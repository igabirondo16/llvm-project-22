// Minimal bare-metal runtime for the emulator: _start, printf over a console
// MMIO byte port, exit through ecall. Compiled without xrepeat.
#include <stdarg.h>

#define CONSOLE (*(volatile char *) 0x10000000u)

int main(void);

__attribute__((naked, section(".text.start"))) void _start(void) {
    __asm__ volatile(
        "la sp, __stack_top\n"
        "call main\n"
        "li a7, 93\n"
        "ecall\n");
}

static void puts_(const char *s) {
    while (*s) CONSOLE = *s++;
}

static void putu(unsigned v, unsigned base, int width, char pad) {
    char buf[16];
    int n = 0;
    do {
        buf[n++] = "0123456789abcdef"[v % base];
        v /= base;
    } while (v);
    while (n < width) buf[n++] = pad;
    while (n) CONSOLE = buf[--n];
}

int printf(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    for (; *fmt; fmt++) {
        if (*fmt != '%') {
            CONSOLE = *fmt;
            continue;
        }
        fmt++;
        char pad = ' ';
        int width = 0;
        if (*fmt == '0') pad = '0', fmt++;
        while (*fmt >= '0' && *fmt <= '9') width = width * 10 + (*fmt++ - '0');
        switch (*fmt) {
        case 'd': {
            int v = va_arg(ap, int);
            if (v < 0) CONSOLE = '-', v = -v;
            putu((unsigned) v, 10, width, pad);
            break;
        }
        case 'u': putu(va_arg(ap, unsigned), 10, width, pad); break;
        case 'x': putu(va_arg(ap, unsigned), 16, width, pad); break;
        case 's': puts_(va_arg(ap, const char *)); break;
        case 'f':
        case 'g': {
            // No soft-float formatting here: print the double's bits.
            union { double d; unsigned w[2]; } u = {va_arg(ap, double)};
            puts_("0x");
            putu(u.w[1], 16, 8, '0');
            putu(u.w[0], 16, 8, '0');
            break;
        }
        default: CONSOLE = *fmt;
        }
    }
    va_end(ap);
    return 0;
}

// float -> double, which printf("%g", (double) f) needs and there is no libgcc for (the f32
// benchmarks). Integer operations only, so it calls nothing else.
double __extendsfdf2(float a) {
    union { float f; unsigned u; } x = {a};
    unsigned e = (x.u >> 23) & 0xff, m = x.u & 0x7fffff;
    unsigned long long r = (unsigned long long) (x.u >> 31) << 63;
    if (e == 0xff) {
        r |= 0x7ffULL << 52 | (unsigned long long) m << 29;
    } else if (e != 0) {
        r |= (unsigned long long) (e - 127 + 1023) << 52 | (unsigned long long) m << 29;
    } else if (m) {  // subnormal: normalize
        int sh = 0;
        while (!(m & 0x800000)) m <<= 1, sh++;
        r |= (unsigned long long) (1023 - 126 - sh) << 52 | (unsigned long long) (m & 0x7fffff) << 29;
    }
    union { unsigned long long u; double d; } y = {r};
    return y.d;
}
