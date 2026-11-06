# Custom Instruction Encodings

This document covers only the **non-standard, custom** instructions `repeat_rv` defines — the
four RISC-V custom opcode slots (`custom-0`/`custom-1`/`custom-2`/`custom-3`) plus the second
register file (VRF) they largely exist to address. Standard RISC-V encodings (RV32I, M, A, Zicsr,
Zifencei, and the F extension, including `FLW`/`FSW`/`FMADD`-family) are **not** covered here —
see the official RISC-V ISA manual for those. Ground truth for everything below is
`rtl/repeat_rv_pkg.sv` (opcode/field enums), `rtl/decode/decoder.sv` (decode logic) and
`rvtarget.h` (the C/assembler macros software actually uses).

All instructions here are encoded as standard RISC-V instruction *shapes* (R/I/S/R4-type) on one
of the four opcodes RISC-V reserves for custom use, so any ground-truth assembler
(`riscv64-unknown-elf-as`) can emit them via `.insn` directives — no custom toolchain patches are
needed, only the `rvtarget.h` macros that wrap the raw `.insn` syntax.

## The second register file (VRF)

`vreg_file.sv` is a second, 32×32-bit register file, structurally identical to the classic
register file (`reg_file.sv`) except that **it has no hardwired `x0`** — register 0 is an
ordinary, writable VRF register. It holds both plain integer values (for the custom `vr.*`
integer family below) and, now that the core has FP32 support, the RV32F register operands —
the F extension's "float registers" are simply VRF registers, not a third file.

Every instruction below that reads/writes the VRF does so through a plain 0–31 register *number*
token-pasted the same way the classic RF's `rd`/`rs1`/`rs2` fields are — there is no dedicated
assembler register namespace (no `v0` mnemonic). The field itself doesn't indicate which file it
addresses; `decoder.sv`'s `is_vrf_rd`/`is_vrf_rs1`/`is_vrf_rs2`/`is_vrf_rs3` control bits are what
actually route a given operand to the VRF instead of the classic RF, instruction-by-instruction
(see the per-instruction tables below). Getting a macro argument's file wrong is not caught by the
assembler — it just decodes as whatever that bit pattern happens to mean.

## Opcode map

| Opcode (binary) | Opcode (hex) | Name | Encodes |
|---|---|---|---|
| `0101011` | `0x2B` | `custom-1` | `vr.*` reg-reg family (`vr.alu`, `vr.mac`, `vr.mv.vx`, `vr.mv.xv`, `vr.lw`, `vr.sw`) |
| `1011011` | `0x5B` | `custom-2` | `repeat` (repeat-burst trailer instruction) |
| `1111011` | `0x7B` | `custom-3` | `vr.*i` reg-imm family |

`custom-0` (`0x0B`) is unused — it briefly carried a legacy, pre-VRF `mac` instruction (`MAC_INSN`,
operating on the classic register file only) that has since been fully retired now that `vr.mac`
(below) gives the VRF its own, superseding equivalent; `custom-0` now traps as an illegal
instruction like any other undefined opcode.

---

## 1. `repeat` — `custom-2` (`0x5B`)

**`REPEAT_INSN(mask, stride_reg, count)`** (`rvtarget.h`):
```c
#define REPEAT_INSN(mask, stride_reg, count) .insn r 0x5B, 0, ((mask) << 3), x0, stride_reg, x ## count
```

R-type layout:

| Bits | Field | Meaning |
|---|---|---|
| `[31:25]` funct7 | `{mask[3:0], 3'b000}` | `mask[3:0]` in funct7`[3:0]` (funct7`[6:4]` reserved, 0) |
| `[24:20]` rs2 | `stride_reg` | real register, holds the runtime **stride** value |
| `[19:15]` rs1 | `x<count>` | **not** a register read — `count` is encoded as a literal register *number* (e.g. `x3`), reinterpreted by `decoder.sv`/the issue modules as a 4-bit immediate (`CORE_CLAIM_BITS'(instr.rs1)` is never read as a GPR for this instruction) |
| `[14:12]` funct3 | `000` | unused |
| `[11:7]` rd | `x0` | unused |
| `[6:0]` opcode | `0x5B` | `custom-2` |

A `repeat` instruction is a **trailer**: it must immediately follow the instruction whose burst it
extends (the "base dispatch"), and that base instruction must itself be repeat-*eligible* (see
below). The base dispatch always executes once, unwindowed, using its own raw `rd`/`rs1`/`rs2`/
`rs3` fields; `repeat`'s own `count` says how many **additional** windowed iterations follow —
total dispatches = `1 + count`.

### `mask` bits

`mask[3:0]`, one bit per R4-type operand slot, says whether that operand **walks** (windowed via
`windowed_reg_id`, a distinct register each iteration) or stays **fixed** (broadcast — the exact
same register every iteration):

| Bit | Operand | Walking (`1`) | Fixed (`0`) |
|---|---|---|---|
| 0 | `rd` | N distinct destinations | one destination, written N times (e.g. an accumulating `mac`) |
| 1 | `rs1` | N distinct sources | one fixed source |
| 2 | `rs2` | N distinct sources | one fixed source (broadcast store value, or a fixed second operand) |
| 3 | `rs3` | N distinct sources | one fixed source (e.g. `mac`'s accumulator) |

Not every bit applies to every repeat-eligible instruction — only the operands that instruction
actually has are meaningful (e.g. a load has no `rs3`; `mask[0]` for a repeated **load** is not
even read, since a load's destination always walks unconditionally — a non-walking load
destination has no sensible use). See each instruction's own entry below for which bits apply.

### Repeat eligibility

Only specific instructions can be followed by a `repeat` trailer, each handled by its own
pipeline's issue module (`lsu_issue_module.sv`, `compute_issue_module.sv`, `ctrl_issue_module.sv`):

- **LSU pipe**: plain word load (`LW`/`VR_LW`/`FLW`, any instruction with `mem_op==MEM_LW` and
  `is_vrf_rd`) — `rd` always walks. Plain word store (`SW`/`VR_SW`/`FSW`, `mem_op==MEM_SW` and
  `is_vrf_rs2`) — `rs2` walking is `mask[2]`-controlled (broadcast vs. walking store value); the
  address always advances by `stride` each iteration either way.
- **Compute pipe**: `mac`/`vr.mac` and `vr.alu` (and the FP equivalents sharing the same dispatch
  shape) — `rd`/`rs1`/`rs2`/`rs3` walking is independently `mask`-controlled per the table above.
- **Ctrl pipe**: `vr.alu`-family/ALU-redirected ops issued on that pipe — same `mask`-controlled
  walking for `rd`/`rs1`/`rs2`.

A classic-RF-only (non-VRF) destination cannot repeat at all — ordinary scalar RV32I/M instructions
are never repeat-eligible.

### Windowing (`windowed_reg_id`)

```systemverilog
function automatic rv_reg_id_t windowed_reg_id(rv_reg_id_t base, logic[3:0] iter, logic[3:0] count);
    if (count <= 3)      return {base[4:2], iter[1:0]};
    else if (count <= 7) return {base[4:3], iter[2:0]};
    else                 return {base[4],   iter[3:0]};
endfunction
```

This **replaces** the base register's own low bits with the iteration number directly — it is not
`base + iter` arithmetic. The window width is inferred purely from the burst's total `count`
(`1 + count` total values): `count<=3` picks a 4-register-wide window (8 such windows across
x0–x31), `count<=7` an 8-wide window (4 windows), otherwise a 16-wide window (2 windows: x0–15,
x16–31).

**Consequence**: a base register only extends cleanly into `count` consecutive registers when it
already sits at slot 0 of its own naturally-aligned window — i.e. `base` is a multiple of 4 (for
`count<=3`), 8 (for `count<=7`), or 16 (otherwise). A misaligned base silently wraps back onto
nearby/overlapping registers instead of trapping. For example `REPEAT_INSN(mask, stride, 3)`
after a base dispatch at VRF register 16 (16 mod 4 == 0) produces registers 16 (base, unwindowed),
17, 18, 19 — four total values.

---

## 2. `vr.*` reg-reg family — `custom-1` (`0x2B`)

Every "v"-prefixed operand (`vd`/`vs1`/`vs2`/`vs3`) below is VRF-addressed; a bare `rs1`/`rd` is a
real classic-RF register. `funct3` selects which instruction this is.

| funct3 | Instruction | Shape | Semantics |
|---|---|---|---|
| `000` | `vr.alu` | R-type | `VRF[vd] = VRF[vs1] OP VRF[vs2]` |
| `001` | `vr.mac` | R4-type | `VRF[vd] = VRF[vs1]*VRF[vs2] + VRF[vs3]` |
| `010` | `vr.mv.vx` | R-type | `VRF[vd] = x[rs1]` |
| `011` | `vr.mv.xv` | R-type | `x[rd] = VRF[vs1]` |
| `100` | `vr.lw` | I-type | `VRF[vd] = MEM[x[rs1] + imm]` |
| `101` | `vr.sw` | S-type | `MEM[x[rs1] + imm] = VRF[vs2]` |

### `vr.alu vd, vs1, vs2` (funct3=000, R-type)

```c
#define VR_ALU_INSN(op, vd, vs1, vs2) .insn r 0x2B, 0, (op), x ## vd, x ## vs1, x ## vs2
```
`op` is packed directly into `funct7[3:0]` (not the `funct7[5]+funct3` split
`OPCODE_INTEGER_REG` uses, since `funct3` here is already spent selecting the instruction *kind*).
`op` is `int_alu_op_t`'s own 4-bit encoding:

| op (hex) | Mnemonic | op (hex) | Mnemonic |
|---|---|---|---|
| `0x0` | `VR_ADD` | `0x6` | `VR_OR` |
| `0x1` | `VR_SLL` | `0x7` | `VR_AND` |
| `0x2` | `VR_SLT` | `0x8` | `VR_SUB` |
| `0x3` | `VR_SLTU` | `0xD` | `VR_SRA` |
| `0x4` | `VR_XOR` | | |
| `0x5` | `VR_SRL` | | |

All operands (`vd`/`vs1`/`vs2`) are VRF. Repeat-eligible on both the compute and ctrl pipes
(`mask[0]`=rd, `mask[1]`=rs1, `mask[2]`=rs2 walk independently).

### `vr.mac vd, vs1, vs2, vs3` (funct3=001, R4-type)

```c
#define VR_MAC(vd, vs1, vs2, vs3) .insn r4 0x2B, 1, 0, x ## vd, x ## vs1, x ## vs2, x ## vs3
```
`VRF[vd] = VRF[vs1]*VRF[vs2] + VRF[vs3]` — R4-type, all four operands VRF.
Repeat-eligible on the compute pipe; the common accumulate idiom is `mask=0b0110` (rs1/rs2 walk,
rd/rs3 fixed at the same accumulator register) — see `vmac_acc_8` in `vrepeat.h`.

### `vr.mv.vx vd, rs1` (funct3=010, R-type)

```c
#define VR_MV_VX(vd, rs1) .insn r 0x2B, 2, 0, x ## vd, rs1, x0
```
`VRF[vd] = x[rs1]` — broadcasts a classic-RF value into the VRF. `rs1` is a real classic-RF
register; `rs2` field unused (`x0`).

### `vr.mv.xv rd, vs1` (funct3=011, R-type)

```c
#define VR_MV_XV(rd, vs1) .insn r 0x2B, 3, 0, rd, x ## vs1, x0
```
`x[rd] = VRF[vs1]` — reads a VRF value back into the classic RF (e.g. to branch on a VRF/FP
comparison result). `rd` is a real classic-RF register.

### `vr.lw vd, imm(rs1)` (funct3=100, I-type)

```c
#define VR_LW(vd, rs1, imm) .insn i 0x2B, 4, x ## vd, rs1, (imm)
```
`VRF[vd] = MEM[x[rs1] + imm]` — address (`rs1`) is classic-RF (pointers stay scalar); only the
destination is VRF. Repeat-eligible on the LSU pipe (`rd` always walks; `rs1`/the stride register
auto-increments the address each iteration, independent of `mask`).

### `vr.sw vs2, imm(rs1)` (funct3=101, S-type)

```c
#define VR_SW(vs2, rs1, imm) .insn s 0x2B, 5, x ## vs2, (imm)(rs1)
```
`MEM[x[rs1] + imm] = VRF[vs2]` — address (`rs1`) is classic-RF; the stored value (`vs2`) is VRF.
Repeat-eligible on the LSU pipe: `mask[2]` controls whether `vs2` walks (N distinct values to N
consecutive addresses) or stays fixed/broadcast (one value to N consecutive addresses) — the
address itself always advances by `stride` regardless.

---

## 3. `vr.*i` reg-imm family — `custom-3` (`0x7B`)

**`VR_ALUI_INSN(funct3, vd, vs1, imm)`** (`rvtarget.h`):
```c
#define VR_ALUI_INSN(funct3, vd, vs1, imm) .insn i 0x7B, funct3, x ## vd, x ## vs1, (imm)
```
`VRF[vd] = VRF[vs1] OP imm` — both `vd` and `vs1` are VRF (no classic-RF operand at all, unlike
`vr.mv.*`/`vr.lw`/`vr.sw` above); typically `vs1 == vd` for an in-place update. `funct3` (and, for
the shift-right case, `imm`'s own bit 10) is bit-for-bit the same scheme `OPCODE_INTEGER_IMM`
(standard `ADDI`/`SLLI`/.../`ANDI`) already uses — there's no second "which instruction" use for
`funct3` to share here, unlike `vr.alu`'s funct7-packed op.

| funct3 | Mnemonic | Semantics |
|---|---|---|
| `000` | `VR_ADDI` | `VRF[vd] = VRF[vs1] + imm` |
| `001` | `VR_SLLI` | `VRF[vd] = VRF[vs1] << shamt` |
| `010` | `VR_SLTI` | `VRF[vd] = (VRF[vs1] < imm) ? 1 : 0` (signed) |
| `011` | `VR_SLTIU` | unsigned `VR_SLTI` |
| `100` | `VR_XORI` | `VRF[vd] = VRF[vs1] ^ imm` |
| `101` | `VR_SRLI`/`VR_SRAI` | `VRF[vd] = VRF[vs1] >> shamt` (logical/arithmetic, selected by `imm` bit 10, i.e. `VR_SRAI` passes `1024 + shamt`) |
| `110` | `VR_ORI` | `VRF[vd] = VRF[vs1] \| imm` |
| `111` | `VR_ANDI` | `VRF[vd] = VRF[vs1] & imm` |

Repeat-eligible on both the compute and ctrl pipes (`mask[0]`=rd, `mask[1]`=rs1 walk
independently; there is no `rs2`/`rs3` for this family).
