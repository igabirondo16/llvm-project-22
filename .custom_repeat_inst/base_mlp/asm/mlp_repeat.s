	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"mlp_repeat.c"
	.option	push
	.option	arch, +m, +zmmul
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	x2, x2, -64
	sw	x1, 60(x2)                      # 4-byte Folded Spill
	sw	x8, 56(x2)                      # 4-byte Folded Spill
	sw	x9, 52(x2)                      # 4-byte Folded Spill
	sw	x18, 48(x2)                     # 4-byte Folded Spill
	sw	x19, 44(x2)                     # 4-byte Folded Spill
	sw	x20, 40(x2)                     # 4-byte Folded Spill
	sw	x21, 36(x2)                     # 4-byte Folded Spill
	sw	x22, 32(x2)                     # 4-byte Folded Spill
	sw	x23, 28(x2)                     # 4-byte Folded Spill
	sw	x24, 24(x2)                     # 4-byte Folded Spill
	sw	x25, 20(x2)                     # 4-byte Folded Spill
	sw	x26, 16(x2)                     # 4-byte Folded Spill
	sw	x27, 12(x2)                     # 4-byte Folded Spill
	lui	x10, %hi(.L.str)
	addi	x10, x10, %lo(.L.str)
	li	x11, 64
	li	x12, 32
	li	x13, 16
	li	x9, 32
	call	printf
	li	x10, 0
	lui	x11, %hi(W1)
	addi	x11, x11, %lo(W1)
	li	x12, -3
	lui	x13, 149797
	lui	x14, 838861
	addi	x13, x13, -1755
	addi	x14, x14, -819
	lui	x8, %hi(.L_MergedGlobals)
	addi	x8, x8, %lo(.L_MergedGlobals)
	mv	x15, x11
.LBB0_1:                                # %for.cond1.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	slli	x16, x10, 8
	add	x16, x16, x11
	addi	x16, x16, 256
	mv	x17, x10
	mv	x5, x12
	mv	x6, x15
.LBB0_2:                                # %for.body4.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mulhu	x7, x17, x13
	sub	x28, x17, x7
	srli	x28, x28, 1
	add	x7, x28, x7
	srli	x7, x7, 2
	slli	x28, x7, 3
	add	x7, x5, x7
	sub	x7, x7, x28
	sw	x7, 0(x6)
	addi	x6, x6, 4
	addi	x5, x5, 1
	addi	x17, x17, 1
	bne	x6, x16, .LBB0_2
# %bb.3:                                # %for.cond.cleanup3.i
                                        #   in Loop: Header=BB0_1 Depth=1
	mulhu	x16, x10, x14
	srli	x17, x16, 2
	andi	x16, x16, -4
	add	x16, x16, x17
	slli	x17, x10, 2
	addi	x15, x15, 256
	add	x17, x8, x17
	sub	x16, x10, x16
	addi	x10, x10, 1
	addi	x16, x16, -2
	sw	x16, 128(x17)
	addi	x12, x12, 1
	bne	x10, x9, .LBB0_1
# %bb.4:                                # %for.cond17.preheader.i.preheader
	li	x10, 0
	lui	x11, %hi(W2)
	addi	x11, x11, %lo(W2)
	li	x12, -2
	lui	x13, 838861
	lui	x14, 699051
	addi	x13, x13, -819
	addi	x14, x14, -1365
	li	x15, 16
	mv	x16, x11
.LBB0_5:                                # %for.cond17.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
	slli	x17, x10, 7
	add	x17, x17, x11
	addi	x17, x17, 128
	mv	x5, x10
	mv	x6, x12
	mv	x7, x16
.LBB0_6:                                # %for.body20.i
                                        #   Parent Loop BB0_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mulhu	x28, x5, x13
	srli	x29, x28, 2
	andi	x28, x28, -4
	add	x28, x28, x29
	sub	x28, x6, x28
	sw	x28, 0(x7)
	addi	x7, x7, 4
	addi	x6, x6, 1
	addi	x5, x5, 1
	bne	x7, x17, .LBB0_6
# %bb.7:                                # %for.cond.cleanup19.i
                                        #   in Loop: Header=BB0_5 Depth=1
	mulhu	x17, x10, x14
	srli	x5, x17, 1
	andi	x17, x17, -2
	add	x17, x17, x5
	slli	x5, x10, 2
	addi	x16, x16, 128
	add	x5, x8, x5
	not	x17, x17
	add	x17, x17, x10
	addi	x10, x10, 1
	sw	x17, 64(x5)
	addi	x12, x12, 1
	bne	x10, x15, .LBB0_5
# %bb.8:                                # %for.body39.i.preheader
	li	x10, 0
	addi	x11, x8, 384
	li	x12, 57
	li	x13, 64
.LBB0_9:                                # %for.body39.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x14, x10, x12
	srli	x14, x14, 9
	andi	x15, x14, 127
	slli	x14, x14, 3
	add	x14, x14, x15
	sub	x14, x10, x14
	addi	x10, x10, 1
	zext.b	x14, x14
	addi	x14, x14, -4
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x10, x13, .LBB0_9
# %bb.10:                               # %init_data.exit
	li	x10, 0
	#APP
	#NO_APP
	lui	x12, 65555
	lui	x11, %hi(W1)
	addi	x11, x11, %lo(W1)
	sw	x0, 0(x12)
	#APP
	#NO_APP
	addi	x12, x8, 384
	li	x13, 4
	li	x14, 7
	li	x15, 32
.LBB0_11:                               # %for.body.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_12 Depth 2
	slli	x5, x10, 2
	add	x5, x8, x5
	lw	x6, 128(x5)
	li	x7, 8
	mv	x9, x12
	mv	x1, x11
.LBB0_12:                               # %for.body4.i6
                                        #   Parent Loop BB0_11 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	lw	x24, 0(x9)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	lw	x16, 0(x1)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	.insn r4 11, 0, 0, x6, x24, x16, x6
	.insn r 91, 0, 48, x0, x0, x14

	#NO_APP
	addi	x7, x7, -1
	addi	x1, x1, 32
	addi	x9, x9, 32
	bnez	x7, .LBB0_12
# %bb.13:                               # %for.cond.cleanup3.i11
                                        #   in Loop: Header=BB0_11 Depth=1
	sgtz	x16, x6
	addi	x10, x10, 1
	neg	x16, x16
	and	x16, x16, x6
	sw	x16, 256(x5)
	addi	x11, x11, 256
	bne	x10, x15, .LBB0_11
# %bb.14:                               # %for.body17.i.preheader
	addi	x10, x8, 64
	lui	x11, %hi(W2)
	addi	x11, x11, %lo(W2)
	addi	x12, x8, 256
	li	x13, 4
	li	x14, 7
	addi	x15, x8, 288
	addi	x5, x8, 320
	addi	x6, x8, 352
	addi	x7, x8, 128
.LBB0_15:                               # %for.body17.i
                                        # =>This Inner Loop Header: Depth=1
	lw	x9, 0(x10)
	#APP
	lw	x24, 0(x12)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	lw	x16, 0(x11)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x14

	#NO_APP
	addi	x1, x11, 32
	#APP
	lw	x24, 0(x15)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	lw	x16, 0(x1)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x14

	#NO_APP
	addi	x1, x11, 64
	#APP
	lw	x24, 0(x5)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	lw	x16, 0(x1)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x14

	#NO_APP
	addi	x1, x11, 96
	#APP
	lw	x24, 0(x6)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	lw	x16, 0(x1)
	.insn r 91, 0, 8, x0, x13, x14

	#NO_APP
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x14

	#NO_APP
	sw	x9, -64(x10)
	addi	x10, x10, 4
	addi	x11, x11, 128
	bne	x10, x7, .LBB0_15
# %bb.16:                               # %mlp_repeat_8.exit
	#APP
	#NO_APP
	lui	x10, 65555
	li	x11, 1
	sw	x11, 0(x10)
	#APP
	#NO_APP
	lw	x10, 0(x8)
	lw	x11, 4(x8)
	lw	x12, 8(x8)
	slt	x11, x10, x11
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_18
# %bb.17:                               # %mlp_repeat_8.exit
	li	x11, 2
.LBB0_18:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 12(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_20
# %bb.19:                               # %mlp_repeat_8.exit
	li	x11, 3
.LBB0_20:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 16(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_22
# %bb.21:                               # %mlp_repeat_8.exit
	li	x11, 4
.LBB0_22:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 20(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_24
# %bb.23:                               # %mlp_repeat_8.exit
	li	x11, 5
.LBB0_24:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 24(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_26
# %bb.25:                               # %mlp_repeat_8.exit
	li	x11, 6
.LBB0_26:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 28(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_28
# %bb.27:                               # %mlp_repeat_8.exit
	li	x11, 7
.LBB0_28:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 32(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_30
# %bb.29:                               # %mlp_repeat_8.exit
	li	x11, 8
.LBB0_30:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 36(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_32
# %bb.31:                               # %mlp_repeat_8.exit
	li	x11, 9
.LBB0_32:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 40(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_34
# %bb.33:                               # %mlp_repeat_8.exit
	li	x11, 10
.LBB0_34:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 44(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_36
# %bb.35:                               # %mlp_repeat_8.exit
	li	x11, 11
.LBB0_36:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 48(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_38
# %bb.37:                               # %mlp_repeat_8.exit
	li	x11, 12
.LBB0_38:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 52(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_40
# %bb.39:                               # %mlp_repeat_8.exit
	li	x11, 13
.LBB0_40:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 56(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_42
# %bb.41:                               # %mlp_repeat_8.exit
	li	x11, 14
.LBB0_42:                               # %mlp_repeat_8.exit
	slli	x10, x11, 2
	add	x10, x8, x10
	lw	x12, 60(x8)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_44
# %bb.43:                               # %mlp_repeat_8.exit
	li	x11, 15
.LBB0_44:                               # %mlp_repeat_8.exit
	lui	x10, %hi(.L.str.1)
	addi	x10, x10, %lo(.L.str.1)
	call	printf
	lui	x10, 528842
	lui	x11, 4096
	lw	x12, 0(x8)
	lw	x13, 4(x8)
	lw	x14, 8(x8)
	lw	x15, 12(x8)
	addi	x16, x10, -571
	addi	x10, x11, 403
	xor	x11, x12, x16
	mul	x11, x11, x10
	xor	x11, x11, x13
	mul	x11, x11, x10
	xor	x11, x11, x14
	mul	x11, x11, x10
	xor	x11, x11, x15
	lw	x12, 16(x8)
	lw	x13, 20(x8)
	lw	x14, 24(x8)
	lw	x15, 28(x8)
	mul	x11, x11, x10
	xor	x11, x11, x12
	mul	x11, x11, x10
	xor	x11, x11, x13
	mul	x11, x11, x10
	xor	x11, x11, x14
	mul	x11, x11, x10
	xor	x11, x11, x15
	lw	x12, 32(x8)
	lw	x13, 36(x8)
	lw	x14, 40(x8)
	lw	x15, 44(x8)
	mul	x11, x11, x10
	xor	x11, x11, x12
	mul	x11, x11, x10
	xor	x11, x11, x13
	mul	x11, x11, x10
	xor	x11, x11, x14
	mul	x11, x11, x10
	xor	x11, x11, x15
	mul	x11, x11, x10
	lw	x12, 48(x8)
	lw	x13, 52(x8)
	lw	x14, 56(x8)
	lw	x15, 60(x8)
	xor	x11, x11, x12
	mul	x11, x11, x10
	xor	x11, x11, x13
	mul	x11, x11, x10
	xor	x11, x11, x14
	mul	x11, x11, x10
	xor	x11, x11, x15
	mul	x8, x11, x10
	lui	x10, %hi(.L.str.3)
	addi	x10, x10, %lo(.L.str.3)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	lui	x13, 853236
	addi	x13, x13, -1861
	bne	x8, x13, .LBB0_46
# %bb.45:                               # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x10, 0
	j	.LBB0_47
.LBB0_46:                               # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	li	x10, 1
.LBB0_47:                               # %bench_report.exit
	lw	x1, 60(x2)                      # 4-byte Folded Reload
	lw	x8, 56(x2)                      # 4-byte Folded Reload
	lw	x9, 52(x2)                      # 4-byte Folded Reload
	lw	x18, 48(x2)                     # 4-byte Folded Reload
	lw	x19, 44(x2)                     # 4-byte Folded Reload
	lw	x20, 40(x2)                     # 4-byte Folded Reload
	lw	x21, 36(x2)                     # 4-byte Folded Reload
	lw	x22, 32(x2)                     # 4-byte Folded Reload
	lw	x23, 28(x2)                     # 4-byte Folded Reload
	lw	x24, 24(x2)                     # 4-byte Folded Reload
	lw	x25, 20(x2)                     # 4-byte Folded Reload
	lw	x26, 16(x2)                     # 4-byte Folded Reload
	lw	x27, 12(x2)                     # 4-byte Folded Reload
	addi	x2, x2, 64
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"mlp: 2-layer MLP forward pass (IN=%d HIDDEN=%d OUT=%d) [repeat_8]\n"
	.size	.L.str, 67

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"argmax class: %d\n"
	.size	.L.str.1, 18

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"mlp"
	.size	.L.str.2, 4

	.type	W1,@object                      # @W1
	.local	W1
	.comm	W1,8192,4
	.type	W2,@object                      # @W2
	.local	W2
	.comm	W2,2048,4
	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"BENCH %s checksum=0x%08x\n"
	.size	.L.str.3, 26

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"PASS: %s checksum matches\n"
	.size	.L.str.5, 27

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"FAIL: %s checksum 0x%08x != expected 0x%08x\n"
	.size	.L.str.6, 45

	.type	.L_MergedGlobals,@object        # @_MergedGlobals
	.local	.L_MergedGlobals
	.comm	.L_MergedGlobals,640,4
output = .L_MergedGlobals
	.size	output, 64
B2 = .L_MergedGlobals+64
	.size	B2, 64
B1 = .L_MergedGlobals+128
	.size	B1, 128
hidden = .L_MergedGlobals+256
	.size	hidden, 128
input = .L_MergedGlobals+384
	.size	input, 256
	.ident	"clang version 22.1.8 (https://github.com/igabirondo16/llvm-project-22.git d5087d6b74df14fbf64ee88049d1ce9a2c66567d)"
	.section	".note.GNU-stack","",@progbits
