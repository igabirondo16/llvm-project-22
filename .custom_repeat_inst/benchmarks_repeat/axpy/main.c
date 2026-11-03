// AXPY benchmark: y = a*x + y - repeat_rv repeat-MAC/LSU version (repeat_rv/benchmarks/axpy's
// axpy_mac_block_8). Same data and checksum as the generic benchmarks/axpy.

#ifndef N
    #define N 1000
#else
    #define BENCH_CUSTOM_SIZES
#endif
#define ALPHA 3 // scalar multiplier

#include "../common/repeat.h"

#define GOLDEN_CHECKSUM 0xd75919e6u

static int x[N];
static int y[N];

static void init_data(int *y) {
    for (int i = 0; i < N; i++) x[i] = (i % 7) - 3;
    for (int i = 0; i < N; i++) y[i] = (i % 5) - 2;
}

static void axpy_mac_block_8(int a, int *x, int *y) {
    DECL_XV_8
    for (int i = 0; i < N; i += 8) {
        load_xv2_8((i32 *) &x[i], 4, 7);
        mac_xv2_val_xv2_8(a, 7);
        load_xv1_8((i32 *) &y[i], 4, 7);
        add_xv2_xv1_8(7);
        store_xv2_8((i32 *) &y[i], 4);
    }
}

int main() {
    printf("axpy: y = a*x + y (N=%d) [repeat mac_block_8]\n", N);

    init_data(y);
    bench_mark(0);
    axpy_mac_block_8(ALPHA, x, y);
    bench_mark(1);

    u32 h = bench_hash(BENCH_FNV_INIT, y, N);
    return bench_report("axpy", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
