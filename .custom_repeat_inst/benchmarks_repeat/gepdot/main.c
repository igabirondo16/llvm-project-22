// GEPDOT benchmark: rank-1 GEMM microkernel - repeat_rv repeat-MAC/LSU version
// (repeat_rv/benchmarks/gepdot's gepdot_mac_vec_vec_8). Same data and checksum as the generic
// benchmarks/gepdot.

#define Kc 1024
#define Nr 8  // ~ vlen in this impl
#define Mr 1  // ~ unroll factor in this impl

#include "../common/repeat.h"

#define GOLDEN_CHECKSUM 0xc3f8ace2u

static int A[Kc];
static int B[Kc * Nr];
static int C[Nr];

static void init_data(int *C) {
    for (int k = 0; k < Kc; k++) A[k] = (k % 7) - 3;
    for (int k = 0; k < Kc; k++) {
        for (int v = 0; v < Nr; v++) B[k * Nr + v] = ((k + v) % 5) - 2;
    }
    for (int v = 0; v < Nr; v++) C[v] = (v % 3) - 1;
}

// Blocks the K (reduction) dimension by 8: each k-block loads A's 8-wide slice ONCE (load_xv2_8,
// shared across all Nr columns) and, for every column, loads that column's k-block of B
// (load_xv1_8, strided by Nr*4 since B is row-major K x Nr) and dot-accumulates it
// (mac_xv2_xv1_acc_8) into a per-column accumulator. The Nr=8 accumulators are hard-pinned to
// x15 down to x7 (outside the primitives' own x16..x31) so all 8 stay register-resident.
static void gepdot_mac_vec_vec_8(int *A, int *B, int *C) {
    DECL_XV_8
    register i32 acc0 asm("x15") = C[0];
    register i32 acc1 asm("x14") = C[1];
    register i32 acc2 asm("x13") = C[2];
    register i32 acc3 asm("x12") = C[3];
    register i32 acc4 asm("x11") = C[4];
    register i32 acc5 asm("x10") = C[5];
    register i32 acc6 asm("x9")  = C[6];
    register i32 acc7 asm("x7")  = C[7];  // x8/s0 is the frame pointer at -O0, unusable
    for (int k = 0; k < Kc; k += 8) {
        load_xv2_8((i32 *) &A[k], 4, 7);
        load_xv1_8((i32 *) &B[k * Nr + 0], Nr * 4, 7); acc0 = mac_xv2_xv1_acc_8(acc0, 7);
        load_xv1_8((i32 *) &B[k * Nr + 1], Nr * 4, 7); acc1 = mac_xv2_xv1_acc_8(acc1, 7);
        load_xv1_8((i32 *) &B[k * Nr + 2], Nr * 4, 7); acc2 = mac_xv2_xv1_acc_8(acc2, 7);
        load_xv1_8((i32 *) &B[k * Nr + 3], Nr * 4, 7); acc3 = mac_xv2_xv1_acc_8(acc3, 7);
        load_xv1_8((i32 *) &B[k * Nr + 4], Nr * 4, 7); acc4 = mac_xv2_xv1_acc_8(acc4, 7);
        load_xv1_8((i32 *) &B[k * Nr + 5], Nr * 4, 7); acc5 = mac_xv2_xv1_acc_8(acc5, 7);
        load_xv1_8((i32 *) &B[k * Nr + 6], Nr * 4, 7); acc6 = mac_xv2_xv1_acc_8(acc6, 7);
        load_xv1_8((i32 *) &B[k * Nr + 7], Nr * 4, 7); acc7 = mac_xv2_xv1_acc_8(acc7, 7);
    }
    C[0] = acc0; C[1] = acc1; C[2] = acc2; C[3] = acc3;
    C[4] = acc4; C[5] = acc5; C[6] = acc6; C[7] = acc7;
}

int main() {
    printf("gepdot: rank-1 GEMM microkernel (Kc=%d Mr=%d Nr=%d) [repeat mac_vec_vec_8]\n", Kc, Mr, Nr);

    init_data(C);
    bench_mark(0);
    gepdot_mac_vec_vec_8(A, B, C);
    bench_mark(1);

    for (int v = 0; v < Nr; v++) printf("C[%d] = %d\n", v, C[v]);

    u32 h = bench_hash(BENCH_FNV_INIT, C, Nr);
    return bench_report("gepdot", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
