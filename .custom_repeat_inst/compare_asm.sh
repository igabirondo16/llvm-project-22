#!/usr/bin/env bash
# Generate and compare the assembly of every benchmark in three versions:
#   base_rv32im   plain C (<name>_base.c), plain RV32IM - the scalar baseline
#   base_xrepeat  the same plain C with -march=rv32im_xrepeat - the compiler vectorizes it
#   hand          the hand-written repeat.h version (main.c), plain RV32IM + inline-asm MAC/REPEAT
#
# Usage: ./compare_asm.sh [extra clang flags...]      e.g. ./compare_asm.sh -DNC=256
# Output: asm_compare/<bench>/<version>.s     full assembly, numeric register names
#         asm_compare/<bench>/<version>.dis   objdump disassembly (xr.mac / xr.repeat for all three)
#         asm_compare/<bench>/loops.txt       every innermost loop of the three versions, with stats
#         asm_compare/summary.txt             one table of all innermost loops, all benchmarks
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
BIN="$HERE/../build-22/bin"
OUT="$HERE/asm_compare"
INC="$OUT/include"
BENCHES=(mlp axpy dotxvf gepdot resnet8 bert_tiny)

TARGET=(--target=riscv32-unknown-elf -mabi=ilp32 -O2 -ffreestanding -fno-asynchronous-unwind-tables)

# The sources include bench.h as "../common/bench.h" (base_mlp/main_mlp.c) or
# "../../benchmarks/common/bench.h" (the rest, and repeat.h). Quoted includes that are not found
# next to the source are retried from each -I directory, so two dummy directories at the right
# depth make both paths land on $INC/benchmarks/common/bench.h.
rm -rf "$INC"
mkdir -p "$INC/benchmarks/common" "$INC/benchmarks/src" "$INC/d1/d2" "$INC/sys"
ln -s "$HERE/base_mlp/bench.h" "$INC/benchmarks/common/bench.h"
echo 'int printf(const char *, ...);' > "$INC/sys/stdio.h"  # no RISC-V libc: a declaration is enough

src_of() {  # bench version -> source file
    local b=$1 v=$2
    if [[ $v == hand ]]; then echo "$HERE/benchmarks_repeat/$b/main.c"
    elif [[ $b == mlp ]]; then echo "$HERE/base_mlp/main_mlp.c"
    else echo "$HERE/benchmarks_repeat/$b/${b}_base.c"; fi
}

compile() {  # bench version march
    local b=$1 v=$2 march=$3 d="$OUT/$1"
    mkdir -p "$d"
    # clang stops at bitcode and llc emits the assembly, only because llc can print numeric
    # register names (-M numeric); the bitcode records -march, so the code is what clang -S emits.
    "$BIN/clang" "${TARGET[@]}" -march="$march" -isystem "$INC/sys" -I "$INC/benchmarks/src" \
        -I "$INC/d1/d2" -emit-llvm -c "$(src_of "$b" "$v")" -o "$d/$v.bc" "${EXTRA[@]}"
    "$BIN/llc" -M numeric "$d/$v.bc" -o "$d/$v.s"
    "$BIN/llc" -filetype=obj "$d/$v.bc" -o "$d/$v.o"
    "$BIN/llvm-objdump" -d --no-show-raw-insn -M numeric --mattr=+m,+xrepeat "$d/$v.o" > "$d/$v.dis"
    rm -f "$d/$v.bc" "$d/$v.o"
}

EXTRA=("$@")
set --
for b in "${BENCHES[@]}"; do
    compile "$b" base_rv32im  rv32im
    compile "$b" base_xrepeat rv32im_xrepeat
    compile "$b" hand         rv32im
done
python3 -I "$HERE/asm_loops.py" "$OUT" "${BENCHES[@]}"
echo "Wrote $OUT/<bench>/{base_rv32im,base_xrepeat,hand}.{s,dis}, loops.txt and $OUT/summary.txt"
