#!/usr/bin/env python3
"""Emulator of the two repeat_rv cores, for flat binaries loaded at address 0.

    rvsim.py [--core int|vrf] [--lax] program.bin

--core int  (default) the original core, compiled with -march=..._xrepeatint:
            RV32IM + xr.mac (custom-0, x registers) + REPEAT (custom-2) with
            stride = x[rs1], count = x[rs2]. A walking field on extra step k is
            field + k. Only lw and xr.mac may be repeated.
--core vrf  the VRF core (.custom_repeat_inst/ENCODINGS.md), compiled with
            -march=..._xrepeat: RV32IMF, where the f registers are the VRF and
            hold integers too, plus
              custom-1  xr.<alu> / xr.mac / xr.mv.vx / xr.mv.xv / xr.lw / xr.sw
              custom-3  xr.<alu>i
              custom-2  xr.repeat: mask = bits 31:28, stride = x[rs1],
                        count = rs2 field read as a literal (bits 23:20,
                        0..15; bit 24 ignored).
            Windowing: a walking register on extra step k is the base register
            with its low bits replaced by k (4/8/16-wide window for
            count <= 3 / <= 7 / else). Loads always walk rd; stores walk the
            value when mask[2] is set; the address of a repeated load or store
            is x[rs1] + imm + k * stride (stride signed).
            Repeatable: flw, fsw, xr.lw, xr.sw, xr.<alu>, xr.<alu>i, xr.mac,
            fadd.s, fsub.s, fmul.s, fmadd.s.

The repeated steps run one after another, each reading its sources and then
writing its result, so a fixed rd accumulates in element order.

Unless --lax is given, everything the compiler must never emit is an error
rather than silently windowed: a walking register that is not aligned to its
window, mask bits for operands the repeated instruction doesn't have, REPEAT of
an ineligible instruction, and a REPEAT that was not reached straight from the
instruction before it (e.g. a branch to the REPEAT).

F arithmetic is IEEE single precision, computed exactly and rounded once
(fmadd is fused); NaN results are the canonical NaN; fflags are not tracked.

Programs talk to the emulator through MMIO: a byte stored to 0x10000000 is
printed, a word stored to 0x10013000 (bench_mark) records the counters, and
`ecall` with a7 = 93 exits with a0. Counters: `insns` = retired instructions
(a REPEAT counts as 1), `steps` = insns + the extra repeated steps.
"""
import argparse
import math
import struct
import sys
from fractions import Fraction

CONSOLE = 0x10000000
MARK = 0x10013000
MASK32 = 0xFFFFFFFF
CANON_NAN = 0x7FC00000
SIGN = 0x80000000


def sx(v, bits):
    v &= (1 << bits) - 1
    return v - (1 << bits) if v >> (bits - 1) else v


class SimError(RuntimeError):
    pass


# ---------------------------------------------------------------- binary32 --

def f_isnan(b):
    return (b & 0x7F800000) == 0x7F800000 and (b & 0x7FFFFF) != 0


def f_isinf(b):
    return (b & 0x7FFFFFFF) == 0x7F800000


def f_iszero(b):
    return (b & 0x7FFFFFFF) == 0


def f_tofloat(b):
    return struct.unpack("<f", struct.pack("<I", b))[0]


def f_frac(b):
    """Exact value of a finite binary32."""
    return Fraction(f_tofloat(b))


def f_from_float(v):
    """binary32 bits of a Python float that is inf or NaN (special cases)."""
    if v != v:
        return CANON_NAN
    return 0x7F800000 | (SIGN if v < 0 else 0)


def round_int(q, rm, neg):
    """Round the non-negative Fraction q to an integer with rounding mode rm,
    where neg is the sign of the value q is the magnitude of."""
    n, r = divmod(q.numerator, q.denominator)
    if r == 0:
        return n
    half = Fraction(r, q.denominator)
    if rm == 0:  # RNE
        up = half > Fraction(1, 2) or (half == Fraction(1, 2) and n & 1)
    elif rm == 1:  # RTZ
        up = False
    elif rm == 2:  # RDN
        up = neg
    elif rm == 3:  # RUP
        up = not neg
    elif rm == 4:  # RMM
        up = half >= Fraction(1, 2)
    else:
        raise SimError(f"bad rounding mode {rm}")
    return n + 1 if up else n


def f_round(q, rm=0, zero_sign=0):
    """binary32 bits of the exact value q rounded with rm. zero_sign is the
    sign bit to use when q is exactly zero."""
    if q == 0:
        return zero_sign
    s = SIGN if q < 0 else 0
    a = abs(q)
    n, d = a.numerator, a.denominator
    e = n.bit_length() - d.bit_length()
    # Make 2^e <= a < 2^(e+1).
    if (n << max(0, -e)) < (d << max(0, e)):
        e -= 1
    e = max(e, -126)
    m = round_int(a * Fraction(2) ** (23 - e), rm, bool(s))
    if m >> 24:
        m >>= 1
        e += 1
    if e > 127:
        to_inf = rm in (0, 4) or (rm == 2 and s) or (rm == 3 and not s)
        return s | (0x7F800000 if to_inf else 0x7F7FFFFF)
    if m < (1 << 23):  # subnormal (e == -126) or zero after rounding
        return s | m
    return s | ((e + 127) << 23) | (m - (1 << 23))


def f_add(a, b, rm):
    if f_isnan(a) or f_isnan(b):
        return CANON_NAN
    if f_isinf(a) or f_isinf(b):
        return f_from_float(f_tofloat(a) + f_tofloat(b))
    if f_iszero(a) and f_iszero(b):  # sign of an exact zero sum (IEEE 754 6.3)
        zs = (a | b if rm == 2 else a & b) & SIGN
    else:
        zs = SIGN if rm == 2 else 0
    return f_round(f_frac(a) + f_frac(b), rm, zs)


def f_mul(a, b, rm):
    if f_isnan(a) or f_isnan(b):
        return CANON_NAN
    if f_isinf(a) or f_isinf(b):
        return f_from_float(f_tofloat(a) * f_tofloat(b))
    return f_round(f_frac(a) * f_frac(b), rm, (a ^ b) & SIGN)


def f_div(a, b, rm):
    if f_isnan(a) or f_isnan(b):
        return CANON_NAN
    s = (a ^ b) & SIGN
    if f_isinf(a):
        return CANON_NAN if f_isinf(b) else s | 0x7F800000
    if f_isinf(b):
        return s
    if f_iszero(b):
        return CANON_NAN if f_iszero(a) else s | 0x7F800000
    return f_round(f_frac(a) / f_frac(b), rm, s)


def f_sqrt(a, rm):
    if f_isnan(a) or (a & SIGN and not f_iszero(a)):
        return CANON_NAN
    if f_iszero(a) or f_isinf(a):
        return a
    # sqrt(q) to 60 fractional bits plus a sticky bit, then round to binary32.
    q = f_frac(a)
    k = 200
    v = (q.numerator << (2 * k)) // q.denominator
    r = math.isqrt(v)
    exact = r * r == v and (q.numerator << (2 * k)) % q.denominator == 0
    val = Fraction(r, 1 << k)
    if not exact:
        val += Fraction(1, 1 << (k + 1))  # sticky: between r and r + 1
    return f_round(val, rm)


def f_fma(a, b, c, rm, neg_prod=False, neg_add=False):
    """(neg_prod ? -1 : 1) * a * b + (neg_add ? -1 : 1) * c, rounded once."""
    if neg_prod:
        a ^= SIGN
    if neg_add:
        c ^= SIGN
    if f_isnan(a) or f_isnan(b) or f_isnan(c):
        return CANON_NAN
    if (f_isinf(a) and f_iszero(b)) or (f_iszero(a) and f_isinf(b)):
        return CANON_NAN
    if f_isinf(a) or f_isinf(b) or f_isinf(c):
        return f_from_float(f_tofloat(a) * f_tofloat(b) + f_tofloat(c))
    ps = (a ^ b) & SIGN
    exact = f_frac(a) * f_frac(b) + f_frac(c)
    prod_zero = f_iszero(a) or f_iszero(b)
    if prod_zero and f_iszero(c):
        zs = (ps | c if rm == 2 else ps & c) & SIGN
    else:
        zs = SIGN if rm == 2 else 0
    return f_round(exact, rm, zs)


def f_minmax(a, b, want_max):
    na, nb = f_isnan(a), f_isnan(b)
    if na and nb:
        return CANON_NAN
    if na:
        return b
    if nb:
        return a
    if f_iszero(a) and f_iszero(b):
        neg = (a | b) & SIGN if not want_max else (a & b) & SIGN
        return neg
    fa, fb = f_tofloat(a), f_tofloat(b)
    return (a if fa > fb else b) if want_max else (a if fa < fb else b)


def f_to_int(a, rm, unsigned):
    lo, hi = (0, MASK32) if unsigned else (-(1 << 31), (1 << 31) - 1)
    if f_isnan(a):
        return hi
    if f_isinf(a):
        return lo if a & SIGN else hi
    q = f_frac(a)
    neg = q < 0
    v = round_int(abs(q), rm, neg)
    v = -v if neg else v
    return min(max(v, lo), hi) & MASK32


def f_class(a):
    s = bool(a & SIGN)
    e = (a >> 23) & 0xFF
    m = a & 0x7FFFFF
    if e == 0xFF:
        if m == 0:
            return 1 << (0 if s else 7)
        return 1 << (9 if m >> 22 else 8)
    if e == 0:
        if m == 0:
            return 1 << (3 if s else 4)
        return 1 << (2 if s else 5)
    return 1 << (1 if s else 6)


# ---------------------------------------------------------------- the core --

# Integer ALU shared by OP, OP-IMM and the xr.* families. funct3 encoding.
def alu(f3, alt, a, b):
    sa, sb = sx(a, 32), sx(b, 32)
    if f3 == 0:
        r = a - b if alt else a + b
    elif f3 == 1:
        r = a << (b & 31)
    elif f3 == 2:
        r = int(sa < sb)
    elif f3 == 3:
        r = int(a < b)
    elif f3 == 4:
        r = a ^ b
    elif f3 == 5:
        r = (sa >> (b & 31)) if alt else (a >> (b & 31))
    elif f3 == 6:
        r = a | b
    else:
        r = a & b
    return r & MASK32


# xr.alu op (funct7[3:0], int_alu_op_t) -> (funct3, alt)
XR_ALU_OPS = {0x0: (0, 0), 0x1: (1, 0), 0x2: (2, 0), 0x3: (3, 0), 0x4: (4, 0),
              0x5: (5, 0), 0x6: (6, 0), 0x7: (7, 0), 0x8: (0, 1), 0xD: (5, 1)}


def muldiv(f3, a, b):
    sa, sb = sx(a, 32), sx(b, 32)
    if f3 == 0:
        r = a * b
    elif f3 == 1:
        r = (sa * sb) >> 32
    elif f3 == 2:
        r = (sa * b) >> 32
    elif f3 == 3:
        r = (a * b) >> 32
    elif f3 == 4:
        r = -1 if b == 0 else (sa if sa == -(1 << 31) and sb == -1 else _tdiv(sa, sb))
    elif f3 == 5:
        r = MASK32 if b == 0 else a // b
    elif f3 == 6:
        r = sa if b == 0 else (0 if sa == -(1 << 31) and sb == -1 else sa - sb * _tdiv(sa, sb))
    else:
        r = a if b == 0 else a % b
    return r & MASK32


def _tdiv(a, b):
    q = abs(a) // abs(b)
    return -q if (a < 0) != (b < 0) else q


# What the VRF core may repeat. Kind -> mask bits allowed (bit0 rd, bit1 rs1,
# bit2 rs2, bit3 rs3).
REPEAT_LOAD, REPEAT_STORE, REPEAT_R, REPEAT_I, REPEAT_R4 = range(5)
ALLOWED_BITS = {REPEAT_LOAD: 0b0001, REPEAT_STORE: 0b0100, REPEAT_R: 0b0111,
                REPEAT_I: 0b0011, REPEAT_R4: 0b1111}


def vrf_repeat_kind(p):
    op, f3, f7 = p & 0x7F, (p >> 12) & 7, p >> 25
    if op == 0x07 and f3 == 2:
        return REPEAT_LOAD
    if op == 0x27 and f3 == 2:
        return REPEAT_STORE
    if op == 0x2B:
        return {0: REPEAT_R, 1: REPEAT_R4, 4: REPEAT_LOAD, 5: REPEAT_STORE}.get(f3)
    if op == 0x7B:
        return REPEAT_I
    if op == 0x43 and (f7 & 3) == 0:
        return REPEAT_R4
    if op == 0x53 and f7 in (0x00, 0x04, 0x08):
        return REPEAT_R
    return None


def window(base, k, count):
    w = 4 if count <= 3 else 8 if count <= 7 else 16
    return (base & ~(w - 1)) | k, base & (w - 1)


class Sim:
    def __init__(self, image, memsize, core, lax, profile=False):
        # Per-pc counts from bench_mark(0) on: retired instructions, and extra
        # repeated steps (charged to the REPEAT's pc). None = no profiling.
        self.profile = profile
        self.prof_insns = {}
        self.prof_steps = {}
        self.prof_on = False
        self.mem = bytearray(memsize)
        self.mem[: len(image)] = image
        self.x = [0] * 32
        self.f = [0] * 32
        self.frm = 0
        self.pc = 0
        self.core = core
        self.lax = lax
        self.out = []
        self.marks = {}
        self.insns = 0
        self.steps = 0
        self.prev_pc = None
        self.repeats = 0
        self.repeated_steps = 0

    # -- memory
    def rd32(self, a):
        return int.from_bytes(self.mem[a : a + 4], "little")

    def load(self, a, size, signed):
        if a + size > len(self.mem):
            raise SimError(f"load from {a:#x} out of memory at pc {self.pc:#x}")
        v = int.from_bytes(self.mem[a : a + size], "little")
        return sx(v, size * 8) & MASK32 if signed else v

    def store(self, a, size, v):
        if a == CONSOLE:
            self.out.append(chr(v & 0xFF))
            return
        if a == MARK:
            self.marks[v] = (self.insns, self.steps, self.repeats)
            if v == 0:
                self.prof_on = self.profile
            return
        if a + size > len(self.mem):
            raise SimError(f"store to {a:#x} out of memory at pc {self.pc:#x}")
        self.mem[a : a + size] = (v & ((1 << (size * 8)) - 1)).to_bytes(size, "little")

    def setx(self, r, v):
        if r:
            self.x[r] = v & MASK32

    def rm(self, f3):
        rm = self.frm if f3 == 7 else f3
        if rm > 4:
            raise SimError(f"invalid rounding mode {rm} at pc {self.pc:#x}")
        return rm

    # -- one instruction with explicit register numbers. `off` is added to
    # load/store addresses (k * stride inside a REPEAT).
    def execute(self, i, rd, rs1, rs2, rs3, off=0):
        x, f = self.x, self.f
        op = i & 0x7F
        f3 = (i >> 12) & 7
        f7 = i >> 25
        immi = sx(i >> 20, 12)
        imms = sx(((i >> 25) << 5) | ((i >> 7) & 31), 12)
        if op == 0x07:  # flw
            if f3 != 2:
                raise SimError(f"unsupported FP load {i:#010x}")
            f[rd] = self.load((x[rs1] + immi + off) & MASK32, 4, False)
        elif op == 0x27:  # fsw
            if f3 != 2:
                raise SimError(f"unsupported FP store {i:#010x}")
            self.store((x[rs1] + imms + off) & MASK32, 4, f[rs2])
        elif op in (0x43, 0x47, 0x4B, 0x4F):
            if f7 & 3:
                raise SimError(f"non-single FMA {i:#010x}")
            np_, na = {0x43: (0, 0), 0x47: (0, 1), 0x4B: (1, 0), 0x4F: (1, 1)}[op]
            f[rd] = f_fma(f[rs1], f[rs2], f[rs3], self.rm(f3), np_, na)
        elif op == 0x53:
            self.op_fp(i, rd, rs1, rs2, f3, f7)
        elif op == 0x2B and self.core == "vrf":
            if f3 == 0:
                if f7 >> 4 or (f7 & 0xF) not in XR_ALU_OPS:
                    raise SimError(f"bad xr.alu op {i:#010x}")
                g3, alt = XR_ALU_OPS[f7 & 0xF]
                f[rd] = alu(g3, alt, f[rs1], f[rs2])
            elif f3 == 1:
                if f7 & 3:
                    raise SimError(f"bad xr.mac {i:#010x}")
                f[rd] = (f[rs1] * f[rs2] + f[rs3]) & MASK32
            elif f3 == 2:
                f[rd] = x[rs1]
            elif f3 == 3:
                self.setx(rd, f[rs1])
            elif f3 == 4:
                f[rd] = self.load((x[rs1] + immi + off) & MASK32, 4, False)
            elif f3 == 5:
                self.store((x[rs1] + imms + off) & MASK32, 4, f[rs2])
            else:
                raise SimError(f"bad custom-1 funct3 {i:#010x}")
        elif op == 0x7B and self.core == "vrf":
            sh = (i >> 20) & 31
            if f3 == 1:
                f[rd] = alu(1, 0, f[rs1], sh)
            elif f3 == 5:
                f[rd] = alu(5, (i >> 30) & 1, f[rs1], sh)
            else:
                f[rd] = alu(f3, 0, f[rs1], immi & MASK32)
        elif op == 0x0B and self.core == "int":
            if f3 or (f7 & 3):
                raise SimError(f"bad xr.mac {i:#010x}")
            self.setx(rd, x[rs1] * x[rs2] + x[rs3])
        elif op == 0x03:
            a = (x[rs1] + immi + off) & MASK32
            size, signed = {0: (1, 1), 1: (2, 1), 2: (4, 1), 4: (1, 0), 5: (2, 0)}[f3]
            self.setx(rd, self.load(a, size, signed))
        else:
            raise SimError(f"illegal instruction {i:#010x} at {self.pc:#x}")

    def op_fp(self, i, rd, rs1, rs2, f3, f7):
        x, f = self.x, self.f
        a, b = f[rs1], f[rs2]
        if f7 == 0x00:
            f[rd] = f_add(a, b, self.rm(f3))
        elif f7 == 0x04:
            f[rd] = f_add(a, b ^ SIGN, self.rm(f3))
        elif f7 == 0x08:
            f[rd] = f_mul(a, b, self.rm(f3))
        elif f7 == 0x0C:
            f[rd] = f_div(a, b, self.rm(f3))
        elif f7 == 0x2C and rs2 == 0:
            f[rd] = f_sqrt(a, self.rm(f3))
        elif f7 == 0x10:
            sb = {0: b & SIGN, 1: ~b & SIGN, 2: (a ^ b) & SIGN}[f3]
            f[rd] = (a & 0x7FFFFFFF) | sb
        elif f7 == 0x14:
            f[rd] = f_minmax(a, b, f3 == 1)
        elif f7 == 0x60:
            self.setx(rd, f_to_int(a, self.rm(f3), rs2 == 1))
        elif f7 == 0x68:
            v = x[rs1] if rs2 == 1 else sx(x[rs1], 32)
            f[rd] = f_round(Fraction(v), self.rm(f3))
        elif f7 == 0x70 and f3 == 0:
            self.setx(rd, a)
        elif f7 == 0x70 and f3 == 1:
            self.setx(rd, f_class(a))
        elif f7 == 0x78 and f3 == 0:
            f[rd] = x[rs1]
        elif f7 == 0x50:
            if f_isnan(a) or f_isnan(b):
                r = 0
            else:
                fa, fb = f_tofloat(a), f_tofloat(b)
                r = {0: fa <= fb, 1: fa < fb, 2: fa == fb}.get(f3)
                if r is None:
                    raise SimError(f"bad FP compare {i:#010x}")
            self.setx(rd, int(r))
        else:
            raise SimError(f"unsupported OP-FP {i:#010x} at {self.pc:#x}")

    def csr(self, i, rd, rs1, f3):
        num = i >> 20
        src = self.x[rs1] if f3 < 4 else rs1
        if num == 1:
            old = 0
        elif num == 2:
            old = self.frm
        elif num == 3:
            old = self.frm << 5
        elif num in (0xC00, 0xC02, 0xB00, 0xB02):
            old = self.insns & MASK32
        else:
            raise SimError(f"unsupported CSR {num:#x} at {self.pc:#x}")
        kind = f3 & 3
        new = src if kind == 1 else old | src if kind == 2 else old & ~src
        write = kind == 1 or rs1 != 0
        if write and num in (2, 3):
            self.frm = (new >> 5 if num == 3 else new) & 7
        self.setx(rd, old)

    # -- main loop
    def run(self, limit=500_000_000):
        x = self.x
        while limit:
            limit -= 1
            pc = self.pc
            i = self.rd32(pc)
            op = i & 0x7F
            rd = (i >> 7) & 31
            f3 = (i >> 12) & 7
            rs1 = (i >> 15) & 31
            rs2 = (i >> 20) & 31
            f7 = i >> 25
            immi = sx(i >> 20, 12)
            npc = pc + 4
            self.insns += 1
            self.steps += 1
            if self.prof_on:
                self.prof_insns[pc] = self.prof_insns.get(pc, 0) + 1
            if op == 0x37:
                self.setx(rd, i & 0xFFFFF000)
            elif op == 0x17:
                self.setx(rd, pc + (i & 0xFFFFF000))
            elif op == 0x6F:
                imm = sx(((i >> 31) << 20) | (((i >> 12) & 0xFF) << 12)
                         | (((i >> 20) & 1) << 11) | (((i >> 21) & 0x3FF) << 1), 21)
                self.setx(rd, npc)
                npc = (pc + imm) & MASK32
            elif op == 0x67:
                t = (x[rs1] + immi) & ~1 & MASK32
                self.setx(rd, npc)
                npc = t
            elif op == 0x63:
                imm = sx(((i >> 31) << 12) | (((i >> 7) & 1) << 11)
                         | (((i >> 25) & 0x3F) << 5) | (((i >> 8) & 0xF) << 1), 13)
                a, b = x[rs1], x[rs2]
                sa, sb = sx(a, 32), sx(b, 32)
                take = {0: a == b, 1: a != b, 4: sa < sb, 5: sa >= sb, 6: a < b, 7: a >= b}[f3]
                if take:
                    npc = (pc + imm) & MASK32
            elif op == 0x23:
                imm = sx(((i >> 25) << 5) | ((i >> 7) & 31), 12)
                self.store((x[rs1] + imm) & MASK32, {0: 1, 1: 2, 2: 4}[f3], x[rs2])
            elif op == 0x13:
                if f3 == 1:
                    r = alu(1, 0, x[rs1], rs2)
                elif f3 == 5:
                    r = alu(5, f7 >> 5, x[rs1], rs2)
                else:
                    r = alu(f3, 0, x[rs1], immi & MASK32)
                self.setx(rd, r)
            elif op == 0x33:
                if f7 == 1:
                    self.setx(rd, muldiv(f3, x[rs1], x[rs2]))
                else:
                    self.setx(rd, alu(f3, f7 >> 5, x[rs1], x[rs2]))
            elif op == 0x5B:
                self.repeat(pc, i)
            elif op == 0x73:
                if f3 == 0:
                    if x[17] == 93:
                        return sx(x[10], 32)
                    raise SimError(f"ecall a7={x[17]} at {pc:#x}")
                self.csr(i, rd, rs1, f3)
            elif op == 0x0F:
                pass
            else:
                self.execute(i, rd, rs1, rs2, i >> 27)
            self.prev_pc = pc
            self.pc = npc
        raise SimError("instruction limit reached")

    def repeat(self, pc, i):
        if not self.lax and self.prev_pc != pc - 4:
            raise SimError(f"REPEAT at {pc:#x} not reached from the instruction before it")
        p = self.rd32(pc - 4)
        rd, rs1, rs2, rs3 = (p >> 7) & 31, (p >> 15) & 31, (p >> 20) & 31, p >> 27
        self.repeats += 1
        if self.core == "int":
            self.repeat_int(pc, i, p, rd, rs1, rs2, rs3)
        else:
            self.repeat_vrf(pc, i, p, rd, rs1, rs2, rs3)

    def repeat_int(self, pc, i, p, rd, rs1, rs2, rs3):
        f3, f7 = (i >> 12) & 7, i >> 25
        if (i >> 7) & 31 or f3 or f7 & 7:
            raise SimError(f"bad REPEAT {i:#010x} at {pc:#x}")
        mask, stride, count = f7 >> 3, self.x[(i >> 15) & 31], self.x[(i >> 20) & 31]
        op = p & 0x7F
        if op == 0x03:
            if (p >> 12) & 7 != 2 or mask != 0b0001:
                raise SimError(f"REPEAT of non-lw load or mask {mask:#06b} at {pc:#x}")
        elif op != 0x0B:
            raise SimError(f"REPEAT of unsupported instruction {p:#010x} at {pc:#x}")
        for k in range(1, count + 1):
            self.steps += 1
            self.repeated_steps += 1
            if self.prof_on:
                self.prof_steps[pc] = self.prof_steps.get(pc, 0) + 1
            regs = [r + k if mask >> b & 1 else r for b, r in enumerate((rd, rs1, rs2, rs3))]
            if op == 0x03:
                regs[1] = rs1
            if max(regs) > 31:
                raise SimError(f"walk past x31 at {pc:#x}")
            self.execute(p, *regs, off=(k * stride) & MASK32 if op == 0x03 else 0)

    def repeat_vrf(self, pc, i, p, rd, rs1, rs2, rs3):
        if (i >> 7) & 31 or (i >> 12) & 7 or (i >> 25) & 7 or (i >> 24) & 1:
            raise SimError(f"bad REPEAT {i:#010x} at {pc:#x}")
        mask = i >> 28
        stride = self.x[(i >> 15) & 31]
        count = (i >> 20) & 15
        kind = vrf_repeat_kind(p)
        if kind is None:
            raise SimError(f"REPEAT of ineligible instruction {p:#010x} at {pc:#x}")
        if kind == REPEAT_LOAD:
            mask |= 1  # rd always walks
        if not self.lax and mask & ~ALLOWED_BITS[kind]:
            raise SimError(f"REPEAT mask {mask:#06b} names operands {p:#010x} doesn't "
                           f"walk, at {pc:#x}")
        fields = (rd, rs1, rs2, rs3)
        walking = [mask >> b & 1 and b_ok for b, b_ok in
                   enumerate(ALLOWED_BITS[kind] >> b & 1 for b in range(4))]
        if not self.lax:
            for b, w in enumerate(walking):
                if w and window(fields[b], 0, count)[1]:
                    raise SimError(f"walking register {fields[b]} is not aligned to the "
                                   f"{count + 1}-wide window, at {pc:#x}")
        mem = kind in (REPEAT_LOAD, REPEAT_STORE)
        for k in range(1, count + 1):
            self.steps += 1
            self.repeated_steps += 1
            if self.prof_on:
                self.prof_steps[pc] = self.prof_steps.get(pc, 0) + 1
            regs = [window(r, k, count)[0] if walking[b] else r for b, r in enumerate(fields)]
            self.execute(p, *regs, off=sx(k * sx(stride, 32), 32) if mem else 0)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--core", choices=("int", "vrf"), default="int")
    ap.add_argument("--lax", action="store_true", help="don't flag code the compiler must not emit")
    ap.add_argument("--mem", type=int, default=16, help="memory size in MiB")
    ap.add_argument("--profile", metavar="FILE",
                    help="write per-pc counts from bench_mark(0) on: pc insns extra_steps")
    ap.add_argument("binary")
    args = ap.parse_args()
    image = open(args.binary, "rb").read()
    s = Sim(image, args.mem << 20, args.core, args.lax, bool(args.profile))
    try:
        rc = s.run()
    except SimError as e:
        sys.stdout.write("".join(s.out))
        print(f"[sim] ERROR: {e}")
        sys.exit(2)
    sys.stdout.write("".join(s.out))
    if args.profile:
        with open(args.profile, "w") as f:
            for pc in sorted(set(s.prof_insns) | set(s.prof_steps)):
                f.write(f"{pc:#x} {s.prof_insns.get(pc, 0)} {s.prof_steps.get(pc, 0)}\n")
    if 0 in s.marks and len(s.marks) > 1:
        i0, s0, r0 = s.marks[0]
        for k in sorted({1, max(s.marks)} & set(s.marks)):
            i1, s1, r1 = s.marks[k]
            print(f"[sim] window mark 0..{k}: {i1 - i0} instructions, "
                  f"{s1 - s0} steps (incl. repeated), {(s1 - s0) - (r1 - r0)} ops "
                  f"(steps without the REPEAT instructions)")
    print(f"[sim] total: {s.insns} instructions, {s.steps} steps, {s.repeats} REPEATs")
    print(f"[sim] exit code {rc}")
    sys.exit(rc & 0xFF)


if __name__ == "__main__":
    main()
