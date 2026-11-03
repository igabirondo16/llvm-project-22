// BERT_TINY benchmark: forward pass of BERT-tiny (Turc et al., 2019, "Well-Read Students Learn
// Better", https://arxiv.org/abs/1908.08962; google-research/bert's L=2 H=128 A=2 model) on a
// 32-token sequence: embeddings (token + position + segment) -> layer norm -> 2 post-LN encoder
// layers (2-head self-attention -> add&norm -> GELU feed-forward 128->512->128 -> add&norm) ->
// pooler (dense + tanh on the first, [CLS], token) -> classifier. ~13.1M MACs per sequence.
// The same encoder block as benchmarks/transformer, at real model size, multi-head, with biases
// on every dense layer and the embedding and pooler stages BERT adds around it.
//
// Integer-only, the way int8 inference runtimes run it:
//   - activations are int8-range values (stored as i32 like the other benchmarks) with a fixed
//     scale of 1/ACT_SCALE (1/32, i.e. +-4.0 at the int8 limits); every dense layer requantizes
//     its accumulator with a power-of-two shift and clamps to [-128, 127].
//   - softmax: max-subtracted scores looked up in a Q8 exp table (half-unit steps); the context
//     is normalized with one reciprocal of the row's exp sum, not a divide per element.
//   - GELU and tanh: 256-entry tables over the int8 input range, precomputed offline as plain
//     integers (round(32 * gelu(x/32)), round(127 * tanh(x/32))) - no floating point anywhere.
//   - layer norm: integer mean/variance, Newton integer sqrt (as in transformer) and one
//     reciprocal of the std per token, gamma/beta in the same 1/ACT_SCALE fixed point.
// The vocabulary is a synthetic VOCAB_SIZE (BERT's 30522-word table alone would be 15.6 MB as
// i32 - more than gazmusino's 16 MiB DRAM - and the lookup does no arithmetic either way).
// Weights, embeddings and token ids are pseudo-random (fixed LCG seed), generated untimed.
//
// Plain C version: no intrinsics or inline asm, so the compiler alone decides how to vectorize
// it. Same data, layers and checksum as main.c (the hand-written repeat-MAC/LSU version, which
// runs the dense layers, attention dot products and residual adds in 8-wide MAC/LSU bursts).

#ifndef NUM_TOKENS
    #define NUM_TOKENS 32
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef HIDDEN
    #define HIDDEN 128           // BERT-tiny's H
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef NUM_HEADS
    #define NUM_HEADS 2          // BERT-tiny's A
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef FFN_WIDTH
    #define FFN_WIDTH 512        // 4 * H
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef NUM_LAYERS
    #define NUM_LAYERS 2         // BERT-tiny's L
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef VOCAB_SIZE
    #define VOCAB_SIZE 1024
#else
    #define BENCH_CUSTOM_SIZES
#endif
#ifndef NUM_CLASSES
    #define NUM_CLASSES 2        // e.g. a sentence-pair / sentiment head
#else
    #define BENCH_CUSTOM_SIZES
#endif

#include "../../benchmarks/common/bench.h"

#define GOLDEN_CHECKSUM 0x2da5163cu

#define HEAD_DIM (HIDDEN / NUM_HEADS)

#define ACT_MAX 127
#define ACT_SCALE 32             // activation fixed point: value = x / ACT_SCALE

// Requantization shifts, ~log2 of each dense layer's accumulator gain (sqrt(fan-in) * weight rms)
#define SH_QKV 4                 // fan-in HIDDEN (128)
#define SH_ATTN_OUT 4            // fan-in HIDDEN
#define SH_FFN1 4                // fan-in HIDDEN
#define SH_FFN2 5                // fan-in FFN_WIDTH (512)
#define SH_POOL 4                // fan-in HIDDEN
// Attention score -> exp-table index (half units): q.k / sqrt(HEAD_DIM), in the 1/ACT_SCALE^2
// fixed point of q*k, times 2 for the table's half-unit steps
#define SCORE_SHIFT 11

#define EXP_STEPS 16
// Q8 exp(-k/2), k = 0..15 (e^-8 rounds to 0 beyond that)
static const i32 EXP_LUT[EXP_STEPS] = {256, 155, 94, 57, 35, 21, 13, 8, 5, 3, 2, 1, 1, 0, 0, 0};

// round(32 * gelu(x / 32)) for x = -128..127
static const i32 GELU_LUT[256] = {
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
       0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
       0,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
      -1,   -2,   -2,   -2,   -2,   -2,   -2,   -2,   -2,   -2,   -2,   -3,   -3,   -3,   -3,   -3,
      -3,   -3,   -3,   -4,   -4,   -4,   -4,   -4,   -4,   -4,   -4,   -5,   -5,   -5,   -5,   -5,
      -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
      -5,   -5,   -5,   -4,   -4,   -4,   -4,   -4,   -3,   -3,   -3,   -2,   -2,   -1,   -1,    0,
       0,    1,    1,    2,    2,    3,    3,    4,    5,    5,    6,    7,    8,    9,    9,   10,
      11,   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,   25,   26,
      27,   28,   29,   30,   31,   32,   34,   35,   36,   37,   38,   39,   40,   41,   43,   44,
      45,   46,   47,   48,   49,   50,   52,   53,   54,   55,   56,   57,   58,   59,   60,   61,
      63,   64,   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,   75,   76,   77,   78,
      80,   81,   82,   83,   84,   85,   86,   87,   88,   89,   90,   91,   92,   93,   94,   95,
      96,   97,   98,   99,  100,  101,  102,  103,  104,  105,  106,  107,  108,  109,  110,  111,
     112,  113,  114,  115,  116,  117,  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
};

// round(127 * tanh(x / 32)) for x = -128..127
static const i32 TANH_LUT[256] = {
    -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
    -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -127, -126, -126, -126,
    -126, -126, -126, -126, -126, -126, -126, -126, -126, -126, -126, -126, -126, -126, -125, -125,
    -125, -125, -125, -125, -125, -125, -125, -124, -124, -124, -124, -124, -123, -123, -123, -123,
    -122, -122, -122, -122, -121, -121, -120, -120, -120, -119, -119, -118, -118, -117, -116, -116,
    -115, -114, -113, -113, -112, -111, -110, -109, -108, -107, -105, -104, -103, -101, -100,  -98,
     -97,  -95,  -93,  -91,  -89,  -87,  -85,  -83,  -81,  -78,  -76,  -73,  -70,  -68,  -65,  -62,
     -59,  -56,  -52,  -49,  -46,  -42,  -38,  -35,  -31,  -27,  -24,  -20,  -16,  -12,   -8,   -4,
       0,    4,    8,   12,   16,   20,   24,   27,   31,   35,   38,   42,   46,   49,   52,   56,
      59,   62,   65,   68,   70,   73,   76,   78,   81,   83,   85,   87,   89,   91,   93,   95,
      97,   98,  100,  101,  103,  104,  105,  107,  108,  109,  110,  111,  112,  113,  113,  114,
     115,  116,  116,  117,  118,  118,  119,  119,  120,  120,  120,  121,  121,  122,  122,  122,
     122,  123,  123,  123,  123,  124,  124,  124,  124,  124,  125,  125,  125,  125,  125,  125,
     125,  125,  125,  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,  126,
     126,  126,  126,  126,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,
     127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,  127,
};

static i32 clamp8(i32 v) {
    if (v > ACT_MAX) return ACT_MAX;
    if (v < -ACT_MAX - 1) return -ACT_MAX - 1;
    return v;
}

// Newton's method integer square root - exact floor(sqrt(v)), v >= 0 (as in transformer)
static i32 isqrt(i32 v) {
    if (v <= 0) return 0;
    i32 x = v;
    i32 y = (x + 1) / 2;
    while (y < x) {
        x = y;
        y = (x + v / x) / 2;
    }
    return x;
}

// Model parameters. Dense weights are [out][in] (each output's weights contiguous).
typedef struct {
    i32 wq[HIDDEN][HIDDEN], bq[HIDDEN];
    i32 wk[HIDDEN][HIDDEN], bk[HIDDEN];
    i32 wv[HIDDEN][HIDDEN], bv[HIDDEN];
    i32 wo[HIDDEN][HIDDEN], bo[HIDDEN];
    i32 gamma1[HIDDEN], beta1[HIDDEN];
    i32 w1[FFN_WIDTH][HIDDEN], b1[FFN_WIDTH];
    i32 w2[HIDDEN][FFN_WIDTH], b2[HIDDEN];
    i32 gamma2[HIDDEN], beta2[HIDDEN];
} layer_t;

static i32 tok_emb[VOCAB_SIZE][HIDDEN];
static i32 pos_emb[NUM_TOKENS][HIDDEN];
static i32 seg_emb[HIDDEN];                // segment A (single-segment input)
static i32 emb_gamma[HIDDEN], emb_beta[HIDDEN];
static layer_t layers[NUM_LAYERS];
static i32 w_pool[HIDDEN][HIDDEN], b_pool[HIDDEN];
static i32 w_cls[NUM_CLASSES][HIDDEN], b_cls[NUM_CLASSES];

static u32 token_ids[NUM_TOKENS];

// Activations
static i32 hidden[NUM_TOKENS][HIDDEN];     // the encoder's running hidden state
static i32 sum_buf[NUM_TOKENS][HIDDEN];    // embedding sum / residual sums before layer norm
static i32 Q[NUM_TOKENS][HIDDEN], K[NUM_TOKENS][HIDDEN], V[NUM_TOKENS][HIDDEN];
static i32 context[NUM_TOKENS][HIDDEN];    // attention output, heads concatenated
static i32 attn_out[NUM_TOKENS][HIDDEN];
static i32 ffn_hidden[NUM_TOKENS][FFN_WIDTH];
static i32 ffn_out[NUM_TOKENS][HIDDEN];
static i32 pooled[HIDDEN];
static i32 logits[NUM_CLASSES];

static u32 lcg_state = 12345u;
static i32 rnd(i32 lo, i32 hi) {
    lcg_state = lcg_state * 1664525u + 1013904223u;
    return lo + (i32) ((lcg_state >> 16) % (u32) (hi - lo + 1));
}
static void fill(i32 *p, u32 n, i32 lo, i32 hi) {
    for (u32 i = 0; i < n; i++) p[i] = rnd(lo, hi);
}
#define FILL(a, lo, hi) fill((i32 *) (a), sizeof(a) / sizeof(i32), lo, hi)

static void init_norm(i32 *gamma, i32 *beta) {
    for (u32 d = 0; d < HIDDEN; d++) {
        gamma[d] = ACT_SCALE + rnd(-4, 4);  // ~1.0 in 1/ACT_SCALE fixed point
        beta[d] = rnd(-4, 4);
    }
}

static void init_data() {
    FILL(tok_emb, -48, 48);
    FILL(pos_emb, -16, 16);
    FILL(seg_emb, -8, 8);
    init_norm(emb_gamma, emb_beta);
    for (u32 l = 0; l < NUM_LAYERS; l++) {
        layer_t *L = &layers[l];
        FILL(L->wq, -2, 2); FILL(L->bq, -32, 32);
        FILL(L->wk, -2, 2); FILL(L->bk, -32, 32);
        FILL(L->wv, -2, 2); FILL(L->bv, -32, 32);
        FILL(L->wo, -2, 2); FILL(L->bo, -32, 32);
        init_norm(L->gamma1, L->beta1);
        FILL(L->w1, -2, 2); FILL(L->b1, -32, 32);
        FILL(L->w2, -2, 2); FILL(L->b2, -32, 32);
        init_norm(L->gamma2, L->beta2);
    }
    FILL(w_pool, -2, 2); FILL(b_pool, -32, 32);
    FILL(w_cls, -2, 2);  FILL(b_cls, -32, 32);
    token_ids[0] = 1;  // [CLS]
    for (u32 t = 1; t < NUM_TOKENS; t++) token_ids[t] = (u32) rnd(0, VOCAB_SIZE - 1);
}

// acc + sum_{i<n} a[i] * b[i], both arrays contiguous
static i32 dot(i32 acc, const i32 *a, const i32 *b, u32 n) {
    for (u32 i = 0; i < n; i++) acc += a[i] * b[i];
    return acc;
}

// out[i] = a[i] + b[i]; out may alias a or b
static void vadd(const i32 *a, const i32 *b, i32 *out, u32 n) {
    for (u32 i = 0; i < n; i++) out[i] = a[i] + b[i];
}

// out[t][o] = clamp((b[o] + sum_i in[t][i] * w[o][i]) >> shift), for NUM_TOKENS rows
static void dense(const i32 *in, u32 in_w, const i32 *w, const i32 *b, u32 out_w, u32 shift, i32 *out) {
    for (u32 t = 0; t < NUM_TOKENS; t++) {
        const i32 *x = in + t * in_w;
        for (u32 o = 0; o < out_w; o++) {
            const i32 *wo = w + o * in_w;
            i32 acc = dot(b[o], x, wo, in_w);
            out[t * out_w + o] = clamp8(acc >> shift);
        }
    }
}

// Per-token layer norm of in[t] (HIDDEN values) into out[t], in the 1/ACT_SCALE fixed point:
// out = clamp(gamma * (x - mean) / std + beta). Inputs are sums of two int8-range values
// (|x| <= 255), so the sum of squared deviations fits in i32 (< 128 * 510^2).
static void layer_norm(const i32 in[NUM_TOKENS][HIDDEN], i32 out[NUM_TOKENS][HIDDEN],
                       const i32 *gamma, const i32 *beta) {
    for (u32 t = 0; t < NUM_TOKENS; t++) {
        i32 sum = 0;
        for (u32 d = 0; d < HIDDEN; d++) sum += in[t][d];
        i32 mean = sum / HIDDEN;
        i32 varsum = 0;
        for (u32 d = 0; d < HIDDEN; d++) {
            i32 diff = in[t][d] - mean;
            varsum += diff * diff;
        }
        i32 std = isqrt(varsum / HIDDEN + 1);
        i32 inv_std = (ACT_SCALE << 16) / std;  // one divide per token: ACT_SCALE / std in Q16
        for (u32 d = 0; d < HIDDEN; d++) {
            i32 normalized = ((in[t][d] - mean) * inv_std) >> 16;  // (x - mean) / std, scale ACT_SCALE
            out[t][d] = clamp8(((gamma[d] * normalized) >> 5) + beta[d]);  // gamma in Q5 (ACT_SCALE = 32)
        }
    }
}

// Multi-head scaled-dot-product attention over Q, K, V (heads concatenated along HIDDEN)
static void attention() {
    for (u32 h = 0; h < NUM_HEADS; h++) {
        u32 hd = h * HEAD_DIM;
        for (u32 i = 0; i < NUM_TOKENS; i++) {
            i32 score[NUM_TOKENS];
            i32 smax = -0x7fffffff;
            for (u32 j = 0; j < NUM_TOKENS; j++) {
                i32 qk = dot(0, &Q[i][hd], &K[j][hd], HEAD_DIM);
                score[j] = qk >> SCORE_SHIFT;
                if (score[j] > smax) smax = score[j];
            }
            // softmax numerators: exp(score - max) from the Q8 table; esum >= 256 (the max's own entry)
            i32 esum = 0;
            for (u32 j = 0; j < NUM_TOKENS; j++) {
                i32 k = smax - score[j];
                score[j] = EXP_LUT[k < EXP_STEPS ? k : EXP_STEPS - 1];
                esum += score[j];
            }
            i32 recip = (1 << 16) / esum;  // one divide per row
            for (u32 d = 0; d < HEAD_DIM; d++) {
                i32 acc = 0;
                for (u32 j = 0; j < NUM_TOKENS; j++) acc += score[j] * V[j][hd + d];  // column of V
                context[i][hd + d] = clamp8((acc * recip) >> 16);
            }
        }
    }
}

static void encoder_layer(const layer_t *L) {
    dense(&hidden[0][0], HIDDEN, &L->wq[0][0], L->bq, HIDDEN, SH_QKV, &Q[0][0]);
    dense(&hidden[0][0], HIDDEN, &L->wk[0][0], L->bk, HIDDEN, SH_QKV, &K[0][0]);
    dense(&hidden[0][0], HIDDEN, &L->wv[0][0], L->bv, HIDDEN, SH_QKV, &V[0][0]);
    attention();
    dense(&context[0][0], HIDDEN, &L->wo[0][0], L->bo, HIDDEN, SH_ATTN_OUT, &attn_out[0][0]);
    vadd(&hidden[0][0], &attn_out[0][0], &sum_buf[0][0], NUM_TOKENS * HIDDEN);
    layer_norm(sum_buf, hidden, L->gamma1, L->beta1);

    dense(&hidden[0][0], HIDDEN, &L->w1[0][0], L->b1, FFN_WIDTH, SH_FFN1, &ffn_hidden[0][0]);
    for (u32 t = 0; t < NUM_TOKENS; t++) {
        for (u32 f = 0; f < FFN_WIDTH; f++) ffn_hidden[t][f] = GELU_LUT[ffn_hidden[t][f] + 128];
    }
    dense(&ffn_hidden[0][0], FFN_WIDTH, &L->w2[0][0], L->b2, HIDDEN, SH_FFN2, &ffn_out[0][0]);
    vadd(&hidden[0][0], &ffn_out[0][0], &sum_buf[0][0], NUM_TOKENS * HIDDEN);
    layer_norm(sum_buf, hidden, L->gamma2, L->beta2);
}

// BERT-tiny forward pass (bert_tiny() below). Shapes at the default sizes: T = NUM_TOKENS (32),
// H = HIDDEN (128), NUM_HEADS (2) heads of HEAD_DIM (64), FFN_WIDTH (512).
//
//             token ids (T)
//                   |
//     +----------------------------------------+
//     | tok_emb[id] + pos_emb[t] + seg_emb     |
//     | layer_norm                             |
//     +----------------------------------------+
//                   |  hidden (T x H)
//  .----------------|---- encoder layer, x NUM_LAYERS (2) --------.
//  |                |------------------------------.              |
//  |                v                              |              |
//  |  +----------------------------------------+   |              |
//  |  | Q, K, V = dense(hidden)   3 x (H -> H) |   |              |
//  |  | per head: softmax(Q K^T / sqrt(64)) V  |   |              |
//  |  | attn_out = dense(context)     H -> H   |   |              |
//  |  +----------------------------------------+   |              |
//  |                |                              |              |
//  |               (+)<----------------------------'              |
//  |                |  layer_norm                                 |
//  |                |------------------------------.              |
//  |                v                              |              |
//  |  +----------------------------------------+   |              |
//  |  | dense H -> FFN_WIDTH, GELU             |   |              |
//  |  | dense FFN_WIDTH -> H                   |   |              |
//  |  +----------------------------------------+   |              |
//  |                |                              |              |
//  |               (+)<----------------------------'              |
//  |                |  layer_norm                                 |
//  '----------------|---------------------------------------------'
//                   |  hidden (T x H)
//     +----------------------------------------+
//     | pooler: tanh(dense(hidden[0]))  [CLS]  |
//     | classifier: dense  H -> NUM_CLASSES    |
//     +----------------------------------------+
//                   |
//             logits (NUM_CLASSES)

// Stages (bench_mark ids, see benchmarks/common/bench.h): 0 = start, 1 = embeddings,
// 2 .. 1 + NUM_LAYERS = encoder layer 0 .. NUM_LAYERS - 1, 2 + NUM_LAYERS = head (pooler + classifier).

static void bert_tiny() {
    bench_mark(0);
    for (u32 t = 0; t < NUM_TOKENS; t++) {
        vadd(tok_emb[token_ids[t]], pos_emb[t], sum_buf[t], HIDDEN);
        vadd(sum_buf[t], seg_emb, sum_buf[t], HIDDEN);
    }
    layer_norm(sum_buf, hidden, emb_gamma, emb_beta);
    bench_mark(1);

    for (u32 l = 0; l < NUM_LAYERS; l++) {
        encoder_layer(&layers[l]);
        bench_mark(2 + l);
    }

    for (u32 o = 0; o < HIDDEN; o++) {
        i32 acc = dot(b_pool[o], hidden[0], w_pool[o], HIDDEN);
        pooled[o] = TANH_LUT[clamp8(acc >> SH_POOL) + 128];
    }
    for (u32 c = 0; c < NUM_CLASSES; c++) {
        i32 acc = dot(b_cls[c], pooled, w_cls[c], HIDDEN);
        logits[c] = acc;
    }
    bench_mark(2 + NUM_LAYERS);
}

int main() {
    printf("bert_tiny: BERT-tiny forward pass (TOKENS=%d HIDDEN=%d HEADS=%d FFN=%d LAYERS=%d CLASSES=%d)\n",
           NUM_TOKENS, HIDDEN, NUM_HEADS, FFN_WIDTH, NUM_LAYERS, NUM_CLASSES);

    init_data();
    bert_tiny();
    for (u32 c = 0; c < NUM_CLASSES; c++) printf("logit[%u] = %d\n", (unsigned) c, (int) logits[c]);

    // Hash the final hidden states as well as the logits, so an error in any token/layer shows
    // up even if the few logits happen to agree.
    u32 h = bench_hash(BENCH_FNV_INIT, &hidden[0][0], NUM_TOKENS * HIDDEN);
    h = bench_hash(h, logits, NUM_CLASSES);
    return bench_report("bert_tiny", h, BENCH_CHECK, GOLDEN_CHECKSUM);
}
