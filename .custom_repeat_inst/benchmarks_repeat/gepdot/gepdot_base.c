// GEPDOT benchmark: rank-1 GEMM microkernel, C[0:Nr] += sum_k A[k] * B[k][0:Nr]. Plain C
// version: no intrinsics, inline asm or pinned registers, so the compiler alone decides how to
// vectorize it. Same data and checksum as main.c (the hand-written repeat-MAC/LSU version,
// gepdot_mac_vec_vec_8).

#define Kc 1024
#define Nr 8  // ~ vlen in this impl
#define Mr 1  // ~ unroll factor in this impl

#include "../../benchmarks/common/bench.h"

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

// One rank-1 update per k: C += A[k] * (row k of B, which is row-major K x Nr)
static void gepdot(int *A, int *B, int *C) {
    for (int k = 0; k < Kc; k++) {
        for (int v = 0; v < Nr; v++) C[v] += A[k] * B[k * Nr + v];
    }
}

int main() {
    printf("gepdot: rank-1 GEMM microkernel (Kc=%d Mr=%d Nr=%d)\n", Kc, Mr, Nr);

    init_data(C);
    bench_mark(0);
    gepdot(A, B, C);
    bench_mark(1);

    for (int v = 0; v < Nr; v++) printf("C[%d] = %d\n", v, C[v]);

    u32 h = bench_hash(BENCH_FNV_INIT, C, Nr);
    return bench_report("gepdot", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
