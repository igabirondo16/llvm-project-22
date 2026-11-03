	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"main.c"
	.option	push
	.option	arch, +m, +zmmul
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	x2, x2, -48
	sw	x1, 44(x2)                      # 4-byte Folded Spill
	sw	x8, 40(x2)                      # 4-byte Folded Spill
	sw	x18, 36(x2)                     # 4-byte Folded Spill
	sw	x19, 32(x2)                     # 4-byte Folded Spill
	sw	x20, 28(x2)                     # 4-byte Folded Spill
	sw	x21, 24(x2)                     # 4-byte Folded Spill
	sw	x22, 20(x2)                     # 4-byte Folded Spill
	sw	x23, 16(x2)                     # 4-byte Folded Spill
	sw	x24, 12(x2)                     # 4-byte Folded Spill
	sw	x25, 8(x2)                      # 4-byte Folded Spill
	sw	x26, 4(x2)                      # 4-byte Folded Spill
	sw	x27, 0(x2)                      # 4-byte Folded Spill
	lui	x10, %hi(.L.str)
	addi	x10, x10, %lo(.L.str)
	li	x11, 1000
	li	x8, 1000
	call	printf
	li	x10, 0
	lui	x11, %hi(x)
	addi	x11, x11, %lo(x)
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
# %bb.2:                                # %for.body5.i.preheader
	li	x10, 0
	lui	x11, %hi(y)
	addi	x11, x11, %lo(y)
	lui	x12, 13
	addi	x12, x12, -819
	li	x13, 1000
.LBB0_3:                                # %for.body5.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x14, x10, x12
	srli	x14, x14, 18
	slli	x15, x14, 2
	sub	x14, x10, x14
	addi	x10, x10, 1
	sub	x14, x14, x15
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -2
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x10, x13, .LBB0_3
# %bb.4:                                # %init_data.exit
	#APP
	#NO_APP
	lui	x14, 65555
	lui	x10, %hi(x)
	addi	x10, x10, %lo(x)
	lui	x11, %hi(y)
	addi	x11, x11, %lo(y)
	li	x12, 4
	li	x13, 7
	sw	x0, 0(x14)
	#APP
	#NO_APP
	li	x14, 3
	li	x15, 1
	addi	x16, x11, 2047
	addi	x5, x16, 1953
.LBB0_5:                                # %for.body.i3
                                        # =>This Inner Loop Header: Depth=1
	#APP
	lw	x24, 0(x10)
	.insn r 91, 0, 8, x0, x12, x13
	#NO_APP
	#APP
	.insn r4 11, 0, 0, x24, x14, x24, x0
	.insn r 91, 0, 40, x0, x0, x13
	#NO_APP
	#APP
	lw	x16, 0(x11)
	.insn r 91, 0, 8, x0, x12, x13
	#NO_APP
	#APP
	.insn r4 11, 0, 0, x24, x15, x16, x24
	.insn r 91, 0, 104, x0, x0, x13
	#NO_APP
	sw	x24, 0(x11)
	sw	x25, 4(x11)
	sw	x26, 8(x11)
	sw	x27, 12(x11)
	sw	x28, 16(x11)
	sw	x29, 20(x11)
	sw	x30, 24(x11)
	sw	x31, 28(x11)
	addi	x11, x11, 32
	addi	x10, x10, 32
	bne	x11, x5, .LBB0_5
# %bb.6:                                # %axpy_mac_block_8.exit
	#APP
	#NO_APP
	lui	x11, 65555
	li	x12, 1
	lui	x10, %hi(y)
	addi	x10, x10, %lo(y)
	lui	x13, 528842
	sw	x12, 0(x11)
	addi	x8, x13, -571
	#APP
	#NO_APP
	lui	x11, 4096
	addi	x11, x11, 403
	addi	x12, x10, 2047
	addi	x12, x12, 1953
.LBB0_7:                                # %for.body.i5
                                        # =>This Inner Loop Header: Depth=1
	lw	x13, 0(x10)
	addi	x10, x10, 4
	xor	x13, x13, x8
	mul	x8, x13, x11
	bne	x10, x12, .LBB0_7
# %bb.8:                                # %bench_hash.exit
	lui	x10, %hi(.L.str.2)
	addi	x10, x10, %lo(.L.str.2)
	lui	x11, %hi(.L.str.1)
	addi	x11, x11, %lo(.L.str.1)
	mv	x12, x8
	call	printf
	lui	x13, 882066
	addi	x13, x13, -1562
	bne	x8, x13, .LBB0_10
# %bb.9:                                # %if.then2.i
	lui	x10, %hi(.L.str.4)
	addi	x10, x10, %lo(.L.str.4)
	lui	x11, %hi(.L.str.1)
	addi	x11, x11, %lo(.L.str.1)
	call	printf
	li	x10, 0
	j	.LBB0_11
.LBB0_10:                               # %if.end4.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.1)
	addi	x11, x11, %lo(.L.str.1)
	mv	x12, x8
	call	printf
	li	x10, 1
.LBB0_11:                               # %bench_report.exit
	lw	x1, 44(x2)                      # 4-byte Folded Reload
	lw	x8, 40(x2)                      # 4-byte Folded Reload
	lw	x18, 36(x2)                     # 4-byte Folded Reload
	lw	x19, 32(x2)                     # 4-byte Folded Reload
	lw	x20, 28(x2)                     # 4-byte Folded Reload
	lw	x21, 24(x2)                     # 4-byte Folded Reload
	lw	x22, 20(x2)                     # 4-byte Folded Reload
	lw	x23, 16(x2)                     # 4-byte Folded Reload
	lw	x24, 12(x2)                     # 4-byte Folded Reload
	lw	x25, 8(x2)                      # 4-byte Folded Reload
	lw	x26, 4(x2)                      # 4-byte Folded Reload
	lw	x27, 0(x2)                      # 4-byte Folded Reload
	addi	x2, x2, 48
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"axpy: y = a*x + y (N=%d) [repeat mac_block_8]\n"
	.size	.L.str, 47

	.type	y,@object                       # @y
	.local	y
	.comm	y,4000,4
	.type	x,@object                       # @x
	.local	x
	.comm	x,4000,4
	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"axpy"
	.size	.L.str.1, 5

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"BENCH %s checksum=0x%08x\n"
	.size	.L.str.2, 26

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	"PASS: %s checksum matches\n"
	.size	.L.str.4, 27

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"FAIL: %s checksum 0x%08x != expected 0x%08x\n"
	.size	.L.str.5, 45

	.ident	"clang version 22.1.8 (https://github.com/igabirondo16/llvm-project-22.git d5087d6b74df14fbf64ee88049d1ce9a2c66567d)"
	.section	".note.GNU-stack","",@progbits
