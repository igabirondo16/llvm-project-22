#ifndef BENCHMARKS_REPEAT_H
#define BENCHMARKS_REPEAT_H

#include "../../benchmarks/common/bench.h"

// repeat_rv-only primitives (custom MAC_INSN opcode 0x0B + REPEAT opcode 0x5B), copied from
// repeat_rv/benchmarks/common.h. They pin x16..x31 as two 8-register "vector" blocks, so these
// programs only run on the repeat_rv core - run.py only schedules benchmarks_repeat/ there.

// DECL_VREG_XV1_8 / DECL_VREG_XV2_8: the two fixed 8-register ranges every primitive below pins
// itself to (x16..x23 and x24..x31) - declared once here instead of repeating the same 8 lines
// of "register i32 rN asm(...)" in every primitive that needs one of these ranges. Named after
// their own base register, not "a"/"b" - which primitives call "a" (x24..x31) and which call "b"
// (x16..x23) is a separate, primitive-level convention these macros don't need to track.
#define DECL_VREG_XV1_8 \
    register i32 r0_xv1 asm("x16"); \
    register i32 r1_xv1 asm("x17"); \
    register i32 r2_xv1 asm("x18"); \
    register i32 r3_xv1 asm("x19"); \
    register i32 r4_xv1 asm("x20"); \
    register i32 r5_xv1 asm("x21"); \
    register i32 r6_xv1 asm("x22"); \
    register i32 r7_xv1 asm("x23");

#define DECL_VREG_XV2_8 \
    register i32 r0_xv2 asm("x24"); \
    register i32 r1_xv2 asm("x25"); \
    register i32 r2_xv2 asm("x26"); \
    register i32 r3_xv2 asm("x27"); \
    register i32 r4_xv2 asm("x28"); \
    register i32 r5_xv2 asm("x29"); \
    register i32 r6_xv2 asm("x30"); \
    register i32 r7_xv2 asm("x31");

// store_xv2 / store_xv1: a caller can hold TWO independently-loaded blocks live at
// once and store either one back - pairs with load_xv2_8/load_xv1_8 below.

static inline __attribute__((always_inline))
void store_xv2_8(i32 *ptr, i32 stride) {
    DECL_VREG_XV2_8
    // Mark these registers as used
    asm volatile("" : "+r"(r0_xv2), "+r"(r1_xv2), "+r"(r2_xv2), "+r"(r3_xv2), "+r"(r4_xv2), "+r"(r5_xv2), "+r"(r6_xv2), "+r"(r7_xv2));
    char *p = (char *) ptr;
    *(i32 *) (p + 0 * stride) = r0_xv2;
    *(i32 *) (p + 1 * stride) = r1_xv2;
    *(i32 *) (p + 2 * stride) = r2_xv2;
    *(i32 *) (p + 3 * stride) = r3_xv2;
    *(i32 *) (p + 4 * stride) = r4_xv2;
    *(i32 *) (p + 5 * stride) = r5_xv2;
    *(i32 *) (p + 6 * stride) = r6_xv2;
    *(i32 *) (p + 7 * stride) = r7_xv2;
}

static inline __attribute__((always_inline))
void store_xv1_8(i32 *ptr, i32 stride) {
    DECL_VREG_XV1_8
    // Mark these registers as used
    asm volatile("" : "+r"(r0_xv1), "+r"(r1_xv1), "+r"(r2_xv1), "+r"(r3_xv1), "+r"(r4_xv1), "+r"(r5_xv1), "+r"(r6_xv1), "+r"(r7_xv1));
    char *p = (char *) ptr;
    *(i32 *) (p + 0 * stride) = r0_xv1;
    *(i32 *) (p + 1 * stride) = r1_xv1;
    *(i32 *) (p + 2 * stride) = r2_xv1;
    *(i32 *) (p + 3 * stride) = r3_xv1;
    *(i32 *) (p + 4 * stride) = r4_xv1;
    *(i32 *) (p + 5 * stride) = r5_xv1;
    *(i32 *) (p + 6 * stride) = r6_xv1;
    *(i32 *) (p + 7 * stride) = r7_xv1;
}

// load_xv2 / load_xv1: a caller can hold TWO independently-loaded blocks live at
// once - the pair mac_xv2_xv1_acc_8 below reads.

static inline __attribute__((always_inline))
void load_xv2_8(const i32 *ptr, i32 stride, i32 count) {
    DECL_VREG_XV2_8
    asm volatile(
        "lw   %[r0], 0(%[ptr])\n"
        ".insn r 0x5B, 0, (0b0001 << 3), x0, %[stride], %[count]\n"  // repeat-LSU: x24..x31 = ptr[0:8]
        : [r0] "=&r"(r0_xv2), "=&r"(r1_xv2), "=&r"(r2_xv2), "=&r"(r3_xv2), "=&r"(r4_xv2), "=&r"(r5_xv2), "=&r"(r6_xv2), "=&r"(r7_xv2)
        : [ptr] "r"(ptr), [stride] "r"(stride), [count] "r"(count)
        : "memory");
}

static inline __attribute__((always_inline))
void load_xv1_8(const i32 *ptr, i32 stride, i32 count) {
    DECL_VREG_XV1_8
    asm volatile(
        "lw   %[r0], 0(%[ptr])\n"
        ".insn r 0x5B, 0, (0b0001 << 3), x0, %[stride], %[count]\n"  // repeat-LSU: x16..x23 = ptr[0:8]
        : [r0] "=&r"(r0_xv1), "=&r"(r1_xv1), "=&r"(r2_xv1), "=&r"(r3_xv1), "=&r"(r4_xv1), "=&r"(r5_xv1), "=&r"(r6_xv1), "=&r"(r7_xv1)
        : [ptr] "r"(ptr), [stride] "r"(stride), [count] "r"(count)
        : "memory");
}

// acc += a-block[i] * b-block[i]
static inline __attribute__((always_inline))
i32 mac_xv2_xv1_acc_8(i32 acc, i32 count) {
    DECL_VREG_XV2_8
    DECL_VREG_XV1_8
    asm volatile(
        ".insn r4 0x0B, 0, 0, %[acc], %[a0], %[b0], %[acc]\n"  // MAC_INSN: acc = x24*x16 + acc
        ".insn r 0x5B, 0, (0b0110 << 3), x0, x0, %[count]\n"   // repeat-MAC: self-chained over 7 more
        : [acc] "+r"(acc)
        : [a0] "r"(r0_xv2), "r"(r1_xv2), "r"(r2_xv2), "r"(r3_xv2), "r"(r4_xv2), "r"(r5_xv2), "r"(r6_xv2), "r"(r7_xv2),
          [b0] "r"(r0_xv1), "r"(r1_xv1), "r"(r2_xv1), "r"(r3_xv1), "r"(r4_xv1), "r"(r5_xv1), "r"(r6_xv1), "r"(r7_xv1), [count] "r"(count)
        : "memory");
    return acc;
}

// block[i] = scalar * block[i]
static inline __attribute__((always_inline))
void mac_xv2_val_xv2_8(i32 a, i32 count) {
    DECL_VREG_XV2_8
    asm volatile(
        ".insn r4 0x0B, 0, 0, %[r0], %[a], %[r0], x0\n"        // MAC_INSN: x24 = a*x24 + 0
        ".insn r 0x5B, 0, (0b0101 << 3), x0, x0, %[count]\n"   // repeat-MAC: rd,rs2 walk, 7 more
        : [r0] "+&r"(r0_xv2), "+&r"(r1_xv2), "+&r"(r2_xv2), "+&r"(r3_xv2), "+&r"(r4_xv2), "+&r"(r5_xv2), "+&r"(r6_xv2), "+&r"(r7_xv2)
        : [a] "r"(a), [count] "r"(count)
        : "memory");
}

// xv2[i] += xv1[i], elementwise, in place - both blocks already resident (e.g. via load_xv2_8 +
// load_xv1_8). Same mask (0b1101: rd,rs2,rs3 walk, rs1 fixed) the old axpy_block_reuse_N used
// with a variable scalar - here rs1 is fixed to the constant 1 instead, since this core's MAC
// hardware has no separate no-multiply add mode to reach for.
static inline __attribute__((always_inline))
void add_xv2_xv1_8(i32 count) {
    DECL_VREG_XV2_8
    DECL_VREG_XV1_8
    asm volatile(
        ".insn r4 0x0B, 0, 0, %[r0], %[one], %[b0], %[r0]\n"   // MAC_INSN: x24 = 1*x16 + x24
        ".insn r 0x5B, 0, (0b1101 << 3), x0, x0, %[count]\n"   // repeat-MAC: rd,rs2,rs3 walk, 7 more
        : [r0] "+&r"(r0_xv2), "+&r"(r1_xv2), "+&r"(r2_xv2), "+&r"(r3_xv2), "+&r"(r4_xv2), "+&r"(r5_xv2), "+&r"(r6_xv2), "+&r"(r7_xv2)
        : [one] "r"(1),
          [b0] "r"(r0_xv1), "r"(r1_xv1), "r"(r2_xv1), "r"(r3_xv1), "r"(r4_xv1), "r"(r5_xv1), "r"(r6_xv1), "r"(r7_xv1), [count] "r"(count)
        : "memory");
}

#endif
