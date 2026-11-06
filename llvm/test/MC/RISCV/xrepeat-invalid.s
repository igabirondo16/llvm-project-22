# RUN: not llvm-mc -triple=riscv32 --mattr=+xrepeat %s 2>&1 \
# RUN:        | FileCheck %s --check-prefixes=CHECK-ERROR
# RUN: not llvm-mc -triple=riscv64 --mattr=+xrepeat %s 2>&1 \
# RUN:        | FileCheck %s --check-prefixes=CHECK-RV64

# CHECK-RV64: 'xrepeat' is only supported for 'rv32'

# REPEAT: mask and count are 4-bit literals, the stride is an x register.
xr.repeat 16, a5, 7
# CHECK-ERROR: :[[@LINE-1]]:11: error: immediate must be an integer in the range [0, 15]
xr.repeat 1, a5, 16
# CHECK-ERROR: :[[@LINE-1]]:18: error: immediate must be an integer in the range [0, 15]
xr.repeat 1, f8, 7
# CHECK-ERROR: :[[@LINE-1]]:14: error: invalid operand for instruction

# XRepeatInt's forms (count in a register, MAC on x registers).
xr.repeat 1, a5, a4
# CHECK-ERROR: :[[@LINE-1]]:1: error: instruction requires the following: 'XRepeatInt' (repeat_rv Repeat and Multiply-Accumulate, frozen original version)
xr.mac a0, a1, a2, a3
# CHECK-ERROR: :[[@LINE-1]]:1: error: instruction requires the following: 'XRepeatInt' (repeat_rv Repeat and Multiply-Accumulate, frozen original version)

# VRF operands are f registers; addresses and moved scalars are x registers.
xr.mac f0, f1, f2
# CHECK-ERROR: :[[@LINE-1]]:1: error: too few operands for instruction
xr.add a0, a1, a2
# CHECK-ERROR: :[[@LINE-1]]:8: error: invalid operand for instruction
xr.add f0, f1, a2
# CHECK-ERROR: :[[@LINE-1]]:16: error: invalid operand for instruction
xr.mv.vx f0, f1
# CHECK-ERROR: :[[@LINE-1]]:14: error: invalid operand for instruction
xr.mv.xv f0, f1
# CHECK-ERROR: :[[@LINE-1]]:10: error: invalid operand for instruction
xr.lw a0, 0(a1)
# CHECK-ERROR: :[[@LINE-1]]:7: error: invalid operand for instruction
xr.lw f0, 0(f1)
# CHECK-ERROR: :[[@LINE-1]]:13: error: invalid operand for instruction

# Immediates.
xr.lw f0, 2048(a1)
# CHECK-ERROR: :[[@LINE-1]]:11: error: operand must be a symbol with %lo/%pcrel_lo/%tprel_lo specifier or an integer in the range [-2048, 2047]
xr.sw f0, -2049(a1)
# CHECK-ERROR: :[[@LINE-1]]:11: error: operand must be a symbol with %lo/%pcrel_lo/%tprel_lo specifier or an integer in the range [-2048, 2047]
xr.addi f0, f1, 2048
# CHECK-ERROR: :[[@LINE-1]]:17: error: operand must be a symbol with %lo/%pcrel_lo/%tprel_lo specifier or an integer in the range [-2048, 2047]
xr.slli f0, f1, 32
# CHECK-ERROR: :[[@LINE-1]]:17: error: immediate must be an integer in the range [0, 31]
xr.srai f0, f1, -1
# CHECK-ERROR: :[[@LINE-1]]:17: error: immediate must be an integer in the range [0, 31]
