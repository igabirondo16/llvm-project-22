// MLP benchmark: small two-layer perceptron forward pass (dense -> ReLU -> dense). Generic C
// version of repeat_rv/benchmarks/mlp's baseline.

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

#include "../common/bench.h"

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

static void mlp() {
    for (u32 h = 0; h < HIDDEN_SIZE; h++) {
        i32 acc = B1[h];
        for (u32 i = 0; i < INPUT_SIZE; i++) acc += W1[h][i] * input[i];
        hidden[h] = relu(acc);
    }
    for (u32 o = 0; o < OUTPUT_SIZE; o++) {
        i32 acc = B2[o];
        for (u32 h = 0; h < HIDDEN_SIZE; h++) acc += W2[o][h] * hidden[h];
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
    printf("mlp: 2-layer MLP forward pass (IN=%d HIDDEN=%d OUT=%d)\n",
           INPUT_SIZE, HIDDEN_SIZE, OUTPUT_SIZE);

    init_data();
    bench_mark(0);
    mlp();
    bench_mark(1);

    printf("argmax class: %d\n", (int) argmax());

    u32 h = bench_hash(BENCH_FNV_INIT, output, OUTPUT_SIZE);
    return bench_report("mlp", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
