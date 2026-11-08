//===-- RISCVInstrInfoXRepeat.td - repeat_rv instructions --*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the two vendor extensions of the repeat_rv cores.
//
// XRepeat (the version under development) targets the core with a second
// register file, the VRF. The VRF is the F extension's register file: f0..f31
// hold floats (standard RV32F) and integers alike, and f0 is an ordinary
// register. Addresses and the REPEAT stride stay in the x registers.
//   - xr.add, xr.sub, ... (custom-1, funct3 000): integer ALU on the VRF.
//   - xr.mac (custom-1, funct3 001): VRF integer rd = rs1 * rs2 + rs3.
//   - xr.mv.vx / xr.mv.xv (custom-1, funct3 010/011): x <-> VRF moves.
//   - xr.lw / xr.sw (custom-1, funct3 100/101): VRF load/store.
//   - xr.addi, xr.slli, ... (custom-3): integer ALU with an immediate.
//   - xr.repeat mask, stride, count (custom-2): re-executes the previous
//     instruction `count` more times. A walking field (mask bit set) gets the
//     iteration number in the low bits of its register number, so a block of
//     4/8/16 registers must start at a multiple of 4/8/16. rs1 holds the
//     stride (bytes) of a repeated load/store; count (0..15) is a literal in
//     the rs2 field.
//   Repeatable: lw/flw/xr.lw, sw/fsw/xr.sw, xr.mac, xr.<alu>, xr.<alu>i,
//   fmadd.s, fadd.s, fsub.s, fmul.s, fmin.s, fmax.s.
//
// XRepeatInt is the original core, frozen (see RISCVFeatures.td):
//   - xr.mac (custom-0): GPR rd = rs1 * rs2 + rs3.
//   - xr.repeat mask, stride, count: rs1 holds the stride and rs2 the count
//     in a register; walking fields count up from x8, x16 or x24.
// The code generation below (vectors in blocks of GPRs) is XRepeatInt's.
//
// The two share opcodes, so they are never enabled together, and same-named
// instructions are told apart by their operands and predicates.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instruction formats
//===----------------------------------------------------------------------===//

// REPEAT fields shared by both versions: mask is funct7[6:3] (bit 0 = rd,
// 1 = rs1, 2 = rs2, 3 = rs3 of the repeated instruction); rd and funct3 are
// always zero.
class XRInstRepeatBase<dag ins, string argstr>
    : RVInst<(outs), ins, "xr.repeat", argstr, [], InstFormatR> {
  bits<4> mask;

  let Inst{31-28} = mask;
  let Inst{27-25} = 0b000;
  let Inst{14-12} = 0b000;
  let Inst{11-7} = 0b00000;
  let Inst{6-0} = OPC_CUSTOM_2.Value;
}

// XRepeatInt: rs1 = stride register, rs2 = count register.
class XRIntInstRepeat
    : XRInstRepeatBase<(ins uimm4:$mask, GPR:$rs1, GPR:$rs2),
                       "$mask, $rs1, $rs2"> {
  bits<5> rs1;
  bits<5> rs2;

  let Inst{24-20} = rs2;
  let Inst{19-15} = rs1;
}

// XRepeat: rs1 = stride register, rs2 field = the literal count (as the
// REPEAT_INSN macro of rvtarget.h: .insn r 0x5B, 0, mask << 3, x0, stride,
// x<count>). The core reads only the low 4 bits of the rs2 field; bit 24 is 0.
class XRInstRepeat
    : XRInstRepeatBase<(ins uimm4:$mask, GPR:$rs1, uimm4:$count),
                       "$mask, $rs1, $count"> {
  bits<5> rs1;
  bits<4> count;

  let Inst{24} = 0;
  let Inst{23-20} = count;
  let Inst{19-15} = rs1;
}

// XRepeat VRF integer ALU, register-register: op in funct7[3:0].
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class XRALU_rr<bits<4> op, string opcodestr>
    : RVInstR<{0b000, op}, 0b000, OPC_CUSTOM_1, (outs FPR32:$rd),
              (ins FPR32:$rs1, FPR32:$rs2), opcodestr, "$rd, $rs1, $rs2">,
      Sched<[]>;

// XRepeat VRF integer ALU with an immediate (custom-3, like OP-IMM).
let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class XRALU_ri<bits<3> funct3, string opcodestr>
    : RVInstI<funct3, OPC_CUSTOM_3, (outs FPR32:$rd),
              (ins FPR32:$rs1, simm12_lo:$imm12), opcodestr,
              "$rd, $rs1, $imm12">,
      Sched<[]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
class XRShift_ri<bits<7> imm11_5, bits<3> funct3, string opcodestr>
    : RVInstIShiftW<imm11_5, funct3, OPC_CUSTOM_3, (outs FPR32:$rd),
                    (ins FPR32:$rs1, uimm5:$shamt), opcodestr,
                    "$rd, $rs1, $shamt">,
      Sched<[]>;

//===----------------------------------------------------------------------===//
// XRepeat instructions (VRF core)
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXRepeat, IsRV32], DecoderNamespace = "XRepeat" in {

def XRV_ADD  : XRALU_rr<0x0, "xr.add">;
def XRV_SLL  : XRALU_rr<0x1, "xr.sll">;
def XRV_SLT  : XRALU_rr<0x2, "xr.slt">;
def XRV_SLTU : XRALU_rr<0x3, "xr.sltu">;
def XRV_XOR  : XRALU_rr<0x4, "xr.xor">;
def XRV_SRL  : XRALU_rr<0x5, "xr.srl">;
def XRV_OR   : XRALU_rr<0x6, "xr.or">;
def XRV_AND  : XRALU_rr<0x7, "xr.and">;
def XRV_SUB  : XRALU_rr<0x8, "xr.sub">;
def XRV_SRA  : XRALU_rr<0xD, "xr.sra">;

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in {
def XRV_MAC : RVInstR4<0b00, 0b001, OPC_CUSTOM_1, (outs FPR32:$rd),
                       (ins FPR32:$rs1, FPR32:$rs2, FPR32:$rs3),
                       "xr.mac", "$rd, $rs1, $rs2, $rs3">,
              Sched<[]>;

let rs2 = 0 in {
def XRV_MV_VX : RVInstR<0b0000000, 0b010, OPC_CUSTOM_1, (outs FPR32:$rd),
                        (ins GPR:$rs1), "xr.mv.vx", "$rd, $rs1">,
                Sched<[]>;
def XRV_MV_XV : RVInstR<0b0000000, 0b011, OPC_CUSTOM_1, (outs GPR:$rd),
                        (ins FPR32:$rs1), "xr.mv.xv", "$rd, $rs1">,
                Sched<[]>;
} // rs2 = 0
} // hasSideEffects = 0, mayLoad = 0, mayStore = 0

let hasSideEffects = 0, mayLoad = 1, mayStore = 0 in
def XRV_LW : RVInstI<0b100, OPC_CUSTOM_1, (outs FPR32:$rd),
                     (ins GPRMem:$rs1, simm12_lo:$imm12),
                     "xr.lw", "$rd, ${imm12}(${rs1})">,
             Sched<[]>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1 in
def XRV_SW : RVInstS<0b101, OPC_CUSTOM_1, (outs),
                     (ins FPR32:$rs2, GPRMem:$rs1, simm12_lo:$imm12),
                     "xr.sw", "$rs2, ${imm12}(${rs1})">,
             Sched<[]>;

def XRV_ADDI  : XRALU_ri<0b000, "xr.addi">;
def XRV_SLTI  : XRALU_ri<0b010, "xr.slti">;
def XRV_SLTIU : XRALU_ri<0b011, "xr.sltiu">;
def XRV_XORI  : XRALU_ri<0b100, "xr.xori">;
def XRV_ORI   : XRALU_ri<0b110, "xr.ori">;
def XRV_ANDI  : XRALU_ri<0b111, "xr.andi">;
def XRV_SLLI  : XRShift_ri<0b0000000, 0b001, "xr.slli">;
def XRV_SRLI  : XRShift_ri<0b0000000, 0b101, "xr.srli">;
def XRV_SRAI  : XRShift_ri<0b0100000, 0b101, "xr.srai">;

// The repeated instruction may be a load or a store, so model REPEAT as
// touching memory and having side effects.
let hasSideEffects = 1, mayLoad = 1, mayStore = 1 in
def XRV_REPEAT : XRInstRepeat, Sched<[]>;

} // Predicates = [HasVendorXRepeat, IsRV32], DecoderNamespace = "XRepeat"

//===----------------------------------------------------------------------===//
// XRepeatInt instructions (original GPR core)
//===----------------------------------------------------------------------===//

let Predicates = [HasVendorXRepeatInt, IsRV32],
    DecoderNamespace = "XRepeatInt" in {

let hasSideEffects = 0, mayLoad = 0, mayStore = 0 in
def XR_MAC : RVInstR4<0b00, 0b000, OPC_CUSTOM_0, (outs GPR:$rd),
                      (ins GPR:$rs1, GPR:$rs2, GPR:$rs3),
                      "xr.mac", "$rd, $rs1, $rs2, $rs3">,
             Sched<[]>;

let hasSideEffects = 1, mayLoad = 1, mayStore = 1 in
def XR_REPEAT : XRIntInstRepeat, Sched<[]>;

} // Predicates = [HasVendorXRepeatInt, IsRV32], DecoderNamespace = ...

//===----------------------------------------------------------------------===//
// XRepeatInt code generation: <8 x i32> in XRVec and <4 x i32> in XRVec4
// registers
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

let Predicates = [HasVendorXRepeatInt, IsRV32] in
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
let Predicates = [HasVendorXRepeatInt, IsRV32] in {
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
} // Predicates = [HasVendorXRepeatInt, IsRV32]

//===----------------------------------------------------------------------===//
// XRepeat code generation (VRF core): <8 x i32>/<8 x float> in XRFVec8 and
// <16 x i32>/<16 x float> in XRFVec16 registers
//===----------------------------------------------------------------------===//

// One XRepeat VRF vector width: its register class and its two types.
class XRFVecInfo<int width, RegisterClass rc, ValueType ivt, ValueType fvt> {
  int Width = width;
  RegisterClass RC = rc;
  ValueType IVT = ivt;
  ValueType FVT = fvt;
  list<ValueType> VTs = [ivt, fvt];
}
def XRFV8 : XRFVecInfo<8, XRFVec8, v8i32, v8f32>;
def XRFV16 : XRFVecInfo<16, XRFVec16, v16i32, v16f32>;

let Predicates = [HasVendorXRepeat, IsRV32] in
foreach V = [XRFV8, XRFV16] in {
defvar W = V.Width;

// Load/store of a whole vector register as one FLW/FSW per element (they move
// the 32 bits unchanged, so integers too). Used for spills and reloads, where
// there is no free register for REPEAT's stride. Expanded in
// RISCVExpandPseudoInsts.cpp.
let hasSideEffects = 0, mayLoad = 1, mayStore = 0, Size = !mul(4, W) in
def PseudoXRFLoad # W : Pseudo<(outs V.RC:$vd),
                               (ins GPRMem:$rs1, simm12_lo:$imm12), []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1, Size = !mul(4, W) in
def PseudoXRFStore # W : Pseudo<(outs),
                                (ins V.RC:$vs, GPRMem:$rs1, simm12_lo:$imm12),
                                []>;

} // foreach V = [XRFV8, XRFV16]

//===----------------------------------------------------------------------===//
// XRepeat VRF code generation: one instruction + REPEAT per vector operation
//===----------------------------------------------------------------------===//

// A vector whose elements are all the same scalar (an i32 in an x register or
// an f32 in an f register). As an operand of a repeated instruction it is a
// fixed field (mask bit clear) holding the scalar in an f register. (The
// element-type constraint can't be checked against GPR's per-HwMode type; the
// patterns give both types.)
def SDT_XRFSplat : SDTypeProfile<1, 1, [SDTCisVec<0>]>;
def riscv_xrf_splat : RVSDNode<"XRF_SPLAT", SDT_XRFSplat>;

// An ordered float sum: start + v[0] + v[1] + ... (TargetSelectionDAG.td has
// no node for it).
// Strided load and store (VRF core): element i is at ptr + i * stride (bytes,
// in a register). flw/fsw + REPEAT with that stride register; the REPEATed
// address advances by it on loads and stores alike. Lowered from
// llvm.experimental.vp.strided.{load,store}, which SLP emits and
// RISCVInterleavedAccess.cpp emits for each field of an interleave group.
def SDT_XRFStridedLoad : SDTypeProfile<1, 2, [SDTCisVec<0>, SDTCisPtrTy<1>,
                                              SDTCisVT<2, i32>]>;
def riscv_xrf_strided_load
    : RVSDNode<"XRF_STRIDED_LOAD", SDT_XRFStridedLoad,
               [SDNPHasChain, SDNPMayLoad, SDNPMemOperand]>;
def SDT_XRFStridedStore : SDTypeProfile<0, 3, [SDTCisVec<0>, SDTCisPtrTy<1>,
                                               SDTCisVT<2, i32>]>;
def riscv_xrf_strided_store
    : RVSDNode<"XRF_STRIDED_STORE", SDT_XRFStridedStore,
               [SDNPHasChain, SDNPMayStore, SDNPMemOperand]>;

// Integer add reductions chained through one f register (the accumulator
// holds i32 bits; see combineXRFVecReduceAdd): acc + reduce(v), and
// acc + reduce(a * b).
def riscv_xrf_addred
    : RVSDNode<"XRF_ADDRED", SDTypeProfile<1, 2, [SDTCisVT<0, f32>,
                                                  SDTCisVT<1, f32>,
                                                  SDTCisVec<2>]>>;
def riscv_xrf_macred
    : RVSDNode<"XRF_MACRED", SDTypeProfile<1, 3, [SDTCisVT<0, f32>,
                                                  SDTCisVT<1, f32>,
                                                  SDTCisVec<2>,
                                                  SDTCisSameAs<2, 3>]>>;

def riscv_xrf_vecreduce_seq_fadd
    : SDNode<"ISD::VECREDUCE_SEQ_FADD",
             SDTypeProfile<1, 2, [SDTCisFP<0>, SDTCisSameAs<0, 1>,
                                  SDTCisVec<2>]>>;

// The fmul and the ordered reduction the loop vectorizer makes from an
// llvm.fmuladd reduction, when it marks them `contract`
// (TTI::preferFusedFMulAddReduction): they may be fused back into one fmadd.s
// + REPEAT that accumulates in order.
def riscv_xrf_fmul_contract
    : PatFrag<(ops node:$a, node:$b), (fmul node:$a, node:$b), [{
  return N->getFlags().hasAllowContract();
}]>;
def riscv_xrf_seq_fadd_contract
    : PatFrag<(ops node:$s, node:$v),
              (riscv_xrf_vecreduce_seq_fadd node:$s, node:$v), [{
  return N->getFlags().hasAllowContract();
}]>;

// PseudoXRF_<Base>_<W>_<kinds>: Base (an instruction on single f registers)
// applied to whole VRF vectors as Base + REPEAT. The pseudo has Base's operands
// in Base's order; each f-register operand is either a vector register (its
// field walks) or a single f register (its field stays fixed), as listed by
// <kinds> (V/S per source; a vector result always walks). Loads and stores
// take the stride register as an extra last operand. Expanded after
// scheduling in RISCVExpandPseudoInsts.cpp, which derives the REPEAT mask from
// the operands' register classes.
//
// Register constraints: vector operands are aligned blocks of one width, so a
// vector result and a vector source are either the same block or disjoint, and
// any assignment works when every source is a vector. A single register,
// though, must not be in the result's block, where a later step would read it
// after an earlier step overwrote it: the result is tied to a vector source
// (which is live until the instruction, so it can't hold the single register
// unless that is one of its own elements, which the expansion handles with an
// element-by-element fallback), or is early-clobber when there is no vector
// source. Size covers the fallback.
class XRFRepeatPseudo<Instruction base, int numElts, bit isLoad, bit isStore,
                      dag outs, dag ins, string constraints>
    : Pseudo<outs, ins, []> {
  Pseudo Pseudo = !cast<Pseudo>(NAME);
  Instruction BaseInstr = base;
  bits<5> NumElts = numElts;
  bit IsStore = isStore;
  bit HasStride = !or(isLoad, isStore);
  let hasSideEffects = 0;
  let mayLoad = isLoad;
  let mayStore = isStore;
  let Size = !mul(4, numElts);
  let Constraints = constraints;
}

def XRFRepeatPseudosTable : GenericTable {
  let FilterClass = "XRFRepeatPseudo";
  let CppTypeName = "XRFRepeatPseudoInfo";
  let Fields = ["Pseudo", "BaseInstr", "NumElts", "IsStore", "HasStride"];
  let PrimaryKey = ["Pseudo"];
  let PrimaryKeyName = "getXRFRepeatPseudoInfo";
}

// "V" or "S" for each source of a pseudo.
class XRFKinds<list<bit> isVec> {
  string Name = !foldl("", isVec, acc, v, acc # !if(v, "V", "S"));
}

// The constraint for a pseudo whose sources $rs1, $rs2, ... are vectors as
// given by isVec: none if all are, else tie the result to the last vector
// source, else early-clobber.
class XRFConstraint<list<bit> isVec> {
  int LastVec = !foldl(0, !range(!size(isVec)), acc, i,
                       !if(isVec[i], !add(i, 1), acc));
  string Str = !cond(!eq(!foldl(1, isVec, acc, v, !and(acc, v)), 1) : "",
                     !eq(LastVec, 0) : "@earlyclobber $rd",
                     true : "$rd = $rs" # LastVec);
}

// Whether a three-source instruction with the given vector sources fits in
// the 32 f registers: every source is live at the instruction, and a 16-wide
// vector takes half of them, so at 16 wide at most one source is a vector.
// (Two 16-wide vectors plus anything else can't be allocated; those operations
// are split or scalarized instead, see lowerXRepeatVRFOperation.)
class XRFFits<int width, list<bit> isVec> {
  bit Val = !or(!eq(width, 8),
                !le(!foldl(0, isVec, acc, v, !add(acc, v)), 1));
}

// A source operand: a vector register or a single f register.
class XRFSrc<XRFVecInfo V, bit isVec> {
  RegisterClass RC = !if(isVec, V.RC, FPR32);
}

// Integer ALU with an immediate: the instruction and its immediate operand.
class XRFIntRIOp<Instruction base, SDPatternOperator op, Operand imm> {
  Instruction Base = base;
  SDPatternOperator Op = op;
  Operand Imm = imm;
}
defvar XRFIntRI = [XRFIntRIOp<XRV_ADDI, add, simm12_lo>,
                   XRFIntRIOp<XRV_ANDI, and, simm12_lo>,
                   XRFIntRIOp<XRV_ORI, or, simm12_lo>,
                   XRFIntRIOp<XRV_XORI, xor, simm12_lo>,
                   XRFIntRIOp<XRV_SLLI, shl, uimm5>,
                   XRFIntRIOp<XRV_SRLI, srl, uimm5>,
                   XRFIntRIOp<XRV_SRAI, sra, uimm5>];

// Two-source instructions and the operation they implement.
class XRFRROp<Instruction base, SDPatternOperator op> {
  Instruction Base = base;
  SDPatternOperator Op = op;
}
defvar XRFIntRR = [XRFRROp<XRV_ADD, add>, XRFRROp<XRV_SUB, sub>,
                   XRFRROp<XRV_AND, and>, XRFRROp<XRV_OR, or>,
                   XRFRROp<XRV_XOR, xor>, XRFRROp<XRV_SLL, shl>,
                   XRFRROp<XRV_SRL, srl>, XRFRROp<XRV_SRA, sra>];
defvar XRFFloatRR = [XRFRROp<FADD_S, fadd>, XRFRROp<FSUB_S, fsub>,
                     XRFRROp<FMUL_S, fmul>];
// fmin.s/fmax.s have no rounding mode. They implement both LLVM's
// minnum/maxnum and minimumnum/maximumnum (IEEE 754-2019 minimumNumber/
// maximumNumber, -0.0 < +0.0), as for scalars (RISCVInstrInfoF.td).
defvar XRFFloatMinMax = [XRFRROp<FMIN_S, fminnum>, XRFRROp<FMAX_S, fmaxnum>,
                         XRFRROp<FMIN_S, fminimumnum>,
                         XRFRROp<FMAX_S, fmaximumnum>];

// A zero in an f register: the addend of a multiply.
defvar XRFZero = (XRV_MV_VX (XLenVT X0));

let Predicates = [HasVendorXRepeat, IsRV32] in
foreach V = [XRFV8, XRFV16] in {
defvar W = V.Width;
defvar P = "PseudoXRF_";

//===-- Pseudos --===//

// Loads (FLW: the result always walks) and stores (FSW of a vector, or of one
// register to every element).
def P # FLW_ # W
    : XRFRepeatPseudo<FLW, W, 1, 0, (outs V.RC:$rd),
                      (ins GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride), "">;
foreach A = [0, 1] in
def P # FSW_ # W # _ # XRFKinds<[A]>.Name
    : XRFRepeatPseudo<FSW, W, 0, 1, (outs),
                      (ins XRFSrc<V, A>.RC:$rs2, GPRMem:$rs1,
                           simm12_lo:$imm12, GPR:$stride), "">;

foreach A = [0, 1] in {
  defvar K1 = XRFKinds<[A]>.Name;
  foreach O = XRFIntRI in
  def P # O.Base # _ # W # _ # K1
      : XRFRepeatPseudo<O.Base, W, 0, 0, (outs V.RC:$rd),
                        (ins XRFSrc<V, A>.RC:$rs1, O.Imm:$imm),
                        XRFConstraint<[A]>.Str>;

  foreach B = [0, 1] in {
    defvar K2 = XRFKinds<[A, B]>.Name;
    defvar C2 = XRFConstraint<[A, B]>.Str;
    foreach O = XRFIntRR in
    def P # O.Base # _ # W # _ # K2
        : XRFRepeatPseudo<O.Base, W, 0, 0, (outs V.RC:$rd),
                          (ins XRFSrc<V, A>.RC:$rs1, XRFSrc<V, B>.RC:$rs2),
                          C2>;
    let Uses = [FRM], mayRaiseFPException = true in
    foreach O = XRFFloatRR in
    def P # O.Base # _ # W # _ # K2
        : XRFRepeatPseudo<O.Base, W, 0, 0, (outs V.RC:$rd),
                          (ins XRFSrc<V, A>.RC:$rs1, XRFSrc<V, B>.RC:$rs2,
                               frmarg:$frm), C2>;
    let mayRaiseFPException = true in
    foreach Base = [FMIN_S, FMAX_S] in
    def P # Base # _ # W # _ # K2
        : XRFRepeatPseudo<Base, W, 0, 0, (outs V.RC:$rd),
                          (ins XRFSrc<V, A>.RC:$rs1, XRFSrc<V, B>.RC:$rs2),
                          C2>;

    foreach C = [0, 1] in
    if XRFFits<W, [A, B, C]>.Val then {
      defvar K3 = XRFKinds<[A, B, C]>.Name;
      defvar C3 = XRFConstraint<[A, B, C]>.Str;
      def P # XRV_MAC_ # W # _ # K3
          : XRFRepeatPseudo<XRV_MAC, W, 0, 0, (outs V.RC:$rd),
                            (ins XRFSrc<V, A>.RC:$rs1, XRFSrc<V, B>.RC:$rs2,
                                 XRFSrc<V, C>.RC:$rs3), C3>;
      let Uses = [FRM], mayRaiseFPException = true in
      def P # FMADD_S_ # W # _ # K3
          : XRFRepeatPseudo<FMADD_S, W, 0, 0, (outs V.RC:$rd),
                            (ins XRFSrc<V, A>.RC:$rs1, XRFSrc<V, B>.RC:$rs2,
                                 XRFSrc<V, C>.RC:$rs3, frmarg:$frm), C3>;
    }
  }
}

// Reductions: the result is a single f register tied to the accumulator
// source, so it stays fixed and every step adds into it, in element order
// (mask 0100: only the vector walks; MAC: mask 0110, a dot product).
def P # XRV_ADD_ # W # _RED
    : XRFRepeatPseudo<XRV_ADD, W, 0, 0, (outs FPR32:$rd),
                      (ins FPR32:$rs1, V.RC:$rs2), "$rd = $rs1">;
let Uses = [FRM], mayRaiseFPException = true in
def P # FADD_S_ # W # _RED
    : XRFRepeatPseudo<FADD_S, W, 0, 0, (outs FPR32:$rd),
                      (ins FPR32:$rs1, V.RC:$rs2, frmarg:$frm), "$rd = $rs1">;
foreach AB = [[1, 1], [1, 0], [0, 1]] in
if XRFFits<W, AB # [0]>.Val then {
def P # XRV_MAC_ # W # _RED_ # XRFKinds<AB>.Name
    : XRFRepeatPseudo<XRV_MAC, W, 0, 0, (outs FPR32:$rd),
                      (ins XRFSrc<V, AB[0]>.RC:$rs1, XRFSrc<V, AB[1]>.RC:$rs2,
                           FPR32:$rs3), "$rd = $rs3">;
// An ordered float dot product, fused: fmadd.s mask 0110.
let Uses = [FRM], mayRaiseFPException = true in
def P # FMADD_S_ # W # _RED_ # XRFKinds<AB>.Name
    : XRFRepeatPseudo<FMADD_S, W, 0, 0, (outs FPR32:$rd),
                      (ins XRFSrc<V, AB[0]>.RC:$rs1, XRFSrc<V, AB[1]>.RC:$rs2,
                           FPR32:$rs3, frmarg:$frm), "$rd = $rs3">;
}

//===-- Patterns --===//

// Each source is a vector (V) or a splat (S). An f32 splat is of an f register.
// An i32 splat is of an x register when it is a constant (the immediate forms
// need it there; otherwise it is moved in with xr.mv.vx), and of the i32's bits
// in an f register otherwise (lowerXRepeatVRFOperation bitcasts it, so a
// loaded scalar is loaded with flw and a vector element is used in place).
defvar IVT = V.IVT;
defvar FVT = V.FVT;

foreach VT = V.VTs in {
  def : Pat<(VT (load (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12))),
            (!cast<Instruction>(P # FLW_ # W)
                 GPRMem:$rs1, simm12_lo:$imm12, XRStride4)>;
  def : Pat<(store (VT V.RC:$vs),
                   (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12)),
            (!cast<Instruction>(P # FSW_ # W # _V)
                 V.RC:$vs, GPRMem:$rs1, simm12_lo:$imm12, XRStride4)>;
  def : Pat<(store (VT (riscv_xrf_splat (f32 FPR32:$s))),
                   (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12)),
            (!cast<Instruction>(P # FSW_ # W # _S)
                 FPR32:$s, GPRMem:$rs1, simm12_lo:$imm12, XRStride4)>;
  // The same with any stride register.
  def : Pat<(VT (riscv_xrf_strided_load
                    (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12),
                    (XLenVT GPR:$stride))),
            (!cast<Instruction>(P # FLW_ # W)
                 GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride)>;
  def : Pat<(riscv_xrf_strided_store
                (VT V.RC:$vs),
                (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12),
                (XLenVT GPR:$stride)),
            (!cast<Instruction>(P # FSW_ # W # _V)
                 V.RC:$vs, GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride)>;
  def : Pat<(riscv_xrf_strided_store
                (VT (riscv_xrf_splat (f32 FPR32:$s))),
                (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12),
                (XLenVT GPR:$stride)),
            (!cast<Instruction>(P # FSW_ # W # _S)
                 FPR32:$s, GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride)>;
}
def : Pat<(store (IVT (riscv_xrf_splat (XLenVT GPR:$s))),
                 (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12)),
          (!cast<Instruction>(P # FSW_ # W # _S)
               (XRV_MV_VX GPR:$s), GPRMem:$rs1, simm12_lo:$imm12, XRStride4)>;
def : Pat<(riscv_xrf_strided_store
              (IVT (riscv_xrf_splat (XLenVT GPR:$s))),
              (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12),
              (XLenVT GPR:$stride)),
          (!cast<Instruction>(P # FSW_ # W # _S)
               (XRV_MV_VX GPR:$s), GPRMem:$rs1, simm12_lo:$imm12, GPR:$stride)>;

// A splat on its own: vd[i] = s + 0.
defvar AddI_S = !cast<Instruction>(P # XRV_ADDI_ # W # _S);
def : Pat<(IVT (riscv_xrf_splat (XLenVT GPR:$s))),
          (AddI_S (XRV_MV_VX GPR:$s), 0)>;
foreach VT = V.VTs in
def : Pat<(VT (riscv_xrf_splat (f32 FPR32:$s))), (AddI_S FPR32:$s, 0)>;

// Integer ALU with an immediate, preferred to a splat of the constant.
let AddedComplexity = 1 in
foreach O = XRFIntRI in
def : Pat<(IVT (O.Op (IVT V.RC:$a),
                     (IVT (riscv_xrf_splat (XLenVT O.Imm:$imm))))),
          (!cast<Instruction>(P # O.Base # _ # W # _V) V.RC:$a, O.Imm:$imm)>;

// Integer sources: 1 = vector, 0 = splat of an x register, 2 = splat of an f
// register.
foreach A = [0, 1, 2] in
foreach B = [0, 1, 2] in
foreach C = [0, 1, 2] in {
  defvar VA = !eq(A, 1);
  defvar VB = !eq(B, 1);
  defvar VC = !eq(C, 1);
  defvar IA = !cond(!eq(A, 1) : (IVT V.RC:$a),
                    !eq(A, 0) : (IVT (riscv_xrf_splat (XLenVT GPR:$a))),
                    true : (IVT (riscv_xrf_splat (f32 FPR32:$a))));
  defvar IB = !cond(!eq(B, 1) : (IVT V.RC:$b),
                    !eq(B, 0) : (IVT (riscv_xrf_splat (XLenVT GPR:$b))),
                    true : (IVT (riscv_xrf_splat (f32 FPR32:$b))));
  defvar IC = !cond(!eq(C, 1) : (IVT V.RC:$c),
                    !eq(C, 0) : (IVT (riscv_xrf_splat (XLenVT GPR:$c))),
                    true : (IVT (riscv_xrf_splat (f32 FPR32:$c))));
  defvar OA = !cond(!eq(A, 1) : (IVT V.RC:$a), !eq(A, 0) : (XRV_MV_VX GPR:$a),
                    true : (f32 FPR32:$a));
  defvar OB = !cond(!eq(B, 1) : (IVT V.RC:$b), !eq(B, 0) : (XRV_MV_VX GPR:$b),
                    true : (f32 FPR32:$b));
  defvar OC = !cond(!eq(C, 1) : (IVT V.RC:$c), !eq(C, 0) : (XRV_MV_VX GPR:$c),
                    true : (f32 FPR32:$c));
  defvar K2 = XRFKinds<[VA, VB]>.Name;
  defvar K3 = XRFKinds<[VA, VB, VC]>.Name;

  // a * b + c, and a * b = a * b + 0.
  if XRFFits<W, [VA, VB, VC]>.Val then
  def : Pat<(IVT (add (mul IA, IB), IC)),
            (!cast<Instruction>(P # XRV_MAC_ # W # _ # K3) OA, OB, OC)>;

  // The two-source forms only need to be generated once.
  if !eq(C, 0) then {
    if XRFFits<W, [VA, VB, 0]>.Val then
    def : Pat<(IVT (mul IA, IB)),
              (!cast<Instruction>(P # XRV_MAC_ # W # _ # K2 # S)
                   OA, OB, XRFZero)>;
    foreach O = XRFIntRR in
    def : Pat<(IVT (O.Op IA, IB)),
              (!cast<Instruction>(P # O.Base # _ # W # _ # K2) OA, OB)>;
  }
}

// Float sources: 1 = vector, 0 = splat of an f register.
foreach A = [0, 1] in
foreach B = [0, 1] in
foreach C = [0, 1] in {
  defvar FA = !if(A, (FVT V.RC:$a), (FVT (riscv_xrf_splat (f32 FPR32:$a))));
  defvar FB = !if(B, (FVT V.RC:$b), (FVT (riscv_xrf_splat (f32 FPR32:$b))));
  defvar FC = !if(C, (FVT V.RC:$c), (FVT (riscv_xrf_splat (f32 FPR32:$c))));
  defvar OFA = !if(A, (FVT V.RC:$a), (f32 FPR32:$a));
  defvar OFB = !if(B, (FVT V.RC:$b), (f32 FPR32:$b));
  defvar OFC = !if(C, (FVT V.RC:$c), (f32 FPR32:$c));

  if XRFFits<W, [A, B, C]>.Val then
  def : Pat<(FVT (any_fma FA, FB, FC)),
            (!cast<Instruction>(P # FMADD_S_ # W # _ # XRFKinds<[A, B, C]>.Name)
                 OFA, OFB, OFC, FRM_DYN)>;

  if !eq(C, 0) then {
    foreach O = XRFFloatRR in
    def : Pat<(FVT (O.Op FA, FB)),
              (!cast<Instruction>(P # O.Base # _ # W # _ #
                                  XRFKinds<[A, B]>.Name)
                   OFA, OFB, FRM_DYN)>;
    foreach O = XRFFloatMinMax in
    def : Pat<(FVT (O.Op FA, FB)),
              (!cast<Instruction>(P # O.Base # _ # W # _ #
                                  XRFKinds<[A, B]>.Name)
                   OFA, OFB)>;
  }
}

// Reductions, accumulating into a single f register: integer sums start at
// 0 and move the result back to an x register; float sums start at the start
// value (an unordered sum is done in order too, from -0.0, the identity).
defvar AddRed = !cast<Instruction>(P # XRV_ADD_ # W # _RED);
defvar FAddRed = !cast<Instruction>(P # FADD_S_ # W # _RED);
def : Pat<(XLenVT (vecreduce_add (IVT V.RC:$v))),
          (XRV_MV_XV (AddRed XRFZero, V.RC:$v))>;
// An i32 accumulator that RISCVCodeGenPrepare keeps in an f register across
// the loop (bitcast to f32): the sum goes straight into it.
def : Pat<(f32 (bitconvert (XLenVT (add (XLenVT (bitconvert (f32 FPR32:$acc))),
                                     (vecreduce_add (IVT V.RC:$v)))))),
          (AddRed FPR32:$acc, V.RC:$v)>;
def : Pat<(f32 (riscv_xrf_addred (f32 FPR32:$acc), (IVT V.RC:$v))),
          (AddRed FPR32:$acc, V.RC:$v)>;
def : Pat<(f32 (riscv_xrf_vecreduce_seq_fadd (f32 FPR32:$s), (FVT V.RC:$v))),
          (FAddRed FPR32:$s, V.RC:$v, FRM_DYN)>;
def : Pat<(f32 (fadd (f32 FPR32:$s), (f32 (vecreduce_fadd (FVT V.RC:$v))))),
          (FAddRed FPR32:$s, V.RC:$v, FRM_DYN)>;
def : Pat<(f32 (vecreduce_fadd (FVT V.RC:$v))),
          (FAddRed (FMV_W_X (LUI 0x80000)), V.RC:$v, FRM_DYN)>;
// A contractable ordered sum of products (see riscv_xrf_fmul_contract): one
// fmadd.s into the accumulator. Float sources: 1 = vector, 0 = splat.
foreach AB = [[1, 1], [1, 0], [0, 1]] in
if XRFFits<W, AB # [0]>.Val then {
  defvar FA = !if(AB[0], (FVT V.RC:$a), (FVT (riscv_xrf_splat (f32 FPR32:$a))));
  defvar FB = !if(AB[1], (FVT V.RC:$b), (FVT (riscv_xrf_splat (f32 FPR32:$b))));
  defvar OFA = !if(AB[0], (FVT V.RC:$a), (f32 FPR32:$a));
  defvar OFB = !if(AB[1], (FVT V.RC:$b), (f32 FPR32:$b));
  let AddedComplexity = 2 in
  def : Pat<(f32 (riscv_xrf_seq_fadd_contract
                     (f32 FPR32:$s), (FVT (riscv_xrf_fmul_contract FA, FB)))),
            (!cast<Instruction>(P # FMADD_S_ # W # _RED_ # XRFKinds<AB>.Name)
                 OFA, OFB, FPR32:$s, FRM_DYN)>;
}
// A dot product: one MAC into the accumulator.
// (Sources as for the integer operations above; at least one is a vector.)
foreach A = [0, 1, 2] in
foreach B = [0, 1, 2] in
if !and(!or(!eq(A, 1), !eq(B, 1)),
        XRFFits<W, [!eq(A, 1), !eq(B, 1), 0]>.Val) then {
  defvar IA = !cond(!eq(A, 1) : (IVT V.RC:$a),
                    !eq(A, 0) : (IVT (riscv_xrf_splat (XLenVT GPR:$a))),
                    true : (IVT (riscv_xrf_splat (f32 FPR32:$a))));
  defvar IB = !cond(!eq(B, 1) : (IVT V.RC:$b),
                    !eq(B, 0) : (IVT (riscv_xrf_splat (XLenVT GPR:$b))),
                    true : (IVT (riscv_xrf_splat (f32 FPR32:$b))));
  defvar OA = !cond(!eq(A, 1) : (IVT V.RC:$a), !eq(A, 0) : (XRV_MV_VX GPR:$a),
                    true : (f32 FPR32:$a));
  defvar OB = !cond(!eq(B, 1) : (IVT V.RC:$b), !eq(B, 0) : (XRV_MV_VX GPR:$b),
                    true : (f32 FPR32:$b));
  defvar Red = !cast<Instruction>(P # XRV_MAC_ # W # _RED_ #
                                  XRFKinds<[!eq(A, 1), !eq(B, 1)]>.Name);
  def : Pat<(XLenVT (vecreduce_add (IVT (mul IA, IB)))),
            (XRV_MV_XV (Red OA, OB, XRFZero))>;
  def : Pat<(f32 (bitconvert (XLenVT (add (XLenVT (bitconvert (f32 FPR32:$acc))),
                                       (vecreduce_add (IVT (mul IA, IB))))))),
            (Red OA, OB, FPR32:$acc)>;
  def : Pat<(f32 (riscv_xrf_macred (f32 FPR32:$acc), IA, IB)),
            (Red OA, OB, FPR32:$acc)>;
}

// An element at a constant index is one f register of the block; an i32
// element moves to or from an x register. (extractelt/insertelt's element-type
// constraint can't be checked against GPR's per-HwMode type, so the
// unconstrained vector_extract/vector_insert are used for i32.)
foreach I = !range(W) in {
  defvar SubReg = !cast<SubRegIndex>("sub_xrf" # I);
  def : Pat<(f32 (extractelt (FVT V.RC:$v), I)),
            (f32 (EXTRACT_SUBREG V.RC:$v, SubReg))>;
  def : Pat<(XLenVT (vector_extract (IVT V.RC:$v), I)),
            (XRV_MV_XV (f32 (EXTRACT_SUBREG V.RC:$v, SubReg)))>;
  def : Pat<(FVT (insertelt (FVT V.RC:$v), (f32 FPR32:$x), I)),
            (INSERT_SUBREG V.RC:$v, FPR32:$x, SubReg)>;
  def : Pat<(IVT (vector_insert (IVT V.RC:$v), (XLenVT GPR:$x), I)),
            (INSERT_SUBREG V.RC:$v, (XRV_MV_VX GPR:$x), SubReg)>;
}

} // foreach V = [XRFV8, XRFV16]
