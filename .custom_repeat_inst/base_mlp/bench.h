#ifndef BENCHMARKS_BENCH_H
#define BENCHMARKS_BENCH_H

#include <stdio.h>
#include <stdint.h>

// Core-agnostic support shared by every benchmark's main.c. Only the plain-C kernels are kept
// here (the repeat_rv core-specific variants live in repeat_rv/benchmarks), so the programs only
// rely on: a hosted-ish libc (printf), a 32-bit int, and the simulation testbench's window mark.
//
// Timing is done by the testbench, not the program: bench_mark(stage) marks a point of the
// timed region (0 at its start, k at the end of stage k). The testbench snapshots its hardware
// counters (mcycle, minstret, the core's debug counters) at every mark and reports, in the prof
// YAML, the `kernel:` window (first to last mark) and each `stages:` k (previous mark to mark k).
// run.py takes a benchmark's cycles from the kernel window's mcycle.
//
// Porting hook (pass via -D or a per-core header force-included with -include):
//   BENCH_WINDOW_MARK(stage)  statement marking `stage` for the testbench. Default: on RISC-V a
//                             store of `stage` to BENCH_WINDOW_ADDR (0x10013000, free in every
//                             core's simulation MMIO page 0x1001xxxx); nothing elsewhere (host
//                             builds, used to generate golden checksums).

typedef int8_t i8;
typedef uint8_t u8;
typedef int16_t i16;
typedef uint16_t u16;
typedef int32_t i32;
typedef uint32_t u32;
typedef int64_t i64;
typedef uint64_t u64;

#ifndef BENCH_WINDOW_MARK
    #if defined(__riscv)
        #define BENCH_WINDOW_ADDR 0x10013000u
        #define BENCH_WINDOW_MARK(stage) (*(volatile u32 *) BENCH_WINDOW_ADDR = (stage))
    #else
        #define BENCH_WINDOW_MARK(stage) ((void) (stage))
    #endif
#endif

// Mark stage `stage` of the timed region: bench_mark(0) at its start, bench_mark(k) at the end of
// stage k (a single-kernel benchmark: bench_mark(0); kernel(); bench_mark(1);). The compiler
// barriers on both sides keep every load/store of the timed code between its marks (a volatile
// store alone only orders other volatile accesses).
static inline void bench_mark(u32 stage) {
    __asm__ volatile("" ::: "memory");
    BENCH_WINDOW_MARK(stage);
    __asm__ volatile("" ::: "memory");
}

// FNV-1a over 32-bit words - result signature compared against a golden value computed on the
// host (see Makefile `golden`), replacing the original baseline-vs-repeat cross-check.
#define BENCH_FNV_INIT 0x811c9dc5u

// `data` is void* so both int[] and i32[] arrays (distinct types on RV32 newlib) can be passed.
static inline u32 bench_hash(u32 h, const void *data, u32 n) {
    const i32 *w = (const i32 *) data;
    for (u32 i = 0; i < n; i++) {
        h ^= (u32) w[i];
        h *= 16777619u;
    }
    return h;
}

// Loop unrolling of the loops the repeat versions vectorize (8-wide dot products, vector adds):
// BENCH_UNROLL_8 before such a loop is `#pragma GCC unroll 8` when the program is built with
// -DBENCH_UNROLL (e.g. ./run.py -D BENCH_UNROLL), and nothing otherwise (GCC's own choice, usually
// a rolled loop). It doesn't change results, so the golden checksums hold either way.
#ifdef BENCH_UNROLL
    #define BENCH_UNROLL_8 _Pragma("GCC unroll 8")
#else
    #define BENCH_UNROLL_8
#endif

// Each benchmark defines BENCH_CUSTOM_SIZES when any problem-size macro is overridden with -D;
// golden checksums are only valid for the default sizes.
#ifdef BENCH_CUSTOM_SIZES
    #define BENCH_CHECK 0
#else
    #define BENCH_CHECK 1
#endif

// Standard report shape, parsed by the runner (cycles come from the testbench's kernel window):
//   BENCH <name> checksum=0x<hash>
//   PASS|FAIL|SKIP ...
// Returns the exit code for main(). `expected` is only checked when `check` is non-zero (golden
// values are only known for the default problem sizes; overriding a size disables the check).
static inline int bench_report(const char *name, u32 checksum, int check, u32 expected) {
    printf("BENCH %s checksum=0x%08x\n", name, (unsigned) checksum);
    if (!check) {
        printf("SKIP: no golden checksum for non-default sizes\n");
        return 0;
    }
    if (checksum == expected) {
        printf("PASS: %s checksum matches\n", name);
        return 0;
    }
    printf("FAIL: %s checksum 0x%08x != expected 0x%08x\n", name, (unsigned) checksum, (unsigned) expected);
    return 1;
}

#endif
