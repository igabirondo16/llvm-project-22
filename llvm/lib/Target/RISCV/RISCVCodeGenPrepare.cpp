//===----- RISCVCodeGenPrepare.cpp ----------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This is a RISC-V specific version of CodeGenPrepare.
// It munges the code in the input function to better prepare it for
// SelectionDAG-based code generation. This works around limitations in it's
// basic-block-at-a-time approach.
//
//===----------------------------------------------------------------------===//

#include "RISCV.h"
#include "RISCVTargetMachine.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/ValueTracking.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Transforms/Utils/Local.h"

using namespace llvm;

#define DEBUG_TYPE "riscv-codegenprepare"
#define PASS_NAME "RISC-V CodeGenPrepare"

namespace {
class RISCVCodeGenPrepare : public InstVisitor<RISCVCodeGenPrepare, bool> {
  Function &F;
  const DataLayout *DL;
  const DominatorTree *DT;
  const RISCVSubtarget *ST;

public:
  RISCVCodeGenPrepare(Function &F, const DominatorTree *DT,
                      const RISCVSubtarget *ST)
      : F(F), DL(&F.getDataLayout()), DT(DT), ST(ST) {}
  bool run();
  bool visitInstruction(Instruction &I) { return false; }
  bool visitAnd(BinaryOperator &BO);
  bool visitIntrinsicInst(IntrinsicInst &I);
  bool expandVPStrideLoad(IntrinsicInst &I);
  bool widenVPMerge(IntrinsicInst &I);
  bool keepXRFAccumulatorInFPR(IntrinsicInst &I);
};
} // namespace

namespace {
class RISCVCodeGenPrepareLegacyPass : public FunctionPass {
public:
  static char ID;

  RISCVCodeGenPrepareLegacyPass() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override;
  StringRef getPassName() const override { return PASS_NAME; }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesCFG();
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<TargetPassConfig>();
  }
};
} // namespace

// Try to optimize (i64 (and (zext/sext (i32 X), C1))) if C1 has bit 31 set,
// but bits 63:32 are zero. If we know that bit 31 of X is 0, we can fill
// the upper 32 bits with ones.
bool RISCVCodeGenPrepare::visitAnd(BinaryOperator &BO) {
  if (!ST->is64Bit())
    return false;

  if (!BO.getType()->isIntegerTy(64))
    return false;

  using namespace PatternMatch;

  // Left hand side should be a zext nneg.
  Value *LHSSrc;
  if (!match(BO.getOperand(0), m_NNegZExt(m_Value(LHSSrc))))
    return false;

  if (!LHSSrc->getType()->isIntegerTy(32))
    return false;

  // Right hand side should be a constant.
  Value *RHS = BO.getOperand(1);

  auto *CI = dyn_cast<ConstantInt>(RHS);
  if (!CI)
    return false;
  uint64_t C = CI->getZExtValue();

  // Look for constants that fit in 32 bits but not simm12, and can be made
  // into simm12 by sign extending bit 31. This will allow use of ANDI.
  // TODO: Is worth making simm32?
  if (!isUInt<32>(C) || isInt<12>(C) || !isInt<12>(SignExtend64<32>(C)))
    return false;

  // Sign extend the constant and replace the And operand.
  C = SignExtend64<32>(C);
  BO.setOperand(1, ConstantInt::get(RHS->getType(), C));

  return true;
}

// With EVL tail folding, an AnyOf reduction will generate an i1 vp.merge like
// follows:
//
// loop:
//   %phi = phi <vscale x 4 x i1> [ zeroinitializer, %entry ], [ %rec, %loop ]
//   %cmp = icmp ...
//   %rec = call <vscale x 4 x i1> @llvm.vp.merge(%cmp, i1 true, %phi, %evl)
//   ...
// middle:
//   %res = call i1 @llvm.vector.reduce.or(<vscale x 4 x i1> %rec)
//
// However RVV doesn't have any tail undisturbed mask instructions and so we
// need a convoluted sequence of mask instructions to lower the i1 vp.merge: see
// llvm/test/CodeGen/RISCV/rvv/vpmerge-sdnode.ll.
//
// To avoid that this widens the i1 vp.merge to an i8 vp.merge, which will
// generate a single vmerge.vim:
//
// loop:
//   %phi = phi <vscale x 4 x i8> [ zeroinitializer, %entry ], [ %rec, %loop ]
//   %cmp = icmp ...
//   %rec = call <vscale x 4 x i8> @llvm.vp.merge(%cmp, i8 true, %phi, %evl)
//   %trunc = trunc <vscale x 4 x i8> %rec to <vscale x 4 x i1>
//   ...
// middle:
//   %res = call i1 @llvm.vector.reduce.or(<vscale x 4 x i1> %rec)
//
// The trunc will normally be sunk outside of the loop, but even if there are
// users inside the loop it is still profitable.
bool RISCVCodeGenPrepare::widenVPMerge(IntrinsicInst &II) {
  if (!II.getType()->getScalarType()->isIntegerTy(1))
    return false;

  Value *Mask, *True, *PhiV, *EVL;
  using namespace PatternMatch;
  if (!match(&II,
             m_Intrinsic<Intrinsic::vp_merge>(m_Value(Mask), m_Value(True),
                                              m_Value(PhiV), m_Value(EVL))))
    return false;

  auto *Phi = dyn_cast<PHINode>(PhiV);
  if (!Phi || !Phi->hasOneUse() || Phi->getNumIncomingValues() != 2 ||
      !match(Phi->getIncomingValue(0), m_Zero()) ||
      Phi->getIncomingValue(1) != &II)
    return false;

  Type *WideTy =
      VectorType::get(IntegerType::getInt8Ty(II.getContext()),
                      cast<VectorType>(II.getType())->getElementCount());

  IRBuilder<> Builder(Phi);
  PHINode *WidePhi = Builder.CreatePHI(WideTy, 2);
  WidePhi->addIncoming(ConstantAggregateZero::get(WideTy),
                       Phi->getIncomingBlock(0));
  Builder.SetInsertPoint(&II);
  Value *WideTrue = Builder.CreateZExt(True, WideTy);
  Value *WideMerge = Builder.CreateIntrinsic(Intrinsic::vp_merge, {WideTy},
                                             {Mask, WideTrue, WidePhi, EVL});
  WidePhi->addIncoming(WideMerge, Phi->getIncomingBlock(1));
  Value *Trunc = Builder.CreateTrunc(WideMerge, II.getType());

  II.replaceAllUsesWith(Trunc);

  // Break the cycle and delete the old chain.
  Phi->setIncomingValue(1, Phi->getIncomingValue(0));
  llvm::RecursivelyDeleteTriviallyDeadInstructions(&II);

  return true;
}

// LLVM vector reduction intrinsics return a scalar result, but on RISC-V vector
// reduction instructions write the result in the first element of a vector
// register. So when a reduction in a loop uses a scalar phi, we end up with
// unnecessary scalar moves:
//
// loop:
// vfmv.s.f v10, fa0
// vfredosum.vs v8, v8, v10
// vfmv.f.s fa0, v8
//
// This mainly affects ordered fadd reductions and VP reductions that have a
// scalar start value, since other types of reduction typically use element-wise
// vectorisation in the loop body. This tries to vectorize any scalar phis that
// feed into these reductions:
//
// loop:
// %phi = phi <float> [ ..., %entry ], [ %acc, %loop ]
// %acc = call float @llvm.vector.reduce.fadd.nxv2f32(float %phi,
//                                                    <vscale x 2 x float> %vec)
//
// ->
//
// loop:
// %phi = phi <vscale x 2 x float> [ ..., %entry ], [ %acc.vec, %loop ]
// %phi.scalar = extractelement <vscale x 2 x float> %phi, i64 0
// %acc = call float @llvm.vector.reduce.fadd.nxv2f32(float %x,
//                                                    <vscale x 2 x float> %vec)
// %acc.vec = insertelement <vscale x 2 x float> poison, float %acc.next, i64 0
//
// Which eliminates the scalar -> vector -> scalar crossing during instruction
// selection.
bool RISCVCodeGenPrepare::visitIntrinsicInst(IntrinsicInst &I) {
  if (expandVPStrideLoad(I))
    return true;

  if (widenVPMerge(I))
    return true;

  if (keepXRFAccumulatorInFPR(I))
    return true;

  if (I.getIntrinsicID() != Intrinsic::vector_reduce_fadd &&
      !isa<VPReductionIntrinsic>(&I))
    return false;

  // XRepeat (VRF core) accumulates a reduction into a single F register, so a
  // scalar phi is what it wants; the vector phi below is for RVV.
  if (!ST->hasVInstructions())
    return false;

  auto *PHI = dyn_cast<PHINode>(I.getOperand(0));
  if (!PHI || !PHI->hasOneUse() ||
      !llvm::is_contained(PHI->incoming_values(), &I))
    return false;

  Type *VecTy = I.getOperand(1)->getType();
  IRBuilder<> Builder(PHI);
  auto *VecPHI = Builder.CreatePHI(VecTy, PHI->getNumIncomingValues());

  for (auto *BB : PHI->blocks()) {
    Builder.SetInsertPoint(BB->getTerminator());
    Value *InsertElt = Builder.CreateInsertElement(
        VecTy, PHI->getIncomingValueForBlock(BB), (uint64_t)0);
    VecPHI->addIncoming(InsertElt, BB);
  }

  Builder.SetInsertPoint(&I);
  I.setOperand(0, Builder.CreateExtractElement(VecPHI, (uint64_t)0));

  PHI->eraseFromParent();

  return true;
}

// XRepeat (VRF core): an in-loop i32 add reduction
//
//   loop:
//     %acc = phi i32 [ %init, %ph ], [ %acc.next, %loop ]
//     %r = call i32 @llvm.vector.reduce.add(<N x i32> %v)
//     %acc.next = add i32 %acc, %r
//
// is one xr.add/xr.mac + REPEAT into a fixed f register, but an i32 phi lives
// in an x register, so every iteration would move the sum to an x register
// and add it there. Give the phi type float instead (bitcasts at both ends),
// so the accumulator stays in its f register and isel folds
// bitcast(add(bitcast %acc, reduce)) into the reduction itself:
//
//   loop:
//     %acc.f = phi float [ bitcast %init, %ph ], [ %acc.next.f, %loop ]
//     %acc.next = add i32 (bitcast %acc.f), %r
//     %acc.next.f = bitcast %acc.next to float
//
// Uses of %acc.next after the loop read bitcast %acc.next.f there. A phi
// after the loop with several inputs (e.g. the start value of the next of a
// chain of reduction loops, which is rewritten the same way) gets the bitcast
// at the end of the incoming block, where back-to-back bitcasts cancel out.
bool RISCVCodeGenPrepare::keepXRFAccumulatorInFPR(IntrinsicInst &I) {
  if (!ST->hasXRepeatVRFVectors() || ST->hasVInstructions() ||
      I.getIntrinsicID() != Intrinsic::vector_reduce_add ||
      !I.getType()->isIntegerTy(32) || !I.hasOneUse())
    return false;
  auto *VecTy = dyn_cast<FixedVectorType>(I.getOperand(0)->getType());
  if (!VecTy || (VecTy->getNumElements() != 8 && VecTy->getNumElements() != 16))
    return false;

  auto *Add = dyn_cast<BinaryOperator>(I.user_back());
  if (!Add || Add->getOpcode() != Instruction::Add)
    return false;
  auto *PHI = dyn_cast<PHINode>(Add->getOperand(0) == &I ? Add->getOperand(1)
                                                           : Add->getOperand(0));
  BasicBlock *BB = Add->getParent();
  if (!PHI || PHI->getParent() != BB || I.getParent() != BB ||
      !PHI->hasOneUse() || PHI->getBasicBlockIndex(BB) < 0 ||
      PHI->getIncomingValueForBlock(BB) != Add)
    return false;
  // Every other use of the sum must be after the loop, in another block.
  for (User *U : Add->users()) {
    auto *UI = cast<Instruction>(U);
    if (UI != PHI && UI->getParent() == BB)
      return false;
  }

  Type *FTy = Type::getFloatTy(F.getContext());
  IRBuilder<> Builder(PHI);
  PHINode *FPHI = Builder.CreatePHI(FTy, PHI->getNumIncomingValues(),
                                    PHI->getName() + ".xrf");
  Builder.SetInsertPoint(Add);
  Value *AccI = Builder.CreateBitCast(FPHI, Add->getType());
  Builder.SetInsertPoint(Add->getNextNode());
  auto *NextF = cast<Instruction>(
      Builder.CreateBitCast(Add, FTy, Add->getName() + ".xrf"));

  // Uses after the loop: LCSSA phis become float phis, others read a bitcast
  // placed right before them.
  for (Use &U : llvm::make_early_inc_range(Add->uses())) {
    auto *UI = cast<Instruction>(U.getUser());
    if (UI == PHI || UI == NextF)
      continue;
    if (auto *UP = dyn_cast<PHINode>(UI); UP && UP->getNumIncomingValues() > 1) {
      Builder.SetInsertPoint(UP->getIncomingBlock(U)->getTerminator());
      U.set(Builder.CreateBitCast(NextF, Add->getType()));
      continue;
    }
    if (auto *UP = dyn_cast<PHINode>(UI)) {
      Builder.SetInsertPoint(UP);
      PHINode *NP = Builder.CreatePHI(FTy, 1, UP->getName() + ".xrf");
      NP->addIncoming(NextF, UP->getIncomingBlock(0));
      Builder.SetInsertPoint(UP->getParent()->getFirstInsertionPt());
      UP->replaceAllUsesWith(Builder.CreateBitCast(NP, UP->getType()));
      UP->eraseFromParent();
      continue;
    }
    Builder.SetInsertPoint(UI);
    U.set(Builder.CreateBitCast(NextF, Add->getType()));
  }

  for (unsigned K = 0, E = PHI->getNumIncomingValues(); K != E; ++K) {
    BasicBlock *In = PHI->getIncomingBlock(K);
    Value *V = PHI->getIncomingValue(K);
    if (V == Add) {
      FPHI->addIncoming(NextF, In);
      continue;
    }
    Builder.SetInsertPoint(In->getTerminator());
    FPHI->addIncoming(Builder.CreateBitCast(V, FTy), In);
  }
  Add->replaceUsesOfWith(PHI, AccI);
  PHI->eraseFromParent();
  return true;
}

// Always expand zero strided loads so we match more .vx splat patterns, even if
// we have +optimized-zero-stride-loads. RISCVDAGToDAGISel::Select will convert
// it back to a strided load if it's optimized.
bool RISCVCodeGenPrepare::expandVPStrideLoad(IntrinsicInst &II) {
  Value *BasePtr, *VL;

  using namespace PatternMatch;
  if (!match(&II, m_Intrinsic<Intrinsic::experimental_vp_strided_load>(
                      m_Value(BasePtr), m_Zero(), m_AllOnes(), m_Value(VL))))
    return false;

  // If SEW>XLEN then a splat will get lowered as a zero strided load anyway, so
  // avoid expanding here.
  if (II.getType()->getScalarSizeInBits() > ST->getXLen())
    return false;

  if (!isKnownNonZero(VL, {*DL, DT, nullptr, &II}))
    return false;

  auto *VTy = cast<VectorType>(II.getType());

  IRBuilder<> Builder(&II);
  Type *STy = VTy->getElementType();
  Value *Val = Builder.CreateLoad(STy, BasePtr);
  Value *Res = Builder.CreateIntrinsic(
      Intrinsic::vp_merge, VTy,
      {II.getOperand(2), Builder.CreateVectorSplat(VTy->getElementCount(), Val),
       PoisonValue::get(VTy), VL});

  II.replaceAllUsesWith(Res);
  II.eraseFromParent();
  return true;
}

bool RISCVCodeGenPrepare::run() {
  bool MadeChange = false;
  for (auto &BB : F)
    for (Instruction &I : llvm::make_early_inc_range(BB))
      MadeChange |= visit(I);

  return MadeChange;
}

bool RISCVCodeGenPrepareLegacyPass::runOnFunction(Function &F) {
  if (skipFunction(F))
    return false;

  auto &TPC = getAnalysis<TargetPassConfig>();
  auto &TM = TPC.getTM<RISCVTargetMachine>();
  auto ST = &TM.getSubtarget<RISCVSubtarget>(F);
  auto DT = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();

  RISCVCodeGenPrepare RVCGP(F, DT, ST);
  return RVCGP.run();
}

INITIALIZE_PASS_BEGIN(RISCVCodeGenPrepareLegacyPass, DEBUG_TYPE, PASS_NAME,
                      false, false)
INITIALIZE_PASS_DEPENDENCY(TargetPassConfig)
INITIALIZE_PASS_END(RISCVCodeGenPrepareLegacyPass, DEBUG_TYPE, PASS_NAME, false,
                    false)

char RISCVCodeGenPrepareLegacyPass::ID = 0;

FunctionPass *llvm::createRISCVCodeGenPrepareLegacyPass() {
  return new RISCVCodeGenPrepareLegacyPass();
}

PreservedAnalyses RISCVCodeGenPreparePass::run(Function &F,
                                               FunctionAnalysisManager &FAM) {
  DominatorTree *DT = &FAM.getResult<DominatorTreeAnalysis>(F);
  auto ST = &TM->getSubtarget<RISCVSubtarget>(F);
  bool Changed = RISCVCodeGenPrepare(F, DT, ST).run();
  if (!Changed)
    return PreservedAnalyses::all();

  PreservedAnalyses PA = PreservedAnalyses::none();
  PA.preserveSet<CFGAnalyses>();
  return PA;
}
