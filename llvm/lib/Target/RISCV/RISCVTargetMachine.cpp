//===-- RISCVTargetMachine.cpp - Define TargetMachine for RISC-V ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Implements the info about RISC-V target spec.
//
//===----------------------------------------------------------------------===//

#include "RISCVTargetMachine.h"
#include "RISCVInstrInfo.h"
#include "MCTargetDesc/RISCVBaseInfo.h"
#include "RISCV.h"
#include "RISCVMachineFunctionInfo.h"
#include "RISCVMachineScheduler.h"
#include "RISCVTargetObjectFile.h"
#include "RISCVTargetTransformInfo.h"
#include "TargetInfo/RISCVTargetInfo.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/GlobalISel/CSEInfo.h"
#include "llvm/CodeGen/GlobalISel/IRTranslator.h"
#include "llvm/CodeGen/GlobalISel/InstructionSelect.h"
#include "llvm/CodeGen/GlobalISel/Legalizer.h"
#include "llvm/CodeGen/GlobalISel/RegBankSelect.h"
#include "llvm/CodeGen/MIRParser/MIParser.h"
#include "llvm/CodeGen/MIRYamlMapping.h"
#include "llvm/CodeGen/MachineScheduler.h"
#include "llvm/CodeGen/MacroFusion.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/RegAllocRegistry.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/InitializePasses.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/Transforms/IPO.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Analysis/AssumptionCache.h"
#include "llvm/Analysis/DependenceAnalysis.h"
#include "llvm/Analysis/IVDescriptors.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/Transforms/Scalar/EarlyCSE.h"
#include "llvm/Transforms/Scalar/GVN.h"
#include "llvm/Transforms/Utils/LCSSA.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "llvm/Transforms/Utils/UnrollLoop.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/Transforms/Scalar/IndVarSimplify.h"
#include "llvm/Transforms/Scalar/LoopFuse.h"
#include "llvm/Transforms/Scalar/LoopPassManager.h"
#include "llvm/Transforms/Utils/LoopSimplify.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Vectorize/LoopIdiomVectorize.h"
#include <optional>
using namespace llvm;

static cl::opt<bool> EnableRedundantCopyElimination(
    "riscv-enable-copyelim",
    cl::desc("Enable the redundant copy elimination pass"), cl::init(true),
    cl::Hidden);

// FIXME: Unify control over GlobalMerge.
static cl::opt<cl::boolOrDefault>
    EnableGlobalMerge("riscv-enable-global-merge", cl::Hidden,
                      cl::desc("Enable the global merge pass"));

static cl::opt<bool>
    EnableMachineCombiner("riscv-enable-machine-combiner",
                          cl::desc("Enable the machine combiner pass"),
                          cl::init(true), cl::Hidden);

static cl::opt<unsigned> RVVVectorBitsMaxOpt(
    "riscv-v-vector-bits-max",
    cl::desc("Assume V extension vector registers are at most this big, "
             "with zero meaning no maximum size is assumed."),
    cl::init(0), cl::Hidden);

static cl::opt<int> RVVVectorBitsMinOpt(
    "riscv-v-vector-bits-min",
    cl::desc("Assume V extension vector registers are at least this big, "
             "with zero meaning no minimum size is assumed. A value of -1 "
             "means use Zvl*b extension. This is primarily used to enable "
             "autovectorization with fixed width vectors."),
    cl::init(-1), cl::Hidden);

static cl::opt<bool> EnableRISCVCopyPropagation(
    "riscv-enable-copy-propagation",
    cl::desc("Enable the copy propagation with RISC-V copy instr"),
    cl::init(true), cl::Hidden);

static cl::opt<bool> EnableRISCVDeadRegisterElimination(
    "riscv-enable-dead-defs", cl::Hidden,
    cl::desc("Enable the pass that removes dead"
             " definitions and replaces stores to"
             " them with stores to x0"),
    cl::init(true));

static cl::opt<bool>
    EnableSinkFold("riscv-enable-sink-fold",
                   cl::desc("Enable sinking and folding of instruction copies"),
                   cl::init(true), cl::Hidden);

static cl::opt<bool>
    EnableLoopDataPrefetch("riscv-enable-loop-data-prefetch", cl::Hidden,
                           cl::desc("Enable the loop data prefetch pass"),
                           cl::init(true));

static cl::opt<bool> DisableVectorMaskMutation(
    "riscv-disable-vector-mask-mutation",
    cl::desc("Disable the vector mask scheduling mutation"), cl::init(false),
    cl::Hidden);

static cl::opt<bool>
    EnableMachinePipeliner("riscv-enable-pipeliner",
                           cl::desc("Enable Machine Pipeliner for RISC-V"),
                           cl::init(false), cl::Hidden);

static cl::opt<bool> EnableCFIInstrInserter(
    "riscv-enable-cfi-instr-inserter",
    cl::desc("Enable CFI Instruction Inserter for RISC-V"), cl::init(false),
    cl::Hidden);

extern "C" LLVM_ABI LLVM_EXTERNAL_VISIBILITY void LLVMInitializeRISCVTarget() {
  RegisterTargetMachine<RISCVTargetMachine> X(getTheRISCV32Target());
  RegisterTargetMachine<RISCVTargetMachine> Y(getTheRISCV64Target());
  RegisterTargetMachine<RISCVTargetMachine> A(getTheRISCV32beTarget());
  RegisterTargetMachine<RISCVTargetMachine> B(getTheRISCV64beTarget());
  auto *PR = PassRegistry::getPassRegistry();
  initializeGlobalISel(*PR);
  initializeRISCVO0PreLegalizerCombinerPass(*PR);
  initializeRISCVPreLegalizerCombinerPass(*PR);
  initializeRISCVPostLegalizerCombinerPass(*PR);
  initializeKCFIPass(*PR);
  initializeRISCVDeadRegisterDefinitionsPass(*PR);
  initializeRISCVLateBranchOptPass(*PR);
  initializeRISCVMakeCompressibleOptPass(*PR);
  initializeRISCVGatherScatterLoweringPass(*PR);
  initializeRISCVCodeGenPrepareLegacyPassPass(*PR);
  initializeRISCVPostRAExpandPseudoPass(*PR);
  initializeRISCVMergeBaseOffsetOptPass(*PR);
  initializeRISCVOptWInstrsPass(*PR);
  initializeRISCVFoldMemOffsetPass(*PR);
  initializeRISCVPreRAExpandPseudoPass(*PR);
  initializeRISCVExpandPseudoPass(*PR);
  initializeRISCVVectorPeepholePass(*PR);
  initializeRISCVVLOptimizerPass(*PR);
  initializeRISCVVMV0EliminationPass(*PR);
  initializeRISCVInsertVSETVLIPass(*PR);
  initializeRISCVInsertReadWriteCSRPass(*PR);
  initializeRISCVInsertWriteVXRMPass(*PR);
  initializeRISCVDAGToDAGISelLegacyPass(*PR);
  initializeRISCVMoveMergePass(*PR);
  initializeRISCVPushPopOptPass(*PR);
  initializeRISCVIndirectBranchTrackingPass(*PR);
  initializeRISCVLoadStoreOptPass(*PR);
  initializeRISCVPreAllocZilsdOptPass(*PR);
  initializeRISCVExpandAtomicPseudoPass(*PR);
  initializeRISCVRedundantCopyEliminationPass(*PR);
  initializeRISCVAsmPrinterPass(*PR);
  initializeRISCVPromoteConstantPass(*PR);
}

static Reloc::Model getEffectiveRelocModel(std::optional<Reloc::Model> RM) {
  return RM.value_or(Reloc::Static);
}

static std::unique_ptr<TargetLoweringObjectFile> createTLOF(const Triple &TT) {
  if (TT.isOSBinFormatMachO())
    return std::make_unique<RISCVMachOTargetObjectFile>();
  return std::make_unique<RISCVELFTargetObjectFile>();
}

RISCVTargetMachine::RISCVTargetMachine(const Target &T, const Triple &TT,
                                       StringRef CPU, StringRef FS,
                                       const TargetOptions &Options,
                                       std::optional<Reloc::Model> RM,
                                       std::optional<CodeModel::Model> CM,
                                       CodeGenOptLevel OL, bool JIT)
    : CodeGenTargetMachineImpl(
          T, TT.computeDataLayout(Options.MCOptions.getABIName()), TT, CPU, FS,
          Options, getEffectiveRelocModel(RM),
          getEffectiveCodeModel(CM, CodeModel::Small), OL),
      TLOF(createTLOF(TT)) {
  initAsmInfo();

  // RISC-V supports the MachineOutliner.
  setMachineOutliner(true);
  setSupportsDefaultOutlining(true);

  // RISC-V supports the debug entry values.
  setSupportsDebugEntryValues(true);

  if (TT.isOSFuchsia() && !TT.isArch64Bit())
    report_fatal_error("Fuchsia is only supported for 64-bit");

  setCFIFixup(!EnableCFIInstrInserter);
}

const RISCVSubtarget *
RISCVTargetMachine::getSubtargetImpl(const Function &F) const {
  Attribute CPUAttr = F.getFnAttribute("target-cpu");
  Attribute TuneAttr = F.getFnAttribute("tune-cpu");
  Attribute FSAttr = F.getFnAttribute("target-features");

  std::string CPU =
      CPUAttr.isValid() ? CPUAttr.getValueAsString().str() : TargetCPU;
  std::string TuneCPU =
      TuneAttr.isValid() ? TuneAttr.getValueAsString().str() : CPU;
  std::string FS =
      FSAttr.isValid() ? FSAttr.getValueAsString().str() : TargetFS;

  unsigned RVVBitsMin = RVVVectorBitsMinOpt;
  unsigned RVVBitsMax = RVVVectorBitsMaxOpt;

  Attribute VScaleRangeAttr = F.getFnAttribute(Attribute::VScaleRange);
  if (VScaleRangeAttr.isValid()) {
    if (!RVVVectorBitsMinOpt.getNumOccurrences())
      RVVBitsMin = VScaleRangeAttr.getVScaleRangeMin() * RISCV::RVVBitsPerBlock;
    std::optional<unsigned> VScaleMax = VScaleRangeAttr.getVScaleRangeMax();
    if (VScaleMax.has_value() && !RVVVectorBitsMaxOpt.getNumOccurrences())
      RVVBitsMax = *VScaleMax * RISCV::RVVBitsPerBlock;
  }

  if (RVVBitsMin != -1U) {
    // FIXME: Change to >= 32 when VLEN = 32 is supported.
    assert((RVVBitsMin == 0 || (RVVBitsMin >= 64 && RVVBitsMin <= 65536 &&
                                isPowerOf2_32(RVVBitsMin))) &&
           "V or Zve* extension requires vector length to be in the range of "
           "64 to 65536 and a power 2!");
    assert((RVVBitsMax >= RVVBitsMin || RVVBitsMax == 0) &&
           "Minimum V extension vector length should not be larger than its "
           "maximum!");
  }
  assert((RVVBitsMax == 0 || (RVVBitsMax >= 64 && RVVBitsMax <= 65536 &&
                              isPowerOf2_32(RVVBitsMax))) &&
         "V or Zve* extension requires vector length to be in the range of "
         "64 to 65536 and a power 2!");

  if (RVVBitsMin != -1U) {
    if (RVVBitsMax != 0) {
      RVVBitsMin = std::min(RVVBitsMin, RVVBitsMax);
      RVVBitsMax = std::max(RVVBitsMin, RVVBitsMax);
    }

    RVVBitsMin = llvm::bit_floor(
        (RVVBitsMin < 64 || RVVBitsMin > 65536) ? 0 : RVVBitsMin);
  }
  RVVBitsMax =
      llvm::bit_floor((RVVBitsMax < 64 || RVVBitsMax > 65536) ? 0 : RVVBitsMax);

  SmallString<512> Key;
  raw_svector_ostream(Key) << "RVVMin" << RVVBitsMin << "RVVMax" << RVVBitsMax
                           << CPU << TuneCPU << FS;
  auto &I = SubtargetMap[Key];
  if (!I) {
    // This needs to be done before we create a new subtarget since any
    // creation will depend on the TM and the code generation flags on the
    // function that reside in TargetOptions.
    resetTargetOptions(F);
    auto ABIName = Options.MCOptions.getABIName();
    if (const MDString *ModuleTargetABI = dyn_cast_or_null<MDString>(
            F.getParent()->getModuleFlag("target-abi"))) {
      auto TargetABI = RISCVABI::getTargetABI(ABIName);
      if (TargetABI != RISCVABI::ABI_Unknown &&
          ModuleTargetABI->getString() != ABIName) {
        report_fatal_error("-target-abi option != target-abi module flag");
      }
      ABIName = ModuleTargetABI->getString();
    }
    I = std::make_unique<RISCVSubtarget>(
        TargetTriple, CPU, TuneCPU, FS, ABIName, RVVBitsMin, RVVBitsMax, *this);
  }
  return I.get();
}

MachineFunctionInfo *RISCVTargetMachine::createMachineFunctionInfo(
    BumpPtrAllocator &Allocator, const Function &F,
    const TargetSubtargetInfo *STI) const {
  return RISCVMachineFunctionInfo::create<RISCVMachineFunctionInfo>(
      Allocator, F, static_cast<const RISCVSubtarget *>(STI));
}

TargetTransformInfo
RISCVTargetMachine::getTargetTransformInfo(const Function &F) const {
  return TargetTransformInfo(std::make_unique<RISCVTTIImpl>(this, F));
}

// A RISC-V hart has a single byte-addressable address space of 2^XLEN bytes
// for all memory accesses, so it is reasonable to assume that an
// implementation has no-op address space casts. If an implementation makes a
// change to this, they can override it here.
bool RISCVTargetMachine::isNoopAddrSpaceCast(unsigned SrcAS,
                                             unsigned DstAS) const {
  return true;
}

namespace {
// XRepeat (VRF core): a block load (flw + REPEAT) fills 8 or 16 f registers.
// Without a scheduling model every load has the default latency of 4, so the
// bottom-up scheduler sees a block load as not yet ready when its user is
// placed and fills the gap with other work, typically the previous block's
// MAC, which leaves every block of a straight-line reduction loaded up front
// (four 8-wide blocks are all 32 f registers) and spilled. Hiding load
// latency is never worth a block spill (16 instructions), so the data edges
// out of block loads get latency 1, and register pressure decides the order.
class XRFBlockLoadLatencyMutation : public ScheduleDAGMutation {
public:
  void apply(ScheduleDAGInstrs *DAG) override {
    for (SUnit &SU : DAG->SUnits) {
      const MachineInstr *MI = SU.getInstr();
      if (!MI || !MI->mayLoad() || !RISCV::getXRFRepeatPseudoInfo(MI->getOpcode()))
        continue;
      for (SDep &Succ : SU.Succs) {
        if (Succ.getKind() != SDep::Data || Succ.getLatency() <= 1)
          continue;
        Succ.setLatency(1);
        for (SDep &Pred : Succ.getSUnit()->Preds)
          if (Pred.getSUnit() == &SU && Pred.getKind() == SDep::Data &&
              Pred.getReg() == Succ.getReg())
            Pred.setLatency(1);
        Succ.getSUnit()->setDepthDirty();
      }
      SU.setHeightDirty();
    }
  }
};
} // namespace

ScheduleDAGInstrs *
RISCVTargetMachine::createMachineScheduler(MachineSchedContext *C) const {
  const RISCVSubtarget &ST = C->MF->getSubtarget<RISCVSubtarget>();
  ScheduleDAGMILive *DAG = createSchedLive<RISCVPreRAMachineSchedStrategy>(C);

  if (ST.enableMISchedLoadClustering())
    DAG->addMutation(createLoadClusterDAGMutation(
        DAG->TII, DAG->TRI, /*ReorderWhileClustering=*/true));

  if (ST.enableMISchedStoreClustering())
    DAG->addMutation(createStoreClusterDAGMutation(
        DAG->TII, DAG->TRI, /*ReorderWhileClustering=*/true));

  if (!DisableVectorMaskMutation && ST.hasVInstructions())
    DAG->addMutation(createRISCVVectorMaskDAGMutation(DAG->TRI));

  if (ST.hasXRepeatVRFVectors())
    DAG->addMutation(std::make_unique<XRFBlockLoadLatencyMutation>());

  return DAG;
}

ScheduleDAGInstrs *
RISCVTargetMachine::createPostMachineScheduler(MachineSchedContext *C) const {
  const RISCVSubtarget &ST = C->MF->getSubtarget<RISCVSubtarget>();
  ScheduleDAGMI *DAG = createSchedPostRA(C);

  if (ST.enablePostMISchedLoadClustering())
    DAG->addMutation(createLoadClusterDAGMutation(
        DAG->TII, DAG->TRI, /*ReorderWhileClustering=*/true));

  if (ST.enablePostMISchedStoreClustering())
    DAG->addMutation(createStoreClusterDAGMutation(
        DAG->TII, DAG->TRI, /*ReorderWhileClustering=*/true));

  return DAG;
}

namespace {

class RVVRegisterRegAlloc : public RegisterRegAllocBase<RVVRegisterRegAlloc> {
public:
  RVVRegisterRegAlloc(const char *N, const char *D, FunctionPassCtor C)
      : RegisterRegAllocBase(N, D, C) {}
};

static bool onlyAllocateRVVReg(const TargetRegisterInfo &TRI,
                               const MachineRegisterInfo &MRI,
                               const Register Reg) {
  const TargetRegisterClass *RC = MRI.getRegClass(Reg);
  return RISCVRegisterInfo::isRVVRegClass(RC);
}

static FunctionPass *useDefaultRegisterAllocator() { return nullptr; }

static llvm::once_flag InitializeDefaultRVVRegisterAllocatorFlag;

/// -riscv-rvv-regalloc=<fast|basic|greedy> command line option.
/// This option could designate the rvv register allocator only.
/// For example: -riscv-rvv-regalloc=basic
static cl::opt<RVVRegisterRegAlloc::FunctionPassCtor, false,
               RegisterPassParser<RVVRegisterRegAlloc>>
    RVVRegAlloc("riscv-rvv-regalloc", cl::Hidden,
                cl::init(&useDefaultRegisterAllocator),
                cl::desc("Register allocator to use for RVV register."));

static void initializeDefaultRVVRegisterAllocatorOnce() {
  RegisterRegAlloc::FunctionPassCtor Ctor = RVVRegisterRegAlloc::getDefault();

  if (!Ctor) {
    Ctor = RVVRegAlloc;
    RVVRegisterRegAlloc::setDefault(RVVRegAlloc);
  }
}

static FunctionPass *createBasicRVVRegisterAllocator() {
  return createBasicRegisterAllocator(onlyAllocateRVVReg);
}

static FunctionPass *createGreedyRVVRegisterAllocator() {
  return createGreedyRegisterAllocator(onlyAllocateRVVReg);
}

static FunctionPass *createFastRVVRegisterAllocator() {
  return createFastRegisterAllocator(onlyAllocateRVVReg, false);
}

static RVVRegisterRegAlloc basicRegAllocRVVReg("basic",
                                               "basic register allocator",
                                               createBasicRVVRegisterAllocator);
static RVVRegisterRegAlloc
    greedyRegAllocRVVReg("greedy", "greedy register allocator",
                         createGreedyRVVRegisterAllocator);

static RVVRegisterRegAlloc fastRegAllocRVVReg("fast", "fast register allocator",
                                              createFastRVVRegisterAllocator);

class RISCVPassConfig : public TargetPassConfig {
public:
  RISCVPassConfig(RISCVTargetMachine &TM, PassManagerBase &PM)
      : TargetPassConfig(TM, PM) {
    if (TM.getOptLevel() != CodeGenOptLevel::None)
      substitutePass(&PostRASchedulerID, &PostMachineSchedulerID);
    setEnableSinkAndFold(EnableSinkFold);
    EnableLoopTermFold = true;
  }

  RISCVTargetMachine &getRISCVTargetMachine() const {
    return getTM<RISCVTargetMachine>();
  }

  void addIRPasses() override;
  bool addPreISel() override;
  void addCodeGenPrepare() override;
  bool addInstSelector() override;
  bool addIRTranslator() override;
  void addPreLegalizeMachineIR() override;
  bool addLegalizeMachineIR() override;
  void addPreRegBankSelect() override;
  bool addRegBankSelect() override;
  bool addGlobalInstructionSelect() override;
  void addPreEmitPass() override;
  void addPreEmitPass2() override;
  void addPreSched2() override;
  void addMachineSSAOptimization() override;
  FunctionPass *createRVVRegAllocPass(bool Optimized);
  bool addRegAssignAndRewriteFast() override;
  bool addRegAssignAndRewriteOptimized() override;
  void addPreRegAlloc() override;
  void addPostRegAlloc() override;
  void addFastRegAlloc() override;
  bool addILPOpts() override;

  std::unique_ptr<CSEConfigBase> getCSEConfig() const override;
};
} // namespace

TargetPassConfig *RISCVTargetMachine::createPassConfig(PassManagerBase &PM) {
  return new RISCVPassConfig(*this, PM);
}

std::unique_ptr<CSEConfigBase> RISCVPassConfig::getCSEConfig() const {
  return getStandardCSEConfigForOpt(TM->getOptLevel());
}

FunctionPass *RISCVPassConfig::createRVVRegAllocPass(bool Optimized) {
  // Initialize the global default.
  llvm::call_once(InitializeDefaultRVVRegisterAllocatorFlag,
                  initializeDefaultRVVRegisterAllocatorOnce);

  RegisterRegAlloc::FunctionPassCtor Ctor = RVVRegisterRegAlloc::getDefault();
  if (Ctor != useDefaultRegisterAllocator)
    return Ctor();

  if (Optimized)
    return createGreedyRVVRegisterAllocator();

  return createFastRVVRegisterAllocator();
}

bool RISCVPassConfig::addRegAssignAndRewriteFast() {
  addPass(createRVVRegAllocPass(false));
  addPass(createRISCVInsertVSETVLIPass());
  if (TM->getOptLevel() != CodeGenOptLevel::None &&
      EnableRISCVDeadRegisterElimination)
    addPass(createRISCVDeadRegisterDefinitionsPass());
  return TargetPassConfig::addRegAssignAndRewriteFast();
}

bool RISCVPassConfig::addRegAssignAndRewriteOptimized() {
  addPass(createRVVRegAllocPass(true));
  addPass(createVirtRegRewriter(false));
  addPass(createRISCVInsertVSETVLIPass());
  if (TM->getOptLevel() != CodeGenOptLevel::None &&
      EnableRISCVDeadRegisterElimination)
    addPass(createRISCVDeadRegisterDefinitionsPass());
  return TargetPassConfig::addRegAssignAndRewriteOptimized();
}

void RISCVPassConfig::addIRPasses() {
  addPass(createAtomicExpandLegacyPass());
  addPass(createRISCVZacasABIFixPass());

  if (getOptLevel() != CodeGenOptLevel::None) {
    if (EnableLoopDataPrefetch)
      addPass(createLoopDataPrefetchPass());

    addPass(createRISCVGatherScatterLoweringPass());
    addPass(createInterleavedAccessPass());
    addPass(createRISCVCodeGenPrepareLegacyPass());
  }

  TargetPassConfig::addIRPasses();
}

bool RISCVPassConfig::addPreISel() {
  if (TM->getOptLevel() != CodeGenOptLevel::None)
    addPass(createRISCVPromoteConstantPass());
  if (TM->getOptLevel() != CodeGenOptLevel::None) {
    // Add a barrier before instruction selection so that we will not get
    // deleted block address after enabling default outlining. See D99707 for
    // more details.
    addPass(createBarrierNoopPass());
  }

  if ((TM->getOptLevel() != CodeGenOptLevel::None &&
       EnableGlobalMerge == cl::BOU_UNSET) ||
      EnableGlobalMerge == cl::BOU_TRUE) {
    // FIXME: Like AArch64, we disable extern global merging by default due to
    // concerns it might regress some workloads. Unlike AArch64, we don't
    // currently support enabling the pass in an "OnlyOptimizeForSize" mode.
    // Investigating and addressing both items are TODO.
    addPass(createGlobalMergePass(TM, /* MaxOffset */ 2047,
                                  /* OnlyOptimizeForSize */ false,
                                  /* MergeExternalByDefault */ true));
  }

  return false;
}

void RISCVPassConfig::addCodeGenPrepare() {
  if (getOptLevel() != CodeGenOptLevel::None)
    addPass(createTypePromotionLegacyPass());
  TargetPassConfig::addCodeGenPrepare();
}

bool RISCVPassConfig::addInstSelector() {
  addPass(createRISCVISelDag(getRISCVTargetMachine(), getOptLevel()));

  return false;
}

bool RISCVPassConfig::addIRTranslator() {
  addPass(new IRTranslator(getOptLevel()));
  return false;
}

void RISCVPassConfig::addPreLegalizeMachineIR() {
  if (getOptLevel() == CodeGenOptLevel::None) {
    addPass(createRISCVO0PreLegalizerCombiner());
  } else {
    addPass(createRISCVPreLegalizerCombiner());
  }
}

bool RISCVPassConfig::addLegalizeMachineIR() {
  addPass(new Legalizer());
  return false;
}

void RISCVPassConfig::addPreRegBankSelect() {
  if (getOptLevel() != CodeGenOptLevel::None)
    addPass(createRISCVPostLegalizerCombiner());
}

bool RISCVPassConfig::addRegBankSelect() {
  addPass(new RegBankSelect());
  return false;
}

bool RISCVPassConfig::addGlobalInstructionSelect() {
  addPass(new InstructionSelect(getOptLevel()));
  return false;
}

void RISCVPassConfig::addPreSched2() {
  addPass(createRISCVPostRAExpandPseudoPass());

  // Emit KCFI checks for indirect calls.
  addPass(createKCFIPass());
  if (TM->getOptLevel() != CodeGenOptLevel::None)
    addPass(createRISCVLoadStoreOptPass());
}

void RISCVPassConfig::addPreEmitPass() {
  // TODO: It would potentially be better to schedule copy propagation after
  // expanding pseudos (in addPreEmitPass2). However, performing copy
  // propagation after the machine outliner (which runs after addPreEmitPass)
  // currently leads to incorrect code-gen, where copies to registers within
  // outlined functions are removed erroneously.
  if (TM->getOptLevel() >= CodeGenOptLevel::Default &&
      EnableRISCVCopyPropagation)
    addPass(createMachineCopyPropagationPass(true));
  if (TM->getOptLevel() >= CodeGenOptLevel::Default)
    addPass(createRISCVLateBranchOptPass());
  // The IndirectBranchTrackingPass inserts lpad and could have changed the
  // basic block alignment. It must be done before Branch Relaxation to
  // prevent the adjusted offset exceeding the branch range.
  addPass(createRISCVIndirectBranchTrackingPass());
  addPass(&BranchRelaxationPassID);
  addPass(createRISCVMakeCompressibleOptPass());
}

void RISCVPassConfig::addPreEmitPass2() {
  if (TM->getOptLevel() != CodeGenOptLevel::None) {
    addPass(createRISCVMoveMergePass());
    // Schedule PushPop Optimization before expansion of Pseudo instruction,
    // ensuring return instruction is detected correctly.
    addPass(createRISCVPushPopOptimizationPass());
  }
  addPass(createRISCVExpandPseudoPass());

  // Schedule the expansion of AMOs at the last possible moment, avoiding the
  // possibility for other passes to break the requirements for forward
  // progress in the LR/SC block.
  addPass(createRISCVExpandAtomicPseudoPass());

  // KCFI indirect call checks are lowered to a bundle.
  addPass(createUnpackMachineBundles([&](const MachineFunction &MF) {
    return MF.getFunction().getParent()->getModuleFlag("kcfi");
  }));

  if (EnableCFIInstrInserter)
    addPass(createCFIInstrInserter());
}

void RISCVPassConfig::addMachineSSAOptimization() {
  addPass(createRISCVVectorPeepholePass());
  addPass(createRISCVFoldMemOffsetPass());

  TargetPassConfig::addMachineSSAOptimization();

  if (TM->getTargetTriple().isRISCV64()) {
    addPass(createRISCVOptWInstrsPass());
  }
}

void RISCVPassConfig::addPreRegAlloc() {
  addPass(createRISCVPreRAExpandPseudoPass());
  if (TM->getOptLevel() != CodeGenOptLevel::None) {
    addPass(createRISCVMergeBaseOffsetOptPass());
    addPass(createRISCVVLOptimizerPass());
    // Add Zilsd pre-allocation load/store optimization
    addPass(createRISCVPreAllocZilsdOptPass());
  }

  addPass(createRISCVInsertReadWriteCSRPass());
  addPass(createRISCVInsertWriteVXRMPass());
  addPass(createRISCVLandingPadSetupPass());

  if (TM->getOptLevel() != CodeGenOptLevel::None && EnableMachinePipeliner)
    addPass(&MachinePipelinerID);

  addPass(createRISCVVMV0EliminationPass());
}

void RISCVPassConfig::addFastRegAlloc() {
  addPass(&InitUndefID);
  TargetPassConfig::addFastRegAlloc();
}


void RISCVPassConfig::addPostRegAlloc() {
  if (TM->getOptLevel() != CodeGenOptLevel::None &&
      EnableRedundantCopyElimination)
    addPass(createRISCVRedundantCopyEliminationPass());
}

bool RISCVPassConfig::addILPOpts() {
  if (EnableMachineCombiner)
    addPass(&MachineCombinerID);

  return true;
}

// Loop attribute RISCVXRepeatUnrollAndJamPass puts on the output loops it
// jams, so that RISCVXRepeatLoopFusionPass leaves those nests alone.
static constexpr const char *XRepeatJammedAttr = "riscv.xrepeat.jammed";

static cl::opt<bool> XRepeatLoopFusion(
    "riscv-xrepeat-loop-fusion",
    cl::desc("XRepeat (VRF core): fuse adjacent loops before the vectorizers"),
    cl::init(true), cl::Hidden);

namespace {
// XRepeat (VRF core): fuse adjacent loops with the same trip count right
// before the vectorizers, then merge their induction variables and the loads
// they share. The early full unroll turns
//   for (u < 4) for (k) acc[u] += A[u][k] * x[k];
// into four k loops that each reload x; fused, one k loop loads each block of
// x once and feeds four MACs (the hand-written dotxvf). Only functions
// compiled for the VRF core are touched.
//
// Only loops that share a load are fused (see worthFusing): that is the gain,
// one load feeding the work of several loops in the same iteration. Fusing
// unrelated loops, or loop nests whose inner loops then share nothing (two
// convolutions with different kernels reading the same image), saves a few
// loop-control instructions but puts their work in one loop body, which can
// push a register-hungry loop nest into spilling (resnet8). LoopFuse itself
// fuses every legal pair, so a pair that shouldn't be fused gets a barrier
// LoopFuse can't move, a volatile load of a dummy stack slot in the second
// loop's preheader, removed afterwards. indvars and GVN only run if something
// was fused.
class RISCVXRepeatLoopFusionPass
    : public PassInfoMixin<RISCVXRepeatLoopFusionPass> {
  const RISCVTargetMachine &TM;

  // The addresses a loop loads from as it iterates: {start, step} of each
  // pointer that advances with L (loads of loop-invariant addresses don't
  // count: LICM handles them either way).
  static SmallVector<std::pair<const SCEV *, const SCEV *>, 8>
  getStridedLoads(Loop *L, ScalarEvolution &SE) {
    SmallVector<std::pair<const SCEV *, const SCEV *>, 8> Res;
    for (BasicBlock *BB : L->blocks())
      for (Instruction &I : *BB)
        if (auto *LI = dyn_cast<LoadInst>(&I))
          if (auto *AR = dyn_cast<SCEVAddRecExpr>(
                  SE.getSCEV(LI->getPointerOperand()));
              AR && AR->getLoop() == L && AR->isAffine())
            Res.push_back({AR->getStart(), AR->getStepRecurrence(SE)});
    return Res;
  }

  using LoopMap = SmallDenseMap<const Loop *, const Loop *, 4>;

  // S0 == S1 once each loop of the second nest is taken as its counterpart
  // in the first (Map: second -> first), i.e. the same address once fused.
  static bool equalModLoops(const SCEV *S0, const SCEV *S1, const LoopMap &Map) {
    if (S0 == S1)
      return true;
    if (S0->getSCEVType() != S1->getSCEVType() ||
        S0->getType() != S1->getType())
      return false;
    if (auto *A0 = dyn_cast<SCEVAddRecExpr>(S0)) {
      auto *A1 = cast<SCEVAddRecExpr>(S1);
      const Loop *L1 = Map.lookup(A1->getLoop());
      if ((L1 ? L1 : A1->getLoop()) != A0->getLoop())
        return false;
    }
    ArrayRef<const SCEV *> Ops0 = S0->operands(), Ops1 = S1->operands();
    if (Ops0.empty() || Ops0.size() != Ops1.size())
      return false;
    for (auto [O0, O1] : zip(Ops0, Ops1))
      if (!equalModLoops(O0, O1, Map))
        return false;
    return true;
  }

  static bool shareALoad(Loop *L0, Loop *L1, ScalarEvolution &SE,
                         const LoopMap &Map) {
    auto Loads0 = getStridedLoads(L0, SE);
    for (auto &[Start1, Step1] : getStridedLoads(L1, SE))
      for (auto &[Start0, Step0] : Loads0)
        if (equalModLoops(Start0, Start1, Map) &&
            equalModLoops(Step0, Step1, Map))
          return true;
    return false;
  }

  // Worth fusing: two innermost loops that share a load, or two loop nests of
  // the same shape (one subloop per level) whose innermost loops do, once
  // each loop of the second nest is matched with its counterpart in the first
  // (so that, the nests fused, their inner loops fuse too: e.g. the Q, K and V
  // projections of bert_tiny, three dense layers reading the same input).
  static bool worthFusing(Loop *L0, Loop *L1, ScalarEvolution &SE,
                          LoopMap &Map) {
    Map[L1] = L0;
    if (L0->isInnermost() && L1->isInnermost())
      return shareALoad(L0, L1, SE, Map);
    if (L0->getSubLoops().size() != 1 || L1->getSubLoops().size() != 1)
      return false;
    return worthFusing(L0->getSubLoops()[0], L1->getSubLoops()[0], SE, Map);
  }

  // L is, contains or is inside an output loop unroll-and-jammed by
  // RISCVXRepeatUnrollAndJamPass, which runs first. Such a nest isn't fused
  // with anything: its inner loops already feed every load to 8 or 16
  // outputs, and fusing two of them (bert_tiny's Q, K and V projections)
  // would put 32 or 48 accumulators in one loop.
  static bool inJammedNest(const Loop *L) {
    for (const Loop *P = L; P; P = P->getParentLoop())
      if (getBooleanLoopAttribute(P, XRepeatJammedAttr))
        return true;
    for (const Loop *Sub : L->getLoopsInPreorder())
      if (getBooleanLoopAttribute(Sub, XRepeatJammedAttr))
        return true;
    return false;
  }

public:
  RISCVXRepeatLoopFusionPass(const RISCVTargetMachine &TM) : TM(TM) {}
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    if (!XRepeatLoopFusion ||
        !TM.getSubtarget<RISCVSubtarget>(F).hasXRepeatVRFVectors())
      return PreservedAnalyses::all();

    // Each loop and the sibling right before it (the last one, in dominance
    // order, among the siblings that dominate it): a barrier where they share
    // no load. Loop-simplify form first, as LoopFuse makes it, so that every
    // loop has the preheader LoopFuse will check.
    FAM.invalidate(F, LoopSimplifyPass().run(F, FAM));
    auto &LI = FAM.getResult<LoopAnalysis>(F);
    auto &SE = FAM.getResult<ScalarEvolutionAnalysis>(F);
    auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);
    SmallVector<Instruction *, 8> Barriers;
    AllocaInst *Slot = nullptr;
    SmallVector<Loop *, 16> Worklist(LI.begin(), LI.end());
    for (unsigned I = 0; I < Worklist.size(); ++I) {
      Loop *L = Worklist[I];
      ArrayRef<Loop *> Siblings =
          L->getParentLoop() ? ArrayRef<Loop *>(L->getParentLoop()->getSubLoops())
                             : ArrayRef<Loop *>(LI.getTopLevelLoops());
      append_range(Worklist, L->getSubLoops());
      BasicBlock *Preheader = L->getLoopPreheader();
      if (!Preheader)
        continue;
      Loop *Prev = nullptr;
      for (Loop *S : Siblings)
        if (S != L && DT.dominates(S->getHeader(), L->getHeader()) &&
            (!Prev || DT.dominates(Prev->getHeader(), S->getHeader())))
          Prev = S;
      LoopMap Map;
      if (!Prev || (!inJammedNest(Prev) && !inJammedNest(L) &&
                    worthFusing(Prev, L, SE, Map)))
        continue;
      if (!Slot)
        Slot = new AllocaInst(Type::getInt8Ty(F.getContext()), 0, "",
                              F.getEntryBlock().getFirstInsertionPt());
      IRBuilder<> B(Preheader->getTerminator());
      Barriers.push_back(B.CreateLoad(B.getInt8Ty(), Slot, /*isVolatile=*/true));
    }
    if (!Barriers.empty())
      FAM.invalidate(F, PreservedAnalyses::allInSet<CFGAnalyses>());

    // Fuse; clean up (one induction variable, one load of each shared address)
    // only if loops were fused: run on unfused code, GVN's load PRE and CSE
    // across loops lengthen live ranges for nothing (resnet8 spills more).
    unsigned LoopsBefore = LI.getLoopsInPreorder().size();
    PreservedAnalyses PA = LoopFusePass().run(F, FAM);
    FAM.invalidate(F, PA);
    if (FAM.getResult<LoopAnalysis>(F).getLoopsInPreorder().size() <
        LoopsBefore) {
      FunctionPassManager FPM;
      FPM.addPass(createFunctionToLoopPassAdaptor(IndVarSimplifyPass(),
                                                  /*UseMemorySSA=*/true));
      FPM.addPass(GVNPass());
      PA.intersect(FPM.run(F, FAM));
    }

    if (!Barriers.empty()) {
      for (Instruction *Barrier : Barriers)
        Barrier->eraseFromParent();
      Slot->eraseFromParent();
      PA = PreservedAnalyses::none();
    }
    return PA;
  }
};
} // namespace

static cl::opt<bool> XRepeatFMinMax(
    "riscv-xrepeat-fminmax",
    cl::desc("XRepeat (VRF core): turn float selects that are exactly a "
             "min/max with a constant into minimumnum/maximumnum"),
    cl::init(true), cl::Hidden);

namespace {
// XRepeat (VRF core): fmin.s/fmax.s repeat, but a clamp or ReLU written as a
// compare and a select (x > C ? x : C) reaches the vectorizers as a select,
// which they can't turn into a burst. Replace the selects that are a min/max
// of a value and a constant with llvm.minimumnum/maximumnum (see
// RISCV::getXRepeatFMinMax for when they are).
class RISCVXRepeatFMinMaxPass : public PassInfoMixin<RISCVXRepeatFMinMaxPass> {
  const RISCVTargetMachine &TM;

public:
  RISCVXRepeatFMinMaxPass(const RISCVTargetMachine &TM) : TM(TM) {}
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    if (!XRepeatFMinMax ||
        !TM.getSubtarget<RISCVSubtarget>(F).hasXRepeatVRFVectors())
      return PreservedAnalyses::all();
    bool Changed = false;
    for (Instruction &I : make_early_inc_range(instructions(F))) {
      auto *SI = dyn_cast<SelectInst>(&I);
      Value *V;
      Constant *C;
      if (!SI)
        continue;
      Intrinsic::ID ID = RISCV::getXRepeatFMinMax(*SI, V, C);
      if (ID == Intrinsic::not_intrinsic)
        continue;
      IRBuilder<> B(SI);
      Value *MinMax = B.CreateBinaryIntrinsic(ID, V, C, nullptr, SI->getName());
      SI->replaceAllUsesWith(MinMax);
      Value *Cond = SI->getCondition();
      SI->eraseFromParent();
      RecursivelyDeleteTriviallyDeadInstructions(Cond);
      Changed = true;
    }
    if (!Changed)
      return PreservedAnalyses::all();
    PreservedAnalyses PA;
    PA.preserveSet<CFGAnalyses>();
    return PA;
  }
};
} // namespace

namespace {
enum class XRepeatUJMode { Off, Row, Column };
} // namespace

static cl::opt<XRepeatUJMode> XRepeatUnrollJam(
    "riscv-xrepeat-unroll-jam",
    cl::desc("XRepeat (VRF core): unroll-and-jam the outputs of a float "
             "reduction nest (matrix-vector product)"),
    cl::init(XRepeatUJMode::Column),
    cl::values(
        clEnumValN(XRepeatUJMode::Off, "off", "don't"),
        clEnumValN(XRepeatUJMode::Row, "row",
                   "the loop vectorizer vectorizes the jammed inner loop: one "
                   "in-order reduction burst per output (the hand-written "
                   "kernels' layout)"),
        clEnumValN(XRepeatUJMode::Column, "column",
                   "SLP vectorizes across the jammed outputs: each lane is "
                   "one output, the weights are loaded by column")),
    cl::Hidden);

static cl::opt<unsigned> XRepeatUnrollJamCount(
    "riscv-xrepeat-unroll-jam-count",
    cl::desc("XRepeat (VRF core): outputs jammed by -riscv-xrepeat-unroll-jam "
             "(0: 16, or 8 if the output count isn't a multiple of 16, in "
             "column mode; 4 in row mode)"),
    cl::init(0), cl::Hidden);

namespace {
// XRepeat (VRF core): unroll-and-jam the output loop of a matrix-vector
// product,
//   for (o) { acc = b[o]; for (i) acc += x[i] * w[o][i]; out[o] = f(acc); }
// by N: the inner loop then carries N accumulators, w[o+0..N-1][i] and one
// x[i].
//
// An in-order float reduction can only become a serial burst (fmadd.s + REPEAT
// mask 0110, each element waiting for the previous one's FMA), and that is
// what the loop vectorizer makes of the inner loop on its own. Jammed, the
// inner loop is instead marked as already vectorized so that SLP vectorizes
// across the accumulators ("column"): per i, one 8-lane fmadd.s burst for
// each 8 outputs, its lanes independent (mask 1101), w[o..o+7][i] one strided
// block load, x[i] a scalar; each lane still adds its products in source
// order, so the result is the scalar code's bit for bit. N = 16 (two bursts
// per x[i], 16 accumulators in two blocks plus one block for the weights).
//
// "row" leaves the jammed loop to the loop vectorizer: one serial burst per
// output sharing each block of x, like the hand-written kernels. N = 4: the
// vectorizer counts x and every row as live blocks (see getNumberOfRegisters)
// and rejects more than five.
//
// A convolution, once its kernel loops are fully unrolled, has a sequence of
// such inner loops instead of one, the accumulator flowing from each into the
// next:
//   for (c) { acc = b[c]; for (i) acc += ...; for (i) acc += ...; ...;
//             out[c] = f(acc); }
// LLVM's unroll-and-jam only handles one inner loop, so such a nest is jammed
// here (jamSequence): every inner loop gets the N accumulators, each lane still
// in source order.
//
// Only nests where this is the whole story are touched: inner loops with one
// float fadd/fmuladd reduction each, no stores, and loads that are either
// invariant in the output loop (x) or step by a constant with it (w's rows),
// an output loop with a constant trip count that is a multiple of the count
// and nothing but the inner loop(s) inside it.
class RISCVXRepeatUnrollAndJamPass
    : public PassInfoMixin<RISCVXRepeatUnrollAndJamPass> {
  const RISCVTargetMachine &TM;

  // An inner loop of a candidate nest: one float fadd/fmuladd reduction, the
  // other header phis inductions, no stores or calls, loads as above.
  static bool isJammableInner(Loop *Sub, Loop *L, ScalarEvolution &SE) {
    if (!Sub->isInnermost() || !Sub->isLoopSimplifyForm())
      return false;
    unsigned NumRed = 0;
    for (PHINode &Phi : Sub->getHeader()->phis()) {
      RecurrenceDescriptor RD;
      if (RecurrenceDescriptor::isReductionPHI(&Phi, Sub, RD, nullptr, nullptr,
                                               nullptr, &SE)) {
        RecurKind K = RD.getRecurrenceKind();
        if (!Phi.getType()->isFloatTy() ||
            (K != RecurKind::FAdd && K != RecurKind::FMulAdd))
          return false;
        ++NumRed;
      } else if (!SE.isSCEVable(Phi.getType()) ||
                 !isa<SCEVAddRecExpr>(SE.getSCEV(&Phi))) {
        return false;
      }
    }
    if (NumRed != 1)
      return false;

    for (BasicBlock *BB : Sub->blocks())
      for (Instruction &I : *BB) {
        if (I.mayWriteToMemory() ||
            (isa<CallBase>(I) && !isa<IntrinsicInst>(I)))
          return false;
        auto *LI = dyn_cast<LoadInst>(&I);
        if (!LI)
          continue;
        if (!LI->isSimple())
          return false;
        const SCEV *Ptr = SE.getSCEV(LI->getPointerOperand());
        auto *AR = dyn_cast<SCEVAddRecExpr>(Ptr);
        if (!AR || AR->getLoop() != Sub || !AR->isAffine())
          return false;
        const SCEV *Start = AR->getStart();
        if (SE.isLoopInvariant(Start, L))
          continue;
        auto *ARL = dyn_cast<SCEVAddRecExpr>(Start);
        if (!ARL || ARL->getLoop() != L || !ARL->isAffine() ||
            !isa<SCEVConstant>(ARL->getStepRecurrence(SE)))
          return false;
      }
    return SE.isLoopInvariant(SE.getBackedgeTakenCount(Sub), L);
  }

  // The shape jamSequence handles: L's body is a chain of single blocks and
  // single-block inner loops,
  //   Header -> Sub1 -> Seg1 -> Sub2 -> ... -> SubM -> SegM (the latch),
  // every header phi of L an induction with a constant step, nothing defined
  // in L used outside it, and memory that the jam may reorder: stores only in
  // the latch block, to identified objects that nothing in L loads from (the
  // jam moves the loads of copies 1..N-1 above the stores of copy 0, and
  // keeps the stores in order).
  static bool getSequence(Loop *L, ScalarEvolution &SE,
                          SmallVectorImpl<BasicBlock *> &Segs,
                          SmallVectorImpl<Loop *> &Subs) {
    BasicBlock *Latch = L->getLoopLatch();
    BasicBlock *BB = L->getHeader();
    Segs.push_back(BB);
    while (BB != Latch) {
      auto *Br = dyn_cast<BranchInst>(BB->getTerminator());
      if (!Br || Br->isConditional())
        return false;
      BasicBlock *Next = Br->getSuccessor(0);
      auto It = find_if(L->getSubLoops(),
                        [&](Loop *S) { return S->getHeader() == Next; });
      if (It == L->getSubLoops().end())
        return false;
      Loop *Sub = *It;
      BasicBlock *Exit = Sub->getExitBlock();
      if (Sub->getNumBlocks() != 1 || Sub->getHeader() != Next || !Exit ||
          Exit->getSinglePredecessor() != Next)
        return false;
      Subs.push_back(Sub);
      Segs.push_back(BB = Exit);
    }
    if (Segs.size() + Subs.size() != L->getNumBlocks())
      return false;

    for (PHINode &Phi : L->getHeader()->phis()) {
      auto *AR = dyn_cast<SCEVAddRecExpr>(
          SE.isSCEVable(Phi.getType()) ? SE.getSCEV(&Phi)
                                       : SE.getCouldNotCompute());
      if (!AR || AR->getLoop() != L || !AR->isAffine() ||
          !isa<SCEVConstant>(AR->getStepRecurrence(SE)) ||
          !(Phi.getType()->isIntegerTy() || Phi.getType()->isPointerTy()))
        return false;
    }

    SmallVector<const Value *, 8> StoreObjs, LoadObjs;
    for (BasicBlock *B : L->blocks())
      for (Instruction &I : *B) {
        for (User *U : I.users())
          if (!L->contains(cast<Instruction>(U)))
            return false;
        if (auto *St = dyn_cast<StoreInst>(&I)) {
          if (B != Latch || !St->isSimple())
            return false;
          StoreObjs.push_back(getUnderlyingObject(St->getPointerOperand()));
        } else if (auto *Ld = dyn_cast<LoadInst>(&I)) {
          if (!Ld->isSimple())
            return false;
          LoadObjs.push_back(getUnderlyingObject(Ld->getPointerOperand()));
        } else if (I.mayHaveSideEffects() || I.mayReadOrWriteMemory()) {
          return false;
        }
      }
    for (const Value *SObj : StoreObjs) {
      if (!isIdentifiedObject(SObj))
        return false;
      for (const Value *LObj : LoadObjs)
        if (LObj == SObj || !isIdentifiedObject(LObj))
          return false;
    }
    return true;
  }

  // An innermost output loop that computes a whole dot product per iteration,
  // its reduction loop fully unrolled (resnet8's first convolution, 27 MACs
  // per output):
  //   for (c) out[c] = f(b[c] + w[c][0] * x0 + w[c][1] * x1 + ...);
  // one block, a chain of float fmuladds, no float phis (nothing carried from
  // one output to the next), loads invariant in L (x) or stepping by a
  // constant with it (w's rows). Cloned for N outputs (jamSequence with no
  // inner loop), SLP vectorizes across them like a jammed nest. Column mode
  // only: the loop vectorizer would see the same loop again in row mode.
  static bool isDotPerIteration(Loop *L, ScalarEvolution &SE) {
    if (L->getNumBlocks() != 1)
      return false;
    for (PHINode &Phi : L->getHeader()->phis())
      if (!Phi.getType()->isIntegerTy() && !Phi.getType()->isPointerTy())
        return false;
    unsigned Chain = 0;
    for (Instruction &I : *L->getHeader()) {
      if (auto *II = dyn_cast<IntrinsicInst>(&I);
          II && II->getIntrinsicID() == Intrinsic::fmuladd &&
          II->getType()->isFloatTy())
        if (auto *Acc = dyn_cast<IntrinsicInst>(II->getArgOperand(2));
            Acc && Acc->getIntrinsicID() == Intrinsic::fmuladd)
          ++Chain;
      auto *LI = dyn_cast<LoadInst>(&I);
      if (!LI)
        continue;
      const SCEV *Ptr = SE.getSCEV(LI->getPointerOperand());
      if (SE.isLoopInvariant(Ptr, L))
        continue;
      auto *AR = dyn_cast<SCEVAddRecExpr>(Ptr);
      if (!AR || AR->getLoop() != L || !AR->isAffine() ||
          !isa<SCEVConstant>(AR->getStepRecurrence(SE)))
        return false;
    }
    // A dot product of a handful of elements, not an elementwise loop.
    return Chain >= 4;
  }

  // The number of outputs to jam for L, or 0 if L isn't a candidate.
  static unsigned getCount(Loop *L, ScalarEvolution &SE) {
    if (!L->isLoopSimplifyForm() || !L->getExitBlock())
      return 0;
    if (L->isInnermost() && (XRepeatUnrollJam != XRepeatUJMode::Column ||
                             !isDotPerIteration(L, SE)))
      return 0;
    unsigned TC = SE.getSmallConstantTripCount(L);
    SmallVector<unsigned, 2> Counts;
    if (XRepeatUnrollJamCount)
      Counts.push_back(XRepeatUnrollJamCount);
    else if (L->isInnermost())
      // One vector of outputs: the dot product's invariant operands (its
      // other vector, hoisted) already take most of the F registers.
      Counts.push_back(8);
    else if (XRepeatUnrollJam == XRepeatUJMode::Row)
      Counts.push_back(4);
    else
      Counts.append({16, 8});
    // An innermost output loop keeps at least two iterations: run out by the
    // jam, its weight loads would no longer depend on any loop around them,
    // and LICM would hoist every weight block of the dot product out of the
    // pixel loops, where they can't all stay in registers.
    for (unsigned C : Counts)
      if (C >= 2 && TC >= C && TC % C == 0 &&
          (!L->isInnermost() || XRepeatUnrollJamCount || TC > C)) {
        for (Loop *Sub : L->getSubLoops())
          if (!isJammableInner(Sub, L, SE))
            return 0;
        return C;
      }
    return 0;
  }

  // Unroll L by N and jam every copy into the same blocks: in each block of
  // the chain (see getSequence), copies 1..N-1 of its instructions follow the
  // original's; each inner loop gets copies of its reduction phi and body
  // (its induction is shared); the header phis step N times as far, and the
  // loop exits where copy N-1 would have. Nothing but instructions changes:
  // the blocks, the loops and the dominator tree stay as they are.
  static void jamSequence(Loop *L, unsigned N, ArrayRef<BasicBlock *> Segs,
                          ArrayRef<Loop *> Subs, ScalarEvolution &SE) {
    std::vector<std::unique_ptr<ValueToValueMapTy>> VMapStore;
    for (unsigned J = 0; J < N; ++J)
      VMapStore.push_back(std::make_unique<ValueToValueMapTy>());
    auto VMap = [&](unsigned J) -> ValueToValueMapTy & { return *VMapStore[J]; };
    auto Remap = [](Instruction *I, ValueToValueMapTy &VM) {
      RemapInstruction(I, VM,
                       RF_IgnoreMissingLocals | RF_NoModuleLevelChanges);
    };
    // The non-phi instructions of BB but the terminator.
    auto BodyOf = [](BasicBlock *BB) {
      SmallVector<Instruction *, 32> Orig;
      for (Instruction &I : *BB)
        if (!isa<PHINode>(I) && !I.isTerminator())
          Orig.push_back(&I);
      return Orig;
    };
    // Clone them for each copy, after the original ones.
    auto CloneBody = [&](BasicBlock *BB, ArrayRef<Instruction *> Orig) {
      for (unsigned J = 1; J < N; ++J)
        for (Instruction *I : Orig) {
          Instruction *C = I->clone();
          C->insertBefore(BB->getTerminator()->getIterator());
          if (I->hasName())
            C->setName(I->getName() + ".jam" + Twine(J));
          VMap(J)[I] = C;
          Remap(C, VMap(J));
        }
    };
    // Copy J of V (V itself if it's the same in every copy).
    auto Map = [&](unsigned J, Value *V) {
      Value *C = VMap(J).lookup(V);
      return C ? C : V;
    };

    // No inner loop: the end of the per-output fmuladd chain (see
    // isDotPerIteration), vectorized across the copies below.
    BasicBlock *Header = L->getHeader();
    Instruction *DotEnd = nullptr;
    if (Subs.empty())
      DotEnd = getDotEnd(Header);

    // Copy J of a header phi: the phi plus J steps.
    SmallVector<Instruction *, 32> HeaderOrig = BodyOf(Header);
    IRBuilder<> B(&*Header->getFirstInsertionPt());
    SmallVector<PHINode *, 4> HeaderPhis;
    for (PHINode &Phi : Header->phis()) {
      HeaderPhis.push_back(&Phi);
      auto *AR = cast<SCEVAddRecExpr>(SE.getSCEV(&Phi));
      const APInt &Step =
          cast<SCEVConstant>(AR->getStepRecurrence(SE))->getAPInt();
      for (unsigned J = 1; J < N; ++J)
        VMap(J)[&Phi] =
            Phi.getType()->isPointerTy()
                ? B.CreatePtrAdd(&Phi, B.getInt(Step * J))
                : B.CreateAdd(&Phi, ConstantInt::get(Phi.getType(), Step * J));
    }
    CloneBody(Header, HeaderOrig);

    for (auto [K, Sub] : enumerate(Subs)) {
      BasicBlock *Body = Sub->getHeader();
      BasicBlock *Pre = Sub->getLoopPreheader();
      // The reduction phi gets a copy per output; the induction is shared.
      SmallVector<std::pair<PHINode *, SmallVector<PHINode *, 16>>, 2> Reds;
      SmallVector<PHINode *, 4> BodyPhis;
      for (PHINode &Phi : Body->phis())
        if (Phi.getType()->isFloatTy())
          BodyPhis.push_back(&Phi);
      for (PHINode *PhiP : BodyPhis) {
        PHINode &Phi = *PhiP;
        SmallVector<PHINode *, 16> Copies(N, nullptr);
        for (unsigned J = 1; J < N; ++J) {
          Copies[J] = PHINode::Create(Phi.getType(), 2,
                                      Phi.getName() + ".jam" + Twine(J));
          Copies[J]->insertBefore(Body->getFirstNonPHIIt());
          VMap(J)[&Phi] = Copies[J];
        }
        Reds.push_back({&Phi, std::move(Copies)});
      }
      CloneBody(Body, BodyOf(Body));
      for (auto &[Phi, Copies] : Reds)
        for (unsigned J = 1; J < N; ++J) {
          Value *Init = Phi->getIncomingValueForBlock(Pre);
          Value *Next = Phi->getIncomingValueForBlock(Body);
          Copies[J]->addIncoming(Map(J, Init), Pre);
          Copies[J]->addIncoming(Map(J, Next), Body);
        }

      // The block after the loop: its phis (LCSSA) and instructions.
      BasicBlock *Seg = Segs[K + 1];
      SmallVector<PHINode *, 4> SegPhis;
      for (PHINode &Phi : Seg->phis())
        SegPhis.push_back(&Phi);
      for (PHINode *Phi : SegPhis)
        for (unsigned J = 1; J < N; ++J) {
          PHINode *C = cast<PHINode>(Phi->clone());
          C->insertBefore(Seg->getFirstNonPHIIt());
          C->setName(Phi->getName() + ".jam" + Twine(J));
          VMap(J)[Phi] = C;
          Remap(C, VMap(J));
        }
      CloneBody(Seg, BodyOf(Seg));
    }

    // Step N times as far, and exit where copy N-1 would have.
    BasicBlock *Latch = L->getLoopLatch();
    for (PHINode *Phi : HeaderPhis) {
      Value *Next = Phi->getIncomingValueForBlock(Latch);
      Phi->setIncomingValueForBlock(Latch, Map(N - 1, Next));
    }
    auto *Br = cast<BranchInst>(Latch->getTerminator());
    Br->setCondition(Map(N - 1, Br->getCondition()));

    if (DotEnd) {
      SmallVector<Instruction *, 16> Ends;
      for (unsigned J = 0; J < N; ++J)
        Ends.push_back(cast<Instruction>(Map(J, DotEnd)));
      vectorizeDots(Header, Ends, SE);
    }
  }

  // The fmuladd ending the (only) float fmuladd chain of BB: the one that
  // isn't the addend of another.
  static Instruction *getDotEnd(BasicBlock *BB) {
    auto IsFMulAdd = [](const Value *V) {
      auto *II = dyn_cast<IntrinsicInst>(V);
      return II && II->getIntrinsicID() == Intrinsic::fmuladd &&
             II->getType()->isFloatTy();
    };
    Instruction *End = nullptr;
    for (Instruction &I : *BB) {
      if (!IsFMulAdd(&I))
        continue;
      if (any_of(I.uses(), [&](const Use &U) {
            return IsFMulAdd(U.getUser()) && U.getOperandNo() == 2;
          }))
        continue;
      if (End)
        return nullptr;
      End = &I;
    }
    return End;
  }

  // BB holds N copies of a per-output dot product (an innermost output loop
  // after jamSequence), Ends[J] the end of copy J's fmuladd chain. SLP can't
  // vectorize them: its only seeds are the copies' stores, whose values come
  // out of compares and selects (clamps) the VRF core has no vector form of,
  // and each store sits among the next copies' loads. So vectorize the chains
  // here, as SLP would, 8 copies per vector: identical lanes become a splat,
  // fmuladd/fmul/fadd/fsub lanes the vector operation, loads whose addresses
  // step by a constant a block load (contiguous) or a strided one. The rest
  // of the block (the copies' epilogues) moves after the chains and takes the
  // lanes with extractelement. If a chain has anything else, BB is left as is.
  static void vectorizeDots(BasicBlock *BB, ArrayRef<Instruction *> Ends,
                            ScalarEvolution &SE) {
    constexpr unsigned VF = 8;
    unsigned N = Ends.size();
    if (N % VF)
      return;
    Type *FTy = Ends[0]->getType();
    auto *VTy = FixedVectorType::get(FTy, VF);

    // The chains: everything in BB the ends depend on.
    SmallPtrSet<Instruction *, 32> Chain;
    SmallVector<Instruction *, 64> Worklist(Ends.begin(), Ends.end());
    while (!Worklist.empty()) {
      Instruction *I = Worklist.pop_back_val();
      if (I->getParent() != BB || isa<PHINode>(I) || !Chain.insert(I).second)
        continue;
      for (Value *Op : I->operands())
        if (auto *OI = dyn_cast<Instruction>(Op))
          Worklist.push_back(OI);
    }

    // Lane J of a tuple of values, one per copy: what each is (all the same,
    // the same operation in every copy, or loads stepping by a constant).
    auto AllSame = [](ArrayRef<Value *> Lanes) {
      return all_equal(Lanes);
    };
    auto LoadStride = [&](ArrayRef<Value *> Lanes) -> std::optional<int64_t> {
      const SCEV *P0 = SE.getSCEV(cast<LoadInst>(Lanes[0])->getPointerOperand());
      std::optional<int64_t> Stride;
      for (unsigned J = 1; J < Lanes.size(); ++J) {
        auto *D = dyn_cast<SCEVConstant>(SE.getMinusSCEV(
            SE.getSCEV(cast<LoadInst>(Lanes[J])->getPointerOperand()), P0));
        if (!D || D->getAPInt().getSignificantBits() > 32)
          return std::nullopt;
        int64_t Off = D->getAPInt().getSExtValue();
        if (!Stride)
          Stride = Off;
        if (Off != *Stride * J)
          return std::nullopt;
      }
      return Stride;
    };
    auto Kind = [&](ArrayRef<Value *> Lanes) -> unsigned {
      // 0: can't, 1: splat, 2: fmuladd, 3: binary op, 4: load.
      if (AllSame(Lanes))
        return Lanes[0]->getType() == FTy ? 1 : 0;
      auto *I0 = dyn_cast<Instruction>(Lanes[0]);
      if (!I0 || !Chain.count(I0) || I0->getType() != FTy)
        return 0;
      for (Value *V : Lanes) {
        auto *I = dyn_cast<Instruction>(V);
        if (!I || !Chain.count(I) || I->getOpcode() != I0->getOpcode() ||
            !I->isSameOperationAs(I0))
          return 0;
      }
      if (auto *II = dyn_cast<IntrinsicInst>(I0))
        return II->getIntrinsicID() == Intrinsic::fmuladd ? 2 : 0;
      if (isa<BinaryOperator>(I0) &&
          is_contained({Instruction::FMul, Instruction::FAdd,
                        Instruction::FSub},
                       I0->getOpcode()))
        return 3;
      if (auto *LI = dyn_cast<LoadInst>(I0))
        return LI->isSimple() && LoadStride(Lanes) ? 4 : 0;
      return 0;
    };
    auto OperandLanes = [](ArrayRef<Value *> Lanes, unsigned Op) {
      SmallVector<Value *, VF> Res;
      for (Value *V : Lanes)
        Res.push_back(cast<Instruction>(V)->getOperand(Op));
      return Res;
    };

    // Check first, so that nothing is created for a chain that can't be.
    std::function<bool(ArrayRef<Value *>)> CanVec =
        [&](ArrayRef<Value *> Lanes) -> bool {
      switch (Kind(Lanes)) {
      case 1:
      case 4:
        return true;
      case 2:
        return CanVec(OperandLanes(Lanes, 0)) &&
               CanVec(OperandLanes(Lanes, 1)) && CanVec(OperandLanes(Lanes, 2));
      case 3:
        return CanVec(OperandLanes(Lanes, 0)) && CanVec(OperandLanes(Lanes, 1));
      }
      return false;
    };
    SmallVector<SmallVector<Value *, VF>, 2> Groups;
    for (unsigned G = 0; G < N / VF; ++G) {
      Groups.emplace_back(Ends.begin() + G * VF, Ends.begin() + (G + 1) * VF);
      if (!CanVec(Groups.back()))
        return;
    }

    // The chains first, the rest of the block after them, in order.
    SmallVector<Instruction *, 128> Rest;
    for (Instruction &I : *BB)
      if (!isa<PHINode>(I) && !I.isTerminator() && !Chain.count(&I))
        Rest.push_back(&I);
    for (Instruction *I : Rest)
      I->moveBefore(BB->getTerminator()->getIterator());

    IRBuilder<> B(Rest.empty() ? BB->getTerminator() : Rest.front());
    DenseMap<Value *, Value *> Built;
    std::function<Value *(ArrayRef<Value *>)> Build =
        [&](ArrayRef<Value *> Lanes) -> Value * {
      if (Value *V = Built.lookup(Lanes[0]); V && !AllSame(Lanes))
        return V;
      Value *Res = nullptr;
      switch (Kind(Lanes)) {
      case 1:
        Res = B.CreateVectorSplat(VF, Lanes[0]);
        break;
      case 2: {
        // The addend (the chain so far) first: each term's loads then come
        // right before its fmuladd, one weight block live at a time.
        Value *D = Build(OperandLanes(Lanes, 2));
        Value *A = Build(OperandLanes(Lanes, 0));
        Value *C = Build(OperandLanes(Lanes, 1));
        Res = B.CreateIntrinsic(Intrinsic::fmuladd, {VTy}, {A, C, D});
        break;
      }
      case 3: {
        auto *I0 = cast<BinaryOperator>(Lanes[0]);
        Value *A = Build(OperandLanes(Lanes, 0));
        Value *C = Build(OperandLanes(Lanes, 1));
        Res = B.CreateBinOp(I0->getOpcode(), A, C);
        cast<Instruction>(Res)->copyIRFlags(I0);
        break;
      }
      case 4: {
        auto *L0 = cast<LoadInst>(Lanes[0]);
        int64_t Stride = *LoadStride(Lanes);
        Value *Ptr = L0->getPointerOperand();
        if (Stride == 0)
          Res = B.CreateVectorSplat(VF, L0);
        else if (Stride == int64_t(FTy->getPrimitiveSizeInBits() / 8))
          Res = B.CreateAlignedLoad(VTy, Ptr, L0->getAlign());
        else
          Res = B.CreateIntrinsic(
              Intrinsic::experimental_vp_strided_load,
              {VTy, Ptr->getType(), B.getInt32Ty()},
              {Ptr, B.getInt32(Stride),
               ConstantVector::getSplat(ElementCount::getFixed(VF),
                                        B.getTrue()),
               B.getInt32(VF)});
        break;
      }
      default:
        llvm_unreachable("checked by CanVec");
      }
      if (!AllSame(Lanes))
        Built[Lanes[0]] = Res;
      return Res;
    };
    for (auto [G, Lanes] : enumerate(Groups)) {
      Value *V = Build(Lanes);
      for (unsigned J = 0; J < VF; ++J) {
        Value *E = B.CreateExtractElement(V, J);
        Ends[G * VF + J]->replaceAllUsesWith(E);
      }
    }
    for (Instruction *E : Ends)
      RecursivelyDeleteTriviallyDeadInstructions(E);
  }

public:
  RISCVXRepeatUnrollAndJamPass(const RISCVTargetMachine &TM) : TM(TM) {}
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    if (XRepeatUnrollJam == XRepeatUJMode::Off ||
        !TM.getSubtarget<RISCVSubtarget>(F).hasXRepeatVRFVectors())
      return PreservedAnalyses::all();

    // Loop-simplify form first (every loop with a preheader and a single
    // latch), which the matching requires.
    FAM.invalidate(F, LoopSimplifyPass().run(F, FAM));
    auto &LI = FAM.getResult<LoopAnalysis>(F);
    auto &SE = FAM.getResult<ScalarEvolutionAnalysis>(F);
    SmallVector<std::pair<Loop *, unsigned>, 4> Candidates;
    for (Loop *L : LI.getLoopsInPreorder())
      if (unsigned Count = getCount(L, SE))
        Candidates.push_back({L, Count});
    if (Candidates.empty())
      return PreservedAnalyses::all();

    auto &DT = FAM.getResult<DominatorTreeAnalysis>(F);
    auto &AC = FAM.getResult<AssumptionAnalysis>(F);
    auto &DI = FAM.getResult<DependenceAnalysis>(F);
    auto &TTI = FAM.getResult<TargetIRAnalysis>(F);
    auto &ORE = FAM.getResult<OptimizationRemarkEmitterAnalysis>(F);
    bool Changed = false;
    for (auto [L, Count] : Candidates) {
      SmallVector<Loop *, 9> Subs;
      if (L->getSubLoops().size() != 1) {
        // A sequence of inner loops (a convolution), or none (a whole dot
        // product per output): jammed here.
        SmallVector<BasicBlock *, 10> Segs;
        if (!getSequence(L, SE, Segs, Subs))
          continue;
        jamSequence(L, Count, Segs, Subs, SE);
        SE.forgetLoop(L);
      } else {
        // One inner loop: LLVM's unroll-and-jam.
        Loop *Outermost = L;
        while (Loop *P = Outermost->getParentLoop())
          Outermost = P;
        Changed |= formLCSSARecursively(*Outermost, DT, &LI, &SE);
        if (!isSafeToUnrollAndJam(L, SE, DT, DI, LI))
          continue;
        Subs.push_back(L->getSubLoops()[0]);
        unsigned TC = SE.getSmallConstantTripCount(L);
        if (UnrollAndJamLoop(L, Count, TC, TC, /*UnrollRemainder=*/false, &LI,
                             &SE, &DT, &AC, &TTI, &ORE) ==
            LoopUnrollResult::Unmodified)
          continue;
      }
      Changed = true;
      // The jammed inner loops are the original ones (the copies are merged
      // into them). Keep the outer loop as it is now, and in column mode keep
      // the loop vectorizer off the inner loops: SLP vectorizes across the
      // jammed accumulators instead.
      addStringMetadataToLoop(L, "llvm.loop.unroll.disable");
      addStringMetadataToLoop(L, XRepeatJammedAttr, 1);
      if (XRepeatUnrollJam == XRepeatUJMode::Column) {
        for (Loop *Sub : Subs)
          addStringMetadataToLoop(Sub, "llvm.loop.isvectorized", 1);
        if (L->isInnermost())
          addStringMetadataToLoop(L, "llvm.loop.isvectorized", 1);
      }
    }
    if (!Changed)
      return PreservedAnalyses::all();

    // One induction variable for the jammed copies and one load of x[i].
    FAM.invalidate(F, PreservedAnalyses::none());
    FunctionPassManager FPM;
    FPM.addPass(createFunctionToLoopPassAdaptor(IndVarSimplifyPass(),
                                                /*UseMemorySSA=*/true));
    FPM.addPass(EarlyCSEPass(/*UseMemorySSA=*/true));
    FPM.run(F, FAM);
    return PreservedAnalyses::none();
  }
};
} // namespace

void RISCVTargetMachine::registerPassBuilderCallbacks(PassBuilder &PB) {
#define GET_PASS_REGISTRY "RISCVPassRegistry.def"
#include "llvm/Passes/TargetPassRegistry.inc"

  PB.registerLateLoopOptimizationsEPCallback([=](LoopPassManager &LPM,
                                                 OptimizationLevel Level) {
    if (Level != OptimizationLevel::O0)
      LPM.addPass(LoopIdiomVectorizePass(LoopIdiomVectorizeStyle::Predicated));
  });

  PB.registerVectorizerStartEPCallback(
      [this](FunctionPassManager &FPM, OptimizationLevel Level) {
        if (Level.getSpeedupLevel() >= 2) {
          FPM.addPass(RISCVXRepeatFMinMaxPass(*this));
          FPM.addPass(RISCVXRepeatUnrollAndJamPass(*this));
          FPM.addPass(RISCVXRepeatLoopFusionPass(*this));
        }
      });
}

yaml::MachineFunctionInfo *
RISCVTargetMachine::createDefaultFuncInfoYAML() const {
  return new yaml::RISCVMachineFunctionInfo();
}

yaml::MachineFunctionInfo *
RISCVTargetMachine::convertFuncInfoToYAML(const MachineFunction &MF) const {
  const auto *MFI = MF.getInfo<RISCVMachineFunctionInfo>();
  return new yaml::RISCVMachineFunctionInfo(*MFI);
}

bool RISCVTargetMachine::parseMachineFunctionInfo(
    const yaml::MachineFunctionInfo &MFI, PerFunctionMIParsingState &PFS,
    SMDiagnostic &Error, SMRange &SourceRange) const {
  const auto &YamlMFI =
      static_cast<const yaml::RISCVMachineFunctionInfo &>(MFI);
  PFS.MF.getInfo<RISCVMachineFunctionInfo>()->initializeBaseYamlFields(YamlMFI);
  return false;
}
