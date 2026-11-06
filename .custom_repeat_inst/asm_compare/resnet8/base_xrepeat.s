	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0_xrepeatint1p0"
	.file	"resnet8_base.c"
	.option	push
	.option	arch, +m, +xrepeatint, +zmmul
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	x2, x2, -880
	sw	x1, 876(x2)                     # 4-byte Folded Spill
	sw	x8, 872(x2)                     # 4-byte Folded Spill
	sw	x9, 868(x2)                     # 4-byte Folded Spill
	sw	x18, 864(x2)                    # 4-byte Folded Spill
	sw	x19, 860(x2)                    # 4-byte Folded Spill
	sw	x20, 856(x2)                    # 4-byte Folded Spill
	sw	x21, 852(x2)                    # 4-byte Folded Spill
	sw	x22, 848(x2)                    # 4-byte Folded Spill
	sw	x23, 844(x2)                    # 4-byte Folded Spill
	sw	x24, 840(x2)                    # 4-byte Folded Spill
	sw	x25, 836(x2)                    # 4-byte Folded Spill
	sw	x26, 832(x2)                    # 4-byte Folded Spill
	sw	x27, 828(x2)                    # 4-byte Folded Spill
	lui	x10, 247535
	lui	x11, 406
	addi	x9, x10, 863
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
	li	x10, 0
	lui	x12, %hi(image)
	addi	x12, x12, %lo(image)
	lui	x11, %hi(lcg_state)
	addi	x12, x12, 428
	lw	x11, %lo(lcg_state)(x11)
	li	x13, 1
	li	x14, 408
	li	x15, 33
.LBB0_1:                                # %for.cond1.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	mul	x16, x10, x14
	lui	x17, %hi(image)
	addi	x17, x17, %lo(image)
	add	x16, x16, x17
	addi	x16, x16, 812
	mv	x17, x12
.LBB0_2:                                # %for.cond5.preheader.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x11, x11, x18
	add	x11, x11, x9
	slli	x5, x11, 8
	mul	x11, x11, x18
	srli	x5, x5, 24
	add	x11, x11, x9
	addi	x5, x5, -128
	slli	x6, x11, 8
	mul	x11, x11, x18
	srli	x6, x6, 24
	add	x11, x11, x9
	addi	x6, x6, -128
	slli	x7, x11, 8
	srli	x7, x7, 24
	addi	x7, x7, -128
	sw	x5, -8(x17)
	sw	x6, -4(x17)
	sw	x7, 0(x17)
	addi	x17, x17, 12
	bne	x17, x16, .LBB0_2
# %bb.3:                                # %for.cond.cleanup3.i
                                        #   in Loop: Header=BB0_1 Depth=1
	addi	x13, x13, 1
	addi	x12, x12, 408
	addi	x10, x10, 1
	bne	x13, x15, .LBB0_1
# %bb.4:                                # %for.body.i.i.preheader
	lui	x10, %hi(w_conv1)
	addi	x10, x10, %lo(w_conv1)
	lui	x12, 13
	addi	x12, x12, -819
	addi	x13, x10, 1728
.LBB0_5:                                # %for.body.i.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
	mul	x15, x14, x12
	srli	x15, x15, 18
	slli	x16, x15, 2
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -2
	sw	x14, 0(x10)
	addi	x10, x10, 4
	bne	x10, x13, .LBB0_5
# %bb.6:                                # %for.body.i24.i.preheader
	lui	x29, %hi(.L_MergedGlobals)
	addi	x29, x29, %lo(.L_MergedGlobals)
	lui	x10, 4
	addi	x12, x29, 80
	addi	x13, x10, -127
	addi	x10, x29, 144
.LBB0_7:                                # %for.body.i24.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
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
	bne	x12, x10, .LBB0_7
# %bb.8:                                # %for.body.i39.i.preheader
	lui	x12, %hi(w_s1a)
	addi	x12, x12, %lo(w_s1a)
	lui	x13, 13
	li	x14, 9
	addi	x13, x13, -819
	slli	x14, x14, 10
	add	x14, x12, x14
.LBB0_9:                                # %for.body.i39.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
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
# %bb.10:                               # %for.body.i54.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x12, x29, 208
.LBB0_11:                               # %for.body.i54.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x10)
	addi	x10, x10, 4
	bne	x10, x12, .LBB0_11
# %bb.12:                               # %for.body.i69.i.preheader
	lui	x10, %hi(w_s1b)
	addi	x10, x10, %lo(w_s1b)
	lui	x13, 13
	li	x14, 9
	addi	x13, x13, -819
	slli	x14, x14, 10
	add	x14, x10, x14
.LBB0_13:                               # %for.body.i69.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x10)
	addi	x10, x10, 4
	bne	x10, x14, .LBB0_13
# %bb.14:                               # %for.body.i84.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x10, x29, 272
.LBB0_15:                               # %for.body.i84.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
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
	bne	x12, x10, .LBB0_15
# %bb.16:                               # %fill.exit97.i
	lui	x13, %hi(lcg_state)
	lui	x12, %hi(w_s2a)
	addi	x12, x12, %lo(w_s2a)
	lui	x14, 13
	sw	x11, %lo(lcg_state)(x13)
	li	x15, 9
	addi	x13, x14, -819
	slli	x14, x15, 11
	add	x14, x12, x14
.LBB0_17:                               # %for.body.i99.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
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
# %bb.18:                               # %for.body.i114.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x12, x29, 400
.LBB0_19:                               # %for.body.i114.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x10)
	addi	x10, x10, 4
	bne	x10, x12, .LBB0_19
# %bb.20:                               # %for.body.i129.i.preheader
	lui	x10, %hi(w_s2b)
	addi	x10, x10, %lo(w_s2b)
	lui	x13, 13
	lui	x14, 9
	addi	x13, x13, -819
	add	x14, x10, x14
.LBB0_21:                               # %for.body.i129.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x10)
	addi	x10, x10, 4
	bne	x10, x14, .LBB0_21
# %bb.22:                               # %for.body.i144.i.preheader
	lui	x10, 4
	addi	x10, x10, -127
	addi	x13, x29, 528
.LBB0_23:                               # %for.body.i144.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
	mul	x15, x14, x10
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
# %bb.24:                               # %for.body.i159.i.preheader
	lui	x10, %hi(w_s2p)
	addi	x10, x10, %lo(w_s2p)
	lui	x12, 13
	addi	x12, x12, -819
	addi	x14, x10, 2047
	addi	x14, x14, 1
.LBB0_25:                               # %for.body.i159.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
	mul	x16, x15, x12
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x10)
	addi	x10, x10, 4
	bne	x10, x14, .LBB0_25
# %bb.26:                               # %for.body.i174.i.preheader
	lui	x12, 4
	addi	x12, x12, -127
	addi	x10, x29, 656
.LBB0_27:                               # %for.body.i174.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
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
	bne	x13, x10, .LBB0_27
# %bb.28:                               # %for.body.i189.i.preheader
	lui	x12, %hi(w_s3a)
	addi	x12, x12, %lo(w_s3a)
	lui	x13, 13
	lui	x14, 18
	addi	x13, x13, -819
	add	x14, x12, x14
.LBB0_29:                               # %for.body.i189.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
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
# %bb.30:                               # %for.body.i204.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x12, x29, 912
.LBB0_31:                               # %for.body.i204.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
	mul	x15, x14, x13
	srli	x15, x15, 21
	slli	x16, x15, 7
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -64
	sw	x14, 0(x10)
	addi	x10, x10, 4
	bne	x10, x12, .LBB0_31
# %bb.32:                               # %for.body.i219.i.preheader
	lui	x10, %hi(w_s3b)
	addi	x10, x10, %lo(w_s3b)
	lui	x13, 13
	lui	x14, 36
	addi	x13, x13, -819
	add	x14, x10, x14
.LBB0_33:                               # %for.body.i219.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x10)
	addi	x10, x10, 4
	bne	x10, x14, .LBB0_33
# %bb.34:                               # %for.body.i234.i.preheader
	lui	x13, 4
	addi	x13, x13, -127
	addi	x10, x29, 1168
.LBB0_35:                               # %for.body.i234.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
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
	bne	x12, x10, .LBB0_35
# %bb.36:                               # %for.body.i249.i.preheader
	lui	x12, %hi(w_s3p)
	addi	x12, x12, %lo(w_s3p)
	lui	x13, 13
	lui	x14, 2
	addi	x13, x13, -819
	add	x14, x12, x14
.LBB0_37:                               # %for.body.i249.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x15, x11, 16
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
# %bb.38:                               # %for.body.i264.i.preheader
	lui	x12, 4
	addi	x12, x12, -127
	addi	x16, x29, 1424
.LBB0_39:                               # %for.body.i264.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x13, x11, 16
	mul	x14, x13, x12
	srli	x14, x14, 21
	slli	x15, x14, 7
	sub	x13, x13, x14
	sub	x13, x13, x15
	slli	x13, x13, 16
	srli	x13, x13, 16
	addi	x13, x13, -64
	sw	x13, 0(x10)
	addi	x10, x10, 4
	bne	x10, x16, .LBB0_39
# %bb.40:                               # %for.body.i279.i.preheader
	sw	x16, 4(x2)                      # 4-byte Folded Spill
	lui	x10, %hi(w_fc)
	addi	x10, x10, %lo(w_fc)
	lui	x12, 13
	addi	x12, x12, -819
	addi	x13, x10, 2047
	addi	x13, x13, 513
.LBB0_41:                               # %for.body.i279.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x11, x11, x18
	add	x11, x11, x9
	srli	x14, x11, 16
	mul	x15, x14, x12
	srli	x15, x15, 18
	slli	x16, x15, 2
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -2
	sw	x14, 0(x10)
	addi	x10, x10, 4
	bne	x10, x13, .LBB0_41
# %bb.42:                               # %init_data.exit
	li	x30, 0
	li	x10, 9
	mul	x11, x11, x18
	lui	x12, 4
	lui	x13, 16
	lui	x14, %hi(lcg_state)
	add	x15, x11, x9
	addi	x12, x12, -127
	addi	x11, x13, -1
	srli	x13, x15, 16
	mul	x15, x15, x18
	mul	x16, x13, x12
	add	x15, x15, x9
	srli	x16, x16, 21
	srli	x17, x15, 16
	mul	x15, x15, x18
	slli	x5, x16, 7
	sub	x13, x13, x16
	mul	x16, x17, x12
	add	x15, x15, x9
	sub	x13, x13, x5
	srli	x16, x16, 21
	srli	x5, x15, 16
	mul	x15, x15, x18
	and	x13, x13, x11
	slli	x6, x16, 7
	sub	x16, x17, x16
	mul	x17, x5, x12
	add	x15, x15, x9
	addi	x13, x13, -64
	sub	x16, x16, x6
	srli	x17, x17, 21
	srli	x6, x15, 16
	mul	x15, x15, x18
	and	x16, x16, x11
	slli	x7, x17, 7
	sub	x17, x5, x17
	mul	x5, x6, x12
	add	x15, x15, x9
	addi	x16, x16, -64
	sub	x17, x17, x7
	srli	x5, x5, 21
	srli	x7, x15, 16
	mul	x15, x15, x18
	and	x17, x17, x11
	slli	x28, x5, 7
	sub	x5, x6, x5
	mul	x6, x7, x12
	add	x15, x15, x9
	addi	x17, x17, -64
	sub	x5, x5, x28
	srli	x6, x6, 21
	srli	x28, x15, 16
	mul	x15, x15, x18
	and	x5, x5, x11
	sub	x7, x7, x6
	slli	x6, x6, 7
	sub	x6, x7, x6
	mul	x7, x28, x12
	add	x15, x15, x9
	addi	x5, x5, -64
	srli	x7, x7, 21
	sw	x13, 40(x29)
	sw	x16, 44(x29)
	sw	x17, 48(x29)
	sw	x5, 52(x29)
	srli	x13, x15, 16
	mul	x15, x15, x18
	sub	x16, x28, x7
	slli	x7, x7, 7
	sub	x16, x16, x7
	mul	x17, x13, x12
	add	x15, x15, x9
	srli	x17, x17, 21
	sub	x13, x13, x17
	slli	x17, x17, 7
	sub	x13, x13, x17
	srli	x17, x15, 16
	mul	x15, x15, x18
	add	x15, x15, x9
	mul	x5, x15, x18
	add	x5, x5, x9
	mul	x7, x17, x12
	srli	x7, x7, 21
	sub	x17, x17, x7
	slli	x7, x7, 7
	sub	x17, x17, x7
	lui	x7, 65555
	srli	x15, x15, 16
	sw	x5, %lo(lcg_state)(x14)
	mul	x14, x15, x12
	srli	x14, x14, 21
	sub	x15, x15, x14
	slli	x14, x14, 7
	sub	x15, x15, x14
	lui	x28, %hi(x1)
	addi	x28, x28, %lo(x1)
	slli	x10, x10, 8
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	and	x10, x6, x11
	addi	x10, x10, -64
	and	x14, x16, x11
	addi	x14, x14, -64
	and	x13, x13, x11
	addi	x13, x13, -64
	srli	x16, x5, 16
	and	x17, x17, x11
	mul	x12, x16, x12
	addi	x17, x17, -64
	srli	x12, x12, 21
	sw	x10, 56(x29)
	sw	x14, 60(x29)
	sw	x13, 64(x29)
	sw	x17, 68(x29)
	and	x15, x15, x11
	slli	x10, x12, 7
	sub	x12, x16, x12
	addi	x13, x15, -64
	sub	x12, x12, x10
	and	x11, x12, x11
	addi	x10, x11, -64
	sw	x13, 72(x29)
	sw	x10, 76(x29)
	#APP
	#NO_APP
	sw	x0, 0(x7)
	#APP
	#NO_APP
	addi	x10, x28, 2047
	addi	x14, x10, 193
	j	.LBB0_44
.LBB0_43:                               # %for.cond.cleanup5.i.i
                                        #   in Loop: Header=BB0_44 Depth=1
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 2047
	addi	x14, x10, 129
	lw	x30, 120(x2)                    # 4-byte Folded Reload
	li	x10, 32
	beq	x30, x10, .LBB0_50
.LBB0_44:                               # %for.cond3.preheader.i.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_46 Depth 2
                                        #       Child Loop BB0_48 Depth 3
	li	x31, 0
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	addi	x12, x13, -128
	slli	x10, x30, 1
	slli	x11, x30, 5
	sw	x12, 76(x2)                     # 4-byte Folded Spill
	mul	x12, x30, x12
	add	x10, x11, x10
	sw	x10, 184(x2)                    # 4-byte Folded Spill
	add	x12, x12, x13
	sw	x12, 152(x2)                    # 4-byte Folded Spill
	addi	x30, x30, 1
	sw	x30, 120(x2)                    # 4-byte Folded Spill
	sw	x14, 116(x2)                    # 4-byte Folded Spill
	mv	x30, x14
	j	.LBB0_46
.LBB0_45:                               # %for.cond3.loopexit.i.i
                                        #   in Loop: Header=BB0_46 Depth=2
	lw	x30, 216(x2)                    # 4-byte Folded Reload
	addi	x30, x30, 64
	lui	x29, %hi(.L_MergedGlobals)
	addi	x29, x29, %lo(.L_MergedGlobals)
	li	x10, 32
	lw	x31, 248(x2)                    # 4-byte Folded Reload
	beq	x31, x10, .LBB0_43
.LBB0_46:                               # %for.body6.i.i
                                        #   Parent Loop BB0_44 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_48 Depth 3
	slli	x10, x31, 6
	lw	x11, 184(x2)                    # 4-byte Folded Reload
	add	x11, x31, x11
	lw	x7, 152(x2)                     # 4-byte Folded Reload
	add	x7, x7, x10
	slli	x10, x11, 2
	slli	x11, x11, 3
	add	x10, x11, x10
	lui	x17, %hi(image)
	addi	x17, x17, %lo(image)
	add	x17, x17, x10
	lw	x10, 408(x17)
	sw	x10, 824(x2)                    # 4-byte Folded Spill
	lw	x10, 412(x17)
	sw	x10, 792(x2)                    # 4-byte Folded Spill
	lw	x10, 416(x17)
	sw	x10, 760(x2)                    # 4-byte Folded Spill
	lw	x10, 420(x17)
	sw	x10, 728(x2)                    # 4-byte Folded Spill
	lw	x10, 424(x17)
	sw	x10, 696(x2)                    # 4-byte Folded Spill
	lw	x10, 428(x17)
	sw	x10, 664(x2)                    # 4-byte Folded Spill
	lw	x10, 432(x17)
	sw	x10, 632(x2)                    # 4-byte Folded Spill
	lw	x10, 436(x17)
	sw	x10, 600(x2)                    # 4-byte Folded Spill
	lw	x10, 0(x17)
	sw	x10, 568(x2)                    # 4-byte Folded Spill
	lw	x10, 4(x17)
	sw	x10, 536(x2)                    # 4-byte Folded Spill
	lw	x10, 8(x17)
	sw	x10, 504(x2)                    # 4-byte Folded Spill
	lw	x10, 12(x17)
	sw	x10, 472(x2)                    # 4-byte Folded Spill
	lw	x10, 16(x17)
	sw	x10, 440(x2)                    # 4-byte Folded Spill
	lw	x10, 20(x17)
	sw	x10, 408(x2)                    # 4-byte Folded Spill
	lw	x10, 24(x17)
	sw	x10, 376(x2)                    # 4-byte Folded Spill
	lw	x10, 28(x17)
	sw	x10, 344(x2)                    # 4-byte Folded Spill
	lw	x10, 32(x17)
	sw	x10, 312(x2)                    # 4-byte Folded Spill
	lw	x10, 440(x17)
	sw	x10, 280(x2)                    # 4-byte Folded Spill
	lw	x14, 816(x17)
	lw	x12, 820(x17)
	lw	x10, 824(x17)
	lw	x11, 828(x17)
	lw	x15, 832(x17)
	lw	x16, 836(x17)
	lw	x5, 840(x17)
	lw	x6, 844(x17)
	lw	x17, 848(x17)
	lui	x28, %hi(x1)
	addi	x28, x28, %lo(x1)
	add	x7, x28, x7
	addi	x31, x31, 1
	sw	x31, 248(x2)                    # 4-byte Folded Spill
	addi	x28, x29, 80
	lui	x29, %hi(w_conv1+52)
	addi	x29, x29, %lo(w_conv1+52)
	sw	x30, 216(x2)                    # 4-byte Folded Spill
	j	.LBB0_48
.LBB0_47:                               # %for.body21.i.i
                                        #   in Loop: Header=BB0_48 Depth=3
	sw	x31, 0(x30)
	addi	x30, x30, 4
	addi	x28, x28, 4
	addi	x29, x29, 108
	beq	x30, x7, .LBB0_45
.LBB0_48:                               # %for.body21.i.i
                                        #   Parent Loop BB0_44 Depth=1
                                        #     Parent Loop BB0_46 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x8, 0(x28)
	lw	x9, -52(x29)
	lw	x18, -48(x29)
	lw	x19, -44(x29)
	lw	x20, -40(x29)
	lw	x21, -36(x29)
	lw	x31, -32(x29)
	lw	x22, -28(x29)
	lw	x23, -24(x29)
	lw	x24, -12(x29)
	lw	x25, -8(x29)
	lw	x26, 8(x29)
	lw	x13, 568(x2)                    # 4-byte Folded Reload
	mul	x9, x9, x13
	lw	x13, 536(x2)                    # 4-byte Folded Reload
	mul	x18, x18, x13
	lw	x13, 504(x2)                    # 4-byte Folded Reload
	mul	x19, x19, x13
	add	x9, x9, x8
	add	x18, x18, x19
	lw	x19, 12(x29)
	lw	x27, 16(x29)
	lw	x1, 20(x29)
	lw	x8, 24(x29)
	lw	x13, 472(x2)                    # 4-byte Folded Reload
	mul	x20, x20, x13
	lw	x13, 440(x2)                    # 4-byte Folded Reload
	mul	x21, x21, x13
	lw	x13, 376(x2)                    # 4-byte Folded Reload
	mul	x22, x22, x13
	lw	x13, 344(x2)                    # 4-byte Folded Reload
	mul	x23, x23, x13
	lw	x13, 792(x2)                    # 4-byte Folded Reload
	mul	x24, x24, x13
	lw	x13, 760(x2)                    # 4-byte Folded Reload
	mul	x25, x25, x13
	add	x20, x20, x21
	add	x22, x22, x23
	add	x24, x24, x25
	lw	x21, 32(x29)
	lw	x23, 36(x29)
	lw	x25, 40(x29)
	lw	x13, 632(x2)                    # 4-byte Folded Reload
	mul	x26, x26, x13
	lw	x13, 600(x2)                    # 4-byte Folded Reload
	mul	x19, x19, x13
	mul	x21, x21, x11
	mul	x23, x23, x15
	add	x19, x26, x19
	add	x21, x21, x23
	lw	x23, -20(x29)
	lw	x26, -16(x29)
	add	x9, x9, x18
	lw	x18, -4(x29)
	lw	x13, 408(x2)                    # 4-byte Folded Reload
	mul	x31, x31, x13
	lw	x13, 312(x2)                    # 4-byte Folded Reload
	mul	x23, x23, x13
	add	x31, x20, x31
	add	x22, x22, x23
	lw	x20, 0(x29)
	lw	x23, 4(x29)
	lw	x13, 728(x2)                    # 4-byte Folded Reload
	mul	x18, x18, x13
	add	x18, x24, x18
	lw	x13, 280(x2)                    # 4-byte Folded Reload
	mul	x24, x27, x13
	add	x19, x19, x24
	mul	x24, x25, x16
	add	x21, x21, x24
	add	x31, x9, x31
	lw	x9, 824(x2)                     # 4-byte Folded Reload
	mul	x9, x26, x9
	add	x9, x22, x9
	lw	x22, 44(x29)
	lw	x13, 696(x2)                    # 4-byte Folded Reload
	mul	x20, x20, x13
	mul	x24, x1, x14
	add	x18, x18, x20
	add	x19, x19, x24
	lw	x20, 48(x29)
	lw	x24, 52(x29)
	mul	x22, x22, x5
	add	x21, x21, x22
	add	x31, x31, x9
	lw	x13, 664(x2)                    # 4-byte Folded Reload
	mul	x9, x23, x13
	add	x9, x18, x9
	mul	x8, x8, x12
	add	x8, x19, x8
	lw	x18, 28(x29)
	mul	x19, x20, x6
	add	x19, x21, x19
	add	x31, x31, x9
	mul	x9, x18, x10
	add	x8, x8, x9
	mul	x9, x24, x17
	add	x9, x19, x9
	add	x31, x31, x8
	add	x31, x31, x9
	srai	x31, x31, 3
	sgtz	x8, x31
	neg	x8, x8
	and	x31, x8, x31
	li	x8, 127
	blt	x31, x8, .LBB0_47
# %bb.49:                               # %for.body21.i.i
                                        #   in Loop: Header=BB0_48 Depth=3
	li	x31, 127
	j	.LBB0_47
.LBB0_50:                               # %conv.exit.i
	li	x15, 0
	#APP
	#NO_APP
	lui	x10, 65555
	li	x11, 1
	lui	x14, %hi(a1)
	addi	x14, x14, %lo(a1)
	li	x12, 17
	li	x7, 7
	lui	x13, 1
	sw	x11, 0(x10)
	addi	x10, x14, 2047
	slli	x12, x12, 8
	sw	x12, 96(x2)                     # 4-byte Folded Spill
	addi	x11, x13, 320
	sw	x11, 92(x2)                     # 4-byte Folded Spill
	#APP
	#NO_APP
	addi	x14, x10, 193
	addi	x10, x13, 384
	sw	x10, 88(x2)                     # 4-byte Folded Spill
	addi	x10, x29, 144
	sw	x10, 84(x2)                     # 4-byte Folded Spill
	j	.LBB0_52
.LBB0_51:                               # %for.cond.cleanup5.i110.i
                                        #   in Loop: Header=BB0_52 Depth=1
	lw	x10, 72(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 2047
	addi	x14, x10, 129
	lw	x15, 80(x2)                     # 4-byte Folded Reload
	li	x10, 32
	beq	x15, x10, .LBB0_58
.LBB0_52:                               # %for.cond3.preheader.i55.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_54 Depth 2
                                        #       Child Loop BB0_56 Depth 3
	li	x28, 0
	lw	x10, 76(x2)                     # 4-byte Folded Reload
	mul	x10, x15, x10
	slli	x11, x15, 1
	slli	x12, x15, 5
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	add	x10, x10, x13
	sw	x10, 104(x2)                    # 4-byte Folded Spill
	add	x11, x12, x11
	sw	x11, 100(x2)                    # 4-byte Folded Spill
	addi	x15, x15, 1
	sw	x15, 80(x2)                     # 4-byte Folded Spill
	sw	x14, 72(x2)                     # 4-byte Folded Spill
	mv	x29, x14
	j	.LBB0_54
.LBB0_53:                               # %for.cond3.loopexit.i108.i
                                        #   in Loop: Header=BB0_54 Depth=2
	lw	x29, 108(x2)                    # 4-byte Folded Reload
	addi	x29, x29, 64
	li	x10, 32
	lw	x28, 112(x2)                    # 4-byte Folded Reload
	beq	x28, x10, .LBB0_51
.LBB0_54:                               # %for.body6.i60.i
                                        #   Parent Loop BB0_52 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_56 Depth 3
	slli	x10, x28, 6
	lw	x11, 100(x2)                    # 4-byte Folded Reload
	add	x11, x28, x11
	slli	x11, x11, 6
	lui	x12, %hi(x1)
	addi	x12, x12, %lo(x1)
	add	x11, x12, x11
	lw	x12, 96(x2)                     # 4-byte Folded Reload
	add	x12, x11, x12
	addi	x13, x11, 2047
	li	x5, 4
	lw	x16, 160(x11)
	xr.repeat	1, x5, x7
	sw	x16, 664(x2)                    # 4-byte Folded Spill
	sw	x17, 668(x2)                    # 4-byte Folded Spill
	sw	x18, 672(x2)                    # 4-byte Folded Spill
	sw	x19, 676(x2)                    # 4-byte Folded Spill
	sw	x20, 680(x2)                    # 4-byte Folded Spill
	sw	x21, 684(x2)                    # 4-byte Folded Spill
	sw	x22, 688(x2)                    # 4-byte Folded Spill
	sw	x23, 692(x2)                    # 4-byte Folded Spill
	lw	x16, 128(x11)
	xr.repeat	1, x5, x7
	sw	x16, 632(x2)                    # 4-byte Folded Spill
	sw	x17, 636(x2)                    # 4-byte Folded Spill
	sw	x18, 640(x2)                    # 4-byte Folded Spill
	sw	x19, 644(x2)                    # 4-byte Folded Spill
	sw	x20, 648(x2)                    # 4-byte Folded Spill
	sw	x21, 652(x2)                    # 4-byte Folded Spill
	sw	x22, 656(x2)                    # 4-byte Folded Spill
	sw	x23, 660(x2)                    # 4-byte Folded Spill
	lw	x14, 92(x2)                     # 4-byte Folded Reload
	add	x14, x11, x14
	lw	x15, 88(x2)                     # 4-byte Folded Reload
	add	x15, x11, x15
	addi	x30, x13, 257
	addi	x31, x13, 193
	addi	x6, x13, 129
	lw	x16, 96(x11)
	xr.repeat	1, x5, x7
	sw	x16, 600(x2)                    # 4-byte Folded Spill
	sw	x17, 604(x2)                    # 4-byte Folded Spill
	sw	x18, 608(x2)                    # 4-byte Folded Spill
	sw	x19, 612(x2)                    # 4-byte Folded Spill
	sw	x20, 616(x2)                    # 4-byte Folded Spill
	sw	x21, 620(x2)                    # 4-byte Folded Spill
	sw	x22, 624(x2)                    # 4-byte Folded Spill
	sw	x23, 628(x2)                    # 4-byte Folded Spill
	lw	x16, 64(x11)
	xr.repeat	1, x5, x7
	sw	x16, 568(x2)                    # 4-byte Folded Spill
	sw	x17, 572(x2)                    # 4-byte Folded Spill
	sw	x18, 576(x2)                    # 4-byte Folded Spill
	sw	x19, 580(x2)                    # 4-byte Folded Spill
	sw	x20, 584(x2)                    # 4-byte Folded Spill
	sw	x21, 588(x2)                    # 4-byte Folded Spill
	sw	x22, 592(x2)                    # 4-byte Folded Spill
	sw	x23, 596(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x11)
	xr.repeat	1, x5, x7
	sw	x16, 536(x2)                    # 4-byte Folded Spill
	sw	x17, 540(x2)                    # 4-byte Folded Spill
	sw	x18, 544(x2)                    # 4-byte Folded Spill
	sw	x19, 548(x2)                    # 4-byte Folded Spill
	sw	x20, 552(x2)                    # 4-byte Folded Spill
	sw	x21, 556(x2)                    # 4-byte Folded Spill
	sw	x22, 560(x2)                    # 4-byte Folded Spill
	sw	x23, 564(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x11)
	xr.repeat	1, x5, x7
	sw	x16, 504(x2)                    # 4-byte Folded Spill
	sw	x17, 508(x2)                    # 4-byte Folded Spill
	sw	x18, 512(x2)                    # 4-byte Folded Spill
	sw	x19, 516(x2)                    # 4-byte Folded Spill
	sw	x20, 520(x2)                    # 4-byte Folded Spill
	sw	x21, 524(x2)                    # 4-byte Folded Spill
	sw	x22, 528(x2)                    # 4-byte Folded Spill
	sw	x23, 532(x2)                    # 4-byte Folded Spill
	lw	x16, 257(x13)
	xr.repeat	1, x5, x7
	sw	x16, 472(x2)                    # 4-byte Folded Spill
	sw	x17, 476(x2)                    # 4-byte Folded Spill
	sw	x18, 480(x2)                    # 4-byte Folded Spill
	sw	x19, 484(x2)                    # 4-byte Folded Spill
	sw	x20, 488(x2)                    # 4-byte Folded Spill
	sw	x21, 492(x2)                    # 4-byte Folded Spill
	sw	x22, 496(x2)                    # 4-byte Folded Spill
	sw	x23, 500(x2)                    # 4-byte Folded Spill
	lw	x16, 193(x13)
	xr.repeat	1, x5, x7
	sw	x16, 440(x2)                    # 4-byte Folded Spill
	sw	x17, 444(x2)                    # 4-byte Folded Spill
	sw	x18, 448(x2)                    # 4-byte Folded Spill
	sw	x19, 452(x2)                    # 4-byte Folded Spill
	sw	x20, 456(x2)                    # 4-byte Folded Spill
	sw	x21, 460(x2)                    # 4-byte Folded Spill
	sw	x22, 464(x2)                    # 4-byte Folded Spill
	sw	x23, 468(x2)                    # 4-byte Folded Spill
	lw	x16, 129(x13)
	xr.repeat	1, x5, x7
	sw	x16, 408(x2)                    # 4-byte Folded Spill
	sw	x17, 412(x2)                    # 4-byte Folded Spill
	sw	x18, 416(x2)                    # 4-byte Folded Spill
	sw	x19, 420(x2)                    # 4-byte Folded Spill
	sw	x20, 424(x2)                    # 4-byte Folded Spill
	sw	x21, 428(x2)                    # 4-byte Folded Spill
	sw	x22, 432(x2)                    # 4-byte Folded Spill
	sw	x23, 436(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x12)
	xr.repeat	1, x5, x7
	sw	x16, 376(x2)                    # 4-byte Folded Spill
	sw	x17, 380(x2)                    # 4-byte Folded Spill
	sw	x18, 384(x2)                    # 4-byte Folded Spill
	sw	x19, 388(x2)                    # 4-byte Folded Spill
	sw	x20, 392(x2)                    # 4-byte Folded Spill
	sw	x21, 396(x2)                    # 4-byte Folded Spill
	sw	x22, 400(x2)                    # 4-byte Folded Spill
	sw	x23, 404(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x12)
	xr.repeat	1, x5, x7
	sw	x16, 344(x2)                    # 4-byte Folded Spill
	sw	x17, 348(x2)                    # 4-byte Folded Spill
	sw	x18, 352(x2)                    # 4-byte Folded Spill
	sw	x19, 356(x2)                    # 4-byte Folded Spill
	sw	x20, 360(x2)                    # 4-byte Folded Spill
	sw	x21, 364(x2)                    # 4-byte Folded Spill
	sw	x22, 368(x2)                    # 4-byte Folded Spill
	sw	x23, 372(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x14)
	xr.repeat	1, x5, x7
	sw	x16, 312(x2)                    # 4-byte Folded Spill
	sw	x17, 316(x2)                    # 4-byte Folded Spill
	sw	x18, 320(x2)                    # 4-byte Folded Spill
	sw	x19, 324(x2)                    # 4-byte Folded Spill
	sw	x20, 328(x2)                    # 4-byte Folded Spill
	sw	x21, 332(x2)                    # 4-byte Folded Spill
	sw	x22, 336(x2)                    # 4-byte Folded Spill
	sw	x23, 340(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x14)
	xr.repeat	1, x5, x7
	sw	x16, 280(x2)                    # 4-byte Folded Spill
	sw	x17, 284(x2)                    # 4-byte Folded Spill
	sw	x18, 288(x2)                    # 4-byte Folded Spill
	sw	x19, 292(x2)                    # 4-byte Folded Spill
	sw	x20, 296(x2)                    # 4-byte Folded Spill
	sw	x21, 300(x2)                    # 4-byte Folded Spill
	sw	x22, 304(x2)                    # 4-byte Folded Spill
	sw	x23, 308(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x30)
	xr.repeat	1, x5, x7
	sw	x16, 248(x2)                    # 4-byte Folded Spill
	sw	x17, 252(x2)                    # 4-byte Folded Spill
	sw	x18, 256(x2)                    # 4-byte Folded Spill
	sw	x19, 260(x2)                    # 4-byte Folded Spill
	sw	x20, 264(x2)                    # 4-byte Folded Spill
	sw	x21, 268(x2)                    # 4-byte Folded Spill
	sw	x22, 272(x2)                    # 4-byte Folded Spill
	sw	x23, 276(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x31)
	xr.repeat	1, x5, x7
	sw	x16, 216(x2)                    # 4-byte Folded Spill
	sw	x17, 220(x2)                    # 4-byte Folded Spill
	sw	x18, 224(x2)                    # 4-byte Folded Spill
	sw	x19, 228(x2)                    # 4-byte Folded Spill
	sw	x20, 232(x2)                    # 4-byte Folded Spill
	sw	x21, 236(x2)                    # 4-byte Folded Spill
	sw	x22, 240(x2)                    # 4-byte Folded Spill
	sw	x23, 244(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x6)
	xr.repeat	1, x5, x7
	sw	x16, 184(x2)                    # 4-byte Folded Spill
	sw	x17, 188(x2)                    # 4-byte Folded Spill
	sw	x18, 192(x2)                    # 4-byte Folded Spill
	sw	x19, 196(x2)                    # 4-byte Folded Spill
	sw	x20, 200(x2)                    # 4-byte Folded Spill
	sw	x21, 204(x2)                    # 4-byte Folded Spill
	sw	x22, 208(x2)                    # 4-byte Folded Spill
	sw	x23, 212(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x15)
	xr.repeat	1, x5, x7
	sw	x16, 152(x2)                    # 4-byte Folded Spill
	sw	x17, 156(x2)                    # 4-byte Folded Spill
	sw	x18, 160(x2)                    # 4-byte Folded Spill
	sw	x19, 164(x2)                    # 4-byte Folded Spill
	sw	x20, 168(x2)                    # 4-byte Folded Spill
	sw	x21, 172(x2)                    # 4-byte Folded Spill
	sw	x22, 176(x2)                    # 4-byte Folded Spill
	sw	x23, 180(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x15)
	xr.repeat	1, x5, x7
	sw	x16, 120(x2)                    # 4-byte Folded Spill
	sw	x17, 124(x2)                    # 4-byte Folded Spill
	sw	x18, 128(x2)                    # 4-byte Folded Spill
	sw	x19, 132(x2)                    # 4-byte Folded Spill
	sw	x20, 136(x2)                    # 4-byte Folded Spill
	sw	x21, 140(x2)                    # 4-byte Folded Spill
	sw	x22, 144(x2)                    # 4-byte Folded Spill
	sw	x23, 148(x2)                    # 4-byte Folded Spill
	lw	x11, 104(x2)                    # 4-byte Folded Reload
	add	x10, x11, x10
	lui	x11, %hi(a1)
	addi	x11, x11, %lo(a1)
	add	x10, x11, x10
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	addi	x28, x28, 1
	sw	x28, 112(x2)                    # 4-byte Folded Spill
	lui	x6, %hi(w_s1a+256)
	addi	x6, x6, %lo(w_s1a+256)
	lw	x11, 84(x2)                     # 4-byte Folded Reload
	sw	x29, 108(x2)                    # 4-byte Folded Spill
	j	.LBB0_56
.LBB0_55:                               # %for.body21.i68.i
                                        #   in Loop: Header=BB0_56 Depth=3
	lw	x12, 792(x2)                    # 4-byte Folded Reload
	sw	x10, 0(x12)
	addi	x29, x12, 4
	lw	x11, 824(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 4
	addi	x6, x6, 576
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	beq	x29, x10, .LBB0_53
.LBB0_56:                               # %for.body21.i68.i
                                        #   Parent Loop BB0_52 Depth=1
                                        #     Parent Loop BB0_54 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	sw	x29, 792(x2)                    # 4-byte Folded Spill
	sw	x11, 824(x2)                    # 4-byte Folded Spill
	lw	x1, 0(x11)
	li	x5, 4
	lw	x24, 32(x6)
	xr.repeat	1, x5, x7
	lw	x16, 0(x6)
	xr.repeat	1, x5, x7
	sw	x16, 760(x2)                    # 4-byte Folded Spill
	sw	x17, 764(x2)                    # 4-byte Folded Spill
	sw	x18, 768(x2)                    # 4-byte Folded Spill
	sw	x19, 772(x2)                    # 4-byte Folded Spill
	sw	x20, 776(x2)                    # 4-byte Folded Spill
	sw	x21, 780(x2)                    # 4-byte Folded Spill
	sw	x22, 784(x2)                    # 4-byte Folded Spill
	sw	x23, 788(x2)                    # 4-byte Folded Spill
	lw	x8, 288(x6)
	xr.repeat	1, x5, x7
	lw	x16, 216(x2)                    # 4-byte Folded Reload
	lw	x17, 220(x2)                    # 4-byte Folded Reload
	lw	x18, 224(x2)                    # 4-byte Folded Reload
	lw	x19, 228(x2)                    # 4-byte Folded Reload
	lw	x20, 232(x2)                    # 4-byte Folded Reload
	lw	x21, 236(x2)                    # 4-byte Folded Reload
	lw	x22, 240(x2)                    # 4-byte Folded Reload
	lw	x23, 244(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x24, x1
	xr.repeat	6, x0, x7
	lw	x24, 256(x6)
	xr.repeat	1, x5, x7
	sw	x24, 696(x2)                    # 4-byte Folded Spill
	sw	x25, 700(x2)                    # 4-byte Folded Spill
	sw	x26, 704(x2)                    # 4-byte Folded Spill
	sw	x27, 708(x2)                    # 4-byte Folded Spill
	sw	x28, 712(x2)                    # 4-byte Folded Spill
	sw	x29, 716(x2)                    # 4-byte Folded Spill
	sw	x30, 720(x2)                    # 4-byte Folded Spill
	sw	x31, 724(x2)                    # 4-byte Folded Spill
	lw	x16, 440(x2)                    # 4-byte Folded Reload
	lw	x17, 444(x2)                    # 4-byte Folded Reload
	lw	x18, 448(x2)                    # 4-byte Folded Reload
	lw	x19, 452(x2)                    # 4-byte Folded Reload
	lw	x20, 456(x2)                    # 4-byte Folded Reload
	lw	x21, 460(x2)                    # 4-byte Folded Reload
	lw	x22, 464(x2)                    # 4-byte Folded Reload
	lw	x23, 468(x2)                    # 4-byte Folded Reload
	lw	x24, 760(x2)                    # 4-byte Folded Reload
	lw	x25, 764(x2)                    # 4-byte Folded Reload
	lw	x26, 768(x2)                    # 4-byte Folded Reload
	lw	x27, 772(x2)                    # 4-byte Folded Reload
	lw	x28, 776(x2)                    # 4-byte Folded Reload
	lw	x29, 780(x2)                    # 4-byte Folded Reload
	lw	x30, 784(x2)                    # 4-byte Folded Reload
	lw	x31, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x24, x1
	xr.repeat	6, x0, x7
	lw	x24, 224(x6)
	xr.repeat	1, x5, x7
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x16, 152(x2)                    # 4-byte Folded Reload
	lw	x17, 156(x2)                    # 4-byte Folded Reload
	lw	x18, 160(x2)                    # 4-byte Folded Reload
	lw	x19, 164(x2)                    # 4-byte Folded Reload
	lw	x20, 168(x2)                    # 4-byte Folded Reload
	lw	x21, 172(x2)                    # 4-byte Folded Reload
	lw	x22, 176(x2)                    # 4-byte Folded Reload
	lw	x23, 180(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x8, x1
	xr.repeat	6, x0, x7
	lw	x8, 192(x6)
	xr.repeat	1, x5, x7
	lw	x16, 120(x2)                    # 4-byte Folded Reload
	lw	x17, 124(x2)                    # 4-byte Folded Reload
	lw	x18, 128(x2)                    # 4-byte Folded Reload
	lw	x19, 132(x2)                    # 4-byte Folded Reload
	lw	x20, 136(x2)                    # 4-byte Folded Reload
	lw	x21, 140(x2)                    # 4-byte Folded Reload
	lw	x22, 144(x2)                    # 4-byte Folded Reload
	lw	x23, 148(x2)                    # 4-byte Folded Reload
	lw	x24, 696(x2)                    # 4-byte Folded Reload
	lw	x25, 700(x2)                    # 4-byte Folded Reload
	lw	x26, 704(x2)                    # 4-byte Folded Reload
	lw	x27, 708(x2)                    # 4-byte Folded Reload
	lw	x28, 712(x2)                    # 4-byte Folded Reload
	lw	x29, 716(x2)                    # 4-byte Folded Reload
	lw	x30, 720(x2)                    # 4-byte Folded Reload
	lw	x31, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x24, x1
	xr.repeat	6, x0, x7
	lw	x24, 160(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 312(x2)                    # 4-byte Folded Reload
	lw	x25, 316(x2)                    # 4-byte Folded Reload
	lw	x26, 320(x2)                    # 4-byte Folded Reload
	lw	x27, 324(x2)                    # 4-byte Folded Reload
	lw	x28, 328(x2)                    # 4-byte Folded Reload
	lw	x29, 332(x2)                    # 4-byte Folded Reload
	lw	x30, 336(x2)                    # 4-byte Folded Reload
	lw	x31, 340(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, 128(x6)
	xr.repeat	1, x5, x7
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 280(x2)                    # 4-byte Folded Reload
	lw	x25, 284(x2)                    # 4-byte Folded Reload
	lw	x26, 288(x2)                    # 4-byte Folded Reload
	lw	x27, 292(x2)                    # 4-byte Folded Reload
	lw	x28, 296(x2)                    # 4-byte Folded Reload
	lw	x29, 300(x2)                    # 4-byte Folded Reload
	lw	x30, 304(x2)                    # 4-byte Folded Reload
	lw	x31, 308(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x8, -160(x6)
	xr.repeat	1, x5, x7
	lw	x24, 376(x2)                    # 4-byte Folded Reload
	lw	x25, 380(x2)                    # 4-byte Folded Reload
	lw	x26, 384(x2)                    # 4-byte Folded Reload
	lw	x27, 388(x2)                    # 4-byte Folded Reload
	lw	x28, 392(x2)                    # 4-byte Folded Reload
	lw	x29, 396(x2)                    # 4-byte Folded Reload
	lw	x30, 400(x2)                    # 4-byte Folded Reload
	lw	x31, 404(x2)                    # 4-byte Folded Reload
	lw	x16, 760(x2)                    # 4-byte Folded Reload
	lw	x17, 764(x2)                    # 4-byte Folded Reload
	lw	x18, 768(x2)                    # 4-byte Folded Reload
	lw	x19, 772(x2)                    # 4-byte Folded Reload
	lw	x20, 776(x2)                    # 4-byte Folded Reload
	lw	x21, 780(x2)                    # 4-byte Folded Reload
	lw	x22, 784(x2)                    # 4-byte Folded Reload
	lw	x23, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, -192(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 344(x2)                    # 4-byte Folded Reload
	lw	x25, 348(x2)                    # 4-byte Folded Reload
	lw	x26, 352(x2)                    # 4-byte Folded Reload
	lw	x27, 356(x2)                    # 4-byte Folded Reload
	lw	x28, 360(x2)                    # 4-byte Folded Reload
	lw	x29, 364(x2)                    # 4-byte Folded Reload
	lw	x30, 368(x2)                    # 4-byte Folded Reload
	lw	x31, 372(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, -96(x6)
	xr.repeat	1, x5, x7
	sw	x24, 696(x2)                    # 4-byte Folded Spill
	sw	x25, 700(x2)                    # 4-byte Folded Spill
	sw	x26, 704(x2)                    # 4-byte Folded Spill
	sw	x27, 708(x2)                    # 4-byte Folded Spill
	sw	x28, 712(x2)                    # 4-byte Folded Spill
	sw	x29, 716(x2)                    # 4-byte Folded Spill
	sw	x30, 720(x2)                    # 4-byte Folded Spill
	sw	x31, 724(x2)                    # 4-byte Folded Spill
	lw	x24, 600(x2)                    # 4-byte Folded Reload
	lw	x25, 604(x2)                    # 4-byte Folded Reload
	lw	x26, 608(x2)                    # 4-byte Folded Reload
	lw	x27, 612(x2)                    # 4-byte Folded Reload
	lw	x28, 616(x2)                    # 4-byte Folded Reload
	lw	x29, 620(x2)                    # 4-byte Folded Reload
	lw	x30, 624(x2)                    # 4-byte Folded Reload
	lw	x31, 628(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x8, -128(x6)
	xr.repeat	1, x5, x7
	lw	x24, 568(x2)                    # 4-byte Folded Reload
	lw	x25, 572(x2)                    # 4-byte Folded Reload
	lw	x26, 576(x2)                    # 4-byte Folded Reload
	lw	x27, 580(x2)                    # 4-byte Folded Reload
	lw	x28, 584(x2)                    # 4-byte Folded Reload
	lw	x29, 588(x2)                    # 4-byte Folded Reload
	lw	x30, 592(x2)                    # 4-byte Folded Reload
	lw	x31, 596(x2)                    # 4-byte Folded Reload
	lw	x16, 760(x2)                    # 4-byte Folded Reload
	lw	x17, 764(x2)                    # 4-byte Folded Reload
	lw	x18, 768(x2)                    # 4-byte Folded Reload
	lw	x19, 772(x2)                    # 4-byte Folded Reload
	lw	x20, 776(x2)                    # 4-byte Folded Reload
	lw	x21, 780(x2)                    # 4-byte Folded Reload
	lw	x22, 784(x2)                    # 4-byte Folded Reload
	lw	x23, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, -32(x6)
	xr.repeat	1, x5, x7
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 664(x2)                    # 4-byte Folded Reload
	lw	x25, 668(x2)                    # 4-byte Folded Reload
	lw	x26, 672(x2)                    # 4-byte Folded Reload
	lw	x27, 676(x2)                    # 4-byte Folded Reload
	lw	x28, 680(x2)                    # 4-byte Folded Reload
	lw	x29, 684(x2)                    # 4-byte Folded Reload
	lw	x30, 688(x2)                    # 4-byte Folded Reload
	lw	x31, 692(x2)                    # 4-byte Folded Reload
	lw	x16, 696(x2)                    # 4-byte Folded Reload
	lw	x17, 700(x2)                    # 4-byte Folded Reload
	lw	x18, 704(x2)                    # 4-byte Folded Reload
	lw	x19, 708(x2)                    # 4-byte Folded Reload
	lw	x20, 712(x2)                    # 4-byte Folded Reload
	lw	x21, 716(x2)                    # 4-byte Folded Reload
	lw	x22, 720(x2)                    # 4-byte Folded Reload
	lw	x23, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x16, -64(x6)
	xr.repeat	1, x5, x7
	lw	x24, 632(x2)                    # 4-byte Folded Reload
	lw	x25, 636(x2)                    # 4-byte Folded Reload
	lw	x26, 640(x2)                    # 4-byte Folded Reload
	lw	x27, 644(x2)                    # 4-byte Folded Reload
	lw	x28, 648(x2)                    # 4-byte Folded Reload
	lw	x29, 652(x2)                    # 4-byte Folded Reload
	lw	x30, 656(x2)                    # 4-byte Folded Reload
	lw	x31, 660(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x24, 64(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 184(x2)                    # 4-byte Folded Reload
	lw	x25, 188(x2)                    # 4-byte Folded Reload
	lw	x26, 192(x2)                    # 4-byte Folded Reload
	lw	x27, 196(x2)                    # 4-byte Folded Reload
	lw	x28, 200(x2)                    # 4-byte Folded Reload
	lw	x29, 204(x2)                    # 4-byte Folded Reload
	lw	x30, 208(x2)                    # 4-byte Folded Reload
	lw	x31, 212(x2)                    # 4-byte Folded Reload
	lw	x8, 728(x2)                     # 4-byte Folded Reload
	lw	x9, 732(x2)                     # 4-byte Folded Reload
	lw	x10, 736(x2)                    # 4-byte Folded Reload
	lw	x11, 740(x2)                    # 4-byte Folded Reload
	lw	x12, 744(x2)                    # 4-byte Folded Reload
	lw	x13, 748(x2)                    # 4-byte Folded Reload
	lw	x14, 752(x2)                    # 4-byte Folded Reload
	lw	x15, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x24, 96(x6)
	xr.repeat	1, x5, x7
	lw	x8, 408(x2)                     # 4-byte Folded Reload
	lw	x9, 412(x2)                     # 4-byte Folded Reload
	lw	x10, 416(x2)                    # 4-byte Folded Reload
	lw	x11, 420(x2)                    # 4-byte Folded Reload
	lw	x12, 424(x2)                    # 4-byte Folded Reload
	lw	x13, 428(x2)                    # 4-byte Folded Reload
	lw	x14, 432(x2)                    # 4-byte Folded Reload
	lw	x15, 436(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x8, x16, x1
	xr.repeat	6, x0, x7
	lw	x16, -224(x6)
	xr.repeat	1, x5, x7
	lw	x8, -256(x6)
	xr.repeat	1, x5, x7
	sw	x8, 728(x2)                     # 4-byte Folded Spill
	sw	x9, 732(x2)                     # 4-byte Folded Spill
	sw	x10, 736(x2)                    # 4-byte Folded Spill
	sw	x11, 740(x2)                    # 4-byte Folded Spill
	sw	x12, 744(x2)                    # 4-byte Folded Spill
	sw	x13, 748(x2)                    # 4-byte Folded Spill
	sw	x14, 752(x2)                    # 4-byte Folded Spill
	sw	x15, 756(x2)                    # 4-byte Folded Spill
	lw	x8, 248(x2)                     # 4-byte Folded Reload
	lw	x9, 252(x2)                     # 4-byte Folded Reload
	lw	x10, 256(x2)                    # 4-byte Folded Reload
	lw	x11, 260(x2)                    # 4-byte Folded Reload
	lw	x12, 264(x2)                    # 4-byte Folded Reload
	lw	x13, 268(x2)                    # 4-byte Folded Reload
	lw	x14, 272(x2)                    # 4-byte Folded Reload
	lw	x15, 276(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x8, x24, x1
	xr.repeat	6, x0, x7
	lw	x24, 472(x2)                    # 4-byte Folded Reload
	lw	x25, 476(x2)                    # 4-byte Folded Reload
	lw	x26, 480(x2)                    # 4-byte Folded Reload
	lw	x27, 484(x2)                    # 4-byte Folded Reload
	lw	x28, 488(x2)                    # 4-byte Folded Reload
	lw	x29, 492(x2)                    # 4-byte Folded Reload
	lw	x30, 496(x2)                    # 4-byte Folded Reload
	lw	x31, 500(x2)                    # 4-byte Folded Reload
	lw	x8, 760(x2)                     # 4-byte Folded Reload
	lw	x9, 764(x2)                     # 4-byte Folded Reload
	lw	x10, 768(x2)                    # 4-byte Folded Reload
	lw	x11, 772(x2)                    # 4-byte Folded Reload
	lw	x12, 776(x2)                    # 4-byte Folded Reload
	lw	x13, 780(x2)                    # 4-byte Folded Reload
	lw	x14, 784(x2)                    # 4-byte Folded Reload
	lw	x15, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x24, 536(x2)                    # 4-byte Folded Reload
	lw	x25, 540(x2)                    # 4-byte Folded Reload
	lw	x26, 544(x2)                    # 4-byte Folded Reload
	lw	x27, 548(x2)                    # 4-byte Folded Reload
	lw	x28, 552(x2)                    # 4-byte Folded Reload
	lw	x29, 556(x2)                    # 4-byte Folded Reload
	lw	x30, 560(x2)                    # 4-byte Folded Reload
	lw	x31, 564(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, 504(x2)                    # 4-byte Folded Reload
	lw	x25, 508(x2)                    # 4-byte Folded Reload
	lw	x26, 512(x2)                    # 4-byte Folded Reload
	lw	x27, 516(x2)                    # 4-byte Folded Reload
	lw	x28, 520(x2)                    # 4-byte Folded Reload
	lw	x29, 524(x2)                    # 4-byte Folded Reload
	lw	x30, 528(x2)                    # 4-byte Folded Reload
	lw	x31, 532(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	srai	x10, x1, 4
	sgtz	x11, x10
	neg	x11, x11
	and	x10, x11, x10
	li	x11, 127
	blt	x10, x11, .LBB0_55
# %bb.57:                               # %for.body21.i68.i
                                        #   in Loop: Header=BB0_56 Depth=3
	li	x10, 127
	j	.LBB0_55
.LBB0_58:                               # %for.cond3.preheader.i113.i.preheader
	li	x14, 0
	lui	x12, %hi(y1)
	addi	x12, x12, %lo(y1)
	lui	x10, 1
	li	x13, 17
	li	x5, 7
	lui	x11, %hi(.L_MergedGlobals)
	addi	x11, x11, %lo(.L_MergedGlobals)
	addi	x11, x11, 208
	sw	x11, 92(x2)                     # 4-byte Folded Spill
	addi	x11, x10, -1856
	slli	x13, x13, 8
	sw	x13, 88(x2)                     # 4-byte Folded Spill
	addi	x13, x10, 320
	sw	x13, 84(x2)                     # 4-byte Folded Spill
	addi	x10, x10, 384
	sw	x10, 80(x2)                     # 4-byte Folded Spill
	add	x15, x12, x11
	lui	x10, %hi(x1)
	addi	x10, x10, %lo(x1)
	add	x16, x10, x11
	j	.LBB0_60
.LBB0_59:                               # %for.cond.cleanup5.i168.i
                                        #   in Loop: Header=BB0_60 Depth=1
	li	x10, 17
	slli	x10, x10, 7
	lw	x15, 68(x2)                     # 4-byte Folded Reload
	add	x15, x15, x10
	lw	x16, 64(x2)                     # 4-byte Folded Reload
	add	x16, x16, x10
	lw	x14, 72(x2)                     # 4-byte Folded Reload
	li	x10, 32
	beq	x14, x10, .LBB0_66
.LBB0_60:                               # %for.cond3.preheader.i113.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_62 Depth 2
                                        #       Child Loop BB0_64 Depth 3
	li	x28, 0
	lw	x10, 76(x2)                     # 4-byte Folded Reload
	mul	x10, x14, x10
	slli	x11, x14, 1
	slli	x12, x14, 5
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	add	x10, x10, x13
	sw	x10, 100(x2)                    # 4-byte Folded Spill
	add	x11, x12, x11
	sw	x11, 96(x2)                     # 4-byte Folded Spill
	addi	x14, x14, 1
	sw	x14, 72(x2)                     # 4-byte Folded Spill
	sw	x16, 64(x2)                     # 4-byte Folded Spill
	mv	x29, x16
	sw	x15, 68(x2)                     # 4-byte Folded Spill
	mv	x30, x15
	j	.LBB0_62
.LBB0_61:                               # %for.cond3.loopexit.i166.i
                                        #   in Loop: Header=BB0_62 Depth=2
	lw	x30, 104(x2)                    # 4-byte Folded Reload
	addi	x30, x30, 64
	lw	x29, 108(x2)                    # 4-byte Folded Reload
	addi	x29, x29, 64
	li	x10, 32
	lw	x28, 112(x2)                    # 4-byte Folded Reload
	beq	x28, x10, .LBB0_59
.LBB0_62:                               # %for.body6.i118.i
                                        #   Parent Loop BB0_60 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_64 Depth 3
	slli	x10, x28, 6
	lw	x11, 96(x2)                     # 4-byte Folded Reload
	add	x11, x28, x11
	slli	x11, x11, 6
	lui	x12, %hi(a1)
	addi	x12, x12, %lo(a1)
	add	x11, x12, x11
	lw	x12, 88(x2)                     # 4-byte Folded Reload
	add	x12, x11, x12
	addi	x13, x11, 2047
	li	x7, 4
	lw	x16, 160(x11)
	xr.repeat	1, x7, x5
	sw	x16, 664(x2)                    # 4-byte Folded Spill
	sw	x17, 668(x2)                    # 4-byte Folded Spill
	sw	x18, 672(x2)                    # 4-byte Folded Spill
	sw	x19, 676(x2)                    # 4-byte Folded Spill
	sw	x20, 680(x2)                    # 4-byte Folded Spill
	sw	x21, 684(x2)                    # 4-byte Folded Spill
	sw	x22, 688(x2)                    # 4-byte Folded Spill
	sw	x23, 692(x2)                    # 4-byte Folded Spill
	lw	x16, 128(x11)
	xr.repeat	1, x7, x5
	sw	x16, 632(x2)                    # 4-byte Folded Spill
	sw	x17, 636(x2)                    # 4-byte Folded Spill
	sw	x18, 640(x2)                    # 4-byte Folded Spill
	sw	x19, 644(x2)                    # 4-byte Folded Spill
	sw	x20, 648(x2)                    # 4-byte Folded Spill
	sw	x21, 652(x2)                    # 4-byte Folded Spill
	sw	x22, 656(x2)                    # 4-byte Folded Spill
	sw	x23, 660(x2)                    # 4-byte Folded Spill
	lw	x14, 84(x2)                     # 4-byte Folded Reload
	add	x14, x11, x14
	lw	x15, 80(x2)                     # 4-byte Folded Reload
	add	x15, x11, x15
	addi	x31, x13, 257
	addi	x8, x13, 193
	addi	x6, x13, 129
	lw	x16, 96(x11)
	xr.repeat	1, x7, x5
	sw	x16, 600(x2)                    # 4-byte Folded Spill
	sw	x17, 604(x2)                    # 4-byte Folded Spill
	sw	x18, 608(x2)                    # 4-byte Folded Spill
	sw	x19, 612(x2)                    # 4-byte Folded Spill
	sw	x20, 616(x2)                    # 4-byte Folded Spill
	sw	x21, 620(x2)                    # 4-byte Folded Spill
	sw	x22, 624(x2)                    # 4-byte Folded Spill
	sw	x23, 628(x2)                    # 4-byte Folded Spill
	lw	x16, 64(x11)
	xr.repeat	1, x7, x5
	sw	x16, 568(x2)                    # 4-byte Folded Spill
	sw	x17, 572(x2)                    # 4-byte Folded Spill
	sw	x18, 576(x2)                    # 4-byte Folded Spill
	sw	x19, 580(x2)                    # 4-byte Folded Spill
	sw	x20, 584(x2)                    # 4-byte Folded Spill
	sw	x21, 588(x2)                    # 4-byte Folded Spill
	sw	x22, 592(x2)                    # 4-byte Folded Spill
	sw	x23, 596(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x11)
	xr.repeat	1, x7, x5
	sw	x16, 536(x2)                    # 4-byte Folded Spill
	sw	x17, 540(x2)                    # 4-byte Folded Spill
	sw	x18, 544(x2)                    # 4-byte Folded Spill
	sw	x19, 548(x2)                    # 4-byte Folded Spill
	sw	x20, 552(x2)                    # 4-byte Folded Spill
	sw	x21, 556(x2)                    # 4-byte Folded Spill
	sw	x22, 560(x2)                    # 4-byte Folded Spill
	sw	x23, 564(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x11)
	xr.repeat	1, x7, x5
	sw	x16, 504(x2)                    # 4-byte Folded Spill
	sw	x17, 508(x2)                    # 4-byte Folded Spill
	sw	x18, 512(x2)                    # 4-byte Folded Spill
	sw	x19, 516(x2)                    # 4-byte Folded Spill
	sw	x20, 520(x2)                    # 4-byte Folded Spill
	sw	x21, 524(x2)                    # 4-byte Folded Spill
	sw	x22, 528(x2)                    # 4-byte Folded Spill
	sw	x23, 532(x2)                    # 4-byte Folded Spill
	lw	x16, 257(x13)
	xr.repeat	1, x7, x5
	sw	x16, 472(x2)                    # 4-byte Folded Spill
	sw	x17, 476(x2)                    # 4-byte Folded Spill
	sw	x18, 480(x2)                    # 4-byte Folded Spill
	sw	x19, 484(x2)                    # 4-byte Folded Spill
	sw	x20, 488(x2)                    # 4-byte Folded Spill
	sw	x21, 492(x2)                    # 4-byte Folded Spill
	sw	x22, 496(x2)                    # 4-byte Folded Spill
	sw	x23, 500(x2)                    # 4-byte Folded Spill
	lw	x16, 193(x13)
	xr.repeat	1, x7, x5
	sw	x16, 440(x2)                    # 4-byte Folded Spill
	sw	x17, 444(x2)                    # 4-byte Folded Spill
	sw	x18, 448(x2)                    # 4-byte Folded Spill
	sw	x19, 452(x2)                    # 4-byte Folded Spill
	sw	x20, 456(x2)                    # 4-byte Folded Spill
	sw	x21, 460(x2)                    # 4-byte Folded Spill
	sw	x22, 464(x2)                    # 4-byte Folded Spill
	sw	x23, 468(x2)                    # 4-byte Folded Spill
	lw	x16, 129(x13)
	xr.repeat	1, x7, x5
	sw	x16, 408(x2)                    # 4-byte Folded Spill
	sw	x17, 412(x2)                    # 4-byte Folded Spill
	sw	x18, 416(x2)                    # 4-byte Folded Spill
	sw	x19, 420(x2)                    # 4-byte Folded Spill
	sw	x20, 424(x2)                    # 4-byte Folded Spill
	sw	x21, 428(x2)                    # 4-byte Folded Spill
	sw	x22, 432(x2)                    # 4-byte Folded Spill
	sw	x23, 436(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x12)
	xr.repeat	1, x7, x5
	sw	x16, 376(x2)                    # 4-byte Folded Spill
	sw	x17, 380(x2)                    # 4-byte Folded Spill
	sw	x18, 384(x2)                    # 4-byte Folded Spill
	sw	x19, 388(x2)                    # 4-byte Folded Spill
	sw	x20, 392(x2)                    # 4-byte Folded Spill
	sw	x21, 396(x2)                    # 4-byte Folded Spill
	sw	x22, 400(x2)                    # 4-byte Folded Spill
	sw	x23, 404(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x12)
	xr.repeat	1, x7, x5
	sw	x16, 344(x2)                    # 4-byte Folded Spill
	sw	x17, 348(x2)                    # 4-byte Folded Spill
	sw	x18, 352(x2)                    # 4-byte Folded Spill
	sw	x19, 356(x2)                    # 4-byte Folded Spill
	sw	x20, 360(x2)                    # 4-byte Folded Spill
	sw	x21, 364(x2)                    # 4-byte Folded Spill
	sw	x22, 368(x2)                    # 4-byte Folded Spill
	sw	x23, 372(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x14)
	xr.repeat	1, x7, x5
	sw	x16, 312(x2)                    # 4-byte Folded Spill
	sw	x17, 316(x2)                    # 4-byte Folded Spill
	sw	x18, 320(x2)                    # 4-byte Folded Spill
	sw	x19, 324(x2)                    # 4-byte Folded Spill
	sw	x20, 328(x2)                    # 4-byte Folded Spill
	sw	x21, 332(x2)                    # 4-byte Folded Spill
	sw	x22, 336(x2)                    # 4-byte Folded Spill
	sw	x23, 340(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x14)
	xr.repeat	1, x7, x5
	sw	x16, 280(x2)                    # 4-byte Folded Spill
	sw	x17, 284(x2)                    # 4-byte Folded Spill
	sw	x18, 288(x2)                    # 4-byte Folded Spill
	sw	x19, 292(x2)                    # 4-byte Folded Spill
	sw	x20, 296(x2)                    # 4-byte Folded Spill
	sw	x21, 300(x2)                    # 4-byte Folded Spill
	sw	x22, 304(x2)                    # 4-byte Folded Spill
	sw	x23, 308(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x31)
	xr.repeat	1, x7, x5
	sw	x16, 248(x2)                    # 4-byte Folded Spill
	sw	x17, 252(x2)                    # 4-byte Folded Spill
	sw	x18, 256(x2)                    # 4-byte Folded Spill
	sw	x19, 260(x2)                    # 4-byte Folded Spill
	sw	x20, 264(x2)                    # 4-byte Folded Spill
	sw	x21, 268(x2)                    # 4-byte Folded Spill
	sw	x22, 272(x2)                    # 4-byte Folded Spill
	sw	x23, 276(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x8)
	xr.repeat	1, x7, x5
	sw	x16, 216(x2)                    # 4-byte Folded Spill
	sw	x17, 220(x2)                    # 4-byte Folded Spill
	sw	x18, 224(x2)                    # 4-byte Folded Spill
	sw	x19, 228(x2)                    # 4-byte Folded Spill
	sw	x20, 232(x2)                    # 4-byte Folded Spill
	sw	x21, 236(x2)                    # 4-byte Folded Spill
	sw	x22, 240(x2)                    # 4-byte Folded Spill
	sw	x23, 244(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x6)
	xr.repeat	1, x7, x5
	sw	x16, 184(x2)                    # 4-byte Folded Spill
	sw	x17, 188(x2)                    # 4-byte Folded Spill
	sw	x18, 192(x2)                    # 4-byte Folded Spill
	sw	x19, 196(x2)                    # 4-byte Folded Spill
	sw	x20, 200(x2)                    # 4-byte Folded Spill
	sw	x21, 204(x2)                    # 4-byte Folded Spill
	sw	x22, 208(x2)                    # 4-byte Folded Spill
	sw	x23, 212(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x15)
	xr.repeat	1, x7, x5
	sw	x16, 152(x2)                    # 4-byte Folded Spill
	sw	x17, 156(x2)                    # 4-byte Folded Spill
	sw	x18, 160(x2)                    # 4-byte Folded Spill
	sw	x19, 164(x2)                    # 4-byte Folded Spill
	sw	x20, 168(x2)                    # 4-byte Folded Spill
	sw	x21, 172(x2)                    # 4-byte Folded Spill
	sw	x22, 176(x2)                    # 4-byte Folded Spill
	sw	x23, 180(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x15)
	xr.repeat	1, x7, x5
	sw	x16, 120(x2)                    # 4-byte Folded Spill
	sw	x17, 124(x2)                    # 4-byte Folded Spill
	sw	x18, 128(x2)                    # 4-byte Folded Spill
	sw	x19, 132(x2)                    # 4-byte Folded Spill
	sw	x20, 136(x2)                    # 4-byte Folded Spill
	sw	x21, 140(x2)                    # 4-byte Folded Spill
	sw	x22, 144(x2)                    # 4-byte Folded Spill
	sw	x23, 148(x2)                    # 4-byte Folded Spill
	lw	x11, 100(x2)                    # 4-byte Folded Reload
	add	x10, x11, x10
	lui	x11, %hi(y1)
	addi	x11, x11, %lo(y1)
	add	x10, x11, x10
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	addi	x28, x28, 1
	sw	x28, 112(x2)                    # 4-byte Folded Spill
	lui	x1, %hi(w_s1b+256)
	addi	x1, x1, %lo(w_s1b+256)
	lw	x11, 92(x2)                     # 4-byte Folded Reload
	sw	x29, 108(x2)                    # 4-byte Folded Spill
	sw	x30, 104(x2)                    # 4-byte Folded Spill
	j	.LBB0_64
.LBB0_63:                               # %for.body21.i126.i
                                        #   in Loop: Header=BB0_64 Depth=3
	lw	x12, 760(x2)                    # 4-byte Folded Reload
	sw	x10, 0(x12)
	addi	x30, x12, 4
	lw	x29, 824(x2)                    # 4-byte Folded Reload
	addi	x29, x29, 4
	lw	x11, 792(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 4
	addi	x1, x1, 576
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	beq	x30, x10, .LBB0_61
.LBB0_64:                               # %for.body21.i126.i
                                        #   Parent Loop BB0_60 Depth=1
                                        #     Parent Loop BB0_62 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	sw	x29, 824(x2)                    # 4-byte Folded Spill
	sw	x30, 760(x2)                    # 4-byte Folded Spill
	sw	x11, 792(x2)                    # 4-byte Folded Spill
	lw	x6, 0(x11)
	li	x7, 4
	lw	x16, 32(x1)
	xr.repeat	1, x7, x5
	lw	x24, 0(x1)
	xr.repeat	1, x7, x5
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x8, 288(x1)
	xr.repeat	1, x7, x5
	lw	x24, 216(x2)                    # 4-byte Folded Reload
	lw	x25, 220(x2)                    # 4-byte Folded Reload
	lw	x26, 224(x2)                    # 4-byte Folded Reload
	lw	x27, 228(x2)                    # 4-byte Folded Reload
	lw	x28, 232(x2)                    # 4-byte Folded Reload
	lw	x29, 236(x2)                    # 4-byte Folded Reload
	lw	x30, 240(x2)                    # 4-byte Folded Reload
	lw	x31, 244(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, 256(x1)
	xr.repeat	1, x7, x5
	sw	x24, 696(x2)                    # 4-byte Folded Spill
	sw	x25, 700(x2)                    # 4-byte Folded Spill
	sw	x26, 704(x2)                    # 4-byte Folded Spill
	sw	x27, 708(x2)                    # 4-byte Folded Spill
	sw	x28, 712(x2)                    # 4-byte Folded Spill
	sw	x29, 716(x2)                    # 4-byte Folded Spill
	sw	x30, 720(x2)                    # 4-byte Folded Spill
	sw	x31, 724(x2)                    # 4-byte Folded Spill
	lw	x24, 440(x2)                    # 4-byte Folded Reload
	lw	x25, 444(x2)                    # 4-byte Folded Reload
	lw	x26, 448(x2)                    # 4-byte Folded Reload
	lw	x27, 452(x2)                    # 4-byte Folded Reload
	lw	x28, 456(x2)                    # 4-byte Folded Reload
	lw	x29, 460(x2)                    # 4-byte Folded Reload
	lw	x30, 464(x2)                    # 4-byte Folded Reload
	lw	x31, 468(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, 224(x1)
	xr.repeat	1, x7, x5
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 152(x2)                    # 4-byte Folded Reload
	lw	x25, 156(x2)                    # 4-byte Folded Reload
	lw	x26, 160(x2)                    # 4-byte Folded Reload
	lw	x27, 164(x2)                    # 4-byte Folded Reload
	lw	x28, 168(x2)                    # 4-byte Folded Reload
	lw	x29, 172(x2)                    # 4-byte Folded Reload
	lw	x30, 176(x2)                    # 4-byte Folded Reload
	lw	x31, 180(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x8, x6
	xr.repeat	6, x0, x5
	lw	x8, 192(x1)
	xr.repeat	1, x7, x5
	lw	x24, 120(x2)                    # 4-byte Folded Reload
	lw	x25, 124(x2)                    # 4-byte Folded Reload
	lw	x26, 128(x2)                    # 4-byte Folded Reload
	lw	x27, 132(x2)                    # 4-byte Folded Reload
	lw	x28, 136(x2)                    # 4-byte Folded Reload
	lw	x29, 140(x2)                    # 4-byte Folded Reload
	lw	x30, 144(x2)                    # 4-byte Folded Reload
	lw	x31, 148(x2)                    # 4-byte Folded Reload
	lw	x16, 696(x2)                    # 4-byte Folded Reload
	lw	x17, 700(x2)                    # 4-byte Folded Reload
	lw	x18, 704(x2)                    # 4-byte Folded Reload
	lw	x19, 708(x2)                    # 4-byte Folded Reload
	lw	x20, 712(x2)                    # 4-byte Folded Reload
	lw	x21, 716(x2)                    # 4-byte Folded Reload
	lw	x22, 720(x2)                    # 4-byte Folded Reload
	lw	x23, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, 160(x1)
	xr.repeat	1, x7, x5
	sw	x24, 696(x2)                    # 4-byte Folded Spill
	sw	x25, 700(x2)                    # 4-byte Folded Spill
	sw	x26, 704(x2)                    # 4-byte Folded Spill
	sw	x27, 708(x2)                    # 4-byte Folded Spill
	sw	x28, 712(x2)                    # 4-byte Folded Spill
	sw	x29, 716(x2)                    # 4-byte Folded Spill
	sw	x30, 720(x2)                    # 4-byte Folded Spill
	sw	x31, 724(x2)                    # 4-byte Folded Spill
	lw	x24, 312(x2)                    # 4-byte Folded Reload
	lw	x25, 316(x2)                    # 4-byte Folded Reload
	lw	x26, 320(x2)                    # 4-byte Folded Reload
	lw	x27, 324(x2)                    # 4-byte Folded Reload
	lw	x28, 328(x2)                    # 4-byte Folded Reload
	lw	x29, 332(x2)                    # 4-byte Folded Reload
	lw	x30, 336(x2)                    # 4-byte Folded Reload
	lw	x31, 340(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, 128(x1)
	xr.repeat	1, x7, x5
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 280(x2)                    # 4-byte Folded Reload
	lw	x25, 284(x2)                    # 4-byte Folded Reload
	lw	x26, 288(x2)                    # 4-byte Folded Reload
	lw	x27, 292(x2)                    # 4-byte Folded Reload
	lw	x28, 296(x2)                    # 4-byte Folded Reload
	lw	x29, 300(x2)                    # 4-byte Folded Reload
	lw	x30, 304(x2)                    # 4-byte Folded Reload
	lw	x31, 308(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x8, x6
	xr.repeat	6, x0, x5
	lw	x8, -160(x1)
	xr.repeat	1, x7, x5
	lw	x24, 376(x2)                    # 4-byte Folded Reload
	lw	x25, 380(x2)                    # 4-byte Folded Reload
	lw	x26, 384(x2)                    # 4-byte Folded Reload
	lw	x27, 388(x2)                    # 4-byte Folded Reload
	lw	x28, 392(x2)                    # 4-byte Folded Reload
	lw	x29, 396(x2)                    # 4-byte Folded Reload
	lw	x30, 400(x2)                    # 4-byte Folded Reload
	lw	x31, 404(x2)                    # 4-byte Folded Reload
	lw	x16, 696(x2)                    # 4-byte Folded Reload
	lw	x17, 700(x2)                    # 4-byte Folded Reload
	lw	x18, 704(x2)                    # 4-byte Folded Reload
	lw	x19, 708(x2)                    # 4-byte Folded Reload
	lw	x20, 712(x2)                    # 4-byte Folded Reload
	lw	x21, 716(x2)                    # 4-byte Folded Reload
	lw	x22, 720(x2)                    # 4-byte Folded Reload
	lw	x23, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, -192(x1)
	xr.repeat	1, x7, x5
	sw	x24, 696(x2)                    # 4-byte Folded Spill
	sw	x25, 700(x2)                    # 4-byte Folded Spill
	sw	x26, 704(x2)                    # 4-byte Folded Spill
	sw	x27, 708(x2)                    # 4-byte Folded Spill
	sw	x28, 712(x2)                    # 4-byte Folded Spill
	sw	x29, 716(x2)                    # 4-byte Folded Spill
	sw	x30, 720(x2)                    # 4-byte Folded Spill
	sw	x31, 724(x2)                    # 4-byte Folded Spill
	lw	x24, 344(x2)                    # 4-byte Folded Reload
	lw	x25, 348(x2)                    # 4-byte Folded Reload
	lw	x26, 352(x2)                    # 4-byte Folded Reload
	lw	x27, 356(x2)                    # 4-byte Folded Reload
	lw	x28, 360(x2)                    # 4-byte Folded Reload
	lw	x29, 364(x2)                    # 4-byte Folded Reload
	lw	x30, 368(x2)                    # 4-byte Folded Reload
	lw	x31, 372(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, -96(x1)
	xr.repeat	1, x7, x5
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 600(x2)                    # 4-byte Folded Reload
	lw	x25, 604(x2)                    # 4-byte Folded Reload
	lw	x26, 608(x2)                    # 4-byte Folded Reload
	lw	x27, 612(x2)                    # 4-byte Folded Reload
	lw	x28, 616(x2)                    # 4-byte Folded Reload
	lw	x29, 620(x2)                    # 4-byte Folded Reload
	lw	x30, 624(x2)                    # 4-byte Folded Reload
	lw	x31, 628(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x8, x6
	xr.repeat	6, x0, x5
	lw	x8, -128(x1)
	xr.repeat	1, x7, x5
	lw	x24, 568(x2)                    # 4-byte Folded Reload
	lw	x25, 572(x2)                    # 4-byte Folded Reload
	lw	x26, 576(x2)                    # 4-byte Folded Reload
	lw	x27, 580(x2)                    # 4-byte Folded Reload
	lw	x28, 584(x2)                    # 4-byte Folded Reload
	lw	x29, 588(x2)                    # 4-byte Folded Reload
	lw	x30, 592(x2)                    # 4-byte Folded Reload
	lw	x31, 596(x2)                    # 4-byte Folded Reload
	lw	x16, 696(x2)                    # 4-byte Folded Reload
	lw	x17, 700(x2)                    # 4-byte Folded Reload
	lw	x18, 704(x2)                    # 4-byte Folded Reload
	lw	x19, 708(x2)                    # 4-byte Folded Reload
	lw	x20, 712(x2)                    # 4-byte Folded Reload
	lw	x21, 716(x2)                    # 4-byte Folded Reload
	lw	x22, 720(x2)                    # 4-byte Folded Reload
	lw	x23, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, -32(x1)
	xr.repeat	1, x7, x5
	sw	x24, 696(x2)                    # 4-byte Folded Spill
	sw	x25, 700(x2)                    # 4-byte Folded Spill
	sw	x26, 704(x2)                    # 4-byte Folded Spill
	sw	x27, 708(x2)                    # 4-byte Folded Spill
	sw	x28, 712(x2)                    # 4-byte Folded Spill
	sw	x29, 716(x2)                    # 4-byte Folded Spill
	sw	x30, 720(x2)                    # 4-byte Folded Spill
	sw	x31, 724(x2)                    # 4-byte Folded Spill
	lw	x24, 664(x2)                    # 4-byte Folded Reload
	lw	x25, 668(x2)                    # 4-byte Folded Reload
	lw	x26, 672(x2)                    # 4-byte Folded Reload
	lw	x27, 676(x2)                    # 4-byte Folded Reload
	lw	x28, 680(x2)                    # 4-byte Folded Reload
	lw	x29, 684(x2)                    # 4-byte Folded Reload
	lw	x30, 688(x2)                    # 4-byte Folded Reload
	lw	x31, 692(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, -64(x1)
	xr.repeat	1, x7, x5
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 632(x2)                    # 4-byte Folded Reload
	lw	x25, 636(x2)                    # 4-byte Folded Reload
	lw	x26, 640(x2)                    # 4-byte Folded Reload
	lw	x27, 644(x2)                    # 4-byte Folded Reload
	lw	x28, 648(x2)                    # 4-byte Folded Reload
	lw	x29, 652(x2)                    # 4-byte Folded Reload
	lw	x30, 656(x2)                    # 4-byte Folded Reload
	lw	x31, 660(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x8, x6
	xr.repeat	6, x0, x5
	lw	x8, 96(x1)
	xr.repeat	1, x7, x5
	lw	x24, 184(x2)                    # 4-byte Folded Reload
	lw	x25, 188(x2)                    # 4-byte Folded Reload
	lw	x26, 192(x2)                    # 4-byte Folded Reload
	lw	x27, 196(x2)                    # 4-byte Folded Reload
	lw	x28, 200(x2)                    # 4-byte Folded Reload
	lw	x29, 204(x2)                    # 4-byte Folded Reload
	lw	x30, 208(x2)                    # 4-byte Folded Reload
	lw	x31, 212(x2)                    # 4-byte Folded Reload
	lw	x16, 696(x2)                    # 4-byte Folded Reload
	lw	x17, 700(x2)                    # 4-byte Folded Reload
	lw	x18, 704(x2)                    # 4-byte Folded Reload
	lw	x19, 708(x2)                    # 4-byte Folded Reload
	lw	x20, 712(x2)                    # 4-byte Folded Reload
	lw	x21, 716(x2)                    # 4-byte Folded Reload
	lw	x22, 720(x2)                    # 4-byte Folded Reload
	lw	x23, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, 64(x1)
	xr.repeat	1, x7, x5
	sw	x24, 696(x2)                    # 4-byte Folded Spill
	sw	x25, 700(x2)                    # 4-byte Folded Spill
	sw	x26, 704(x2)                    # 4-byte Folded Spill
	sw	x27, 708(x2)                    # 4-byte Folded Spill
	sw	x28, 712(x2)                    # 4-byte Folded Spill
	sw	x29, 716(x2)                    # 4-byte Folded Spill
	sw	x30, 720(x2)                    # 4-byte Folded Spill
	sw	x31, 724(x2)                    # 4-byte Folded Spill
	lw	x24, 408(x2)                    # 4-byte Folded Reload
	lw	x25, 412(x2)                    # 4-byte Folded Reload
	lw	x26, 416(x2)                    # 4-byte Folded Reload
	lw	x27, 420(x2)                    # 4-byte Folded Reload
	lw	x28, 424(x2)                    # 4-byte Folded Reload
	lw	x29, 428(x2)                    # 4-byte Folded Reload
	lw	x30, 432(x2)                    # 4-byte Folded Reload
	lw	x31, 436(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x24, -224(x1)
	xr.repeat	1, x7, x5
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 248(x2)                    # 4-byte Folded Reload
	lw	x25, 252(x2)                    # 4-byte Folded Reload
	lw	x26, 256(x2)                    # 4-byte Folded Reload
	lw	x27, 260(x2)                    # 4-byte Folded Reload
	lw	x28, 264(x2)                    # 4-byte Folded Reload
	lw	x29, 268(x2)                    # 4-byte Folded Reload
	lw	x30, 272(x2)                    # 4-byte Folded Reload
	lw	x31, 276(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x8, x6
	xr.repeat	6, x0, x5
	lw	x8, -256(x1)
	xr.repeat	1, x7, x5
	lw	x24, 472(x2)                    # 4-byte Folded Reload
	lw	x25, 476(x2)                    # 4-byte Folded Reload
	lw	x26, 480(x2)                    # 4-byte Folded Reload
	lw	x27, 484(x2)                    # 4-byte Folded Reload
	lw	x28, 488(x2)                    # 4-byte Folded Reload
	lw	x29, 492(x2)                    # 4-byte Folded Reload
	lw	x30, 496(x2)                    # 4-byte Folded Reload
	lw	x31, 500(x2)                    # 4-byte Folded Reload
	lw	x16, 696(x2)                    # 4-byte Folded Reload
	lw	x17, 700(x2)                    # 4-byte Folded Reload
	lw	x18, 704(x2)                    # 4-byte Folded Reload
	lw	x19, 708(x2)                    # 4-byte Folded Reload
	lw	x20, 712(x2)                    # 4-byte Folded Reload
	lw	x21, 716(x2)                    # 4-byte Folded Reload
	lw	x22, 720(x2)                    # 4-byte Folded Reload
	lw	x23, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x16, x6
	xr.repeat	6, x0, x5
	lw	x16, 824(x2)                    # 4-byte Folded Reload
	lw	x7, 0(x16)
	lw	x16, 536(x2)                    # 4-byte Folded Reload
	lw	x17, 540(x2)                    # 4-byte Folded Reload
	lw	x18, 544(x2)                    # 4-byte Folded Reload
	lw	x19, 548(x2)                    # 4-byte Folded Reload
	lw	x20, 552(x2)                    # 4-byte Folded Reload
	lw	x21, 556(x2)                    # 4-byte Folded Reload
	lw	x22, 560(x2)                    # 4-byte Folded Reload
	lw	x23, 564(x2)                    # 4-byte Folded Reload
	lw	x24, 728(x2)                    # 4-byte Folded Reload
	lw	x25, 732(x2)                    # 4-byte Folded Reload
	lw	x26, 736(x2)                    # 4-byte Folded Reload
	lw	x27, 740(x2)                    # 4-byte Folded Reload
	lw	x28, 744(x2)                    # 4-byte Folded Reload
	lw	x29, 748(x2)                    # 4-byte Folded Reload
	lw	x30, 752(x2)                    # 4-byte Folded Reload
	lw	x31, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x16, x24, x6
	xr.repeat	6, x0, x5
	lw	x24, 504(x2)                    # 4-byte Folded Reload
	lw	x25, 508(x2)                    # 4-byte Folded Reload
	lw	x26, 512(x2)                    # 4-byte Folded Reload
	lw	x27, 516(x2)                    # 4-byte Folded Reload
	lw	x28, 520(x2)                    # 4-byte Folded Reload
	lw	x29, 524(x2)                    # 4-byte Folded Reload
	lw	x30, 528(x2)                    # 4-byte Folded Reload
	lw	x31, 532(x2)                    # 4-byte Folded Reload
	xr.mac	x6, x24, x8, x6
	xr.repeat	6, x0, x5
	srai	x10, x6, 4
	add	x10, x7, x10
	sgtz	x11, x10
	neg	x11, x11
	and	x10, x11, x10
	li	x11, 127
	blt	x10, x11, .LBB0_63
# %bb.65:                               # %for.body21.i126.i
                                        #   in Loop: Header=BB0_64 Depth=3
	li	x10, 127
	j	.LBB0_63
.LBB0_66:                               # %conv.exit170.i
	li	x16, 0
	li	x10, 9
	#APP
	#NO_APP
	lui	x11, 65555
	li	x12, 2
	lui	x15, %hi(a2)
	addi	x15, x15, %lo(a2)
	li	x13, 17
	lui	x14, 1
	slli	x10, x10, 9
	sw	x12, 0(x11)
	addi	x11, x15, 2047
	slli	x13, x13, 8
	sw	x13, 96(x2)                     # 4-byte Folded Spill
	addi	x12, x14, 320
	sw	x12, 92(x2)                     # 4-byte Folded Spill
	#APP
	#NO_APP
	sw	x11, 68(x2)                     # 4-byte Folded Spill
	addi	x15, x11, 385
	sw	x10, 52(x2)                     # 4-byte Folded Spill
	addi	x10, x10, -256
	sw	x10, 80(x2)                     # 4-byte Folded Spill
	addi	x10, x14, 384
	sw	x10, 88(x2)                     # 4-byte Folded Spill
	lui	x10, %hi(.L_MergedGlobals)
	addi	x10, x10, %lo(.L_MergedGlobals)
	addi	x10, x10, 272
	sw	x10, 84(x2)                     # 4-byte Folded Spill
	j	.LBB0_68
.LBB0_67:                               # %for.cond.cleanup5.i226.i
                                        #   in Loop: Header=BB0_68 Depth=1
	lw	x10, 72(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 2047
	addi	x15, x10, 257
	lw	x16, 76(x2)                     # 4-byte Folded Reload
	li	x10, 16
	beq	x16, x10, .LBB0_74
.LBB0_68:                               # %for.cond3.preheader.i171.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_70 Depth 2
                                        #       Child Loop BB0_72 Depth 3
	li	x28, 0
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	mul	x11, x16, x13
	lw	x12, 80(x2)                     # 4-byte Folded Reload
	mul	x12, x16, x12
	addi	x10, x16, 1
	sw	x10, 76(x2)                     # 4-byte Folded Spill
	add	x11, x13, x11
	addi	x10, x11, 256
	sw	x10, 104(x2)                    # 4-byte Folded Spill
	lui	x10, %hi(y1)
	addi	x10, x10, %lo(y1)
	add	x10, x10, x12
	sw	x10, 100(x2)                    # 4-byte Folded Spill
	sw	x15, 72(x2)                     # 4-byte Folded Spill
	mv	x29, x15
	j	.LBB0_70
.LBB0_69:                               # %for.cond3.loopexit.i224.i
                                        #   in Loop: Header=BB0_70 Depth=2
	lw	x29, 108(x2)                    # 4-byte Folded Reload
	addi	x29, x29, 128
	li	x10, 16
	lw	x28, 112(x2)                    # 4-byte Folded Reload
	beq	x28, x10, .LBB0_67
.LBB0_70:                               # %for.body6.i176.i
                                        #   Parent Loop BB0_68 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_72 Depth 3
	slli	x10, x28, 7
	lw	x11, 100(x2)                    # 4-byte Folded Reload
	add	x11, x11, x10
	lw	x12, 96(x2)                     # 4-byte Folded Reload
	add	x12, x11, x12
	addi	x13, x11, 2047
	li	x5, 4
	li	x6, 7
	lw	x16, 160(x11)
	xr.repeat	1, x5, x6
	sw	x16, 664(x2)                    # 4-byte Folded Spill
	sw	x17, 668(x2)                    # 4-byte Folded Spill
	sw	x18, 672(x2)                    # 4-byte Folded Spill
	sw	x19, 676(x2)                    # 4-byte Folded Spill
	sw	x20, 680(x2)                    # 4-byte Folded Spill
	sw	x21, 684(x2)                    # 4-byte Folded Spill
	sw	x22, 688(x2)                    # 4-byte Folded Spill
	sw	x23, 692(x2)                    # 4-byte Folded Spill
	lw	x16, 128(x11)
	xr.repeat	1, x5, x6
	sw	x16, 632(x2)                    # 4-byte Folded Spill
	sw	x17, 636(x2)                    # 4-byte Folded Spill
	sw	x18, 640(x2)                    # 4-byte Folded Spill
	sw	x19, 644(x2)                    # 4-byte Folded Spill
	sw	x20, 648(x2)                    # 4-byte Folded Spill
	sw	x21, 652(x2)                    # 4-byte Folded Spill
	sw	x22, 656(x2)                    # 4-byte Folded Spill
	sw	x23, 660(x2)                    # 4-byte Folded Spill
	lw	x14, 92(x2)                     # 4-byte Folded Reload
	add	x14, x11, x14
	lw	x15, 88(x2)                     # 4-byte Folded Reload
	add	x15, x11, x15
	addi	x30, x13, 257
	addi	x31, x13, 193
	addi	x7, x13, 129
	lw	x16, 96(x11)
	xr.repeat	1, x5, x6
	sw	x16, 600(x2)                    # 4-byte Folded Spill
	sw	x17, 604(x2)                    # 4-byte Folded Spill
	sw	x18, 608(x2)                    # 4-byte Folded Spill
	sw	x19, 612(x2)                    # 4-byte Folded Spill
	sw	x20, 616(x2)                    # 4-byte Folded Spill
	sw	x21, 620(x2)                    # 4-byte Folded Spill
	sw	x22, 624(x2)                    # 4-byte Folded Spill
	sw	x23, 628(x2)                    # 4-byte Folded Spill
	lw	x16, 64(x11)
	xr.repeat	1, x5, x6
	sw	x16, 568(x2)                    # 4-byte Folded Spill
	sw	x17, 572(x2)                    # 4-byte Folded Spill
	sw	x18, 576(x2)                    # 4-byte Folded Spill
	sw	x19, 580(x2)                    # 4-byte Folded Spill
	sw	x20, 584(x2)                    # 4-byte Folded Spill
	sw	x21, 588(x2)                    # 4-byte Folded Spill
	sw	x22, 592(x2)                    # 4-byte Folded Spill
	sw	x23, 596(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x11)
	xr.repeat	1, x5, x6
	sw	x16, 536(x2)                    # 4-byte Folded Spill
	sw	x17, 540(x2)                    # 4-byte Folded Spill
	sw	x18, 544(x2)                    # 4-byte Folded Spill
	sw	x19, 548(x2)                    # 4-byte Folded Spill
	sw	x20, 552(x2)                    # 4-byte Folded Spill
	sw	x21, 556(x2)                    # 4-byte Folded Spill
	sw	x22, 560(x2)                    # 4-byte Folded Spill
	sw	x23, 564(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x11)
	xr.repeat	1, x5, x6
	sw	x16, 504(x2)                    # 4-byte Folded Spill
	sw	x17, 508(x2)                    # 4-byte Folded Spill
	sw	x18, 512(x2)                    # 4-byte Folded Spill
	sw	x19, 516(x2)                    # 4-byte Folded Spill
	sw	x20, 520(x2)                    # 4-byte Folded Spill
	sw	x21, 524(x2)                    # 4-byte Folded Spill
	sw	x22, 528(x2)                    # 4-byte Folded Spill
	sw	x23, 532(x2)                    # 4-byte Folded Spill
	lw	x16, 257(x13)
	xr.repeat	1, x5, x6
	sw	x16, 472(x2)                    # 4-byte Folded Spill
	sw	x17, 476(x2)                    # 4-byte Folded Spill
	sw	x18, 480(x2)                    # 4-byte Folded Spill
	sw	x19, 484(x2)                    # 4-byte Folded Spill
	sw	x20, 488(x2)                    # 4-byte Folded Spill
	sw	x21, 492(x2)                    # 4-byte Folded Spill
	sw	x22, 496(x2)                    # 4-byte Folded Spill
	sw	x23, 500(x2)                    # 4-byte Folded Spill
	lw	x16, 193(x13)
	xr.repeat	1, x5, x6
	sw	x16, 440(x2)                    # 4-byte Folded Spill
	sw	x17, 444(x2)                    # 4-byte Folded Spill
	sw	x18, 448(x2)                    # 4-byte Folded Spill
	sw	x19, 452(x2)                    # 4-byte Folded Spill
	sw	x20, 456(x2)                    # 4-byte Folded Spill
	sw	x21, 460(x2)                    # 4-byte Folded Spill
	sw	x22, 464(x2)                    # 4-byte Folded Spill
	sw	x23, 468(x2)                    # 4-byte Folded Spill
	lw	x16, 129(x13)
	xr.repeat	1, x5, x6
	sw	x16, 408(x2)                    # 4-byte Folded Spill
	sw	x17, 412(x2)                    # 4-byte Folded Spill
	sw	x18, 416(x2)                    # 4-byte Folded Spill
	sw	x19, 420(x2)                    # 4-byte Folded Spill
	sw	x20, 424(x2)                    # 4-byte Folded Spill
	sw	x21, 428(x2)                    # 4-byte Folded Spill
	sw	x22, 432(x2)                    # 4-byte Folded Spill
	sw	x23, 436(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x12)
	xr.repeat	1, x5, x6
	sw	x16, 376(x2)                    # 4-byte Folded Spill
	sw	x17, 380(x2)                    # 4-byte Folded Spill
	sw	x18, 384(x2)                    # 4-byte Folded Spill
	sw	x19, 388(x2)                    # 4-byte Folded Spill
	sw	x20, 392(x2)                    # 4-byte Folded Spill
	sw	x21, 396(x2)                    # 4-byte Folded Spill
	sw	x22, 400(x2)                    # 4-byte Folded Spill
	sw	x23, 404(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x12)
	xr.repeat	1, x5, x6
	sw	x16, 344(x2)                    # 4-byte Folded Spill
	sw	x17, 348(x2)                    # 4-byte Folded Spill
	sw	x18, 352(x2)                    # 4-byte Folded Spill
	sw	x19, 356(x2)                    # 4-byte Folded Spill
	sw	x20, 360(x2)                    # 4-byte Folded Spill
	sw	x21, 364(x2)                    # 4-byte Folded Spill
	sw	x22, 368(x2)                    # 4-byte Folded Spill
	sw	x23, 372(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x14)
	xr.repeat	1, x5, x6
	sw	x16, 312(x2)                    # 4-byte Folded Spill
	sw	x17, 316(x2)                    # 4-byte Folded Spill
	sw	x18, 320(x2)                    # 4-byte Folded Spill
	sw	x19, 324(x2)                    # 4-byte Folded Spill
	sw	x20, 328(x2)                    # 4-byte Folded Spill
	sw	x21, 332(x2)                    # 4-byte Folded Spill
	sw	x22, 336(x2)                    # 4-byte Folded Spill
	sw	x23, 340(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x14)
	xr.repeat	1, x5, x6
	sw	x16, 280(x2)                    # 4-byte Folded Spill
	sw	x17, 284(x2)                    # 4-byte Folded Spill
	sw	x18, 288(x2)                    # 4-byte Folded Spill
	sw	x19, 292(x2)                    # 4-byte Folded Spill
	sw	x20, 296(x2)                    # 4-byte Folded Spill
	sw	x21, 300(x2)                    # 4-byte Folded Spill
	sw	x22, 304(x2)                    # 4-byte Folded Spill
	sw	x23, 308(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x30)
	xr.repeat	1, x5, x6
	sw	x16, 248(x2)                    # 4-byte Folded Spill
	sw	x17, 252(x2)                    # 4-byte Folded Spill
	sw	x18, 256(x2)                    # 4-byte Folded Spill
	sw	x19, 260(x2)                    # 4-byte Folded Spill
	sw	x20, 264(x2)                    # 4-byte Folded Spill
	sw	x21, 268(x2)                    # 4-byte Folded Spill
	sw	x22, 272(x2)                    # 4-byte Folded Spill
	sw	x23, 276(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x31)
	xr.repeat	1, x5, x6
	sw	x16, 216(x2)                    # 4-byte Folded Spill
	sw	x17, 220(x2)                    # 4-byte Folded Spill
	sw	x18, 224(x2)                    # 4-byte Folded Spill
	sw	x19, 228(x2)                    # 4-byte Folded Spill
	sw	x20, 232(x2)                    # 4-byte Folded Spill
	sw	x21, 236(x2)                    # 4-byte Folded Spill
	sw	x22, 240(x2)                    # 4-byte Folded Spill
	sw	x23, 244(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x7)
	xr.repeat	1, x5, x6
	sw	x16, 184(x2)                    # 4-byte Folded Spill
	sw	x17, 188(x2)                    # 4-byte Folded Spill
	sw	x18, 192(x2)                    # 4-byte Folded Spill
	sw	x19, 196(x2)                    # 4-byte Folded Spill
	sw	x20, 200(x2)                    # 4-byte Folded Spill
	sw	x21, 204(x2)                    # 4-byte Folded Spill
	sw	x22, 208(x2)                    # 4-byte Folded Spill
	sw	x23, 212(x2)                    # 4-byte Folded Spill
	lw	x16, 32(x15)
	xr.repeat	1, x5, x6
	sw	x16, 152(x2)                    # 4-byte Folded Spill
	sw	x17, 156(x2)                    # 4-byte Folded Spill
	sw	x18, 160(x2)                    # 4-byte Folded Spill
	sw	x19, 164(x2)                    # 4-byte Folded Spill
	sw	x20, 168(x2)                    # 4-byte Folded Spill
	sw	x21, 172(x2)                    # 4-byte Folded Spill
	sw	x22, 176(x2)                    # 4-byte Folded Spill
	sw	x23, 180(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x15)
	xr.repeat	1, x5, x6
	sw	x16, 120(x2)                    # 4-byte Folded Spill
	sw	x17, 124(x2)                    # 4-byte Folded Spill
	sw	x18, 128(x2)                    # 4-byte Folded Spill
	sw	x19, 132(x2)                    # 4-byte Folded Spill
	sw	x20, 136(x2)                    # 4-byte Folded Spill
	sw	x21, 140(x2)                    # 4-byte Folded Spill
	sw	x22, 144(x2)                    # 4-byte Folded Spill
	sw	x23, 148(x2)                    # 4-byte Folded Spill
	lw	x11, 104(x2)                    # 4-byte Folded Reload
	add	x10, x11, x10
	lui	x11, %hi(a2)
	addi	x11, x11, %lo(a2)
	add	x10, x11, x10
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	addi	x28, x28, 1
	sw	x28, 112(x2)                    # 4-byte Folded Spill
	lui	x6, %hi(w_s2a+256)
	addi	x6, x6, %lo(w_s2a+256)
	lw	x11, 84(x2)                     # 4-byte Folded Reload
	sw	x29, 108(x2)                    # 4-byte Folded Spill
	j	.LBB0_72
.LBB0_71:                               # %for.body21.i184.i
                                        #   in Loop: Header=BB0_72 Depth=3
	lw	x12, 792(x2)                    # 4-byte Folded Reload
	sw	x10, 0(x12)
	addi	x29, x12, 4
	lw	x11, 824(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 4
	addi	x6, x6, 576
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	beq	x29, x10, .LBB0_69
.LBB0_72:                               # %for.body21.i184.i
                                        #   Parent Loop BB0_68 Depth=1
                                        #     Parent Loop BB0_70 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	sw	x29, 792(x2)                    # 4-byte Folded Spill
	sw	x11, 824(x2)                    # 4-byte Folded Spill
	lw	x1, 0(x11)
	li	x5, 4
	li	x7, 7
	lw	x8, 32(x6)
	xr.repeat	1, x5, x7
	lw	x24, 0(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 288(x6)
	xr.repeat	1, x5, x7
	lw	x16, 216(x2)                    # 4-byte Folded Reload
	lw	x17, 220(x2)                    # 4-byte Folded Reload
	lw	x18, 224(x2)                    # 4-byte Folded Reload
	lw	x19, 228(x2)                    # 4-byte Folded Reload
	lw	x20, 232(x2)                    # 4-byte Folded Reload
	lw	x21, 236(x2)                    # 4-byte Folded Reload
	lw	x22, 240(x2)                    # 4-byte Folded Reload
	lw	x23, 244(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x8, x1
	xr.repeat	6, x0, x7
	lw	x16, 256(x6)
	xr.repeat	1, x5, x7
	sw	x16, 696(x2)                    # 4-byte Folded Spill
	sw	x17, 700(x2)                    # 4-byte Folded Spill
	sw	x18, 704(x2)                    # 4-byte Folded Spill
	sw	x19, 708(x2)                    # 4-byte Folded Spill
	sw	x20, 712(x2)                    # 4-byte Folded Spill
	sw	x21, 716(x2)                    # 4-byte Folded Spill
	sw	x22, 720(x2)                    # 4-byte Folded Spill
	sw	x23, 724(x2)                    # 4-byte Folded Spill
	lw	x16, 440(x2)                    # 4-byte Folded Reload
	lw	x17, 444(x2)                    # 4-byte Folded Reload
	lw	x18, 448(x2)                    # 4-byte Folded Reload
	lw	x19, 452(x2)                    # 4-byte Folded Reload
	lw	x20, 456(x2)                    # 4-byte Folded Reload
	lw	x21, 460(x2)                    # 4-byte Folded Reload
	lw	x22, 464(x2)                    # 4-byte Folded Reload
	lw	x23, 468(x2)                    # 4-byte Folded Reload
	lw	x8, 760(x2)                     # 4-byte Folded Reload
	lw	x9, 764(x2)                     # 4-byte Folded Reload
	lw	x10, 768(x2)                    # 4-byte Folded Reload
	lw	x11, 772(x2)                    # 4-byte Folded Reload
	lw	x12, 776(x2)                    # 4-byte Folded Reload
	lw	x13, 780(x2)                    # 4-byte Folded Reload
	lw	x14, 784(x2)                    # 4-byte Folded Reload
	lw	x15, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x8, x1
	xr.repeat	6, x0, x7
	lw	x16, 224(x6)
	xr.repeat	1, x5, x7
	sw	x16, 728(x2)                    # 4-byte Folded Spill
	sw	x17, 732(x2)                    # 4-byte Folded Spill
	sw	x18, 736(x2)                    # 4-byte Folded Spill
	sw	x19, 740(x2)                    # 4-byte Folded Spill
	sw	x20, 744(x2)                    # 4-byte Folded Spill
	sw	x21, 748(x2)                    # 4-byte Folded Spill
	sw	x22, 752(x2)                    # 4-byte Folded Spill
	sw	x23, 756(x2)                    # 4-byte Folded Spill
	lw	x16, 152(x2)                    # 4-byte Folded Reload
	lw	x17, 156(x2)                    # 4-byte Folded Reload
	lw	x18, 160(x2)                    # 4-byte Folded Reload
	lw	x19, 164(x2)                    # 4-byte Folded Reload
	lw	x20, 168(x2)                    # 4-byte Folded Reload
	lw	x21, 172(x2)                    # 4-byte Folded Reload
	lw	x22, 176(x2)                    # 4-byte Folded Reload
	lw	x23, 180(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x24, x1
	xr.repeat	6, x0, x7
	lw	x24, 192(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 120(x2)                    # 4-byte Folded Reload
	lw	x25, 124(x2)                    # 4-byte Folded Reload
	lw	x26, 128(x2)                    # 4-byte Folded Reload
	lw	x27, 132(x2)                    # 4-byte Folded Reload
	lw	x28, 136(x2)                    # 4-byte Folded Reload
	lw	x29, 140(x2)                    # 4-byte Folded Reload
	lw	x30, 144(x2)                    # 4-byte Folded Reload
	lw	x31, 148(x2)                    # 4-byte Folded Reload
	lw	x16, 696(x2)                    # 4-byte Folded Reload
	lw	x17, 700(x2)                    # 4-byte Folded Reload
	lw	x18, 704(x2)                    # 4-byte Folded Reload
	lw	x19, 708(x2)                    # 4-byte Folded Reload
	lw	x20, 712(x2)                    # 4-byte Folded Reload
	lw	x21, 716(x2)                    # 4-byte Folded Reload
	lw	x22, 720(x2)                    # 4-byte Folded Reload
	lw	x23, 724(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x8, 160(x6)
	xr.repeat	1, x5, x7
	lw	x24, 312(x2)                    # 4-byte Folded Reload
	lw	x25, 316(x2)                    # 4-byte Folded Reload
	lw	x26, 320(x2)                    # 4-byte Folded Reload
	lw	x27, 324(x2)                    # 4-byte Folded Reload
	lw	x28, 328(x2)                    # 4-byte Folded Reload
	lw	x29, 332(x2)                    # 4-byte Folded Reload
	lw	x30, 336(x2)                    # 4-byte Folded Reload
	lw	x31, 340(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, 128(x6)
	xr.repeat	1, x5, x7
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 280(x2)                    # 4-byte Folded Reload
	lw	x25, 284(x2)                    # 4-byte Folded Reload
	lw	x26, 288(x2)                    # 4-byte Folded Reload
	lw	x27, 292(x2)                    # 4-byte Folded Reload
	lw	x28, 296(x2)                    # 4-byte Folded Reload
	lw	x29, 300(x2)                    # 4-byte Folded Reload
	lw	x30, 304(x2)                    # 4-byte Folded Reload
	lw	x31, 308(x2)                    # 4-byte Folded Reload
	lw	x16, 760(x2)                    # 4-byte Folded Reload
	lw	x17, 764(x2)                    # 4-byte Folded Reload
	lw	x18, 768(x2)                    # 4-byte Folded Reload
	lw	x19, 772(x2)                    # 4-byte Folded Reload
	lw	x20, 776(x2)                    # 4-byte Folded Reload
	lw	x21, 780(x2)                    # 4-byte Folded Reload
	lw	x22, 784(x2)                    # 4-byte Folded Reload
	lw	x23, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, -160(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 376(x2)                    # 4-byte Folded Reload
	lw	x25, 380(x2)                    # 4-byte Folded Reload
	lw	x26, 384(x2)                    # 4-byte Folded Reload
	lw	x27, 388(x2)                    # 4-byte Folded Reload
	lw	x28, 392(x2)                    # 4-byte Folded Reload
	lw	x29, 396(x2)                    # 4-byte Folded Reload
	lw	x30, 400(x2)                    # 4-byte Folded Reload
	lw	x31, 404(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x8, -192(x6)
	xr.repeat	1, x5, x7
	lw	x24, 344(x2)                    # 4-byte Folded Reload
	lw	x25, 348(x2)                    # 4-byte Folded Reload
	lw	x26, 352(x2)                    # 4-byte Folded Reload
	lw	x27, 356(x2)                    # 4-byte Folded Reload
	lw	x28, 360(x2)                    # 4-byte Folded Reload
	lw	x29, 364(x2)                    # 4-byte Folded Reload
	lw	x30, 368(x2)                    # 4-byte Folded Reload
	lw	x31, 372(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, -96(x6)
	xr.repeat	1, x5, x7
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 600(x2)                    # 4-byte Folded Reload
	lw	x25, 604(x2)                    # 4-byte Folded Reload
	lw	x26, 608(x2)                    # 4-byte Folded Reload
	lw	x27, 612(x2)                    # 4-byte Folded Reload
	lw	x28, 616(x2)                    # 4-byte Folded Reload
	lw	x29, 620(x2)                    # 4-byte Folded Reload
	lw	x30, 624(x2)                    # 4-byte Folded Reload
	lw	x31, 628(x2)                    # 4-byte Folded Reload
	lw	x16, 760(x2)                    # 4-byte Folded Reload
	lw	x17, 764(x2)                    # 4-byte Folded Reload
	lw	x18, 768(x2)                    # 4-byte Folded Reload
	lw	x19, 772(x2)                    # 4-byte Folded Reload
	lw	x20, 776(x2)                    # 4-byte Folded Reload
	lw	x21, 780(x2)                    # 4-byte Folded Reload
	lw	x22, 784(x2)                    # 4-byte Folded Reload
	lw	x23, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, -128(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 568(x2)                    # 4-byte Folded Reload
	lw	x25, 572(x2)                    # 4-byte Folded Reload
	lw	x26, 576(x2)                    # 4-byte Folded Reload
	lw	x27, 580(x2)                    # 4-byte Folded Reload
	lw	x28, 584(x2)                    # 4-byte Folded Reload
	lw	x29, 588(x2)                    # 4-byte Folded Reload
	lw	x30, 592(x2)                    # 4-byte Folded Reload
	lw	x31, 596(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x8, -32(x6)
	xr.repeat	1, x5, x7
	lw	x24, 664(x2)                    # 4-byte Folded Reload
	lw	x25, 668(x2)                    # 4-byte Folded Reload
	lw	x26, 672(x2)                    # 4-byte Folded Reload
	lw	x27, 676(x2)                    # 4-byte Folded Reload
	lw	x28, 680(x2)                    # 4-byte Folded Reload
	lw	x29, 684(x2)                    # 4-byte Folded Reload
	lw	x30, 688(x2)                    # 4-byte Folded Reload
	lw	x31, 692(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, -64(x6)
	xr.repeat	1, x5, x7
	sw	x24, 728(x2)                    # 4-byte Folded Spill
	sw	x25, 732(x2)                    # 4-byte Folded Spill
	sw	x26, 736(x2)                    # 4-byte Folded Spill
	sw	x27, 740(x2)                    # 4-byte Folded Spill
	sw	x28, 744(x2)                    # 4-byte Folded Spill
	sw	x29, 748(x2)                    # 4-byte Folded Spill
	sw	x30, 752(x2)                    # 4-byte Folded Spill
	sw	x31, 756(x2)                    # 4-byte Folded Spill
	lw	x24, 632(x2)                    # 4-byte Folded Reload
	lw	x25, 636(x2)                    # 4-byte Folded Reload
	lw	x26, 640(x2)                    # 4-byte Folded Reload
	lw	x27, 644(x2)                    # 4-byte Folded Reload
	lw	x28, 648(x2)                    # 4-byte Folded Reload
	lw	x29, 652(x2)                    # 4-byte Folded Reload
	lw	x30, 656(x2)                    # 4-byte Folded Reload
	lw	x31, 660(x2)                    # 4-byte Folded Reload
	lw	x16, 760(x2)                    # 4-byte Folded Reload
	lw	x17, 764(x2)                    # 4-byte Folded Reload
	lw	x18, 768(x2)                    # 4-byte Folded Reload
	lw	x19, 772(x2)                    # 4-byte Folded Reload
	lw	x20, 776(x2)                    # 4-byte Folded Reload
	lw	x21, 780(x2)                    # 4-byte Folded Reload
	lw	x22, 784(x2)                    # 4-byte Folded Reload
	lw	x23, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, 64(x6)
	xr.repeat	1, x5, x7
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x24, 184(x2)                    # 4-byte Folded Reload
	lw	x25, 188(x2)                    # 4-byte Folded Reload
	lw	x26, 192(x2)                    # 4-byte Folded Reload
	lw	x27, 196(x2)                    # 4-byte Folded Reload
	lw	x28, 200(x2)                    # 4-byte Folded Reload
	lw	x29, 204(x2)                    # 4-byte Folded Reload
	lw	x30, 208(x2)                    # 4-byte Folded Reload
	lw	x31, 212(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x24, 96(x6)
	xr.repeat	1, x5, x7
	lw	x8, 408(x2)                     # 4-byte Folded Reload
	lw	x9, 412(x2)                     # 4-byte Folded Reload
	lw	x10, 416(x2)                    # 4-byte Folded Reload
	lw	x11, 420(x2)                    # 4-byte Folded Reload
	lw	x12, 424(x2)                    # 4-byte Folded Reload
	lw	x13, 428(x2)                    # 4-byte Folded Reload
	lw	x14, 432(x2)                    # 4-byte Folded Reload
	lw	x15, 436(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x8, x16, x1
	xr.repeat	6, x0, x7
	lw	x8, -224(x6)
	xr.repeat	1, x5, x7
	lw	x16, -256(x6)
	xr.repeat	1, x5, x7
	sw	x16, 728(x2)                    # 4-byte Folded Spill
	sw	x17, 732(x2)                    # 4-byte Folded Spill
	sw	x18, 736(x2)                    # 4-byte Folded Spill
	sw	x19, 740(x2)                    # 4-byte Folded Spill
	sw	x20, 744(x2)                    # 4-byte Folded Spill
	sw	x21, 748(x2)                    # 4-byte Folded Spill
	sw	x22, 752(x2)                    # 4-byte Folded Spill
	sw	x23, 756(x2)                    # 4-byte Folded Spill
	lw	x16, 248(x2)                    # 4-byte Folded Reload
	lw	x17, 252(x2)                    # 4-byte Folded Reload
	lw	x18, 256(x2)                    # 4-byte Folded Reload
	lw	x19, 260(x2)                    # 4-byte Folded Reload
	lw	x20, 264(x2)                    # 4-byte Folded Reload
	lw	x21, 268(x2)                    # 4-byte Folded Reload
	lw	x22, 272(x2)                    # 4-byte Folded Reload
	lw	x23, 276(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x16, x24, x1
	xr.repeat	6, x0, x7
	lw	x24, 472(x2)                    # 4-byte Folded Reload
	lw	x25, 476(x2)                    # 4-byte Folded Reload
	lw	x26, 480(x2)                    # 4-byte Folded Reload
	lw	x27, 484(x2)                    # 4-byte Folded Reload
	lw	x28, 488(x2)                    # 4-byte Folded Reload
	lw	x29, 492(x2)                    # 4-byte Folded Reload
	lw	x30, 496(x2)                    # 4-byte Folded Reload
	lw	x31, 500(x2)                    # 4-byte Folded Reload
	lw	x16, 760(x2)                    # 4-byte Folded Reload
	lw	x17, 764(x2)                    # 4-byte Folded Reload
	lw	x18, 768(x2)                    # 4-byte Folded Reload
	lw	x19, 772(x2)                    # 4-byte Folded Reload
	lw	x20, 776(x2)                    # 4-byte Folded Reload
	lw	x21, 780(x2)                    # 4-byte Folded Reload
	lw	x22, 784(x2)                    # 4-byte Folded Reload
	lw	x23, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	lw	x24, 536(x2)                    # 4-byte Folded Reload
	lw	x25, 540(x2)                    # 4-byte Folded Reload
	lw	x26, 544(x2)                    # 4-byte Folded Reload
	lw	x27, 548(x2)                    # 4-byte Folded Reload
	lw	x28, 552(x2)                    # 4-byte Folded Reload
	lw	x29, 556(x2)                    # 4-byte Folded Reload
	lw	x30, 560(x2)                    # 4-byte Folded Reload
	lw	x31, 564(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x8, x1
	xr.repeat	6, x0, x7
	lw	x24, 504(x2)                    # 4-byte Folded Reload
	lw	x25, 508(x2)                    # 4-byte Folded Reload
	lw	x26, 512(x2)                    # 4-byte Folded Reload
	lw	x27, 516(x2)                    # 4-byte Folded Reload
	lw	x28, 520(x2)                    # 4-byte Folded Reload
	lw	x29, 524(x2)                    # 4-byte Folded Reload
	lw	x30, 528(x2)                    # 4-byte Folded Reload
	lw	x31, 532(x2)                    # 4-byte Folded Reload
	lw	x16, 728(x2)                    # 4-byte Folded Reload
	lw	x17, 732(x2)                    # 4-byte Folded Reload
	lw	x18, 736(x2)                    # 4-byte Folded Reload
	lw	x19, 740(x2)                    # 4-byte Folded Reload
	lw	x20, 744(x2)                    # 4-byte Folded Reload
	lw	x21, 748(x2)                    # 4-byte Folded Reload
	lw	x22, 752(x2)                    # 4-byte Folded Reload
	lw	x23, 756(x2)                    # 4-byte Folded Reload
	xr.mac	x1, x24, x16, x1
	xr.repeat	6, x0, x7
	srai	x10, x1, 4
	sgtz	x11, x10
	neg	x11, x11
	and	x10, x11, x10
	li	x11, 127
	blt	x10, x11, .LBB0_71
# %bb.73:                               # %for.body21.i184.i
                                        #   in Loop: Header=BB0_72 Depth=3
	li	x10, 127
	j	.LBB0_71
.LBB0_74:                               # %for.cond3.preheader.i229.i.preheader
	li	x14, 0
	lui	x13, %hi(p2)
	addi	x13, x13, %lo(p2)
	lui	x12, %hi(.L_MergedGlobals)
	addi	x12, x12, %lo(.L_MergedGlobals)
	addi	x12, x12, 528
	sw	x12, 568(x2)                    # 4-byte Folded Spill
	addi	x12, x13, 2047
	addi	x6, x12, 385
	li	x5, 7
	j	.LBB0_76
.LBB0_75:                               # %for.cond.cleanup5.i286.i
                                        #   in Loop: Header=BB0_76 Depth=1
	lw	x12, 504(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 2047
	addi	x6, x12, 257
	lw	x14, 536(x2)                    # 4-byte Folded Reload
	li	x10, 16
	beq	x14, x10, .LBB0_84
.LBB0_76:                               # %for.cond3.preheader.i229.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_78 Depth 2
                                        #       Child Loop BB0_80 Depth 3
	li	x11, 0
	mv	x12, x14
	lw	x14, 56(x2)                     # 4-byte Folded Reload
	mul	x13, x12, x14
	lw	x16, 80(x2)                     # 4-byte Folded Reload
	mul	x10, x12, x16
	addi	x12, x12, 1
	sw	x12, 536(x2)                    # 4-byte Folded Spill
	add	x13, x14, x13
	addi	x12, x13, 256
	sw	x12, 632(x2)                    # 4-byte Folded Spill
	lui	x12, %hi(y1)
	addi	x12, x12, %lo(y1)
	add	x10, x12, x10
	sw	x10, 600(x2)                    # 4-byte Folded Spill
	sw	x6, 504(x2)                     # 4-byte Folded Spill
	j	.LBB0_78
.LBB0_77:                               # %for.cond3.loopexit.i284.i
                                        #   in Loop: Header=BB0_78 Depth=2
	lw	x6, 664(x2)                     # 4-byte Folded Reload
	addi	x6, x6, 128
	li	x10, 16
	lw	x11, 696(x2)                    # 4-byte Folded Reload
	beq	x11, x10, .LBB0_75
.LBB0_78:                               # %for.body6.i235.i
                                        #   Parent Loop BB0_76 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_80 Depth 3
	slli	x13, x11, 7
	lw	x14, 600(x2)                    # 4-byte Folded Reload
	add	x14, x14, x13
	addi	x14, x14, 2047
	addi	x7, x14, 193
	li	x10, 4
	li	x12, 7
	lw	x24, 193(x14)
	xr.repeat	1, x10, x12
	sw	x24, 792(x2)                    # 4-byte Folded Spill
	sw	x25, 796(x2)                    # 4-byte Folded Spill
	sw	x26, 800(x2)                    # 4-byte Folded Spill
	sw	x27, 804(x2)                    # 4-byte Folded Spill
	sw	x28, 808(x2)                    # 4-byte Folded Spill
	sw	x29, 812(x2)                    # 4-byte Folded Spill
	sw	x30, 816(x2)                    # 4-byte Folded Spill
	sw	x31, 820(x2)                    # 4-byte Folded Spill
	lw	x24, 32(x7)
	xr.repeat	1, x10, x12
	sw	x24, 760(x2)                    # 4-byte Folded Spill
	sw	x25, 764(x2)                    # 4-byte Folded Spill
	sw	x26, 768(x2)                    # 4-byte Folded Spill
	sw	x27, 772(x2)                    # 4-byte Folded Spill
	sw	x28, 776(x2)                    # 4-byte Folded Spill
	sw	x29, 780(x2)                    # 4-byte Folded Spill
	sw	x30, 784(x2)                    # 4-byte Folded Spill
	sw	x31, 788(x2)                    # 4-byte Folded Spill
	lw	x10, 632(x2)                    # 4-byte Folded Reload
	add	x13, x10, x13
	lui	x1, %hi(p2)
	addi	x1, x1, %lo(p2)
	add	x13, x1, x13
	sw	x13, 728(x2)                    # 4-byte Folded Spill
	addi	x11, x11, 1
	sw	x11, 696(x2)                    # 4-byte Folded Spill
	lw	x1, 568(x2)                     # 4-byte Folded Reload
	lui	x14, %hi(w_s2p)
	addi	x14, x14, %lo(w_s2p)
	sw	x6, 664(x2)                     # 4-byte Folded Spill
	j	.LBB0_80
.LBB0_79:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_80 Depth=3
	sw	x8, 0(x6)
	addi	x6, x6, 4
	lw	x14, 824(x2)                    # 4-byte Folded Reload
	addi	x14, x14, 64
	addi	x1, x1, 4
	lw	x10, 728(x2)                    # 4-byte Folded Reload
	beq	x6, x10, .LBB0_77
.LBB0_80:                               # %for.body21.i244.i
                                        #   Parent Loop BB0_76 Depth=1
                                        #     Parent Loop BB0_78 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x7, 0(x1)
	li	x10, 4
	lw	x24, 32(x14)
	xr.repeat	1, x10, x5
	sw	x14, 824(x2)                    # 4-byte Folded Spill
	lw	x16, 0(x14)
	xr.repeat	1, x10, x5
	lw	x8, 760(x2)                     # 4-byte Folded Reload
	lw	x9, 764(x2)                     # 4-byte Folded Reload
	lw	x10, 768(x2)                    # 4-byte Folded Reload
	lw	x11, 772(x2)                    # 4-byte Folded Reload
	lw	x12, 776(x2)                    # 4-byte Folded Reload
	lw	x13, 780(x2)                    # 4-byte Folded Reload
	lw	x14, 784(x2)                    # 4-byte Folded Reload
	lw	x15, 788(x2)                    # 4-byte Folded Reload
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x5
	lw	x24, 792(x2)                    # 4-byte Folded Reload
	lw	x25, 796(x2)                    # 4-byte Folded Reload
	lw	x26, 800(x2)                    # 4-byte Folded Reload
	lw	x27, 804(x2)                    # 4-byte Folded Reload
	lw	x28, 808(x2)                    # 4-byte Folded Reload
	lw	x29, 812(x2)                    # 4-byte Folded Reload
	lw	x30, 816(x2)                    # 4-byte Folded Reload
	lw	x31, 820(x2)                    # 4-byte Folded Reload
	xr.mac	x7, x16, x24, x7
	xr.repeat	6, x0, x5
	srai	x8, x7, 3
	li	x16, -128
	blt	x16, x8, .LBB0_82
# %bb.81:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_80 Depth=3
	li	x8, -128
.LBB0_82:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_80 Depth=3
	li	x16, 127
	blt	x8, x16, .LBB0_79
# %bb.83:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_80 Depth=3
	li	x8, 127
	j	.LBB0_79
.LBB0_84:                               # %for.cond3.preheader.i289.i.preheader
	li	x14, 0
	li	x15, 9
	lui	x10, 1
	li	x11, 19
	lui	x30, %hi(a2)
	addi	x30, x30, %lo(a2)
	addi	x16, x30, 128
	addi	x17, x30, 256
	lw	x12, 68(x2)                     # 4-byte Folded Reload
	addi	x5, x12, 257
	addi	x6, x12, 385
	addi	x7, x12, 513
	li	x21, 7
	li	x20, 4
	slli	x12, x15, 9
	addi	x10, x10, 640
	slli	x11, x11, 8
	add	x15, x30, x12
	add	x28, x30, x10
	add	x29, x30, x11
	j	.LBB0_86
.LBB0_85:                               # %for.cond.cleanup5.i350.i
                                        #   in Loop: Header=BB0_86 Depth=1
	li	x10, 9
	slli	x10, x10, 8
	lw	x30, 16(x2)                     # 4-byte Folded Reload
	add	x30, x30, x10
	lw	x16, 48(x2)                     # 4-byte Folded Reload
	add	x16, x16, x10
	lw	x17, 44(x2)                     # 4-byte Folded Reload
	add	x17, x17, x10
	lw	x5, 40(x2)                      # 4-byte Folded Reload
	add	x5, x5, x10
	lw	x6, 36(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x7, 32(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x15, 28(x2)                     # 4-byte Folded Reload
	add	x15, x15, x10
	lw	x28, 24(x2)                     # 4-byte Folded Reload
	add	x28, x28, x10
	lw	x29, 20(x2)                     # 4-byte Folded Reload
	add	x29, x29, x10
	lw	x14, 60(x2)                     # 4-byte Folded Reload
	li	x10, 16
	beq	x14, x10, .LBB0_110
.LBB0_86:                               # %for.cond3.preheader.i289.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_88 Depth 2
                                        #       Child Loop BB0_90 Depth 3
                                        #         Child Loop BB0_91 Depth 4
                                        #         Child Loop BB0_93 Depth 4
                                        #         Child Loop BB0_95 Depth 4
                                        #         Child Loop BB0_97 Depth 4
                                        #         Child Loop BB0_99 Depth 4
                                        #         Child Loop BB0_101 Depth 4
                                        #         Child Loop BB0_103 Depth 4
                                        #         Child Loop BB0_105 Depth 4
                                        #         Child Loop BB0_107 Depth 4
	li	x31, 0
	lw	x12, 56(x2)                     # 4-byte Folded Reload
	mul	x10, x14, x12
	addi	x14, x14, 1
	addi	x8, x10, 384
	addi	x9, x10, 256
	addi	x18, x10, 128
	slli	x10, x14, 1
	sw	x14, 60(x2)                     # 4-byte Folded Spill
	slli	x11, x14, 4
	lw	x13, 52(x2)                     # 4-byte Folded Reload
	add	x14, x8, x13
	sw	x14, 88(x2)                     # 4-byte Folded Spill
	add	x14, x9, x13
	sw	x14, 84(x2)                     # 4-byte Folded Spill
	add	x13, x18, x13
	sw	x13, 80(x2)                     # 4-byte Folded Spill
	sw	x8, 100(x2)                     # 4-byte Folded Spill
	add	x8, x8, x12
	sw	x8, 76(x2)                      # 4-byte Folded Spill
	sw	x9, 96(x2)                      # 4-byte Folded Spill
	add	x9, x9, x12
	sw	x9, 72(x2)                      # 4-byte Folded Spill
	sw	x18, 92(x2)                     # 4-byte Folded Spill
	add	x12, x18, x12
	sw	x12, 68(x2)                     # 4-byte Folded Spill
	add	x10, x11, x10
	sw	x10, 64(x2)                     # 4-byte Folded Spill
	sw	x29, 20(x2)                     # 4-byte Folded Spill
	sw	x29, 472(x2)                    # 4-byte Folded Spill
	sw	x28, 24(x2)                     # 4-byte Folded Spill
	sw	x28, 440(x2)                    # 4-byte Folded Spill
	sw	x15, 28(x2)                     # 4-byte Folded Spill
	sw	x15, 408(x2)                    # 4-byte Folded Spill
	sw	x7, 32(x2)                      # 4-byte Folded Spill
	sw	x7, 376(x2)                     # 4-byte Folded Spill
	sw	x6, 36(x2)                      # 4-byte Folded Spill
	sw	x6, 344(x2)                     # 4-byte Folded Spill
	sw	x5, 40(x2)                      # 4-byte Folded Spill
	sw	x5, 312(x2)                     # 4-byte Folded Spill
	sw	x17, 44(x2)                     # 4-byte Folded Spill
	sw	x17, 280(x2)                    # 4-byte Folded Spill
	sw	x16, 48(x2)                     # 4-byte Folded Spill
	sw	x16, 248(x2)                    # 4-byte Folded Spill
	sw	x30, 16(x2)                     # 4-byte Folded Spill
	sw	x30, 216(x2)                    # 4-byte Folded Spill
	j	.LBB0_88
.LBB0_87:                               # %for.cond3.loopexit.i348.i
                                        #   in Loop: Header=BB0_88 Depth=2
	lw	x10, 216(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 216(x2)                    # 4-byte Folded Spill
	lw	x10, 248(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 248(x2)                    # 4-byte Folded Spill
	lw	x10, 280(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 280(x2)                    # 4-byte Folded Spill
	lw	x10, 312(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 312(x2)                    # 4-byte Folded Spill
	lw	x10, 344(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 344(x2)                    # 4-byte Folded Spill
	lw	x10, 376(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 376(x2)                    # 4-byte Folded Spill
	lw	x10, 408(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 408(x2)                    # 4-byte Folded Spill
	lw	x10, 440(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 440(x2)                    # 4-byte Folded Spill
	lw	x10, 472(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 472(x2)                    # 4-byte Folded Spill
	li	x10, 16
	lw	x31, 104(x2)                    # 4-byte Folded Reload
	beq	x31, x10, .LBB0_85
.LBB0_88:                               # %for.body6.i297.i
                                        #   Parent Loop BB0_86 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_90 Depth 3
                                        #         Child Loop BB0_91 Depth 4
                                        #         Child Loop BB0_93 Depth 4
                                        #         Child Loop BB0_95 Depth 4
                                        #         Child Loop BB0_97 Depth 4
                                        #         Child Loop BB0_99 Depth 4
                                        #         Child Loop BB0_101 Depth 4
                                        #         Child Loop BB0_103 Depth 4
                                        #         Child Loop BB0_105 Depth 4
                                        #         Child Loop BB0_107 Depth 4
	li	x11, 0
	slli	x10, x31, 7
	addi	x31, x31, 1
	lui	x17, %hi(w_s2b)
	addi	x17, x17, %lo(w_s2b)
	addi	x12, x17, 128
	sw	x12, 824(x2)                    # 4-byte Folded Spill
	addi	x12, x17, 256
	sw	x12, 792(x2)                    # 4-byte Folded Spill
	addi	x12, x17, 384
	sw	x12, 760(x2)                    # 4-byte Folded Spill
	addi	x12, x17, 512
	sw	x12, 728(x2)                    # 4-byte Folded Spill
	addi	x12, x17, 640
	sw	x12, 696(x2)                    # 4-byte Folded Spill
	addi	x12, x17, 768
	sw	x12, 664(x2)                    # 4-byte Folded Spill
	addi	x12, x17, 896
	sw	x12, 632(x2)                    # 4-byte Folded Spill
	lw	x13, 88(x2)                     # 4-byte Folded Reload
	add	x13, x13, x10
	lw	x25, 84(x2)                     # 4-byte Folded Reload
	add	x25, x25, x10
	lw	x26, 80(x2)                     # 4-byte Folded Reload
	add	x26, x26, x10
	lw	x14, 76(x2)                     # 4-byte Folded Reload
	add	x14, x14, x10
	lw	x6, 72(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x30, 68(x2)                     # 4-byte Folded Reload
	add	x30, x30, x10
	lw	x24, 100(x2)                    # 4-byte Folded Reload
	add	x24, x24, x10
	lw	x8, 96(x2)                      # 4-byte Folded Reload
	add	x8, x8, x10
	lw	x18, 92(x2)                     # 4-byte Folded Reload
	add	x18, x18, x10
	sw	x31, 104(x2)                    # 4-byte Folded Spill
	lw	x7, 64(x2)                      # 4-byte Folded Reload
	add	x7, x31, x7
	lui	x10, %hi(a2)
	addi	x10, x10, %lo(a2)
	add	x5, x10, x13
	add	x19, x10, x25
	add	x26, x10, x26
	sw	x26, 184(x2)                    # 4-byte Folded Spill
	add	x14, x10, x14
	sw	x14, 152(x2)                    # 4-byte Folded Spill
	add	x6, x10, x6
	sw	x6, 120(x2)                     # 4-byte Folded Spill
	add	x1, x10, x30
	add	x6, x10, x24
	add	x16, x10, x8
	add	x18, x10, x18
	slli	x7, x7, 7
	lui	x10, %hi(y2)
	addi	x10, x10, %lo(y2)
	add	x10, x10, x7
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	lui	x10, %hi(p2)
	addi	x10, x10, %lo(p2)
	add	x10, x10, x7
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	addi	x23, x17, 1024
	sw	x5, 116(x2)                     # 4-byte Folded Spill
	j	.LBB0_90
.LBB0_89:                               # %for.cond.cleanup42.i334.2.i.2
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x10, 112(x2)                    # 4-byte Folded Reload
	add	x10, x10, x12
	lw	x11, 600(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1
	lw	x17, 536(x2)                    # 4-byte Folded Reload
	addi	x17, x17, 1152
	lw	x12, 824(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1152
	sw	x12, 824(x2)                    # 4-byte Folded Spill
	lw	x12, 792(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1152
	sw	x12, 792(x2)                    # 4-byte Folded Spill
	lw	x12, 760(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1152
	sw	x12, 760(x2)                    # 4-byte Folded Spill
	lw	x12, 728(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1152
	sw	x12, 728(x2)                    # 4-byte Folded Spill
	lw	x12, 696(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1152
	sw	x12, 696(x2)                    # 4-byte Folded Spill
	lw	x12, 664(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1152
	sw	x12, 664(x2)                    # 4-byte Folded Spill
	lw	x12, 632(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1152
	sw	x12, 632(x2)                    # 4-byte Folded Spill
	sw	x7, 0(x10)
	addi	x23, x23, 1152
	li	x10, 32
	beq	x11, x10, .LBB0_87
.LBB0_90:                               # %for.body21.i306.i
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_91 Depth 4
                                        #         Child Loop BB0_93 Depth 4
                                        #         Child Loop BB0_95 Depth 4
                                        #         Child Loop BB0_97 Depth 4
                                        #         Child Loop BB0_99 Depth 4
                                        #         Child Loop BB0_101 Depth 4
                                        #         Child Loop BB0_103 Depth 4
                                        #         Child Loop BB0_105 Depth 4
                                        #         Child Loop BB0_107 Depth 4
	sw	x23, 568(x2)                    # 4-byte Folded Spill
	sw	x11, 600(x2)                    # 4-byte Folded Spill
	slli	x11, x11, 2
	lui	x7, %hi(.L_MergedGlobals)
	addi	x7, x7, %lo(.L_MergedGlobals)
	sw	x11, 504(x2)                    # 4-byte Folded Spill
	add	x7, x7, x11
	lw	x7, 400(x7)
	sw	x17, 536(x2)                    # 4-byte Folded Spill
	lw	x22, 216(x2)                    # 4-byte Folded Reload
.LBB0_91:                               # %vector.body83
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x18, .LBB0_91
# %bb.92:                               # %for.cond.cleanup42.i334.i
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x17, 824(x2)                    # 4-byte Folded Reload
	lw	x22, 248(x2)                    # 4-byte Folded Reload
	lw	x23, 152(x2)                    # 4-byte Folded Reload
.LBB0_93:                               # %vector.body75
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x16, .LBB0_93
# %bb.94:                               # %for.cond.cleanup42.i334.1.i
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x17, 792(x2)                    # 4-byte Folded Reload
	lw	x22, 280(x2)                    # 4-byte Folded Reload
.LBB0_95:                               # %vector.body67
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x6, .LBB0_95
# %bb.96:                               # %for.cond.cleanup42.i334.2.i
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x17, 760(x2)                    # 4-byte Folded Reload
	lw	x22, 312(x2)                    # 4-byte Folded Reload
.LBB0_97:                               # %vector.body59
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x1, .LBB0_97
# %bb.98:                               # %for.cond.cleanup42.i334.i.1
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x17, 728(x2)                    # 4-byte Folded Reload
	lw	x22, 344(x2)                    # 4-byte Folded Reload
	lw	x5, 120(x2)                     # 4-byte Folded Reload
.LBB0_99:                               # %vector.body51
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x5, .LBB0_99
# %bb.100:                              # %for.cond.cleanup42.i334.1.i.1
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x17, 696(x2)                    # 4-byte Folded Reload
	lw	x22, 376(x2)                    # 4-byte Folded Reload
.LBB0_101:                              # %vector.body43
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x23, .LBB0_101
# %bb.102:                              # %for.cond.cleanup42.i334.2.i.1
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x17, 664(x2)                    # 4-byte Folded Reload
	lw	x22, 408(x2)                    # 4-byte Folded Reload
	lw	x23, 184(x2)                    # 4-byte Folded Reload
	lw	x5, 116(x2)                     # 4-byte Folded Reload
.LBB0_103:                              # %vector.body35
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x23, .LBB0_103
# %bb.104:                              # %for.cond.cleanup42.i334.i.2
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x17, 632(x2)                    # 4-byte Folded Reload
	lw	x22, 440(x2)                    # 4-byte Folded Reload
.LBB0_105:                              # %vector.body27
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x19, .LBB0_105
# %bb.106:                              # %for.cond.cleanup42.i334.1.i.2
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x23, 568(x2)                    # 4-byte Folded Reload
	mv	x17, x23
	lw	x22, 472(x2)                    # 4-byte Folded Reload
.LBB0_107:                              # %vector.body
                                        #   Parent Loop BB0_86 Depth=1
                                        #     Parent Loop BB0_88 Depth=2
                                        #       Parent Loop BB0_90 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x17)
	xr.repeat	1, x20, x21
	lw	x24, 0(x22)
	xr.repeat	1, x20, x21
	addi	x22, x22, 32
	xr.mac	x7, x24, x8, x7
	xr.repeat	6, x0, x21
	addi	x17, x17, 32
	bne	x22, x5, .LBB0_107
# %bb.108:                              # %for.cond.cleanup42.i334.2.i.2
                                        #   in Loop: Header=BB0_90 Depth=3
	lw	x10, 108(x2)                    # 4-byte Folded Reload
	lw	x12, 504(x2)                    # 4-byte Folded Reload
	add	x10, x10, x12
	lw	x10, 0(x10)
	srai	x11, x7, 4
	add	x10, x10, x11
	sgtz	x11, x10
	neg	x11, x11
	and	x7, x11, x10
	li	x10, 127
	blt	x7, x10, .LBB0_89
# %bb.109:                              # %for.cond.cleanup42.i334.2.i.2
                                        #   in Loop: Header=BB0_90 Depth=3
	li	x7, 127
	j	.LBB0_89
.LBB0_110:                              # %conv.exit352.i
	li	x17, 0
	#APP
	#NO_APP
	lui	x10, 65555
	li	x11, 3
	li	x12, 9
	lui	x13, 1
	li	x14, 19
	lui	x16, %hi(y2)
	addi	x16, x16, %lo(y2)
	addi	x5, x16, 128
	addi	x6, x16, 256
	addi	x15, x16, 2047
	sw	x11, 0(x10)
	slli	x12, x12, 9
	addi	x10, x13, 640
	slli	x14, x14, 8
	addi	x13, x15, 257
	addi	x7, x15, 385
	addi	x28, x15, 513
	sw	x12, 16(x2)                     # 4-byte Folded Spill
	add	x30, x16, x12
	add	x8, x16, x10
	add	x14, x16, x14
	#APP
	#NO_APP
	li	x31, 7
	li	x29, 4
	lui	x15, %hi(.L_MergedGlobals)
	addi	x15, x15, %lo(.L_MergedGlobals)
	j	.LBB0_112
.LBB0_111:                              # %for.cond.cleanup5.i412.i
                                        #   in Loop: Header=BB0_112 Depth=1
	lw	x10, 16(x2)                     # 4-byte Folded Reload
	lw	x16, 20(x2)                     # 4-byte Folded Reload
	add	x16, x16, x10
	lw	x5, 60(x2)                      # 4-byte Folded Reload
	add	x5, x5, x10
	lw	x6, 48(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x13, 44(x2)                     # 4-byte Folded Reload
	add	x13, x13, x10
	lw	x7, 40(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x28, 36(x2)                     # 4-byte Folded Reload
	add	x28, x28, x10
	lw	x30, 32(x2)                     # 4-byte Folded Reload
	add	x30, x30, x10
	lw	x8, 28(x2)                      # 4-byte Folded Reload
	add	x8, x8, x10
	lw	x14, 24(x2)                     # 4-byte Folded Reload
	add	x14, x14, x10
	lw	x17, 64(x2)                     # 4-byte Folded Reload
	li	x10, 8
	beq	x17, x10, .LBB0_136
.LBB0_112:                              # %for.cond3.preheader.i353.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_114 Depth 2
                                        #       Child Loop BB0_116 Depth 3
                                        #         Child Loop BB0_117 Depth 4
                                        #         Child Loop BB0_119 Depth 4
                                        #         Child Loop BB0_121 Depth 4
                                        #         Child Loop BB0_123 Depth 4
                                        #         Child Loop BB0_125 Depth 4
                                        #         Child Loop BB0_127 Depth 4
                                        #         Child Loop BB0_129 Depth 4
                                        #         Child Loop BB0_131 Depth 4
                                        #         Child Loop BB0_133 Depth 4
	li	x9, 0
	lw	x12, 52(x2)                     # 4-byte Folded Reload
	mul	x10, x17, x12
	addi	x17, x17, 1
	addi	x18, x10, 384
	addi	x19, x10, 256
	addi	x20, x10, 128
	slli	x10, x17, 1
	sw	x17, 64(x2)                     # 4-byte Folded Spill
	slli	x11, x17, 3
	add	x17, x18, x12
	sw	x17, 92(x2)                     # 4-byte Folded Spill
	add	x17, x19, x12
	sw	x17, 88(x2)                     # 4-byte Folded Spill
	add	x12, x20, x12
	sw	x12, 84(x2)                     # 4-byte Folded Spill
	lw	x12, 56(x2)                     # 4-byte Folded Reload
	sw	x18, 104(x2)                    # 4-byte Folded Spill
	add	x18, x18, x12
	sw	x18, 80(x2)                     # 4-byte Folded Spill
	sw	x19, 100(x2)                    # 4-byte Folded Spill
	add	x19, x19, x12
	sw	x19, 76(x2)                     # 4-byte Folded Spill
	sw	x20, 96(x2)                     # 4-byte Folded Spill
	add	x12, x20, x12
	sw	x12, 72(x2)                     # 4-byte Folded Spill
	add	x10, x11, x10
	sw	x10, 68(x2)                     # 4-byte Folded Spill
	sw	x14, 24(x2)                     # 4-byte Folded Spill
	sw	x14, 472(x2)                    # 4-byte Folded Spill
	sw	x8, 28(x2)                      # 4-byte Folded Spill
	sw	x8, 440(x2)                     # 4-byte Folded Spill
	sw	x30, 32(x2)                     # 4-byte Folded Spill
	sw	x30, 408(x2)                    # 4-byte Folded Spill
	sw	x28, 36(x2)                     # 4-byte Folded Spill
	sw	x28, 376(x2)                    # 4-byte Folded Spill
	sw	x7, 40(x2)                      # 4-byte Folded Spill
	sw	x7, 344(x2)                     # 4-byte Folded Spill
	sw	x13, 44(x2)                     # 4-byte Folded Spill
	sw	x13, 312(x2)                    # 4-byte Folded Spill
	sw	x6, 48(x2)                      # 4-byte Folded Spill
	sw	x6, 280(x2)                     # 4-byte Folded Spill
	sw	x5, 60(x2)                      # 4-byte Folded Spill
	sw	x5, 248(x2)                     # 4-byte Folded Spill
	sw	x16, 20(x2)                     # 4-byte Folded Spill
	sw	x16, 216(x2)                    # 4-byte Folded Spill
	j	.LBB0_114
.LBB0_113:                              # %for.cond3.loopexit.i410.i
                                        #   in Loop: Header=BB0_114 Depth=2
	lw	x10, 216(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 216(x2)                    # 4-byte Folded Spill
	lw	x10, 248(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 248(x2)                    # 4-byte Folded Spill
	lw	x10, 280(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 280(x2)                    # 4-byte Folded Spill
	lw	x10, 312(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 312(x2)                    # 4-byte Folded Spill
	lw	x10, 344(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 344(x2)                    # 4-byte Folded Spill
	lw	x10, 376(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 376(x2)                    # 4-byte Folded Spill
	lw	x10, 408(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 408(x2)                    # 4-byte Folded Spill
	lw	x10, 440(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 440(x2)                    # 4-byte Folded Spill
	lw	x10, 472(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 472(x2)                    # 4-byte Folded Spill
	li	x10, 8
	lw	x9, 108(x2)                     # 4-byte Folded Reload
	beq	x9, x10, .LBB0_111
.LBB0_114:                              # %for.body6.i361.i
                                        #   Parent Loop BB0_112 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_116 Depth 3
                                        #         Child Loop BB0_117 Depth 4
                                        #         Child Loop BB0_119 Depth 4
                                        #         Child Loop BB0_121 Depth 4
                                        #         Child Loop BB0_123 Depth 4
                                        #         Child Loop BB0_125 Depth 4
                                        #         Child Loop BB0_127 Depth 4
                                        #         Child Loop BB0_129 Depth 4
                                        #         Child Loop BB0_131 Depth 4
                                        #         Child Loop BB0_133 Depth 4
	li	x17, 0
	slli	x10, x9, 8
	addi	x9, x9, 1
	lui	x30, %hi(w_s3a)
	addi	x30, x30, %lo(w_s3a)
	addi	x11, x30, 128
	sw	x11, 824(x2)                    # 4-byte Folded Spill
	addi	x11, x30, 256
	sw	x11, 792(x2)                    # 4-byte Folded Spill
	addi	x11, x30, 384
	sw	x11, 760(x2)                    # 4-byte Folded Spill
	addi	x11, x30, 512
	sw	x11, 728(x2)                    # 4-byte Folded Spill
	addi	x11, x30, 640
	sw	x11, 696(x2)                    # 4-byte Folded Spill
	addi	x1, x30, 768
	addi	x11, x30, 896
	sw	x11, 664(x2)                    # 4-byte Folded Spill
	lw	x13, 92(x2)                     # 4-byte Folded Reload
	add	x13, x13, x10
	lw	x14, 88(x2)                     # 4-byte Folded Reload
	add	x14, x14, x10
	lw	x8, 84(x2)                      # 4-byte Folded Reload
	add	x8, x8, x10
	lw	x11, 80(x2)                     # 4-byte Folded Reload
	add	x11, x11, x10
	lw	x12, 76(x2)                     # 4-byte Folded Reload
	add	x12, x12, x10
	lw	x5, 72(x2)                      # 4-byte Folded Reload
	add	x5, x5, x10
	lw	x6, 104(x2)                     # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x23, 100(x2)                    # 4-byte Folded Reload
	add	x23, x23, x10
	lw	x20, 96(x2)                     # 4-byte Folded Reload
	add	x20, x20, x10
	sw	x9, 108(x2)                     # 4-byte Folded Spill
	lw	x7, 68(x2)                      # 4-byte Folded Reload
	add	x7, x9, x7
	lui	x25, %hi(y2)
	addi	x25, x25, %lo(y2)
	add	x13, x25, x13
	add	x14, x25, x14
	sw	x14, 152(x2)                    # 4-byte Folded Spill
	add	x8, x25, x8
	sw	x8, 120(x2)                     # 4-byte Folded Spill
	add	x11, x25, x11
	sw	x11, 116(x2)                    # 4-byte Folded Spill
	add	x26, x25, x12
	add	x27, x25, x5
	add	x5, x25, x6
	add	x24, x25, x23
	add	x25, x25, x20
	slli	x7, x7, 8
	lui	x10, %hi(a3)
	addi	x10, x10, %lo(a3)
	add	x10, x10, x7
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	addi	x7, x30, 1024
	sw	x13, 184(x2)                    # 4-byte Folded Spill
	j	.LBB0_116
.LBB0_115:                              # %for.cond.cleanup42.i398.2.i.2
                                        #   in Loop: Header=BB0_116 Depth=3
	lw	x10, 112(x2)                    # 4-byte Folded Reload
	lw	x11, 504(x2)                    # 4-byte Folded Reload
	add	x10, x10, x11
	lw	x17, 632(x2)                    # 4-byte Folded Reload
	addi	x17, x17, 1
	lw	x30, 536(x2)                    # 4-byte Folded Reload
	addi	x30, x30, 1152
	lw	x11, 824(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1152
	sw	x11, 824(x2)                    # 4-byte Folded Spill
	lw	x11, 792(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1152
	sw	x11, 792(x2)                    # 4-byte Folded Spill
	lw	x11, 760(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1152
	sw	x11, 760(x2)                    # 4-byte Folded Spill
	lw	x11, 728(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1152
	sw	x11, 728(x2)                    # 4-byte Folded Spill
	lw	x11, 696(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1152
	sw	x11, 696(x2)                    # 4-byte Folded Spill
	lw	x1, 600(x2)                     # 4-byte Folded Reload
	addi	x1, x1, 1152
	lw	x11, 664(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1152
	sw	x11, 664(x2)                    # 4-byte Folded Spill
	sw	x6, 0(x10)
	addi	x7, x7, 1152
	lui	x15, %hi(.L_MergedGlobals)
	addi	x15, x15, %lo(.L_MergedGlobals)
	li	x10, 64
	beq	x17, x10, .LBB0_113
.LBB0_116:                              # %for.body21.i370.i
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_117 Depth 4
                                        #         Child Loop BB0_119 Depth 4
                                        #         Child Loop BB0_121 Depth 4
                                        #         Child Loop BB0_123 Depth 4
                                        #         Child Loop BB0_125 Depth 4
                                        #         Child Loop BB0_127 Depth 4
                                        #         Child Loop BB0_129 Depth 4
                                        #         Child Loop BB0_131 Depth 4
                                        #         Child Loop BB0_133 Depth 4
	sw	x7, 568(x2)                     # 4-byte Folded Spill
	sw	x17, 632(x2)                    # 4-byte Folded Spill
	slli	x17, x17, 2
	sw	x17, 504(x2)                    # 4-byte Folded Spill
	add	x6, x15, x17
	lw	x28, 656(x6)
	sw	x30, 536(x2)                    # 4-byte Folded Spill
	lw	x6, 216(x2)                     # 4-byte Folded Reload
.LBB0_117:                              # %vector.body155
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x30)
	xr.repeat	1, x29, x31
	lw	x16, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x16, x8, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x25, .LBB0_117
# %bb.118:                              # %for.cond.cleanup42.i398.i
                                        #   in Loop: Header=BB0_116 Depth=3
	lw	x30, 824(x2)                    # 4-byte Folded Reload
	lw	x6, 248(x2)                     # 4-byte Folded Reload
	lw	x7, 116(x2)                     # 4-byte Folded Reload
.LBB0_119:                              # %vector.body147
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x24, .LBB0_119
# %bb.120:                              # %for.cond.cleanup42.i398.1.i
                                        #   in Loop: Header=BB0_116 Depth=3
	lw	x30, 792(x2)                    # 4-byte Folded Reload
	lw	x6, 280(x2)                     # 4-byte Folded Reload
.LBB0_121:                              # %vector.body139
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x5, .LBB0_121
# %bb.122:                              # %for.cond.cleanup42.i398.2.i
                                        #   in Loop: Header=BB0_116 Depth=3
	lw	x30, 760(x2)                    # 4-byte Folded Reload
	lw	x6, 312(x2)                     # 4-byte Folded Reload
.LBB0_123:                              # %vector.body131
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x27, .LBB0_123
# %bb.124:                              # %for.cond.cleanup42.i398.i.1
                                        #   in Loop: Header=BB0_116 Depth=3
	lw	x30, 728(x2)                    # 4-byte Folded Reload
	lw	x6, 344(x2)                     # 4-byte Folded Reload
.LBB0_125:                              # %vector.body123
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x26, .LBB0_125
# %bb.126:                              # %for.cond.cleanup42.i398.1.i.1
                                        #   in Loop: Header=BB0_116 Depth=3
	lw	x30, 696(x2)                    # 4-byte Folded Reload
	lw	x6, 376(x2)                     # 4-byte Folded Reload
.LBB0_127:                              # %vector.body115
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x7, .LBB0_127
# %bb.128:                              # %for.cond.cleanup42.i398.2.i.1
                                        #   in Loop: Header=BB0_116 Depth=3
	mv	x30, x1
	lw	x6, 408(x2)                     # 4-byte Folded Reload
	lw	x7, 120(x2)                     # 4-byte Folded Reload
.LBB0_129:                              # %vector.body107
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x7, .LBB0_129
# %bb.130:                              # %for.cond.cleanup42.i398.i.2
                                        #   in Loop: Header=BB0_116 Depth=3
	sw	x1, 600(x2)                     # 4-byte Folded Spill
	lw	x30, 664(x2)                    # 4-byte Folded Reload
	lw	x6, 440(x2)                     # 4-byte Folded Reload
	lw	x1, 152(x2)                     # 4-byte Folded Reload
.LBB0_131:                              # %vector.body99
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x1, .LBB0_131
# %bb.132:                              # %for.cond.cleanup42.i398.1.i.2
                                        #   in Loop: Header=BB0_116 Depth=3
	lw	x7, 568(x2)                     # 4-byte Folded Reload
	mv	x30, x7
	lw	x6, 472(x2)                     # 4-byte Folded Reload
	lw	x1, 184(x2)                     # 4-byte Folded Reload
.LBB0_133:                              # %vector.body91
                                        #   Parent Loop BB0_112 Depth=1
                                        #     Parent Loop BB0_114 Depth=2
                                        #       Parent Loop BB0_116 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x30)
	xr.repeat	1, x29, x31
	lw	x8, 0(x6)
	xr.repeat	1, x29, x31
	addi	x6, x6, 32
	xr.mac	x28, x8, x16, x28
	xr.repeat	6, x0, x31
	addi	x30, x30, 32
	bne	x6, x1, .LBB0_133
# %bb.134:                              # %for.cond.cleanup42.i398.2.i.2
                                        #   in Loop: Header=BB0_116 Depth=3
	srai	x10, x28, 4
	sgtz	x11, x10
	neg	x11, x11
	and	x6, x11, x10
	li	x10, 127
	blt	x6, x10, .LBB0_115
# %bb.135:                              # %for.cond.cleanup42.i398.2.i.2
                                        #   in Loop: Header=BB0_116 Depth=3
	li	x6, 127
	j	.LBB0_115
.LBB0_136:                              # %for.cond3.preheader.i415.i.preheader
	li	x12, 0
	lui	x10, %hi(y2)
	addi	x10, x10, %lo(y2)
	li	x16, 7
	li	x7, 4
	li	x5, 9
	addi	x17, x10, 2047
	addi	x17, x17, 385
	slli	x5, x5, 9
	sw	x5, 696(x2)                     # 4-byte Folded Spill
	j	.LBB0_138
.LBB0_137:                              # %for.cond.cleanup5.i474.i
                                        #   in Loop: Header=BB0_138 Depth=1
	lw	x17, 728(x2)                    # 4-byte Folded Reload
	lw	x10, 696(x2)                    # 4-byte Folded Reload
	add	x17, x17, x10
	lw	x12, 760(x2)                    # 4-byte Folded Reload
	li	x10, 8
	beq	x12, x10, .LBB0_148
.LBB0_138:                              # %for.cond3.preheader.i415.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_140 Depth 2
                                        #       Child Loop BB0_142 Depth 3
                                        #         Child Loop BB0_143 Depth 4
	li	x13, 0
	lw	x10, 52(x2)                     # 4-byte Folded Reload
	mul	x10, x12, x10
	addi	x12, x12, 1
	lw	x11, 56(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	slli	x28, x12, 1
	sw	x12, 760(x2)                    # 4-byte Folded Spill
	slli	x29, x12, 3
	addi	x10, x10, 256
	sw	x10, 824(x2)                    # 4-byte Folded Spill
	add	x28, x29, x28
	sw	x28, 792(x2)                    # 4-byte Folded Spill
	sw	x17, 728(x2)                    # 4-byte Folded Spill
	j	.LBB0_140
.LBB0_139:                              # %for.cond3.loopexit.i472.i
                                        #   in Loop: Header=BB0_140 Depth=2
	addi	x17, x17, 256
	li	x10, 8
	mv	x13, x23
	beq	x23, x10, .LBB0_137
.LBB0_140:                              # %for.body6.i423.i
                                        #   Parent Loop BB0_138 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_142 Depth 3
                                        #         Child Loop BB0_143 Depth 4
	li	x18, 0
	slli	x31, x13, 8
	addi	x13, x13, 1
	lw	x10, 824(x2)                    # 4-byte Folded Reload
	add	x31, x10, x31
	mv	x23, x13
	lw	x8, 792(x2)                     # 4-byte Folded Reload
	add	x8, x13, x8
	lui	x6, %hi(y2)
	addi	x6, x6, %lo(y2)
	add	x6, x6, x31
	slli	x8, x8, 8
	lui	x5, %hi(p3)
	addi	x5, x5, %lo(p3)
	add	x5, x5, x8
	lui	x22, %hi(w_s3p)
	addi	x22, x22, %lo(w_s3p)
	j	.LBB0_142
.LBB0_141:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_142 Depth=3
	add	x1, x5, x1
	addi	x18, x18, 1
	sw	x19, 0(x1)
	addi	x22, x22, 128
	li	x10, 64
	beq	x18, x10, .LBB0_139
.LBB0_142:                              # %for.body21.i432.i
                                        #   Parent Loop BB0_138 Depth=1
                                        #     Parent Loop BB0_140 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_143 Depth 4
	slli	x1, x18, 2
	add	x19, x15, x1
	lw	x19, 1168(x19)
	mv	x20, x22
	mv	x21, x17
.LBB0_143:                              # %vector.body163
                                        #   Parent Loop BB0_138 Depth=1
                                        #     Parent Loop BB0_140 Depth=2
                                        #       Parent Loop BB0_142 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x8, 0(x20)
	xr.repeat	1, x7, x16
	lw	x24, 0(x21)
	xr.repeat	1, x7, x16
	addi	x21, x21, 32
	xr.mac	x19, x24, x8, x19
	xr.repeat	6, x0, x16
	addi	x20, x20, 32
	bne	x21, x6, .LBB0_143
# %bb.144:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_142 Depth=3
	srai	x19, x19, 3
	li	x10, -128
	blt	x10, x19, .LBB0_146
# %bb.145:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_142 Depth=3
	li	x19, -128
.LBB0_146:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_142 Depth=3
	li	x10, 127
	lui	x15, %hi(.L_MergedGlobals)
	addi	x15, x15, %lo(.L_MergedGlobals)
	blt	x19, x10, .LBB0_141
# %bb.147:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_142 Depth=3
	li	x19, 127
	j	.LBB0_141
.LBB0_148:                              # %for.cond3.preheader.i477.i.preheader
	li	x17, 0
	li	x16, 5
	li	x10, 21
	li	x11, 11
	lui	x19, %hi(a3)
	addi	x19, x19, %lo(a3)
	addi	x5, x19, 256
	addi	x6, x19, 512
	addi	x12, x19, 2047
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 256
	sw	x13, 8(x2)                      # 4-byte Folded Spill
	li	x28, 7
	li	x29, 4
	li	x24, 9
	slli	x13, x16, 10
	slli	x10, x10, 8
	slli	x11, x11, 9
	addi	x7, x12, 513
	addi	x30, x12, 769
	addi	x31, x12, 1025
	slli	x24, x24, 8
	sw	x24, 104(x2)                    # 4-byte Folded Spill
	add	x8, x19, x13
	add	x9, x19, x10
	add	x18, x19, x11
	j	.LBB0_150
.LBB0_149:                              # %for.cond.cleanup5.i538.i
                                        #   in Loop: Header=BB0_150 Depth=1
	li	x10, 5
	slli	x10, x10, 9
	lw	x19, 12(x2)                     # 4-byte Folded Reload
	add	x19, x19, x10
	lw	x5, 44(x2)                      # 4-byte Folded Reload
	add	x5, x5, x10
	lw	x6, 40(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x7, 36(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x30, 32(x2)                     # 4-byte Folded Reload
	add	x30, x30, x10
	lw	x31, 28(x2)                     # 4-byte Folded Reload
	add	x31, x31, x10
	lw	x8, 24(x2)                      # 4-byte Folded Reload
	add	x8, x8, x10
	lw	x9, 20(x2)                      # 4-byte Folded Reload
	add	x9, x9, x10
	lw	x18, 16(x2)                     # 4-byte Folded Reload
	add	x18, x18, x10
	lw	x17, 48(x2)                     # 4-byte Folded Reload
	li	x10, 8
	beq	x17, x10, .LBB0_174
.LBB0_150:                              # %for.cond3.preheader.i477.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_152 Depth 2
                                        #       Child Loop BB0_154 Depth 3
                                        #         Child Loop BB0_155 Depth 4
                                        #         Child Loop BB0_157 Depth 4
                                        #         Child Loop BB0_159 Depth 4
                                        #         Child Loop BB0_161 Depth 4
                                        #         Child Loop BB0_163 Depth 4
                                        #         Child Loop BB0_165 Depth 4
                                        #         Child Loop BB0_167 Depth 4
                                        #         Child Loop BB0_169 Depth 4
                                        #         Child Loop BB0_171 Depth 4
	li	x20, 0
	lw	x10, 8(x2)                      # 4-byte Folded Reload
	mul	x10, x17, x10
	addi	x17, x17, 1
	lw	x16, 52(x2)                     # 4-byte Folded Reload
	add	x11, x16, x10
	addi	x21, x10, 768
	lw	x14, 56(x2)                     # 4-byte Folded Reload
	add	x12, x14, x10
	addi	x22, x10, 512
	addi	x10, x10, 256
	sw	x10, 88(x2)                     # 4-byte Folded Spill
	slli	x10, x17, 1
	sw	x17, 48(x2)                     # 4-byte Folded Spill
	slli	x13, x17, 3
	addi	x17, x11, 1280
	sw	x17, 84(x2)                     # 4-byte Folded Spill
	addi	x11, x11, 1024
	sw	x11, 80(x2)                     # 4-byte Folded Spill
	add	x16, x21, x16
	sw	x16, 76(x2)                     # 4-byte Folded Spill
	addi	x11, x12, 1024
	sw	x11, 72(x2)                     # 4-byte Folded Spill
	sw	x21, 96(x2)                     # 4-byte Folded Spill
	add	x21, x21, x14
	sw	x21, 68(x2)                     # 4-byte Folded Spill
	sw	x22, 92(x2)                     # 4-byte Folded Spill
	add	x14, x22, x14
	sw	x14, 64(x2)                     # 4-byte Folded Spill
	add	x10, x13, x10
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	sw	x18, 16(x2)                     # 4-byte Folded Spill
	sw	x18, 472(x2)                    # 4-byte Folded Spill
	sw	x9, 20(x2)                      # 4-byte Folded Spill
	sw	x9, 440(x2)                     # 4-byte Folded Spill
	sw	x8, 24(x2)                      # 4-byte Folded Spill
	sw	x8, 408(x2)                     # 4-byte Folded Spill
	sw	x31, 28(x2)                     # 4-byte Folded Spill
	sw	x31, 376(x2)                    # 4-byte Folded Spill
	sw	x30, 32(x2)                     # 4-byte Folded Spill
	sw	x30, 344(x2)                    # 4-byte Folded Spill
	sw	x7, 36(x2)                      # 4-byte Folded Spill
	sw	x7, 312(x2)                     # 4-byte Folded Spill
	sw	x6, 40(x2)                      # 4-byte Folded Spill
	sw	x6, 280(x2)                     # 4-byte Folded Spill
	sw	x5, 44(x2)                      # 4-byte Folded Spill
	sw	x5, 248(x2)                     # 4-byte Folded Spill
	sw	x19, 12(x2)                     # 4-byte Folded Spill
	sw	x19, 216(x2)                    # 4-byte Folded Spill
	j	.LBB0_152
.LBB0_151:                              # %for.cond3.loopexit.i536.i
                                        #   in Loop: Header=BB0_152 Depth=2
	lw	x10, 216(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 216(x2)                    # 4-byte Folded Spill
	lw	x10, 248(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 248(x2)                    # 4-byte Folded Spill
	lw	x10, 280(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 280(x2)                    # 4-byte Folded Spill
	lw	x10, 312(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 312(x2)                    # 4-byte Folded Spill
	lw	x10, 344(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 344(x2)                    # 4-byte Folded Spill
	lw	x10, 376(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 376(x2)                    # 4-byte Folded Spill
	lw	x10, 408(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 408(x2)                    # 4-byte Folded Spill
	lw	x10, 440(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 440(x2)                    # 4-byte Folded Spill
	lw	x10, 472(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 472(x2)                    # 4-byte Folded Spill
	li	x10, 8
	lw	x20, 100(x2)                    # 4-byte Folded Reload
	beq	x20, x10, .LBB0_149
.LBB0_152:                              # %for.body6.i485.i
                                        #   Parent Loop BB0_150 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_154 Depth 3
                                        #         Child Loop BB0_155 Depth 4
                                        #         Child Loop BB0_157 Depth 4
                                        #         Child Loop BB0_159 Depth 4
                                        #         Child Loop BB0_161 Depth 4
                                        #         Child Loop BB0_163 Depth 4
                                        #         Child Loop BB0_165 Depth 4
                                        #         Child Loop BB0_167 Depth 4
                                        #         Child Loop BB0_169 Depth 4
                                        #         Child Loop BB0_171 Depth 4
	li	x14, 0
	slli	x13, x20, 8
	addi	x20, x20, 1
	lui	x12, %hi(w_s3b)
	addi	x12, x12, %lo(w_s3b)
	addi	x10, x12, 256
	sw	x10, 824(x2)                    # 4-byte Folded Spill
	addi	x10, x12, 512
	sw	x10, 792(x2)                    # 4-byte Folded Spill
	addi	x10, x12, 768
	sw	x10, 760(x2)                    # 4-byte Folded Spill
	addi	x10, x12, 1024
	sw	x10, 728(x2)                    # 4-byte Folded Spill
	addi	x10, x12, 1280
	sw	x10, 696(x2)                    # 4-byte Folded Spill
	addi	x24, x12, 1536
	addi	x31, x12, 1792
	addi	x17, x12, 2047
	lw	x5, 84(x2)                      # 4-byte Folded Reload
	add	x5, x5, x13
	lw	x7, 80(x2)                      # 4-byte Folded Reload
	add	x7, x7, x13
	lw	x1, 76(x2)                      # 4-byte Folded Reload
	add	x1, x1, x13
	lw	x27, 72(x2)                     # 4-byte Folded Reload
	add	x27, x27, x13
	lw	x30, 68(x2)                     # 4-byte Folded Reload
	add	x30, x30, x13
	lw	x26, 64(x2)                     # 4-byte Folded Reload
	add	x26, x26, x13
	lw	x8, 96(x2)                      # 4-byte Folded Reload
	add	x8, x8, x13
	lw	x10, 92(x2)                     # 4-byte Folded Reload
	add	x10, x10, x13
	lw	x23, 88(x2)                     # 4-byte Folded Reload
	add	x23, x23, x13
	sw	x20, 100(x2)                    # 4-byte Folded Spill
	lw	x9, 60(x2)                      # 4-byte Folded Reload
	add	x9, x20, x9
	lui	x6, %hi(a3)
	addi	x6, x6, %lo(a3)
	add	x13, x6, x5
	add	x7, x6, x7
	sw	x7, 152(x2)                     # 4-byte Folded Spill
	add	x1, x6, x1
	sw	x1, 120(x2)                     # 4-byte Folded Spill
	add	x27, x6, x27
	sw	x27, 116(x2)                    # 4-byte Folded Spill
	add	x7, x6, x30
	add	x26, x6, x26
	add	x5, x6, x8
	add	x30, x6, x10
	add	x6, x6, x23
	slli	x9, x9, 8
	lui	x10, %hi(y3)
	addi	x10, x10, %lo(y3)
	add	x10, x10, x9
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	lui	x10, %hi(p3)
	addi	x10, x10, %lo(p3)
	add	x10, x10, x9
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	addi	x17, x17, 1
	sw	x17, 664(x2)                    # 4-byte Folded Spill
	mv	x1, x12
	sw	x13, 184(x2)                    # 4-byte Folded Spill
	j	.LBB0_154
.LBB0_153:                              # %for.cond.cleanup42.i522.2.i.2
                                        #   in Loop: Header=BB0_154 Depth=3
	lw	x10, 112(x2)                    # 4-byte Folded Reload
	add	x10, x10, x12
	lw	x14, 632(x2)                    # 4-byte Folded Reload
	addi	x14, x14, 1
	lw	x11, 104(x2)                    # 4-byte Folded Reload
	lw	x1, 536(x2)                     # 4-byte Folded Reload
	add	x1, x1, x11
	lw	x12, 824(x2)                    # 4-byte Folded Reload
	add	x12, x12, x11
	sw	x12, 824(x2)                    # 4-byte Folded Spill
	lw	x12, 792(x2)                    # 4-byte Folded Reload
	add	x12, x12, x11
	sw	x12, 792(x2)                    # 4-byte Folded Spill
	lw	x12, 760(x2)                    # 4-byte Folded Reload
	add	x12, x12, x11
	sw	x12, 760(x2)                    # 4-byte Folded Spill
	lw	x12, 728(x2)                    # 4-byte Folded Reload
	add	x12, x12, x11
	sw	x12, 728(x2)                    # 4-byte Folded Spill
	lw	x12, 696(x2)                    # 4-byte Folded Reload
	add	x12, x12, x11
	sw	x12, 696(x2)                    # 4-byte Folded Spill
	lw	x24, 600(x2)                    # 4-byte Folded Reload
	add	x24, x24, x11
	add	x31, x31, x11
	sw	x9, 0(x10)
	lw	x10, 664(x2)                    # 4-byte Folded Reload
	add	x10, x10, x11
	sw	x10, 664(x2)                    # 4-byte Folded Spill
	lui	x15, %hi(.L_MergedGlobals)
	addi	x15, x15, %lo(.L_MergedGlobals)
	li	x10, 64
	beq	x14, x10, .LBB0_151
.LBB0_154:                              # %for.body21.i494.i
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_155 Depth 4
                                        #         Child Loop BB0_157 Depth 4
                                        #         Child Loop BB0_159 Depth 4
                                        #         Child Loop BB0_161 Depth 4
                                        #         Child Loop BB0_163 Depth 4
                                        #         Child Loop BB0_165 Depth 4
                                        #         Child Loop BB0_167 Depth 4
                                        #         Child Loop BB0_169 Depth 4
                                        #         Child Loop BB0_171 Depth 4
	sw	x14, 632(x2)                    # 4-byte Folded Spill
	slli	x14, x14, 2
	sw	x14, 504(x2)                    # 4-byte Folded Spill
	add	x9, x15, x14
	lw	x25, 912(x9)
	sw	x1, 536(x2)                     # 4-byte Folded Spill
	lw	x27, 216(x2)                    # 4-byte Folded Reload
.LBB0_155:                              # %vector.body235
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x1)
	xr.repeat	1, x29, x28
	lw	x8, 0(x27)
	xr.repeat	1, x29, x28
	addi	x27, x27, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x1, x1, 32
	bne	x27, x6, .LBB0_155
# %bb.156:                              # %for.cond.cleanup42.i522.i
                                        #   in Loop: Header=BB0_154 Depth=3
	lw	x27, 824(x2)                    # 4-byte Folded Reload
	lw	x1, 248(x2)                     # 4-byte Folded Reload
.LBB0_157:                              # %vector.body227
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x30, .LBB0_157
# %bb.158:                              # %for.cond.cleanup42.i522.1.i
                                        #   in Loop: Header=BB0_154 Depth=3
	lw	x27, 792(x2)                    # 4-byte Folded Reload
	lw	x1, 280(x2)                     # 4-byte Folded Reload
.LBB0_159:                              # %vector.body219
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x5, .LBB0_159
# %bb.160:                              # %for.cond.cleanup42.i522.2.i
                                        #   in Loop: Header=BB0_154 Depth=3
	lw	x27, 760(x2)                    # 4-byte Folded Reload
	lw	x1, 312(x2)                     # 4-byte Folded Reload
.LBB0_161:                              # %vector.body211
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x26, .LBB0_161
# %bb.162:                              # %for.cond.cleanup42.i522.i.1
                                        #   in Loop: Header=BB0_154 Depth=3
	lw	x27, 728(x2)                    # 4-byte Folded Reload
	lw	x1, 344(x2)                     # 4-byte Folded Reload
.LBB0_163:                              # %vector.body203
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x7, .LBB0_163
# %bb.164:                              # %for.cond.cleanup42.i522.1.i.1
                                        #   in Loop: Header=BB0_154 Depth=3
	sw	x31, 568(x2)                    # 4-byte Folded Spill
	lw	x27, 696(x2)                    # 4-byte Folded Reload
	lw	x1, 376(x2)                     # 4-byte Folded Reload
	lw	x31, 116(x2)                    # 4-byte Folded Reload
.LBB0_165:                              # %vector.body195
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x31, .LBB0_165
# %bb.166:                              # %for.cond.cleanup42.i522.2.i.1
                                        #   in Loop: Header=BB0_154 Depth=3
	mv	x27, x24
	lw	x1, 408(x2)                     # 4-byte Folded Reload
	lw	x31, 120(x2)                    # 4-byte Folded Reload
.LBB0_167:                              # %vector.body187
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x31, .LBB0_167
# %bb.168:                              # %for.cond.cleanup42.i522.i.2
                                        #   in Loop: Header=BB0_154 Depth=3
	sw	x24, 600(x2)                    # 4-byte Folded Spill
	lw	x31, 568(x2)                    # 4-byte Folded Reload
	mv	x27, x31
	lw	x1, 440(x2)                     # 4-byte Folded Reload
	lw	x24, 152(x2)                    # 4-byte Folded Reload
.LBB0_169:                              # %vector.body179
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x24, .LBB0_169
# %bb.170:                              # %for.cond.cleanup42.i522.1.i.2
                                        #   in Loop: Header=BB0_154 Depth=3
	lw	x27, 664(x2)                    # 4-byte Folded Reload
	lw	x1, 472(x2)                     # 4-byte Folded Reload
	lw	x24, 184(x2)                    # 4-byte Folded Reload
.LBB0_171:                              # %vector.body171
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x27)
	xr.repeat	1, x29, x28
	lw	x8, 0(x1)
	xr.repeat	1, x29, x28
	addi	x1, x1, 32
	xr.mac	x25, x8, x16, x25
	xr.repeat	6, x0, x28
	addi	x27, x27, 32
	bne	x1, x24, .LBB0_171
# %bb.172:                              # %for.cond.cleanup42.i522.2.i.2
                                        #   in Loop: Header=BB0_154 Depth=3
	lw	x10, 108(x2)                    # 4-byte Folded Reload
	lw	x12, 504(x2)                    # 4-byte Folded Reload
	add	x10, x10, x12
	lw	x10, 0(x10)
	srai	x11, x25, 5
	add	x10, x10, x11
	sgtz	x11, x10
	neg	x9, x11
	and	x9, x9, x10
	li	x10, 127
	blt	x9, x10, .LBB0_153
# %bb.173:                              # %for.cond.cleanup42.i522.2.i.2
                                        #   in Loop: Header=BB0_154 Depth=3
	li	x9, 127
	j	.LBB0_153
.LBB0_174:                              # %conv.exit540.i
	li	x10, 0
	#APP
	#NO_APP
	lui	x15, 65555
	li	x16, 4
	li	x13, 11
	lui	x14, 3
	sw	x16, 0(x15)
	slli	x15, x13, 10
	#APP
	#NO_APP
	lui	x17, 4
	lui	x5, 5
	li	x6, 256
	lui	x16, %hi(y3)
	addi	x16, x16, %lo(y3)
.LBB0_175:                              # %for.cond1.preheader.i9
                                        # =>This Inner Loop Header: Depth=1
	add	x7, x16, x10
	addi	x18, x7, 2047
	lui	x9, 1
	add	x9, x7, x9
	lui	x28, 2
	add	x28, x7, x28
	add	x29, x7, x15
	addi	x31, x14, 768
	add	x31, x7, x31
	add	x30, x7, x17
	add	x8, x7, x5
	addi	x19, x18, 769
	lw	x20, 769(x18)
	lw	x18, 1025(x18)
	lw	x21, 1280(x9)
	lw	x22, 1536(x9)
	lw	x23, -1536(x28)
	lw	x24, -1280(x28)
	lw	x25, 512(x28)
	lw	x26, 768(x28)
	lw	x27, -256(x29)
	lw	x1, 0(x29)
	lw	x11, 512(x31)
	lw	x12, 768(x31)
	add	x18, x18, x20
	lw	x20, 0(x30)
	add	x21, x21, x22
	lw	x22, 256(x30)
	add	x23, x23, x24
	lw	x24, -1024(x8)
	add	x25, x25, x26
	lw	x26, -768(x8)
	add	x27, x27, x1
	lw	x1, 512(x19)
	add	x11, x11, x12
	lw	x12, 768(x19)
	add	x20, x20, x22
	lw	x22, 1024(x19)
	add	x24, x24, x26
	lw	x26, 1280(x19)
	add	x18, x18, x1
	lw	x1, 1536(x19)
	lw	x9, 1792(x9)
	add	x12, x12, x22
	lw	x22, -1024(x28)
	add	x26, x26, x1
	lw	x1, 1024(x28)
	add	x21, x21, x9
	lw	x9, 256(x29)
	add	x22, x23, x22
	lw	x23, 1024(x31)
	add	x25, x25, x1
	lw	x1, 512(x30)
	add	x27, x27, x9
	add	x11, x11, x23
	lw	x23, -512(x8)
	add	x20, x20, x1
	slli	x9, x13, 11
	add	x9, x7, x9
	lw	x19, 1792(x19)
	add	x23, x24, x23
	lw	x24, -2048(x28)
	add	x12, x18, x12
	lw	x18, -256(x28)
	add	x19, x26, x19
	lw	x26, 1280(x28)
	add	x21, x21, x24
	lw	x24, 512(x29)
	add	x18, x22, x18
	lw	x22, 1280(x31)
	add	x25, x25, x26
	lw	x26, 768(x30)
	add	x24, x27, x24
	lw	x27, -1792(x9)
	add	x11, x11, x22
	add	x20, x20, x26
	lw	x22, -1792(x28)
	add	x23, x23, x27
	lw	x26, 0(x28)
	add	x12, x12, x19
	lw	x19, 1536(x28)
	add	x21, x21, x22
	lw	x22, 768(x29)
	add	x18, x18, x26
	lw	x26, 1536(x31)
	add	x19, x25, x19
	add	x22, x24, x22
	lw	x24, 1024(x30)
	add	x11, x11, x26
	lw	x25, -1536(x9)
	lw	x28, 256(x28)
	add	x20, x20, x24
	lw	x24, -768(x29)
	add	x23, x23, x25
	lw	x25, 1024(x29)
	add	x12, x12, x21
	lw	x21, 1792(x31)
	add	x28, x18, x28
	lw	x18, 1792(x30)
	add	x19, x19, x24
	lw	x24, -1280(x9)
	add	x22, x22, x25
	add	x11, x11, x21
	lui	x21, %hi(.L_MergedGlobals)
	addi	x21, x21, %lo(.L_MergedGlobals)
	add	x18, x20, x18
	add	x23, x23, x24
	lw	x29, -512(x29)
	lw	x31, 0(x31)
	add	x12, x12, x28
	lw	x28, -768(x30)
	add	x29, x19, x29
	lw	x19, -2048(x8)
	add	x31, x22, x31
	add	x11, x11, x28
	lw	x28, -1024(x9)
	add	x18, x18, x19
	add	x7, x7, x14
	lw	x7, 1024(x7)
	add	x28, x23, x28
	lw	x19, -512(x30)
	add	x12, x12, x29
	lw	x29, -1792(x8)
	add	x7, x31, x7
	lw	x31, -768(x9)
	add	x11, x11, x19
	add	x29, x18, x29
	lw	x30, -256(x30)
	add	x28, x28, x31
	lw	x31, -1536(x8)
	add	x12, x12, x7
	lw	x7, -512(x9)
	add	x11, x11, x30
	add	x29, x29, x31
	lw	x30, -1280(x8)
	add	x7, x28, x7
	lw	x28, -256(x9)
	add	x11, x12, x11
	add	x29, x29, x30
	lw	x12, 0(x9)
	add	x7, x7, x28
	add	x28, x21, x10
	add	x11, x11, x29
	add	x12, x7, x12
	add	x11, x11, x12
	srai	x12, x11, 31
	srli	x12, x12, 26
	add	x11, x11, x12
	srai	x11, x11, 6
	addi	x10, x10, 4
	sw	x11, 1424(x28)
	bne	x10, x6, .LBB0_175
# %bb.176:                              # %for.body21.i.preheader
	li	x18, 0
	lui	x7, %hi(w_fc)
	addi	x7, x7, %lo(w_fc)
	li	x19, 7
	li	x20, 4
	addi	x21, x21, 1680
	li	x22, 10
	lw	x23, 4(x2)                      # 4-byte Folded Reload
.LBB0_177:                              # %for.body21.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_178 Depth 2
	slli	x16, x18, 2
	lui	x10, %hi(.L_MergedGlobals)
	addi	x10, x10, %lo(.L_MergedGlobals)
	add	x16, x10, x16
	lw	x17, 40(x16)
	mv	x5, x7
	mv	x6, x23
.LBB0_178:                              # %vector.body243
                                        #   Parent Loop BB0_177 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x24, 0(x5)
	xr.repeat	1, x20, x19
	lw	x8, 0(x6)
	xr.repeat	1, x20, x19
	addi	x6, x6, 32
	xr.mac	x17, x8, x24, x17
	xr.repeat	6, x0, x19
	addi	x5, x5, 32
	bne	x6, x21, .LBB0_178
# %bb.179:                              # %for.cond.cleanup26.i
                                        #   in Loop: Header=BB0_177 Depth=1
	sw	x17, 0(x16)
	addi	x18, x18, 1
	addi	x7, x7, 256
	bne	x18, x22, .LBB0_177
# %bb.180:                              # %resnet8.exit
	#APP
	#NO_APP
	lui	x10, 65555
	li	x11, 5
	sw	x11, 0(x10)
	#APP
	#NO_APP
	lui	x9, %hi(.L_MergedGlobals)
	addi	x9, x9, %lo(.L_MergedGlobals)
	lw	x10, 0(x9)
	lw	x11, 4(x9)
	lw	x12, 8(x9)
	slt	x11, x10, x11
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_182
# %bb.181:                              # %resnet8.exit
	li	x11, 2
.LBB0_182:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x12, 12(x9)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_184
# %bb.183:                              # %resnet8.exit
	li	x11, 3
.LBB0_184:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x12, 16(x9)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_186
# %bb.185:                              # %resnet8.exit
	li	x11, 4
.LBB0_186:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x12, 20(x9)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_188
# %bb.187:                              # %resnet8.exit
	li	x11, 5
.LBB0_188:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x12, 24(x9)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_190
# %bb.189:                              # %resnet8.exit
	li	x11, 6
.LBB0_190:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x12, 28(x9)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_192
# %bb.191:                              # %resnet8.exit
	li	x11, 7
.LBB0_192:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x12, 32(x9)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_194
# %bb.193:                              # %resnet8.exit
	li	x11, 8
.LBB0_194:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x9, x10
	lw	x12, 36(x9)
	lw	x13, 0(x10)
	lui	x10, 4096
	bge	x13, x12, .LBB0_196
# %bb.195:                              # %resnet8.exit
	li	x11, 9
.LBB0_196:                              # %resnet8.exit
	addi	x8, x10, 403
	lui	x10, %hi(.L.str.1)
	addi	x10, x10, %lo(.L.str.1)
	call	printf
	lui	x10, 528842
	li	x11, 25
	addi	x10, x10, -571
	slli	x11, x11, 10
	lui	x13, %hi(y3)
	addi	x13, x13, %lo(y3)
	add	x11, x13, x11
.LBB0_197:                              # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	lw	x12, 0(x13)
	addi	x13, x13, 4
	xor	x10, x12, x10
	mul	x10, x10, x8
	bne	x13, x11, .LBB0_197
# %bb.198:                              # %for.body.i15.preheader
	lw	x11, 0(x9)
	lw	x12, 4(x9)
	lw	x13, 8(x9)
	lw	x14, 12(x9)
	xor	x10, x11, x10
	mul	x10, x10, x8
	xor	x10, x12, x10
	mul	x10, x10, x8
	xor	x10, x13, x10
	mul	x10, x10, x8
	xor	x10, x14, x10
	lw	x11, 16(x9)
	lw	x12, 20(x9)
	lw	x13, 24(x9)
	lw	x14, 28(x9)
	mul	x10, x10, x8
	xor	x10, x11, x10
	mul	x10, x10, x8
	xor	x10, x12, x10
	mul	x10, x10, x8
	xor	x10, x13, x10
	lw	x11, 32(x9)
	mul	x10, x10, x8
	xor	x10, x14, x10
	lw	x12, 36(x9)
	mul	x10, x10, x8
	xor	x10, x11, x10
	mul	x10, x10, x8
	xor	x10, x12, x10
	mul	x8, x10, x8
	lui	x10, %hi(.L.str.3)
	addi	x10, x10, %lo(.L.str.3)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	lui	x13, 170287
	addi	x13, x13, 1822
	bne	x8, x13, .LBB0_200
# %bb.199:                              # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x10, 0
	j	.LBB0_201
.LBB0_200:                              # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	li	x10, 1
.LBB0_201:                              # %bench_report.exit
	lw	x1, 876(x2)                     # 4-byte Folded Reload
	lw	x8, 872(x2)                     # 4-byte Folded Reload
	lw	x9, 868(x2)                     # 4-byte Folded Reload
	lw	x18, 864(x2)                    # 4-byte Folded Reload
	lw	x19, 860(x2)                    # 4-byte Folded Reload
	lw	x20, 856(x2)                    # 4-byte Folded Reload
	lw	x21, 852(x2)                    # 4-byte Folded Reload
	lw	x22, 848(x2)                    # 4-byte Folded Reload
	lw	x23, 844(x2)                    # 4-byte Folded Reload
	lw	x24, 840(x2)                    # 4-byte Folded Reload
	lw	x25, 836(x2)                    # 4-byte Folded Reload
	lw	x26, 832(x2)                    # 4-byte Folded Reload
	lw	x27, 828(x2)                    # 4-byte Folded Reload
	addi	x2, x2, 880
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"resnet8: ResNet-8 forward pass (IMG=%dx%dx%d FILTERS=%d/%d/%d CLASSES=%d)\n"
	.size	.L.str, 75

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
