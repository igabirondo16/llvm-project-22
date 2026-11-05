//===-- RISCVInstrInfoXRepeat.td - repeat_rv instructions --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the XRepeat vendor extension of the repeat_rv core:
//   - xr.mac:    rd = rs1 * rs2 + rs3 (R4-type, custom-0).
//   - xr.repeat: re-executes the previous instruction `count` more times,
//                incrementing the register fields selected by `mask` by one
//                on every step (R-type, custom-2).
//
// XRepeatInt is a frozen copy of XRepeat (see RISCVFeatures.td): everything
// here is under HasVendorXRepeatAny so both get it. Additions that only the
// developed XRepeat gets go under HasVendorXRepeat (and in C++ behind
// hasVendorXRepeat()), which keeps XRepeatInt's output unchanged.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction formats
//===----------------------------------------------------------------------===//

// mask is funct7[6:3]: bit 0 = rd, 1 = rs1, 2 = rs2, 3 = rs3 of the repeated
// instruction. rs1 holds the stride (bytes) and rs2 the count. rd and funct3
// are always zero.
class XRInstRepeat
    : RVInstRBase<0b000, OPC_CUSTOM_2, (outs),
                  (ins uimm4:$mask, GPR:$rs1, GPR:$rs2),
                  "xr.repeat", "$mask, $rs1, $rs2"> {
  bits<4> mask;

  let Inst{31-28} = mask;
  let Inst{27-25} = 0b000;
  let rd = 0;
}

//===----------------------------------------------------------------------===//
// Instructions
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXRepeatAny, IsRV32], DecoderNamespace = "XRepeat" in {

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def XR_MAC : RVInstR4<0b00, 0b000, OPC_CUSTOM_0, (outs GPR:$rd),
                      (ins GPR:$rs1, GPR:$rs2, GPR:$rs3),
                      "xr.mac", "$rd, $rs1, $rs2, $rs3">,
             Sched<[]>;

// The repeated instruction may be a load or a store, so model REPEAT as
// touching memory and having side effects.
let hasSideEffects = 1, mayLoad = 1, mayStore = 1 in
def XR_REPEAT : XRInstRepeat, Sched<[]>;

} // Predicates = [HasVendorXRepeatAny, IsRV32], DecoderNamespace = "XRepeat"

//===----------------------------------------------------------------------===//
// Code generation: <8 x i32> in XRVec and <4 x i32> in XRVec4 registers
//===----------------------------------------------------------------------===//

// A vector whose elements are all the same scalar. MAC can read it directly
// from the scalar register (that field just doesn't walk).
def SDT_XRSplat : SDTypeProfile<1, 1, [SDTCisVec<0>, SDTCVecEltisVT<0, i32>,
                                       SDTCisVT<1, i32>]>;
def riscv_xr_splat : RVSDNode<"XR_SPLAT", SDT_XRSplat>;

// acc + a[0] * b[0] + ... + a[N-1] * b[N-1].
def SDT_XRDot : SDTypeProfile<1, 3, [SDTCisVT<0, i32>, SDTCisVT<1, i32>,
                                     SDTCisVec<2>, SDTCVecEltisVT<2, i32>,
                                     SDTCisSameAs<2, 3>]>;
def riscv_xr_dot : RVSDNode<"XR_DOT", SDT_XRDot>;

// Strided load: element i comes from ptr + i * stride (stride in bytes, in a
// register). Lowered from llvm.experimental.vp.strided.load, which SLP emits
// directly and the interleaved access pass emits for each field of an
// interleave group (see RISCVInterleavedAccess.cpp).
def SDT_XRStridedLoad : SDTypeProfile<1, 2, [SDTCisVec<0>,
                                             SDTCVecEltisVT<0, i32>,
                                             SDTCisPtrTy<1>,
                                             SDTCisVT<2, i32>]>;
def riscv_xr_strided_load
    : RVSDNode<"XR_STRIDED_LOAD", SDT_XRStridedLoad,
               [SDNPHasChain, SDNPMayLoad, SDNPMemOperand]>;

// One XRepeat vector width: its type, register class, and the REPEAT count
// (number of elements - 1) that covers a whole register.
class XRVecInfo<int width, ValueType vt, RegisterClass rc> {
  int Width = width;
  ValueType VT = vt;
  RegisterClass RC = rc;
  dag Count = (ADDI (XLenVT X0), !sub(width, 1));
}
def XRV8 : XRVecInfo<8, v8i32, XRVec>;
def XRV4 : XRVecInfo<4, v4i32, XRVec4>;

defvar XRStride4 = (ADDI (XLenVT X0), 4);
defvar XROne = (ADDI (XLenVT X0), 1);
defvar XRMinusOne = (ADDI (XLenVT X0), -1);

let Predicates = [HasVendorXRepeatAny, IsRV32] in
foreach V = [XRV8, XRV4] in {
defvar W = V.Width;

// Load/store of a whole vector register as one LW/SW per element. Used for
// spills and reloads (no free registers for REPEAT's stride/count there) and
// for stores, which REPEAT cannot repeat. Expanded in
// RISCVExpandPseudoInsts.cpp. $vd is early-clobber so the base address never
// lives in the destination block while it is being loaded.
let hasSideEffects = 0, mayLoad = 1, mayStore = 0, Size = !mul(4, W),
    Constraints = "@earlyclobber $vd" in
def PseudoXRLoad # W : Pseudo<(outs V.RC:$vd),
                              (ins GPRMem:$rs1, simm12_lo:$imm12), []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1, Size = !mul(4, W) in
def PseudoXRStore # W : Pseudo<(outs),
                               (ins V.RC:$vs, GPRMem:$rs1, simm12_lo:$imm12),
                               []>;

// Vector load: LW of the first element + REPEAT (mask = rd). The address
// register keeps its value and the immediate offset applies, so the elements
// come from rs1+imm12, rs1+imm12+stride, ... $vd is early-clobber because the
// base, stride and count registers are read on every step.
let hasSideEffects = 0, mayLoad = 1, mayStore = 0, Size = 8,
    Constraints = "@earlyclobber $vd" in
def PseudoXRVLoad # W : Pseudo<(outs V.RC:$vd),
                               (ins GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride,
                                    GPR:$count), []>;

// Vector MAC: vd = rs1 * rs2 + rs3, then REPEAT. Each of rs1/rs2/rs3 is either
// a vector register (V, its field walks) or a scalar GPR (S, its field stays);
// the REPEAT mask is derived from that when the pseudo is expanded. vd is tied
// to a vector input (preferring rs3), which keeps it apart from the scalar and
// count registers that are read on every step; with no vector input it is
// early-clobber instead.
foreach A = [0, 1] in
foreach B = [0, 1] in
foreach C = [0, 1] in {
  defvar Name = !if(A, "V", "S") # !if(B, "V", "S") # !if(C, "V", "S");
  defvar Tie = !cond(C : "$vd = $rs3",
                     B : "$vd = $rs2",
                     A : "$vd = $rs1",
                     true : "@earlyclobber $vd");
  let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Size = 8,
      Constraints = Tie in
  def PseudoXRMAC # W # _ # Name
      : Pseudo<(outs V.RC:$vd),
               (ins !if(A, V.RC, GPR):$rs1, !if(B, V.RC, GPR):$rs2,
                    !if(C, V.RC, GPR):$rs3, GPR:$count), []>;
}

// Dot product: rd = rs1 * rs2 + rs3 where rd and rs3 are the same scalar
// accumulator, so neither walks and each step adds one product to it (REPEAT
// mask 0110 when both sources are vectors). Expanded like PseudoXRMAC*.
foreach A = [0, 1] in
foreach B = [0, 1] in {
  defvar Name = !if(A, "V", "S") # !if(B, "V", "S");
  let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Size = 8,
      Constraints = "$vd = $rs3" in
  def PseudoXRDot # W # _ # Name
      : Pseudo<(outs GPR:$vd),
               (ins !if(A, V.RC, GPR):$rs1, !if(B, V.RC, GPR):$rs2,
                    GPR:$rs3, GPR:$count), []>;
}

def : Pat<(V.VT (load (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12))),
          (!cast<Instruction>("PseudoXRVLoad" # W)
               GPRMem:$rs1, simm12_lo:$imm12, XRStride4, V.Count)>;
// The same LW + REPEAT, with any stride.
def : Pat<(V.VT (riscv_xr_strided_load
                    (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12),
                    (XLenVT GPR:$stride))),
          (!cast<Instruction>("PseudoXRVLoad" # W)
               GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride, V.Count)>;
def : Pat<(store (V.VT V.RC:$vs), (XLenVT GPRMem:$rs1)),
          (!cast<Instruction>("PseudoXRStore" # W) V.RC:$vs, GPRMem:$rs1, 0)>;

// A splat on its own: vd[i] = s * 1 + 0.
def : Pat<(V.VT (riscv_xr_splat (XLenVT GPR:$s))),
          (!cast<Instruction>("PseudoXRMAC" # W # "_SSS")
               GPR:$s, XROne, (XLenVT X0), V.Count)>;

// Arithmetic, for every vector/scalar combination of the operands.
foreach A = [0, 1] in
foreach B = [0, 1] in
foreach C = [0, 1] in {
  defvar InA = !if(A, (V.VT V.RC:$a),
                     (V.VT (riscv_xr_splat (XLenVT GPR:$a))));
  defvar InB = !if(B, (V.VT V.RC:$b),
                     (V.VT (riscv_xr_splat (XLenVT GPR:$b))));
  defvar InC = !if(C, (V.VT V.RC:$c),
                     (V.VT (riscv_xr_splat (XLenVT GPR:$c))));
  defvar OutA = !if(A, (V.VT V.RC:$a), (XLenVT GPR:$a));
  defvar OutB = !if(B, (V.VT V.RC:$b), (XLenVT GPR:$b));
  defvar OutC = !if(C, (V.VT V.RC:$c), (XLenVT GPR:$c));
  defvar MAC = "PseudoXRMAC" # W # "_";
  defvar NameABC = !if(A, "V", "S") # !if(B, "V", "S") # !if(C, "V", "S");

  // a * b + c
  def : Pat<(V.VT (add (mul InA, InB), InC)),
            (!cast<Instruction>(MAC # NameABC) OutA, OutB, OutC, V.Count)>;

  // Each two-operand form only needs to be emitted once, so they are generated
  // in the iteration with A == 0 (A is the fixed rs1 they don't use).
  if !eq(C, 0) then {
    // a * b = a * b + 0
    def : Pat<(V.VT (mul InA, InB)),
              (!cast<Instruction>(MAC # !if(A, "V", "S") # !if(B, "V", "S") #
                                  "S")
                   OutA, OutB, (XLenVT X0), V.Count)>;
  }
  if !eq(A, 0) then {
    defvar NameSBC = "S" # !if(B, "V", "S") # !if(C, "V", "S");
    // c + b = 1 * b + c
    def : Pat<(V.VT (add InC, InB)),
              (!cast<Instruction>(MAC # NameSBC)
                   XROne, OutB, OutC, V.Count)>;
    // c - b = -1 * b + c
    def : Pat<(V.VT (sub InC, InB)),
              (!cast<Instruction>(MAC # NameSBC)
                   XRMinusOne, OutB, OutC, V.Count)>;
  }
}

// Dot products, for every vector/scalar combination of the sources. The
// reduction's start value (0) is replaced by the scalar it is added to.
foreach A = [0, 1] in
foreach B = [0, 1] in {
  defvar InA = !if(A, (V.VT V.RC:$a),
                     (V.VT (riscv_xr_splat (XLenVT GPR:$a))));
  defvar InB = !if(B, (V.VT V.RC:$b),
                     (V.VT (riscv_xr_splat (XLenVT GPR:$b))));
  defvar OutA = !if(A, (V.VT V.RC:$a), (XLenVT GPR:$a));
  defvar OutB = !if(B, (V.VT V.RC:$b), (XLenVT GPR:$b));
  defvar Dot = !cast<Instruction>("PseudoXRDot" # W # "_" #
                                  !if(A, "V", "S") # !if(B, "V", "S"));

  def : Pat<(add (riscv_xr_dot (XLenVT 0), InA, InB), (XLenVT GPR:$acc)),
            (Dot OutA, OutB, GPR:$acc, V.Count)>;
  def : Pat<(riscv_xr_dot (XLenVT GPR:$acc), InA, InB),
            (Dot OutA, OutB, GPR:$acc, V.Count)>;
}

// An element at a constant index is one register of the block. (insertelt's
// element-type constraint can't be checked against GPR's per-HwMode type, so
// the unconstrained vector_insert is used.)
foreach I = !range(W) in {
  defvar SubReg = !cast<SubRegIndex>("sub_xr" # I);
  def : Pat<(i32 (extractelt (V.VT V.RC:$v), I)),
            (EXTRACT_SUBREG V.RC:$v, SubReg)>;
  def : Pat<(V.VT (vector_insert (V.VT V.RC:$v), (i32 GPR:$x), I)),
            (INSERT_SUBREG V.RC:$v, GPR:$x, SubReg)>;
}

} // foreach V = [XRV8, XRV4]

// A <4 x i32> half of an <8 x i32> is a sub-register of the block, so moving
// halves between the two widths needs no instructions.
let Predicates = [HasVendorXRepeatAny, IsRV32] in {
foreach Half = [0, 1] in {
  defvar SubReg = !cast<SubRegIndex>("sub_xr" # !if(Half, "hi", "lo"));
  defvar Idx = !mul(4, Half);
  def : Pat<(v4i32 (extract_subvector (v8i32 XRVec:$v), (iPTR Idx))),
            (EXTRACT_SUBREG XRVec:$v, SubReg)>;
  def : Pat<(v8i32 (insert_subvector (v8i32 XRVec:$v), (v4i32 XRVec4:$s),
                                     (iPTR Idx))),
            (INSERT_SUBREG XRVec:$v, XRVec4:$s, SubReg)>;
}
def : Pat<(v8i32 (concat_vectors (v4i32 XRVec4:$lo), (v4i32 XRVec4:$hi))),
          (REG_SEQUENCE XRVec, XRVec4:$lo, sub_xrlo, XRVec4:$hi, sub_xrhi)>;
} // Predicates = [HasVendorXRepeatAny, IsRV32]
