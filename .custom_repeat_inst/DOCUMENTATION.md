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
| 8 — `xrepeatint`: frozen copy of XRepeat; `xrepeat` keeps evolving | `477e688a98d6` | committed |
| 9 — `xrepeat` targets the VRF core: assembler and disassembler | — | not committed yet (one commit with Phases 9–18) |
| 10 — `xrepeat`: vectors in blocks of F registers (8 and 16 wide, i32 and f32) | — | not committed yet (one commit with Phases 9–18) |
| 11 — `xrepeat`: instruction + REPEAT for VRF vector operations | — | not committed yet (one commit with Phases 9–18) |
| 12 — `xrepeat`: cost model, reductions; the vectorizers use the VRF | — | not committed yet (one commit with Phases 9–18) |
| 13 — Emulator of both cores, kept in the repo (`sim/`); VRF code run and checked | — | not committed yet (one commit with Phases 9–18) |
| 14 — VRF core: i32 sums and dot products accumulate in the loop, in an f register | — | not committed yet (one commit with Phases 9–18) |
| 15 — VRF core: fused ordered float dot product (`fmadd.s` + REPEAT) | — | not committed yet (one commit with Phases 9–18) |
| 16 — VRF core: strided and interleaved loads **and stores** (`flw`/`fsw` + REPEAT) | — | not committed yet (one commit with Phases 9–18) |
| 17 — resnet8: chained reductions, 16-product sums, block-load scheduling | — | not committed yet (one commit with Phases 9–18) |
| 18 — axpy (a metric, not a gap) and dotxvf: loop fusion before the vectorizers | — | not committed yet (one commit with Phases 9–18) |

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

> The emulator now lives in [`sim/`](sim/) and also models the VRF core (Phase 13).

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

Steps are emulator steps in the measured window (`bench_mark(0)`…`bench_mark(1)`; for bert_tiny that
is only the embeddings, see the measurement correction in Phase 16), REPEATed
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

## Known limitation — dotxvf: no reuse of `x` across rows (fixed for the VRF core in Phase 18)

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

## Phase 9 — `xrepeat` moves to the VRF core: assembler and disassembler

**Goal.** Make `xrepeat` describe the new `repeat_rv` core in
[`ENCODINGS.md`](ENCODINGS.md). Its vector data lives in a second register file, the VRF, which
is the F extension's register file: `f0`..`f31` hold floats and integers alike, and `f0` is an
ordinary register. Addresses and the REPEAT stride stay in x registers. This phase only teaches
the assembler and disassembler the new instructions; code generation for them comes next.

**Changes to Phase 8's split.** The two extensions no longer share instructions:
- `xrepeat` implies F (`-march=rv32im_xrepeat` also turns on `f` and `zicsr`).
- Its instructions (custom-1 `0x2B`, custom-3 `0x7B`, custom-2 for REPEAT), all under
  `HasVendorXRepeat`, decoder table `XRepeat`. The mnemonics are `xr.*`; `ENCODINGS.md` calls
  them `vr.*`, which is wrong (confirmed by the hardware author).

  | Assembly | Encoding | Meaning |
  |---|---|---|
  | `xr.add/sll/slt/sltu/xor/srl/or/and/sub/sra fd, fs1, fs2` | custom-1, funct3 000, funct7 = op 0,1,2,3,4,5,6,7,8,0xD | VRF integer ALU |
  | `xr.mac fd, fs1, fs2, fs3` | custom-1, funct3 001, R4 | VRF integer `fd = fs1*fs2 + fs3` |
  | `xr.mv.vx fd, rs1` / `xr.mv.xv rd, fs1` | custom-1, funct3 010 / 011 | x → VRF / VRF → x |
  | `xr.lw fd, imm(rs1)` / `xr.sw fs2, imm(rs1)` | custom-1, funct3 100 (I) / 101 (S) | VRF load / store |
  | `xr.addi/slti/sltiu/xori/ori/andi fd, fs1, imm`, `xr.slli/srli/srai fd, fs1, shamt` | custom-3, funct3 as OP-IMM (`srai`: imm bit 10) | VRF integer ALU with immediate |
  | `xr.repeat mask, rs1, count` | custom-2, mask in bits 31:28, **rs1 = stride register, rs2 field = literal count 0..15** | repeat the previous instruction `count` more times |

  The VRF operands print as f registers in ABI form (`f8` → `fs0`, `f16` → `fa6`, …).
- `xrepeatint` keeps the original `xr.mac` (custom-0, x registers) and
  `xr.repeat mask, stride_reg, count_reg`, now under `HasVendorXRepeatInt` with its own decoder
  table `XRepeatInt`. The same mnemonic is accepted by whichever extension is enabled, and the
  wrong form is reported as needing the other one.
- The GPR-block code generation (Phases 2–7) is `xrepeatint`'s alone: the patterns use
  `HasVendorXRepeatInt`, and the C++ guard is `RISCVSubtarget::hasXRepeatGPRVectors()`
  (XRepeatInt and no V). Until the VRF code generation exists, `-march=rv32im_xrepeat` compiles to
  scalar code (with F), and `compare_asm.sh` builds its `base_xrepeat` column with
  `rv32im_xrepeatint`.

**Tests.**
- The Phase 2–7 tests are renamed `xrepeatint-*` and run only with `+xrepeatint`.
- `MC/RISCV/xrepeat-valid.s`: 35 instructions, with encodings computed by a separate script
  directly from `ENCODINGS.md` (not from LLVM's output). They are checked in both directions
  (assemble and disassemble), plus `flw`/`fmadd.s` being available through the implied F.
- `MC/RISCV/xrepeat-invalid.s`: out-of-range mask, count and immediates; x registers where VRF
  registers go and the other way round; XRepeatInt's forms; rv64.
- Unit test `ParseArchString.XRepeatImpliesF`.
- Validation: all 3688 RISC-V lit tests (CodeGen, MC, disassembler, vectorizers, unroll,
  cost model, PhaseOrdering, clang driver) and 642 TargetParser unit tests pass; every benchmark
  compiled with `xrepeatint` gives the same code as before.

## Phase 10 — `xrepeat`: vectors in blocks of F registers

**Goal.** The VRF equivalent of Phase 2: give the compiler vector types that live in the F
registers, so later phases can select instructions + REPEAT on them. Only F registers are used,
and they hold integer and float vectors alike.

### Registers — `RISCVRegisterInfo.td`
- `sub_xrf0`..`sub_xrf15`: element `I` of a block (always 32 bits, unlike the GPR `sub_xr*`
  indices whose size depends on XLEN). `RISCVRI::getXRFSubRegIndex(I)` in `RISCVRegisterInfo.h`
  maps an element number to its index (the generated enum values are not guaranteed to be
  consecutive).
- Register tuples `XRV_F0_F7`, `XRV_F8_F15`, `XRV_F16_F23`, `XRV_F24_F31` (8 wide) and
  `XRV_F0_F15`, `XRV_F16_F31` (16 wide). REPEAT replaces the low bits of a walking register
  number with the iteration, so a block must start at a multiple of its width; these are exactly
  the aligned ones (f0 is a normal register on this core, so it can start a block).
- Register classes `XRFVec8` = {`v8i32`, `v8f32`} and `XRFVec16` = {`v16i32`, `v16f32`}: one class
  per width with both element types, because the same F registers hold either. Allocation order:
  f0–f7, f24–f31, f16–f23, f8–f15 for 8 wide; f0–f15, f16–f31 for 16 wide (f8/f9/f18–f27 are
  callee-saved and f10–f17 carry arguments under the hard-float ABIs; under `ilp32` every F
  register is caller-saved). No pressure sets of their own (the FPR sets already count them).

### Legality and lowering — `RISCVISelLowering.cpp`
- `RISCVSubtarget::hasXRepeatVRFVectors()` = XRepeat and no V. It adds the four types to the two
  classes.
- Whole-vector loads, stores, copies, `undef` and `freeze` are native; every other operation is
  `Expand` (scalarized) until instruction selection is added. Bitcasts between the `i32` and `f32`
  vector of a width cost nothing (same registers).
- `isShuffleMaskLegal` is false and the RISC-V DAG combines skip these types (they assume RVV or
  scalars), as for the GPR blocks.
- **Calls:** these vectors are passed and returned as their elements
  (`getRegisterTypeForCallingConv`, `getNumRegistersForCallingConv`,
  `getVectorTypeBreakdownForCallingConv`), exactly as without XRepeat, so the ABI is unchanged —
  checked against plain `rv32imf` for `ilp32` and `ilp32f`. (The GPR blocks of `xrepeatint` still
  crash here; that frozen extension is left as it was.)
- **Store merging:** `canMergeStoresTo` refuses these types. Otherwise the DAG combiner merges
  eight scalar constant stores into one vector store that first loads the vector from the constant
  pool (seen in gepdot: 8 `flw` + 8 `fsw` instead of 3 `li` + 8 `sw`).

### Pseudos, copies, spills
- `PseudoXRFLoad8/16` and `PseudoXRFStore8/16` (`RISCVInstrInfoXRepeat.td`): a whole block as one
  `flw`/`fsw` per element (they move the 32 bits unchanged, so integers too), expanded in
  `RISCVExpandPseudoInsts.cpp` by the same routine as the GPR ones. Used for vector loads/stores
  (address used as is, no folded offset, so the last element's offset can't overflow) and for
  spills/reloads (`storeRegToStackSlot`/`loadRegFromStackSlot`;
  `eliminateFrameIndex` folds the slot offset only if `+28`/`+60` still fits in 12 bits).
- Copies (`copyPhysReg`): one `fmv.s` (`fsgnj.s`, a plain bit copy) per element.

Loads and stores become `flw`/`fsw` + REPEAT, and copies `xr.addi` + REPEAT, in the instruction
selection phase; spills keep one instruction per element (REPEAT needs a stride register, and
none is free when spilling).

### Cost model
`isXRepeatVRFVector` sends explicit vector code on these types to the generic cost model
(shuffles, casts, element insert/extract, scalarization), so it never reaches the RVV-only code.
The vectorizers still don't create these vectors (vector register width is 0 for `xrepeat`).

### ABI note
`xrepeat` implies F, and clang picks the default ABI from the extensions: `-march=rv32im_xrepeat`
alone now means `-mabi=ilp32f` (hard-float: floats in `fa0`–`fa7`). Pass `-mabi=ilp32` to keep
the soft-float ABI (the benchmark scripts do).

### Tests and validation
- `CodeGen/RISCV/xrepeat-vrf.ll`: loads/stores of all four types, scalarized `add`/`fadd`, element
  extracts, a 16-wide spill around a call, a block swap in a loop (copies), bitcasts, arguments,
  returns and a call, and the store-merging case; also run at `-O0` (fast register allocator).
- `Analysis/CostModel/RISCV/xrepeat-vrf.ll`: costs of explicit vector code on the four types.
- All 3691 RISC-V lit tests and 642 TargetParser unit tests pass; `xrepeatint` benchmark code is
  unchanged; every benchmark compiled with `rv32im_xrepeat` is identical to `rv32imf`.

## Phase 11 — `xrepeat`: instruction + REPEAT for VRF vector operations

**Goal.** The VRF equivalent of Phase 3: each operation on a block of F registers becomes one
instruction on the first element followed by `xr.repeat mask, stride, count` (count = 7 or 15).
Each source either walks (a vector, its mask bit set) or stays fixed (a splat: one F register).

| Operation (`v8i32`/`v16i32`, `v8f32`/`v16f32`) | Instruction + REPEAT |
|---|---|
| load / store | `flw` / `fsw`; stride 4 in an x register (`li`, shared and hoisted like any constant); offset folded, since the address advances by the stride. A stored splat is `fsw` with mask 0 (value fixed) |
| `add sub and or xor shl srl sra` | `xr.add` … `xr.sra`; with a constant splat that fits, `xr.addi xr.andi xr.ori xr.xori xr.slli xr.srli xr.srai` |
| `mul`, `add(mul a, b), c` | `xr.mac` (zero addend from `xr.mv.vx f, zero` for a plain multiply) |
| `fadd fsub fmul`, `fma` / `fmuladd` | `fadd.s fsub.s fmul.s fmadd.s` (dynamic rounding mode) |
| `fminnum fmaxnum`, `fminimumnum fmaximumnum` | `fmin.s fmax.s` (Phase 19) |
| splat on its own | `xr.addi vd, s, 0` with only rd walking |
| copy (`copyPhysReg`) | `xr.addi vd, vs, 0` |
| element at a constant index | the F register itself (`f32`), or `xr.mv.xv`/`xr.mv.vx` (`i32`) |
| non-constant `BUILD_VECTOR` | one insert per element; a constant vector is loaded from the constant pool |

Splats as operands: an `i32` scalar is moved in with `xr.mv.vx`, an `f32` is used where it is.
Spills keep one `flw`/`fsw` per element (no free x register for the stride while spilling).
Everything else (compares, selects, divisions, conversions, shuffles, reductions…) is still
scalarized.

### Pseudos — `RISCVInstrInfoXRepeat.td`
One generic scheme instead of one hand-written pseudo per operation:
`PseudoXRF_<Base>_<W>_<kinds>` has the operands of `Base` (the single-register instruction:
`XRV_ADD`, `FADD_S`, `FLW`…) in the same order, with each F-register source either a vector class
(`V`) or `FPR32` (`S`), plus a stride register for loads/stores. All combinations are generated
with `foreach`. A searchable table (`XRFRepeatPseudosTable` → `RISCV::getXRFRepeatPseudoInfo`)
maps each pseudo to its base instruction, width and whether it is a store / has a stride. One
expansion routine (`expandXRFRepeat` in `RISCVExpandPseudoInsts.cpp`) handles them all: the base
instruction on element 0 of every vector operand, then REPEAT whose mask has the bit of every
vector operand (rd = 0, rs1..rs3 = 1..3; a store's value is rs2). The REPEAT carries the vector
result as an implicit def and the sources as implicit uses (they are read on every step). It runs
after scheduling, so nothing gets between the instruction and its REPEAT.

### Register constraints, and what a 16-wide block can do
- Vector operands of one width are aligned blocks, so a vector result and a vector source are the
  same block or disjoint: with only vector sources no constraint is needed (in-place works).
- A fixed source must not be inside the result block (a later step would read it after an earlier
  step overwrote it). The result is tied to a vector source, or early-clobber if there is none.
  The one case that slips through: the fixed source is an element of the very vector the result
  is tied to, and the register coalescer gives it that element's register (`v - splat(v[3])`).
  The expansion detects it and falls back to one instruction per element, that element last
  (correct, just not a single REPEAT).
- **16 wide:** two 16-wide vectors take all 32 F registers. So a 16-wide instruction can read two
  vectors only if nothing else is live. Three-source forms with two or more vector sources are not
  generated; `fmuladd` is an `fmul` and an `fadd` at 16 wide (`isFMAFasterThanFMulAndFAdd`); a
  16-wide `mul` of two vectors (the MAC needs a zero addend) and a 16-wide `fma` with two vectors are
  scalarized (`lowerXRepeatVRFOperation`). At 8 wide (four blocks) every form fits.

### Lowering — `RISCVISelLowering.cpp`
- Legal: `add sub mul and or xor shl srl sra` on the `i32` types, `fadd fsub fmul fma` on the
  `f32` types.
- Custom (`lowerXRepeatVRFOperation`): `BUILD_VECTOR` (a splat becomes `RISCVISD::XRF_SPLAT`, a
  constant vector goes to the constant pool, anything else is a chain of inserts), element
  insert/extract at a constant index, and the 16-wide `mul`/`fma` above.
- TableGen note: `extractelt`/`insertelt` with an `i32` in a GPR trips TableGen's per-HwMode type
  check, so those patterns use `vector_extract`/`vector_insert`; `XRF_SPLAT`'s type profile is
  loose for the same reason.

### Tests and validation
- `CodeGen/RISCV/xrepeat-vrf-ops.ll` (new): loads/stores with offsets, integer ALU (register,
  immediate and splat forms), MAC, float ops, the 16-wide cases, splat stores, copies, a loop with
  a 16-wide accumulator, and the coalescer fallback; also run at `-O0`.
- `CodeGen/RISCV/xrepeat-vrf.ll` and `Analysis/CostModel/RISCV/xrepeat-vrf.ll` regenerated.
- The generated code assembles with `llvm-mc` to the same bytes as `llc -filetype=obj`, and
  disassembles with no unknown instructions.
- All RISC-V lit tests (3297) and the 642 TargetParser unit tests pass; `xrepeatint` benchmark
  code is unchanged; every benchmark with `rv32im_xrepeat` is still identical to `rv32imf` (the
  vectorizers don't create VRF vectors yet; that is the TTI phase).
- Not yet run on the emulator (it doesn't model the VRF core yet).

## Phase 12 — `xrepeat`: cost model and reductions; the vectorizers use the VRF

**Goal.** The VRF equivalent of Phase 4: the loop and SLP vectorizers produce 8- and 16-wide
`i32`/`float` vectors on the VRF core. Reductions (dot products) became necessary at the same
time, so they are here too.

### Reductions — `RISCVInstrInfoXRepeat.td`
REPEAT can keep the result field fixed while a source walks, and every step then accumulates
into the same register, in element order:

| Reduction | Code |
|---|---|
| `reduce.add <N x i32>` | `xr.add facc, facc, v0` + REPEAT mask 0100 (`facc` = 0 from `xr.mv.vx`, result back with `xr.mv.xv`) |
| `reduce.add(mul a, b)` | `xr.mac facc, a0, b0, facc` + REPEAT mask 0110 (one instruction pair for a whole dot product) |
| `reduce.fadd` (ordered or not) | `fadd.s facc, facc, v0` + REPEAT mask 0100: in element order, so an ordered (strict FP) sum is exact |

The pseudos (`PseudoXRF_*_RED*`) have a single-register result tied to the accumulator source. If
the register coalescer puts the accumulator in an element of the summed block, or a fixed source
in the result block (the Phase 11 case), the expansion now copies the clashing register into a
free F register (found with `LivePhysRegs`) and still emits a single burst (`fmv.s` before, and
for the accumulator one after). Only with no free F register does it fall back to one
instruction per element (an error for an ordered float sum, whose order that would change).

### Cost model — `RISCVTargetTransformInfo.{h,cpp}`
- `getRegisterBitWidth` = 512 (VF up to 16 for 32-bit elements); `getMinVectorRegisterBitWidth`
  = 256.
- `getXRFPairCost`: 2 per whole 8/16-wide block of **exactly** `i32` or `float` (an `<N x i16>`
  would be promoted to an `i32` block but loaded/stored element by element, so it has no cost
  here; nor do vectors that aren't whole blocks).
- Costed as instruction + REPEAT: loads and stores; `add sub and or xor shl lshr ashr`, `mul`;
  `fadd fsub fmul`, `fmuladd`/`fma`; add/fadd reductions (+2 for moving the accumulator in and
  out); splats (1: one move into an F register); bitcasts between the `i32` and `float` vectors
  (0). Everything else has an invalid throughput cost (`isUnsupportedXRepeatOp` now covers both
  cores), so the vectorizers don't pick it.
- **16 wide:** a `mul` of two vectors, `fma`, and a `mul`-add reduction are invalid; `fmuladd` costs
  an `fmul` + `fadd`.
- **Register pressure:** `getNumberOfRegisters(vector)` = 3 blocks of 8 (a 16-wide value counts as
  two, `getRegUsageForType`). The fourth block is left for what the vectorizer doesn't see but
  needs F registers: splatted scalars, a MAC's zero addend, accumulators. With it, the loop
  vectorizer's register-pressure check (on for RISC-V) rejects a 16-wide loop with two vector
  values live. Measured on axpy, 16 wide spilled 32 registers per iteration; 8 wide spills none.
  A loop with a single vector stream (e.g. `y[i] = y[i] * s + 1`, an ordered sum) still gets 16.
- SLP has no such check, so `getMaximumVF` caps it at 8 elements (16 scalars become two 8-wide
  trees).
- No interleaving (`getMaxInterleaveFactor` = 1), and the unrolling rules of the GPR version apply
  too: auto-vectorized loops are not unrolled, and small loops the vectorizer can turn into whole
  blocks are kept rolled for it (trip count a multiple of 8; `i32` or `float` loads/stores and
  `add sub mul and or xor` shifts `fadd fsub fmul fmuladd`).

### Two changes outside the cost model
- **Splats hoisted out of the loop** (the vectorizer puts the broadcast in the preheader) reached
  instruction selection as a whole vector block: a block wasted on a scalar, and a 16-wide `mul`
  that looked like two vectors and got scalarized. `isProfitableToSinkOperands` now sinks splat
  operands of the VRF vector operations next to their users (CodeGenPrepare), where they become
  fixed fields.
- **`RISCVCodeGenPrepare`** turns the scalar accumulator phi of an `fadd` reduction into a vector
  phi (good for RVV). On the VRF core that put the accumulator in a whole block and splatted it
  every iteration; it is now done only with V.
- Non-constant `i32` splats are bitcast to `f32` (`lowerXRepeatVRFOperation`), so a splat of a
  loaded value is an `flw` straight into the F register and a splat of a vector element is used
  in place. The integer patterns accept the splat in either register file.

### Results (`compare_asm.sh`, new `base_vrf` column = `-march=rv32im_xrepeat`)
Every benchmark kernel is vectorized at VF 8 (two vector streams, or one stream plus a vector
accumulator):

| bench | `xrepeatint` (GPR) | `xrepeat` (VRF) | spills: rv32im / xrepeatint / xrepeat |
|---|---|---|---|
| axpy | 17 insns per 8 (`sw` ×8) | 11 per 8 (`fsw` + REPEAT) | 2 / 12 / 2 |
| dotxvf, mlp, resnet8 dot loops | 9 per 8 | 9 per 8 (vector accumulator, `xr.mac` mask 1111) | 4 / 13 / 4; 3 / 13 / 4; 198 / 992 / 189 |
| gepdot | 8 | 8 (scalar `flw` straight into an F register) | 7 / 13 / 7 |
| bert_tiny | 23 loops, 238 insns | 24 loops, 320 insns (one more vectorized: a 16-wide table lookup, 84 insns per 16 against ~112 scalar) | 23 / 64 / 25 |

The REPEAT loops are as short as on the GPR core, stores are now repeated too, and since the
vectors no longer take up the GPRs, the scalar code around them spills like plain `rv32im`.

### Tests
- `Analysis/CostModel/RISCV/xrepeat-vrf.ll`: costs of every supported and unsupported case.
- `Transforms/LoopVectorize/RISCV/xrepeat-vrf.ll`: axpy (VF 8), dot (vector accumulator), a single
  stream (VF 16), float axpy (`fmuladd`), ordered float sum (VF 16, in loop), division and `i16`
  (scalar).
- `Transforms/SLPVectorizer/RISCV/xrepeat-vrf.ll`: 8 `i32`, 16 floats as two 8-wide trees, 4
  elements left scalar.
- `Transforms/LoopUnroll/RISCV/xrepeat-vrf-keep-small-loops.ll`.
- `CodeGen/RISCV/xrepeat-vrf-ops.ll`: reductions, dot products, the accumulator clash, a hoisted
  splat in a loop, an ordered sum in a loop.
- All 3305 RISC-V lit tests and the 642 TargetParser unit tests pass; the `rv32im`, `xrepeatint`
  and hand-written versions of every benchmark compile exactly as before.

### Known gaps (Phase 12)
- ~~Not run on the emulator yet~~: done in Phase 13; every benchmark and the differential kernel
  test pass on the VRF core.
- Straight-line code with several blocks (SLP) can still spill: the scheduler issues all the loads
  before the arithmetic, and four 8-wide blocks are all 32 F registers.
- Not supported (scalar or invalid cost): compares/selects, divisions, conversions, `i8`/`i16`,
  strided and interleaved accesses, min/max reductions, shuffles other than splats.
- Spills of a block are one `flw`/`fsw` per element.

## Phase 13 — Emulator of both cores; the VRF code runs

Until now the VRF code was only checked by lit tests and by reading the assembly. The Python
emulator used since Phase 4 lived in a temporary session directory and only knew the GPR core. It
is now in [`sim/`](sim/) and models both cores, so every compiled version can be run and checked.
Nothing in LLVM changed in this phase.

| File | What it is |
|---|---|
| `sim/rvsim.py` | The emulator. `--core int`: RV32IM + `xr.mac` (custom-0) + REPEAT with `stride = x[rs1]`, `count = x[rs2]` (the `xrepeatint` core, unchanged). `--core vrf`: RV32IMF + the `ENCODINGS.md` ISA. |
| `sim/rt.c`, `sim/link.ld`, `sim/sys/stdio.h` | Bare-metal runtime: `_start`, a `printf` over an MMIO byte port (`%d %u %x %s`, zero padding and width, no `-`), exit through `ecall`. |
| `sim/build.sh <core> <name> <src.c> <march> [flags]` | Compile, link with `ld.lld`, disassemble and run one program; output in `sim/out/` (ignored by git). |
| `sim/run_benchmarks.sh [bench…] [-- flags]` | The six benchmarks in the four versions of `compare_asm.sh`, with checksum check and the `bench_mark(0)..(1)` counts. With size flags (add `-DBENCH_CUSTOM_SIZES`) every version is compared to `base_rv32im` instead. |
| `sim/run_tests.sh [N…]` | Differential test: `sim/tests/kernels.c` built for scalar `rv32imf` and for `rv32im_xrepeat` must print the same hashes, for runtime sizes 1, 7, 8, 9, 16, 37, 64, 100, 128. |

### VRF core model

- The f registers are the VRF: 32 words with no hardwired zero, holding integers and floats.
- `xr.<alu>`/`xr.mac`/`xr.mv.vx`/`xr.mv.xv`/`xr.lw`/`xr.sw` (custom-1) and `xr.<alu>i` (custom-3)
  follow `ENCODINGS.md`, with the `xr.*` names.
- `xr.repeat`: mask in bits 31:28, `stride = x[rs1]` (signed), count = the rs2 field as a literal (bits 23:20).
  On extra step k, a walking register is the base register with its low bits replaced by k (a 4-,
  8- or 16-wide window from the count), as `windowed_reg_id` does. The address of a repeated load
  or store is `x[rs1] + imm + k·stride`. A load's destination always walks; a store's value walks
  only with `mask[2]`.
- Repeatable: `flw`, `fsw`, `xr.lw`, `xr.sw`, `xr.<alu>`, `xr.<alu>i`, `xr.mac`, `fadd.s`,
  `fsub.s`, `fmul.s`, `fmadd.s`, `fmin.s`, `fmax.s`.
- The steps run one after another, each reading its sources and then writing its result.
- The F extension is IEEE single precision: computed exactly and rounded once (`fmadd.s` is
  fused), all rounding modes, canonical NaN. `fflags` is not tracked.
- **Strict mode** (the default; `--lax` turns it off) makes an error of everything the compiler
  must never emit, instead of silently windowing it:
  - a walking register that isn't aligned to its window;
  - mask bits for operands the instruction doesn't have;
  - REPEAT of an ineligible instruction;
  - a REPEAT reached by a branch instead of from the instruction before it.

  None of these fired in any run below.

The integer core gives exactly the step counts recorded in earlier phases (mlp 18,462 / 10,143 /
10,225; gepdot 22,555; …), so the rewrite didn't change its model.

### Results: benchmarks (default sizes, golden checksums)

| Benchmark | rv32im | xrepeatint | **xrepeat (VRF)** | hand |
|---|---|---|---|---|
| mlp | 18,462 PASS | 10,143 PASS | **11,440 PASS** | 10,225 PASS |
| axpy | 9,012 PASS | 4,760 PASS | **4,885 PASS** | 5,885 PASS |
| dotxvf | 28,706 PASS | 15,400 PASS | **15,478 PASS** | 11,408 PASS |
| gepdot | 28,695 PASS | 22,555 PASS | **22,555 PASS** | 23,832 PASS |
| resnet8 | 1,894,912 PASS | 1,894,912 PASS | **1,894,912 PASS** | 3,010,011 PASS |
| bert_tiny | 179,038 PASS | 141,940 PASS | **143,435 PASS** | 157,301 PASS |

Steps in the `bench_mark(0)..(1)` window, REPEATed steps included. For resnet8 that window is only
the first stage (conv1, scalar in every compiled version), so its numbers don't compare the
vectorized code; its checksum covers the whole network.

Non-default sizes, compared with `base_rv32im`:

- mlp 67/21/16, 9/17/5, 16/24/33; axpy N=100; dotxvf NC=200; resnet8 IMG_SIZE=8; bert_tiny
  8/64/256: every compiled version (`xrepeatint` and VRF) gives the scalar checksum.
- The hand-written mlp differs at 67/21/16 and 9/17/5, because it assumes multiples of 8.

### Results: differential kernel test (`run_tests.sh`)

40 kernels at each of the 9 sizes. Covered:
- integer add/sub/logic/shifts (constant and variable), immediates, mul, scale, axpy, a·b+c,
  splat from memory, fill, in place;
- integer sum and dot-product reductions;
- constant 8/16/24/64-element loops and the gepdot shape;
- SLP at 8 and 16;
- a block live across a call (spilled and reloaded);
- float add/sub/mul, axpy, a·b+c, `fma`, scale;
- an ordered float sum (in loop and 64-wide);
- the 16-wide `y = y·s + 1` (int and float).

Every kernel except `k_press` (which the vectorizers keep scalar) is vectorized; this was checked in
the disassembly. **Every kernel gives bit-identical results to scalar `rv32imf` at every
size.**

One case was allowed to differ, and was reported separately until Phase 15 fused it: the float dot product written
`s += a[i] * b[i]` with the default `-ffp-contract=on` (`fdot~`).
- The front end emits `llvm.fmuladd`, which allows fusing but doesn't require it. Scalar code
  fuses (`fmadd.s`).
- The loop vectorizer turns the ordered `fmuladd` reduction into a vector `fmul` plus an in-order
  `fadd`, with no `contract` flag, so the IR asks for two roundings. The backend correctly may not
  fuse them back, and the result differs in the last bits.
- The same loop with contraction off (`fdot_nc`) matches exactly. This also confirms the in-order
  `fadd.s` + REPEAT reduction.

### Findings for later

- **Fused ordered float dot product** (done in Phase 15). If the loop vectorizer put `contract` on the `fmul` and the
  reduction it creates from an `fmuladd` (the original allowed exactly that fusion), the backend
  could select one `fmadd.s` + REPEAT (mask `0110`, accumulator fixed). That is bit-identical to
  scalar code and one burst shorter.
- **mlp's start vector** (fixed in Phase 14). The VRF mlp has the same 9-instruction hot loop as `xrepeatint`, but each
  neuron builds its start vector `<bias, 0, …, 0>` with one `xr.mv.vx`, six `fmv.s` and an 8-step
  block copy into the accumulator block. This is the likely source of most of the 1,297 extra steps. A zero splat burst plus one
  insert, built in place, would remove most of it.
- axpy/dotxvf/bert_tiny are within 1–3% of `xrepeatint` in steps, but take fewer instructions.

## Phase 14 — VRF core: integer sums and dot products accumulate in the loop

**Problem** (found in Phase 13). The loop vectorizer gave the VRF core's `i32` dot products a vector
accumulator. Every outer iteration then paid for two extra steps:
- building `<init, 0, …, 0>`: one `xr.mv.vx`, six `fmv.s` and an 8-step block copy;
- reducing the block after the loop: a zero reloaded from the stack, `xr.add` + REPEAT, `xr.mv.xv`.

In mlp that was about 25 steps per neuron, 1,266 steps in all. The inner loop itself was the same 9
instructions as on `xrepeatint`, but with `xr.mac` mask `1111` (8 separate accumulators).

**Cause.** `preferInLoopReduction` still tested `hasXRepeatVectors()`, which since Phase 8 means the
GPR core only. The VRF cost model added in Phase 12 never enabled it.

**Changes**

| File | Change | Why |
|---|---|---|
| `RISCVTargetTransformInfo.cpp`, `preferInLoopReduction` | true for `i32` add reductions on both cores | The vectorizer reduces each block in the loop and adds the result to a scalar: `acc += reduce.add(a*b)`. |
| `RISCVCodeGenPrepare.cpp`, new `keepXRFAccumulatorInFPR` | An `i32` phi updated only by `acc + reduce.add(…)` in its own block becomes a `float` phi, with bitcasts at both ends. Uses after the loop read a bitcast there, and LCSSA phis become `float` phis. | An `i32` phi lives in an x register, so the in-loop reduction alone gave 12 instructions per iteration (`fmv.s` of a zero, `xr.mac`, `xr.mv.xv`, `add`). As a `float`, the accumulator stays in its f register. |
| `RISCVISelLowering.{h,cpp}`, `shouldConvertPhiType` | false for float → integer on the VRF core | Generic CodeGenPrepare (`optimizePhiTypes`) otherwise turns that `float` phi straight back into an `i32` one. |
| `RISCVInstrInfoXRepeat.td` | `bitconvert(add(bitconvert FPR:$acc, vecreduce_add V))` → `xr.add` + REPEAT into `$acc` (mask `0100`); the same around `vecreduce_add(mul A, B)` → `xr.mac` + REPEAT (mask `0110`) | The sum goes straight into the accumulator register. |

The rewrite leaves alone any sum that is used inside the loop as well; it then goes through an x
register as before. That case is checked by the `loop_isum_used` test.

Result: mlp's neuron loop. The bias is loaded with `flw` directly into the accumulator and the result
stored with `fsw`, so the sum never visits an x register:

```
    flw     fa5, 0(a7)              # acc = bias[h]
.LBB0_2:
    flw     ft0, 0(t0)  ; xr.repeat 1, a3, 7
    flw     fs8, 0(t1)  ; xr.repeat 1, a3, 7
    addi    t1, t1, 32
    xr.mac  fa5, fs8, ft0, fa5 ; xr.repeat 6, zero, 7    # acc += Σ a[k]·b[k]
    addi    t0, t0, 32
    bne     t1, a5, .LBB0_2
    fsw     fa5, 128(a7)
```

**Tests**
- `CodeGen/RISCV/xrepeat-vrf-ops.ll`: `loop_isum` (8 wide, start value 5), `loop_dot` (result stored
  through an LCSSA phi), `loop_isum16`, and `loop_isum_used`, which is not rewritten.
- `Transforms/LoopVectorize/RISCV/xrepeat-vrf.ll`: `dot` now checks the in-loop scalar reduction.
- All 3781 tests pass in the RISC-V CodeGen, MC, CostModel, LoopVectorize, SLPVectorizer and
  InterleavedAccess suites, plus LoopUnroll, PhaseOrdering and CodeGenPrepare. The 642
  TargetParser unit tests pass too.

**Results** (emulator, every benchmark PASS; steps in the `bench_mark(0)..(1)` window):

| Benchmark | `xrepeatint` | VRF, Phase 13 | **VRF, Phase 14** | hand |
|---|---|---|---|---|
| mlp | 10,143 | 11,440 | **10,174** | 10,225 |
| axpy | 4,760 | 4,885 | 4,885 | 5,885 |
| dotxvf | 15,400 | 15,478 | **15,398** | 11,408 |
| gepdot | 22,555 | 22,555 | 22,555 | 23,832 |
| resnet8 (conv1 window) | 1,894,912 | 1,894,912 | 1,894,912 | 3,010,011 |
| bert_tiny | 141,940 | 143,435 | **141,248** | 157,301 |

- The differential kernel test still gives bit-identical results for all 40 kernels at all 9 sizes.
- `asm_compare/` was regenerated: every dot-product loop of `base_vrf` (mlp, dotxvf) is 9
  instructions with `xr.mac` mask `0110`, and nothing else changed per neuron or row.

**Caveat.** Steps are not cycles. Mask `0110` chains the 8 MACs through one register, while mask
`1111` (the old vector accumulator) gives 8 independent ones. If the real core overlaps independent
MACs, the old shape could be faster in cycles. Only the RTL simulator can decide; to go back, make
`preferInLoopReduction` return false for the VRF core.

## Phase 15 — VRF core: fused ordered float dot product

**Problem** (found in Phase 13). With the default `-ffp-contract=on`, `s += a[i] * b[i]` on floats
is `llvm.fmuladd`, which allows fusing but doesn't require it. Scalar code fuses it (`fmadd.s`). The
loop vectorizer turns the ordered `fmuladd` reduction into a vector `fmul` and an in-order
`vector.reduce.fadd`, keeping the `fmuladd`'s fast-math flags (none). That IR asks for two
roundings, so the backend correctly couldn't fuse them. The result was two bursts per block
(`fmul.s` + REPEAT, `fadd.s` + REPEAT) and a value a few bits off from the scalar loop.

The core can do the fused, in-order version directly: `fmadd.s acc, a, b, acc` + REPEAT mask `0110`.
That is exactly the scalar loop's sequence of fused operations, so it is bit-identical.

**Changes**

| File | Change | Why |
|---|---|---|
| `llvm/include/llvm/Analysis/TargetTransformInfo{,Impl}.h`, `llvm/lib/Analysis/TargetTransformInfo.cpp` | New hook `preferFusedFMulAddReduction()`, false by default | Generic code is unchanged for every other target. |
| `llvm/lib/Transforms/Vectorize/VPlanConstruction.cpp`, `VPlanTransforms.h`, `LoopVectorize.cpp` | `createInLoopReductionRecipes(…, ContractFMulAdd)`: when the hook is on, the `fmul` created from an `fmuladd` link and its reduction get `contract` | `llvm.fmuladd` permits exactly this fusion, so the flags only preserve permission the original IR had. |
| `RISCVTargetTransformInfo.h` | The hook returns true on the VRF core | |
| `RISCVInstrInfoXRepeat.td` | New pseudos `PseudoXRF_FMADD_S_<W>_RED_{VV,VS,SV}` (FPR32 result tied to the accumulator), and PatFrags `riscv_xrf_fmul_contract`/`riscv_xrf_seq_fadd_contract` that require `contract` on the node. Pattern: `seq_fadd(acc, fmul(A, B))`, both contract → `fmadd.s` + REPEAT into `acc` (`AddedComplexity` 2) | Without `contract` the unfused `fmul.s` + `fadd.s` form is kept. The 16-wide two-vector form doesn't fit in the f registers (Phase 11) and stays unfused; 16 wide with a splat factor is fused. |

The existing generic expansion handles the new pseudos with no change. The vector operands walk,
the tied accumulator is fixed, and the rounding-mode operand is carried along.

**Generated code** (`float s = 0; for (…) s += a[i] * b[i];`):

```
.LBB0_5:
    flw     ft0, 0(a6)  ; xr.repeat 1, a3, 7
    flw     fs8, 0(a7)  ; xr.repeat 1, a3, 7
    addi    a7, a7, 32
    fmadd.s fa5, ft0, fs8, fa5 ; xr.repeat 6, zero, 7     # s = fma(a[k], b[k], s), k = 0..7
    addi    a6, a6, 32
    bne     a7, a4, .LBB0_5
```

That is one burst less per block than before (`fmul.s` + REPEAT 7, `fadd.s` + REPEAT 4). With a
constant factor (`s += a[i] * k`) the loop runs 16 wide: `fmadd.s` mask `0010`, with `k` fixed.

**Tests**
- `Transforms/LoopVectorize/RISCV/xrepeat-vrf.ll`: `fdot` checks `fmul contract` and
  `call contract … @llvm.vector.reduce.fadd`.
- `CodeGen/RISCV/xrepeat-vrf-ops.ll`:
  - `fdot_contract`: `fmadd.s` mask `0110`;
  - `fdot_contract16s`: 16 wide with a splat, mask `0010`;
  - `fdot_nocontract`: still `fmul.s` + `fadd.s`.
- Lit: all 4,834 tests pass in RISC-V CodeGen, MC, CostModel, SLPVectorizer and InterleavedAccess,
  **all of `Transforms/LoopVectorize`** (every target, to confirm that nothing else changed),
  LoopUnroll, PhaseOrdering and CodeGenPrepare. The 68 VectorizeTests unit tests pass.
- Emulator: `sim/run_tests.sh` no longer has an "allowed to differ" kernel. `fdot` is now required to
  match, and **all 40 kernels are bit-identical to scalar `rv32imf` at all 9 sizes**.
- The benchmarks are integer code: `compare_asm.sh` gives byte-identical assembly in all four versions,
  so their emulator results are those of Phase 14.

## Phase 16 — VRF core: strided and interleaved accesses

Phase 6 gave the GPR core strided loads. This phase ports them to the VRF core, and goes further on
stores: the VRF core can repeat `fsw`, and the address advances by the stride register just as for
loads. So **strided stores and interleaved stores are single bursts too**, where the GPR core needs
one `sw` per element.

**Changes**

| File | Change |
|---|---|
| `RISCVInstrInfoXRepeat.td` | Nodes `XRF_STRIDED_LOAD`/`XRF_STRIDED_STORE` (type profile with no element-type constraint, for i32 and f32). Patterns reuse the `flw`/`fsw` pseudos with a stride register instead of `XRStride4`: a vector store walks the value (mask `0100`); a splat store is one fixed register (mask `0000`), as an f32 register or an i32 from an x register. |
| `RISCVISelLowering.cpp` | `vp.strided.load`/`vp.strided.store` are Custom for `v8i32`/`v8f32`/`v16i32`/`v16f32` and their masks `v8i1`/`v16i1`. `lowerXRepeatVRFOperation` keeps only the unmasked, full-length form, as on the GPR core. `isLegalStridedLoadStore` is true for those types with 4-byte alignment. |
| `RISCVInterleavedAccess.cpp` | `lowerXRepeatInterleavedLoad` now serves both cores; the field types come from `isXRepeatInterleaveFieldVT`. New `lowerXRepeatInterleavedStore` (VRF only): each field of a plain interleaved store, with every field present, becomes a `vp.strided.store` at `ptr + field·4` with stride `Factor·4`. |
| `RISCVTargetTransformInfo.cpp` | `getStridedMemoryOpCost` and `getMemIntrinsicInstrCost` cover VRF vectors (same cost as contiguous: 2 per block). `getIntrinsicInstrCost` passes the strided intrinsics through to them (the VRF branch used to return invalid, which only the cost-model printer saw, since SLP asks `getMemIntrinsicInstrCost` directly). `getInterleavedMemoryOpCost`: one pair per field, for loads and for full stores, with fields of exactly 8 or 16 elements. |

**Generated code**

```
# o[i] = m[16*i]*3 + m[16*i + 5]  (columns, stride 64; SLP)
    li      x12, 0x40
    flw     f0, 0(x11)  ; xr.repeat 1, x12, 7
    flw     f24, 20(x11); xr.repeat 1, x12, 7
    xr.mac  f24, f0, f15, f24 ; xr.repeat 0xb, x0, 7
    fsw     f24, 0(x10) ; xr.repeat 4, x11(=4), 7

# o[2i] = re[i] + 1; o[2i+1] = im[i] * 2   (interleaved store, factor 2)
    fsw     ft0, 0(t1)  ; xr.repeat 4, a5(=8), 7
    fsw     fs8, 4(t1)  ; xr.repeat 4, a5, 7

# d[7-i] = a[i] + 1   (reversed: strided store, stride -4)
    fsw     f0, 28(x10) ; xr.repeat 4, x11(=-4), 7
```

**Not covered:**
- **Column writes with a constant stride** (`m[64*i] = …`). SLP in LLVM 22 only forms strided stores
  for reversed contiguous stores. The loop vectorizer only forms interleave groups, and a store
  group with gaps would need a mask. Both are limits of the generic vectorizers, not of the core.
- A factor-4 interleaved load plus store (8 blocks live) exceeds the cost model's three blocks and
  stays scalar.
- Complex multiplication needs a float negation, which the VRF core doesn't vectorize yet.

**Tests**
- New `CodeGen/RISCV/xrepeat-vrf-strided.ll`:
  - strided loads (register, constant and negative strides; 8 and 16 wide; i32 and float);
  - a strided load feeding a dot product;
  - strided stores (register stride, reversed float, splat);
  - a factor-8 interleaved load;
  - a factor-2 float interleaved store;
  - a 4-element field, which isn't a block on this core and is left to the generic lowering.
- `Analysis/CostModel/RISCV/xrepeat-vrf.ll`: strided costs.
- `Transforms/LoopVectorize/RISCV/xrepeat-vrf.ll`: a factor-2 load group (`cmag`) and a factor-2
  float store group (`ilv`), both vectorized at VF 8.
- `Transforms/SLPVectorizer/RISCV/xrepeat-vrf.ll`: a column (strided load, stride 64) and reversed
  stores (strided store, −4).
- Lit: 5,672 tests pass in RISC-V CodeGen, MC and CostModel, **all** LoopVectorize, SLPVectorizer
  and InterleavedAccess tests for every target, LoopUnroll, PhaseOrdering and CodeGenPrepare.
- Emulator: `tests/kernels.c` gains `col`, `cmag`, `ilv`, `ilv4`, `ilvc` (constant field: mask
  `0000` store), `rev`, `fcmag` and `filv`. **All 48 kernels are bit-identical to scalar code at
  all 9 sizes.**

### Measurement correction: the kernel window

`run_benchmarks.sh` (Phase 13), and the emulator tables of earlier phases, reported steps from
`bench_mark(0)` to `bench_mark(1)`. `bench.h` defines the kernel window as **first to last mark**,
and two benchmarks have more than two marks:
- **resnet8** marks 0..5, and 0..1 is only conv1, which was already noted for it.
- **bert_tiny** marks 0..4, and 0..1 is **only the embeddings**. Its "steps" in the Phase 7, 13 and
  14 tables measured just that stage.

`run_benchmarks.sh` now reports the first-to-last window, with a column naming it. mlp, axpy,
dotxvf and gepdot mark only 0..1, so their numbers don't change.

**Results** (emulator, every checksum PASS, default sizes, full kernel window):

| Benchmark | rv32im | `xrepeatint` | VRF before (Phase 15) | **VRF now** | hand |
|---|---|---|---|---|---|
| mlp | 18,462 | 10,143 | 10,174 | **10,174** | 10,225 |
| axpy | 9,012 | 4,760 | 4,885 | **4,885** | 5,885 |
| dotxvf | 28,706 | 15,400 | 15,398 | **15,398** | 11,408 |
| gepdot | 28,695 | 22,555 | 22,555 | **22,555** | 23,832 |
| resnet8 (0..5) | 73,143,007 | 54,133,975 | 55,548,485 | **55,548,485** | 59,132,684 |
| bert_tiny (0..4) | 94,486,328 | 51,958,023 | 51,985,643 | **51,709,352** | 53,892,405 |

- **bert_tiny:** its two scores × V loops (a column of V, stride 512 bytes) went from 23 to 9
  instructions: 8 single `flw` became one `flw` + REPEAT, the same as on `xrepeatint`. Over the
  kernel that is −505,667 instructions (−2.9%) and −276,291 steps (−0.5%). Steps fall less, because
  8 `flw` and one `flw` + REPEAT are both 8 steps; the saving is the per-element address arithmetic.
  The VRF build is now the fastest bert_tiny.
- The "VRF before" column for resnet8 and bert_tiny comes from rerunning Phase 15's assembly (bert)
  or from unchanged assembly (resnet8). `compare_asm.sh` shows that only bert_tiny's VRF code
  changed in this phase.
- **New finding (fixed in Phase 17): resnet8.** Over the whole network, the VRF build takes 2.6%
  more steps than `xrepeatint` (55.5M vs 54.1M) and 45% more instructions (39.7M vs 27.5M). The old
  conv1-only window hid this.

## Phase 17 — resnet8: closing the gap to `xrepeatint`

**Starting point** (Phase 16, full kernel window): resnet8 on the VRF core took 55.5M steps against
54.1M on `xrepeatint` (+2.6%), and 39.7M instructions against 27.5M (+45%). Comparing the innermost
loops of the two builds (`asm_compare/summary.txt`) and profiling them on the emulator (new
`rvsim.py --profile FILE`: per-pc counts from `bench_mark(0)` on) showed four causes.

### 1. Chained reduction loops kept the x-register round trip

24 of the 29 dot-product loops were 12 instructions, not 9: `fmv.s` of a zero, then `xr.mac`, then
`xr.mv.xv` and `add`. resnet8's convolutions chain reduction loops: one loop's sum is the start
value of the next (`%acc2 = phi [%acc1, %mid], [%acc3, %l2]`). Phase 14's
`keepXRFAccumulatorInFPR` only accepted single-input (LCSSA) phis after the loop, so it gave up.

**Fix** (`RISCVCodeGenPrepare.cpp`): a phi with several inputs gets `bitcast %acc.next.f to i32` at
the end of the incoming block. When the next loop is rewritten too, the back-to-back bitcasts
cancel, and both loops share one f-register accumulator. Test: `chained_loops` in
`xrepeat-vrf-ops.ll`.

### 2. 16-channel dot products stayed scalar

The three convolutions with 16 input channels unrolled `for (i < 16) acc += w[i]*x[i]` into 16
scalar multiply-adds (67-instruction loops). SLP's horizontal reduction tried 16 wide, because its
width comes from the register width, 512 bits. A 16-wide multiply of two vectors had an **invalid**
cost, since it doesn't fit next to a zero addend (Phase 11). On an invalid cost SLP stops; it
retries narrower only after a valid but unprofitable one. The integer core starts at 8 (256-bit
registers) and succeeds.

**Fix** (`RISCVTargetTransformInfo.cpp`, `getArithmeticInstrCost`): that multiply costs
`4 × elements` (64), which is what its lowering emits: per element, two `xr.mv.xv`, a `mul` and an
`xr.mv.vx`. SLP then retries 8 wide and vectorizes the sum as two 8-wide halves. Tests: the cost
model's `mul <16 x i32>` is now 64; SLP test `dot16x`.

### 3. A sum of two products kept four blocks live

SLP emits `reduce.add(a0*b0 + a1*b1)`, so the sum is a fourth block, and four 8-wide blocks are
the whole register file.

**Fix** (`RISCVISelLowering.cpp` and `RISCVInstrInfoXRepeat.td`):
- New nodes `XRF_ADDRED(acc, v)` and `XRF_MACRED(acc, a, b)`: an f32 accumulator holding i32 bits,
  matched to the Phase 12 reduction pseudos.
- `combineXRFVecReduceAdd`: a `reduce.add` of a tree of single-use adds becomes a chain with one
  reduction per leaf. A product is `xr.mac` mask `0110` (8 wide only; at 16 wide, two vectors and
  the accumulator don't fit, so the product is reduced as a vector).
- `combineXRFAddReduce`: `x + reduce(…)` starts the chain from x's bits instead of 0, so an
  accumulator kept in an f register (item 1, Phase 14) flows through it.
- `shouldReassociateReduction` is false for VRF types, so the generic combine doesn't merge the
  reductions back.

Tests: `red_sum_of_products` and `loop_red_sum_of_products` in `xrepeat-vrf-ops.ll`.

### 4. The scheduler loaded every block first

Even with the chain, every block was loaded before the first MAC, and they spilled. There is no
scheduling model for the generic RISC-V CPU, so every load gets the default latency of 4. Bottom-up,
after placing the second MAC, its block loads aren't ready yet, so the only candidate is the first
MAC. Every load then ends up above both MACs (`Pick Bot ONLY1` in `-debug-only=machine-scheduler`).

**Fix** (`RISCVTargetMachine.cpp`): a scheduling-DAG mutation, `XRFBlockLoadLatencyMutation` (VRF
core only), gives the data edges out of XRepeat block loads latency 1, so register pressure decides
the order. Hiding load latency is never worth spilling a block (16 instructions). Also
(`RISCVInstrInfo.cpp`, `shouldClusterMemOps`): XRepeat block loads and stores are never clustered,
because pairing two blocks makes both live at once.

Result for one loop iteration of a 16-channel sum (`acc` kept in `fa5`):

```
    flw ft0, -32(a0) ; xr.repeat 1, a3, 7
    flw fs8, -32(a1) ; xr.repeat 1, a3, 7
    xr.mac fa5, ft0, fs8, fa5 ; xr.repeat 6, zero, 7
    flw ft0, 0(a0)   ; xr.repeat 1, a3, 7
    flw fs8, 0(a1)   ; xr.repeat 1, a3, 7
    xr.mac fa5, ft0, fs8, fa5 ; xr.repeat 6, zero, 7
```

### Results

All 24 runs PASS. Steps and instructions are over the full kernel window:

| Benchmark | rv32im | `xrepeatint` | VRF, Phase 16 | **VRF now** | hand |
|---|---|---|---|---|---|
| mlp | 18,462 | 10,143 | 10,174 | **10,174** | 10,225 |
| axpy | 9,012 | 4,760 | 4,885 | **4,885** | 5,885 |
| dotxvf | 28,706 | 15,400 | 15,398 | **15,398** | 11,408 |
| gepdot | 28,695 | 22,555 | 22,555 | **22,555** | 23,832 |
| resnet8 | 73,143,007 | 54,133,975 | 55,548,485 | **45,936,351** | 59,132,684 |
| bert_tiny | 94,486,328 | 51,958,023 | 51,709,352 | **51,709,352** | 53,892,405 |

- **resnet8:**
  - steps −17.3% over Phase 16, now **15.1% fewer than `xrepeatint`** and 22% fewer than the
    hand-written version;
  - instructions 39.7M → **19.3M** (−51%; `xrepeatint` 27.5M).
- gepdot and bert_tiny only changed instruction order; their step counts are identical.
- Lit: 5,672 tests pass, the same suites as Phase 16. The differential kernel test still gives
  bit-identical results for all 48 kernels at all 9 sizes.
- In the existing tests, a 16-wide float `fmul` + `fadd` no longer spills 32 registers, and some
  loads move next to their users.

### Remaining gap: LICM hoists block loads without regard to register pressure

Once the 16-channel sums are vectorized, the late full unroll unrolls the 3-iteration `kx` loop. The
late LICM then hoists the 3×3 pixels' 18 blocks out of the output-channel loop, because they don't
depend on the channel. 18 blocks are 144 f registers, so they are spilled once per output pixel and
reloaded per channel (551 spill and reload lines in resnet8, up from 198).

The integer core's IR has the same hoisting. In steps it costs little: reloading a block (8 `flw`)
takes as many steps as loading it from memory (`flw` + REPEAT), so the extra cost is only the spill
stores per pixel. Fixing it would need an alias-aware sinking of the loads back into the loop, or
LICM to account for register pressure; burst spills would cut instructions but not steps.

## Phase 18 — axpy and dotxvf

### axpy: a metric, not a gap

On the VRF core axpy took 4,885 steps against `xrepeatint`'s 4,760. Per iteration of 8 elements:

| | `xrepeatint` | VRF core |
|---|---|---|
| load x, load y, MAC | 9 + 9 + 9 | 9 + 9 + 9 |
| store y | 8 single `sw` = 8 | `fsw` + REPEAT = 1 + **1** + 7 = 9 |
| pointers, branch | 3 | 3 |
| total | 38 steps, 17 instructions | 39 steps, 11 instructions |

The whole difference is the REPEAT instruction of the store burst. The GPR core can't repeat
stores, so it writes them out. Under the "steps" metric a burst always costs one step more than the
same work written out as single instructions, because the REPEAT itself is counted. Whether a REPEAT
takes an issue cycle is a hardware question.

**Emulator:** a third count, `ops` = steps − REPEAT instructions (the element operations, i.e. the
work if a REPEAT costs nothing). `run_benchmarks.sh` shows it next to steps. axpy is
**4,385 ops on both cores**: the same work, with 35% fewer instructions on the VRF core. mlp's +31 is
one `fmv.x.w` per hidden neuron (32 of them): the sum stays in an f register and the ReLU is
integer code.

### dotxvf: fusing the row loops before the vectorizers

`y[u] = A[u]·x` for 4 rows. The early full unroll makes 4 `k` loops, which are vectorized one by one,
each reloading `x`: 15,398 steps against 11,408 for the hand-written version, which loads each block
of `x` once for all 4 rows. On the VRF core the 4 accumulators are single f registers (Phase 14), so a
fused loop needs only the `x` block plus one `A` block at a time.

Unroll-and-jam (`-enable-unroll-and-jam`) can't help: it runs after the loop vectorizer, and the
early full unroll has already removed the loop nest. An `opt` prototype at the vectorizer-start
extension point (LoopFuse, `indvars`, GVN, then `-force-vector-width=8`) gave 11,154 steps.

**Changes**

| File | Change |
|---|---|
| `RISCVTargetMachine.cpp`, `RISCVPassRegistry.def` | New function pass `riscv-xrepeat-loop-fusion`, added at the vectorizer-start extension point at O2 and above. For functions compiled for the VRF core only, it runs LoopFuse (fuses adjacent loops with the same trip count and no dependences) on the loops that **share a load** (see below), then, if anything was fused, `indvars` (one induction variable) and GVN (one load of `x[k]`). Hidden flag `-riscv-xrepeat-loop-fusion=false` for A/B runs. |
| `RISCVTargetTransformInfo.{h,cpp}` | Register estimate for the loop vectorizer: 5 units, with an 8-wide block 1 unit and a 16-wide one 3 (before: 3 units, 1 and 2). The vectorizer counts each loaded vector as live from the top of the body; the fused dotxvf loop counts 5, yet since Phase 17 the backend loads each `A` block right before its MAC and only 2 are live. A 16-wide loop with two vector values (6 units) is still rejected, as Phase 12 requires for axpy. |

The fused loop, the hand-written shape (one load of `x` in `ft0`, four MACs into four accumulators):

```
.LBB0_3:
    flw  fs8, 0(a0) ; xr.repeat 1, a5, 7      # x[k..k+7]
    flw  ft0, 0(a4) ; xr.repeat 1, a5, 7      # A0
    xr.mac fa5, ft0, fs8, fa5 ; xr.repeat 6, zero, 7
    flw  fs8, 0(a3) ; xr.repeat 1, a5, 7      # A1
    xr.mac fa4, ft0, fs8, fa4 ; xr.repeat 6, zero, 7
    ...                                       # A2, A3
    bne  a1, a6, .LBB0_3
```

**Only loops that share a load.** LoopFuse fuses every legal pair, with no profitability check.
Fusing everything cost resnet8 0.5%: its two convolutions with different kernels that read the same
image were fused as whole nests, and so was a pair of unrelated dot loops. That gives one loop body
with more live blocks but no shared load. The pass therefore picks the pairs itself:
- **Which pairs share a load** (`worthFusing`):
  - two innermost loops share a load when they load through pointers with the same `{start, step}`
    as functions of their loops (e.g. `x[k]` in each row loop; loads of loop-invariant addresses
    don't count);
  - two loop nests qualify when they have the same shape (one subloop per level) and their innermost
    loops share a load once each loop of the second nest is matched with its counterpart in the
    first. `equalModLoops` compares the address expressions modulo that matching: in bert_tiny's Q,
    K and V projections, three `dense` nests reading `hidden[t][k]`, each address depends on its own
    nest's `t` loop.
- **Blocking the other pairs:** every other loop gets a barrier in its preheader, a volatile load of
  a dummy stack slot. LoopFuse rejects a pair when it can't move a preheader instruction, and it
  never moves a volatile one. The barriers and the slot are deleted after fusion. The loops are put
  into loop-simplify form first, so the preheader holding the barrier is the one LoopFuse checks.
- **Cleanup only after fusion:** `indvars` and GVN run only if the number of loops went down. On
  unfused code GVN alone lengthened resnet8's live ranges into more spills.

Fusions: dotxvf its 4 row loops; bert_tiny the Q/K/V nests at all three levels plus one pair of dot
loops; resnet8, gepdot, mlp and axpy none (resnet8's assembly is byte-identical to Phase 17's).

**Tests**
- New `CodeGen/RISCV/xrepeat-vrf-loop-fusion.ll`:
  - four sibling row loops fused into one, with 4 accumulators and one load of `x`;
  - two loops over unrelated arrays kept apart;
  - two same-shaped nests reading the same `in[t][k]` fused at both levels;
  - unchanged without XRepeat, and with the flag off;
  - with `default<O2>`, the fused loop vectorized at VF 8 (5 block loads, 4 in-loop reductions).
- `CodeGen/RISCV/print-pipeline-passes.ll` now prints the pass by its registered name.
- Lit: all suites of Phase 17 plus `Transforms/LoopFusion` pass (5,707 tests).
  `llvm/test/Other` has 10 failures that exit with status 127: tools such as `llvm-profdata` and
  `llvm-bcanalyzer` aren't built here. They are unrelated.
- Emulator: all 48 kernels are bit-identical, and more of them vectorize (2,158 REPEATs at N=128,
  up from 1,962).

**Results** (all 24 runs PASS; full kernel window):

| Benchmark | `xrepeatint` steps / ops | VRF, Phase 17 steps | **VRF now steps / ops** | hand steps / ops |
|---|---|---|---|---|
| mlp | 10,143 / 9,183 | 10,174 | **10,174 / 9,214** | 10,225 / 9,265 |
| axpy | 4,760 / 4,385 | 4,885 | **4,885 / 4,385** | 5,885 / 5,385 |
| dotxvf | 15,400 / 13,864 | 15,398 | **11,154 / 10,002** | 11,408 / 10,256 |
| gepdot | 22,555 / 20,506 | 22,555 | **22,555 / 20,505** | 23,832 / 21,656 |
| resnet8 | 54,133,975 / 50,323,431 | 45,936,351 | **45,936,351 / 42,125,807** | 59,132,684 / 54,413,852 |
| bert_tiny | 51,958,023 / 47,014,407 | 51,709,352 | **48,678,563 / 43,994,707** | 53,892,405 / 48,961,749 |

- **dotxvf:** −27.6% steps, **below the hand-written version** (11,154 vs 11,408).
- **bert_tiny:** −5.9%, from fusing the Q/K/V projections, which load each block of `hidden`
  once for three dot products. It now takes 6.3% fewer steps than `xrepeatint` and 9.7% fewer than
  the hand-written version.
- **resnet8:** unchanged. With every legal pair fused it was +0.5% (46,167,100); fusing only loops
  that share a load leaves it byte-identical to Phase 17. bert_tiny with every pair fused was
  48,656,545, so the selective rule keeps 99% of that gain.
- The VRF core now takes the fewest steps of all four versions on dotxvf, gepdot (tied), resnet8 and
  bert_tiny. On axpy it is level with `xrepeatint` in ops, and on mlp +31 ops.

## Phase 19 — fmin.s / fmax.s

The hand-written f32 kernels clamp and ReLU their outputs with `fmax.s`/`fmin.s` + REPEAT (mask
`1011`, a vector and one fixed register), and they pass their checksums on the RTL, so the core
repeats these two instructions. `fsgnj*.s` + REPEAT is never used by the hand code and stays out
until it is confirmed.

### Instruction selection

| File | Change |
|---|---|
| `RISCVInstrInfoXRepeat.td` | `PseudoXRF_FMIN_S_<W>_<VV,VS,SV>` / `FMAX_S`, like `FADD_S` but without the rounding mode operand; patterns for `fminnum`/`fmaxnum` and `fminimumnum`/`fmaximumnum` (the same mapping as scalar `fmin.s`/`fmax.s` in `RISCVInstrInfoF.td`). |
| `RISCVISelLowering.cpp` | `FMINNUM FMAXNUM FMINIMUMNUM FMAXIMUMNUM` legal for `v8f32`/`v16f32` (they were expanded, i.e. scalarized). |
| `RISCVTargetTransformInfo.cpp` | `minnum maxnum minimumnum maximumnum` cost one burst (they were invalid, so no vectorizer used them). |
| `sim/rvsim.py` | `fmin.s`/`fmax.s` repeatable. |

### Selects that are a min/max

The benchmarks never call `fmaxf`: a ReLU or a clamp is a compare and a select, which the
vectorizers can't turn into a burst. `RISCVXRepeatFMinMaxPass` (vectorizer start, VRF core only,
before the loop fusion) replaces the selects that are a min/max of a value and a constant with
`llvm.minimumnum`/`maximumnum`. These are IEEE 754-2019 minimumNumber/maximumNumber: a NaN
operand gives the other one, and −0.0 < +0.0, which is exactly what `fmin.s`/`fmax.s` do. The rule
is `RISCV::getXRepeatFMinMax`:

- **Exactly** (no fast-math flags), with C a constant that is not a NaN:

  | select | is | unless |
  |---|---|---|
  | `x > C ? x : C` | maximumNumber(x, C) | C = −0.0 (x = +0.0 gives −0.0) |
  | `x >= C ? x : C` | maximumNumber(x, C) | C = +0.0 (x = −0.0 gives −0.0) |
  | `x < C ? x : C` | minimumNumber(x, C) | C = +0.0 |
  | `x <= C ? x : C` | minimumNumber(x, C) | C = −0.0 |

  The compare must be ordered, so that a NaN x selects C; C on the true side is the same with the
  inverse (unordered) compare. `x < C ? C : x` is **not** a max: a NaN x selects x. This is the
  form of resnet8's ReLU and of `clamp8` in bert_tiny, so without fast-math they stay selects.
- **With the compare's fast-math flags**: `nnan` allows any compare and either side; `nsz` drops
  the conditions on C's sign; with both, the clamp InstCombine makes of two selects,
  `x > C ? min(x, C2) : C` with C2 ≥ C, is max(min(x, C2), C). Clang puts the flags on the `fcmp`,
  not on the `select`, which is why InstCombine's own select → `minnum`/`maxnum` often doesn't fire
  under `-ffast-math`.

`isXRepeatVectorizableSmallLoop` (keep-small-loops, Phase 7) accepts these selects and the min/max
intrinsics, so a small loop with a clamp stays rolled like one with an `fadd`.

| C code (`a[i]` → `b[i]`) | default | `-ffinite-math-only` | `-ffast-math` |
|---|---|---|---|
| `a > 0 ? a : 0` | `fmax.s` + REPEAT | `fmax.s` + REPEAT | `fmax.s` + REPEAT |
| `a < 127 ? a : 127` | `fmin.s` + REPEAT | `fmin.s` + REPEAT | `fmin.s` + REPEAT |
| both bounds of a clamp | `fmax.s`, `fmin.s` + REPEAT | `fmax.s`, `fmin.s` + REPEAT | `fmin.s`, `fmax.s` + REPEAT |
| `a < 0 ? 0 : a` | compare + select (scalar) | scalar (x = −0.0) | `fmax.s` + REPEAT |
| `a > -0.0 ? a : -0.0` | compare + select (scalar) | scalar | `fmax.s` + REPEAT |

### Tests

- `CodeGen/RISCV/xrepeat-vrf-minmax.ll`: every form, 8 and 16 wide.
- `CodeGen/RISCV/xrepeat-vrf-fminmax.ll`: the pass, each rule and its counter-examples; without
  XRepeat nothing changes.
- `LoopVectorize/RISCV/xrepeat-vrf.ll` (`@clamp`) and `LoopUnroll/RISCV/xrepeat-vrf-keep-small-loops.ll`
  (`@relu_tc8`, `@relu_nan_tc8`).
- `sim/tests/kernels.c`: 9 min/max kernels over NaN, ±0.0, ±∞, the bounds and their neighbours.
  The reference is plain `rv32imf`, where the pass doesn't run, so it checks the exact rules bit
  for bit against compare + select. All 57 kernels give the same hashes at every N.

### Effect on the benchmarks

None yet, by design. The exact forms only occur in mlp's ReLU, and every clamp in the benchmarks
sits in a per-output epilogue, after a reduction loop, so there is no vector to clamp until the
outputs are computed eight at a time (unroll-and-jam).

Known limitation, from Phase 7: when the pointers may alias, a kept small loop is not vectorized
either, because the loop vectorizer emits no runtime alias check for a trip count below 16
("Runtime ptr check is required with -Os/-Oz"). It stays a rolled scalar loop, slower than the
unrolled one; this applies to an `fadd` loop just the same.

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

# The assembler encodes the new instructions (VRF core, and the original GPR core)
echo 'xr.mac f8, f16, f24, f8' | build-22/bin/llvm-mc -triple=riscv32 -mattr=+xrepeat -show-encoding
echo 'xr.mac x5, x16, x24, x5' | build-22/bin/llvm-mc -triple=riscv32 -mattr=+xrepeatint -show-encoding

# XRepeat and XRepeatInt regression tests (all should pass)
build-22/bin/llvm-lit -v llvm/test/MC/RISCV/xrepeat*.s llvm/test/CodeGen/RISCV/xrepeat*.ll \
  llvm/test/Analysis/CostModel/RISCV/xrepeat*.ll llvm/test/Transforms/*/RISCV/xrepeat*.ll

# Assembly of the benchmarks, from the repo root (writes .custom_repeat_inst/asm_compare/)
.custom_repeat_inst/compare_asm.sh
grep -c xr.repeat .custom_repeat_inst/asm_compare/mlp/base_xrepeat.dis   # > 0
```

Use it with `--target=riscv32-unknown-elf` and `-march=rv32im_xrepeat` (the VRF core, Phases 9–18)
or `-march=rv32im_xrepeatint` (the original GPR core, frozen at Phase 8). Without either in
`-march`, the compiler behaves like the original, unmodified LLVM 22. See the next section for a
worked example.

After editing any `.td` or `.cpp` file, rebuild `clang` too, not only `llc`. `clang` contains
its own copy of the back end, and a stale `clang` once produced a false test failure.

## Compiling your own code for XRepeat

Write plain C; there are no intrinsics or pragmas. The vectorizers decide what goes into
REPEAT bursts. A small example, `dot.c`:

```c
#include <stdio.h>

#define N 256
int a[N], b[N];
float x[N], y[N];

// y = alpha * x + y  (float: flw / fmadd.s / fsw + REPEAT)
void saxpy(float alpha) {
    for (int i = 0; i < N; i++) y[i] = alpha * x[i] + y[i];
}

// integer dot product (one xr.mac + REPEAT per 8 elements)
int dot(void) {
    int s = 0;
    for (int i = 0; i < N; i++) s += a[i] * b[i];
    return s;
}

int main(void) {
    for (int i = 0; i < N; i++) { a[i] = i % 7 - 3; b[i] = i % 5; x[i] = i * 0.5f; y[i] = 1.0f; }
    saxpy(2.0f);
    printf("dot = %d, y[10] = %d\n", dot(), (int) y[10]);
    return 0;
}
```

### Compile

From the repo root, with `B=build-22/bin`:

```bash
# Assembly for the VRF core
$B/clang --target=riscv32-unknown-elf -march=rv32im_xrepeat -mabi=ilp32 -O2 \
    -ffreestanding -isystem .custom_repeat_inst/sim/sys -S dot.c -o dot.s

# Object file, and its disassembly with the xr.* names
$B/clang --target=riscv32-unknown-elf -march=rv32im_xrepeat -mabi=ilp32 -O2 \
    -ffreestanding -isystem .custom_repeat_inst/sim/sys -c dot.c -o dot.o
$B/llvm-objdump -d --mattr=+m,+f,+xrepeat dot.o
```

The loop in `saxpy` becomes:

```
    flw     ft0, 0(a1)  ; xr.repeat 1, a2, 7     # x[i..i+7]   (a2 = 4, the stride)
    flw     fs8, 0(a0)  ; xr.repeat 1, a2, 7     # y[i..i+7]
    fmadd.s fs8, fa5, ft0, fs8 ; xr.repeat 13, zero, 7   # y = alpha * x + y, alpha fixed in fa5
    fsw     fs8, 0(a0)  ; xr.repeat 4, a2, 7     # store y[i..i+7]
```

The flags:

| Flag | Why |
|---|---|
| `--target=riscv32-unknown-elf` | Bare-metal RV32. |
| `-march=rv32im_xrepeat` | The VRF core. XRepeat implies F: vectors live in the f registers, and float code uses RV32F. Use `rv32im_xrepeatint` for the original GPR core. |
| `-mabi=ilp32` | Without it, `xrepeat` (which implies F) makes clang choose `ilp32f`, the single-float ABI, and the object no longer links with code built for plain `rv32im`, such as `sim/rt.c`. If everything is built with F, `ilp32f` is fine. |
| `-O2` (or `-O3`) | The loop and SLP vectorizers, and this extension's loop fusion, only run from `-O2`. At `-O1`/`-O0` the code stays scalar. |
| `-ffreestanding -isystem .custom_repeat_inst/sim/sys` | There is no RISC-V libc on this machine. `sim/sys/stdio.h` only declares `printf`, which `sim/rt.c` implements for the emulator. |

### See what was vectorized, and why

```bash
$B/clang ... -O2 -S dot.c -o /dev/null -Rpass=loop-vectorize -Rpass=slp-vectorizer \
    -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize -Rpass=loop-fusion
# dot.c:9:5:  remark: vectorized loop (vectorization width: 8, interleaved count: 1)
# dot.c:15:5: remark: vectorized loop (vectorization width: 8, interleaved count: 1)
```

A loop the core can't do in one burst gets "the cost-model indicates that vectorization is not
beneficial" or "Recipe with invalid costs". Examples are compares and selects, divisions,
conversions, and `i8`/`i16` data; see the known gaps of Phases 12 and 16.

### Run it on the emulator

`sim/build.sh <core> <name> <src.c> <march> [flags]` compiles, links with `sim/rt.c` and
`sim/link.ld`, and runs the program (output in `sim/out/`):

```bash
.custom_repeat_inst/sim/build.sh vrf dot_example dot.c rv32im_xrepeat
# dot = -13, y[10] = 11
# [sim] total: 9180 instructions, 10748 steps, 224 REPEATs

.custom_repeat_inst/sim/build.sh vrf dot_ref dot.c rv32imf      # scalar reference
# dot = -13, y[10] = 11
# [sim] total: 12121 instructions, 12121 steps, 0 REPEATs
```

The core must match `-march`: `vrf` for `rv32im_xrepeat` (and for any F code), `int` for
`rv32im_xrepeatint` and `rv32im`. A program can time a region by calling
`bench_mark(0)` … `bench_mark(1)` from `base_mlp/bench.h`; the emulator then also prints the steps
in that window.

### Switches for experiments

| Option | Effect |
|---|---|
| `-fno-vectorize -fno-slp-vectorize` | No vectorization: scalar code, even with XRepeat. |
| `-mllvm -riscv-xrepeat-loop-fusion=false` | No fusion of loops that share a load before the vectorizers (Phase 18). |
| `-mllvm -riscv-xrepeat-fminmax=false` | Float clamps/ReLUs written as compare + select stay selects instead of becoming `fmin.s`/`fmax.s` (Phase 19). |
| `-mllvm -riscv-xrepeat-keep-small-loops=false` | Small constant-trip-count loops are fully unrolled as usual, instead of kept rolled for the vectorizer (Phase 7). |
| `-mllvm -force-vector-width=8` (or 16) | Force a vectorization factor, ignoring the cost model. Only for experiments; it can spill. |

## How to rebuild and re-run everything

```bash
# Build (from the repo root)
ninja -C build-22 clang llc opt llvm-mc llvm-objdump

# XRepeat and XRepeatInt tests only
build-22/bin/llvm-lit -v llvm/test/MC/RISCV/xrepeat*.s llvm/test/CodeGen/RISCV/xrepeat*.ll \
  llvm/test/Analysis/CostModel/RISCV/xrepeat*.ll llvm/test/Transforms/*/RISCV/xrepeat*.ll

# All RISC-V suites touched by these changes
build-22/bin/llvm-lit -q llvm/test/CodeGen/RISCV llvm/test/MC/RISCV \
  llvm/test/Analysis/CostModel/RISCV llvm/test/Transforms/LoopVectorize/RISCV \
  llvm/test/Transforms/SLPVectorizer/RISCV llvm/test/Transforms/InterleavedAccess/RISCV \
  llvm/test/Transforms/LoopUnroll llvm/test/Transforms/PhaseOrdering

# Assembly of every benchmark (plain/rv32im, plain/xrepeatint, hand) -> asm_compare/
.custom_repeat_inst/compare_asm.sh            # extra clang flags are passed through, e.g. -DNC=256

# Run on the emulator (Phase 13): benchmarks in all four versions, and the VRF differential test
.custom_repeat_inst/sim/run_benchmarks.sh                 # all six, default sizes (~10 min, resnet8 dominates)
.custom_repeat_inst/sim/run_benchmarks.sh mlp -- -DINPUT_SIZE=67 -DBENCH_CUSTOM_SIZES
.custom_repeat_inst/sim/run_tests.sh                      # ~1 min
.custom_repeat_inst/sim/build.sh vrf mine my.c rv32im_xrepeat   # any single program

# A/B: the Phase 7 unroll rule off
build-22/bin/clang ... -mllvm -riscv-xrepeat-keep-small-loops=false

# Regenerate autogenerated checks after an intended codegen change
python3 llvm/utils/update_llc_test_checks.py --llc-binary build-22/bin/llc <test.ll>
python3 llvm/utils/update_analyze_test_checks.py --opt-binary build-22/bin/opt <test.ll>

# See what the vectorizer decided, and why
build-22/bin/clang --target=riscv32-unknown-elf -march=rv32im_xrepeatint -O2 -S main_mlp.c \
  -Rpass=loop-vectorize -Rpass-missed=loop-vectorize -Rpass-analysis=loop-vectorize
```

(Compiling the benchmark needs a `stdio.h`; without a RISC-V libc, a one-line stub declaring
`printf` plus `-ffreestanding -isystem <dir>` is enough to generate assembly.)
