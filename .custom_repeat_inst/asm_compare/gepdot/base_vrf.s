	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_f2p2_zicsr2p0_zmmul1p0_xrepeat1p0"
	.file	"gepdot_base.c"
	.option	push
	.option	arch, +f, +m, +xrepeat, +zicsr, +zmmul
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function main
.LCPI0_0:
	.word	4294967295                      # 0xffffffff
	.word	0                               # 0x0
	.word	1                               # 0x1
	.word	4294967295                      # 0xffffffff
	.word	0                               # 0x0
	.word	1                               # 0x1
	.word	4294967295                      # 0xffffffff
	.word	0                               # 0x0
	.text
	.globl	main
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
	li	x11, 4
	lui	x12, %hi(.LCPI0_0)
	lui	x13, %hi(C)
	flw	f0, %lo(.LCPI0_0)(x12)
	xr.repeat	1, x11, 7
	lui	x12, 65555
	fsw	f0, %lo(C)(x13)
	xr.repeat	4, x11, 7
	#APP
	#NO_APP
	sw	x0, 0(x12)
	#APP
	#NO_APP
	flw	f0, %lo(C)(x13)
	xr.repeat	1, x11, 7
	lui	x12, %hi(A)
	addi	x12, x12, %lo(A)
	lui	x13, 8
	add	x13, x10, x13
.LBB0_5:                                # %for.cond1.preheader.i
                                        # =>This Inner Loop Header: Depth=1
	flw	f15, 0(x12)
	flw	f24, 0(x10)
	xr.repeat	1, x11, 7
	addi	x10, x10, 32
	xr.mac	f0, f24, f15, f0
	xr.repeat	11, x0, 7
	addi	x12, x12, 4
	bne	x10, x13, .LBB0_5
# %bb.6:                                # %gepdot.exit
	lui	x18, %hi(C)
	li	x10, 4
	lui	x11, 65555
	fsw	f0, %lo(C)(x18)
	xr.repeat	4, x10, 7
	li	x8, 1
	#APP
	#NO_APP
	sw	x8, 0(x11)
	#APP
	#NO_APP
	lw	x12, %lo(C)(x18)
	lui	x9, %hi(.L.str.1)
	addi	x9, x9, %lo(.L.str.1)
	mv	x10, x9
	li	x11, 0
	call	printf
	lw	x12, %lo(C+4)(x18)
	li	x11, 1
	mv	x10, x9
	call	printf
	lw	x12, %lo(C+8)(x18)
	li	x11, 2
	mv	x10, x9
	call	printf
	lw	x12, %lo(C+12)(x18)
	li	x11, 3
	mv	x10, x9
	call	printf
	lw	x12, %lo(C+16)(x18)
	li	x11, 4
	mv	x10, x9
	call	printf
	lw	x12, %lo(C+20)(x18)
	li	x11, 5
	mv	x10, x9
	call	printf
	lw	x12, %lo(C+24)(x18)
	li	x11, 6
	mv	x10, x9
	call	printf
	lw	x12, %lo(C+28)(x18)
	li	x11, 7
	mv	x10, x9
	call	printf
	lw	x10, %lo(C)(x18)
	lui	x11, 528842
	lui	x12, 4096
	lw	x13, %lo(C+4)(x18)
	addi	x11, x11, -571
	xor	x10, x10, x11
	lw	x11, %lo(C+8)(x18)
	addi	x12, x12, 403
	mul	x10, x10, x12
	xor	x10, x10, x13
	lw	x13, %lo(C+12)(x18)
	mul	x10, x10, x12
	xor	x10, x10, x11
	lw	x11, %lo(C+16)(x18)
	mul	x10, x10, x12
	xor	x10, x10, x13
	lw	x13, %lo(C+20)(x18)
	mul	x10, x10, x12
	xor	x10, x10, x11
	lw	x11, %lo(C+24)(x18)
	mul	x10, x10, x12
	xor	x10, x10, x13
	lw	x13, %lo(C+28)(x18)
	mul	x10, x10, x12
	xor	x10, x10, x11
	mul	x10, x10, x12
	xor	x10, x10, x13
	mul	x9, x10, x12
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

	.type	C,@object                       # @C
	.local	C
	.comm	C,32,32
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

	.ident	"clang version 22.1.8 (https://github.com/igabirondo16/llvm-project-22.git 477e688a98d61e1ca9b3401134098175fdecb835)"
	.section	".note.GNU-stack","",@progbits
