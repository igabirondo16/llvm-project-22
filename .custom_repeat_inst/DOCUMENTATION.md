# XRepeat in LLVM 22: what was changed, and why

This document lists every change made to LLVM on branch `clang-22-custom-repeat` to support the
`repeat_rv` core (MAC + REPEAT), phase by phase, with the reason for each one. The ISA itself and
the original plan are in [`PLAN.md`](PLAN.md); this file describes what was actually built.
For a visual overview (pipeline diagram, register blocks, worked example), open
[`xrepeat_llvm.html`](xrepeat_llvm.html) in a browser.

| Phase | Commit | Status |
|---|---|---|
| 0 — Extension name | `f7a259c59ba1` | committed |
| 1 — Assembler / disassembler | `602255941302` | committed |
| 2 — `<8 x i32>` register class | `9f7dbe41dc50` | committed |
| 3 — Instruction selection to MAC/LW + REPEAT | `af46cffc55d6` | committed |
| 4 — Auto-vectorizer | `e536166bac86` | committed |
| 5 — `<4 x i32>` blocks; the compiler picks 4 or 8 | `d5087d6b74df` | committed |
| 6 — Strided loads (`lw` + REPEAT with any stride) | `7775c26197b3` | committed (one commit with Phase 7) |
| 7 — gepdot: splat cost, keep small loops rolled for the vectorizer | `7775c26197b3` | committed (one commit with Phase 6) |
| 8 — `xrepeatint`: frozen copy of XRepeat; `xrepeat` keeps evolving | — | not committed yet |

All code is under `llvm/lib/Target/RISCV/` unless another path is given. Every code-generation
change is guarded by `hasXRepeatVectors()` (XRepeat or XRepeatInt, and no V extension; before
Phase 8 it was spelled `hasVendorXRepeat() && !hasVInstructions()`): if the V extension is also
enabled, fixed vectors keep going to RVV as before, and nothing changes for any other target.

---

## Background: the three ideas the whole design rests on

1. **A "vector register" is 8 (or 4) consecutive GPRs.** An 8-element walk must start at x8, x16
   or x24, so the compiler sees three registers of type `v8i32`:
   `X8_X15` (s0, s1, a0–a5), `X16_X23` (a6, a7, s2–s7) and `X24_X31` (s8–s11, t3–t6). Since
   Phase 5, a 4-element walk may start at any multiple of 4 from x8, giving six `v4i32` registers
   `X8_X11`, `X12_X15`, …, `X28_X31` that overlap the 8-element ones. Because they
   are built *out of* the normal GPRs, the register allocator automatically knows that using
   `X16_X23` clobbers a6, a7, s2–s7. That is what makes it safe, unlike the inline-asm version in
   `repeat.h`, which pins x16–x31 behind the compiler's back.
2. **An instruction and its REPEAT must stay adjacent.** REPEAT re-executes *the instruction just
   before it*, so nothing may ever be scheduled between them. The pair is therefore kept as a
   single pseudo-instruction through instruction selection, register allocation and both
   scheduling passes, and only split into two real instructions in `RISCVExpandPseudoInsts.cpp`,
   which runs in `addPreEmitPass2`, after the last scheduler.
3. **REPEAT only works for `lw` and MAC.** Everything is expressed through those two:
   loads are `lw` + REPEAT; add/sub/mul/shift-by-constant/splat/multiply-add/dot product are all
   MAC + REPEAT with the right constant operands and mask; stores are 8 plain `sw`. Anything else
   on a vector is split into 8 scalar operations.

---

## Phase 0 — Extension name

Goal: make `-march=rv32im_xrepeat` / `-mattr=+xrepeat` exist.

| File | Change | Why |
|---|---|---|
| `RISCVFeatures.td` | `FeatureVendorXRepeat` (version 1.0) and predicate `HasVendorXRepeat` | Declares the extension. TableGen generates `Subtarget.hasVendorXRepeat()`, the assembler predicate, and the `-march` string name `xrepeat`. Vendor extensions must start with `x`. |
| `llvm/lib/TargetParser/RISCVISAInfo.cpp` | Error if `xrepeat` is used with RV64 | The vector blocks are 8 × 32-bit GPRs and all patterns assume `i32`; RV64 is not supported by the core. |
| `clang/test/Driver/print-supported-extensions-riscv.c`, `llvm/unittests/TargetParser/RISCVISAInfoTest.cpp`, `llvm/test/CodeGen/RISCV/features-info.ll` | Add the new line for `xrepeat` | These tests print the full list of extensions, so any new extension must be added to them or they fail. |

## Phase 1 — Assembler and disassembler (MC layer)

Goal: `llvm-mc` encodes `xr.mac` / `xr.repeat`, and `llvm-objdump` prints them instead of
`<unknown>`.

**New file `RISCVInstrInfoXRepeat.td`** (included at the end of `RISCVInstrInfo.td`):

- `XR_MAC` — `RVInstR4<funct2=0, funct3=0, OPC_CUSTOM_0>`, syntax `xr.mac rd, rs1, rs2, rs3`.
  R4-type is the same layout as the floating-point fused multiply-add (`fmadd`), so the existing
  base class could be reused.
- `XR_REPEAT` — a new format class `XRInstRepeat` built on `RVInstRBase` with `OPC_CUSTOM_2`. The
  4-bit `mask` operand goes in bits 31–28 (funct7[6:3]), bits 27–25 are 0, `rd` = 0, funct3 = 0.
  Syntax `xr.repeat mask, rs1(stride), rs2(count)`.
- `XR_REPEAT` is marked `hasSideEffects = 1, mayLoad = 1, mayStore = 1`. **Why:** at the MC level
  LLVM doesn't know which instruction is being repeated, so the conservative flags stop any pass
  from treating it as a no-op or moving memory operations across it.
- Both are under `Predicates = [HasVendorXRepeat, IsRV32]` and their own
  `DecoderNamespace = "XRepeat"`.

**`Disassembler/RISCVDisassembler.cpp`**: one line adding `DecoderTableXRepeat32` to
`DecoderList32`, enabled by `FeatureVendorXRepeat`. **Why:** custom-0/custom-2 opcodes are shared
by many vendors, so each vendor has its own decoder table that is only tried when its extension
is enabled.

**Tests**: `llvm/test/MC/RISCV/xrepeat-valid.s` (encodings, e.g. `xr.mac t2, s8, a6, t2` =
`0x390c038b`, the same as the old `.insn`, plus `llvm-objdump` round trip) and
`xrepeat-invalid.s` (mask out of range [0, 15], too few operands, immediate instead of a
register, and the RV64 error).

The mnemonics are prefixed `xr.` because LLVM vendor instructions are named that way (`cv.mac`,
`th.…`, `qc.…`) so they can never clash with a future standard instruction.

## Phase 2 — `<8 x i32>` lives in a register class of GPR blocks

Goal: make `v8i32` a legal type held in the three blocks, so it can be loaded, stored, copied
and spilled. At this phase every arithmetic operation was still split into scalars; the point was
to get the register model right first.

### Registers — `RISCVRegisterInfo.td`

- Sub-register indices `sub_xr0` … `sub_xr7` (element *i* is bits 32·i … 32·i+31).
- Three tuple registers `X8_X15`, `X16_X23`, `X24_X31`, each made of 8 GPRs, with
  `CoveredBySubRegs = 1`. **Why:** this is what tells the allocator and liveness analysis that
  the block *is* those 8 GPRs (writing the block writes all 8, and a6 is busy while `X16_X23` is
  live). That covers rules 2 and 3 of `PLAN.md` ("an instruction + REPEAT reads/writes all 8
  registers" and "a block must not be touched by other code").
- Register class `XRVec` of type `v8i32`.
  - Allocation order `X24_X31, X16_X23, X8_X15`. **Why:** x8 is the frame pointer and x10–x15
    are the argument registers a0–a5, so that block is the most expensive to take and goes last.
  - `CopyCost = 8` (a copy is 8 moves).
  - `GeneratePressureSet = 0`. **Why:** without it TableGen creates new register-pressure sets,
    which changed instruction scheduling (and broke unrelated tests) *even when xrepeat was
    disabled*. The pressure is already tracked by the GPR sets, since the blocks are GPRs.

### Type legality and lowering — `RISCVISelLowering.cpp`

- `addRegisterClass(MVT::v8i32, &RISCV::XRVecRegClass)`: `v8i32` becomes a legal type.
- Every `v8i32` operation except `LOAD`, `STORE`, `UNDEF`, `FREEZE` is set to `Expand`. **Why:**
  making the type legal tells LLVM it can do *everything* on it; `Expand` makes the legalizer
  split unsupported operations into 8 scalar ones instead of trying to select an instruction that
  doesn't exist.
- Extending loads into, and truncating stores from, `v8i32` are `Expand`. **Why:** same reason,
  for `sext <8 x i16>` etc.
- `isShuffleMaskLegal` returns `false`. **Why:** the default RISC-V answer assumes RVV can do
  shuffles; returning false makes them expand.
- `PerformDAGCombine` returns early for nodes producing `v8i32`. **Why:** the RISC-V-specific
  combines assume either scalar or RVV types and crashed or produced RVV nodes on `v8i32`.

### Copies and spills — `RISCVInstrInfo.cpp`, `RISCVRegisterInfo.cpp`

- `copyPhysReg`: a block-to-block copy is 8 `addi dst_i, src_i, 0` (i.e. `mv`).
- `storeRegToStackSlot` / `loadRegFromStackSlot` use the new pseudos `PseudoXRStore8` /
  `PseudoXRLoad8`. **Why:** the allocator must be able to spill a block when it runs out of
  blocks.
- `eliminateFrameIndex`: those pseudos become 8 accesses at offset +0 … +28, so the stack offset
  is only folded into the instruction if *offset + 28* still fits in 12 bits.

### Pseudos — `RISCVInstrInfoXRepeat.td`, `RISCVExpandPseudoInsts.cpp`

- `PseudoXRLoad8` / `PseudoXRStore8`: a whole block as 8 `lw` / `sw`, expanded by
  `expandXRLoadStore8`, which also splits the memory operand so alias analysis stays correct.
  `$vd` of the load is `@earlyclobber`. **Why:** if the base address register were inside the
  destination block, the first `lw` would overwrite it before the other 7 loads use it.
- In this phase, these pseudos were also used for ordinary `v8i32` loads and stores (Phase 3
  switched loads to `lw` + REPEAT).

### Cost model — `RISCVTargetTransformInfo.{h,cpp}`

- New helper `isXRepeatVector(Ty)`, and the `getShuffleCost`, `getScalarizationOverhead`,
  `getCastInstrCost` and `getVectorInstrCost` hooks fall back to the generic (`BaseT`)
  implementation for these types. **Why:** the RISC-V cost functions assume any legal fixed
  vector is an RVV vector, and call RVV helpers (`getMinRVVVectorSizeInBits`, …) that assert or
  return nonsense without V.

### Tests

- `llvm/test/CodeGen/RISCV/xrepeat-v8i32.ll`: loads, stores, copies, spills under pressure.
- `llvm/test/CodeGen/RISCV/xrepeat-v8i32-scalarized.ll`: operations without a XRepeat
  instruction (sext, trunc, select, shuffles) must compile to scalar code, at `-O2` and `-O0`.
- `llvm/test/Analysis/CostModel/RISCV/xrepeat.ll`: the cost model doesn't crash or use RVV costs.

## Phase 3 — Select loads and arithmetic to `lw`/MAC + REPEAT

Goal: generate the instruction pairs from the table in `PLAN.md`. Tested with clang vector types
(`typedef int v8 __attribute__((vector_size(32)))`) and `.ll` files, without the vectorizer.

### New pseudos — `RISCVInstrInfoXRepeat.td`

- **`PseudoXRVLoad vd, base, imm, stride, count`** → `lw vd[0], imm(base)` + `xr.repeat 1,
  stride, count`. `$vd` is `@earlyclobber`. **Why:** base, stride and count are read again on
  every repeated step, so none of them may live inside the destination block.
- **`PseudoXRMAC_{S,V}{S,V}{S,V} vd, rs1, rs2, rs3, count`** — 8 variants, one per combination of
  "operand is a vector block (V)" or "a scalar GPR (S)". The REPEAT mask is computed from that at
  expansion: a V field walks, an S field stays fixed. **Why:** MAC can read a scalar directly, so
  `a * splat(s)` doesn't need to materialize the splat in a block (mask 0101 instead of 0111).
- `vd` is *tied* to a vector input (preferring rs3, then rs2, then rs1); with no vector input it
  is `@earlyclobber`. **Why:** it must never share a register with the scalar operands or the
  count, which are read on every step. Tying it to a vector input is safe because each step reads
  element *i* and writes element *i*.
- Stores still use `PseudoXRStore8` (8 × `sw`), because REPEAT can't repeat stores. Spills also
  keep using `PseudoXRLoad8`. **Why:** at spill time there are no free registers to hold the
  stride and count.
- The stride and count are ordinary `li 4` / `li 7` instructions (`ADDI X0, imm`) feeding the
  pseudo. **Why:** as normal instructions, MachineLICM hoists them out of loops and they are
  shared between pairs.

### Patterns

New target node `XR_SPLAT` (`riscv_xr_splat`): a `v8i32` whose elements are all the same scalar.
With it, the patterns (generated with `foreach` over all S/V combinations) are:

| IR | Pseudo | MAC operands |
|---|---|---|
| `load <8 x i32>` | `PseudoXRVLoad` | stride 4, count 7 |
| `a * b + c` | `PseudoXRMAC_<abc>` | `a, b, c` |
| `a * b` | `PseudoXRMAC_<ab>S` | `a, b, x0` |
| `c + b` | `PseudoXRMAC_S<bc>` | `1, b, c` |
| `c - b` | `PseudoXRMAC_S<bc>` | `-1, b, c` |
| `splat(s)` alone | `PseudoXRMAC_SSS` | `s, 1, x0` (mask rd only) |

### Custom lowering — `RISCVISelLowering.cpp`

- `ADD`, `SUB`, `MUL` are no longer `Expand` (they are selected by the patterns above).
- `BUILD_VECTOR` and `SHL` are `Custom`, handled by the new `lowerXRepeatOperation`:
  - a splat `BUILD_VECTOR` becomes `XR_SPLAT` (other `BUILD_VECTOR`s were still expanded; see
    the Phase 4 bug fix);
  - `a << k` with a constant `k` becomes `a * splat(1 << k)`. **Why:** there is no vector shift;
    a multiply by a power of two is the same thing and is a single MAC.

### Expansion — `RISCVExpandPseudoInsts.cpp`

- `expandXRVLoad` and `expandXRMAC` emit the real instruction on the first sub-register
  (`sub_xr0`) of each block and the `XR_REPEAT` right after it.
- The REPEAT carries the **whole destination block as an implicit def** and the source
  blocks/base as **implicit uses**. **Why:** after expansion the `lw`/`mac` only mention the first
  register of each block; without these implicit operands, later passes (e.g. the machine
  verifier, or anything computing liveness) would think registers 2–8 of the block are not
  written or not read.
- MAC repeats use `x0` as the stride register, as in `repeat.h`.

### Tests

- `llvm/test/CodeGen/RISCV/xrepeat-v8i32-arith.ll` (new, autogenerated): load with offset, mul,
  add, sub, multiply-add, multiply by scalar, by constant, shift, add constant, negation, splat
  store, in-place add, and xor (scalarized).
- `xrepeat-v8i32.ll` regenerated: loads are now `lw` + REPEAT.

## Phase 4 — Enable the auto-vectorizer

Goal: plain C (`main_mlp.c`) at `-O2 -march=rv32im_xrepeat` is vectorized by LoopVectorize with
VF = 8 and produces the same code as the hand-written `mlp_repeat.c`.

The loop vectorizer decides *whether* and *how wide* to vectorize purely from the
`TargetTransformInfo` (TTI) hooks, so most of this phase is in `RISCVTargetTransformInfo.{h,cpp}`.
It also produces IR shapes that Phase 3 couldn't compile yet (reductions, element
extract/insert), which required new lowering and patterns.

### Telling the vectorizer that the vectors exist — TTI

| Hook | Value with XRepeat | Why |
|---|---|---|
| `getRegisterBitWidth(RGK_FixedWidthVector)` | 256 | One block = 8 × 32 bits. With 0 (the default without V) the vectorizer never even tries. This gives VF = 8 for `i32`. |
| `getNumberOfRegisters(vector class)` | 3 | Only three blocks; used by the vectorizer's register-pressure estimate. |
| `getMaxInterleaveFactor` | 1 | Interleaving (processing 2 × 8 elements per iteration) would need twice as many live blocks. |
| `preferInLoopReduction(Add, i32)` | true | See "dot product" below; this is the key to matching `mlp_repeat.c`. |
| `getUnrollingPreferences` | no unrolling of loops already vectorized (`llvm.loop.isvectorized` + vector instructions) | After vectorizing, the loop unroller would unroll the vector body; then the scheduler moves the loads of several iterations ahead of their MACs and the blocks spill. |
| new helper `hasXRepeatVectors()` | — | Same check as `isXRepeatVector` without the type; used by the hooks above. |

### Costs — TTI

New helper `getXRepeatPairCost(Ty)`: an operation that is *one instruction + one REPEAT per
block* costs **2 per block**. It returns a value only for vectors whose length is a multiple of 8
(more on that below).

| Operation | Cost |
|---|---|
| `add`, `sub`, `mul`, `shl` by a uniform constant | pair (2) |
| load | pair (2) |
| store | 4 × pair (8): 8 plain `sw` |
| splat (`SK_Broadcast` shuffle) | pair (2): a MAC by 1 |
| `reduce.add` (`getArithmeticReductionCost`) | pair (2) |
| `reduce.add(mul(a, b))` (new override `getMulAccReductionCost`) | pair (2): a single MAC |
| anything else on an XRepeat vector | **invalid** |

New helper `isUnsupportedXRepeatOp(Ty, CostKind)`, used in `getMemIntrinsicInstrCost`,
`getInterleavedMemoryOpCost`, `getIntrinsicInstrCost` (except `vector_reduce_add`),
`getMinMaxReductionCost`, `getExtendedReductionCost`, `getCmpSelInstrCost`,
`getArithmeticInstrCost`, `getMemoryOpCost`, `getShuffleCost` and `getCastInstrCost`.

**Why "invalid" rather than a high number:** the generic cost of a scalarized vector op is
"8 scalar ops + extract/insert overhead", which for a GPR-backed vector is cheap (the elements
already *are* GPRs), so the vectorizer happily vectorized loops full of xor/compare/select that
then compiled into 8 scalar operations *plus* 24 registers tied up in blocks. An invalid cost
makes the vectorizer reject any VF where such an operation appears (that's the
`Recipe with invalid costs prevented vectorization ... urem` remark you see for `init_data`).
**Only the `TCK_RecipThroughput` cost kind** (the one the vectorizers use) is made invalid; the
others (code size, latency) keep the generic estimate, so that existing vector code (e.g. written
with clang vector types) is still costed sensibly by the inliner and other passes.

### Dot product: in-loop reduction into a scalar

`acc += a[i] * b[i]` is the core of the MLP. By default LoopVectorize keeps a *vector*
accumulator (`vacc += a * b` elementwise) and only reduces it to a scalar after the loop. On this
core that would cost a third live block for `vacc` inside the loop and an extra MAC per iteration.

With `preferInLoopReduction` the vectorizer instead emits, every iteration,
`acc = acc + reduce.add(a * b)`, which is exactly one
`xr.mac acc, a[0], b[0], acc` + `xr.repeat 0110` (rs1 and rs2 walk; rd = rs3 = the scalar
accumulator stays fixed). That is the same as `mac_xv2_xv1_acc_8` in `repeat.h`.

Code needed for that:

- **`RISCVInstrInfoXRepeat.td`**
  - New node `XR_DOT acc, a, b` (`riscv_xr_dot`) = `acc + Σ a[i]·b[i]`.
  - New pseudos `PseudoXRDot_{S,V}{S,V} vd, rs1, rs2, rs3, count` with GPR result and
    `$vd = $rs3` tied (the scalar accumulator).
  - Patterns: `add(XR_DOT(0, a, b), acc)` and `XR_DOT(acc, a, b)` → `PseudoXRDot_*`, with `acc`
    as rs3. **Why the two forms:** lowering creates `XR_DOT(0, …)` and the `+ acc` that follows
    in the IR is folded into the same MAC.
- **`RISCVISelLowering.cpp`**: `VECREDUCE_ADD` on `v8i32` is `Custom`.
  - `reduce.add(mul(a, b))` (when the `mul` has no other use) → `XR_DOT(0, a, b)`.
  - `reduce.add(a)` → `XR_DOT(0, a, splat(1))` (mask 0010: only rs1 walks).
  - `LowerOperation` now also routes nodes whose *operand* is `v8i32` (`VECREDUCE_ADD`,
    `EXTRACT_VECTOR_ELT`) to `lowerXRepeatOperation`; before, only nodes whose *result* was
    `v8i32` were routed.
- **`RISCVExpandPseudoInsts.cpp`**: `PseudoXRDot_*` reuse `expandXRMAC`. That function was
  generalized: the mask bit for rd is now only set when rd is a block (for a dot product rd is a
  scalar and must not walk), and the MAC's rd is the register itself instead of its `sub_xr0`.

### Element extract / insert

The vectorizer (and SLP) produce `extractelement`/`insertelement` at constant indices, e.g. to
read the last element in the middle block.

- `EXTRACT_VECTOR_ELT` and `INSERT_VECTOR_ELT` on `v8i32` are `Custom`; with a constant index
  `lowerXRepeatOperation` keeps them as they are (so they reach instruction selection); with a
  variable index it returns nothing and they are expanded through the stack.
- Patterns: `extractelt(v, I)` → `EXTRACT_SUBREG v, sub_xrI`, and `insert(v, x, I)` →
  `INSERT_SUBREG v, x, sub_xrI`. **Why:** element *I* of a block simply *is* GPR number
  base + I, so these become plain register copies (usually removed by the allocator).
  (`vector_insert` is used instead of `insertelt` in the pattern because `insertelt`'s element
  type check can't be matched against `GPR`'s per-HwMode type.)

### Bug fix 1 — the compiler hung on non-splat `BUILD_VECTOR`

**Symptom:** `main_mlp.c` with `-DINPUT_SIZE=67 -DHIDDEN_SIZE=21` never finished compiling (in
instruction selection). Reduced to a single two-source `shufflevector <8 x i32>`.

**Cause:** a `BUILD_VECTOR` that is not a splat (e.g. the scalarized shuffle) had no XRepeat
lowering, so the default expansion wrote the 8 elements to a stack slot with 8 scalar stores and
loaded them back as one `<8 x i32>`. The DAG combiner then noticed 8 consecutive scalar stores and
merged them back into one `<8 x i32>` store *of a `BUILD_VECTOR`*… which was expanded again, and
so on forever.

**Fix (`lowerXRepeatOperation`, `BUILD_VECTOR` case):** a non-splat `BUILD_VECTOR` is now a chain
of `INSERT_VECTOR_ELT` at constant indices starting from `undef`, i.e. each element is moved
straight into its register of the block. No stack is involved, so there's nothing to re-merge.
Side benefit: scalarized operations (e.g. the `xor` test) no longer round-trip through the stack.

### Bug fix 2 — vectors shorter than 8 were costed as if they were full blocks

**Symptom:** with `HIDDEN_SIZE=21` the 21-iteration loop is fully unrolled *before*
LoopVectorize runs, and then the SLP vectorizer (which packs straight-line code) turned it into
`<16 x i32>` + `<4 x i32>` operations with shuffles, rated as a big win (cost −47), which then
spilled blocks heavily.

**Cause:** a `<4 x i32>` is legalized by widening to `<8 x i32>`, so `getTypeLegalizationCost`
returned the same cost as a real block, although it takes a whole block (8 GPRs) to do half the
work.

**Fix (`getXRepeatPairCost`):** return a cost only when the element count is a multiple of 8;
otherwise the caller falls through to `isUnsupportedXRepeatOp` → invalid. `<16 x i32>`
(= 2 blocks) is still allowed. (Phase 5 relaxes this to multiples of 4, now that `<4 x i32>` has
blocks of its own.)

### Tests (Phase 4)

- **New** `llvm/test/CodeGen/RISCV/xrepeat-v8i32-reduce.ll` (autogenerated): dot product into
  an accumulator (mask 6), plain `reduce.add` (mask 2), vector·scalar dot product, constant-index
  extract and insert, and the two regression tests for bug fix 1 (two-source shuffle, non-splat
  build_vector).
- **New** `llvm/test/Transforms/LoopVectorize/RISCV/xrepeat.ll`: a dot-product loop vectorizes with
  VF = 8 and the reduction inside the loop; an `a[i] = b[i]*s + c[i]` loop vectorizes with VF = 8;
  a loop with `xor` stays scalar.
- **Updated** `llvm/test/Analysis/CostModel/RISCV/xrepeat.ll`: new costs (2 per pair, invalid for
  the rest), plus a `@widths` function checking that `<4 x i32>` is invalid and `<16 x i32>` costs
  2 blocks.
- **Regenerated** `llvm/test/CodeGen/RISCV/xrepeat-v8i32-arith.ll`: only the `xor` function
  changed (scalarized in registers instead of through the stack, from bug fix 1).
- Result: all 3249 tests in `CodeGen/RISCV`, `MC/RISCV`, `Analysis/CostModel/RISCV`,
  `Transforms/{LoopVectorize,SLPVectorizer,LoopUnroll}/RISCV` pass.

### Validation

There is no RISC-V libc or `repeat_rv` simulator on this machine, so the binaries were run on a
small Python emulator of RV32IM + MAC/REPEAT, written from the semantics in `PLAN.md` (not from
the real hardware), with a minimal bare-metal runtime (`_start`, a `printf` that writes to an MMIO
port, exit via `ecall`) and linked with `/usr/bin/ld.lld`.

> ⚠ The emulator lives in the session scratchpad, which is temporary:
> `/tmp/claude-1000/-home-igabirondo-tesis-dl4compilers-llvm-project-22/58d18e53-eecd-4e39-9a71-8032c4f240e2/scratchpad/sim/`
> (`rvsim.py`, `rt.c`, `link.ld`, `build.sh`). Copy it here if you want to keep it.

| Version | Checksum | Instructions in the `bench_mark(0)..(1)` window |
|---|---|---|
| Scalar `main_mlp.c` (`rv32im`) | `0xd04f38bb` PASS | 18462 |
| Hand-written `mlp_repeat.c` | `0xd04f38bb` PASS | 3505 |
| Auto-vectorized `main_mlp.c` (`rv32im_xrepeat`) | `0xd04f38bb` PASS | 3423 |

The hand-written version passing too is evidence that the emulator's REPEAT model is right. With
non-default sizes (67/21/16, 8/8/8, 9/17/5, 100/40/3, 7/7/7, 16/24/33, 5/3/2) the vectorized
checksum matches the scalar one in every case.

Generated inner loop (identical in shape to `mlp_repeat.c`):

```
.LBB2_2:
    lw      a6, 0(t2)
    xr.repeat 1, ra, s11        # V1 = W1[h][i..i+7]
    lw      s0, 0(t3)
    xr.repeat 1, ra, s11        # V0 = input[i..i+7]
    addi    t3, t3, 32
    xr.mac  t1, s0, a6, t1
    xr.repeat 6, zero, s11      # acc += Σ V0[k]*V1[k]
    addi    t2, t2, 32
    bne     t3, t4, .LBB2_2
```

### Known gaps (at the end of Phase 4; see Phase 5 for what changed)

- **Must run on the real `repeat_rv` simulator** to confirm the checksum and get cycle counts.
  The instruction counts above are not cycles.
- **SLP on short, fully unrolled loops** (e.g. `HIDDEN_SIZE = 21`): the result is correct, but the
  invariant `hidden[0..15]` blocks are hoisted out of the loop and stay live next to the `W2`
  blocks (4 blocks needed, 3 available), so they spill.
- **Tiny sizes** are a few instructions slower than scalar (9/17/5: 1002 vs 887; 7/7/7: 356 vs
  349). Cost-model tuning.
- **`<8 x i32>` as a function argument or return value** crashes the calling convention
  (`Unhandled register class for ValueType`, `RISCVCallingConv.cpp`). Not produced by the
  vectorizers, but reachable from IR or clang vector types across non-inlined calls.
- Spills of a block still use 8 `lw` (`PseudoXRLoad8`) instead of `lw` + REPEAT, because there may be
  no free registers for the stride and count at that point.
- Open ISA questions from `PLAN.md` still apply (REPEAT `rd`/`funct3`, counts other than 7,
  stride 0, interrupts in the middle of a REPEAT). The compiler always emits count = 7 and
  stride = 4 (loads) or `x0` (MAC).

---

## Phase 5 — `<4 x i32>` blocks; the compiler picks 4 or 8

Goal: also accept vectors of 4 elements, whose block may start at any multiple of 4 from x8
(x8, x12, …, x28), and let the compiler choose whichever width is cheaper.

The ISA is unchanged: a 4-element vector is the same `lw` / MAC + REPEAT pairs with **count 3**
instead of 7. Assumed (from the user, 2026-10-29): a walking field may start at any multiple of 4
when only 4 registers are walked.

### Registers — `RISCVRegisterInfo.td`

- Six new registers `X8_X11`, `X12_X15`, …, `X28_X31` (sub-registers `sub_xr0..3`), generated by
  the same `foreach` as the 8-wide ones.
- New class `XRVec4` (`v4i32`), same allocation order idea as `XRVec`: x24..x31 and x16..x23
  first, `X12_X15` next, `X8_X11` (frame pointer, s1, a0, a1) last. `GeneratePressureSet = 0`
  as for `XRVec`.
- New sub-register indices **`sub_xrlo` / `sub_xrhi`**: the low/high 4 registers of an 8-wide
  block. **Why named explicitly:** TableGen notices that `X8_X11` is the first half of `X8_X15`
  and invents an index called `sub_xr0_sub_xr1_sub_xr2_sub_xr3` on its own; defining it with
  `CoveringSubRegIndices` gives it a stable name the patterns can use.

### One set of pseudos and patterns for both widths — `RISCVInstrInfoXRepeat.td`

- A small record `XRVecInfo<width, vt, regclass>` (with `Count` = `ADDI x0, width-1`) and
  `foreach V = [XRV8, XRV4]` around all the code-generation definitions, so every pseudo and
  pattern exists for both widths.
- **Pseudos renamed** to carry the width: `PseudoXRVLoad8/4`, `PseudoXRMAC8_*/PseudoXRMAC4_*`,
  `PseudoXRDot8_*/PseudoXRDot4_*`, `PseudoXRLoad8/4`, `PseudoXRStore8/4`.
- `XR_SPLAT` and `XR_DOT` now accept any `i32` vector type instead of only `v8i32`. Because a splat
  of a scalar no longer has a fixed width, the patterns write the type explicitly
  (`(V.VT (riscv_xr_splat …))`); without it TableGen can't infer the types of the dot-product
  pattern with two scalar operands.
- **Halves are free:** `extract_subvector(v8, 0/4)` → `EXTRACT_SUBREG sub_xrlo/hi`,
  `insert_subvector(v8, v4, 0/4)` → `INSERT_SUBREG`, `concat_vectors(v4, v4)` → `REG_SEQUENCE`.
  **Why:** with both widths legal, the SLP vectorizer mixes them (e.g. 12 = 8 + 4). Before these
  patterns the halves went through the stack or element by element, and with `HIDDEN_SIZE = 20`
  the register allocator failed with *"ran out of registers"*.

### Lowering and selection — `RISCVISelLowering.cpp`, `RISCVISelDAGToDAG.cpp`

- `v4i32` is added to `XRVec4` and gets the same operation actions as `v8i32` (loop over both
  types). `EXTRACT_SUBVECTOR`, `INSERT_SUBVECTOR`, `CONCAT_VECTORS` are `Custom` and kept when they
  move a whole 4-element half; anything else is expanded as before.
- `RISCVDAGToDAGISel::Select` has hand-written code for `INSERT_SUBVECTOR`/`EXTRACT_SUBVECTOR`
  that assumes RVV (it asserted in `getContainerForFixedLengthVector`); it now leaves fixed-length
  vectors to the patterns when there is no V.
- **New DAG combine `combineXRepeatVecReduceAdd`** (registered for `VECREDUCE_ADD`). The SLP
  vectorizer reduces 12 values as an 8-wide and a 4-wide part and then *merges* them into one
  vector before the final `reduce.add` (`emitReduction` in `SLPVectorizer.cpp`, no cost check).
  The merged vector of products needs a block, which caused heavy spills (12/12 went from 886 to
  1890 instructions). The combine splits it back, since a sum doesn't depend on grouping:
  - `reduce(a + b)` → `reduce(a) + reduce(b)`
  - `reduce(insert_subvector(V, extract_subvector(V, i) + X, i))` → `reduce(V) + reduce(X)`
  - `reduce(shuffle(V + concat(X, undef), V, <0..3, 12..15>))` → `reduce(V) + reduce(X)` (the
    same merge after InstCombine)

  Each `reduce(mul(a, b))` is then one dot-product MAC + REPEAT (mask 0110).
- **`shouldReassociateReduction` returns false for XRepeat types.** The generic DAG combiner does
  the opposite rewrite (`reduce(a) + reduce(b)` → `reduce(a + b)`); with both active the compiler
  looped forever (seen with 16/16).
- **New DAG combine `combineXRepeatDotAdd`** (on `ADD`): `XR_DOT(acc, a, b) + z` →
  `XR_DOT(acc + z, a, b)`. Chained dot products then accumulate into one register, starting from
  the bias, instead of each starting from 0 and being added at the end (saves `li 0` + `add` per
  output).

### Copies, spills, expansion

- `copyPhysReg`, `storeRegToStackSlot`, `loadRegFromStackSlot`: 4 `addi`/`sw`/`lw` for `XRVec4`.
- `eliminateFrameIndex`: the offset check uses +12 (last of 4 words) for `PseudoXRLoad4/Store4`.
- `RISCVExpandPseudoInsts.cpp`: one `expandXRLoadStore` for both widths; `expandXRMAC` recognizes
  blocks of either class (helper `isXRVecReg`).
- **`RISCVRegisterInfo::shouldCoalesce`**: don't merge a `v4i32` into half of a `v8i32`. Merging
  ties the two live ranges together, so the 4-element value occupies a whole 8-register block;
  measured on the emulator it cost more spills than the 4 `mv` it saves (20/20: 1815 vs 2103
  instructions at the time), with no size getting better.

### Choosing the width — TTI

| Hook | Change | Why |
|---|---|---|
| `getXRepeatPairCost` | accepts element counts that are multiples of **4** and legalize to `v4i32` or `v8i32` | `<4 x i32>` is now a real block, so it costs one pair like `<8 x i32>`. `<2 x i32>` (widened to 4) stays invalid. |
| `getNumberOfRegisters(vector)` | **6** | Counted in 4-register units… |
| `getRegUsageForType` | `v4i32` = 1, `v8i32` = 2 | …so the vectorizer's register-pressure check sees that three 8-wide or six 4-wide vectors fit. |
| `getRegisterBitWidth` | unchanged (256) | The widest VF is still 8; the vectorizer also tries 4 and 2 by itself. |

Nothing else was needed: LLVM 22's loop vectorizer already compares VFs per element, rejects VFs
whose estimated register usage exceeds the target's (RISC-V enables this), and, when the trip count
is known, includes the scalar remainder in the comparison. Results (`LoopVectorize/RISCV/xrepeat.ll`):

| Loop | Chosen VF | Why |
|---|---|---|
| dot product, unknown `n`, 16 or 64 iterations | 8 | half as many pairs per element |
| dot product, 4 iterations | 4 | 8 doesn't fit |
| dot product, 20 iterations | 4 | 5 × VF4 beats 2 × VF8 + 4 scalar iterations |
| `o[i] = a·b + c·d + e·f` (6 loads live) | 4 | 6 blocks of 4 fit, 6 blocks of 8 don't |

### Validation

Differential test on the emulator: every size compiled with `rv32im_xrepeat` gives the same
checksum as plain `rv32im`. Instructions in the `bench_mark` window:

| IN/HIDDEN(/OUT) | Phase 4 (8 only) | Phase 5 | scalar `rv32im` |
|---|---|---|---|
| 64/32 (default) | 3423 | 3423 | 18462 |
| 20/20 | 1926 | **1707** | 2908 |
| 36/20 | 2280 | **2204** | 6555 |
| 64/12 | 1378 | **1369** | 6199 |
| 12/12 | 886 | **878** | 1196 |
| 16/16 | 1408 | **1330** | 1676 |
| 9/17/5 | 1002 | **746** | 887 |
| 7/7/7 | 356 | **280** | 349 |
| 24/40, 28/8, 64/32/4, 40/24/12, 8/8, 4/4, 44/28 | same | same | — |

The default size is unchanged (the hand-written `mlp_repeat.c` is 3505). No size got slower, and
the two sizes that were slower than scalar in Phase 4 (9/17/5, 7/7/7) are now faster.

### Tests (Phase 5)

- **New** `llvm/test/CodeGen/RISCV/xrepeat-v4i32.ll` (autogenerated): `v4i32` loads/stores,
  MAC forms, dot product and `reduce.add`, element extract, non-splat build, `<2 x i32>` widened to
  a 4-block, both widths in one function, 4-block spills, and the three reduction-splitting cases
  (12 = 8 + 4 in both shapes, 16 = 8 + 8).
- **Updated** `llvm/test/Transforms/LoopVectorize/RISCV/xrepeat.ll`: trip counts 4, 20 (VF 4) and
  16 (VF 8), and the 6-array register-pressure loop (VF 4).
- **Updated** `llvm/test/Analysis/CostModel/RISCV/xrepeat.ll`: `<4 x i32>` costs one pair,
  `<2 x i32>` stays invalid, `<12 x i32>` costs 2 blocks.
- All XRepeat tests and all 3267 tests in the RISC-V suites pass.

### Known gaps (Phase 5)

- **A loop with exactly 12 iterations (a known constant below 16) isn't vectorized at all.** For
  such short loops LoopVectorize forbids a scalar remainder, but only checks whether the *widest*
  VF (8) divides the trip count; it then tries tail folding (masking), which XRepeat can't do, and
  gives up instead of trying VF 4. This is the generic `FIXME: look for a smaller MaxVF that does
  divide TC rather than masking` in `LoopVectorize.cpp` (`computeMaxVF`); fixing it would change
  the generic vectorizer for all targets.
- **Spills when all loads are scheduled first.** Small functions that load 3–4 blocks before
  using any of them (e.g. the `dot16` test) still spill, because the schedulers don't see block
  pressure (`GeneratePressureSet = 0`) and the argument registers sit inside `X8_X15`. In loop
  bodies of the benchmark this hasn't been a problem.
- **No epilogue vectorization:** with an unknown trip count the main loop uses VF 8 and up to 7
  leftover elements run scalar; a VF 4 epilogue could take 4 of them
  (`preferEpilogueVectorization` / `getEpilogueVectorizationMinVF`).
- `<4 x i32>` as a function argument or return value has the same calling-convention gap as
  `<8 x i32>`.

---

## Phase 6 — Strided loads (`lw` + REPEAT with any stride)

Goal: load vector elements that are not next to each other in memory (a column of a row-major
matrix, every 8th word, a reversed array) with one `lw` + REPEAT, by putting the distance in
REPEAT's stride register instead of 4. Until now only contiguous loads (stride 4) were supported,
so a strided access cost 8 `lw` plus inserts, and the vectorizers either skipped the loop or
emitted 8 separate loads (bert_tiny's `scores × V` loop).

LLVM 22 has two ways for a vectorizer to ask for a strided load; both are handled:

- **SLP** emits `llvm.experimental.vp.strided.load(ptr, stride, all-true mask, evl = N)` when the
  target says strided loads are legal.
- **The loop vectorizer** has no strided load of its own. It uses *interleave groups*: one wide load
  and one shuffle per field (`<64 x i32>` load + 8 shuffles for `B[k][0..7]` at VF 8). The
  `InterleavedAccess` IR pass hands that to the target's `lowerInterleavedLoad`, which now replaces
  each field with a `vp.strided.load` of stride `Factor * 4`.

| File | Change | Why |
|---|---|---|
| `RISCVInstrInfoXRepeat.td` | `XR_STRIDED_LOAD` node (chain, memory operand) and a pattern to `PseudoXRVLoad{8,4}` with the stride in a register | The pseudo already took a stride register; it was always given 4. The address's immediate offset is folded into the `lw`. |
| `RISCVISelLowering.cpp` | `EXPERIMENTAL_VP_STRIDED_LOAD` → `XR_STRIDED_LOAD`; `EXPERIMENTAL_VP_STRIDED_STORE` → one `sw` per element | Only the unmasked, full-length form (all-true mask, `evl` = element count), which is the only one the vectorizers emit for XRepeat. REPEAT can't repeat stores, so a strided store is like an ordinary vector store. |
| same | both marked Custom for `v8i32`/`v4i32` **and for the mask types `v8i1`/`v4i1`** | The `<N x i1>` mask has no legal type. Type legalization first offers the node to the target keyed by the illegal operand's type; without this, the generic code tries to promote the mask and aborts. |
| same, `isLegalStridedLoadStore` | true for `v8i32`/`v4i32` with 4-byte alignment | This is what makes SLP form strided loads. It is shared with strided stores (SLP uses stride −4 for reversed stores), hence the store lowering. |
| `RISCVInterleavedAccess.cpp` | `lowerXRepeatInterleavedLoad`: one `vp.strided.load` per used field, at `ptr + field * 4` with stride `Factor * 4` | Turns the loop vectorizer's interleave groups into strided loads. Only plain loads whose fields are whole `v8i32`/`v4i32` blocks; anything else is left alone. |
| `RISCVTargetTransformInfo.cpp` | `getStridedMemoryOpCost`: same as the contiguous load (one pair) or store (8 `sw`). `getInterleavedMemoryOpCost`: one pair per used field. `getMemIntrinsicInstrCost` dispatches strided intrinsics before the "unsupported XRepeat op" check | So both vectorizers see the real cost. |

Test: `llvm/test/CodeGen/RISCV/xrepeat-strided.ll` (register, constant and negative strides at both
widths; a strided load feeding a dot product; a strided store; factor-8 and partial factor-4
interleave groups).

### Results

- **bert_tiny `scores × V`** (V's column, stride 512 bytes): 15 instructions with 8 `lw` → 9, with
  `lw` + `xr.repeat 1, x15(=512), x7`. Same shape as the hand-written version (10–11).
- Every benchmark still gives the right checksum on the emulator (plain/rv32im, plain/xrepeat,
  hand-written), and the RISC-V CodeGen, MC, CostModel, LoopVectorize, SLPVectorizer,
  InterleavedAccess and LoopUnroll suites pass (3254 tests).
- Step counts of mlp, axpy, dotxvf and gepdot are unchanged (they had no strided accesses the
  compiler vectorized).

### Known gaps (Phase 6)

- gepdot was not vectorized by Phase 6 (register pressure in the loop vectorizer's plan across
  `k`). Fixed in Phase 7 by vectorizing across `v` instead.
- Reversed strided stores (stride −4) are correct but get 8 extra `mv`: the DAG combiner merges the
  8 `sw` back into a reversed contiguous store.
- Masked or partial-length (`evl` < N) strided accesses are not supported; nothing emits them for
  XRepeat today.
- Negative strides rely on REPEAT adding the stride register as a signed value; this matches the
  emulator but is not yet confirmed on the real core.

## Phase 7 — gepdot: splat cost and keeping small loops rolled

**Problem.** In the plain gepdot (`for k: for v < 8: C[v] += A[k] * B[k*8 + v]`) the early full
unroll (`LoopFullUnrollPass`, before any vectorizer) unrolls the 8-iteration `v` loop, leaving
8 scalar accumulators in the `k` loop. Then:

- the loop vectorizer can only vectorize across `k`: 8 strided B columns and 8 vector accumulators,
  which it rejects for register pressure (9 blocks live, 3 exist);
- SLP builds the right tree across `v`, but scored it Invalid (the splat of `A[k]`), and once that is
  fixed, +1 (in-loop savings −7 against +8 for extracting C after the loop, which SLP weighs the same).

`#pragma clang loop unroll(disable)` on the `v` loop showed that keeping the loop rolled is enough:
the loop vectorizer then vectorizes across `v` with contiguous loads only.

**Changes** (`RISCVTargetTransformInfo.cpp`):

1. `getShuffleCost`: the XRepeat branch refines the shuffle kind with `improveShuffleKindFromMask`
   first. SLP asks for a splat as a single-source permute with an all-zero mask, which used to fall
   through to Invalid; it now costs as a broadcast (the splat folds into the MAC as its scalar
   operand). Test: `llvm/test/Transforms/SLPVectorizer/RISCV/xrepeat-splat.ll`.
2. `getUnrollingPreferences`: new rule after the Phase 5 one. With XRepeat, a loop that is not yet
   vectorized and passes `isXRepeatVectorizableSmallLoop` gets `UP.FullUnrollMaxCount = 0`, i.e. the
   compiler does on its own what the pragma did. The check is strict on purpose:
   - innermost, single exit, constant trip count that is a multiple of 4;
   - body only PHI/GEP/icmp/br, simple i32 loads with stride 1 or a loop-invariant address, simple
     i32 stores with stride 1, and i32 add/sub/mul;
   - at least one add/sub/mul on loaded data (the induction update alone does not count) and one store.

   Hidden flag to turn it off for A/B runs: `-mllvm -riscv-xrepeat-keep-small-loops=false`.
   Test: `llvm/test/Transforms/LoopUnroll/RISCV/xrepeat-keep-small-loops.ll` (kept rolled; and still
   unrolled for i16, trip count 6, a zero fill, a stride-2 store, the flag off, and without XRepeat).

**Risk.** The same hook is asked by the unroll pass after the vectorizer. A loop that passes the check
but that the loop vectorizer then rejects stays rolled (slower scalar code, not wrong code). None of
the six benchmarks hits this.

**Results** (emulator, plain/xrepeat):

- gepdot: 28,695 → **22,555** steps; the `k` loop is 8 instructions (`lw`+REPEAT for the B row,
  `xr.mac`+REPEAT with `A[k]` as the fixed scalar, mask `0xd`). Hand-written version: 23,832.
- mlp, axpy, dotxvf, resnet8 (IMG_SIZE=8) and bert_tiny (8/64/256): the IR with the rule on and off
  is identical, as are the step counts; every checksum matches.
- lit: RISC-V CodeGen, MC, CostModel, LoopVectorize, SLPVectorizer, InterleavedAccess, LoopUnroll
  (all, not only RISC-V) and PhaseOrdering pass (3656 tests).

## Benchmarks: hand-written vs compiler-vectorized

Layout: `benchmarks_repeat/<bench>/main.c` is the hand-written version (inline asm through
`common/repeat.h`), `benchmarks_repeat/<bench>/<bench>_base.c` the plain C version with the same data
and checksum (`mlp`'s plain version is `base_mlp/main_mlp.c`). `compare_asm.sh` builds each benchmark
three ways (plain/rv32im, plain/rv32im_xrepeat, hand) into `asm_compare/<bench>/`, and
`asm_loops.py` lists every innermost loop in `loops.txt` and `asm_compare/summary.txt`.

Steps are emulator steps in the measured window (`bench_mark(0)`…`bench_mark(1)`), REPEATed
instructions included; resnet8 with `IMG_SIZE=8`, bert_tiny with 8 tokens, hidden 64, FFN 256.
REPEAT mask bits: 0 = `rd`, 1 = `rs1`, 2 = `rs2`, 3 = `rs3` advance by one register per repeat.

| Benchmark | Hand-written | Clang (plain C) | Hot loop (hand / clang) | Steps rv32im / clang / hand |
|---|---|---|---|---|
| mlp | dot product per neuron, mask 6 | the same | 10 / 9 instructions | 18,462 / **10,143** / 10,225 |
| axpy | 2 MACs: `t = a*x` (mask 5), `y = 1*t + y` (mask 13) | 1 MAC: `y = a*x + y` (mask 11) | 19 / 17 | 9,012 / **4,760** / 5,885 |
| dotxvf | loads `x` once, 4 dot products (one per row) per loop | 4 separate loops, `x` reloaded in each | 26 (4 rows) / 9 (1 row) | 28,706 / 15,400 / **11,408** |
| gepdot | across `k`: 8 strided column dot products into 8 pinned scalars | across `v`: 1 MAC into a block of 8 accumulators (mask 13, Phase 7) | 67 (8 `k`) / 8 (1 `k`) | 28,695 / **22,555** / 23,832 |
| resnet8 | im2col, then dot products (mask 6) | direct convolution, dot product over input channels (mask 6) | 10 / 9 | not comparable: the window covers only the first stage, which differs between versions |
| bert_tiny | dot products, `vadd`, scores × V | the same, plus layernorm mean/variance; scores × V with a strided load (Phase 6) | 10–11 / 9 | 22,752 / **18,265** / 20,075 |

- **Clang wins** on axpy (folds `a*x + y` into one MAC), gepdot (better direction; C stays in one
  block, while clang compiles the hand version's 8 pinned accumulators with 12 `mv` and stack
  spills per iteration) and bert_tiny (vectorizes more loops).
- **Hand wins** on dotxvf: see the known limitation below.
- **mlp** is the same loop; clang's is one instruction shorter (the address doubles as the counter).
- One clang weakness in bert_tiny: in one copy of the variance loop the block holding the splatted
  mean is reloaded from the stack every iteration (8 `lw`), from register pressure.

## Known limitation — dotxvf: no reuse of `x` across rows

dotxvf computes `y[u] = A[u] · x` for 4 rows (`u < 4`, `k < 1024`). Emulator steps: rv32im 28,706,
clang 15,400, hand-written **11,408**. This is the one benchmark where the hand version clearly wins,
and the compiler does not close the gap.

**Why the hand version is faster.** It loads each 8-wide block of `x` once and uses it for all 4
rows: per block, 5 `lw`+REPEAT and 4 `xr.mac`+REPEAT (mask 6), 89 steps. The early full unroll turns
the 4-iteration `u` loop into 4 separate `k` loops, and clang vectorizes each one on its own
(9 instructions, 30 steps per block per row, 120 for the 4 rows), reloading `x` every time.

**What was tried** (experiments only, nothing in the code base):

| Attempt | Result | Steps |
|---|---|---|
| `-fexperimental-loop-fusion` (LoopFuse before the vectorizers) | The 4 loops are fused, but each keeps its own induction variable, so `x[k]` is still loaded 4 times; the loop vectorizer rejects it for register pressure, so the kernel stays scalar | 19,467 |
| Fusion + `indvars` + `gvn` by hand before the vectorizer | One induction variable, one load of `x` and 4 of `A`. VF 8 rejected (“too many registers”), VF 4 chosen | 15,377 |
| Same, with VF 8 forced (`-force-vector-width=8`) | Correct, but the blocks spill to the stack every iteration | 20,370 |

**Root cause.** In the vectorizer's plan all 5 loads come first and the 4 `mul + reduce.add`
expressions (the MACs) after them, so 5 eight-wide blocks are live at once while XRepeat has 3. The
estimate is right for that order: forcing VF 8 does spill. The hand version interleaves
`load A0; mac; load A1; mac; …`, which needs only 2 blocks.

**What a fix would need** (not done; most of it is generic LLVM, not the RISC-V target):

1. Run loop fusion before the vectorizers, followed by an induction-variable/GVN cleanup so the
   fused loop has one counter and one load of `x` (pipeline change).
2. Place each `A` load right before its MAC: in the vectorizer's plan, or in a RISC-V IR pass before
   instruction selection.
3. Make the vectorizer's register-usage estimate see that order, so it accepts VF 8 (generic
   `VPlanAnalysis` change).

Expected result if all three were done: about the hand version's 11.4k steps.

## Phase 8 — `xrepeatint`: a frozen copy, so `xrepeat` can keep evolving

**Goal.** Keep improving MAC/REPEAT support without losing what Phases 0–7 built. There are now two
extensions with the same instructions (`xr.mac`, `xr.repeat`) and, for now, exactly the same code
generation:

| `-march` | LLVM feature | Role |
|---|---|---|
| `rv32im_xrepeat` | `XRepeat` | the version under development; new work goes here |
| `rv32im_xrepeatint` | `XRepeatInt` | frozen: what XRepeat did at the end of Phase 7 |

**Why not `xrepeat2` or `xrepeat_int`.** In an ISA string, digits at the end of a name are its
version (`xrepeat2` parses as `xrepeat` version 2), and `_` separates extensions
(`xrepeat_int` would be `xrepeat` + `int`). So the name must be letters only, or end in one.

**How the code is shared, not copied.**
- `RISCVFeatures.td`: `FeatureVendorXRepeatInt` / `HasVendorXRepeatInt`, plus
  `HasVendorXRepeatAny` (*XRepeat or XRepeatInt*, an `any_of` assembler predicate).
- `RISCVInstrInfoXRepeat.td`: the instructions, pseudos and patterns use `HasVendorXRepeatAny`.
- `RISCVSubtarget.h`: `hasXRepeatVectors()` = (XRepeat or XRepeatInt) and no V. It replaces the
  eight `hasVendorXRepeat() && !hasVInstructions()` checks in `RISCVISelLowering.cpp`,
  `RISCVInterleavedAccess.cpp` and the TTI helper of the same name.
- `RISCVDisassembler.cpp`: the XRepeat decoder table is enabled by either feature.
- `RISCVISAInfo.cpp`: `xrepeatint` is rv32-only, and `xrepeat` + `xrepeatint` together is an error
  (they share opcodes, so a disassembler could not tell them apart).

**Rule for future work.** Anything only the developed version should get is guarded by
`HasVendorXRepeat` in `.td` and `Subtarget.hasVendorXRepeat()` in C++. Shared code stays under
`HasVendorXRepeatAny` / `hasXRepeatVectors()`. That keeps `xrepeatint`'s output fixed.

**Tests.** Every XRepeat RUN line has an `+xrepeatint` twin that must pass the same checks
(CodeGen, MC, LoopVectorize, SLP, LoopUnroll, CostModel). New unit tests check the rv64 error and
the incompatibility. Validation: all 3270 RISC-V lit tests and the 641 TargetParser unit tests
pass. `compare_asm.sh` regenerates byte-identical code (only the `.ident` commit hash changes),
and every benchmark compiled with `xrepeatint` is identical to `xrepeat` except for the arch
attribute lines.

## Installing from scratch

These steps build the modified clang on a fresh Linux machine. They reproduce the build used for
this work: Release with assertions, `X86;RISCV` back ends, clang as the only extra project,
built with the system clang and linked with lld.

### 1. Prerequisites

| Tool | Used here | Why |
|---|---|---|
| `git` | any recent | Clone the repository |
| `cmake` | 3.28.3 (LLVM 22 needs ≥ 3.20) | Configure the build |
| `ninja` | 1.11.1 | Build tool; much faster than make for LLVM |
| `clang` / `clang++` | system packages | Host compiler that builds LLVM (any C++17 compiler works; gcc is fine too) |
| `lld` | `/usr/bin/ld.lld` | Linker for LLVM itself, and for the bare-metal test programs |
| `python3` | any 3.8+ | lit test runner, check-update scripts, emulator |

On Ubuntu/Debian:

```bash
sudo apt install git cmake ninja-build clang lld python3
```

Disk and time: the build directory takes about 2 GB, and a full clone with history adds about
3 GB more (a shallow clone is much smaller). A first build of `clang` takes from roughly 30 minutes
to a few hours, depending on the number of cores. Linking needs a lot of memory, which is why
the link jobs are limited to 2 below.

### 2. Get the source

The work lives on branch `clang-22-custom-repeat`, based on upstream `release/22.x`
(LLVM 22.1.0-git), in the fork `https://github.com/igabirondo16/llvm-project-22`.

```bash
# Shallow clone of the branch only. Drop --depth 1 if you need the history.
git clone --branch clang-22-custom-repeat --single-branch --depth 1 \
    https://github.com/igabirondo16/llvm-project-22.git llvm-project-22
cd llvm-project-22
```

> The branch has to be pushed to `origin` first (`git push -u origin clang-22-custom-repeat`).
> This folder (`.custom_repeat_inst/`) is not tracked by git, so copy it in separately, or
> commit it, if the other machine needs the documentation, benchmarks and scripts.

### 3. Configure

```bash
cmake -S llvm -B build-22 -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_ENABLE_PROJECTS=clang \
    -DLLVM_TARGETS_TO_BUILD="X86;RISCV" \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DLLVM_USE_LINKER=lld \
    -DLLVM_PARALLEL_LINK_JOBS=2
```

| Option | Why |
|---|---|
| `-S llvm` | The top-level CMake project is the `llvm/` folder, not the repository root |
| `Release` + `ASSERTIONS=ON` | Fast compiler, but internal checks stay on, so a wrong change fails loudly instead of producing bad code |
| `ENABLE_PROJECTS=clang` | Builds the C front end as well as the LLVM tools (`llc`, `opt`, `llvm-mc`, ...) |
| `TARGETS_TO_BUILD="X86;RISCV"` | RISC-V for this work; X86 so the compiler can also target the host. Building all targets is several times slower |
| `LLVM_USE_LINKER=lld` | Much faster and lighter linking than GNU ld |
| `PARALLEL_LINK_JOBS=2` | Each link of `clang` uses several GB of RAM; this avoids running out of memory |

### 4. Build

```bash
ninja -C build-22 clang llc opt llvm-mc llvm-objdump llvm-objcopy FileCheck not count
```

This builds only what the work and its tests need. `ninja -C build-22` with no target builds
everything, which takes much longer. The tools end up in `build-22/bin/`.

### 5. Check the installation

```bash
# The new extension is known
build-22/bin/llc -mtriple=riscv32 -mattr=help 2>&1 | grep -i xrepeat

# The assembler encodes the new instructions
echo 'xr.mac x5, x16, x24, x5' | build-22/bin/llvm-mc -triple=riscv32 -mattr=+xrepeat -show-encoding

# XRepeat regression tests (all should pass)
build-22/bin/llvm-lit -v llvm/test/MC/RISCV/xrepeat-*.s llvm/test/CodeGen/RISCV/xrepeat-*.ll \
  llvm/test/Analysis/CostModel/RISCV/xrepeat.ll llvm/test/Transforms/LoopVectorize/RISCV/xrepeat.ll

# Assembly of the benchmark, from the repo root (writes .custom_repeat_inst/asm/)
.custom_repeat_inst/build_asm.sh
grep -c xr.repeat .custom_repeat_inst/asm/main_mlp.dis   # > 0
```

Use it with `--target=riscv32-unknown-elf -march=rv32im_xrepeat`. Without `_xrepeat` in
`-march`, the compiler behaves like the original, unmodified LLVM 22.

After editing any `.td` or `.cpp` file, rebuild `clang` too, not only `llc`. `clang` contains
its own copy of the back end, and a stale `clang` once produced a false test failure.

## How to rebuild and re-run everything

```bash
# Build (from the repo root)
ninja -C build-22 clang llc opt llvm-mc llvm-objdump

# XRepeat tests only
build-22/bin/llvm-lit -v llvm/test/MC/RISCV/xrepeat-*.s llvm/test/CodeGen/RISCV/xrepeat-*.ll \
  llvm/test/Analysis/CostModel/RISCV/xrepeat.ll llvm/test/Transforms/LoopVectorize/RISCV/xrepeat.ll \
  llvm/test/Transforms/SLPVectorizer/RISCV/xrepeat-splat.ll \
  llvm/test/Transforms/LoopUnroll/RISCV/xrepeat-keep-small-loops.ll

# All RISC-V suites touched by these changes
build-22/bin/llvm-lit -q llvm/test/CodeGen/RISCV llvm/test/MC/RISCV \
  llvm/test/Analysis/CostModel/RISCV llvm/test/Transforms/LoopVectorize/RISCV \
  llvm/test/Transforms/SLPVectorizer/RISCV llvm/test/Transforms/InterleavedAccess/RISCV \
  llvm/test/Transforms/LoopUnroll llvm/test/Transforms/PhaseOrdering

# Assembly of every benchmark (plain/rv32im, plain/xrepeat, hand) -> asm_compare/
.custom_repeat_inst/compare_asm.sh            # extra clang flags are passed through, e.g. -DNC=256

# A/B: the Phase 7 unroll rule off
build-22/bin/clang ... -mllvm -riscv-xrepeat-keep-small-loops=false

# Regenerate autogenerated checks after an intended codegen change
python3 llvm/utils/update_llc_test_checks.py --llc-binary build-22/bin/llc <test.ll>
python3 llvm/utils/update_analyze_test_checks.py --opt-binary build-22/bin/opt <test.ll>

# See what the vectorizer decided, and why
build-22/bin/clang --target=riscv32-unknown-elf -march=rv32im_xrepeat -O2 -S main_mlp.c \
  -Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize
```

(Compiling the benchmark needs a `stdio.h`; without a RISC-V libc, a one-line stub declaring
`printf` plus `-ffreestanding -isystem <dir>` is enough to generate assembly.)
