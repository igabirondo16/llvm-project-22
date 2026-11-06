	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_f2p2_zicsr2p0_zmmul1p0_xrepeat1p0"
	.file	"dotxvf_base.c"
	.option	push
	.option	arch, +f, +m, +xrepeat, +zicsr, +zmmul
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	x2, x2, -16
	sw	x1, 12(x2)                      # 4-byte Folded Spill
	sw	x8, 8(x2)                       # 4-byte Folded Spill
	sw	x9, 4(x2)                       # 4-byte Folded Spill
	sw	x18, 0(x2)                      # 4-byte Folded Spill
	lui	x10, %hi(.L.str)
	addi	x10, x10, %lo(.L.str)
	li	x11, 1024
	li	x12, 4
	li	x13, 8
	li	x8, 1024
	call	printf
	li	x10, 0
	lui	x18, %hi(.L_MergedGlobals)
	addi	x18, x18, %lo(.L_MergedGlobals)
	lui	x11, %hi(x)
	addi	x11, x11, %lo(x)
	lui	x12, 2
	lui	x13, 16
	sw	x0, 0(x18)
	sw	x0, 4(x18)
	sw	x0, 8(x18)
	sw	x0, 12(x18)
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
# %bb.2:                                # %for.body9.i.preheader
	li	x10, 0
	lui	x11, %hi(A)
	addi	x11, x11, %lo(A)
	li	x12, -2
	lui	x13, 838861
	lui	x14, 1
	addi	x13, x13, -819
	add	x14, x11, x14
.LBB0_3:                                # %for.body9.i
                                        # =>This Inner Loop Header: Depth=1
	mulhu	x15, x10, x13
	addi	x10, x10, 1
	srli	x16, x15, 2
	andi	x15, x15, -4
	add	x15, x15, x16
	sub	x15, x12, x15
	sw	x15, 0(x11)
	addi	x11, x11, 4
	addi	x12, x12, 1
	bne	x11, x14, .LBB0_3
# %bb.4:                                # %for.body9.1.i.preheader
	lui	x10, %hi(A)
	addi	x10, x10, %lo(A)
	lui	x13, 1
	li	x11, -1
	li	x12, 1
	lui	x14, 838861
	lui	x15, 2
	add	x13, x10, x13
	addi	x14, x14, -819
	add	x15, x10, x15
.LBB0_5:                                # %for.body9.1.i
                                        # =>This Inner Loop Header: Depth=1
	mulhu	x16, x12, x14
	srli	x17, x16, 2
	andi	x16, x16, -4
	add	x16, x16, x17
	sub	x16, x11, x16
	sw	x16, 0(x13)
	addi	x13, x13, 4
	addi	x11, x11, 1
	addi	x12, x12, 1
	bne	x13, x15, .LBB0_5
# %bb.6:                                # %for.body9.2.i.preheader
	li	x11, 0
	lui	x13, 2
	li	x12, 2
	lui	x14, 838861
	lui	x15, 3
	add	x13, x10, x13
	addi	x14, x14, -819
	add	x15, x10, x15
.LBB0_7:                                # %for.body9.2.i
                                        # =>This Inner Loop Header: Depth=1
	mulhu	x16, x12, x14
	srli	x17, x16, 2
	andi	x16, x16, -4
	add	x16, x16, x17
	sub	x16, x11, x16
	addi	x11, x11, 1
	sw	x16, 0(x13)
	addi	x13, x13, 4
	addi	x12, x12, 1
	bne	x13, x15, .LBB0_7
# %bb.8:                                # %for.body9.3.i.preheader
	lui	x13, 3
	li	x11, 1
	li	x12, 3
	lui	x14, 838861
	lui	x15, 4
	add	x13, x10, x13
	addi	x14, x14, -819
	add	x15, x10, x15
.LBB0_9:                                # %for.body9.3.i
                                        # =>This Inner Loop Header: Depth=1
	mulhu	x16, x12, x14
	srli	x17, x16, 2
	andi	x16, x16, -4
	add	x16, x16, x17
	sub	x16, x11, x16
	sw	x16, 0(x13)
	addi	x13, x13, 4
	addi	x11, x11, 1
	addi	x12, x12, 1
	bne	x13, x15, .LBB0_9
# %bb.10:                               # %init_data.exit
	#APP
	#NO_APP
	lui	x11, 65555
	lui	x12, 3
	lui	x13, 2
	lui	x14, 1
	fmv.w.x	f15, x0
	sw	x0, 0(x11)
	add	x11, x10, x12
	add	x12, x10, x13
	add	x13, x10, x14
	#APP
	#NO_APP
	lui	x14, %hi(x)
	addi	x14, x14, %lo(x)
	li	x15, 4
	lui	x16, 4
	add	x16, x10, x16
	fmv.s	f14, f15
	fmv.s	f13, f15
	fmv.s	f12, f15
.LBB0_11:                               # %vector.body
                                        # =>This Inner Loop Header: Depth=1
	flw	f24, 0(x10)
	xr.repeat	1, x15, 7
	flw	f0, 0(x14)
	xr.repeat	1, x15, 7
	xr.mac	f15, f0, f24, f15
	xr.repeat	6, x0, 7
	flw	f24, 0(x13)
	xr.repeat	1, x15, 7
	xr.mac	f14, f0, f24, f14
	xr.repeat	6, x0, 7
	flw	f24, 0(x12)
	xr.repeat	1, x15, 7
	xr.mac	f13, f0, f24, f13
	xr.repeat	6, x0, 7
	flw	f24, 0(x11)
	xr.repeat	1, x15, 7
	xr.mac	f12, f0, f24, f12
	xr.repeat	6, x0, 7
	addi	x11, x11, 32
	addi	x12, x12, 32
	addi	x13, x13, 32
	addi	x14, x14, 32
	addi	x10, x10, 32
	bne	x11, x16, .LBB0_11
# %bb.12:                               # %dotxvf.exit
	fsw	f15, 0(x18)
	fsw	f14, 4(x18)
	fsw	f13, 8(x18)
	fsw	f12, 12(x18)
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
	mul	x9, x10, x11
	lui	x10, %hi(.L.str.3)
	addi	x10, x10, %lo(.L.str.3)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x9
	call	printf
	lui	x13, 1032542
	addi	x13, x13, 516
	bne	x9, x13, .LBB0_14
# %bb.13:                               # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x8, 0
	j	.LBB0_15
.LBB0_14:                               # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x9
	call	printf
.LBB0_15:                               # %bench_report.exit
	mv	x10, x8
	lw	x1, 12(x2)                      # 4-byte Folded Reload
	lw	x8, 8(x2)                       # 4-byte Folded Reload
	lw	x9, 4(x2)                       # 4-byte Folded Reload
	lw	x18, 0(x2)                      # 4-byte Folded Reload
	addi	x2, x2, 16
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"dotxvf: dot-product microkernel (NC=%d UR=%d V=%d)\n"
	.size	.L.str, 52

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"y[%d] = %d\n"
	.size	.L.str.1, 12

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"dotxvf"
	.size	.L.str.2, 7

	.type	x,@object                       # @x
	.local	x
	.comm	x,4096,4
	.type	A,@object                       # @A
	.local	A
	.comm	A,16384,4
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
	.comm	.L_MergedGlobals,16,4
y.0 = .L_MergedGlobals
	.size	y.0, 4
y.1 = .L_MergedGlobals+4
	.size	y.1, 4
y.2 = .L_MergedGlobals+8
	.size	y.2, 4
y.3 = .L_MergedGlobals+12
	.size	y.3, 4
	.ident	"clang version 22.1.8 (https://github.com/igabirondo16/llvm-project-22.git 477e688a98d61e1ca9b3401134098175fdecb835)"
	.section	".note.GNU-stack","",@progbits
