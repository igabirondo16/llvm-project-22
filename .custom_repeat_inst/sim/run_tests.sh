#!/usr/bin/env bash
# Differential test of the VRF code generation on the emulator: tests/kernels.c built for scalar
# rv32imf (reference) and for rv32im_xrepeat must print the same hashes, for several runtime
# sizes N. Kernels whose name ends in '~' may legally differ (see kernels.c) and are only listed.
# Prints the differing kernels, if any; exit status 1 on any difference.
#
# usage: run_tests.sh [N...]          (default: 1 7 8 9 16 37 64 100 128)
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
export OUT="${OUT:-$HERE/out}"
mkdir -p "$OUT"
SIZES=("$@"); [[ ${#SIZES[@]} -eq 0 ]] && SIZES=(1 7 8 9 16 37 64 100 128)
status=0
for n in "${SIZES[@]}"; do
    "$HERE/build.sh" vrf kref_$n "$HERE/tests/kernels.c" rv32imf -DN=$n > "$OUT/kref_$n.log" 2>&1
    "$HERE/build.sh" vrf kvrf_$n "$HERE/tests/kernels.c" rv32im_xrepeat -DN=$n > "$OUT/kvrf_$n.log" 2>&1
    reps=$(sed -n 's/.* \([0-9]*\) REPEATs/\1/p' "$OUT/kvrf_$n.log")
    if grep -q 'ERROR\|error' "$OUT/kref_$n.log" "$OUT/kvrf_$n.log" ||
       ! grep -q '^\[sim\] exit code 0' "$OUT/kref_$n.log" ||
       ! grep -q '^\[sim\] exit code 0' "$OUT/kvrf_$n.log"; then
        echo "N=$n: build or emulator error"; grep -h 'ERROR\|error\|exit code' "$OUT"/k{ref,vrf}_$n.log
        status=1; continue
    fi
    d=$(paste -d' ' <(grep -v '^\[sim\]' "$OUT/kref_$n.log") <(grep -v '^\[sim\]' "$OUT/kvrf_$n.log") \
        | awk '$2 != $4 && $1 !~ /~$/ { printf " %s", $1 }')
    allowed=$(paste -d' ' <(grep -v '^\[sim\]' "$OUT/kref_$n.log") <(grep -v '^\[sim\]' "$OUT/kvrf_$n.log") \
        | awk '$2 != $4 && $1 ~ /~$/ { printf " %s", $1 }')
    [[ -n $allowed ]] && allowed=" (allowed to differ:$allowed)"
    if [[ -n $d ]]; then
        echo "N=$n: DIFFERENT ($reps REPEATs):$d"; status=1
    else
        echo "N=$n: same ($(grep -vc '^\[sim\]' "$OUT/kvrf_$n.log") kernels, $reps REPEATs)$allowed"
    fi
done
exit $status
