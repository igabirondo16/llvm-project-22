//===- RISCVTargetTransformInfo.h - RISC-V specific TTI ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
/// \file
/// This file defines a TargetTransformInfoImplBase conforming object specific
/// to the RISC-V target machine. It uses the target's detailed information to
/// provide more precise answers to certain TTI queries, while letting the
/// target independent and default TTI implementations handle the rest.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_RISCV_RISCVTARGETTRANSFORMINFO_H
#define LLVM_LIB_TARGET_RISCV_RISCVTARGETTRANSFORMINFO_H

#include "RISCVSubtarget.h"
#include "RISCVTargetMachine.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/BasicTTIImpl.h"
#include "llvm/IR/Function.h"
#include <optional>

namespace llvm {

class RISCVTTIImpl final : public BasicTTIImplBase<RISCVTTIImpl> {
  using BaseT = BasicTTIImplBase<RISCVTTIImpl>;
  using TTI = TargetTransformInfo;

  friend BaseT;

  const RISCVSubtarget *ST;
  const RISCVTargetLowering *TLI;

  const RISCVSubtarget *getST() const { return ST; }

  /// True when XRepeatInt provides the fixed-length vectors: blocks of GPRs
  /// instead of RVV registers, either three <8 x i32> (x8..x15, x16..x23,
  /// x24..x31) or six <4 x i32> (x8..x11, x12..x15, ..., x28..x31).
  bool hasXRepeatVectors() const { return ST->hasXRepeatGPRVectors(); }

  /// True when XRepeat (the VRF core) provides the fixed-length vectors:
  /// blocks of F registers, four <8 x i32>/<8 x float> (f0, f8, f16, f24) or
  /// two <16 x i32>/<16 x float> (f0, f16).
  bool hasXRepeatVRFVectors() const { return ST->hasXRepeatVRFVectors(); }

  /// True for fixed vectors when XRepeat keeps them in blocks of F registers.
  /// The RVV cost model doesn't apply to them.
  bool isXRepeatVRFVector(Type *Ty) const {
    return hasXRepeatVRFVectors() && isa<FixedVectorType>(Ty);
  }

  /// Cost of an operation that XRepeat does with one instruction + REPEAT
  /// pair per 8- or 16-wide F-register block of \p Ty, or std::nullopt if
  /// \p Ty isn't legalized to such blocks.
  std::optional<InstructionCost> getXRFPairCost(Type *Ty) const;

  /// Whether \p Ty is legalized to 16-wide F-register blocks. Two of them
  /// fill the F registers, so an instruction can't read two of them plus a
  /// third register.
  bool isXRF16Wide(Type *Ty) const;

  /// True for fixed vectors when XRepeat keeps them in GPR blocks instead of
  /// RVV registers. The RVV cost model doesn't apply to them, so the hooks
  /// that would otherwise assume RVV use the generic cost model instead.
  bool isXRepeatVector(Type *Ty) const {
    return hasXRepeatVectors() && isa<FixedVectorType>(Ty);
  }

  /// XRepeat only has MAC and LW + REPEAT. Any other vector operation is done
  /// element by element, which is never worth vectorizing for since the
  /// blocks already take 24 of the GPRs. Its throughput cost (the one the
  /// vectorizers use) is therefore invalid, so they don't choose it; the
  /// other cost kinds keep the generic estimate for existing vector code.
  /// The same for the VRF core, where loads, stores, the integer ALU, MAC,
  /// fadd/fsub/fmul/fmadd and add reductions are supported.
  bool isUnsupportedXRepeatOp(Type *Ty, TTI::TargetCostKind CostKind) const {
    return CostKind == TTI::TCK_RecipThroughput &&
           (isXRepeatVector(Ty) || isXRepeatVRFVector(Ty));
  }

  /// Cost of an operation that XRepeat does with one instruction + REPEAT
  /// pair per <8 x i32> or <4 x i32> block of \p Ty, or std::nullopt if \p Ty
  /// isn't legalized to such blocks.
  std::optional<InstructionCost> getXRepeatPairCost(Type *Ty) const;
  const RISCVTargetLowering *getTLI() const { return TLI; }

  /// This function returns an estimate for VL to be used in VL based terms
  /// of the cost model.  For fixed length vectors, this is simply the
  /// vector length.  For scalable vectors, we return results consistent
  /// with getVScaleForTuning under the assumption that clients are also
  /// using that when comparing costs between scalar and vector representation.
  /// This does unfortunately mean that we can both undershoot and overshot
  /// the true cost significantly if getVScaleForTuning is wildly off for the
  /// actual target hardware.
  unsigned getEstimatedVLFor(VectorType *Ty) const;

  /// This function calculates the costs for one or more RVV opcodes based
  /// on the vtype and the cost kind.
  /// \param Opcodes A list of opcodes of the RVV instruction to evaluate.
  /// \param VT The MVT of vtype associated with the RVV instructions.
  /// For widening/narrowing instructions where the result and source types
  /// differ, it is important to check the spec to determine whether the vtype
  /// refers to the result or source type.
  /// \param CostKind The type of cost to compute.
  InstructionCost getRISCVInstructionCost(ArrayRef<unsigned> OpCodes, MVT VT,
                                          TTI::TargetCostKind CostKind) const;

  // Return the cost of generating a PC relative address
  InstructionCost
  getStaticDataAddrGenerationCost(const TTI::TargetCostKind CostKind) const;

  /// Return the cost of accessing a constant pool entry of the specified
  /// type.
  InstructionCost getConstantPoolLoadCost(Type *Ty,
                                          TTI::TargetCostKind CostKind) const;

  /// If this shuffle can be lowered as a masked slide pair (at worst),
  /// return a cost for it.
  InstructionCost getSlideCost(FixedVectorType *Tp, ArrayRef<int> Mask,
                               TTI::TargetCostKind CostKind) const;

public:
  explicit RISCVTTIImpl(const RISCVTargetMachine *TM, const Function &F)
      : BaseT(TM, F.getDataLayout()), ST(TM->getSubtargetImpl(F)),
        TLI(ST->getTargetLowering()) {}

  /// Return the cost of materializing an immediate for a value operand of
  /// a store instruction.
  InstructionCost getStoreImmCost(Type *VecTy, TTI::OperandValueInfo OpInfo,
                                  TTI::TargetCostKind CostKind) const;

  InstructionCost getIntImmCost(const APInt &Imm, Type *Ty,
                                TTI::TargetCostKind CostKind) const override;
  InstructionCost getIntImmCostInst(unsigned Opcode, unsigned Idx,
                                    const APInt &Imm, Type *Ty,
                                    TTI::TargetCostKind CostKind,
                                    Instruction *Inst = nullptr) const override;
  InstructionCost
  getIntImmCostIntrin(Intrinsic::ID IID, unsigned Idx, const APInt &Imm,
                      Type *Ty, TTI::TargetCostKind CostKind) const override;

  /// \name EVL Support for predicated vectorization.
  /// Whether the target supports the %evl parameter of VP intrinsic efficiently
  /// in hardware. (see LLVM Language Reference - "Vector Predication
  /// Intrinsics",
  /// https://llvm.org/docs/LangRef.html#vector-predication-intrinsics and
  /// "IR-level VP intrinsics",
  /// https://llvm.org/docs/Proposals/VectorPredication.html#ir-level-vp-intrinsics).
  bool hasActiveVectorLength() const override;

  TargetTransformInfo::PopcntSupportKind
  getPopcntSupport(unsigned TyWidth) const override;

  InstructionCost getPartialReductionCost(
      unsigned Opcode, Type *InputTypeA, Type *InputTypeB, Type *AccumType,
      ElementCount VF, TTI::PartialReductionExtendKind OpAExtend,
      TTI::PartialReductionExtendKind OpBExtend, std::optional<unsigned> BinOp,
      TTI::TargetCostKind CostKind) const override;

  bool shouldExpandReduction(const IntrinsicInst *II) const override;
  bool supportsScalableVectors() const override {
    return ST->hasVInstructions();
  }
  bool enableOrderedReductions() const override { return true; }
  bool enableScalableVectorization() const override {
    return ST->hasVInstructions();
  }
  bool preferPredicateOverEpilogue(TailFoldingInfo *TFI) const override {
    return ST->hasVInstructions();
  }
  TailFoldingStyle
  getPreferredTailFoldingStyle(bool IVUpdateMayOverflow) const override {
    return ST->hasVInstructions() ? TailFoldingStyle::DataWithEVL
                                  : TailFoldingStyle::None;
  }
  std::optional<unsigned> getMaxVScale() const override;
  std::optional<unsigned> getVScaleForTuning() const override;

  TypeSize
  getRegisterBitWidth(TargetTransformInfo::RegisterKind K) const override;

  unsigned getRegUsageForType(Type *Ty) const override;

  unsigned getMaximumVF(unsigned ElemWidth, unsigned Opcode) const override;

  bool preferAlternateOpcodeVectorization() const override;

  bool preferInLoopReduction(RecurKind Kind, Type *Ty) const override;

  /// XRepeat (VRF core): an ordered float dot product is one fmadd.s + REPEAT
  /// into the accumulator (fused, in order, like the scalar loop).
  bool preferFusedFMulAddReduction() const override {
    return hasXRepeatVRFVectors();
  }

  bool preferEpilogueVectorization() const override {
    // Epilogue vectorization is usually unprofitable - tail folding or
    // a smaller VF would have been better.  This a blunt hammer - we
    // should re-examine this once vectorization is better tuned.
    return false;
  }

  bool shouldConsiderVectorizationRegPressure() const override { return true; }

  InstructionCost
  getMemIntrinsicInstrCost(const MemIntrinsicCostAttributes &MICA,
                           TTI::TargetCostKind CostKind) const override;

  InstructionCost getMaskedMemoryOpCost(const MemIntrinsicCostAttributes &MICA,
                                        TTI::TargetCostKind CostKind) const;

  InstructionCost
  getPointersChainCost(ArrayRef<const Value *> Ptrs, const Value *Base,
                       const TTI::PointersChainInfo &Info, Type *AccessTy,
                       TTI::TargetCostKind CostKind) const override;

  void getUnrollingPreferences(Loop *L, ScalarEvolution &SE,
                               TTI::UnrollingPreferences &UP,
                               OptimizationRemarkEmitter *ORE) const override;

  void getPeelingPreferences(Loop *L, ScalarEvolution &SE,
                             TTI::PeelingPreferences &PP) const override;

  bool getTgtMemIntrinsic(IntrinsicInst *Inst,
                          MemIntrinsicInfo &Info) const override;

  unsigned getMinVectorRegisterBitWidth() const override {
    // XRepeat VRF: the narrowest block is 8 x 32 bits (SLP starts there).
    if (hasXRepeatVRFVectors())
      return 256;
    return ST->useRVVForFixedLengthVectors() ? 16 : 0;
  }

  InstructionCost
  getShuffleCost(TTI::ShuffleKind Kind, VectorType *DstTy, VectorType *SrcTy,
                 ArrayRef<int> Mask, TTI::TargetCostKind CostKind, int Index,
                 VectorType *SubTp, ArrayRef<const Value *> Args = {},
                 const Instruction *CxtI = nullptr) const override;

  InstructionCost getScalarizationOverhead(
      VectorType *Ty, const APInt &DemandedElts, bool Insert, bool Extract,
      TTI::TargetCostKind CostKind, bool ForPoisonSrc = true,
      ArrayRef<Value *> VL = {}) const override;

  InstructionCost
  getIntrinsicInstrCost(const IntrinsicCostAttributes &ICA,
                        TTI::TargetCostKind CostKind) const override;

  InstructionCost
  getAddressComputationCost(Type *PTy, ScalarEvolution *SE, const SCEV *Ptr,
                            TTI::TargetCostKind CostKind) const override;

  InstructionCost getInterleavedMemoryOpCost(
      unsigned Opcode, Type *VecTy, unsigned Factor, ArrayRef<unsigned> Indices,
      Align Alignment, unsigned AddressSpace, TTI::TargetCostKind CostKind,
      bool UseMaskForCond = false, bool UseMaskForGaps = false) const override;

  InstructionCost getGatherScatterOpCost(const MemIntrinsicCostAttributes &MICA,
                                         TTI::TargetCostKind CostKind) const;

  InstructionCost
  getExpandCompressMemoryOpCost(const MemIntrinsicCostAttributes &MICA,
                                TTI::TargetCostKind CostKind) const;

  InstructionCost getStridedMemoryOpCost(const MemIntrinsicCostAttributes &MICA,
                                         TTI::TargetCostKind CostKind) const;

  InstructionCost
  getCostOfKeepingLiveOverCall(ArrayRef<Type *> Tys) const override;

  InstructionCost
  getCastInstrCost(unsigned Opcode, Type *Dst, Type *Src,
                   TTI::CastContextHint CCH, TTI::TargetCostKind CostKind,
                   const Instruction *I = nullptr) const override;

  InstructionCost
  getMinMaxReductionCost(Intrinsic::ID IID, VectorType *Ty, FastMathFlags FMF,
                         TTI::TargetCostKind CostKind) const override;

  InstructionCost
  getArithmeticReductionCost(unsigned Opcode, VectorType *Ty,
                             std::optional<FastMathFlags> FMF,
                             TTI::TargetCostKind CostKind) const override;

  InstructionCost
  getExtendedReductionCost(unsigned Opcode, bool IsUnsigned, Type *ResTy,
                           VectorType *ValTy, std::optional<FastMathFlags> FMF,
                           TTI::TargetCostKind CostKind) const override;

  InstructionCost
  getMulAccReductionCost(bool IsUnsigned, unsigned RedOpcode, Type *ResTy,
                         VectorType *Ty,
                         TTI::TargetCostKind CostKind) const override;

  InstructionCost getMemoryOpCost(
      unsigned Opcode, Type *Src, Align Alignment, unsigned AddressSpace,
      TTI::TargetCostKind CostKind,
      TTI::OperandValueInfo OpdInfo = {TTI::OK_AnyValue, TTI::OP_None},
      const Instruction *I = nullptr) const override;

  InstructionCost getCmpSelInstrCost(
      unsigned Opcode, Type *ValTy, Type *CondTy, CmpInst::Predicate VecPred,
      TTI::TargetCostKind CostKind,
      TTI::OperandValueInfo Op1Info = {TTI::OK_AnyValue, TTI::OP_None},
      TTI::OperandValueInfo Op2Info = {TTI::OK_AnyValue, TTI::OP_None},
      const Instruction *I = nullptr) const override;

  InstructionCost getCFInstrCost(unsigned Opcode, TTI::TargetCostKind CostKind,
                                 const Instruction *I = nullptr) const override;

  using BaseT::getVectorInstrCost;
  InstructionCost getVectorInstrCost(unsigned Opcode, Type *Val,
                                     TTI::TargetCostKind CostKind,
                                     unsigned Index, const Value *Op0,
                                     const Value *Op1) const override;

  InstructionCost
  getIndexedVectorInstrCostFromEnd(unsigned Opcode, Type *Val,
                                   TTI::TargetCostKind CostKind,
                                   unsigned Index) const override;

  InstructionCost getArithmeticInstrCost(
      unsigned Opcode, Type *Ty, TTI::TargetCostKind CostKind,
      TTI::OperandValueInfo Op1Info = {TTI::OK_AnyValue, TTI::OP_None},
      TTI::OperandValueInfo Op2Info = {TTI::OK_AnyValue, TTI::OP_None},
      ArrayRef<const Value *> Args = {},
      const Instruction *CxtI = nullptr) const override;

  bool isElementTypeLegalForScalableVector(Type *Ty) const override {
    return TLI->isLegalElementTypeForRVV(TLI->getValueType(DL, Ty));
  }

  bool isLegalMaskedLoadStore(Type *DataType, Align Alignment) const {
    if (!ST->hasVInstructions())
      return false;

    EVT DataTypeVT = TLI->getValueType(DL, DataType);

    // Only support fixed vectors if we know the minimum vector size.
    if (DataTypeVT.isFixedLengthVector() && !ST->useRVVForFixedLengthVectors())
      return false;

    EVT ElemType = DataTypeVT.getScalarType();
    if (!ST->enableUnalignedVectorMem() && Alignment < ElemType.getStoreSize())
      return false;

    return TLI->isLegalElementTypeForRVV(ElemType);
  }

  bool isLegalMaskedLoad(Type *DataType, Align Alignment,
                         unsigned /*AddressSpace*/,
                         TTI::MaskKind /*MaskKind*/) const override {
    return isLegalMaskedLoadStore(DataType, Alignment);
  }
  bool isLegalMaskedStore(Type *DataType, Align Alignment,
                          unsigned /*AddressSpace*/,
                          TTI::MaskKind /*MaskKind*/) const override {
    return isLegalMaskedLoadStore(DataType, Alignment);
  }

  bool isLegalMaskedGatherScatter(Type *DataType, Align Alignment) const {
    if (!ST->hasVInstructions())
      return false;

    EVT DataTypeVT = TLI->getValueType(DL, DataType);

    // Only support fixed vectors if we know the minimum vector size.
    if (DataTypeVT.isFixedLengthVector() && !ST->useRVVForFixedLengthVectors())
      return false;

    // We also need to check if the vector of address is valid.
    EVT PointerTypeVT = EVT(TLI->getPointerTy(DL));
    if (DataTypeVT.isScalableVector() &&
        !TLI->isLegalElementTypeForRVV(PointerTypeVT))
      return false;

    EVT ElemType = DataTypeVT.getScalarType();
    if (!ST->enableUnalignedVectorMem() && Alignment < ElemType.getStoreSize())
      return false;

    return TLI->isLegalElementTypeForRVV(ElemType);
  }

  bool isLegalMaskedGather(Type *DataType, Align Alignment) const override {
    return isLegalMaskedGatherScatter(DataType, Alignment);
  }
  bool isLegalMaskedScatter(Type *DataType, Align Alignment) const override {
    return isLegalMaskedGatherScatter(DataType, Alignment);
  }

  bool forceScalarizeMaskedGather(VectorType *VTy,
                                  Align Alignment) const override {
    // Scalarize masked gather for RV64 if EEW=64 indices aren't supported.
    return ST->is64Bit() && !ST->hasVInstructionsI64();
  }

  bool forceScalarizeMaskedScatter(VectorType *VTy,
                                   Align Alignment) const override {
    // Scalarize masked scatter for RV64 if EEW=64 indices aren't supported.
    return ST->is64Bit() && !ST->hasVInstructionsI64();
  }

  bool isLegalStridedLoadStore(Type *DataType, Align Alignment) const override {
    EVT DataTypeVT = TLI->getValueType(DL, DataType);
    return TLI->isLegalStridedLoadStore(DataTypeVT, Alignment);
  }

  bool isLegalInterleavedAccessType(VectorType *VTy, unsigned Factor,
                                    Align Alignment,
                                    unsigned AddrSpace) const override {
    return TLI->isLegalInterleavedAccessType(VTy, Factor, Alignment, AddrSpace,
                                             DL);
  }

  bool isLegalMaskedExpandLoad(Type *DataType, Align Alignment) const override;

  bool isLegalMaskedCompressStore(Type *DataTy, Align Alignment) const override;

  bool isVScaleKnownToBeAPowerOfTwo() const override {
    return TLI->isVScaleKnownToBeAPowerOfTwo();
  }

  /// \returns How the target needs this vector-predicated operation to be
  /// transformed.
  TargetTransformInfo::VPLegalization
  getVPLegalizationStrategy(const VPIntrinsic &PI) const override {
    using VPLegalization = TargetTransformInfo::VPLegalization;
    if (!ST->hasVInstructions() ||
        (PI.getIntrinsicID() == Intrinsic::vp_reduce_mul &&
         cast<VectorType>(PI.getArgOperand(1)->getType())
                 ->getElementType()
                 ->getIntegerBitWidth() != 1))
      return VPLegalization(VPLegalization::Discard, VPLegalization::Convert);
    return VPLegalization(VPLegalization::Legal, VPLegalization::Legal);
  }

  bool isLegalToVectorizeReduction(const RecurrenceDescriptor &RdxDesc,
                                   ElementCount VF) const override {
    if (!VF.isScalable())
      return true;

    Type *Ty = RdxDesc.getRecurrenceType();
    if (!TLI->isLegalElementTypeForRVV(TLI->getValueType(DL, Ty)))
      return false;

    switch (RdxDesc.getRecurrenceKind()) {
    case RecurKind::Add:
    case RecurKind::Sub:
    case RecurKind::AddChainWithSubs:
    case RecurKind::And:
    case RecurKind::Or:
    case RecurKind::Xor:
    case RecurKind::SMin:
    case RecurKind::SMax:
    case RecurKind::UMin:
    case RecurKind::UMax:
    case RecurKind::FMin:
    case RecurKind::FMax:
      return true;
    case RecurKind::AnyOf:
    case RecurKind::FAdd:
    case RecurKind::FMulAdd:
      // We can't promote f16/bf16 fadd reductions and scalable vectors can't be
      // expanded.
      if (Ty->isBFloatTy() || (Ty->isHalfTy() && !ST->hasVInstructionsF16()))
        return false;
      return true;
    default:
      return false;
    }
  }

  unsigned getMaxInterleaveFactor(ElementCount VF) const override {
    // Don't interleave if the loop has been vectorized with scalable vectors.
    if (VF.isScalable())
      return 1;
    // XRepeat has only six (or three) GPR blocks, or four (or two) F-register
    // blocks.
    if (hasXRepeatVectors() || hasXRepeatVRFVectors())
      return 1;
    // If the loop will not be vectorized, don't interleave the loop.
    // Let regular unroll to unroll the loop.
    return VF.isScalar() ? 1 : ST->getMaxInterleaveFactor();
  }

  bool enableInterleavedAccessVectorization() const override { return true; }

  bool enableMaskedInterleavedAccessVectorization() const override {
    return ST->hasVInstructions();
  }

  unsigned getMinTripCountTailFoldingThreshold() const override;

  enum RISCVRegisterClass { GPRRC, FPRRC, VRRC };
  unsigned getNumberOfRegisters(unsigned ClassID) const override {
    switch (ClassID) {
    case RISCVRegisterClass::GPRRC:
      // 31 = 32 GPR - x0 (zero register)
      // FIXME: Should we exclude fixed registers like SP, TP or GP?
      return 31;
    case RISCVRegisterClass::FPRRC:
      if (ST->hasStdExtF())
        return 32;
      return 0;
    case RISCVRegisterClass::VRRC:
      // Although there are 32 vector registers, v0 is special in that it is the
      // only register that can be used to hold a mask.
      // FIXME: Should we conservatively return 31 as the number of usable
      // vector registers?
      if (ST->hasVInstructions())
        return 32;
      // XRepeat: the six 4-GPR blocks (an 8-GPR block counts as two, see
      // getRegUsageForType). VRF core: 5 units, with an 8-wide block 1 unit
      // and a 16-wide one 3 (getRegUsageForType). The vectorizer counts every
      // loaded vector as live from the top of the loop body, but the backend
      // loads each block right before its use (XRFBlockLoadLatencyMutation),
      // so e.g. a loop with x and four rows A0..A3 (5 blocks counted) really
      // needs two. A 16-wide loop with two vector values live (6 units) is
      // still rejected: two 16-wide blocks are all 32 F registers, with no
      // room for splats, a MAC's zero addend or accumulators.
      if (hasXRepeatVRFVectors())
        return 5;
      return hasXRepeatVectors() ? 6 : 0;
    }
    llvm_unreachable("unknown register class");
  }

  TTI::AddressingModeKind
  getPreferredAddressingMode(const Loop *L, ScalarEvolution *SE) const override;

  unsigned getRegisterClassForType(bool Vector,
                                   Type *Ty = nullptr) const override {
    if (Vector)
      return RISCVRegisterClass::VRRC;
    if (!Ty)
      return RISCVRegisterClass::GPRRC;

    Type *ScalarTy = Ty->getScalarType();
    if ((ScalarTy->isHalfTy() && ST->hasStdExtZfhmin()) ||
        (ScalarTy->isFloatTy() && ST->hasStdExtF()) ||
        (ScalarTy->isDoubleTy() && ST->hasStdExtD())) {
      return RISCVRegisterClass::FPRRC;
    }

    return RISCVRegisterClass::GPRRC;
  }

  const char *getRegisterClassName(unsigned ClassID) const override {
    switch (ClassID) {
    case RISCVRegisterClass::GPRRC:
      return "RISCV::GPRRC";
    case RISCVRegisterClass::FPRRC:
      return "RISCV::FPRRC";
    case RISCVRegisterClass::VRRC:
      return "RISCV::VRRC";
    }
    llvm_unreachable("unknown register class");
  }

  bool isLSRCostLess(const TargetTransformInfo::LSRCost &C1,
                     const TargetTransformInfo::LSRCost &C2) const override;

  bool shouldConsiderAddressTypePromotion(
      const Instruction &I,
      bool &AllowPromotionWithoutCommonHeader) const override;
  std::optional<unsigned> getMinPageSize() const override { return 4096; }
  /// Return true if the (vector) instruction I will be lowered to an
  /// instruction with a scalar splat operand for the given Operand number.
  bool canSplatOperand(Instruction *I, int Operand) const;
  /// Return true if a vector instruction will lower to a target instruction
  /// able to splat the given operand.
  bool canSplatOperand(unsigned Opcode, int Operand) const;

  bool isProfitableToSinkOperands(Instruction *I,
                                  SmallVectorImpl<Use *> &Ops) const override;

  TTI::MemCmpExpansionOptions
  enableMemCmpExpansion(bool OptSize, bool IsZeroCmp) const override;
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_RISCV_RISCVTARGETTRANSFORMINFO_H
