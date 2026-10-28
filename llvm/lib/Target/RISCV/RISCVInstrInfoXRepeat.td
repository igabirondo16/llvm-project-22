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