#!/usr/bin/env bash
# Run every benchmark on the emulator in the four versions of compare_asm.sh and print a table:
#   base_rv32im   plain C, rv32im                 (core int)
#   base_xrepeat  plain C, rv32im_xrepeatint      (core int: GPR blocks)
#   base_vrf      plain C, rv32im_xrepeat         (core vrf: vectors in f registers)
#   hand          main.c (repeat.h inline asm)    (core int)
# The checksum is checked against the golden value at default sizes. With extra flags (sizes,
# e.g. -DIMG_SIZE=8) there is no golden value, so every version is compared to base_rv32im.
# Insns/steps are counted in the kernel window, from the first to the last bench_mark (as
# bench.h defines it; mlp/axpy/dotxvf/gepdot mark 0..1, resnet8 0..5, bert_tiny 0..4).
# Steps = instructions + extra repeated steps; ops = steps - REPEAT instructions (the element
# operations, i.e. the work if a REPEAT trailer cost nothing). The "win" column names the window.
#
# usage: run_benchmarks.sh [bench...] [-- extra clang flags...]
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
R="$HERE/.."
BENCHES=()
while [[ $# -gt 0 && $1 != -- ]]; do BENCHES+=("$1"); shift; done
[[ ${1:-} == -- ]] && shift
[[ ${#BENCHES[@]} -eq 0 ]] && BENCHES=(mlp axpy dotxvf gepdot resnet8 bert_tiny)
export OUT="${OUT:-$HERE/out}"
mkdir -p "$OUT"
EXTRA=("$@")

src_of() {
    local b=$1 v=$2
    if [[ $v == hand ]]; then echo "$R/benchmarks_repeat/$b/main.c"
    elif [[ $b == mlp ]]; then echo "$R/base_mlp/main_mlp.c"
    else echo "$R/benchmarks_repeat/$b/${b}_base.c"; fi
}

status=0
printf '%-10s %-13s %-12s %-6s %10s %10s %10s %5s\n' bench version checksum result insns steps ops win
for b in "${BENCHES[@]}"; do
    ref=""
    for vm in "base_rv32im int rv32im" "base_xrepeat int rv32im_xrepeatint" \
              "base_vrf vrf rv32im_xrepeat" "hand int rv32im"; do
        set -- $vm; v=$1 core=$2 march=$3; shift 3
        log="$OUT/${b}_$v.log"
        "$HERE/build.sh" "$core" "${b}_$v" "$(src_of "$b" "$v")" "$march" "${EXTRA[@]}" \
            > "$log" 2>&1
        sum=$(sed -n 's/^BENCH .* checksum=\(0x[0-9a-f]*\).*/\1/p' "$log")
        win=$(sed -n 's/^\[sim\] window mark \(0\.\.[0-9]*\): \([0-9]*\) instructions, \([0-9]*\) steps (incl. repeated), \([0-9]*\) ops.*/\2 \3 \4 \1/p' "$log" | tail -1)
        if grep -q '^PASS' "$log"; then res=PASS
        elif grep -q '^SKIP' "$log"; then
            [[ -z $ref ]] && ref=$sum
            if [[ -n $sum && $sum == "$ref" ]]; then res=same; else res=DIFF; fi
        else res=FAIL; fi
        [[ $res == PASS || $res == same ]] || { status=1; grep -m1 'ERROR\|error' "$log"; }
        printf '%-10s %-13s %-12s %-6s %10s %10s %10s %5s\n' "$b" "$v" "${sum:--}" "$res" ${win:-- - - -}
    done
done
exit $status
