// RESNET8 benchmark: forward pass of ResNet-8, the MLPerf Tiny image-classification network
// (https://github.com/mlcommons/tiny, "resnet_v1_eembc"): a 32x32x3 image -> 3x3 conv (16) ->
// three residual stacks (16, 32, 64 filters; stacks 2 and 3 downsample with stride 2 and a 1x1
// projection shortcut) -> 8x8 average pool -> dense (10 classes). ~12.5M MACs, ~78k parameters.
//
// Integer-only, the way int8 inference runtimes run it: batch norm folded into each conv's bias,
// and every layer's accumulator requantized with a power-of-two scale (arithmetic right shift)
// and clamped to the int8 range [-ACT_MAX-1, ACT_MAX] (ReLU layers to [0, ACT_MAX]). Values are
// stored as i32 like the other benchmarks. Activations are channel-last ([y][x][c], as cnn_vlen)
// in buffers with a zero 1-pixel border, so the 3x3 "same" convolutions need no bounds checks.
// Weights and the input image are pseudo-random (fixed LCG seed), generated outside the timed part.
//
// Plain C version: no intrinsics or inline asm, and every layer (conv1 included) is a direct
// convolution loop, so the compiler alone decides how to vectorize it. Same data, layers and
// checksum as main.c (the hand-written repeat-MAC/LSU version, which uses 8-wide channel bursts
// and an im2col gather for conv1).

#ifndef IMG_SIZE
    #define IMG_SIZE 32      // input height/width (must be a multiple of 4)
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef IN_CHANNELS
    #define IN_CHANNELS 3
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef FILTERS
    #define FILTERS 16       // stack 1 width; stacks 2 and 3 use 2x and 4x
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef NUM_CLASSES
    #define NUM_CLASSES 10
#else
    #define BENCH_CUSTOM_SIZES
#endif

#include "../../benchmarks/common/bench.h"

#define GOLDEN_CHECKSUM 0x2992f71eu

#define S1 IMG_SIZE          // stack 1 feature map size
#define S2 (IMG_SIZE / 2)    // stack 2
#define S3 (IMG_SIZE / 4)    // stack 3
#define F1 FILTERS
#define F2 (2 * FILTERS)
#define F3 (4 * FILTERS)
#define ACT_MAX 127

// Requantization shifts, ~log2 of each layer's accumulator gain (sqrt(fan-in) * weight rms) so
// activations keep roughly the same magnitude from layer to layer.
#define SH_CONV1 3   // fan-in 27
#define SH_3x3_F1 4  // fan-in 144
#define SH_3x3_F2 4  // fan-in 288
#define SH_3x3_F3 5  // fan-in 576
#define SH_PROJ 3    // 1x1 shortcuts, fan-in 16 / 32

// Padded channel-last feature maps: interior (1..S, 1..S), zero border
#define PAD(s) ((s) + 2)
static i32 image[PAD(S1)][PAD(S1)][IN_CHANNELS];
static i32 x1[PAD(S1)][PAD(S1)][F1];   // conv1 out
static i32 a1[PAD(S1)][PAD(S1)][F1];   // stack 1 inner
static i32 y1[PAD(S1)][PAD(S1)][F1];   // stack 1 out
static i32 a2[PAD(S2)][PAD(S2)][F2];   // stack 2 inner
static i32 p2[PAD(S2)][PAD(S2)][F2];   // stack 2 shortcut
static i32 y2[PAD(S2)][PAD(S2)][F2];   // stack 2 out
static i32 a3[PAD(S3)][PAD(S3)][F3];
static i32 p3[PAD(S3)][PAD(S3)][F3];
static i32 y3[PAD(S3)][PAD(S3)][F3];
static i32 pooled[F3];
static i32 logits[NUM_CLASSES];

// Weights [co][ky][kx][ci], biases [co] (batch norm folded in)
static i32 w_conv1[F1][3][3][IN_CHANNELS], b_conv1[F1];
static i32 w_s1a[F1][3][3][F1], b_s1a[F1];
static i32 w_s1b[F1][3][3][F1], b_s1b[F1];
static i32 w_s2a[F2][3][3][F1], b_s2a[F2];
static i32 w_s2b[F2][3][3][F2], b_s2b[F2];
static i32 w_s2p[F2][1][1][F1], b_s2p[F2];
static i32 w_s3a[F3][3][3][F2], b_s3a[F3];
static i32 w_s3b[F3][3][3][F3], b_s3b[F3];
static i32 w_s3p[F3][1][1][F2], b_s3p[F3];
static i32 w_fc[NUM_CLASSES][F3], b_fc[NUM_CLASSES];

static u32 lcg_state = 12345u;
static i32 rnd(i32 lo, i32 hi) {
    lcg_state = lcg_state * 1664525u + 1013904223u;
    return lo + (i32) ((lcg_state >> 16) % (u32) (hi - lo + 1));
}
static void fill(i32 *p, u32 n, i32 lo, i32 hi) {
    for (u32 i = 0; i < n; i++) p[i] = rnd(lo, hi);
}
#define FILL(a, lo, hi) fill((i32 *) (a), sizeof(a) / sizeof(i32), lo, hi)

static void init_data() {
    for (u32 y = 1; y <= S1; y++) {
        for (u32 x = 1; x <= S1; x++) {
            for (u32 c = 0; c < IN_CHANNELS; c++) image[y][x][c] = rnd(-ACT_MAX - 1, ACT_MAX);
        }
    }
    FILL(w_conv1, -2, 2); FILL(b_conv1, -64, 64);
    FILL(w_s1a, -2, 2);   FILL(b_s1a, -64, 64);
    FILL(w_s1b, -2, 2);   FILL(b_s1b, -64, 64);
    FILL(w_s2a, -2, 2);   FILL(b_s2a, -64, 64);
    FILL(w_s2b, -2, 2);   FILL(b_s2b, -64, 64);
    FILL(w_s2p, -2, 2);   FILL(b_s2p, -64, 64);
    FILL(w_s3a, -2, 2);   FILL(b_s3a, -64, 64);
    FILL(w_s3b, -2, 2);   FILL(b_s3b, -64, 64);
    FILL(w_s3p, -2, 2);   FILL(b_s3p, -64, 64);
    FILL(w_fc, -2, 2);    FILL(b_fc, -64, 64);
}

// One convolution layer on padded channel-last maps.
//   in:  padded map of width in_pw, ci channels; out: padded map of width out_pw, co channels,
//   out_s x out_s interior. K = 3 ("same" padding, reads the border) or 1 (1x1, reads the
//   interior), stride 1 or 2. Output = clamp((bias + sum w*x) >> shift [+ residual] [ReLU]).
//   Channel-last storage makes each kernel tap's ci input channels contiguous in both the input
//   and the [co][ky][kx][ci] weights, so the innermost loop is a plain dot product over them.
static void conv(const i32 *in, u32 in_pw, u32 ci, const i32 *w, const i32 *bias,
                 u32 co, u32 k, u32 stride, u32 shift, i32 *out, u32 out_pw, u32 out_s,
                 const i32 *residual, int relu) {
    u32 off = (k == 1) ? 1 : 0;  // 1x1 kernels sample the interior pixel directly
    u32 rf = k * k * ci;
    for (u32 oy = 0; oy < out_s; oy++) {
        for (u32 ox = 0; ox < out_s; ox++) {
            const i32 *base = in + ((oy * stride + off) * in_pw + ox * stride + off) * ci;
            u32 o = ((oy + 1) * out_pw + (ox + 1)) * co;
            for (u32 c = 0; c < co; c++) {
                i32 acc = bias[c];
                const i32 *wc = w + c * rf;
                for (u32 ky = 0; ky < k; ky++) {
                    for (u32 kx = 0; kx < k; kx++) {
                        const i32 *px = base + (ky * in_pw + kx) * ci;
                        const i32 *wk = wc + (ky * k + kx) * ci;
                        for (u32 i = 0; i < ci; i++) acc += wk[i] * px[i];
                    }
                }
                i32 v = acc >> shift;
                if (residual) v += residual[o + c];
                if (relu && v < 0) v = 0;
                if (v > ACT_MAX) v = ACT_MAX;
                if (v < -ACT_MAX - 1) v = -ACT_MAX - 1;
                out[o + c] = v;
            }
        }
    }
}

#define CONV(in, s_in, ci, w, b, co, k, stride, sh, out, s_out, res, relu) \
    conv(&in[0][0][0], PAD(s_in), ci, &w[0][0][0][0], b, co, k, stride, sh, &out[0][0][0], PAD(s_out), s_out, res, relu)

// ResNet-8 forward pass (resnet8() below; MLPerf Tiny resnet_v1_eembc, link in the file header).
// Shapes are H x W x C at the default sizes. Every conv also requantizes and clamps its output
// (file header); s<n>p are the 1x1 projection shortcuts of the downsampling stacks.
//
//                   image 32x32x3
//                         |
//                +----------------+
//                | conv1 3x3, 16  |
//                | ReLU           |
//                +----------------+
//                         | x1 32x32x16
//            .------------+------------.
//            |                         |             stack 1
//            |                +----------------+
//            |                | s1a 3x3, 16    |
//            |                | ReLU           |
//            |                +----------------+
//            |                         | a1 32x32x16
//            |                +----------------+
//            |                | s1b 3x3, 16    |
//            |                +----------------+
//            | identity                |
//            '---------> (+) <---------'
//                         | ReLU
//                         | y1 32x32x16
//            .------------+------------.
//            |                         |             stack 2
//   +----------------+        +----------------+
//   | s2p 1x1, 32    |        | s2a 3x3, 32    |
//   | stride 2       |        | stride 2, ReLU |
//   +----------------+        +----------------+
//            |                         | a2 16x16x32
//            |                +----------------+
//            |                | s2b 3x3, 32    |
//            |                +----------------+
//            | p2 16x16x32             |
//            '---------> (+) <---------'
//                         | ReLU
//                         | y2 16x16x32
//            .------------+------------.
//            |                         |             stack 3
//   +----------------+        +----------------+
//   | s3p 1x1, 64    |        | s3a 3x3, 64    |
//   | stride 2       |        | stride 2, ReLU |
//   +----------------+        +----------------+
//            |                         | a3 8x8x64
//            |                +----------------+
//            |                | s3b 3x3, 64    |
//            |                +----------------+
//            | p3 8x8x64               |
//            '---------> (+) <---------'
//                         | ReLU
//                         | y3 8x8x64
//                +----------------+
//                | avg pool 8x8   |
//                +----------------+
//                         | pooled 64
//                +----------------+
//                | dense, 10      |
//                +----------------+
//                         |
//                   logits 10  -> argmax = class

// Stages (bench_mark ids, see benchmarks/common/bench.h): 0 = start, 1 = conv1, 2 = stack1,
// 3 = stack2, 4 = stack3, 5 = head (average pool + dense).

static void resnet8() {
    bench_mark(0);
    CONV(image, S1, IN_CHANNELS, w_conv1, b_conv1, F1, 3, 1, SH_CONV1, x1, S1, 0, 1);
    bench_mark(1);

    // Stack 1: identity shortcut
    CONV(x1, S1, F1, w_s1a, b_s1a, F1, 3, 1, SH_3x3_F1, a1, S1, 0, 1);
    CONV(a1, S1, F1, w_s1b, b_s1b, F1, 3, 1, SH_3x3_F1, y1, S1, &x1[0][0][0], 1);
    bench_mark(2);

    // Stack 2: stride 2, 1x1 projection shortcut
    CONV(y1, S1, F1, w_s2a, b_s2a, F2, 3, 2, SH_3x3_F1, a2, S2, 0, 1);
    CONV(y1, S1, F1, w_s2p, b_s2p, F2, 1, 2, SH_PROJ, p2, S2, 0, 0);
    CONV(a2, S2, F2, w_s2b, b_s2b, F2, 3, 1, SH_3x3_F2, y2, S2, &p2[0][0][0], 1);
    bench_mark(3);

    // Stack 3: stride 2, 1x1 projection shortcut
    CONV(y2, S2, F2, w_s3a, b_s3a, F3, 3, 2, SH_3x3_F2, a3, S3, 0, 1);
    CONV(y2, S2, F2, w_s3p, b_s3p, F3, 1, 2, SH_PROJ, p3, S3, 0, 0);
    CONV(a3, S3, F3, w_s3b, b_s3b, F3, 3, 1, SH_3x3_F3, y3, S3, &p3[0][0][0], 1);
    bench_mark(4);

    // Head: global average pool (S3*S3 = 64 at the default size, a power of two) + dense
    for (u32 c = 0; c < F3; c++) {
        i32 sum = 0;
        for (u32 y = 1; y <= S3; y++) {
            for (u32 x = 1; x <= S3; x++) sum += y3[y][x][c];
        }
        pooled[c] = sum / (S3 * S3);
    }
    for (u32 o = 0; o < NUM_CLASSES; o++) {
        i32 acc = b_fc[o];
        for (u32 c = 0; c < F3; c++) acc += w_fc[o][c] * pooled[c];
        logits[o] = acc;
    }
    bench_mark(5);

}

static u32 argmax() {
    u32 best = 0;
    for (u32 o = 1; o < NUM_CLASSES; o++) {
        if (logits[o] > logits[best]) best = o;
    }
    return best;
}

int main() {
    printf("resnet8: ResNet-8 forward pass (IMG=%dx%dx%d FILTERS=%d/%d/%d CLASSES=%d)\n",
           IMG_SIZE, IMG_SIZE, IN_CHANNELS, F1, F2, F3, NUM_CLASSES);

    init_data();
    resnet8();
    printf("argmax class: %u\n", (unsigned) argmax());

    // Hash the final feature map (interior and border) as well as the logits, so an error in any
    // layer shows up even if the 10 logits happen to agree.
    u32 h = bench_hash(BENCH_FNV_INIT, &y3[0][0][0], sizeof(y3) / sizeof(i32));
    h = bench_hash(h, logits, NUM_CLASSES);
    return bench_report("resnet8", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
