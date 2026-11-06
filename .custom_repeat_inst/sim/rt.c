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
        default: CONSOLE = *fmt;
        }
    }
    va_end(ap);
    return 0;
}
