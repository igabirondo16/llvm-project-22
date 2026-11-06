"""Extract the innermost loops from llc assembly and summarize their instruction mix.

Usage: python3 asm_loops.py <asm_compare dir> <bench>...   (called by compare_asm.sh)

llc marks every loop header with a comment ("=>This Inner Loop Header: Depth=N" for innermost
loops). An innermost loop's body runs from its header label to the last branch back to that
label. The hand-written versions' MAC/REPEAT are `.insn` directives in the .s file; they are
renamed xr.mac / xr.repeat here so all versions read the same. Loads and stores count lw/flw
and sw/fsw (base_vrf keeps its vectors in F registers); "xr.op" counts the VRF core's other
vector instructions (xr.add, xr.addi, ..., fadd.s/fsub.s/fmul.s/fmadd.s followed by a REPEAT).
"""
import re
import sys
from pathlib import Path

VERSIONS = ["base_rv32im", "base_xrepeat", "base_vrf", "hand"]
BRANCHES = ("beq", "bne", "blt", "bge", "bltu", "bgeu", "beqz", "bnez", "blez", "bgez",
            "bltz", "bgtz", "bgt", "ble", "bgtu", "bleu", "j")


def normalize(ins):
    if ins.startswith(".insn r4 11,") or ins.startswith(".insn r4 0xb,"):
        return "xr.mac\t" + ins.split(",", 3)[3].strip()
    if ins.startswith(".insn r 91,") or ins.startswith(".insn r 0x5b,"):
        f = [x.strip() for x in ins[len(".insn r "):].split(",")]
        return f"xr.repeat\t{int(f[2], 0) >> 3}, {f[4]}, {f[5]}"
    return ins


def parse(path):
    """-> list of (function, [line]) where each line is ('label', name, comment) or ('ins', text)."""
    funcs, cur, name = [], None, None
    for raw in Path(path).read_text().splitlines():
        m = re.match(r"^([A-Za-z_.$][\w.$]*):(.*)$", raw)
        if m and not raw.startswith("\t"):
            lab = m.group(1)
            if not lab.startswith(".L") or lab.startswith(".Lfunc_end"):
                if lab.startswith(".Lfunc_end"):
                    cur = None
                    continue
                name, cur = lab, []
                funcs.append((name, cur))
                continue
            if cur is not None:
                cur.append(["label", lab, ""])
            continue
        if cur is None:
            continue
        s = raw.strip()
        if s.startswith("#"):
            if cur and cur[-1][0] == "label":
                cur[-1][2] += s + " "
            continue
        if not s or (s.startswith(".") and not s.startswith(".insn")):
            continue
        s = re.sub(r"\s+#.*$", "", s)
        cur.append(["ins", normalize(s)])
    return funcs


def inner_loops(funcs):
    loops = []
    for fname, lines in funcs:
        for i, ln in enumerate(lines):
            if ln[0] != "label" or "Inner Loop Header" not in ln[2]:
                continue
            lab = ln[1]
            end = None
            for j in range(i + 1, len(lines)):
                if lines[j][0] == "ins":
                    op, *rest = lines[j][1].split(None, 1)
                    if op in BRANCHES and rest and rest[0].split(",")[-1].strip() == lab:
                        end = j
            if end is None:
                continue
            body = [l[1] for l in lines[i:end + 1] if l[0] == "ins"]
            loops.append((fname, lab, body))
    return loops


def stats(body):
    ops = [b.split()[0] for b in body]
    c = lambda *names: sum(o in names for o in ops)
    # An instruction followed by a REPEAT, other than MAC and loads/stores.
    xop = sum(1 for o, n in zip(ops, ops[1:] + [""]) if n == "xr.repeat" and
              o not in ("xr.mac", "lw", "flw", "sw", "fsw"))
    return {"insns": len(ops), "mac": c("xr.mac"), "rep": c("xr.repeat"), "xop": xop,
            "lw": c("lw", "flw"), "sw": c("sw", "fsw"), "mul": c("mul"),
            "add": c("add", "addi", "sub")}


def main():
    out = Path(sys.argv[1])
    summary = []
    hdr = f"{'bench':<10} {'version':<13} {'function':<26} {'loop':<10} {'insns':>5} {'xr.mac':>6} {'xr.op':>5} {'xr.rep':>6} {'lw':>4} {'sw':>4} {'mul':>4}"
    summary += [hdr, "-" * len(hdr)]
    for bench in sys.argv[2:]:
        txt = []
        for v in VERSIONS:
            loops = inner_loops(parse(out / bench / f"{v}.s"))
            txt.append(f"{'=' * 30} {bench} / {v}: {len(loops)} innermost loops {'=' * 30}\n")
            for fname, lab, body in loops:
                s = stats(body)
                summary.append(f"{bench:<10} {v:<13} {fname[:26]:<26} {lab:<10} {s['insns']:>5} {s['mac']:>6} {s['xop']:>5} {s['rep']:>6} {s['lw']:>4} {s['sw']:>4} {s['mul']:>4}")
                txt.append(f"--- {fname} {lab}: {s['insns']} insns, {s['mac']} xr.mac, {s['xop']} other repeated, {s['rep']} xr.repeat, "
                           f"{s['lw']} lw, {s['sw']} sw, {s['mul']} mul\n")
                txt += [f"\t{b}\n" for b in body]
                txt.append("\n")
        (out / bench / "loops.txt").write_text("".join(txt))
        summary.append("")
    (out / "summary.txt").write_text("\n".join(summary) + "\n")
    print("\n".join(summary))


if __name__ == "__main__":
    main()
