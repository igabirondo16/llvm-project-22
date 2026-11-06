	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"gepdot_base.c"
	.option	push
	.option	arch, +m, +zmmul
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	x2, x2, -32
	sw	x1, 28(x2)                      # 4-byte Folded Spill
	sw	x8, 24(x2)                      # 4-byte Folded Spill
	sw	x9, 20(x2)                      # 4-byte Folded Spill
	sw	x18, 16(x2)                     # 4-byte Folded Spill
	sw	x19, 12(x2)                     # 4-byte Folded Spill
	sw	x20, 8(x2)                      # 4-byte Folded Spill
	sw	x21, 4(x2)                      # 4-byte Folded Spill
	lui	x10, %hi(.L.str)
	addi	x10, x10, %lo(.L.str)
	li	x11, 1024
	li	x12, 1
	li	x13, 8
	li	x8, 1024
	call	printf
	li	x10, 0
	lui	x11, %hi(A)
	addi	x11, x11, %lo(A)
	lui	x12, 2
	lui	x13, 16
	addi	x12, x12, 1171
	addi	x13, x13, -1
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x14, x10, x12
	srli	x14, x14, 16
	sub	x15, x10, x14
	slli	x15, x15, 16
	srli	x15, x15, 17
	add	x14, x15, x14
	slli	x14, x14, 16
	srli	x14, x14, 18
	slli	x15, x14, 3
	add	x14, x10, x14
	addi	x10, x10, 1
	sub	x14, x14, x15
	and	x14, x14, x13
	addi	x14, x14, -3
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x10, x8, .LBB0_1
# %bb.2:                                # %for.cond6.preheader.i.preheader
	li	x28, 0
	lui	x10, %hi(B)
	addi	x10, x10, %lo(B)
	li	x11, 7
	li	x12, 6
	li	x13, 5
	li	x14, 4
	li	x15, 3
	li	x16, 2
	li	x17, 1
	lui	x6, 838861
	addi	x5, x10, 16
	addi	x6, x6, -819
	li	x7, 1024
.LBB0_3:                                # %for.cond6.preheader.i
                                        # =>This Inner Loop Header: Depth=1
	mulhu	x29, x11, x6
	mulhu	x31, x12, x6
	mulhu	x8, x13, x6
	mulhu	x9, x14, x6
	mulhu	x18, x15, x6
	mulhu	x19, x16, x6
	mulhu	x20, x17, x6
	mulhu	x21, x28, x6
	srli	x30, x29, 2
	andi	x29, x29, -4
	add	x30, x29, x30
	srli	x29, x31, 2
	andi	x31, x31, -4
	add	x31, x31, x29
	srli	x29, x8, 2
	andi	x8, x8, -4
	add	x8, x8, x29
	srli	x29, x9, 2
	andi	x9, x9, -4
	add	x9, x9, x29
	srli	x29, x18, 2
	andi	x18, x18, -4
	add	x18, x18, x29
	srli	x29, x19, 2
	andi	x19, x19, -4
	add	x19, x19, x29
	srli	x29, x20, 2
	andi	x20, x20, -4
	add	x20, x20, x29
	srli	x29, x21, 2
	andi	x21, x21, -4
	add	x21, x21, x29
	addi	x29, x28, 1
	addi	x11, x11, 1
	addi	x12, x12, 1
	addi	x13, x13, 1
	addi	x14, x14, 1
	addi	x15, x15, 1
	addi	x16, x16, 1
	addi	x17, x17, 1
	sub	x21, x28, x21
	not	x20, x20
	sub	x19, x28, x19
	sub	x18, x28, x18
	sub	x9, x28, x9
	sub	x8, x28, x8
	sub	x31, x28, x31
	sub	x30, x28, x30
	addi	x21, x21, -2
	add	x28, x20, x28
	addi	x18, x18, 1
	addi	x9, x9, 2
	addi	x8, x8, 3
	addi	x31, x31, 4
	addi	x30, x30, 5
	sw	x21, -16(x5)
	sw	x28, -12(x5)
	sw	x19, -8(x5)
	sw	x18, -4(x5)
	sw	x9, 0(x5)
	sw	x8, 4(x5)
	sw	x31, 8(x5)
	sw	x30, 12(x5)
	addi	x5, x5, 32
	mv	x28, x29
	bne	x29, x7, .LBB0_3
# %bb.4:                                # %init_data.exit
	lui	x18, %hi(.L_MergedGlobals)
	addi	x18, x18, %lo(.L_MergedGlobals)
	li	x11, -1
	li	x12, 1
	lui	x13, 65555
	addi	x10, x10, 16
	sw	x11, 0(x18)
	sw	x0, 4(x18)
	sw	x12, 8(x18)
	sw	x11, 12(x18)
	sw	x0, 16(x18)
	sw	x12, 20(x18)
	sw	x11, 24(x18)
	sw	x0, 28(x18)
	#APP
	#NO_APP
	sw	x0, 0(x13)
	#APP
	#NO_APP
	lw	x5, 0(x18)
	lw	x17, 4(x18)
	lw	x16, 8(x18)
	lw	x15, 12(x18)
	lw	x14, 16(x18)
	lw	x13, 20(x18)
	lw	x12, 24(x18)
	lw	x11, 28(x18)
	lui	x6, %hi(A)
	addi	x6, x6, %lo(A)
	lui	x7, 1
	add	x7, x6, x7
.LBB0_5:                                # %for.cond1.preheader.i
                                        # =>This Inner Loop Header: Depth=1
	lw	x28, 0(x6)
	lw	x29, -16(x10)
	lw	x30, -12(x10)
	lw	x31, -8(x10)
	lw	x8, -4(x10)
	lw	x9, 0(x10)
	lw	x19, 4(x10)
	lw	x20, 8(x10)
	lw	x21, 12(x10)
	mul	x29, x29, x28
	mul	x30, x30, x28
	mul	x31, x31, x28
	mul	x8, x8, x28
	mul	x9, x9, x28
	mul	x19, x19, x28
	mul	x20, x20, x28
	mul	x28, x21, x28
	add	x5, x29, x5
	add	x17, x30, x17
	add	x16, x31, x16
	add	x15, x8, x15
	add	x14, x9, x14
	add	x13, x19, x13
	addi	x6, x6, 4
	add	x12, x20, x12
	add	x11, x28, x11
	addi	x10, x10, 32
	bne	x6, x7, .LBB0_5
# %bb.6:                                # %gepdot.exit
	sw	x5, 0(x18)
	sw	x17, 4(x18)
	sw	x16, 8(x18)
	sw	x15, 12(x18)
	sw	x14, 16(x18)
	sw	x13, 20(x18)
	sw	x12, 24(x18)
	sw	x11, 28(x18)
	lui	x10, 65555
	li	x8, 1
	#APP
	#NO_APP
	sw	x8, 0(x10)
	#APP
	#NO_APP
	lw	x12, 0(x18)
	lui	x9, %hi(.L.str.1)
	addi	x9, x9, %lo(.L.str.1)
	mv	x10, x9
	li	x11, 0
	call	printf
	lw	x12, 4(x18)
	li	x11, 1
	mv	x10, x9
	call	printf
	lw	x12, 8(x18)
	li	x11, 2
	mv	x10, x9
	call	printf
	lw	x12, 12(x18)
	li	x11, 3
	mv	x10, x9
	call	printf
	lw	x12, 16(x18)
	li	x11, 4
	mv	x10, x9
	call	printf
	lw	x12, 20(x18)
	li	x11, 5
	mv	x10, x9
	call	printf
	lw	x12, 24(x18)
	li	x11, 6
	mv	x10, x9
	call	printf
	lw	x12, 28(x18)
	li	x11, 7
	mv	x10, x9
	call	printf
	lui	x10, 528842
	lw	x11, 0(x18)
	lw	x12, 4(x18)
	lw	x13, 8(x18)
	lw	x14, 12(x18)
	addi	x10, x10, -571
	xor	x10, x11, x10
	lui	x11, 4096
	addi	x11, x11, 403
	mul	x10, x10, x11
	xor	x10, x10, x12
	mul	x10, x10, x11
	xor	x10, x10, x13
	mul	x10, x10, x11
	xor	x10, x10, x14
	mul	x10, x10, x11
	lw	x12, 16(x18)
	lw	x13, 20(x18)
	lw	x14, 24(x18)
	lw	x15, 28(x18)
	xor	x10, x10, x12
	mul	x10, x10, x11
	xor	x10, x10, x13
	mul	x10, x10, x11
	xor	x10, x10, x14
	mul	x10, x10, x11
	xor	x10, x10, x15
	mul	x9, x10, x11
	lui	x10, %hi(.L.str.3)
	addi	x10, x10, %lo(.L.str.3)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x9
	call	printf
	lui	x13, 802699
	addi	x13, x13, -798
	bne	x9, x13, .LBB0_8
# %bb.7:                                # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x8, 0
	j	.LBB0_9
.LBB0_8:                                # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x9
	call	printf
.LBB0_9:                                # %bench_report.exit
	mv	x10, x8
	lw	x1, 28(x2)                      # 4-byte Folded Reload
	lw	x8, 24(x2)                      # 4-byte Folded Reload
	lw	x9, 20(x2)                      # 4-byte Folded Reload
	lw	x18, 16(x2)                     # 4-byte Folded Reload
	lw	x19, 12(x2)                     # 4-byte Folded Reload
	lw	x20, 8(x2)                      # 4-byte Folded Reload
	lw	x21, 4(x2)                      # 4-byte Folded Reload
	addi	x2, x2, 32
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"gepdot: rank-1 GEMM microkernel (Kc=%d Mr=%d Nr=%d)\n"
	.size	.L.str, 53

	.type	A,@object                       # @A
	.local	A
	.comm	A,4096,4
	.type	B,@object                       # @B
	.local	B
	.comm	B,32768,4
	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"C[%d] = %d\n"
	.size	.L.str.1, 12

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"gepdot"
	.size	.L.str.2, 7

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
	.comm	.L_MergedGlobals,32,4
C.0 = .L_MergedGlobals
	.size	C.0, 4
C.1 = .L_MergedGlobals+4
	.size	C.1, 4
C.2 = .L_MergedGlobals+8
	.size	C.2, 4
C.3 = .L_MergedGlobals+12
	.size	C.3, 4
C.4 = .L_MergedGlobals+16
	.size	C.4, 4
C.5 = .L_MergedGlobals+20
	.size	C.5, 4
C.6 = .L_MergedGlobals+24
	.size	C.6, 4
C.7 = .L_MergedGlobals+28
	.size	C.7, 4
	.ident	"clang version 22.1.8 (https://github.com/igabirondo16/llvm-project-22.git 477e688a98d61e1ca9b3401134098175fdecb835)"
	.section	".note.GNU-stack","",@progbits
