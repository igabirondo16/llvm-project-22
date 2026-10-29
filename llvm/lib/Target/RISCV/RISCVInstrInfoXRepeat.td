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

let Predicates = [HasVendorXRepeat, IsRV32], DecoderNamespace = "XRepeat" in {

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def XR_MAC : RVInstR4<0b00, 0b000, OPC_CUSTOM_0, (outs GPR:$rd),
                      (ins GPR:$rs1, GPR:$rs2, GPR:$rs3),
                      "xr.mac", "$rd, $rs1, $rs2, $rs3">,
             Sched<[]>;

// The repeated instruction may be a load or a store, so model REPEAT as
// touching memory and having side effects.
let hasSideEffects = 1, mayLoad = 1, mayStore = 1 in
def XR_REPEAT : XRInstRepeat, Sched<[]>;

} // Predicates = [HasVendorXRepeat, IsRV32], DecoderNamespace = "XRepeat"

//===----------------------------------------------------------------------===//
// Code generation: <8 x i32> in XRVec registers
//===----------------------------------------------------------------------===//

// A v8i32 whose 8 elements are all the same scalar. MAC can read it directly
// from the scalar register (that field just doesn't walk).
def SDT_XRSplat : SDTypeProfile<1, 1, [SDTCisVT<0, v8i32>, SDTCisVT<1, i32>]>;
def riscv_xr_splat : RVSDNode<"XR_SPLAT", SDT_XRSplat>;

// acc + a[0] * b[0] + ... + a[7] * b[7].
def SDT_XRDot : SDTypeProfile<1, 3, [SDTCisVT<0, i32>, SDTCisVT<1, i32>,
                                     SDTCisVT<2, v8i32>, SDTCisVT<3, v8i32>]>;
def riscv_xr_dot : RVSDNode<"XR_DOT", SDT_XRDot>;

let Predicates = [HasVendorXRepeat, IsRV32] in {

// Load/store of a whole XRVec register as eight LW/SW. Used for spills and
// reloads (no free registers for REPEAT's stride/count there) and for stores,
// which REPEAT cannot repeat. Expanded in RISCVExpandPseudoInsts.cpp. $vd is
// early-clobber so the base address never lives in the destination block
// while it is being loaded.
let hasSideEffects = 0, mayLoad = 1, mayStore = 0, Size = 32,
    Constraints = "@earlyclobber $vd" in
def PseudoXRLoad8 : Pseudo<(outs XRVec:$vd),
                           (ins GPRMem:$rs1, simm12_lo:$imm12), []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1, Size = 32 in
def PseudoXRStore8 : Pseudo<(outs),
                            (ins XRVec:$vs, GPRMem:$rs1, simm12_lo:$imm12), []>;

// Vector load: LW of the first element + REPEAT (mask = rd). The address
// register keeps its value and the immediate offset applies, so the elements
// come from rs1+imm12, rs1+imm12+stride, ... $vd is early-clobber because the
// base, stride and count registers are read on every step.
let hasSideEffects = 0, mayLoad = 1, mayStore = 0, Size = 8,
    Constraints = "@earlyclobber $vd" in
def PseudoXRVLoad : Pseudo<(outs XRVec:$vd),
                           (ins GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride,
                                GPR:$count), []>;

// Vector MAC: vd = rs1 * rs2 + rs3, then REPEAT. Each of rs1/rs2/rs3 is either
// an XRVec block (V, its field walks) or a scalar GPR (S, its field stays); the
// REPEAT mask is derived from that when the pseudo is expanded. vd is tied to
// a vector input (preferring rs3), which keeps it apart from the scalar and
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
  def PseudoXRMAC_ # Name
      : Pseudo<(outs XRVec:$vd),
               (ins !if(A, XRVec, GPR):$rs1, !if(B, XRVec, GPR):$rs2,
                    !if(C, XRVec, GPR):$rs3, GPR:$count), []>;
}

// Dot product: rd = rs1 * rs2 + rs3 where rd and rs3 are the same scalar
// accumulator, so neither walks and each step adds one product to it (REPEAT
// mask 0110 when both sources are vectors). Expanded like PseudoXRMAC_*.
foreach A = [0, 1] in
foreach B = [0, 1] in {
  defvar Name = !if(A, "V", "S") # !if(B, "V", "S");
  let hasSideEffects = 0, mayLoad = 0, mayStore = 0, Size = 8,
      Constraints = "$vd = $rs3" in
  def PseudoXRDot_ # Name
      : Pseudo<(outs GPR:$vd),
               (ins !if(A, XRVec, GPR):$rs1, !if(B, XRVec, GPR):$rs2,
                    GPR:$rs3, GPR:$count), []>;
}

defvar XRStride4 = (ADDI (XLenVT X0), 4);
defvar XRCount7 = (ADDI (XLenVT X0), 7);
defvar XROne = (ADDI (XLenVT X0), 1);
defvar XRMinusOne = (ADDI (XLenVT X0), -1);

def : Pat<(v8i32 (load (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12))),
          (PseudoXRVLoad GPRMem:$rs1, simm12_lo:$imm12, XRStride4, XRCount7)>;
def : Pat<(store (v8i32 XRVec:$vs), (XLenVT GPRMem:$rs1)),
          (PseudoXRStore8 XRVec:$vs, GPRMem:$rs1, 0)>;

// A splat on its own: vd[i] = s * 1 + 0.
def : Pat<(v8i32 (riscv_xr_splat (XLenVT GPR:$s))),
          (PseudoXRMAC_SSS GPR:$s, XROne, (XLenVT X0), XRCount7)>;

// Arithmetic, for every vector/scalar combination of the operands.
foreach A = [0, 1] in
foreach B = [0, 1] in
foreach C = [0, 1] in {
  defvar InA = !if(A, (v8i32 XRVec:$a), (riscv_xr_splat (XLenVT GPR:$a)));
  defvar InB = !if(B, (v8i32 XRVec:$b), (riscv_xr_splat (XLenVT GPR:$b)));
  defvar InC = !if(C, (v8i32 XRVec:$c), (riscv_xr_splat (XLenVT GPR:$c)));
  defvar OutA = !if(A, (v8i32 XRVec:$a), (XLenVT GPR:$a));
  defvar OutB = !if(B, (v8i32 XRVec:$b), (XLenVT GPR:$b));
  defvar OutC = !if(C, (v8i32 XRVec:$c), (XLenVT GPR:$c));
  defvar NameABC = !if(A, "V", "S") # !if(B, "V", "S") # !if(C, "V", "S");

  // a * b + c
  def : Pat<(v8i32 (add (mul InA, InB), InC)),
            (!cast<Instruction>("PseudoXRMAC_" # NameABC)
                 OutA, OutB, OutC, XRCount7)>;

  // Each two-operand form only needs to be emitted once, so they are generated
  // in the iteration with A == 0 (A is the fixed rs1 they don't use).
  if !eq(C, 0) then {
    // a * b = a * b + 0
    def : Pat<(v8i32 (mul InA, InB)),
              (!cast<Instruction>("PseudoXRMAC_" # !if(A, "V", "S") #
                                  !if(B, "V", "S") # "S")
                   OutA, OutB, (XLenVT X0), XRCount7)>;
  }
  if !eq(A, 0) then {
    defvar NameSBC = "S" # !if(B, "V", "S") # !if(C, "V", "S");
    // c + b = 1 * b + c
    def : Pat<(v8i32 (add InC, InB)),
              (!cast<Instruction>("PseudoXRMAC_" # NameSBC)
                   XROne, OutB, OutC, XRCount7)>;
    // c - b = -1 * b + c
    def : Pat<(v8i32 (sub InC, InB)),
              (!cast<Instruction>("PseudoXRMAC_" # NameSBC)
                   XRMinusOne, OutB, OutC, XRCount7)>;
  }
}

// Dot products, for every vector/scalar combination of the sources. The
// reduction's start value (0) is replaced by the scalar it is added to.
foreach A = [0, 1] in
foreach B = [0, 1] in {
  defvar InA = !if(A, (v8i32 XRVec:$a), (riscv_xr_splat (XLenVT GPR:$a)));
  defvar InB = !if(B, (v8i32 XRVec:$b), (riscv_xr_splat (XLenVT GPR:$b)));
  defvar OutA = !if(A, (v8i32 XRVec:$a), (XLenVT GPR:$a));
  defvar OutB = !if(B, (v8i32 XRVec:$b), (XLenVT GPR:$b));
  defvar Dot = !cast<Instruction>("PseudoXRDot_" # !if(A, "V", "S") #
                                  !if(B, "V", "S"));

  def : Pat<(add (riscv_xr_dot (XLenVT 0), InA, InB), (XLenVT GPR:$acc)),
            (Dot OutA, OutB, GPR:$acc, XRCount7)>;
  def : Pat<(riscv_xr_dot (XLenVT GPR:$acc), InA, InB),
            (Dot OutA, OutB, GPR:$acc, XRCount7)>;
}

// An element at a constant index is one register of the block. (insertelt's
// element-type constraint can't be checked against GPR's per-HwMode type, so
// the unconstrained vector_insert is used.)
foreach I = 0...7 in {
  defvar SubReg = !cast<SubRegIndex>("sub_xr" # I);
  def : Pat<(i32 (extractelt (v8i32 XRVec:$v), I)),
            (EXTRACT_SUBREG XRVec:$v, SubReg)>;
  def : Pat<(v8i32 (vector_insert (v8i32 XRVec:$v), (i32 GPR:$x), I)),
            (INSERT_SUBREG XRVec:$v, GPR:$x, SubReg)>;
}

} // Predicates = [HasVendorXRepeat, IsRV32]
