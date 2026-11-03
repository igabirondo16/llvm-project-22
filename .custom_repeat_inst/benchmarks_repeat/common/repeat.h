#ifndef BENCHMARKS_REPEAT_H
#define BENCHMARKS_REPEAT_H

#include "../../benchmarks/common/bench.h"

// repeat_rv-only primitives (custom MAC_INSN opcode 0x0B + REPEAT opcode 0x5B), copied from
// repeat_rv/benchmarks/common.h. They use x16..x31 as two 8-register "vector" blocks, so these
// programs only run on the repeat_rv core - run.py only schedules benchmarks_repeat/ there.
//
// Usage: put DECL_XV_8 once at the top of every function (or block) that calls the primitives,
// then call them as before:
//
//     static i32 dot(const i32 *a, const i32 *b, u32 n) {
//         DECL_XV_8
//         i32 acc = 0;
//         for (u32 i = 0; i < n; i += 8) {
//             load_xv2_8(a + i, 4, 7);
//             load_xv1_8(b + i, 4, 7);
//             acc = mac_xv2_xv1_acc_8(acc, 7);
//         }
//         return acc;
//     }
//
// Why DECL_XV_8 (portable to clang as well as GCC): a block's 8 values must stay in their
// registers from the asm that loads them to the asm that uses them. GCC and clang only promise a
// `register ... asm("xN")` variable is in xN *at the asm statements that use it as an operand*;
// between two asm statements the compiler may reuse xN for anything else. The old primitives each
// declared their own fresh copies of these variables, so nothing told the compiler that x24..x31
// still held live data after load_xv2_8 returned. GCC happened to leave them alone, but clang
// reused them for addresses between the load and the MAC (gepdot, bert_tiny gave wrong results).
// Now the 16 variables are declared once per function and every primitive reads and writes those
// same variables, so the compiler sees the real data flow: it keeps each block live from load to
// use, and the operand constraints put it back in x16..x31 (with moves, if ever needed) at each
// asm. The primitives are macros because they must name the caller's variables.

// The two fixed 8-register blocks: xv1 = x16..x23, xv2 = x24..x31 (a REPEAT walk can only start
// at x8, x16 or x24). Which primitive calls which block "a" or "b" is a primitive-level
// convention: mac_xv2_xv1_acc_8 computes acc += xv2[i] * xv1[i].
#define DECL_XV_8 \
    register i32 r0_xv1 asm("x16") __attribute__((unused)); \
    register i32 r1_xv1 asm("x17") __attribute__((unused)); \
    register i32 r2_xv1 asm("x18") __attribute__((unused)); \
    register i32 r3_xv1 asm("x19") __attribute__((unused)); \
    register i32 r4_xv1 asm("x20") __attribute__((unused)); \
    register i32 r5_xv1 asm("x21") __attribute__((unused)); \
    register i32 r6_xv1 asm("x22") __attribute__((unused)); \
    register i32 r7_xv1 asm("x23") __attribute__((unused)); \
    register i32 r0_xv2 asm("x24") __attribute__((unused)); \
    register i32 r1_xv2 asm("x25") __attribute__((unused)); \
    register i32 r2_xv2 asm("x26") __attribute__((unused)); \
    register i32 r3_xv2 asm("x27") __attribute__((unused)); \
    register i32 r4_xv2 asm("x28") __attribute__((unused)); \
    register i32 r5_xv2 asm("x29") __attribute__((unused)); \
    register i32 r6_xv2 asm("x30") __attribute__((unused)); \
    register i32 r7_xv2 asm("x31") __attribute__((unused));

// Operand lists naming a whole block, for the asm statements below
#define XV1_OUT "=&r"(r0_xv1), "=&r"(r1_xv1), "=&r"(r2_xv1), "=&r"(r3_xv1), \
                "=&r"(r4_xv1), "=&r"(r5_xv1), "=&r"(r6_xv1), "=&r"(r7_xv1)
#define XV2_OUT "=&r"(r0_xv2), "=&r"(r1_xv2), "=&r"(r2_xv2), "=&r"(r3_xv2), \
                "=&r"(r4_xv2), "=&r"(r5_xv2), "=&r"(r6_xv2), "=&r"(r7_xv2)
#define XV2_INOUT "+&r"(r0_xv2), "+&r"(r1_xv2), "+&r"(r2_xv2), "+&r"(r3_xv2), \
                  "+&r"(r4_xv2), "+&r"(r5_xv2), "+&r"(r6_xv2), "+&r"(r7_xv2)
#define XV1_IN "r"(r0_xv1), "r"(r1_xv1), "r"(r2_xv1), "r"(r3_xv1), \
               "r"(r4_xv1), "r"(r5_xv1), "r"(r6_xv1), "r"(r7_xv1)
#define XV2_IN "r"(r0_xv2), "r"(r1_xv2), "r"(r2_xv2), "r"(r3_xv2), \
               "r"(r4_xv2), "r"(r5_xv2), "r"(r6_xv2), "r"(r7_xv2)

// load_xv2_8 / load_xv1_8: block = ptr[0], ptr[stride bytes], ... (count + 1 words).
// Operand %0 is the block's first register, %8 ptr, %9 stride, %10 count. The early-clobber
// outputs keep ptr/stride/count out of the block, which the REPEAT overwrites while reading them.
#define load_xv2_8(ptr, stride, count)                                                         \
    __asm__ volatile(                                                                          \
        "lw   %0, 0(%8)\n\t"                                                                   \
        ".insn r 0x5B, 0, (0b0001 << 3), x0, %9, %10"  /* repeat-LSU: x24..x31 = ptr[0:8] */ \
        : XV2_OUT                                                                              \
        : "r"(ptr), "r"(stride), "r"(count)                                                    \
        : "memory")

#define load_xv1_8(ptr, stride, count)                                                         \
    __asm__ volatile(                                                                          \
        "lw   %0, 0(%8)\n\t"                                                                   \
        ".insn r 0x5B, 0, (0b0001 << 3), x0, %9, %10"  /* repeat-LSU: x16..x23 = ptr[0:8] */ \
        : XV1_OUT                                                                              \
        : "r"(ptr), "r"(stride), "r"(count)                                                    \
        : "memory")

// store_xv2_8 / store_xv1_8: ptr[i * stride bytes] = block[i]. REPEAT can't repeat stores, so
// these are 8 plain sw, written in C so the compiler schedules them like any other store.
#define store_xv2_8(ptr, stride)                                     \
    do {                                                             \
        char *xr_p_ = (char *) (ptr);                                \
        i32 xr_s_ = (stride);                                        \
        *(i32 *) (xr_p_ + 0 * xr_s_) = r0_xv2;                       \
        *(i32 *) (xr_p_ + 1 * xr_s_) = r1_xv2;                       \
        *(i32 *) (xr_p_ + 2 * xr_s_) = r2_xv2;                       \
        *(i32 *) (xr_p_ + 3 * xr_s_) = r3_xv2;                       \
        *(i32 *) (xr_p_ + 4 * xr_s_) = r4_xv2;                       \
        *(i32 *) (xr_p_ + 5 * xr_s_) = r5_xv2;                       \
        *(i32 *) (xr_p_ + 6 * xr_s_) = r6_xv2;                       \
        *(i32 *) (xr_p_ + 7 * xr_s_) = r7_xv2;                       \
    } while (0)

#define store_xv1_8(ptr, stride)                                     \
    do {                                                             \
        char *xr_p_ = (char *) (ptr);                                \
        i32 xr_s_ = (stride);                                        \
        *(i32 *) (xr_p_ + 0 * xr_s_) = r0_xv1;                       \
        *(i32 *) (xr_p_ + 1 * xr_s_) = r1_xv1;                       \
        *(i32 *) (xr_p_ + 2 * xr_s_) = r2_xv1;                       \
        *(i32 *) (xr_p_ + 3 * xr_s_) = r3_xv1;                       \
        *(i32 *) (xr_p_ + 4 * xr_s_) = r4_xv1;                       \
        *(i32 *) (xr_p_ + 5 * xr_s_) = r5_xv1;                       \
        *(i32 *) (xr_p_ + 6 * xr_s_) = r6_xv1;                       \
        *(i32 *) (xr_p_ + 7 * xr_s_) = r7_xv1;                       \
    } while (0)

// acc + sum_i xv2[i] * xv1[i]  (an expression: acc = mac_xv2_xv1_acc_8(acc, 7);)
// Operands: %0 acc, %1..%8 xv2, %9..%16 xv1, %17 count. acc is rd and rs3 and does not walk.
#define mac_xv2_xv1_acc_8(acc, count)                                                     \
    __extension__({                                                                       \
        i32 xr_acc_ = (acc);                                                              \
        __asm__ volatile(                                                                 \
            ".insn r4 0x0B, 0, 0, %0, %1, %9, %0\n\t" /* MAC_INSN: acc = x24*x16 + acc */ \
            ".insn r 0x5B, 0, (0b0110 << 3), x0, x0, %17" /* repeat-MAC: rs1,rs2 walk */ \
            : "+r"(xr_acc_)                                                               \
            : XV2_IN, XV1_IN, "r"(count));                                                \
        xr_acc_;                                                                          \
    })

// xv2[i] = a * xv2[i]. Operands: %0..%7 xv2, %8 a, %9 count.
#define mac_xv2_val_xv2_8(a, count)                                                    \
    __asm__ volatile(                                                                  \
        ".insn r4 0x0B, 0, 0, %0, %8, %0, x0\n\t" /* MAC_INSN: x24 = a*x24 + 0 */      \
        ".insn r 0x5B, 0, (0b0101 << 3), x0, x0, %9" /* repeat-MAC: rd,rs2 walk */    \
        : XV2_INOUT                                                                    \
        : "r"(a), "r"(count))

// xv2[i] += xv1[i], elementwise, in place. Same mask (0b1101: rd,rs2,rs3 walk, rs1 fixed) the old
// axpy_block_reuse_N used with a variable scalar - here rs1 is the constant 1, since this core's
// MAC hardware has no separate no-multiply add mode. Operands: %0..%7 xv2, %8 the constant 1,
// %9..%16 xv1, %17 count.
#define add_xv2_xv1_8(count)                                                            \
    __asm__ volatile(                                                                   \
        ".insn r4 0x0B, 0, 0, %0, %8, %9, %0\n\t" /* MAC_INSN: x24 = 1*x16 + x24 */     \
        ".insn r 0x5B, 0, (0b1101 << 3), x0, x0, %17" /* repeat-MAC: rd,rs2,rs3 walk */ \
        : XV2_INOUT                                                                     \
        : "r"(1), XV1_IN, "r"(count))

#endif
