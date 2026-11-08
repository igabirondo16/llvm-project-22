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
#include "llvm/Transforms/Scalar/GVN.h"
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
      if (!Prev || worthFusing(Prev, L, SE, Map))
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
