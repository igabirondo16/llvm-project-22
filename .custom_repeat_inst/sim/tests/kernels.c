// Differential test of the VRF code generation: every kernel is compiled once for scalar
// rv32imf (the reference) and once for rv32im_xrepeat (vectorized into f-register blocks), and
// run_tests.sh checks that both print the same hashes. Each kernel prints one line, so a mismatch
// names the kernel. N (runtime-sized loops) is set with -DN=...; the constant-size loops use 8,
// 16, 24 and 64 elements.
//
// A kernel name ending in '~' may legally differ from scalar code; run_tests.sh only lists it.
// (None does now. fdot did until Phase 15: `s += a[i] * b[i]` is llvm.fmuladd, which scalar code
// fuses, and the loop vectorizer split it into a vector fmul + an in-order fadd. With XRepeat it
// now marks both `contract` and the backend fuses them into fmadd.s + REPEAT. fdot_nc is the
// same loop with contraction off.)
#include <stdio.h>
#include <stdint.h>

#ifndef N
#define N 37
#endif
#define NMAX 512
#define NI __attribute__((noinline))

typedef int32_t i32;
typedef uint32_t u32;

static u32 seed = 12345;
static u32 rnd(void) { return seed = seed * 1103515245u + 12345u; }

static i32 A[NMAX], B[NMAX], C[NMAX], D[NMAX];
static float FA[NMAX], FB[NMAX], FC[NMAX], FD[NMAX];
// Inputs for the min/max kernels: NaN, signed zeros, infinities, the clamp bounds and values
// next to them, between ordinary values.
static float FS[NMAX];
static float f_bits(u32 b) { union { u32 u; float f; } v = {b}; return v.f; }

static u32 hash(const void *p, int n) {
    const u32 *w = (const u32 *) p;
    u32 h = 0x811c9dc5u;
    for (int i = 0; i < n; i++) h = (h ^ w[i]) * 16777619u;
    return h;
}

static void init(void) {
    for (int i = 0; i < NMAX; i++) {
        A[i] = (i32) rnd() >> 8;
        B[i] = (i32) (rnd() % 2001) - 1000;
        C[i] = (i32) rnd();
        D[i] = 0;
        // Floats with full mantissas and mixed signs and magnitudes, so rounding matters.
        FA[i] = (float) ((i32) rnd() >> 4) / 4096.0f;
        FB[i] = (float) ((i32) rnd() >> 6) / 65536.0f;
        FC[i] = (float) ((i32) rnd() >> 10) * 3.0f;
        FD[i] = 0;
    }
    static const u32 special[] = {0x7fc00000u, 0x00000000u, 0x80000000u, 0x7f800000u, 0xff800000u,
                                  0x42fe0000u /* 127 */, 0xc3000000u /* -128 */, 0x42fe0001u,
                                  0xc3000001u, 0x3f800000u /* 1 */, 0xbf800000u /* -1 */};
    for (int i = 0; i < NMAX; i++)
        FS[i] = (i % 3 == 0) ? f_bits(special[(i / 3) % (sizeof special / sizeof special[0])])
                             : (float) ((i32) rnd() >> 22);
}

#define REPORT(name, ptr, n) printf("%s %08x\n", name, hash(ptr, n))
#define REPORT1(name, v) do { u32 t_ = 0; __builtin_memcpy(&t_, &(v), 4); \
    printf("%s %08x\n", name, t_); } while (0)

// ---- integer, runtime n
NI void k_add(i32 *d, const i32 *a, const i32 *b, int n) { for (int i = 0; i < n; i++) d[i] = a[i] + b[i]; }
NI void k_sub(i32 *d, const i32 *a, const i32 *b, int n) { for (int i = 0; i < n; i++) d[i] = a[i] - b[i]; }
NI void k_logic(i32 *d, const i32 *a, const i32 *b, int n) {
    for (int i = 0; i < n; i++) d[i] = (a[i] & b[i]) ^ (a[i] | 0x5a5);
}
NI void k_shifts(i32 *d, const i32 *a, int n) {
    for (int i = 0; i < n; i++) d[i] = (a[i] << 3) + (a[i] >> 5) + (i32) ((u32) a[i] >> 7);
}
NI void k_varshift(i32 *d, const i32 *a, int s, int n) {
    for (int i = 0; i < n; i++) d[i] = (a[i] << s) ^ (a[i] >> s);
}
NI void k_imm(i32 *d, const i32 *a, int n) { for (int i = 0; i < n; i++) d[i] = ((a[i] + 17) & 1023) | 4096; }
NI void k_mul(i32 *d, const i32 *a, const i32 *b, int n) { for (int i = 0; i < n; i++) d[i] = a[i] * b[i]; }
NI void k_scale(i32 *d, const i32 *a, i32 s, int n) { for (int i = 0; i < n; i++) d[i] = a[i] * s; }
NI void k_axpy(i32 *y, const i32 *x, i32 a, int n) { for (int i = 0; i < n; i++) y[i] = a * x[i] + y[i]; }
NI void k_mac3(i32 *d, const i32 *a, const i32 *b, const i32 *c, int n) {
    for (int i = 0; i < n; i++) d[i] = a[i] * b[i] + c[i];
}
NI void k_splatadd(i32 *d, const i32 *a, const i32 *s, int n) { for (int i = 0; i < n; i++) d[i] = a[i] + *s; }
NI void k_fill(i32 *d, i32 v, int n) { for (int i = 0; i < n; i++) d[i] = v; }
NI void k_inplace(i32 *d, int n) { for (int i = 0; i < n; i++) d[i] = d[i] * 3 + d[i]; }
NI i32 k_sum(const i32 *a, int n) { i32 s = 7; for (int i = 0; i < n; i++) s += a[i]; return s; }
NI i32 k_dot(const i32 *a, const i32 *b, int n) { i32 s = 0; for (int i = 0; i < n; i++) s += a[i] * b[i]; return s; }
NI i32 k_dotsplat(const i32 *a, i32 b, int n) { i32 s = 0; for (int i = 0; i < n; i++) s += a[i] * b; return s; }

// ---- integer, constant sizes (kept rolled / unrolled / 16-wide)
NI void k_c8(i32 *__restrict d, const i32 *a, const i32 *b) { for (int i = 0; i < 8; i++) d[i] = a[i] * b[i] - a[i]; }
NI void k_c16(i32 *y, i32 s) { for (int i = 0; i < 16; i++) y[i] = y[i] * s + 1; }
NI void k_c64(i32 *y, const i32 *x, i32 a) { for (int i = 0; i < 64; i++) y[i] += a * x[i]; }
NI void k_gep(i32 *__restrict c, const i32 *a, const i32 *b) {  // gepdot shape
    for (int k = 0; k < 8; k++)
        for (int v = 0; v < 8; v++) c[v] += a[k] * b[k * 8 + v];
}
NI i32 k_dot64(const i32 *a, const i32 *b) { i32 s = 0; for (int i = 0; i < 64; i++) s += a[i] * b[i]; return s; }
NI i32 k_sum24(const i32 *a) { i32 s = 0; for (int i = 0; i < 24; i++) s += a[i]; return s; }

// ---- straight-line (SLP)
NI void k_slp(i32 *__restrict d, const i32 *a, const i32 *b, i32 s) {
    d[0] = a[0] * s + b[0]; d[1] = a[1] * s + b[1]; d[2] = a[2] * s + b[2]; d[3] = a[3] * s + b[3];
    d[4] = a[4] * s + b[4]; d[5] = a[5] * s + b[5]; d[6] = a[6] * s + b[6]; d[7] = a[7] * s + b[7];
}
NI void k_slp16(i32 *d, const i32 *a, const i32 *b) {
    for (int i = 0; i < 16; i++) d[i] = (a[i] - b[i]) << 2;
}

// ---- register pressure: more 8-wide blocks live than fit (spills), and a block live across a call
NI void k_press(i32 *__restrict d, const i32 *a, const i32 *b, const i32 *c) {
    for (int i = 0; i < 8; i++) {
        i32 x = a[i] * b[i], y = b[i + 8] - c[i], z = c[i + 8] ^ a[i + 8], w = a[i + 16] + b[i + 16];
        d[i] = x + y; d[i + 8] = y * z; d[i + 16] = z - w; d[i + 24] = w * x;
    }
}
NI i32 opaque(i32 v) { __asm__ volatile("" : "+r"(v)); return v + 1; }
NI void k_call(i32 *__restrict d, const i32 *a, const i32 *b) {
    i32 t[8];
    for (int i = 0; i < 8; i++) t[i] = a[i] + b[i];
    i32 k = opaque(d[0]);
    for (int i = 0; i < 8; i++) d[i] = t[i] * k;
}

// ---- strided and interleaved accesses (Phase 16)
NI void k_col(i32 *__restrict o, const i32 *__restrict m) {   // column of a 16-wide matrix
    for (int i = 0; i < 8; i++) o[i] = m[i * 16] * 3 + m[i * 16 + 5];
}
NI void k_cmag(i32 *__restrict o, const i32 *__restrict c, int n) {   // interleaved load, factor 2
    for (int i = 0; i < n; i++) o[i] = c[2 * i] * c[2 * i] + c[2 * i + 1] * c[2 * i + 1];
}
NI void k_ilv(i32 *__restrict o, const i32 *__restrict re, const i32 *__restrict im, int n) {
    for (int i = 0; i < n; i++) { o[2 * i] = re[i] + 1; o[2 * i + 1] = im[i] * 2; }   // store, factor 2
}
NI void k_ilv4(i32 *__restrict o, const i32 *__restrict a, int n) {   // load and store, factor 4
    for (int i = 0; i < n; i++) {
        o[4 * i] = a[4 * i + 3]; o[4 * i + 1] = a[4 * i + 2] + 7;
        o[4 * i + 2] = a[4 * i + 1] ^ 255; o[4 * i + 3] = a[4 * i] - a[4 * i + 1];
    }
}
NI void k_ilvc(i32 *__restrict o, const i32 *__restrict a, int n) {   // a constant field
    for (int i = 0; i < n; i++) { o[2 * i] = a[i] << 2; o[2 * i + 1] = 0x77; }
}
NI void k_rev(i32 *__restrict d, const i32 *__restrict a) {   // reversed store (stride -4)
    d[7] = a[0] + 1; d[6] = a[1] + 1; d[5] = a[2] + 1; d[4] = a[3] + 1;
    d[3] = a[4] + 1; d[2] = a[5] + 1; d[1] = a[6] + 1; d[0] = a[7] + 1;
}
NI void f_cmag(float *__restrict o, const float *__restrict c, int n) {
    for (int i = 0; i < n; i++) o[i] = c[2 * i] * c[2 * i] + c[2 * i + 1] * c[2 * i + 1];
}
NI void f_ilv(float *__restrict o, const float *__restrict a, const float *__restrict b, int n) {
    for (int i = 0; i < n; i++) { o[2 * i] = a[i] + b[i]; o[2 * i + 1] = a[i] * b[i]; }
}

// ---- float, runtime n
NI void f_add(float *d, const float *a, const float *b, int n) { for (int i = 0; i < n; i++) d[i] = a[i] + b[i]; }
NI void f_sub(float *d, const float *a, const float *b, int n) { for (int i = 0; i < n; i++) d[i] = a[i] - b[i]; }
NI void f_mul(float *d, const float *a, const float *b, int n) { for (int i = 0; i < n; i++) d[i] = a[i] * b[i]; }
NI void f_axpy(float *y, const float *x, float a, int n) { for (int i = 0; i < n; i++) y[i] = a * x[i] + y[i]; }
NI void f_mac3(float *d, const float *a, const float *b, const float *c, int n) {
    for (int i = 0; i < n; i++) d[i] = a[i] * b[i] + c[i];
}
NI void f_fma(float *d, const float *a, const float *b, const float *c, int n) {
    for (int i = 0; i < n; i++) d[i] = __builtin_elementwise_fma(a[i], b[i], c[i]);
}
NI void f_scale(float *d, const float *a, float s, int n) { for (int i = 0; i < n; i++) d[i] = a[i] * s + 0.5f; }
NI float f_sum(const float *a, int n) { float s = 1.0f; for (int i = 0; i < n; i++) s += a[i]; return s; }
NI float f_dot(const float *a, const float *b, int n) {
    float s = 0; for (int i = 0; i < n; i++) s += a[i] * b[i]; return s;
}
NI float f_dot_nc(const float *a, const float *b, int n) {
#pragma clang fp contract(off)
    float s = 0; for (int i = 0; i < n; i++) s += a[i] * b[i]; return s;
}

// ---- float min/max (fmin.s/fmax.s + REPEAT where the select is exactly a min/max)
NI void f_relu(float *d, const float *a, int n) { for (int i = 0; i < n; i++) d[i] = a[i] > 0.0f ? a[i] : 0.0f; }
NI void f_clamp(float *d, const float *a, int n) {
    for (int i = 0; i < n; i++) { float v = a[i] > -128.0f ? a[i] : -128.0f; d[i] = v < 127.0f ? v : 127.0f; }
}
NI void f_clamp_ge(float *d, const float *a, int n) {
    for (int i = 0; i < n; i++) { float v = a[i] >= -128.0f ? a[i] : -128.0f; d[i] = v <= 127.0f ? v : 127.0f; }
}
NI void f_clamp_inv(float *d, const float *a, int n) {  // constant on the true side, inverse compare
    for (int i = 0; i < n; i++) d[i] = !(a[i] > -1.0f) ? -1.0f : a[i];
}
// Not exactly a min/max (a NaN, or -0.0 for +0.0): must stay compare + select.
NI void f_relu_nan(float *d, const float *a, int n) { for (int i = 0; i < n; i++) d[i] = a[i] < 0.0f ? 0.0f : a[i]; }
NI void f_negzero(float *d, const float *a, int n) { for (int i = 0; i < n; i++) d[i] = a[i] > -0.0f ? a[i] : -0.0f; }
NI void f_ge_zero(float *d, const float *a, int n) { for (int i = 0; i < n; i++) d[i] = a[i] >= 0.0f ? a[i] : 0.0f; }
NI void f_maxv(float *d, const float *a, const float *b, int n) {
    for (int i = 0; i < n; i++) d[i] = __builtin_fmaxf(a[i], b[i]);
}
NI void f_min8(float *d, const float *a) {
    for (int i = 0; i < 8; i++) d[i] = a[i] < 2.5f ? a[i] : 2.5f;
}

// ---- float, constant sizes
NI void f_c16(float *y, float s) { for (int i = 0; i < 16; i++) y[i] = y[i] * s + 1.0f; }
NI void f_c64(float *y, const float *x, float a) { for (int i = 0; i < 64; i++) y[i] = a * x[i] + y[i]; }
NI float f_sum64(const float *a) { float s = 0; for (int i = 0; i < 64; i++) s += a[i]; return s; }
NI void f_slp(float *__restrict d, const float *a, const float *b) {
    for (int i = 0; i < 8; i++) d[i] = (a[i] + b[i]) * a[i];
}

int main(void) {
    init();
    i32 r;
    float fr;
    k_add(D, A, B, N); REPORT("add", D, NMAX);
    k_sub(D, A, B, N); REPORT("sub", D, NMAX);
    k_logic(D, A, B, N); REPORT("logic", D, NMAX);
    k_shifts(D, A, N); REPORT("shifts", D, NMAX);
    k_varshift(D, A, 5, N); REPORT("varshift", D, NMAX);
    k_imm(D, C, N); REPORT("imm", D, NMAX);
    k_mul(D, A, B, N); REPORT("mul", D, NMAX);
    k_scale(D, A, -77, N); REPORT("scale", D, NMAX);
    k_axpy(D, B, 13, N); REPORT("axpy", D, NMAX);
    k_mac3(D, A, B, C, N); REPORT("mac3", D, NMAX);
    k_splatadd(D, A, &B[3], N); REPORT("splatadd", D, NMAX);
    k_fill(D, 0x1234567, N); REPORT("fill", D, NMAX);
    k_inplace(D, N); REPORT("inplace", D, NMAX);
    r = k_sum(A, N); REPORT1("sum", r);
    r = k_dot(A, B, N); REPORT1("dot", r);
    r = k_dotsplat(C, B[5], N); REPORT1("dotsplat", r);
    k_c8(D, A, B); REPORT("c8", D, NMAX);
    k_c16(D, -3); REPORT("c16", D, NMAX);
    k_c64(D, B, 9); REPORT("c64", D, NMAX);
    k_gep(D, A, B); REPORT("gep", D, NMAX);
    r = k_dot64(A, C); REPORT1("dot64", r);
    r = k_sum24(C); REPORT1("sum24", r);
    k_slp(D, A, B, 11); REPORT("slp", D, NMAX);
    k_slp16(D, A, B); REPORT("slp16", D, NMAX);
    k_press(D, A, B, C); REPORT("press", D, NMAX);
    k_call(D, A, B); REPORT("call", D, NMAX);
    k_col(D, A); REPORT("col", D, NMAX);
    k_cmag(D, A, N); REPORT("cmag", D, NMAX);
    k_ilv(D, A, B, N); REPORT("ilv", D, NMAX);
    k_ilv4(D, C, N); REPORT("ilv4", D, NMAX);
    k_ilvc(D, B, N); REPORT("ilvc", D, NMAX);
    k_rev(D, A); REPORT("rev", D, NMAX);
    f_cmag(FD, FA, N); REPORT("fcmag", FD, NMAX);
    f_ilv(FD, FA, FB, N); REPORT("filv", FD, NMAX);
    f_add(FD, FA, FB, N); REPORT("fadd", FD, NMAX);
    f_sub(FD, FA, FC, N); REPORT("fsub", FD, NMAX);
    f_mul(FD, FA, FB, N); REPORT("fmul", FD, NMAX);
    f_axpy(FD, FA, 1.37f, N); REPORT("faxpy", FD, NMAX);
    f_mac3(FD, FA, FB, FC, N); REPORT("fmac3", FD, NMAX);
    f_fma(FD, FB, FC, FA, N); REPORT("ffma", FD, NMAX);
    f_scale(FD, FC, -0.3f, N); REPORT("fscale", FD, NMAX);
    fr = f_sum(FA, N); REPORT1("fsum", fr);
    fr = f_dot(FA, FB, N); REPORT1("fdot", fr);
    fr = f_dot_nc(FA, FB, N); REPORT1("fdot_nc", fr);
    f_c16(FD, 0.7f); REPORT("fc16", FD, NMAX);
    f_c64(FD, FB, 2.5f); REPORT("fc64", FD, NMAX);
    fr = f_sum64(FC); REPORT1("fsum64", fr);
    f_slp(FD, FA, FB); REPORT("fslp", FD, NMAX);
    f_relu(FD, FS, N); REPORT("frelu", FD, NMAX);
    f_clamp(FD, FS, N); REPORT("fclamp", FD, NMAX);
    f_clamp_ge(FD, FS, N); REPORT("fclamp_ge", FD, NMAX);
    f_clamp_inv(FD, FS, N); REPORT("fclamp_inv", FD, NMAX);
    f_relu_nan(FD, FS, N); REPORT("frelu_nan", FD, NMAX);
    f_negzero(FD, FS, N); REPORT("fnegzero", FD, NMAX);
    f_ge_zero(FD, FS, N); REPORT("fge_zero", FD, NMAX);
    f_maxv(FD, FS, FA, N); REPORT("fmaxv", FD, NMAX);
    f_min8(FD, FS); REPORT("fmin8", FD, NMAX);
    return 0;
}
