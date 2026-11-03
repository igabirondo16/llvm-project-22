// AXPY benchmark: y = a*x + y. Plain C version: no intrinsics or inline asm, so the compiler
// alone decides how to vectorize it. Same data and checksum as main.c (the hand-written
// repeat-MAC/LSU version, axpy_mac_block_8).

#ifndef N
    #define N 1000
#else
    #define BENCH_CUSTOM_SIZES
#endif
#define ALPHA 3 // scalar multiplier

#include "../../benchmarks/common/bench.h"

#define GOLDEN_CHECKSUM 0xd75919e6u

static int x[N];
static int y[N];

static void init_data(int *y) {
    for (int i = 0; i < N; i++) x[i] = (i % 7) - 3;
    for (int i = 0; i < N; i++) y[i] = (i % 5) - 2;
}

static void axpy(int a, int *x, int *y) {
    for (int i = 0; i < N; i++) y[i] = a * x[i] + y[i];
}

int main() {
    printf("axpy: y = a*x + y (N=%d)\n", N);

    init_data(y);
    bench_mark(0);
    axpy(ALPHA, x, y);
    bench_mark(1);

    u32 h = bench_hash(BENCH_FNV_INIT, y, N);
    return bench_report("axpy", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
