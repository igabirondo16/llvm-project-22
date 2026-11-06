# RUN: not llvm-mc -triple=riscv32 --mattr=+xrepeatint %s 2>&1 \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ERROR
# RUN: not llvm-mc -triple=riscv64 --mattr=+xrepeatint %s 2>&1 \
# RUN:        | FileCheck %s --check-prefixes=CHECK-RV64

xr.repeat 16, a3, a4
# CHECK-ERROR: immediate must be an integer in the range [0, 15]
# CHECK-RV64: 'xrepeatint' is only supported for 'rv32'

xr.mac t2, s8, a6
# CHECK-ERROR: too few operands for instruction

xr.mac t2, s8, a6, 5
# CHECK-ERROR: invalid operand for instruction
# XRepeat's VRF form (custom-1, f registers) is not part of XRepeatInt.
xr.mac f0, f1, f2, f3
# CHECK-ERROR: instruction requires the following: 'XRepeat' (repeat_rv Repeat and Multiply-Accumulate)
