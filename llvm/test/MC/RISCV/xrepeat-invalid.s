# RUN: not llvm-mc -triple=riscv32 --mattr=+xrepeat %s 2>&1 \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ERROR
# RUN: not llvm-mc -triple=riscv64 --mattr=+xrepeat %s 2>&1 \
# RUN:        | FileCheck %s --check-prefixes=CHECK-RV64

xr.repeat 16, a3, a4
# CHECK-ERROR: immediate must be an integer in the range [0, 15]
# CHECK-RV64: 'xrepeat' is only supported for 'rv32'

xr.mac t2, s8, a6
# CHECK-ERROR: too few operands for instruction

xr.mac t2, s8, a6, 5
# CHECK-ERROR: invalid operand for instruction