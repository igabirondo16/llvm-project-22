// MLP benchmark: two-layer perceptron forward pass (dense -> ReLU -> dense) - repeat_rv
// repeat-MAC/LSU version (repeat_rv/benchmarks/mlp's mlp_repeat_8). Same data and checksum as the
// generic benchmarks/mlp. INPUT_SIZE and HIDDEN_SIZE must both be divisible by 8.

#ifndef INPUT_SIZE
    #define INPUT_SIZE 64
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef HIDDEN_SIZE
    #define HIDDEN_SIZE 32
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef OUTPUT_SIZE
    #define OUTPUT_SIZE 16
#else
    #define BENCH_CUSTOM_SIZES
#endif

#include "../common/repeat.h"

#define GOLDEN_CHECKSUM 0xd04f38bbu

static i32 W1[HIDDEN_SIZE][INPUT_SIZE];
static i32 B1[HIDDEN_SIZE];
static i32 W2[OUTPUT_SIZE][HIDDEN_SIZE];
static i32 B2[OUTPUT_SIZE];
static i32 input[INPUT_SIZE];

static i32 hidden[HIDDEN_SIZE];
static i32 output[OUTPUT_SIZE];

static void init_data() {
    for (u32 h = 0; h < HIDDEN_SIZE; h++) {
        for (u32 i = 0; i < INPUT_SIZE; i++) W1[h][i] = ((h + i) % 7) - 3;
        B1[h] = (h % 5) - 2;
    }
    for (u32 o = 0; o < OUTPUT_SIZE; o++) {
        for (u32 h = 0; h < HIDDEN_SIZE; h++) W2[o][h] = ((o + h) % 5) - 2;
        B2[o] = (o % 3) - 1;
    }
    for (u32 i = 0; i < INPUT_SIZE; i++) input[i] = (i % 9) - 4;
}

static i32 relu(i32 x) {
    return x > 0 ? x : 0;
}

static void mlp_repeat_8() {
    for (u32 h = 0; h < HIDDEN_SIZE; h++) {
        i32 acc = B1[h];
        for (u32 b = 0; b < INPUT_SIZE / 8; b++) {
            load_xv2_8(&input[b * 8], 4, 7);
            load_xv1_8(&W1[h][b * 8], 4, 7);
            acc = mac_xv2_xv1_acc_8(acc, 7);
        }
        hidden[h] = relu(acc);
    }
    for (u32 o = 0; o < OUTPUT_SIZE; o++) {
        i32 acc = B2[o];
        for (u32 b = 0; b < HIDDEN_SIZE / 8; b++) {
            load_xv2_8(&hidden[b * 8], 4, 7);
            load_xv1_8(&W2[o][b * 8], 4, 7);
            acc = mac_xv2_xv1_acc_8(acc, 7);
        }
        output[o] = acc;
    }
}

static i32 argmax() {
    i32 best = 0;
    for (u32 o = 1; o < OUTPUT_SIZE; o++) {
        if (output[o] > output[best]) best = o;
    }
    return best;
}

int main() {
    printf("mlp: 2-layer MLP forward pass (IN=%d HIDDEN=%d OUT=%d) [repeat_8]\n",
           INPUT_SIZE, HIDDEN_SIZE, OUTPUT_SIZE);

    init_data();
    bench_mark(0);
    mlp_repeat_8();
    bench_mark(1);

    printf("argmax class: %d\n", (int) argmax());

    u32 h = bench_hash(BENCH_FNV_INIT, output, OUTPUT_SIZE);
    return bench_report("mlp", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
