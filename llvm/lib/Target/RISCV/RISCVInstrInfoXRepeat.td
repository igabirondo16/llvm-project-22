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

let Predicates = [HasVendorXRepeat, IsRV32] in {

// Load/store of a whole XRVec register as eight LW/SW. Used for vector loads
// and stores, and for spills and reloads. Expanded in
// RISCVExpandPseudoInsts.cpp. $vd is early-clobber so the base address never
// lives in the destination block while it is being loaded.
let hasSideEffects = 0, mayLoad = 1, mayStore = 0, Size = 32,
    Constraints = "@earlyclobber $vd" in
def PseudoXRLoad8 : Pseudo<(outs XRVec:$vd),
                           (ins GPRMem:$rs1, simm12_lo:$imm12), []>;

let hasSideEffects = 0, mayLoad = 0, mayStore = 1, Size = 32 in
def PseudoXRStore8 : Pseudo<(outs),
                            (ins XRVec:$vs, GPRMem:$rs1, simm12_lo:$imm12), []>;

def : Pat<(v8i32 (load (AddrRegImm (XLenVT GPRMem:$rs1), simm12_lo:$imm12))),
          (PseudoXRLoad8 GPRMem:$rs1, simm12_lo:$imm12)>;
def : Pat<(store (v8i32 XRVec:$vs), (XLenVT GPRMem:$rs1)),
          (PseudoXRStore8 XRVec:$vs, GPRMem:$rs1, 0)>;

} // Predicates = [HasVendorXRepeat, IsRV32]
