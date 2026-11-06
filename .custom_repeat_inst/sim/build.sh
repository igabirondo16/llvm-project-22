#!/usr/bin/env bash
# Build a bare-metal program for the emulator and run it.
#
# usage: build.sh <core> <name> <src.c> <march> [extra clang flags...]
#   core   int (the GPR core: rv32im, rv32im_xrepeatint, hand-written repeat.h code)
#          vrf (the VRF core: rv32im_xrepeat, or anything with F)
# Output in $OUT (default: sim/out): <name>.{elf,bin,dis}; prints the program's output and the
# emulator's counters. Extra environment: CC_FLAGS_RT for the runtime.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
BIN="${BIN:-$HERE/../../build-22/bin}"
OUT="${OUT:-$HERE/out}"
core=$1 name=$2 src=$3 march=$4; shift 4
mkdir -p "$OUT"
T=(--target=riscv32-unknown-elf -mabi=ilp32 -ffreestanding -fno-builtin -nostdlib -mno-relax)
# The benchmarks include bench.h as "../common/bench.h" or "../../benchmarks/common/bench.h"
# (see compare_asm.sh): the same two dummy directories make both land on base_mlp/bench.h.
INC="$OUT/include"
if [[ ! -e $INC/benchmarks/common/bench.h ]]; then
    mkdir -p "$INC/benchmarks/common" "$INC/benchmarks/src" "$INC/d1/d2"
    ln -sf "$HERE/../base_mlp/bench.h" "$INC/benchmarks/common/bench.h"
fi
"$BIN/clang" "${T[@]}" -march=rv32im -O2 -c "$HERE/rt.c" -o "$OUT/rt.o"
"$BIN/clang" "${T[@]}" -march="$march" -O2 -isystem "$HERE/sys" -I "$INC/benchmarks/src" \
    -I "$INC/d1/d2" "$@" -c "$src" -o "$OUT/$name.o"
ld.lld -T "$HERE/link.ld" --no-relax "$OUT/rt.o" "$OUT/$name.o" -o "$OUT/$name.elf"
"$BIN/llvm-objcopy" -O binary "$OUT/$name.elf" "$OUT/$name.bin"
ext=xrepeatint; [[ $core == vrf ]] && ext=xrepeat
"$BIN/llvm-objdump" -d --no-show-raw-insn -M numeric --mattr=+m,+f,+$ext "$OUT/$name.elf" \
    > "$OUT/$name.dis" 2>/dev/null || true
python3 -I "$HERE/rvsim.py" --core "$core" "$OUT/$name.bin"
