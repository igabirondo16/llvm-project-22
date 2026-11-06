# Encodings computed from .custom_repeat_inst/ENCODINGS.md (VRF core).
# RUN: llvm-mc -triple=riscv32 --mattr=+xrepeat -M no-aliases -show-encoding %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INSTR
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xrepeat < %s \
# RUN:     | llvm-objdump --mattr=+xrepeat --no-print-imm-hex -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-INSTR %s
# RUN: not llvm-mc -triple riscv32 %s 2>&1 \
# RUN:     | FileCheck -check-prefix=CHECK-NO-EXT %s

# vrf[8] = vrf[16] add vrf[24]
xr.add f8, f16, f24
# CHECK-INSTR: xr.add fs0, fa6, fs8
# CHECK-ENCODING: [0x2b,0x04,0x88,0x01]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[0] = vrf[1] sll vrf[2]
xr.sll f0, f1, f2
# CHECK-INSTR: xr.sll ft0, ft1, ft2
# CHECK-ENCODING: [0x2b,0x80,0x20,0x02]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[31] = vrf[30] slt vrf[29]
xr.slt f31, f30, f29
# CHECK-INSTR: xr.slt ft11, ft10, ft9
# CHECK-ENCODING: [0xab,0x0f,0xdf,0x05]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[16] = vrf[8] sltu vrf[0]
xr.sltu f16, f8, f0
# CHECK-INSTR: xr.sltu fa6, fs0, ft0
# CHECK-ENCODING: [0x2b,0x08,0x04,0x06]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[24] = vrf[25] xor vrf[26]
xr.xor f24, f25, f26
# CHECK-INSTR: xr.xor fs8, fs9, fs10
# CHECK-ENCODING: [0x2b,0x8c,0xac,0x09]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[1] = vrf[9] srl vrf[17]
xr.srl f1, f9, f17
# CHECK-INSTR: xr.srl ft1, fs1, fa7
# CHECK-ENCODING: [0xab,0x80,0x14,0x0b]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[2] = vrf[10] or vrf[18]
xr.or f2, f10, f18
# CHECK-INSTR: xr.or ft2, fa0, fs2
# CHECK-ENCODING: [0x2b,0x01,0x25,0x0d]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[3] = vrf[11] and vrf[19]
xr.and f3, f11, f19
# CHECK-INSTR: xr.and ft3, fa1, fs3
# CHECK-ENCODING: [0xab,0x81,0x35,0x0f]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[4] = vrf[12] sub vrf[20]
xr.sub f4, f12, f20
# CHECK-INSTR: xr.sub ft4, fa2, fs4
# CHECK-ENCODING: [0x2b,0x02,0x46,0x11]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[5] = vrf[13] sra vrf[21]
xr.sra f5, f13, f21
# CHECK-INSTR: xr.sra ft5, fa3, fs5
# CHECK-ENCODING: [0xab,0x82,0x56,0x1b]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[8] = vrf[16] * vrf[24] + vrf[8]
xr.mac f8, f16, f24, f8
# CHECK-INSTR: xr.mac fs0, fa6, fs8, fs0
# CHECK-ENCODING: [0x2b,0x14,0x88,0x41]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[0] = vrf[0] * vrf[0] + vrf[0]
xr.mac f0, f0, f0, f0
# CHECK-INSTR: xr.mac ft0, ft0, ft0, ft0
# CHECK-ENCODING: [0x2b,0x10,0x00,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[31] = vrf[1] * vrf[17] + vrf[30]
xr.mac f31, f1, f17, f30
# CHECK-INSTR: xr.mac ft11, ft1, fa7, ft10
# CHECK-ENCODING: [0xab,0x9f,0x10,0xf1]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[3] = a0
xr.mv.vx f3, a0
# CHECK-INSTR: xr.mv.vx ft3, a0
# CHECK-ENCODING: [0xab,0x21,0x05,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[0] = zero
xr.mv.vx f0, zero
# CHECK-INSTR: xr.mv.vx ft0, zero
# CHECK-ENCODING: [0x2b,0x20,0x00,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# a1 = vrf[20]
xr.mv.xv a1, f20
# CHECK-INSTR: xr.mv.xv a1, fs4
# CHECK-ENCODING: [0xab,0x35,0x0a,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[5] = mem[a0 + 12]
xr.lw f5, 12(a0)
# CHECK-INSTR: xr.lw ft5, 12(a0)
# CHECK-ENCODING: [0xab,0x42,0xc5,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[31] = mem[sp - 2048]
xr.lw f31, -2048(sp)
# CHECK-INSTR: xr.lw ft11, -2048(sp)
# CHECK-ENCODING: [0xab,0x4f,0x01,0x80]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# mem[sp - 8] = vrf[6]
xr.sw f6, -8(sp)
# CHECK-INSTR: xr.sw ft6, -8(sp)
# CHECK-ENCODING: [0x2b,0x5c,0x61,0xfe]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# mem[a2 + 2047] = vrf[16]
xr.sw f16, 2047(a2)
# CHECK-INSTR: xr.sw fa6, 2047(a2)
# CHECK-ENCODING: [0xab,0x5f,0x06,0x7f]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[7] = vrf[9] addi -1
xr.addi f7, f9, -1
# CHECK-INSTR: xr.addi ft7, fs1, -1
# CHECK-ENCODING: [0xfb,0x83,0xf4,0xff]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[7] = vrf[9] slti 100
xr.slti f7, f9, 100
# CHECK-INSTR: xr.slti ft7, fs1, 100
# CHECK-ENCODING: [0xfb,0xa3,0x44,0x06]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[7] = vrf[9] sltiu 2047
xr.sltiu f7, f9, 2047
# CHECK-INSTR: xr.sltiu ft7, fs1, 2047
# CHECK-ENCODING: [0xfb,0xb3,0xf4,0x7f]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[7] = vrf[9] xori -2048
xr.xori f7, f9, -2048
# CHECK-INSTR: xr.xori ft7, fs1, -2048
# CHECK-ENCODING: [0xfb,0xc3,0x04,0x80]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[7] = vrf[9] ori 255
xr.ori f7, f9, 255
# CHECK-INSTR: xr.ori ft7, fs1, 255
# CHECK-ENCODING: [0xfb,0xe3,0xf4,0x0f]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[7] = vrf[9] andi 15
xr.andi f7, f9, 15
# CHECK-INSTR: xr.andi ft7, fs1, 15
# CHECK-ENCODING: [0xfb,0xf3,0xf4,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[1] = vrf[1] slli 31
xr.slli f1, f1, 31
# CHECK-INSTR: xr.slli ft1, ft1, 31
# CHECK-ENCODING: [0xfb,0x90,0xf0,0x01]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[1] = vrf[1] srli 1
xr.srli f1, f1, 1
# CHECK-INSTR: xr.srli ft1, ft1, 1
# CHECK-ENCODING: [0xfb,0xd0,0x10,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# vrf[1] = vrf[1] srai 3
xr.srai f1, f1, 3
# CHECK-INSTR: xr.srai ft1, ft1, 3
# CHECK-ENCODING: [0xfb,0xd0,0x30,0x40]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# mask 1, stride a5, count 7
xr.repeat 1, a5, 7
# CHECK-INSTR: xr.repeat 1, a5, 7
# CHECK-ENCODING: [0x5b,0x80,0x77,0x10]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# mask 6, stride zero, count 7
xr.repeat 6, zero, 7
# CHECK-INSTR: xr.repeat 6, zero, 7
# CHECK-ENCODING: [0x5b,0x00,0x70,0x60]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# mask 11, stride zero, count 15
xr.repeat 11, zero, 15
# CHECK-INSTR: xr.repeat 11, zero, 15
# CHECK-ENCODING: [0x5b,0x00,0xf0,0xb0]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# mask 15, stride t6, count 0
xr.repeat 15, t6, 0
# CHECK-INSTR: xr.repeat 15, t6, 0
# CHECK-ENCODING: [0x5b,0x80,0x0f,0xf0]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# mask 0, stride a0, count 3
xr.repeat 0, a0, 3
# CHECK-INSTR: xr.repeat 0, a0, 3
# CHECK-ENCODING: [0x5b,0x00,0x35,0x00]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# xrepeat implies F.
flw ft0, 0(a0)
# CHECK-INSTR: flw ft0, 0(a0)
fmadd.s ft0, ft1, ft2, ft3, dyn
# CHECK-INSTR: fmadd.s ft0, ft1, ft2, ft3, dyn
