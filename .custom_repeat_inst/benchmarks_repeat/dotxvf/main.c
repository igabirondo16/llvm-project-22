// DOTXVF benchmark: UR dot products of length NC sharing one x vector - repeat_rv repeat-MAC/LSU
// version (repeat_rv/benchmarks/dotxvf's dotxvf_mac_block_reuse_8). Same data and checksum as the
// generic benchmarks/dotxvf.

// NC overridable via -DNC=<n> on the command line for sweeping problem sizes.
#ifndef NC
    #define NC 1024
#else
    #define BENCH_CUSTOM_SIZES
#endif

#define UR 4
#define V 8

#include "../common/repeat.h"

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

// x's k-block is loaded ONCE per iteration (load_xv2_8) and reused across all UR=4 rows
// (load_xv1_8 + mac_xv2_xv1_acc_8 per row). The UR=4 accumulators are hard-pinned to x15 down
// (outside the primitives' own x16..x31 range) - a static global array is never register-promoted
// by GCC, so without pinning every k-block reloads/stores it from memory.
static void dotxvf_mac_block_reuse_8() {
    DECL_XV_8
    register i32 acc0 asm("x15") = 0;
    register i32 acc1 asm("x14") = 0;
    register i32 acc2 asm("x13") = 0;
    register i32 acc3 asm("x12") = 0;
    for (int k = 0; k < NC; k += 8) {
        load_xv2_8((i32 *) &x[k], 4, 7);
        load_xv1_8((i32 *) &A[0][k], 4, 7); acc0 = mac_xv2_xv1_acc_8(acc0, 7);
        load_xv1_8((i32 *) &A[1][k], 4, 7); acc1 = mac_xv2_xv1_acc_8(acc1, 7);
        load_xv1_8((i32 *) &A[2][k], 4, 7); acc2 = mac_xv2_xv1_acc_8(acc2, 7);
        load_xv1_8((i32 *) &A[3][k], 4, 7); acc3 = mac_xv2_xv1_acc_8(acc3, 7);
    }
    y[0] = acc0;
    y[1] = acc1;
    y[2] = acc2;
    y[3] = acc3;
}

int main() {
    printf("dotxvf: dot-product microkernel (NC=%d UR=%d V=%d) [repeat mac_block_reuse_8]\n", NC, UR, V);

    for (int u = 0; u < UR; u++) y[u] = 0;

    init_data();
    bench_mark(0);
    dotxvf_mac_block_reuse_8();
    bench_mark(1);

    for (int u = 0; u < UR; u++) printf("y[%d] = %d\n", u, y[u]);

    u32 h = bench_hash(BENCH_FNV_INIT, y, UR);
    return bench_report("dotxvf", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
