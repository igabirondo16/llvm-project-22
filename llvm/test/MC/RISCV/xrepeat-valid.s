# RUN: llvm-mc -triple=riscv32 --mattr=+xrepeat -M no-aliases -show-encoding %s \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ENCODING,CHECK-INSTR
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+xrepeat < %s \
# RUN:     | llvm-objdump --mattr=+xrepeat --no-print-imm-hex -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-INSTR %s
# RUN: not llvm-mc -triple riscv32 %s 2>&1 \
# RUN:     | FileCheck -check-prefix=CHECK-NO-EXT %s

# Dot-product step from mlp_repeat.s: t2 = s8*a6 + t2
xr.mac t2, s8, a6, t2
# CHECK-INSTR: xr.mac t2, s8, a6, t2
# CHECK-ENCODING: [0x8b,0x03,0x0c,0x39]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# Scale step: s8 = a0*s8 + 0
xr.mac s8, a0, s8, zero
# CHECK-INSTR: xr.mac s8, a0, s8, zero
# CHECK-ENCODING: [0x0b,0x0c,0x85,0x01]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# Load repeat: mask 0b0001 (rd), stride a3, count a4
xr.repeat 1, a3, a4
# CHECK-INSTR: xr.repeat 1, a3, a4
# CHECK-ENCODING: [0x5b,0x80,0xe6,0x10]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# Dot-product repeat: mask 0b0110 (rs1, rs2), count a4
xr.repeat 6, zero, a4
# CHECK-INSTR: xr.repeat 6, zero, a4
# CHECK-ENCODING: [0x5b,0x00,0xe0,0x60]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}

# Largest mask
xr.repeat 15, a3, a4
# CHECK-INSTR: xr.repeat 15, a3, a4
# CHECK-ENCODING: [0x5b,0x80,0xe6,0xf0]
# CHECK-NO-EXT: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate){{$}}