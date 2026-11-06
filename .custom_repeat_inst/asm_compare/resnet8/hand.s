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
	addi	x2, x2, -80
	sw	x1, 76(x2)                      # 4-byte Folded Spill
	sw	x8, 72(x2)                      # 4-byte Folded Spill
	sw	x9, 68(x2)                      # 4-byte Folded Spill
	sw	x18, 64(x2)                     # 4-byte Folded Spill
	sw	x19, 60(x2)                     # 4-byte Folded Spill
	sw	x20, 56(x2)                     # 4-byte Folded Spill
	sw	x21, 52(x2)                     # 4-byte Folded Spill
	sw	x22, 48(x2)                     # 4-byte Folded Spill
	sw	x23, 44(x2)                     # 4-byte Folded Spill
	sw	x24, 40(x2)                     # 4-byte Folded Spill
	sw	x25, 36(x2)                     # 4-byte Folded Spill
	sw	x26, 32(x2)                     # 4-byte Folded Spill
	sw	x27, 28(x2)                     # 4-byte Folded Spill
	lui	x10, 247535
	lui	x11, 406
	addi	x8, x10, 863
	addi	x18, x11, 1549
	lui	x10, %hi(.L.str)
	addi	x10, x10, %lo(.L.str)
	li	x11, 32
	li	x12, 32
	li	x13, 3
	li	x14, 16
	li	x15, 32
	li	x16, 64
	li	x17, 10
	call	printf
	li	x11, 0
	lui	x12, %hi(image)
	addi	x12, x12, %lo(image)
	lui	x10, %hi(lcg_state)
	addi	x13, x12, 428
	lw	x10, %lo(lcg_state)(x10)
	li	x14, 1
	li	x15, 408
	li	x16, 33
.LBB0_1:                                # %for.cond1.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	mul	x17, x11, x15
	add	x17, x17, x12
	addi	x17, x17, 812
	mv	x5, x13
.LBB0_2:                                # %for.cond5.preheader.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x18
	add	x10, x10, x8
	slli	x6, x10, 8
	mul	x10, x10, x18
	srli	x6, x6, 24
	add	x10, x10, x8
	addi	x6, x6, -128
	slli	x7, x10, 8
	mul	x10, x10, x18
	srli	x7, x7, 24
	add	x10, x10, x8
	addi	x7, x7, -128
	slli	x28, x10, 8
	srli	x28, x28, 24
	addi	x28, x28, -128
	sw	x6, -8(x5)
	sw	x7, -4(x5)
	sw	x28, 0(x5)
	addi	x5, x5, 12
	bne	x5, x17, .LBB0_2
# %bb.3:                                # %for.cond.cleanup3.i
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	x14, x14, 1
	addi	x13, x13, 408
	addi	x11, x11, 1
	bne	x14, x16, .LBB0_1
# %bb.4:                                # %for.body.i.i.preheader
	lui	x11, %hi(w_conv1)
	addi	x11, x11, %lo(w_conv1)
	lui	x12, 13
	addi	x12, x12, -819
	addi	x13, x11, 1728
.LBB0_5:                                # %for.body.i.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x12
	srli	x15, x15, 18
	slli	x16, x15, 2
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -2
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x13, .LBB0_5
# %bb.6:                                # %for.body.i53.i.preheader
	lui	x26, %hi(.L_MergedGlobals)
	addi	x26, x26, %lo(.L_MergedGlobals)
	lui	x11, 4
	addi	x12, x26, 80
	addi	x13, x11, -127
	addi	x11, x26, 144
.LBB0_7:                                # %for.body.i53.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x12)
	addi	x12, x12, 4
	bne	x12, x11, .LBB0_7
# %bb.8:                                # %for.body.i68.i.preheader
	lui	x12, %hi(w_s1a)
	addi	x12, x12, %lo(w_s1a)
	lui	x13, 13
	li	x14, 9
	addi	x13, x13, -819
	slli	x14, x14, 10
	add	x14, x12, x14
.LBB0_9:                                # %for.body.i68.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x12)
	addi	x12, x12, 4
	bne	x12, x14, .LBB0_9
# %bb.10:                               # %for.body.i83.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x12, x26, 208
.LBB0_11:                               # %for.body.i83.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x12, .LBB0_11
# %bb.12:                               # %for.body.i98.i.preheader
	lui	x11, %hi(w_s1b)
	addi	x11, x11, %lo(w_s1b)
	lui	x13, 13
	li	x14, 9
	addi	x13, x13, -819
	slli	x14, x14, 10
	add	x14, x11, x14
.LBB0_13:                               # %for.body.i98.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x11)
	addi	x11, x11, 4
	bne	x11, x14, .LBB0_13
# %bb.14:                               # %for.body.i113.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x11, x26, 272
.LBB0_15:                               # %for.body.i113.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x12)
	addi	x12, x12, 4
	bne	x12, x11, .LBB0_15
# %bb.16:                               # %fill.exit126.i
	lui	x13, %hi(lcg_state)
	lui	x12, %hi(w_s2a)
	addi	x12, x12, %lo(w_s2a)
	lui	x14, 13
	sw	x10, %lo(lcg_state)(x13)
	li	x15, 9
	addi	x13, x14, -819
	slli	x14, x15, 11
	add	x14, x12, x14
.LBB0_17:                               # %for.body.i128.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x12)
	addi	x12, x12, 4
	bne	x12, x14, .LBB0_17
# %bb.18:                               # %for.body.i143.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x12, x26, 400
.LBB0_19:                               # %for.body.i143.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x12, .LBB0_19
# %bb.20:                               # %for.body.i158.i.preheader
	lui	x11, %hi(w_s2b)
	addi	x11, x11, %lo(w_s2b)
	lui	x13, 13
	lui	x14, 9
	addi	x13, x13, -819
	add	x14, x11, x14
.LBB0_21:                               # %for.body.i158.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x11)
	addi	x11, x11, 4
	bne	x11, x14, .LBB0_21
# %bb.22:                               # %for.body.i173.i.preheader
	lui	x11, 4
	addi	x11, x11, -127
	addi	x13, x26, 528
.LBB0_23:                               # %for.body.i173.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x11
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x12)
	addi	x12, x12, 4
	bne	x12, x13, .LBB0_23
# %bb.24:                               # %for.body.i188.i.preheader
	lui	x11, %hi(w_s2p)
	addi	x11, x11, %lo(w_s2p)
	lui	x12, 13
	addi	x12, x12, -819
	addi	x14, x11, 2047
	addi	x14, x14, 1
.LBB0_25:                               # %for.body.i188.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x12
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x11)
	addi	x11, x11, 4
	bne	x11, x14, .LBB0_25
# %bb.26:                               # %for.body.i203.i.preheader
	lui	x12, 4
	addi	x12, x12, -127
	addi	x11, x26, 656
.LBB0_27:                               # %for.body.i203.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x12
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x13)
	addi	x13, x13, 4
	bne	x13, x11, .LBB0_27
# %bb.28:                               # %for.body.i218.i.preheader
	lui	x12, %hi(w_s3a)
	addi	x12, x12, %lo(w_s3a)
	lui	x13, 13
	lui	x14, 18
	addi	x13, x13, -819
	add	x14, x12, x14
.LBB0_29:                               # %for.body.i218.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x12)
	addi	x12, x12, 4
	bne	x12, x14, .LBB0_29
# %bb.30:                               # %for.body.i233.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x12, x26, 912
.LBB0_31:                               # %for.body.i233.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x12, .LBB0_31
# %bb.32:                               # %for.body.i248.i.preheader
	lui	x11, %hi(w_s3b)
	addi	x11, x11, %lo(w_s3b)
	lui	x13, 13
	lui	x14, 36
	addi	x13, x13, -819
	add	x14, x11, x14
.LBB0_33:                               # %for.body.i248.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x11)
	addi	x11, x11, 4
	bne	x11, x14, .LBB0_33
# %bb.34:                               # %for.body.i263.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x11, x26, 1168
.LBB0_35:                               # %for.body.i263.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x12)
	addi	x12, x12, 4
	bne	x12, x11, .LBB0_35
# %bb.36:                               # %for.body.i278.i.preheader
	lui	x12, %hi(w_s3p)
	addi	x12, x12, %lo(w_s3p)
	lui	x13, 13
	lui	x14, 2
	addi	x13, x13, -819
	add	x14, x12, x14
.LBB0_37:                               # %for.body.i278.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x12)
	addi	x12, x12, 4
	bne	x12, x14, .LBB0_37
# %bb.38:                               # %for.body.i293.i.preheader
	lui	x12, 4
	addi	x12, x12, -127
	addi	x17, x26, 1424
.LBB0_39:                               # %for.body.i293.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x13, x10, 16
	mul	x14, x13, x12
	srli	x14, x14, 21
	slli	x15, x14, 7
	sub	x13, x13, x14
	sub	x13, x13, x15
	slli	x13, x13, 16
	srli	x13, x13, 16
	addi	x13, x13, -64
	sw	x13, 0(x11)
	addi	x11, x11, 4
	bne	x11, x17, .LBB0_39
# %bb.40:                               # %for.body.i308.i.preheader
	lui	x11, %hi(w_fc)
	addi	x11, x11, %lo(w_fc)
	lui	x12, 13
	addi	x12, x12, -819
	addi	x13, x11, 2047
	addi	x13, x13, 513
.LBB0_41:                               # %for.body.i308.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x18
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x12
	srli	x15, x15, 18
	slli	x16, x15, 2
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -2
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x13, .LBB0_41
# %bb.42:                               # %fill.exit321.i
	sw	x17, 24(x2)                     # 4-byte Folded Spill
	li	x11, 0
	mul	x10, x10, x18
	lui	x12, 4
	lui	x13, 16
	lui	x14, %hi(lcg_state)
	add	x15, x10, x8
	addi	x12, x12, -127
	addi	x10, x13, -1
	srli	x13, x15, 16
	mul	x15, x15, x18
	mul	x16, x13, x12
	add	x15, x15, x8
	srli	x16, x16, 21
	srli	x17, x15, 16
	mul	x15, x15, x18
	slli	x5, x16, 7
	sub	x13, x13, x16
	mul	x16, x17, x12
	add	x15, x15, x8
	sub	x13, x13, x5
	srli	x16, x16, 21
	srli	x5, x15, 16
	mul	x15, x15, x18
	and	x13, x13, x10
	slli	x6, x16, 7
	sub	x16, x17, x16
	mul	x17, x5, x12
	add	x15, x15, x8
	addi	x13, x13, -64
	sub	x16, x16, x6
	srli	x17, x17, 21
	srli	x6, x15, 16
	mul	x15, x15, x18
	and	x16, x16, x10
	slli	x7, x17, 7
	sub	x17, x5, x17
	mul	x5, x6, x12
	add	x15, x15, x8
	addi	x16, x16, -64
	sub	x17, x17, x7
	srli	x5, x5, 21
	srli	x7, x15, 16
	mul	x15, x15, x18
	and	x17, x17, x10
	slli	x28, x5, 7
	sub	x5, x6, x5
	mul	x6, x7, x12
	add	x15, x15, x8
	addi	x17, x17, -64
	sub	x5, x5, x28
	srli	x6, x6, 21
	srli	x28, x15, 16
	mul	x15, x15, x18
	and	x5, x5, x10
	sub	x7, x7, x6
	slli	x6, x6, 7
	sub	x6, x7, x6
	mul	x7, x28, x12
	add	x15, x15, x8
	addi	x5, x5, -64
	srli	x7, x7, 21
	sw	x13, 40(x26)
	sw	x16, 44(x26)
	sw	x17, 48(x26)
	sw	x5, 52(x26)
	srli	x13, x15, 16
	mul	x15, x15, x18
	sub	x16, x28, x7
	slli	x7, x7, 7
	sub	x16, x16, x7
	mul	x17, x13, x12
	add	x15, x15, x8
	srli	x17, x17, 21
	sub	x13, x13, x17
	slli	x17, x17, 7
	sub	x17, x13, x17
	srli	x13, x15, 16
	mul	x15, x15, x18
	add	x15, x15, x8
	mul	x5, x15, x18
	add	x5, x5, x8
	mul	x7, x13, x12
	srli	x7, x7, 21
	sub	x13, x13, x7
	slli	x7, x7, 7
	sub	x7, x13, x7
	lui	x13, %hi(w_conv1)
	addi	x13, x13, %lo(w_conv1)
	srli	x15, x15, 16
	sw	x5, %lo(lcg_state)(x14)
	mul	x14, x15, x12
	srli	x14, x14, 21
	sub	x15, x15, x14
	slli	x14, x14, 7
	sub	x28, x15, x14
	lui	x14, %hi(w_conv1_flat)
	addi	x14, x14, %lo(w_conv1_flat)
	and	x15, x6, x10
	addi	x15, x15, -64
	and	x16, x16, x10
	addi	x16, x16, -64
	and	x17, x17, x10
	addi	x17, x17, -64
	and	x6, x7, x10
	addi	x6, x6, -64
	sw	x15, 56(x26)
	sw	x16, 60(x26)
	sw	x17, 64(x26)
	sw	x6, 68(x26)
	li	x15, 26
	srli	x16, x5, 16
	mul	x12, x16, x12
	srli	x12, x12, 21
	sub	x16, x16, x12
	slli	x12, x12, 7
	sub	x16, x16, x12
	li	x12, 32
	and	x17, x28, x10
	addi	x17, x17, -64
	and	x10, x16, x10
	addi	x10, x10, -64
	sw	x17, 72(x26)
	sw	x10, 76(x26)
	li	x10, 16
	j	.LBB0_44
.LBB0_43:                               # %for.cond.cleanup27.i
                                        #   in Loop: Header=BB0_44 Depth=1
	addi	x11, x11, 1
	addi	x13, x13, 108
	addi	x14, x14, 128
	beq	x11, x10, .LBB0_49
.LBB0_44:                               # %for.body20.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_47 Depth 2
	li	x16, 0
	mv	x17, x14
	mv	x5, x13
	j	.LBB0_47
.LBB0_45:                               # %cond.true.i
                                        #   in Loop: Header=BB0_47 Depth=2
	lw	x6, 0(x5)
.LBB0_46:                               # %cond.end.i
                                        #   in Loop: Header=BB0_47 Depth=2
	sw	x6, 0(x17)
	addi	x16, x16, 1
	addi	x5, x5, 4
	addi	x17, x17, 4
	beq	x16, x12, .LBB0_43
.LBB0_47:                               # %for.body28.i
                                        #   Parent Loop BB0_44 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	bgeu	x15, x16, .LBB0_45
# %bb.48:                               #   in Loop: Header=BB0_47 Depth=2
	li	x6, 0
	j	.LBB0_46
.LBB0_49:                               # %init_data.exit
	#APP
	#NO_APP
	lui	x21, 65555
	sw	x0, 0(x21)
	#APP
	#NO_APP
	li	x22, 1
	li	x9, 32
	addi	x15, x26, 80
	lui	x10, %hi(image)
	addi	x10, x10, %lo(image)
	lui	x13, %hi(w_conv1)
	addi	x13, x13, %lo(w_conv1)
	lui	x14, %hi(w_conv1_flat)
	addi	x14, x14, %lo(w_conv1_flat)
	lui	x8, %hi(x1)
	addi	x8, x8, %lo(x1)
	li	x24, 16
	li	x11, 34
	li	x12, 3
	li	x16, 16
	li	x17, 3
	li	x28, 1
	li	x29, 3
	li	x31, 34
	sw	x9, 0(x2)
	sw	x0, 4(x2)
	sw	x22, 8(x2)
	li	x25, 3
	mv	x30, x8
	call	conv
	#APP
	#NO_APP
	sw	x22, 0(x21)
	#APP
	#NO_APP
	sw	x9, 0(x2)
	sw	x0, 4(x2)
	sw	x22, 8(x2)
	addi	x15, x26, 144
	lui	x13, %hi(w_s1a)
	addi	x13, x13, %lo(w_s1a)
	lui	x18, %hi(a1)
	addi	x18, x18, %lo(a1)
	li	x11, 34
	li	x12, 16
	li	x16, 16
	li	x17, 3
	li	x28, 1
	li	x29, 4
	li	x31, 34
	li	x23, 4
	mv	x10, x8
	li	x14, 0
	mv	x30, x18
	call	conv
	addi	x15, x26, 208
	lui	x13, %hi(w_s1b)
	addi	x13, x13, %lo(w_s1b)
	lui	x20, %hi(y1)
	addi	x20, x20, %lo(y1)
	li	x11, 34
	li	x12, 16
	li	x16, 16
	li	x17, 3
	li	x28, 1
	li	x29, 4
	li	x31, 34
	sw	x9, 0(x2)
	sw	x8, 4(x2)
	sw	x22, 8(x2)
	mv	x10, x18
	li	x14, 0
	mv	x30, x20
	call	conv
	#APP
	#NO_APP
	li	x10, 2
	sw	x10, 0(x21)
	#APP
	#NO_APP
	addi	x15, x26, 272
	lui	x13, %hi(w_s2a)
	addi	x13, x13, %lo(w_s2a)
	lui	x18, %hi(a2)
	addi	x18, x18, %lo(a2)
	li	x11, 34
	li	x12, 16
	li	x16, 32
	li	x17, 3
	li	x28, 2
	li	x29, 4
	li	x31, 18
	sw	x24, 0(x2)
	sw	x0, 4(x2)
	sw	x22, 8(x2)
	mv	x10, x20
	li	x14, 0
	mv	x30, x18
	call	conv
	addi	x15, x26, 528
	lui	x13, %hi(w_s2p)
	addi	x13, x13, %lo(w_s2p)
	lui	x19, %hi(p2)
	addi	x19, x19, %lo(p2)
	li	x11, 34
	li	x12, 16
	li	x16, 32
	li	x17, 1
	li	x28, 2
	li	x29, 3
	li	x31, 18
	sw	x24, 0(x2)
	sw	x0, 4(x2)
	sw	x0, 8(x2)
	mv	x10, x20
	li	x14, 0
	mv	x30, x19
	call	conv
	addi	x15, x26, 400
	lui	x13, %hi(w_s2b)
	addi	x13, x13, %lo(w_s2b)
	lui	x8, %hi(y2)
	addi	x8, x8, %lo(y2)
	li	x11, 18
	li	x12, 32
	li	x16, 32
	li	x17, 3
	li	x28, 1
	li	x29, 4
	li	x31, 18
	sw	x24, 0(x2)
	sw	x19, 4(x2)
	sw	x22, 8(x2)
	mv	x10, x18
	li	x14, 0
	mv	x30, x8
	call	conv
	#APP
	#NO_APP
	sw	x25, 0(x21)
	#APP
	#NO_APP
	li	x9, 8
	addi	x15, x26, 656
	lui	x13, %hi(w_s3a)
	addi	x13, x13, %lo(w_s3a)
	lui	x19, %hi(a3)
	addi	x19, x19, %lo(a3)
	li	x11, 18
	li	x12, 32
	li	x16, 64
	li	x17, 3
	li	x28, 2
	li	x29, 4
	li	x31, 10
	sw	x9, 0(x2)
	sw	x0, 4(x2)
	sw	x22, 8(x2)
	mv	x10, x8
	li	x14, 0
	mv	x30, x19
	call	conv
	addi	x15, x26, 1168
	lui	x13, %hi(w_s3p)
	addi	x13, x13, %lo(w_s3p)
	lui	x18, %hi(p3)
	addi	x18, x18, %lo(p3)
	li	x11, 18
	li	x12, 32
	li	x16, 64
	li	x17, 1
	li	x28, 2
	li	x29, 3
	li	x31, 10
	sw	x9, 0(x2)
	sw	x0, 4(x2)
	sw	x0, 8(x2)
	mv	x10, x8
	li	x14, 0
	mv	x30, x18
	call	conv
	addi	x15, x26, 912
	lui	x13, %hi(w_s3b)
	addi	x13, x13, %lo(w_s3b)
	lui	x8, %hi(y3)
	addi	x8, x8, %lo(y3)
	li	x11, 10
	li	x12, 64
	li	x16, 64
	li	x17, 3
	li	x28, 1
	li	x29, 5
	li	x31, 10
	sw	x9, 0(x2)
	sw	x18, 4(x2)
	sw	x22, 8(x2)
	mv	x10, x19
	li	x14, 0
	mv	x30, x8
	call	conv
	li	x10, 0
	#APP
	#NO_APP
	sw	x23, 0(x21)
	li	x13, 11
	#APP
	#NO_APP
	lui	x14, 3
	lui	x12, 4
	lui	x16, 5
	li	x17, 256
.LBB0_50:                               # %for.cond1.preheader.i7
                                        # =>This Inner Loop Header: Depth=1
	add	x5, x8, x10
	slli	x7, x13, 10
	addi	x28, x14, 768
	addi	x18, x5, 2047
	lui	x31, 1
	add	x31, x5, x31
	lui	x30, 2
	add	x30, x5, x30
	add	x7, x5, x7
	add	x28, x5, x28
	add	x6, x5, x12
	add	x29, x5, x16
	addi	x9, x18, 769
	lw	x19, 769(x18)
	lw	x18, 1025(x18)
	lw	x20, 1280(x31)
	lw	x21, 1536(x31)
	lw	x22, -1536(x30)
	lw	x23, -1280(x30)
	lw	x24, 512(x30)
	lw	x25, 768(x30)
	mv	x15, x26
	lw	x26, -256(x7)
	lw	x27, 0(x7)
	lw	x1, 512(x28)
	lw	x11, 768(x28)
	add	x18, x18, x19
	lw	x19, 0(x6)
	add	x20, x20, x21
	lw	x21, 256(x6)
	add	x22, x22, x23
	lw	x23, -1024(x29)
	add	x24, x24, x25
	lw	x25, -768(x29)
	add	x26, x26, x27
	lw	x27, 512(x9)
	add	x11, x1, x11
	lw	x1, 768(x9)
	add	x19, x19, x21
	lw	x21, 1024(x9)
	add	x23, x23, x25
	lw	x25, 1280(x9)
	add	x18, x18, x27
	lw	x27, 1536(x9)
	lw	x31, 1792(x31)
	add	x21, x1, x21
	lw	x1, -1024(x30)
	add	x25, x25, x27
	lw	x27, 1024(x30)
	add	x20, x20, x31
	lw	x31, 256(x7)
	add	x22, x22, x1
	lw	x1, 1024(x28)
	add	x24, x24, x27
	lw	x27, 512(x6)
	add	x26, x26, x31
	add	x11, x11, x1
	lw	x1, -512(x29)
	add	x19, x19, x27
	slli	x31, x13, 11
	add	x31, x5, x31
	lw	x9, 1792(x9)
	add	x23, x23, x1
	lw	x27, -2048(x30)
	add	x18, x18, x21
	lw	x21, -256(x30)
	add	x9, x25, x9
	lw	x25, 1280(x30)
	add	x20, x20, x27
	lw	x27, 512(x7)
	add	x21, x22, x21
	lw	x22, 1280(x28)
	add	x24, x24, x25
	lw	x25, 768(x6)
	add	x26, x26, x27
	lw	x27, -1792(x31)
	add	x11, x11, x22
	add	x19, x19, x25
	lw	x22, -1792(x30)
	add	x23, x23, x27
	lw	x25, 0(x30)
	add	x9, x18, x9
	lw	x18, 1536(x30)
	add	x20, x20, x22
	lw	x22, 768(x7)
	add	x21, x21, x25
	lw	x25, 1536(x28)
	add	x18, x24, x18
	add	x22, x26, x22
	mv	x26, x15
	lw	x24, 1024(x6)
	add	x11, x11, x25
	lw	x25, -1536(x31)
	lw	x30, 256(x30)
	add	x19, x19, x24
	lw	x24, -768(x7)
	add	x23, x23, x25
	lw	x25, 1024(x7)
	add	x9, x9, x20
	lw	x20, 1792(x28)
	add	x30, x21, x30
	lw	x21, 1792(x6)
	add	x18, x18, x24
	lw	x24, -1280(x31)
	add	x22, x22, x25
	add	x11, x11, x20
	add	x19, x19, x21
	add	x23, x23, x24
	lw	x7, -512(x7)
	lw	x28, 0(x28)
	add	x30, x9, x30
	lw	x9, -768(x6)
	add	x7, x18, x7
	lw	x18, -2048(x29)
	add	x28, x22, x28
	add	x11, x11, x9
	lw	x9, -1024(x31)
	add	x18, x19, x18
	add	x5, x5, x14
	lw	x5, 1024(x5)
	add	x9, x23, x9
	lw	x19, -512(x6)
	add	x7, x30, x7
	lw	x30, -1792(x29)
	add	x5, x28, x5
	lw	x28, -768(x31)
	add	x11, x11, x19
	add	x30, x18, x30
	lw	x6, -256(x6)
	add	x28, x9, x28
	lw	x9, -1536(x29)
	add	x5, x7, x5
	lw	x7, -512(x31)
	add	x11, x11, x6
	add	x30, x30, x9
	lw	x6, -1280(x29)
	add	x7, x28, x7
	lw	x28, -256(x31)
	add	x11, x5, x11
	add	x6, x30, x6
	lw	x5, 0(x31)
	add	x7, x7, x28
	add	x28, x15, x10
	add	x11, x11, x6
	add	x5, x7, x5
	add	x11, x11, x5
	srai	x5, x11, 31
	srli	x5, x5, 26
	add	x11, x11, x5
	srai	x11, x11, 6
	addi	x10, x10, 4
	sw	x11, 1424(x28)
	bne	x10, x17, .LBB0_50
# %bb.51:                               # %for.body21.i.preheader
	li	x10, 0
	lui	x11, %hi(w_fc)
	addi	x11, x11, %lo(w_fc)
	li	x12, 4
	li	x13, 7
	li	x14, 56
.LBB0_52:                               # %for.body21.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_53 Depth 2
	slli	x5, x10, 2
	add	x5, x26, x5
	lw	x6, 40(x5)
	li	x7, -8
	mv	x1, x11
	lw	x9, 24(x2)                      # 4-byte Folded Reload
.LBB0_53:                               # %for.body26.i
                                        #   Parent Loop BB0_52 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	lw	x24, 0(x1)
	.insn r 91, 0, 8, x0, x12, x13
	#NO_APP
	addi	x7, x7, 8
	#APP
	lw	x16, 0(x9)
	.insn r 91, 0, 8, x0, x12, x13
	#NO_APP
	addi	x9, x9, 32
	#APP
	.insn r4 11, 0, 0, x6, x24, x16, x6
	.insn r 91, 0, 48, x0, x0, x13
	#NO_APP
	addi	x1, x1, 32
	bltu	x7, x14, .LBB0_53
# %bb.54:                               # %for.cond.cleanup25.i
                                        #   in Loop: Header=BB0_52 Depth=1
	sw	x6, 0(x5)
	addi	x10, x10, 1
	addi	x11, x11, 256
	mv	x26, x15
	li	x16, 10
	bne	x10, x16, .LBB0_52
# %bb.55:                               # %resnet8.exit
	#APP
	#NO_APP
	lui	x10, 65555
	li	x11, 5
	sw	x11, 0(x10)
	#APP
	#NO_APP
	lw	x10, 0(x26)
	lw	x11, 4(x26)
	lw	x12, 8(x26)
	slt	x11, x10, x11
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_57
# %bb.56:                               # %resnet8.exit
	li	x11, 2
.LBB0_57:                               # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x12, 12(x26)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_59
# %bb.58:                               # %resnet8.exit
	li	x11, 3
.LBB0_59:                               # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x12, 16(x26)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_61
# %bb.60:                               # %resnet8.exit
	li	x11, 4
.LBB0_61:                               # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x12, 20(x26)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_63
# %bb.62:                               # %resnet8.exit
	li	x11, 5
.LBB0_63:                               # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x12, 24(x26)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_65
# %bb.64:                               # %resnet8.exit
	li	x11, 6
.LBB0_65:                               # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x12, 28(x26)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_67
# %bb.66:                               # %resnet8.exit
	li	x11, 7
.LBB0_67:                               # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x12, 32(x26)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_69
# %bb.68:                               # %resnet8.exit
	li	x11, 8
.LBB0_69:                               # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x26, x10
	lw	x12, 36(x26)
	lw	x13, 0(x10)
	lui	x10, 4096
	bge	x13, x12, .LBB0_71
# %bb.70:                               # %resnet8.exit
	li	x11, 9
.LBB0_71:                               # %resnet8.exit
	addi	x9, x10, 403
	lui	x10, %hi(.L.str.1)
	addi	x10, x10, %lo(.L.str.1)
	call	printf
	lui	x10, 528842
	li	x11, 25
	addi	x10, x10, -571
	slli	x11, x11, 10
	add	x11, x8, x11
.LBB0_72:                               # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	lw	x12, 0(x8)
	addi	x8, x8, 4
	xor	x10, x12, x10
	mul	x10, x10, x9
	bne	x8, x11, .LBB0_72
# %bb.73:                               # %for.body.i12.preheader
	lw	x11, 0(x26)
	lw	x12, 4(x26)
	lw	x13, 8(x26)
	lw	x14, 12(x26)
	xor	x10, x11, x10
	mul	x10, x10, x9
	xor	x10, x12, x10
	mul	x10, x10, x9
	xor	x10, x13, x10
	mul	x10, x10, x9
	xor	x10, x14, x10
	lw	x11, 16(x26)
	lw	x12, 20(x26)
	lw	x13, 24(x26)
	lw	x14, 28(x26)
	mul	x10, x10, x9
	xor	x10, x11, x10
	mul	x10, x10, x9
	xor	x10, x12, x10
	mul	x10, x10, x9
	xor	x10, x13, x10
	lw	x11, 32(x26)
	mul	x10, x10, x9
	xor	x10, x14, x10
	lw	x12, 36(x26)
	mul	x10, x10, x9
	xor	x10, x11, x10
	mul	x10, x10, x9
	xor	x10, x12, x10
	mul	x8, x10, x9
	lui	x10, %hi(.L.str.3)
	addi	x10, x10, %lo(.L.str.3)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	lui	x13, 170287
	addi	x13, x13, 1822
	bne	x8, x13, .LBB0_75
# %bb.74:                               # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x10, 0
	j	.LBB0_76
.LBB0_75:                               # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	li	x10, 1
.LBB0_76:                               # %bench_report.exit
	lw	x1, 76(x2)                      # 4-byte Folded Reload
	lw	x8, 72(x2)                      # 4-byte Folded Reload
	lw	x9, 68(x2)                      # 4-byte Folded Reload
	lw	x18, 64(x2)                     # 4-byte Folded Reload
	lw	x19, 60(x2)                     # 4-byte Folded Reload
	lw	x20, 56(x2)                     # 4-byte Folded Reload
	lw	x21, 52(x2)                     # 4-byte Folded Reload
	lw	x22, 48(x2)                     # 4-byte Folded Reload
	lw	x23, 44(x2)                     # 4-byte Folded Reload
	lw	x24, 40(x2)                     # 4-byte Folded Reload
	lw	x25, 36(x2)                     # 4-byte Folded Reload
	lw	x26, 32(x2)                     # 4-byte Folded Reload
	lw	x27, 28(x2)                     # 4-byte Folded Reload
	addi	x2, x2, 80
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.option	push
	.option	arch, +m, +zmmul
	.p2align	2                               # -- Begin function conv
	.type	conv,@function
conv:                                   # @conv
# %bb.0:                                # %entry
	addi	x2, x2, -176
	sw	x1, 172(x2)                     # 4-byte Folded Spill
	sw	x8, 168(x2)                     # 4-byte Folded Spill
	sw	x9, 164(x2)                     # 4-byte Folded Spill
	sw	x18, 160(x2)                    # 4-byte Folded Spill
	sw	x19, 156(x2)                    # 4-byte Folded Spill
	sw	x20, 152(x2)                    # 4-byte Folded Spill
	sw	x21, 148(x2)                    # 4-byte Folded Spill
	sw	x22, 144(x2)                    # 4-byte Folded Spill
	sw	x23, 140(x2)                    # 4-byte Folded Spill
	sw	x24, 136(x2)                    # 4-byte Folded Spill
	sw	x25, 132(x2)                    # 4-byte Folded Spill
	sw	x26, 128(x2)                    # 4-byte Folded Spill
	sw	x27, 124(x2)                    # 4-byte Folded Spill
	sw	x31, 8(x2)                      # 4-byte Folded Spill
	sw	x30, 28(x2)                     # 4-byte Folded Spill
	sw	x29, 64(x2)                     # 4-byte Folded Spill
	mv	x8, x17
	sw	x16, 80(x2)                     # 4-byte Folded Spill
	sw	x15, 60(x2)                     # 4-byte Folded Spill
	sw	x14, 24(x2)                     # 4-byte Folded Spill
	sw	x13, 20(x2)                     # 4-byte Folded Spill
	mv	x17, x11
	mv	x16, x10
	lw	x10, 184(x2)
	addi	x13, x8, -1
	andi	x11, x12, 7
	sw	x11, 76(x2)                     # 4-byte Folded Spill
	mul	x14, x8, x12
	lui	x15, 1
	addi	x5, x17, 1
	mul	x7, x28, x12
	mul	x28, x12, x17
	slli	x11, x12, 2
	mul	x29, x8, x8
	li	x1, 4
	li	x6, 7
	seqz	x13, x13
	mul	x5, x12, x5
	mul	x13, x5, x13
	mul	x5, x14, x8
	addi	x15, x15, -8
	mul	x17, x7, x17
	slli	x7, x7, 2
	sw	x7, 16(x2)                      # 4-byte Folded Spill
	slli	x28, x28, 2
	sw	x28, 108(x2)                    # 4-byte Folded Spill
	mul	x7, x29, x12
	slli	x14, x14, 2
	sw	x14, 100(x2)                    # 4-byte Folded Spill
	addi	x5, x5, 7
	slli	x17, x17, 2
	sw	x17, 4(x2)                      # 4-byte Folded Spill
	slli	x7, x7, 2
	sw	x7, 56(x2)                      # 4-byte Folded Spill
	and	x15, x5, x15
	slli	x13, x13, 2
	slli	x5, x5, 2
	snez	x10, x10
	add	x31, x16, x13
	li	x13, 0
	andi	x14, x5, -32
	sw	x14, 52(x2)                     # 4-byte Folded Spill
	addi	x10, x10, -1
	andi	x10, x10, -128
	sw	x10, 48(x2)                     # 4-byte Folded Spill
	lui	x30, %hi(patch)
	addi	x30, x30, %lo(patch)
	sw	x15, 104(x2)                    # 4-byte Folded Spill
	j	.LBB1_2
.LBB1_1:                                # %for.cond.cleanup9
                                        #   in Loop: Header=BB1_2 Depth=1
	lw	x10, 4(x2)                      # 4-byte Folded Reload
	add	x31, x31, x10
	lw	x13, 12(x2)                     # 4-byte Folded Reload
	lw	x10, 176(x2)
	beq	x13, x10, .LBB1_31
.LBB1_2:                                # %for.cond6.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_4 Depth 2
                                        #       Child Loop BB1_6 Depth 3
                                        #         Child Loop BB1_7 Depth 4
                                        #           Child Loop BB1_8 Depth 5
                                        #       Child Loop BB1_12 Depth 3
                                        #       Child Loop BB1_15 Depth 3
                                        #         Child Loop BB1_17 Depth 4
                                        #         Child Loop BB1_19 Depth 4
                                        #           Child Loop BB1_20 Depth 5
                                        #             Child Loop BB1_21 Depth 6
	sw	x0, 36(x2)                      # 4-byte Folded Spill
	addi	x13, x13, 1
	lw	x10, 8(x2)                      # 4-byte Folded Reload
	sw	x13, 12(x2)                     # 4-byte Folded Spill
	mul	x10, x13, x10
	sw	x10, 32(x2)                     # 4-byte Folded Spill
	sw	x31, 40(x2)                     # 4-byte Folded Spill
	sw	x31, 68(x2)                     # 4-byte Folded Spill
	j	.LBB1_4
.LBB1_3:                                # %for.cond6.loopexit
                                        #   in Loop: Header=BB1_4 Depth=2
	lw	x10, 16(x2)                     # 4-byte Folded Reload
	lw	x13, 40(x2)                     # 4-byte Folded Reload
	add	x13, x13, x10
	sw	x13, 40(x2)                     # 4-byte Folded Spill
	lw	x10, 176(x2)
	lw	x13, 36(x2)                     # 4-byte Folded Reload
	beq	x13, x10, .LBB1_1
.LBB1_4:                                # %for.body10
                                        #   Parent Loop BB1_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_6 Depth 3
                                        #         Child Loop BB1_7 Depth 4
                                        #           Child Loop BB1_8 Depth 5
                                        #       Child Loop BB1_12 Depth 3
                                        #       Child Loop BB1_15 Depth 3
                                        #         Child Loop BB1_17 Depth 4
                                        #         Child Loop BB1_19 Depth 4
                                        #           Child Loop BB1_20 Depth 5
                                        #             Child Loop BB1_21 Depth 6
	lw	x10, 76(x2)                     # 4-byte Folded Reload
	beqz	x10, .LBB1_13
# %bb.5:                                # %for.cond23.preheader.preheader
                                        #   in Loop: Header=BB1_4 Depth=2
	li	x13, 0
	li	x10, 0
	lw	x14, 40(x2)                     # 4-byte Folded Reload
.LBB1_6:                                # %for.cond23.preheader
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB1_7 Depth 4
                                        #           Child Loop BB1_8 Depth 5
	li	x15, 0
	slli	x16, x10, 2
	add	x16, x11, x16
	mv	x17, x14
.LBB1_7:                                # %for.cond28.preheader
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        #       Parent Loop BB1_6 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB1_8 Depth 5
	mul	x5, x11, x15
	slli	x7, x10, 2
	add	x28, x16, x5
	add	x5, x30, x7
	add	x7, x30, x28
	add	x10, x12, x10
	mv	x28, x17
.LBB1_8:                                # %for.body32
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        #       Parent Loop BB1_6 Depth=3
                                        #         Parent Loop BB1_7 Depth=4
                                        # =>        This Inner Loop Header: Depth=5
	lw	x29, 0(x28)
	sw	x29, 0(x5)
	addi	x5, x5, 4
	addi	x28, x28, 4
	bne	x5, x7, .LBB1_8
# %bb.9:                                # %for.cond.cleanup31
                                        #   in Loop: Header=BB1_7 Depth=4
	addi	x15, x15, 1
	add	x17, x17, x11
	bne	x15, x8, .LBB1_7
# %bb.10:                               # %for.cond.cleanup26
                                        #   in Loop: Header=BB1_6 Depth=3
	addi	x13, x13, 1
	lw	x15, 108(x2)                    # 4-byte Folded Reload
	add	x14, x14, x15
	bne	x13, x8, .LBB1_6
# %bb.11:                               # %for.cond45.preheader
                                        #   in Loop: Header=BB1_4 Depth=2
	lw	x15, 104(x2)                    # 4-byte Folded Reload
	bgeu	x10, x15, .LBB1_13
.LBB1_12:                               # %for.body48
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	slli	x13, x10, 2
	add	x13, x30, x13
	addi	x10, x10, 1
	sw	x0, 0(x13)
	bltu	x10, x15, .LBB1_12
.LBB1_13:                               # %if.end
                                        #   in Loop: Header=BB1_4 Depth=2
	li	x16, 0
	lw	x10, 36(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 1
	sw	x10, 36(x2)                     # 4-byte Folded Spill
	lw	x13, 32(x2)                     # 4-byte Folded Reload
	add	x10, x10, x13
	lw	x13, 80(x2)                     # 4-byte Folded Reload
	mul	x10, x10, x13
	slli	x10, x10, 2
	lw	x13, 180(x2)
	add	x13, x13, x10
	sw	x13, 44(x2)                     # 4-byte Folded Spill
	lw	x13, 28(x2)                     # 4-byte Folded Reload
	add	x10, x13, x10
	sw	x10, 72(x2)                     # 4-byte Folded Spill
	lw	x7, 20(x2)                      # 4-byte Folded Reload
	lw	x14, 24(x2)                     # 4-byte Folded Reload
	j	.LBB1_15
.LBB1_14:                               # %if.end156
                                        #   in Loop: Header=BB1_15 Depth=3
	lw	x10, 72(x2)                     # 4-byte Folded Reload
	add	x10, x10, x17
	addi	x16, x16, 1
	lw	x14, 52(x2)                     # 4-byte Folded Reload
	lw	x17, 88(x2)                     # 4-byte Folded Reload
	add	x14, x17, x14
	sw	x13, 0(x10)
	lw	x10, 56(x2)                     # 4-byte Folded Reload
	lw	x7, 92(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x10, 80(x2)                     # 4-byte Folded Reload
	beq	x16, x10, .LBB1_3
.LBB1_15:                               # %for.body62
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB1_17 Depth 4
                                        #         Child Loop BB1_19 Depth 4
                                        #           Child Loop BB1_20 Depth 5
                                        #             Child Loop BB1_21 Depth 6
	sw	x16, 96(x2)                     # 4-byte Folded Spill
	slli	x16, x16, 2
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	sw	x16, 84(x2)                     # 4-byte Folded Spill
	add	x10, x10, x16
	lw	x9, 0(x10)
	lw	x10, 76(x2)                     # 4-byte Folded Reload
	sw	x7, 92(x2)                      # 4-byte Folded Spill
	sw	x14, 88(x2)                     # 4-byte Folded Spill
	beqz	x10, .LBB1_18
# %bb.16:                               # %for.body126.preheader
                                        #   in Loop: Header=BB1_15 Depth=3
	li	x10, 0
	mv	x13, x14
	mv	x14, x30
.LBB1_17:                               # %for.body126
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#APP
	lw	x24, 0(x13)
	.insn r 91, 0, 8, x0, x1, x6
	#NO_APP
	addi	x10, x10, 8
	#APP
	lw	x16, 0(x14)
	.insn r 91, 0, 8, x0, x1, x6
	#NO_APP
	addi	x14, x14, 32
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x6
	#NO_APP
	addi	x13, x13, 32
	bltu	x10, x15, .LBB1_17
	j	.LBB1_24
.LBB1_18:                               # %if.then65
                                        #   in Loop: Header=BB1_15 Depth=3
	li	x14, 0
	lw	x13, 40(x2)                     # 4-byte Folded Reload
.LBB1_19:                               # %for.cond75.preheader
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB1_20 Depth 5
                                        #             Child Loop BB1_21 Depth 6
	sw	x14, 120(x2)                    # 4-byte Folded Spill
	li	x5, 0
	sw	x7, 116(x2)                     # 4-byte Folded Spill
	sw	x13, 112(x2)                    # 4-byte Folded Spill
	mv	x15, x13
.LBB1_20:                               # %for.body79
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        #         Parent Loop BB1_19 Depth=4
                                        # =>        This Loop Header: Depth=5
                                        #             Child Loop BB1_21 Depth 6
	li	x10, 0
	mv	x13, x7
	mv	x14, x15
.LBB1_21:                               # %for.body92
                                        #   Parent Loop BB1_2 Depth=1
                                        #     Parent Loop BB1_4 Depth=2
                                        #       Parent Loop BB1_15 Depth=3
                                        #         Parent Loop BB1_19 Depth=4
                                        #           Parent Loop BB1_20 Depth=5
                                        # =>          This Inner Loop Header: Depth=6
	#APP
	lw	x24, 0(x13)
	.insn r 91, 0, 8, x0, x1, x6
	#NO_APP
	addi	x10, x10, 8
	#APP
	lw	x16, 0(x14)
	.insn r 91, 0, 8, x0, x1, x6
	#NO_APP
	addi	x14, x14, 32
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x6
	#NO_APP
	addi	x13, x13, 32
	bltu	x10, x12, .LBB1_21
# %bb.22:                               # %for.cond.cleanup91
                                        #   in Loop: Header=BB1_20 Depth=5
	addi	x5, x5, 1
	add	x15, x15, x11
	add	x7, x7, x11
	bne	x5, x8, .LBB1_20
# %bb.23:                               # %for.cond.cleanup78
                                        #   in Loop: Header=BB1_19 Depth=4
	lw	x14, 120(x2)                    # 4-byte Folded Reload
	addi	x14, x14, 1
	lw	x10, 108(x2)                    # 4-byte Folded Reload
	lw	x13, 112(x2)                    # 4-byte Folded Reload
	add	x13, x13, x10
	lw	x10, 100(x2)                    # 4-byte Folded Reload
	lw	x7, 116(x2)                     # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x15, 104(x2)                    # 4-byte Folded Reload
	bne	x14, x8, .LBB1_19
.LBB1_24:                               # %if.end150
                                        #   in Loop: Header=BB1_15 Depth=3
	lw	x10, 64(x2)                     # 4-byte Folded Reload
	sra	x10, x9, x10
	lw	x13, 180(x2)
	beqz	x13, .LBB1_26
# %bb.25:                               # %if.then152
                                        #   in Loop: Header=BB1_15 Depth=3
	lw	x13, 44(x2)                     # 4-byte Folded Reload
	lw	x17, 84(x2)                     # 4-byte Folded Reload
	add	x13, x13, x17
	lw	x13, 0(x13)
	add	x10, x13, x10
	j	.LBB1_27
.LBB1_26:                               #   in Loop: Header=BB1_15 Depth=3
	lw	x17, 84(x2)                     # 4-byte Folded Reload
.LBB1_27:                               # %if.end156
                                        #   in Loop: Header=BB1_15 Depth=3
	lw	x14, 48(x2)                     # 4-byte Folded Reload
	mv	x13, x14
	lw	x31, 68(x2)                     # 4-byte Folded Reload
	lw	x16, 96(x2)                     # 4-byte Folded Reload
	blt	x10, x14, .LBB1_29
# %bb.28:                               # %if.end156
                                        #   in Loop: Header=BB1_15 Depth=3
	mv	x13, x10
.LBB1_29:                               # %if.end156
                                        #   in Loop: Header=BB1_15 Depth=3
	li	x10, 127
	lui	x30, %hi(patch)
	addi	x30, x30, %lo(patch)
	blt	x13, x10, .LBB1_14
# %bb.30:                               # %if.end156
                                        #   in Loop: Header=BB1_15 Depth=3
	li	x13, 127
	j	.LBB1_14
.LBB1_31:                               # %for.cond.cleanup
	lw	x1, 172(x2)                     # 4-byte Folded Reload
	lw	x8, 168(x2)                     # 4-byte Folded Reload
	lw	x9, 164(x2)                     # 4-byte Folded Reload
	lw	x18, 160(x2)                    # 4-byte Folded Reload
	lw	x19, 156(x2)                    # 4-byte Folded Reload
	lw	x20, 152(x2)                    # 4-byte Folded Reload
	lw	x21, 148(x2)                    # 4-byte Folded Reload
	lw	x22, 144(x2)                    # 4-byte Folded Reload
	lw	x23, 140(x2)                    # 4-byte Folded Reload
	lw	x24, 136(x2)                    # 4-byte Folded Reload
	lw	x25, 132(x2)                    # 4-byte Folded Reload
	lw	x26, 128(x2)                    # 4-byte Folded Reload
	lw	x27, 124(x2)                    # 4-byte Folded Reload
	addi	x2, x2, 176
	ret
.Lfunc_end1:
	.size	conv, .Lfunc_end1-conv
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"resnet8: ResNet-8 forward pass (IMG=%dx%dx%d FILTERS=%d/%d/%d CLASSES=%d) [repeat_8]\n"
	.size	.L.str, 86

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"argmax class: %u\n"
	.size	.L.str.1, 18

	.type	y3,@object                      # @y3
	.local	y3
	.comm	y3,25600,4
	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"resnet8"
	.size	.L.str.2, 8

	.type	image,@object                   # @image
	.local	image
	.comm	image,13872,4
	.type	w_conv1,@object                 # @w_conv1
	.local	w_conv1
	.comm	w_conv1,1728,4
	.type	w_s1a,@object                   # @w_s1a
	.local	w_s1a
	.comm	w_s1a,9216,4
	.type	w_s1b,@object                   # @w_s1b
	.local	w_s1b
	.comm	w_s1b,9216,4
	.type	w_s2a,@object                   # @w_s2a
	.local	w_s2a
	.comm	w_s2a,18432,4
	.type	w_s2b,@object                   # @w_s2b
	.local	w_s2b
	.comm	w_s2b,36864,4
	.type	w_s2p,@object                   # @w_s2p
	.local	w_s2p
	.comm	w_s2p,2048,4
	.type	w_s3a,@object                   # @w_s3a
	.local	w_s3a
	.comm	w_s3a,73728,4
	.type	w_s3b,@object                   # @w_s3b
	.local	w_s3b
	.comm	w_s3b,147456,4
	.type	w_s3p,@object                   # @w_s3p
	.local	w_s3p
	.comm	w_s3p,8192,4
	.type	w_fc,@object                    # @w_fc
	.local	w_fc
	.comm	w_fc,2560,4
	.type	w_conv1_flat,@object            # @w_conv1_flat
	.local	w_conv1_flat
	.comm	w_conv1_flat,2048,4
	.type	lcg_state,@object               # @lcg_state
	.data
	.p2align	2, 0x0
lcg_state:
	.word	12345                           # 0x3039
	.size	lcg_state, 4

	.type	x1,@object                      # @x1
	.local	x1
	.comm	x1,73984,4
	.type	a1,@object                      # @a1
	.local	a1
	.comm	a1,73984,4
	.type	y1,@object                      # @y1
	.local	y1
	.comm	y1,73984,4
	.type	a2,@object                      # @a2
	.local	a2
	.comm	a2,41472,4
	.type	p2,@object                      # @p2
	.local	p2
	.comm	p2,41472,4
	.type	y2,@object                      # @y2
	.local	y2
	.comm	y2,41472,4
	.type	a3,@object                      # @a3
	.local	a3
	.comm	a3,25600,4
	.type	p3,@object                      # @p3
	.local	p3
	.comm	p3,25600,4
	.type	patch,@object                   # @patch
	.local	patch
	.comm	patch,128,4
	.type	.L.str.3,@object                # @.str.3
	.section	.rodata.str1.1,"aMS",@progbits,1
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
	.comm	.L_MergedGlobals,1680,4
logits = .L_MergedGlobals
	.size	logits, 40
b_fc = .L_MergedGlobals+40
	.size	b_fc, 40
b_conv1 = .L_MergedGlobals+80
	.size	b_conv1, 64
b_s1a = .L_MergedGlobals+144
	.size	b_s1a, 64
b_s1b = .L_MergedGlobals+208
	.size	b_s1b, 64
b_s2a = .L_MergedGlobals+272
	.size	b_s2a, 128
b_s2b = .L_MergedGlobals+400
	.size	b_s2b, 128
b_s2p = .L_MergedGlobals+528
	.size	b_s2p, 128
b_s3a = .L_MergedGlobals+656
	.size	b_s3a, 256
b_s3b = .L_MergedGlobals+912
	.size	b_s3b, 256
b_s3p = .L_MergedGlobals+1168
	.size	b_s3p, 256
pooled = .L_MergedGlobals+1424
	.size	pooled, 256
	.ident	"clang version 22.1.8 (https://github.com/igabirondo16/llvm-project-22.git 477e688a98d61e1ca9b3401134098175fdecb835)"
	.section	".note.GNU-stack","",@progbits
