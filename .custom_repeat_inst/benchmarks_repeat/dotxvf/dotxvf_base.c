// DOTXVF benchmark: UR dot products of length NC sharing one x vector. Plain C version: no
// intrinsics, inline asm or pinned registers, so the compiler alone decides how to vectorize it.
// Same data and checksum as main.c (the hand-written repeat-MAC/LSU version,
// dotxvf_mac_block_reuse_8).

// NC overridable via -DNC=<n> on the command line for sweeping problem sizes.
#ifndef NC
    #define NC 1024
#else
    #define BENCH_CUSTOM_SIZES
#endif

#define UR 4
#define V 8

#include "../../benchmarks/common/bench.h"

#define GOLDEN_CHECKSUM 0xfc15e204u

static int A[UR][NC];
static int x[NC];
static int y[UR];

static void init_data() {
    for (int k = 0; k < NC; k++) x[k] = (k % 7) - 3;
    for (int u = 0; u < UR; u++) {
        for (int k = 0; k < NC; k++) A[u][k] = ((u + k) % 5) - 2;
    }
}

// y[u] = A[u] . x for each of the UR rows
static void dotxvf() {
    for (int u = 0; u < UR; u++) {
        i32 acc = 0;
        for (int k = 0; k < NC; k++) acc += A[u][k] * x[k];
        y[u] = acc;
    }
}

int main() {
    printf("dotxvf: dot-product microkernel (NC=%d UR=%d V=%d)\n", NC, UR, V);

    for (int u = 0; u < UR; u++) y[u] = 0;

    init_data();
    bench_mark(0);
    dotxvf();
    bench_mark(1);

    for (int u = 0; u < UR; u++) printf("y[%d] = %d\n", u, y[u]);

    u32 h = bench_hash(BENCH_FNV_INIT, y, UR);
    return bench_report("dotxvf", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
