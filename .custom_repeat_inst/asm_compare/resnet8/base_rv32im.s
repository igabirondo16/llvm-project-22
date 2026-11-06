	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"resnet8_base.c"
	.option	push
	.option	arch, +m, +zmmul
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	x2, x2, -192
	sw	x1, 188(x2)                     # 4-byte Folded Spill
	sw	x8, 184(x2)                     # 4-byte Folded Spill
	sw	x9, 180(x2)                     # 4-byte Folded Spill
	sw	x18, 176(x2)                    # 4-byte Folded Spill
	sw	x19, 172(x2)                    # 4-byte Folded Spill
	sw	x20, 168(x2)                    # 4-byte Folded Spill
	sw	x21, 164(x2)                    # 4-byte Folded Spill
	sw	x22, 160(x2)                    # 4-byte Folded Spill
	sw	x23, 156(x2)                    # 4-byte Folded Spill
	sw	x24, 152(x2)                    # 4-byte Folded Spill
	sw	x25, 148(x2)                    # 4-byte Folded Spill
	sw	x26, 144(x2)                    # 4-byte Folded Spill
	sw	x27, 140(x2)                    # 4-byte Folded Spill
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
	lui	x19, %hi(.L_MergedGlobals)
	addi	x19, x19, %lo(.L_MergedGlobals)
	lui	x10, 4
	addi	x12, x19, 80
	addi	x13, x10, -127
	addi	x10, x19, 144
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
	addi	x12, x19, 208
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
	addi	x10, x19, 272
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
	addi	x12, x19, 400
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
	addi	x13, x19, 528
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
	addi	x10, x19, 656
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
	addi	x12, x19, 912
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
	addi	x10, x19, 1168
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
	addi	x16, x19, 1424
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
	sw	x16, 8(x2)                      # 4-byte Folded Spill
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
	li	x29, 0
	li	x10, 5
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
	sw	x13, 40(x19)
	sw	x16, 44(x19)
	sw	x17, 48(x19)
	sw	x5, 52(x19)
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
	slli	x10, x10, 9
	sw	x10, 48(x2)                     # 4-byte Folded Spill
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
	sw	x10, 56(x19)
	sw	x14, 60(x19)
	sw	x13, 64(x19)
	sw	x17, 68(x19)
	and	x15, x15, x11
	slli	x10, x12, 7
	sub	x12, x16, x12
	addi	x13, x15, -64
	sub	x12, x12, x10
	and	x11, x12, x11
	addi	x10, x11, -64
	sw	x13, 72(x19)
	sw	x10, 76(x19)
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
	lw	x10, 40(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 2047
	addi	x14, x10, 129
	lw	x29, 44(x2)                     # 4-byte Folded Reload
	li	x10, 32
	beq	x29, x10, .LBB0_50
.LBB0_44:                               # %for.cond3.preheader.i.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_46 Depth 2
                                        #       Child Loop BB0_48 Depth 3
	li	x28, 0
	lw	x13, 48(x2)                     # 4-byte Folded Reload
	addi	x10, x13, -384
	slli	x11, x29, 1
	slli	x12, x29, 5
	mul	x10, x29, x10
	add	x11, x12, x11
	sw	x11, 56(x2)                     # 4-byte Folded Spill
	add	x10, x13, x10
	addi	x10, x10, -256
	sw	x10, 52(x2)                     # 4-byte Folded Spill
	addi	x29, x29, 1
	sw	x29, 44(x2)                     # 4-byte Folded Spill
	sw	x14, 40(x2)                     # 4-byte Folded Spill
	mv	x29, x14
	j	.LBB0_46
.LBB0_45:                               # %for.cond3.loopexit.i.i
                                        #   in Loop: Header=BB0_46 Depth=2
	lw	x29, 60(x2)                     # 4-byte Folded Reload
	addi	x29, x29, 64
	lui	x19, %hi(.L_MergedGlobals)
	addi	x19, x19, %lo(.L_MergedGlobals)
	li	x10, 32
	lw	x28, 64(x2)                     # 4-byte Folded Reload
	beq	x28, x10, .LBB0_43
.LBB0_46:                               # %for.body6.i.i
                                        #   Parent Loop BB0_44 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_48 Depth 3
	slli	x10, x28, 6
	lw	x11, 56(x2)                     # 4-byte Folded Reload
	add	x11, x28, x11
	lw	x6, 52(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	slli	x10, x11, 2
	slli	x11, x11, 3
	add	x10, x11, x10
	lui	x16, %hi(image)
	addi	x16, x16, %lo(image)
	add	x16, x16, x10
	lw	x10, 408(x16)
	sw	x10, 136(x2)                    # 4-byte Folded Spill
	lw	x10, 412(x16)
	sw	x10, 132(x2)                    # 4-byte Folded Spill
	lw	x10, 416(x16)
	sw	x10, 128(x2)                    # 4-byte Folded Spill
	lw	x10, 420(x16)
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	lw	x10, 424(x16)
	sw	x10, 120(x2)                    # 4-byte Folded Spill
	lw	x10, 428(x16)
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	lw	x10, 432(x16)
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	lw	x10, 436(x16)
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	lw	x10, 0(x16)
	sw	x10, 104(x2)                    # 4-byte Folded Spill
	lw	x10, 4(x16)
	sw	x10, 100(x2)                    # 4-byte Folded Spill
	lw	x10, 8(x16)
	sw	x10, 96(x2)                     # 4-byte Folded Spill
	lw	x10, 12(x16)
	sw	x10, 92(x2)                     # 4-byte Folded Spill
	lw	x10, 16(x16)
	sw	x10, 88(x2)                     # 4-byte Folded Spill
	lw	x10, 20(x16)
	sw	x10, 84(x2)                     # 4-byte Folded Spill
	lw	x10, 24(x16)
	sw	x10, 80(x2)                     # 4-byte Folded Spill
	lw	x10, 28(x16)
	sw	x10, 76(x2)                     # 4-byte Folded Spill
	lw	x10, 32(x16)
	sw	x10, 72(x2)                     # 4-byte Folded Spill
	lw	x10, 440(x16)
	sw	x10, 68(x2)                     # 4-byte Folded Spill
	lw	x14, 816(x16)
	lw	x12, 820(x16)
	lw	x10, 824(x16)
	lw	x13, 828(x16)
	lw	x11, 832(x16)
	lw	x15, 836(x16)
	lw	x17, 840(x16)
	lw	x5, 844(x16)
	lw	x16, 848(x16)
	lui	x7, %hi(x1)
	addi	x7, x7, %lo(x1)
	add	x6, x7, x6
	addi	x28, x28, 1
	sw	x28, 64(x2)                     # 4-byte Folded Spill
	addi	x7, x19, 80
	lui	x28, %hi(w_conv1+52)
	addi	x28, x28, %lo(w_conv1+52)
	sw	x29, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_48
.LBB0_47:                               # %for.body21.i.i
                                        #   in Loop: Header=BB0_48 Depth=3
	sw	x30, 0(x29)
	addi	x29, x29, 4
	addi	x7, x7, 4
	addi	x28, x28, 108
	beq	x29, x6, .LBB0_45
.LBB0_48:                               # %for.body21.i.i
                                        #   Parent Loop BB0_44 Depth=1
                                        #     Parent Loop BB0_46 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x31, 0(x7)
	lw	x8, -52(x28)
	lw	x9, -48(x28)
	lw	x18, -44(x28)
	lw	x19, -40(x28)
	lw	x20, -36(x28)
	lw	x30, -32(x28)
	lw	x21, -28(x28)
	lw	x22, -24(x28)
	lw	x23, -12(x28)
	lw	x24, -8(x28)
	lw	x25, 8(x28)
	lw	x26, 104(x2)                    # 4-byte Folded Reload
	mul	x8, x8, x26
	lw	x26, 100(x2)                    # 4-byte Folded Reload
	mul	x9, x9, x26
	lw	x26, 96(x2)                     # 4-byte Folded Reload
	mul	x18, x18, x26
	add	x8, x8, x31
	add	x9, x9, x18
	lw	x18, 12(x28)
	lw	x26, 16(x28)
	lw	x27, 20(x28)
	lw	x31, 24(x28)
	lw	x1, 92(x2)                      # 4-byte Folded Reload
	mul	x19, x19, x1
	lw	x1, 88(x2)                      # 4-byte Folded Reload
	mul	x20, x20, x1
	lw	x1, 80(x2)                      # 4-byte Folded Reload
	mul	x21, x21, x1
	lw	x1, 76(x2)                      # 4-byte Folded Reload
	mul	x22, x22, x1
	lw	x1, 132(x2)                     # 4-byte Folded Reload
	mul	x23, x23, x1
	lw	x1, 128(x2)                     # 4-byte Folded Reload
	mul	x24, x24, x1
	add	x19, x19, x20
	add	x21, x21, x22
	add	x23, x23, x24
	lw	x20, 32(x28)
	lw	x22, 36(x28)
	lw	x24, 40(x28)
	lw	x1, 112(x2)                     # 4-byte Folded Reload
	mul	x25, x25, x1
	lw	x1, 108(x2)                     # 4-byte Folded Reload
	mul	x18, x18, x1
	mul	x20, x20, x13
	mul	x22, x22, x11
	add	x18, x25, x18
	add	x20, x20, x22
	lw	x22, -20(x28)
	lw	x25, -16(x28)
	add	x8, x8, x9
	lw	x9, -4(x28)
	lw	x1, 84(x2)                      # 4-byte Folded Reload
	mul	x30, x30, x1
	lw	x1, 72(x2)                      # 4-byte Folded Reload
	mul	x22, x22, x1
	add	x30, x19, x30
	add	x21, x21, x22
	lw	x19, 0(x28)
	lw	x22, 4(x28)
	lw	x1, 124(x2)                     # 4-byte Folded Reload
	mul	x9, x9, x1
	add	x9, x23, x9
	lw	x23, 68(x2)                     # 4-byte Folded Reload
	mul	x23, x26, x23
	add	x18, x18, x23
	mul	x23, x24, x15
	add	x20, x20, x23
	add	x30, x8, x30
	lw	x8, 136(x2)                     # 4-byte Folded Reload
	mul	x8, x25, x8
	add	x8, x21, x8
	lw	x21, 44(x28)
	lw	x23, 120(x2)                    # 4-byte Folded Reload
	mul	x19, x19, x23
	mul	x23, x27, x14
	add	x9, x9, x19
	add	x18, x18, x23
	lw	x19, 48(x28)
	lw	x23, 52(x28)
	mul	x21, x21, x17
	add	x20, x20, x21
	add	x30, x30, x8
	lw	x8, 116(x2)                     # 4-byte Folded Reload
	mul	x8, x22, x8
	add	x8, x9, x8
	mul	x31, x31, x12
	add	x31, x18, x31
	lw	x9, 28(x28)
	mul	x18, x19, x5
	add	x18, x20, x18
	add	x30, x30, x8
	mul	x8, x9, x10
	add	x31, x31, x8
	mul	x8, x23, x16
	add	x8, x18, x8
	add	x30, x30, x31
	add	x30, x30, x8
	srai	x30, x30, 3
	sgtz	x31, x30
	neg	x31, x31
	and	x30, x31, x30
	li	x31, 127
	blt	x30, x31, .LBB0_47
# %bb.49:                               # %for.body21.i.i
                                        #   in Loop: Header=BB0_48 Depth=3
	li	x30, 127
	j	.LBB0_47
.LBB0_50:                               # %conv.exit.i
	li	x11, 0
	#APP
	#NO_APP
	lui	x13, 65555
	li	x15, 1
	lui	x10, %hi(x1)
	addi	x10, x10, %lo(x1)
	addi	x10, x10, 32
	lui	x12, %hi(w_s1a)
	addi	x12, x12, %lo(w_s1a)
	sw	x15, 0(x13)
	#APP
	#NO_APP
	addi	x12, x12, 32
	sw	x12, 108(x2)                    # 4-byte Folded Spill
	j	.LBB0_52
.LBB0_51:                               # %for.cond.cleanup5.i110.i
                                        #   in Loop: Header=BB0_52 Depth=1
	lw	x10, 100(x2)                    # 4-byte Folded Reload
	addi	x11, x10, 2047
	addi	x10, x11, 129
	lw	x11, 104(x2)                    # 4-byte Folded Reload
	li	x12, 32
	beq	x11, x12, .LBB0_62
.LBB0_52:                               # %for.cond3.preheader.i55.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_54 Depth 2
                                        #       Child Loop BB0_56 Depth 3
                                        #         Child Loop BB0_57 Depth 4
                                        #           Child Loop BB0_58 Depth 5
	li	x12, 0
	addi	x11, x11, 1
	slli	x7, x11, 1
	sw	x11, 104(x2)                    # 4-byte Folded Spill
	slli	x13, x11, 5
	add	x13, x13, x7
	sw	x13, 112(x2)                    # 4-byte Folded Spill
	sw	x10, 100(x2)                    # 4-byte Folded Spill
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	j	.LBB0_54
.LBB0_53:                               # %for.cond3.loopexit.i108.i
                                        #   in Loop: Header=BB0_54 Depth=2
	lw	x10, 124(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 64
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	li	x10, 32
	lw	x12, 116(x2)                    # 4-byte Folded Reload
	beq	x12, x10, .LBB0_51
.LBB0_54:                               # %for.body6.i60.i
                                        #   Parent Loop BB0_52 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_56 Depth 3
                                        #         Child Loop BB0_57 Depth 4
                                        #           Child Loop BB0_58 Depth 5
	li	x11, 0
	addi	x12, x12, 1
	sw	x12, 116(x2)                    # 4-byte Folded Spill
	lw	x13, 112(x2)                    # 4-byte Folded Reload
	add	x13, x12, x13
	slli	x13, x13, 6
	lui	x10, %hi(a1)
	addi	x10, x10, %lo(a1)
	add	x10, x10, x13
	sw	x10, 120(x2)                    # 4-byte Folded Spill
	lw	x12, 108(x2)                    # 4-byte Folded Reload
	j	.LBB0_56
.LBB0_55:                               # %for.cond.cleanup26.i102.i
                                        #   in Loop: Header=BB0_56 Depth=3
	lw	x13, 120(x2)                    # 4-byte Folded Reload
	lw	x10, 128(x2)                    # 4-byte Folded Reload
	add	x13, x13, x10
	lw	x11, 136(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 1
	sw	x8, 0(x13)
	lw	x12, 132(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 576
	lui	x19, %hi(.L_MergedGlobals)
	addi	x19, x19, %lo(.L_MergedGlobals)
	li	x10, 16
	beq	x11, x10, .LBB0_53
.LBB0_56:                               # %for.body21.i68.i
                                        #   Parent Loop BB0_52 Depth=1
                                        #     Parent Loop BB0_54 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_57 Depth 4
                                        #           Child Loop BB0_58 Depth 5
	li	x8, 0
	slli	x9, x11, 6
	slli	x18, x11, 9
	sw	x11, 136(x2)                    # 4-byte Folded Spill
	slli	x11, x11, 2
	sw	x11, 128(x2)                    # 4-byte Folded Spill
	add	x19, x19, x11
	lw	x20, 144(x19)
	add	x9, x18, x9
	addi	x9, x9, 224
	lui	x10, %hi(w_s1a)
	addi	x10, x10, %lo(w_s1a)
	add	x9, x10, x9
	sw	x12, 132(x2)                    # 4-byte Folded Spill
	mv	x18, x12
	lw	x19, 124(x2)                    # 4-byte Folded Reload
.LBB0_57:                               # %for.cond28.preheader.i73.i
                                        #   Parent Loop BB0_52 Depth=1
                                        #     Parent Loop BB0_54 Depth=2
                                        #       Parent Loop BB0_56 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB0_58 Depth 5
	slli	x21, x8, 6
	slli	x22, x8, 7
	add	x21, x22, x21
	add	x21, x9, x21
	mv	x22, x18
	mv	x23, x19
.LBB0_58:                               # %for.body31.i78.i
                                        #   Parent Loop BB0_52 Depth=1
                                        #     Parent Loop BB0_54 Depth=2
                                        #       Parent Loop BB0_56 Depth=3
                                        #         Parent Loop BB0_57 Depth=4
                                        # =>        This Inner Loop Header: Depth=5
	lw	x24, -32(x22)
	lw	x25, -28(x22)
	lw	x26, -24(x22)
	lw	x27, -20(x22)
	lw	x1, -32(x23)
	lw	x10, -28(x23)
	lw	x11, -24(x23)
	lw	x12, -20(x23)
	lw	x15, -16(x22)
	lw	x5, -12(x22)
	lw	x7, -8(x22)
	lw	x6, -4(x22)
	lw	x14, -16(x23)
	lw	x17, -12(x23)
	lw	x30, -8(x23)
	lw	x28, -4(x23)
	lw	x13, 0(x22)
	lw	x31, 4(x22)
	lw	x29, 8(x22)
	lw	x16, 12(x22)
	mul	x24, x1, x24
	mul	x10, x10, x25
	mul	x11, x11, x26
	mul	x12, x12, x27
	lw	x25, 0(x23)
	lw	x26, 4(x23)
	lw	x27, 8(x23)
	lw	x1, 12(x23)
	mul	x14, x14, x15
	mul	x15, x17, x5
	mul	x17, x30, x7
	mul	x5, x28, x6
	lw	x6, 16(x22)
	lw	x7, 20(x22)
	lw	x28, 24(x22)
	lw	x30, 28(x22)
	mul	x13, x25, x13
	mul	x31, x26, x31
	mul	x29, x27, x29
	mul	x16, x1, x16
	lw	x25, 16(x23)
	lw	x26, 20(x23)
	lw	x27, 24(x23)
	lw	x1, 28(x23)
	mul	x6, x25, x6
	mul	x7, x26, x7
	mul	x28, x27, x28
	mul	x30, x1, x30
	add	x20, x24, x20
	add	x10, x10, x11
	add	x12, x12, x14
	add	x17, x17, x5
	add	x16, x29, x16
	add	x10, x20, x10
	add	x12, x12, x15
	add	x13, x17, x13
	add	x16, x16, x6
	add	x10, x10, x12
	add	x13, x13, x31
	add	x16, x16, x7
	add	x10, x10, x13
	addi	x22, x22, 64
	add	x16, x16, x28
	add	x10, x10, x16
	add	x20, x10, x30
	addi	x23, x23, 64
	bne	x22, x21, .LBB0_58
# %bb.59:                               # %for.cond.cleanup30.i99.i
                                        #   in Loop: Header=BB0_57 Depth=4
	addi	x8, x8, 1
	addi	x19, x19, 2047
	addi	x19, x19, 129
	addi	x18, x18, 192
	li	x10, 3
	bne	x8, x10, .LBB0_57
# %bb.60:                               # %for.cond.cleanup26.i102.i
                                        #   in Loop: Header=BB0_56 Depth=3
	srai	x8, x20, 4
	sgtz	x9, x8
	neg	x9, x9
	and	x8, x9, x8
	li	x9, 127
	blt	x8, x9, .LBB0_55
# %bb.61:                               # %for.cond.cleanup26.i102.i
                                        #   in Loop: Header=BB0_56 Depth=3
	li	x8, 127
	j	.LBB0_55
.LBB0_62:                               # %for.cond3.preheader.i113.i.preheader
	li	x10, 0
	lui	x11, %hi(a1)
	addi	x11, x11, %lo(a1)
	addi	x11, x11, 32
	lui	x12, %hi(w_s1b)
	addi	x12, x12, %lo(w_s1b)
	addi	x12, x12, 32
	sw	x12, 104(x2)                    # 4-byte Folded Spill
	j	.LBB0_64
.LBB0_63:                               # %for.cond.cleanup5.i168.i
                                        #   in Loop: Header=BB0_64 Depth=1
	lw	x10, 96(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 2047
	addi	x11, x10, 129
	lw	x10, 100(x2)                    # 4-byte Folded Reload
	li	x12, 32
	beq	x10, x12, .LBB0_74
.LBB0_64:                               # %for.cond3.preheader.i113.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_66 Depth 2
                                        #       Child Loop BB0_68 Depth 3
                                        #         Child Loop BB0_69 Depth 4
                                        #           Child Loop BB0_70 Depth 5
	li	x12, 0
	addi	x10, x10, 1
	slli	x7, x10, 1
	sw	x10, 100(x2)                    # 4-byte Folded Spill
	slli	x10, x10, 5
	add	x10, x10, x7
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	sw	x11, 96(x2)                     # 4-byte Folded Spill
	sw	x11, 124(x2)                    # 4-byte Folded Spill
	j	.LBB0_66
.LBB0_65:                               # %for.cond3.loopexit.i166.i
                                        #   in Loop: Header=BB0_66 Depth=2
	lw	x10, 124(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 64
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	li	x10, 32
	lw	x12, 112(x2)                    # 4-byte Folded Reload
	beq	x12, x10, .LBB0_63
.LBB0_66:                               # %for.body6.i118.i
                                        #   Parent Loop BB0_64 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_68 Depth 3
                                        #         Child Loop BB0_69 Depth 4
                                        #           Child Loop BB0_70 Depth 5
	li	x14, 0
	addi	x12, x12, 1
	sw	x12, 112(x2)                    # 4-byte Folded Spill
	lw	x10, 108(x2)                    # 4-byte Folded Reload
	add	x10, x12, x10
	slli	x10, x10, 6
	lui	x11, %hi(y1)
	addi	x11, x11, %lo(y1)
	add	x11, x11, x10
	sw	x11, 120(x2)                    # 4-byte Folded Spill
	lui	x11, %hi(x1)
	addi	x11, x11, %lo(x1)
	add	x10, x11, x10
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	lw	x11, 104(x2)                    # 4-byte Folded Reload
	j	.LBB0_68
.LBB0_67:                               # %for.cond.cleanup26.i160.i
                                        #   in Loop: Header=BB0_68 Depth=3
	lw	x13, 120(x2)                    # 4-byte Folded Reload
	add	x13, x13, x11
	lw	x14, 136(x2)                    # 4-byte Folded Reload
	addi	x14, x14, 1
	sw	x10, 0(x13)
	lw	x11, 132(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 576
	lui	x19, %hi(.L_MergedGlobals)
	addi	x19, x19, %lo(.L_MergedGlobals)
	li	x10, 16
	beq	x14, x10, .LBB0_65
.LBB0_68:                               # %for.body21.i126.i
                                        #   Parent Loop BB0_64 Depth=1
                                        #     Parent Loop BB0_66 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_69 Depth 4
                                        #           Child Loop BB0_70 Depth 5
	li	x9, 0
	slli	x10, x14, 6
	slli	x18, x14, 9
	sw	x14, 136(x2)                    # 4-byte Folded Spill
	slli	x14, x14, 2
	sw	x14, 128(x2)                    # 4-byte Folded Spill
	add	x19, x19, x14
	lw	x21, 208(x19)
	add	x10, x18, x10
	addi	x18, x10, 224
	lui	x10, %hi(w_s1b)
	addi	x10, x10, %lo(w_s1b)
	add	x18, x10, x18
	sw	x11, 132(x2)                    # 4-byte Folded Spill
	mv	x19, x11
	lw	x20, 124(x2)                    # 4-byte Folded Reload
.LBB0_69:                               # %for.cond28.preheader.i131.i
                                        #   Parent Loop BB0_64 Depth=1
                                        #     Parent Loop BB0_66 Depth=2
                                        #       Parent Loop BB0_68 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB0_70 Depth 5
	slli	x10, x9, 6
	slli	x22, x9, 7
	add	x10, x22, x10
	add	x22, x18, x10
	mv	x23, x19
	mv	x24, x20
.LBB0_70:                               # %for.body31.i136.i
                                        #   Parent Loop BB0_64 Depth=1
                                        #     Parent Loop BB0_66 Depth=2
                                        #       Parent Loop BB0_68 Depth=3
                                        #         Parent Loop BB0_69 Depth=4
                                        # =>        This Inner Loop Header: Depth=5
	lw	x10, -32(x23)
	lw	x25, -28(x23)
	lw	x26, -24(x23)
	lw	x27, -20(x23)
	lw	x1, -32(x24)
	lw	x11, -28(x24)
	lw	x12, -24(x24)
	lw	x17, -20(x24)
	lw	x5, -16(x23)
	lw	x7, -12(x23)
	lw	x6, -8(x23)
	lw	x14, -4(x23)
	lw	x16, -16(x24)
	lw	x30, -12(x24)
	lw	x31, -8(x24)
	lw	x28, -4(x24)
	lw	x13, 0(x23)
	lw	x8, 4(x23)
	lw	x29, 8(x23)
	lw	x15, 12(x23)
	mul	x10, x1, x10
	mul	x11, x11, x25
	mul	x12, x12, x26
	mul	x17, x17, x27
	lw	x25, 0(x24)
	lw	x26, 4(x24)
	lw	x27, 8(x24)
	lw	x1, 12(x24)
	mul	x16, x16, x5
	mul	x5, x30, x7
	mul	x6, x31, x6
	mul	x14, x28, x14
	lw	x7, 16(x23)
	lw	x28, 20(x23)
	lw	x30, 24(x23)
	lw	x31, 28(x23)
	mul	x13, x25, x13
	mul	x8, x26, x8
	mul	x29, x27, x29
	mul	x15, x1, x15
	lw	x25, 16(x24)
	lw	x26, 20(x24)
	lw	x27, 24(x24)
	lw	x1, 28(x24)
	mul	x7, x25, x7
	mul	x28, x26, x28
	mul	x30, x27, x30
	mul	x31, x1, x31
	add	x10, x10, x21
	add	x11, x11, x12
	add	x16, x17, x16
	add	x14, x6, x14
	add	x15, x29, x15
	add	x10, x10, x11
	add	x16, x16, x5
	add	x13, x14, x13
	add	x15, x15, x7
	add	x10, x10, x16
	add	x13, x13, x8
	add	x15, x15, x28
	add	x10, x10, x13
	addi	x23, x23, 64
	add	x15, x15, x30
	add	x10, x10, x15
	add	x21, x10, x31
	addi	x24, x24, 64
	bne	x23, x22, .LBB0_70
# %bb.71:                               # %for.cond.cleanup30.i157.i
                                        #   in Loop: Header=BB0_69 Depth=4
	addi	x9, x9, 1
	addi	x10, x20, 2047
	addi	x20, x10, 129
	addi	x19, x19, 192
	li	x10, 3
	bne	x9, x10, .LBB0_69
# %bb.72:                               # %for.cond.cleanup26.i160.i
                                        #   in Loop: Header=BB0_68 Depth=3
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	lw	x11, 128(x2)                    # 4-byte Folded Reload
	add	x10, x10, x11
	lw	x10, 0(x10)
	srai	x9, x21, 4
	add	x10, x10, x9
	sgtz	x9, x10
	neg	x9, x9
	and	x10, x9, x10
	li	x9, 127
	blt	x10, x9, .LBB0_67
# %bb.73:                               # %for.cond.cleanup26.i160.i
                                        #   in Loop: Header=BB0_68 Depth=3
	li	x10, 127
	j	.LBB0_67
.LBB0_74:                               # %conv.exit170.i
	li	x12, 0
	#APP
	#NO_APP
	lui	x10, 65555
	li	x15, 2
	lui	x11, %hi(y1)
	addi	x11, x11, %lo(y1)
	addi	x11, x11, 32
	lui	x13, %hi(w_s2a)
	addi	x13, x13, %lo(w_s2a)
	sw	x15, 0(x10)
	addi	x10, x13, 32
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	#APP
	#NO_APP
	li	x5, 17
	slli	x5, x5, 8
	sw	x5, 96(x2)                      # 4-byte Folded Spill
	j	.LBB0_76
.LBB0_75:                               # %for.cond.cleanup5.i226.i
                                        #   in Loop: Header=BB0_76 Depth=1
	lw	x11, 100(x2)                    # 4-byte Folded Reload
	lw	x10, 96(x2)                     # 4-byte Folded Reload
	add	x11, x11, x10
	lw	x12, 104(x2)                    # 4-byte Folded Reload
	li	x10, 16
	beq	x12, x10, .LBB0_86
.LBB0_76:                               # %for.cond3.preheader.i171.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_78 Depth 2
                                        #       Child Loop BB0_80 Depth 3
                                        #         Child Loop BB0_81 Depth 4
                                        #           Child Loop BB0_82 Depth 5
	li	x13, 0
	addi	x12, x12, 1
	slli	x7, x12, 1
	sw	x12, 104(x2)                    # 4-byte Folded Spill
	slli	x10, x12, 4
	add	x10, x10, x7
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	sw	x11, 100(x2)                    # 4-byte Folded Spill
	sw	x11, 124(x2)                    # 4-byte Folded Spill
	j	.LBB0_78
.LBB0_77:                               # %for.cond3.loopexit.i224.i
                                        #   in Loop: Header=BB0_78 Depth=2
	lw	x10, 124(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	li	x10, 16
	lw	x13, 116(x2)                    # 4-byte Folded Reload
	beq	x13, x10, .LBB0_75
.LBB0_78:                               # %for.body6.i176.i
                                        #   Parent Loop BB0_76 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_80 Depth 3
                                        #         Child Loop BB0_81 Depth 4
                                        #           Child Loop BB0_82 Depth 5
	li	x12, 0
	addi	x13, x13, 1
	sw	x13, 116(x2)                    # 4-byte Folded Spill
	lw	x10, 112(x2)                    # 4-byte Folded Reload
	add	x10, x13, x10
	slli	x10, x10, 7
	lui	x11, %hi(a2)
	addi	x11, x11, %lo(a2)
	add	x10, x11, x10
	sw	x10, 120(x2)                    # 4-byte Folded Spill
	lw	x11, 108(x2)                    # 4-byte Folded Reload
	j	.LBB0_80
.LBB0_79:                               # %for.cond.cleanup26.i218.i
                                        #   in Loop: Header=BB0_80 Depth=3
	lw	x8, 120(x2)                     # 4-byte Folded Reload
	lw	x11, 128(x2)                    # 4-byte Folded Reload
	add	x8, x8, x11
	lw	x12, 136(x2)                    # 4-byte Folded Reload
	addi	x12, x12, 1
	sw	x10, 0(x8)
	lw	x11, 132(x2)                    # 4-byte Folded Reload
	addi	x11, x11, 576
	lui	x19, %hi(.L_MergedGlobals)
	addi	x19, x19, %lo(.L_MergedGlobals)
	li	x10, 32
	beq	x12, x10, .LBB0_77
.LBB0_80:                               # %for.body21.i184.i
                                        #   Parent Loop BB0_76 Depth=1
                                        #     Parent Loop BB0_78 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_81 Depth 4
                                        #           Child Loop BB0_82 Depth 5
	li	x9, 0
	slli	x10, x12, 6
	slli	x18, x12, 9
	sw	x12, 136(x2)                    # 4-byte Folded Spill
	slli	x12, x12, 2
	sw	x12, 128(x2)                    # 4-byte Folded Spill
	add	x19, x19, x12
	lw	x21, 272(x19)
	add	x10, x18, x10
	addi	x18, x10, 224
	lui	x10, %hi(w_s2a)
	addi	x10, x10, %lo(w_s2a)
	add	x18, x10, x18
	sw	x11, 132(x2)                    # 4-byte Folded Spill
	mv	x19, x11
	lw	x20, 124(x2)                    # 4-byte Folded Reload
.LBB0_81:                               # %for.cond28.preheader.i189.i
                                        #   Parent Loop BB0_76 Depth=1
                                        #     Parent Loop BB0_78 Depth=2
                                        #       Parent Loop BB0_80 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB0_82 Depth 5
	slli	x10, x9, 6
	slli	x22, x9, 7
	add	x10, x22, x10
	add	x22, x18, x10
	mv	x23, x19
	mv	x24, x20
.LBB0_82:                               # %for.body31.i194.i
                                        #   Parent Loop BB0_76 Depth=1
                                        #     Parent Loop BB0_78 Depth=2
                                        #       Parent Loop BB0_80 Depth=3
                                        #         Parent Loop BB0_81 Depth=4
                                        # =>        This Inner Loop Header: Depth=5
	lw	x10, -32(x23)
	lw	x25, -28(x23)
	lw	x26, -24(x23)
	lw	x27, -20(x23)
	lw	x1, -32(x24)
	lw	x5, -28(x24)
	lw	x11, -24(x24)
	lw	x12, -20(x24)
	lw	x15, -16(x23)
	lw	x17, -12(x23)
	lw	x7, -8(x23)
	lw	x6, -4(x23)
	lw	x13, -16(x24)
	lw	x16, -12(x24)
	lw	x30, -8(x24)
	lw	x28, -4(x24)
	lw	x8, 0(x23)
	lw	x31, 4(x23)
	lw	x29, 8(x23)
	lw	x14, 12(x23)
	mul	x10, x1, x10
	mul	x5, x5, x25
	mul	x11, x11, x26
	mul	x12, x12, x27
	lw	x25, 0(x24)
	lw	x26, 4(x24)
	lw	x27, 8(x24)
	lw	x1, 12(x24)
	mul	x13, x13, x15
	mul	x15, x16, x17
	mul	x16, x30, x7
	mul	x17, x28, x6
	lw	x6, 16(x23)
	lw	x7, 20(x23)
	lw	x28, 24(x23)
	lw	x30, 28(x23)
	mul	x8, x25, x8
	mul	x31, x26, x31
	mul	x29, x27, x29
	mul	x14, x1, x14
	lw	x25, 16(x24)
	lw	x26, 20(x24)
	lw	x27, 24(x24)
	lw	x1, 28(x24)
	mul	x6, x25, x6
	mul	x7, x26, x7
	mul	x28, x27, x28
	mul	x30, x1, x30
	add	x10, x10, x21
	add	x11, x5, x11
	add	x12, x12, x13
	add	x16, x16, x17
	add	x14, x29, x14
	add	x10, x10, x11
	add	x12, x12, x15
	add	x16, x16, x8
	add	x14, x14, x6
	add	x10, x10, x12
	add	x16, x16, x31
	add	x14, x14, x7
	add	x10, x10, x16
	addi	x23, x23, 64
	add	x14, x14, x28
	add	x10, x10, x14
	add	x21, x10, x30
	addi	x24, x24, 64
	bne	x23, x22, .LBB0_82
# %bb.83:                               # %for.cond.cleanup30.i215.i
                                        #   in Loop: Header=BB0_81 Depth=4
	addi	x9, x9, 1
	addi	x10, x20, 2047
	addi	x20, x10, 129
	addi	x19, x19, 192
	li	x10, 3
	bne	x9, x10, .LBB0_81
# %bb.84:                               # %for.cond.cleanup26.i218.i
                                        #   in Loop: Header=BB0_80 Depth=3
	srai	x10, x21, 4
	sgtz	x9, x10
	neg	x9, x9
	and	x10, x9, x10
	li	x9, 127
	blt	x10, x9, .LBB0_79
# %bb.85:                               # %for.cond.cleanup26.i218.i
                                        #   in Loop: Header=BB0_80 Depth=3
	li	x10, 127
	j	.LBB0_79
.LBB0_86:                               # %for.cond3.preheader.i229.i.preheader
	li	x13, 0
	lui	x12, %hi(p2)
	addi	x12, x12, %lo(p2)
	li	x10, 9
	lw	x11, 48(x2)                     # 4-byte Folded Reload
	addi	x11, x11, -256
	sw	x11, 60(x2)                     # 4-byte Folded Spill
	addi	x11, x19, 528
	sw	x11, 112(x2)                    # 4-byte Folded Spill
	addi	x12, x12, 2047
	slli	x10, x10, 9
	addi	x7, x12, 385
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	addi	x10, x10, -256
	sw	x10, 100(x2)                    # 4-byte Folded Spill
	j	.LBB0_88
.LBB0_87:                               # %for.cond.cleanup5.i286.i
                                        #   in Loop: Header=BB0_88 Depth=1
	lw	x10, 104(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 2047
	addi	x7, x10, 257
	lw	x13, 108(x2)                    # 4-byte Folded Reload
	li	x10, 16
	beq	x13, x10, .LBB0_96
.LBB0_88:                               # %for.cond3.preheader.i229.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_90 Depth 2
                                        #       Child Loop BB0_92 Depth 3
	li	x14, 0
	lw	x11, 60(x2)                     # 4-byte Folded Reload
	mul	x5, x13, x11
	lw	x11, 100(x2)                    # 4-byte Folded Reload
	mul	x6, x13, x11
	addi	x10, x13, 1
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	lw	x10, 48(x2)                     # 4-byte Folded Reload
	add	x10, x5, x10
	sw	x10, 120(x2)                    # 4-byte Folded Spill
	lui	x10, %hi(y1)
	addi	x10, x10, %lo(y1)
	add	x10, x10, x6
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	sw	x7, 104(x2)                     # 4-byte Folded Spill
	j	.LBB0_90
.LBB0_89:                               # %for.cond3.loopexit.i284.i
                                        #   in Loop: Header=BB0_90 Depth=2
	lw	x7, 124(x2)                     # 4-byte Folded Reload
	addi	x7, x7, 128
	li	x10, 16
	lw	x14, 128(x2)                    # 4-byte Folded Reload
	beq	x14, x10, .LBB0_87
.LBB0_90:                               # %for.body6.i235.i
                                        #   Parent Loop BB0_88 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_92 Depth 3
	slli	x10, x14, 7
	lw	x12, 116(x2)                    # 4-byte Folded Reload
	add	x12, x12, x10
	addi	x12, x12, 2047
	lw	x11, 193(x12)
	sw	x11, 136(x2)                    # 4-byte Folded Spill
	lw	x11, 197(x12)
	sw	x11, 132(x2)                    # 4-byte Folded Spill
	lw	x30, 201(x12)
	lw	x31, 205(x12)
	lw	x8, 209(x12)
	lw	x9, 213(x12)
	lw	x18, 217(x12)
	lw	x19, 221(x12)
	lw	x20, 225(x12)
	lw	x21, 229(x12)
	lw	x22, 233(x12)
	lw	x23, 237(x12)
	lw	x24, 241(x12)
	lw	x25, 245(x12)
	lw	x26, 249(x12)
	lw	x27, 253(x12)
	lw	x11, 120(x2)                    # 4-byte Folded Reload
	add	x10, x11, x10
	lui	x1, %hi(p2)
	addi	x1, x1, %lo(p2)
	add	x1, x1, x10
	addi	x14, x14, 1
	sw	x14, 128(x2)                    # 4-byte Folded Spill
	lui	x13, %hi(w_s2p+32)
	addi	x13, x13, %lo(w_s2p+32)
	lw	x12, 112(x2)                    # 4-byte Folded Reload
	sw	x7, 124(x2)                     # 4-byte Folded Spill
	j	.LBB0_92
.LBB0_91:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_92 Depth=3
	sw	x10, 0(x7)
	addi	x7, x7, 4
	addi	x12, x12, 4
	addi	x13, x13, 64
	beq	x7, x1, .LBB0_89
.LBB0_92:                               # %for.body21.i244.i
                                        #   Parent Loop BB0_88 Depth=1
                                        #     Parent Loop BB0_90 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x10, 0(x12)
	lw	x11, -32(x13)
	lw	x14, -28(x13)
	lw	x16, -24(x13)
	lw	x5, -20(x13)
	lw	x6, -16(x13)
	lw	x17, -12(x13)
	lw	x15, -8(x13)
	lw	x28, -4(x13)
	lw	x29, 136(x2)                    # 4-byte Folded Reload
	mul	x11, x11, x29
	lw	x29, 132(x2)                    # 4-byte Folded Reload
	mul	x14, x14, x29
	mul	x16, x16, x30
	mul	x5, x5, x31
	mul	x6, x6, x8
	mul	x15, x15, x18
	mul	x28, x28, x19
	add	x10, x11, x10
	add	x14, x14, x16
	add	x5, x5, x6
	add	x15, x15, x28
	lw	x11, 0(x13)
	lw	x16, 4(x13)
	lw	x6, 8(x13)
	lw	x28, 12(x13)
	mul	x17, x17, x9
	mul	x11, x11, x20
	mul	x6, x6, x22
	mul	x28, x28, x23
	add	x6, x6, x28
	add	x10, x10, x14
	add	x17, x5, x17
	add	x11, x15, x11
	lw	x14, 16(x13)
	lw	x15, 20(x13)
	lw	x5, 24(x13)
	lw	x28, 28(x13)
	mul	x14, x14, x24
	add	x14, x6, x14
	add	x10, x10, x17
	mul	x16, x16, x21
	add	x11, x11, x16
	mul	x15, x15, x25
	add	x14, x14, x15
	add	x10, x10, x11
	mul	x11, x5, x26
	add	x11, x14, x11
	mul	x14, x28, x27
	add	x10, x10, x11
	add	x10, x10, x14
	srai	x10, x10, 3
	li	x11, -128
	blt	x11, x10, .LBB0_94
# %bb.93:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_92 Depth=3
	li	x10, -128
.LBB0_94:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_92 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_91
# %bb.95:                               # %for.body21.i244.i
                                        #   in Loop: Header=BB0_92 Depth=3
	li	x10, 127
	j	.LBB0_91
.LBB0_96:                               # %for.cond3.preheader.i289.i.preheader
	li	x15, 0
	li	x13, 9
	lui	x10, 1
	li	x11, 19
	lui	x14, %hi(a2)
	addi	x14, x14, %lo(a2)
	addi	x16, x14, 128
	addi	x17, x14, 256
	addi	x12, x14, 2047
	slli	x13, x13, 9
	addi	x10, x10, 640
	slli	x11, x11, 8
	addi	x5, x12, 257
	addi	x6, x12, 385
	addi	x7, x12, 513
	add	x28, x14, x13
	add	x29, x14, x10
	add	x30, x14, x11
	lui	x9, %hi(.L_MergedGlobals)
	addi	x9, x9, %lo(.L_MergedGlobals)
	j	.LBB0_98
.LBB0_97:                               # %for.cond.cleanup5.i350.i
                                        #   in Loop: Header=BB0_98 Depth=1
	li	x10, 9
	slli	x10, x10, 8
	lw	x14, 12(x2)                     # 4-byte Folded Reload
	add	x14, x14, x10
	lw	x16, 44(x2)                     # 4-byte Folded Reload
	add	x16, x16, x10
	lw	x17, 40(x2)                     # 4-byte Folded Reload
	add	x17, x17, x10
	lw	x5, 36(x2)                      # 4-byte Folded Reload
	add	x5, x5, x10
	lw	x6, 32(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x7, 28(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x28, 24(x2)                     # 4-byte Folded Reload
	add	x28, x28, x10
	lw	x29, 20(x2)                     # 4-byte Folded Reload
	add	x29, x29, x10
	lw	x30, 16(x2)                     # 4-byte Folded Reload
	add	x30, x30, x10
	lw	x15, 52(x2)                     # 4-byte Folded Reload
	li	x10, 16
	beq	x15, x10, .LBB0_122
.LBB0_98:                               # %for.cond3.preheader.i289.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_100 Depth 2
                                        #       Child Loop BB0_102 Depth 3
                                        #         Child Loop BB0_103 Depth 4
                                        #         Child Loop BB0_105 Depth 4
                                        #         Child Loop BB0_107 Depth 4
                                        #         Child Loop BB0_109 Depth 4
                                        #         Child Loop BB0_111 Depth 4
                                        #         Child Loop BB0_113 Depth 4
                                        #         Child Loop BB0_115 Depth 4
                                        #         Child Loop BB0_117 Depth 4
                                        #         Child Loop BB0_119 Depth 4
	li	x31, 0
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	mul	x10, x15, x10
	addi	x15, x15, 1
	addi	x8, x10, 384
	addi	x18, x10, 256
	addi	x19, x10, 128
	lw	x12, 48(x2)                     # 4-byte Folded Reload
	add	x20, x10, x12
	slli	x10, x15, 1
	sw	x15, 52(x2)                     # 4-byte Folded Spill
	slli	x11, x15, 4
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	sw	x8, 100(x2)                     # 4-byte Folded Spill
	add	x8, x8, x13
	sw	x8, 84(x2)                      # 4-byte Folded Spill
	sw	x18, 96(x2)                     # 4-byte Folded Spill
	add	x18, x18, x13
	sw	x18, 80(x2)                     # 4-byte Folded Spill
	add	x13, x19, x13
	sw	x13, 76(x2)                     # 4-byte Folded Spill
	sw	x19, 92(x2)                     # 4-byte Folded Spill
	add	x12, x19, x12
	sw	x12, 72(x2)                     # 4-byte Folded Spill
	sw	x20, 88(x2)                     # 4-byte Folded Spill
	addi	x12, x20, -128
	sw	x12, 68(x2)                     # 4-byte Folded Spill
	add	x10, x11, x10
	sw	x10, 64(x2)                     # 4-byte Folded Spill
	sw	x30, 16(x2)                     # 4-byte Folded Spill
	sw	x30, 136(x2)                    # 4-byte Folded Spill
	sw	x29, 20(x2)                     # 4-byte Folded Spill
	sw	x29, 132(x2)                    # 4-byte Folded Spill
	sw	x28, 24(x2)                     # 4-byte Folded Spill
	sw	x28, 128(x2)                    # 4-byte Folded Spill
	sw	x7, 28(x2)                      # 4-byte Folded Spill
	sw	x7, 124(x2)                     # 4-byte Folded Spill
	sw	x6, 32(x2)                      # 4-byte Folded Spill
	sw	x6, 120(x2)                     # 4-byte Folded Spill
	sw	x5, 36(x2)                      # 4-byte Folded Spill
	sw	x5, 116(x2)                     # 4-byte Folded Spill
	sw	x17, 40(x2)                     # 4-byte Folded Spill
	sw	x17, 112(x2)                    # 4-byte Folded Spill
	sw	x16, 44(x2)                     # 4-byte Folded Spill
	sw	x16, 108(x2)                    # 4-byte Folded Spill
	sw	x14, 12(x2)                     # 4-byte Folded Spill
	mv	x30, x14
	j	.LBB0_100
.LBB0_99:                               # %for.cond3.loopexit.i348.i
                                        #   in Loop: Header=BB0_100 Depth=2
	addi	x30, x30, 128
	lw	x10, 108(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	lw	x10, 112(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	lw	x10, 120(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 120(x2)                    # 4-byte Folded Spill
	lw	x10, 124(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	lw	x10, 128(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 128(x2)                    # 4-byte Folded Spill
	lw	x10, 132(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 132(x2)                    # 4-byte Folded Spill
	lw	x10, 136(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 128
	sw	x10, 136(x2)                    # 4-byte Folded Spill
	li	x10, 16
	lw	x31, 104(x2)                    # 4-byte Folded Reload
	beq	x31, x10, .LBB0_97
.LBB0_100:                              # %for.body6.i297.i
                                        #   Parent Loop BB0_98 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_102 Depth 3
                                        #         Child Loop BB0_103 Depth 4
                                        #         Child Loop BB0_105 Depth 4
                                        #         Child Loop BB0_107 Depth 4
                                        #         Child Loop BB0_109 Depth 4
                                        #         Child Loop BB0_111 Depth 4
                                        #         Child Loop BB0_113 Depth 4
                                        #         Child Loop BB0_115 Depth 4
                                        #         Child Loop BB0_117 Depth 4
                                        #         Child Loop BB0_119 Depth 4
	li	x17, 0
	slli	x13, x31, 7
	addi	x31, x31, 1
	lui	x7, %hi(w_s2b)
	addi	x7, x7, %lo(w_s2b)
	addi	x21, x7, 128
	addi	x10, x7, 256
	addi	x15, x7, 384
	addi	x1, x7, 512
	addi	x12, x7, 640
	addi	x11, x7, 768
	addi	x5, x7, 896
	lw	x14, 84(x2)                     # 4-byte Folded Reload
	add	x14, x14, x13
	lw	x16, 80(x2)                     # 4-byte Folded Reload
	add	x16, x16, x13
	lw	x24, 76(x2)                     # 4-byte Folded Reload
	add	x24, x24, x13
	lw	x25, 72(x2)                     # 4-byte Folded Reload
	add	x25, x25, x13
	lw	x27, 88(x2)                     # 4-byte Folded Reload
	add	x27, x27, x13
	lw	x26, 68(x2)                     # 4-byte Folded Reload
	add	x26, x26, x13
	lw	x28, 100(x2)                    # 4-byte Folded Reload
	add	x28, x28, x13
	lw	x29, 96(x2)                     # 4-byte Folded Reload
	add	x29, x29, x13
	lw	x23, 92(x2)                     # 4-byte Folded Reload
	add	x23, x23, x13
	sw	x31, 104(x2)                    # 4-byte Folded Spill
	lw	x13, 64(x2)                     # 4-byte Folded Reload
	add	x31, x31, x13
	lui	x6, %hi(a2)
	addi	x6, x6, %lo(a2)
	add	x13, x6, x14
	add	x16, x6, x16
	add	x24, x6, x24
	add	x25, x6, x25
	add	x27, x6, x27
	add	x26, x6, x26
	add	x14, x6, x28
	add	x28, x6, x29
	add	x23, x6, x23
	slli	x29, x31, 7
	lui	x8, %hi(y2)
	addi	x8, x8, %lo(y2)
	add	x8, x8, x29
	lui	x6, %hi(p2)
	addi	x6, x6, %lo(p2)
	add	x29, x6, x29
	addi	x20, x7, 1024
	mv	x31, x7
	j	.LBB0_102
.LBB0_101:                              # %for.cond.cleanup42.i334.2.i.2
                                        #   in Loop: Header=BB0_102 Depth=3
	add	x18, x8, x18
	addi	x17, x17, 1
	addi	x31, x31, 1152
	addi	x21, x21, 1152
	addi	x10, x10, 1152
	addi	x15, x15, 1152
	addi	x1, x1, 1152
	addi	x12, x12, 1152
	addi	x11, x11, 1152
	addi	x5, x5, 1152
	sw	x9, 0(x18)
	addi	x20, x20, 1152
	lui	x9, %hi(.L_MergedGlobals)
	addi	x9, x9, %lo(.L_MergedGlobals)
	li	x6, 32
	beq	x17, x6, .LBB0_99
.LBB0_102:                              # %for.body21.i306.i
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_103 Depth 4
                                        #         Child Loop BB0_105 Depth 4
                                        #         Child Loop BB0_107 Depth 4
                                        #         Child Loop BB0_109 Depth 4
                                        #         Child Loop BB0_111 Depth 4
                                        #         Child Loop BB0_113 Depth 4
                                        #         Child Loop BB0_115 Depth 4
                                        #         Child Loop BB0_117 Depth 4
                                        #         Child Loop BB0_119 Depth 4
	slli	x18, x17, 2
	add	x9, x9, x18
	lw	x9, 400(x9)
	mv	x19, x31
	mv	x22, x30
.LBB0_103:                              # %for.body43.i325.i
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x23, .LBB0_103
# %bb.104:                              # %for.cond.cleanup42.i334.i
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x21
	lw	x22, 108(x2)                    # 4-byte Folded Reload
.LBB0_105:                              # %for.body43.i325.1.i
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x7, 0(x19)
	lw	x6, 0(x22)
	addi	x22, x22, 4
	mul	x6, x6, x7
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x28, .LBB0_105
# %bb.106:                              # %for.cond.cleanup42.i334.1.i
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x10
	lw	x22, 112(x2)                    # 4-byte Folded Reload
.LBB0_107:                              # %for.body43.i325.2.i
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x14, .LBB0_107
# %bb.108:                              # %for.cond.cleanup42.i334.2.i
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x15
	lw	x22, 116(x2)                    # 4-byte Folded Reload
.LBB0_109:                              # %for.body43.i325.i.1
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x26, .LBB0_109
# %bb.110:                              # %for.cond.cleanup42.i334.i.1
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x1
	lw	x22, 120(x2)                    # 4-byte Folded Reload
.LBB0_111:                              # %for.body43.i325.1.i.1
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x27, .LBB0_111
# %bb.112:                              # %for.cond.cleanup42.i334.1.i.1
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x12
	lw	x22, 124(x2)                    # 4-byte Folded Reload
.LBB0_113:                              # %for.body43.i325.2.i.1
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x25, .LBB0_113
# %bb.114:                              # %for.cond.cleanup42.i334.2.i.1
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x11
	lw	x22, 128(x2)                    # 4-byte Folded Reload
.LBB0_115:                              # %for.body43.i325.i.2
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x24, .LBB0_115
# %bb.116:                              # %for.cond.cleanup42.i334.i.2
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x5
	lw	x22, 132(x2)                    # 4-byte Folded Reload
.LBB0_117:                              # %for.body43.i325.1.i.2
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x16, .LBB0_117
# %bb.118:                              # %for.cond.cleanup42.i334.1.i.2
                                        #   in Loop: Header=BB0_102 Depth=3
	mv	x19, x20
	lw	x22, 136(x2)                    # 4-byte Folded Reload
.LBB0_119:                              # %for.body43.i325.2.i.2
                                        #   Parent Loop BB0_98 Depth=1
                                        #     Parent Loop BB0_100 Depth=2
                                        #       Parent Loop BB0_102 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x19)
	lw	x7, 0(x22)
	addi	x22, x22, 4
	mul	x6, x7, x6
	add	x9, x6, x9
	addi	x19, x19, 4
	bne	x22, x13, .LBB0_119
# %bb.120:                              # %for.cond.cleanup42.i334.2.i.2
                                        #   in Loop: Header=BB0_102 Depth=3
	add	x6, x29, x18
	lw	x6, 0(x6)
	srai	x9, x9, 4
	add	x6, x6, x9
	sgtz	x7, x6
	neg	x7, x7
	and	x9, x7, x6
	li	x6, 127
	blt	x9, x6, .LBB0_101
# %bb.121:                              # %for.cond.cleanup42.i334.2.i.2
                                        #   in Loop: Header=BB0_102 Depth=3
	li	x9, 127
	j	.LBB0_101
.LBB0_122:                              # %conv.exit352.i
	li	x17, 0
	#APP
	#NO_APP
	lui	x10, 65555
	li	x11, 3
	li	x12, 9
	lui	x13, 1
	li	x14, 19
	lui	x31, %hi(y2)
	addi	x31, x31, %lo(y2)
	addi	x5, x31, 128
	addi	x6, x31, 256
	addi	x15, x31, 2047
	sw	x11, 0(x10)
	slli	x12, x12, 9
	addi	x10, x13, 640
	slli	x14, x14, 8
	addi	x7, x15, 257
	addi	x28, x15, 385
	addi	x15, x15, 513
	sw	x12, 16(x2)                     # 4-byte Folded Spill
	add	x29, x31, x12
	add	x30, x31, x10
	add	x14, x31, x14
	#APP
	#NO_APP
	j	.LBB0_124
.LBB0_123:                              # %for.cond.cleanup5.i412.i
                                        #   in Loop: Header=BB0_124 Depth=1
	lw	x10, 16(x2)                     # 4-byte Folded Reload
	lw	x31, 20(x2)                     # 4-byte Folded Reload
	add	x31, x31, x10
	lw	x5, 60(x2)                      # 4-byte Folded Reload
	add	x5, x5, x10
	lw	x6, 52(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x7, 44(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x28, 40(x2)                     # 4-byte Folded Reload
	add	x28, x28, x10
	lw	x15, 36(x2)                     # 4-byte Folded Reload
	add	x15, x15, x10
	lw	x29, 32(x2)                     # 4-byte Folded Reload
	add	x29, x29, x10
	lw	x30, 28(x2)                     # 4-byte Folded Reload
	add	x30, x30, x10
	lw	x14, 24(x2)                     # 4-byte Folded Reload
	add	x14, x14, x10
	lw	x17, 64(x2)                     # 4-byte Folded Reload
	li	x10, 8
	beq	x17, x10, .LBB0_148
.LBB0_124:                              # %for.cond3.preheader.i353.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_126 Depth 2
                                        #       Child Loop BB0_128 Depth 3
                                        #         Child Loop BB0_129 Depth 4
                                        #         Child Loop BB0_131 Depth 4
                                        #         Child Loop BB0_133 Depth 4
                                        #         Child Loop BB0_135 Depth 4
                                        #         Child Loop BB0_137 Depth 4
                                        #         Child Loop BB0_139 Depth 4
                                        #         Child Loop BB0_141 Depth 4
                                        #         Child Loop BB0_143 Depth 4
                                        #         Child Loop BB0_145 Depth 4
	li	x18, 0
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	mul	x10, x17, x13
	addi	x17, x17, 1
	addi	x16, x10, 384
	addi	x8, x10, 256
	addi	x9, x10, 128
	lw	x12, 48(x2)                     # 4-byte Folded Reload
	add	x19, x10, x12
	slli	x10, x17, 1
	sw	x17, 64(x2)                     # 4-byte Folded Spill
	slli	x11, x17, 3
	sw	x16, 104(x2)                    # 4-byte Folded Spill
	add	x16, x16, x13
	sw	x16, 88(x2)                     # 4-byte Folded Spill
	sw	x8, 100(x2)                     # 4-byte Folded Spill
	add	x8, x8, x13
	sw	x8, 84(x2)                      # 4-byte Folded Spill
	add	x13, x9, x13
	sw	x13, 80(x2)                     # 4-byte Folded Spill
	sw	x9, 96(x2)                      # 4-byte Folded Spill
	add	x12, x9, x12
	sw	x12, 76(x2)                     # 4-byte Folded Spill
	sw	x19, 92(x2)                     # 4-byte Folded Spill
	addi	x12, x19, -128
	sw	x12, 72(x2)                     # 4-byte Folded Spill
	add	x10, x11, x10
	sw	x10, 68(x2)                     # 4-byte Folded Spill
	sw	x14, 24(x2)                     # 4-byte Folded Spill
	sw	x14, 136(x2)                    # 4-byte Folded Spill
	sw	x30, 28(x2)                     # 4-byte Folded Spill
	sw	x30, 132(x2)                    # 4-byte Folded Spill
	sw	x29, 32(x2)                     # 4-byte Folded Spill
	sw	x29, 128(x2)                    # 4-byte Folded Spill
	sw	x15, 36(x2)                     # 4-byte Folded Spill
	sw	x15, 124(x2)                    # 4-byte Folded Spill
	sw	x28, 40(x2)                     # 4-byte Folded Spill
	sw	x28, 120(x2)                    # 4-byte Folded Spill
	sw	x7, 44(x2)                      # 4-byte Folded Spill
	sw	x7, 116(x2)                     # 4-byte Folded Spill
	sw	x6, 52(x2)                      # 4-byte Folded Spill
	sw	x6, 112(x2)                     # 4-byte Folded Spill
	sw	x5, 60(x2)                      # 4-byte Folded Spill
	mv	x16, x5
	sw	x31, 20(x2)                     # 4-byte Folded Spill
	mv	x7, x31
	j	.LBB0_126
.LBB0_125:                              # %for.cond3.loopexit.i410.i
                                        #   in Loop: Header=BB0_126 Depth=2
	addi	x7, x7, 256
	addi	x16, x16, 256
	lw	x10, 112(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	lw	x10, 120(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 120(x2)                    # 4-byte Folded Spill
	lw	x10, 124(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	lw	x10, 128(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 128(x2)                    # 4-byte Folded Spill
	lw	x10, 132(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 132(x2)                    # 4-byte Folded Spill
	lw	x10, 136(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 136(x2)                    # 4-byte Folded Spill
	li	x10, 8
	lw	x18, 108(x2)                    # 4-byte Folded Reload
	beq	x18, x10, .LBB0_123
.LBB0_126:                              # %for.body6.i361.i
                                        #   Parent Loop BB0_124 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_128 Depth 3
                                        #         Child Loop BB0_129 Depth 4
                                        #         Child Loop BB0_131 Depth 4
                                        #         Child Loop BB0_133 Depth 4
                                        #         Child Loop BB0_135 Depth 4
                                        #         Child Loop BB0_137 Depth 4
                                        #         Child Loop BB0_139 Depth 4
                                        #         Child Loop BB0_141 Depth 4
                                        #         Child Loop BB0_143 Depth 4
                                        #         Child Loop BB0_145 Depth 4
	li	x15, 0
	slli	x11, x18, 8
	addi	x18, x18, 1
	lui	x6, %hi(w_s3a)
	addi	x6, x6, %lo(w_s3a)
	addi	x5, x6, 128
	addi	x19, x6, 256
	addi	x27, x6, 384
	addi	x10, x6, 512
	addi	x24, x6, 640
	addi	x25, x6, 768
	addi	x26, x6, 896
	lw	x13, 88(x2)                     # 4-byte Folded Reload
	add	x13, x13, x11
	lw	x14, 84(x2)                     # 4-byte Folded Reload
	add	x14, x14, x11
	lw	x1, 80(x2)                      # 4-byte Folded Reload
	add	x1, x1, x11
	lw	x22, 76(x2)                     # 4-byte Folded Reload
	add	x22, x22, x11
	lw	x8, 92(x2)                      # 4-byte Folded Reload
	add	x8, x8, x11
	lw	x12, 72(x2)                     # 4-byte Folded Reload
	add	x12, x12, x11
	lw	x23, 104(x2)                    # 4-byte Folded Reload
	add	x23, x23, x11
	lw	x28, 100(x2)                    # 4-byte Folded Reload
	add	x28, x28, x11
	lw	x9, 96(x2)                      # 4-byte Folded Reload
	add	x9, x9, x11
	sw	x18, 108(x2)                    # 4-byte Folded Spill
	lw	x29, 68(x2)                     # 4-byte Folded Reload
	add	x29, x18, x29
	lui	x17, %hi(y2)
	addi	x17, x17, %lo(y2)
	add	x13, x17, x13
	add	x14, x17, x14
	add	x1, x17, x1
	add	x22, x17, x22
	add	x8, x17, x8
	add	x12, x17, x12
	add	x23, x17, x23
	add	x11, x17, x28
	add	x9, x17, x9
	slli	x29, x29, 8
	lui	x21, %hi(a3)
	addi	x21, x21, %lo(a3)
	add	x21, x21, x29
	addi	x18, x6, 1024
	mv	x28, x6
	j	.LBB0_128
.LBB0_127:                              # %for.cond.cleanup42.i398.2.i.2
                                        #   in Loop: Header=BB0_128 Depth=3
	add	x30, x21, x30
	addi	x15, x15, 1
	addi	x28, x28, 1152
	addi	x5, x5, 1152
	addi	x19, x19, 1152
	addi	x27, x27, 1152
	addi	x10, x10, 1152
	addi	x24, x24, 1152
	addi	x25, x25, 1152
	addi	x26, x26, 1152
	sw	x29, 0(x30)
	addi	x18, x18, 1152
	li	x17, 64
	beq	x15, x17, .LBB0_125
.LBB0_128:                              # %for.body21.i370.i
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_129 Depth 4
                                        #         Child Loop BB0_131 Depth 4
                                        #         Child Loop BB0_133 Depth 4
                                        #         Child Loop BB0_135 Depth 4
                                        #         Child Loop BB0_137 Depth 4
                                        #         Child Loop BB0_139 Depth 4
                                        #         Child Loop BB0_141 Depth 4
                                        #         Child Loop BB0_143 Depth 4
                                        #         Child Loop BB0_145 Depth 4
	slli	x30, x15, 2
	lui	x29, %hi(.L_MergedGlobals)
	addi	x29, x29, %lo(.L_MergedGlobals)
	add	x29, x29, x30
	lw	x29, 656(x29)
	mv	x31, x28
	mv	x20, x7
.LBB0_129:                              # %for.body43.i389.i
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x9, .LBB0_129
# %bb.130:                              # %for.cond.cleanup42.i398.i
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x5
	mv	x20, x16
.LBB0_131:                              # %for.body43.i389.1.i
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x6, 0(x31)
	lw	x17, 0(x20)
	addi	x20, x20, 4
	mul	x17, x17, x6
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x11, .LBB0_131
# %bb.132:                              # %for.cond.cleanup42.i398.1.i
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x19
	lw	x20, 112(x2)                    # 4-byte Folded Reload
.LBB0_133:                              # %for.body43.i389.2.i
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x23, .LBB0_133
# %bb.134:                              # %for.cond.cleanup42.i398.2.i
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x27
	lw	x20, 116(x2)                    # 4-byte Folded Reload
.LBB0_135:                              # %for.body43.i389.i.1
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x12, .LBB0_135
# %bb.136:                              # %for.cond.cleanup42.i398.i.1
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x10
	lw	x20, 120(x2)                    # 4-byte Folded Reload
.LBB0_137:                              # %for.body43.i389.1.i.1
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x8, .LBB0_137
# %bb.138:                              # %for.cond.cleanup42.i398.1.i.1
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x24
	lw	x20, 124(x2)                    # 4-byte Folded Reload
.LBB0_139:                              # %for.body43.i389.2.i.1
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x22, .LBB0_139
# %bb.140:                              # %for.cond.cleanup42.i398.2.i.1
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x25
	lw	x20, 128(x2)                    # 4-byte Folded Reload
.LBB0_141:                              # %for.body43.i389.i.2
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x1, .LBB0_141
# %bb.142:                              # %for.cond.cleanup42.i398.i.2
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x26
	lw	x20, 132(x2)                    # 4-byte Folded Reload
.LBB0_143:                              # %for.body43.i389.1.i.2
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x14, .LBB0_143
# %bb.144:                              # %for.cond.cleanup42.i398.1.i.2
                                        #   in Loop: Header=BB0_128 Depth=3
	mv	x31, x18
	lw	x20, 136(x2)                    # 4-byte Folded Reload
.LBB0_145:                              # %for.body43.i389.2.i.2
                                        #   Parent Loop BB0_124 Depth=1
                                        #     Parent Loop BB0_126 Depth=2
                                        #       Parent Loop BB0_128 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x31)
	lw	x6, 0(x20)
	addi	x20, x20, 4
	mul	x17, x6, x17
	add	x29, x17, x29
	addi	x31, x31, 4
	bne	x20, x13, .LBB0_145
# %bb.146:                              # %for.cond.cleanup42.i398.2.i.2
                                        #   in Loop: Header=BB0_128 Depth=3
	srai	x17, x29, 4
	sgtz	x6, x17
	neg	x6, x6
	and	x29, x6, x17
	li	x17, 127
	blt	x29, x17, .LBB0_127
# %bb.147:                              # %for.cond.cleanup42.i398.2.i.2
                                        #   in Loop: Header=BB0_128 Depth=3
	li	x29, 127
	j	.LBB0_127
.LBB0_148:                              # %for.cond3.preheader.i415.i.preheader
	li	x10, 0
	lui	x11, %hi(y2)
	addi	x11, x11, %lo(y2)
	lui	x12, %hi(w_s3p)
	addi	x12, x12, %lo(w_s3p)
	li	x13, 64
	li	x14, 8
	li	x16, 9
	addi	x15, x11, 2047
	addi	x15, x15, 385
	slli	x16, x16, 9
	lui	x22, %hi(.L_MergedGlobals)
	addi	x22, x22, %lo(.L_MergedGlobals)
	j	.LBB0_150
.LBB0_149:                              # %for.cond.cleanup5.i474.i
                                        #   in Loop: Header=BB0_150 Depth=1
	add	x15, x15, x16
	beq	x10, x14, .LBB0_160
.LBB0_150:                              # %for.cond3.preheader.i415.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_152 Depth 2
                                        #       Child Loop BB0_154 Depth 3
                                        #         Child Loop BB0_155 Depth 4
	li	x17, 0
	lw	x5, 56(x2)                      # 4-byte Folded Reload
	mul	x5, x10, x5
	addi	x10, x10, 1
	lw	x6, 48(x2)                      # 4-byte Folded Reload
	add	x5, x5, x6
	slli	x6, x10, 1
	slli	x7, x10, 3
	add	x6, x7, x6
	mv	x7, x15
	j	.LBB0_152
.LBB0_151:                              # %for.cond3.loopexit.i472.i
                                        #   in Loop: Header=BB0_152 Depth=2
	addi	x7, x7, 256
	beq	x17, x14, .LBB0_149
.LBB0_152:                              # %for.body6.i423.i
                                        #   Parent Loop BB0_150 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_154 Depth 3
                                        #         Child Loop BB0_155 Depth 4
	li	x28, 0
	slli	x29, x17, 8
	addi	x17, x17, 1
	add	x29, x5, x29
	add	x30, x17, x6
	add	x29, x11, x29
	slli	x30, x30, 8
	lui	x31, %hi(p3)
	addi	x31, x31, %lo(p3)
	add	x30, x31, x30
	mv	x31, x12
	j	.LBB0_154
.LBB0_153:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_154 Depth=3
	add	x8, x30, x8
	addi	x28, x28, 1
	sw	x9, 0(x8)
	addi	x31, x31, 128
	beq	x28, x13, .LBB0_151
.LBB0_154:                              # %for.body21.i432.i
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_155 Depth 4
	slli	x8, x28, 2
	add	x9, x22, x8
	lw	x9, 1168(x9)
	mv	x18, x31
	mv	x19, x7
.LBB0_155:                              # %for.body43.i451.i
                                        #   Parent Loop BB0_150 Depth=1
                                        #     Parent Loop BB0_152 Depth=2
                                        #       Parent Loop BB0_154 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x20, 0(x18)
	lw	x21, 0(x19)
	addi	x19, x19, 4
	mul	x20, x21, x20
	add	x9, x20, x9
	addi	x18, x18, 4
	bne	x19, x29, .LBB0_155
# %bb.156:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_154 Depth=3
	srai	x9, x9, 3
	li	x18, -128
	blt	x18, x9, .LBB0_158
# %bb.157:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_154 Depth=3
	li	x9, -128
.LBB0_158:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_154 Depth=3
	li	x18, 127
	blt	x9, x18, .LBB0_153
# %bb.159:                              # %for.cond.cleanup42.i460.i
                                        #   in Loop: Header=BB0_154 Depth=3
	li	x9, 127
	j	.LBB0_153
.LBB0_160:                              # %for.cond3.preheader.i477.i.preheader
	li	x15, 0
	li	x13, 5
	li	x10, 21
	li	x11, 11
	lui	x8, %hi(a3)
	addi	x8, x8, %lo(a3)
	addi	x16, x8, 256
	addi	x17, x8, 512
	addi	x12, x8, 2047
	lui	x18, %hi(y3)
	addi	x18, x18, %lo(y3)
	li	x28, 9
	slli	x13, x13, 10
	slli	x10, x10, 8
	slli	x11, x11, 9
	addi	x5, x12, 513
	addi	x6, x12, 769
	addi	x7, x12, 1025
	slli	x28, x28, 8
	add	x29, x8, x13
	add	x30, x8, x10
	add	x31, x8, x11
	j	.LBB0_162
.LBB0_161:                              # %for.cond.cleanup5.i538.i
                                        #   in Loop: Header=BB0_162 Depth=1
	li	x10, 5
	slli	x10, x10, 9
	lw	x8, 12(x2)                      # 4-byte Folded Reload
	add	x8, x8, x10
	lw	x16, 44(x2)                     # 4-byte Folded Reload
	add	x16, x16, x10
	lw	x17, 40(x2)                     # 4-byte Folded Reload
	add	x17, x17, x10
	lw	x5, 36(x2)                      # 4-byte Folded Reload
	add	x5, x5, x10
	lw	x6, 32(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x7, 28(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x29, 24(x2)                     # 4-byte Folded Reload
	add	x29, x29, x10
	lw	x30, 20(x2)                     # 4-byte Folded Reload
	add	x30, x30, x10
	lw	x31, 16(x2)                     # 4-byte Folded Reload
	add	x31, x31, x10
	lw	x15, 52(x2)                     # 4-byte Folded Reload
	li	x10, 8
	beq	x15, x10, .LBB0_186
.LBB0_162:                              # %for.cond3.preheader.i477.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_164 Depth 2
                                        #       Child Loop BB0_166 Depth 3
                                        #         Child Loop BB0_167 Depth 4
                                        #         Child Loop BB0_169 Depth 4
                                        #         Child Loop BB0_171 Depth 4
                                        #         Child Loop BB0_173 Depth 4
                                        #         Child Loop BB0_175 Depth 4
                                        #         Child Loop BB0_177 Depth 4
                                        #         Child Loop BB0_179 Depth 4
                                        #         Child Loop BB0_181 Depth 4
                                        #         Child Loop BB0_183 Depth 4
	li	x19, 0
	lw	x13, 48(x2)                     # 4-byte Folded Reload
	mul	x10, x15, x13
	addi	x15, x15, 1
	lw	x14, 56(x2)                     # 4-byte Folded Reload
	add	x11, x14, x10
	addi	x9, x10, 768
	addi	x20, x10, 512
	addi	x21, x10, 256
	slli	x10, x15, 1
	sw	x15, 52(x2)                     # 4-byte Folded Spill
	slli	x12, x15, 3
	addi	x15, x11, 1280
	sw	x15, 84(x2)                     # 4-byte Folded Spill
	addi	x11, x11, 1024
	sw	x11, 80(x2)                     # 4-byte Folded Spill
	add	x14, x9, x14
	sw	x14, 76(x2)                     # 4-byte Folded Spill
	sw	x9, 96(x2)                      # 4-byte Folded Spill
	add	x9, x9, x13
	sw	x9, 72(x2)                      # 4-byte Folded Spill
	sw	x20, 92(x2)                     # 4-byte Folded Spill
	add	x20, x20, x13
	sw	x20, 68(x2)                     # 4-byte Folded Spill
	sw	x21, 88(x2)                     # 4-byte Folded Spill
	add	x13, x21, x13
	sw	x13, 64(x2)                     # 4-byte Folded Spill
	add	x10, x12, x10
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	sw	x31, 16(x2)                     # 4-byte Folded Spill
	sw	x31, 136(x2)                    # 4-byte Folded Spill
	sw	x30, 20(x2)                     # 4-byte Folded Spill
	sw	x30, 132(x2)                    # 4-byte Folded Spill
	sw	x29, 24(x2)                     # 4-byte Folded Spill
	sw	x29, 128(x2)                    # 4-byte Folded Spill
	sw	x7, 28(x2)                      # 4-byte Folded Spill
	sw	x7, 124(x2)                     # 4-byte Folded Spill
	sw	x6, 32(x2)                      # 4-byte Folded Spill
	sw	x6, 120(x2)                     # 4-byte Folded Spill
	sw	x5, 36(x2)                      # 4-byte Folded Spill
	sw	x5, 116(x2)                     # 4-byte Folded Spill
	sw	x17, 40(x2)                     # 4-byte Folded Spill
	sw	x17, 112(x2)                    # 4-byte Folded Spill
	sw	x16, 44(x2)                     # 4-byte Folded Spill
	sw	x16, 108(x2)                    # 4-byte Folded Spill
	sw	x8, 12(x2)                      # 4-byte Folded Spill
	sw	x8, 104(x2)                     # 4-byte Folded Spill
	j	.LBB0_164
.LBB0_163:                              # %for.cond3.loopexit.i536.i
                                        #   in Loop: Header=BB0_164 Depth=2
	lw	x10, 104(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 104(x2)                    # 4-byte Folded Spill
	lw	x10, 108(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 108(x2)                    # 4-byte Folded Spill
	lw	x10, 112(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 112(x2)                    # 4-byte Folded Spill
	lw	x10, 116(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 116(x2)                    # 4-byte Folded Spill
	lw	x10, 120(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 120(x2)                    # 4-byte Folded Spill
	lw	x10, 124(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 124(x2)                    # 4-byte Folded Spill
	lw	x10, 128(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 128(x2)                    # 4-byte Folded Spill
	lw	x10, 132(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 132(x2)                    # 4-byte Folded Spill
	lw	x10, 136(x2)                    # 4-byte Folded Reload
	addi	x10, x10, 256
	sw	x10, 136(x2)                    # 4-byte Folded Spill
	lui	x18, %hi(y3)
	addi	x18, x18, %lo(y3)
	li	x10, 8
	lw	x19, 100(x2)                    # 4-byte Folded Reload
	beq	x19, x10, .LBB0_161
.LBB0_164:                              # %for.body6.i485.i
                                        #   Parent Loop BB0_162 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_166 Depth 3
                                        #         Child Loop BB0_167 Depth 4
                                        #         Child Loop BB0_169 Depth 4
                                        #         Child Loop BB0_171 Depth 4
                                        #         Child Loop BB0_173 Depth 4
                                        #         Child Loop BB0_175 Depth 4
                                        #         Child Loop BB0_177 Depth 4
                                        #         Child Loop BB0_179 Depth 4
                                        #         Child Loop BB0_181 Depth 4
                                        #         Child Loop BB0_183 Depth 4
	li	x21, 0
	slli	x10, x19, 8
	addi	x19, x19, 1
	lui	x5, %hi(w_s3b)
	addi	x5, x5, %lo(w_s3b)
	addi	x31, x5, 256
	addi	x9, x5, 512
	addi	x14, x5, 768
	addi	x27, x5, 1024
	addi	x1, x5, 1280
	addi	x12, x5, 1536
	addi	x11, x5, 1792
	addi	x16, x5, 2047
	lw	x13, 84(x2)                     # 4-byte Folded Reload
	add	x13, x13, x10
	lw	x15, 80(x2)                     # 4-byte Folded Reload
	add	x15, x15, x10
	lw	x6, 76(x2)                      # 4-byte Folded Reload
	add	x6, x6, x10
	lw	x25, 72(x2)                     # 4-byte Folded Reload
	add	x25, x25, x10
	lw	x26, 68(x2)                     # 4-byte Folded Reload
	add	x26, x26, x10
	lw	x24, 64(x2)                     # 4-byte Folded Reload
	add	x24, x24, x10
	lw	x7, 96(x2)                      # 4-byte Folded Reload
	add	x7, x7, x10
	lw	x23, 92(x2)                     # 4-byte Folded Reload
	add	x23, x23, x10
	lw	x8, 88(x2)                      # 4-byte Folded Reload
	add	x8, x8, x10
	sw	x19, 100(x2)                    # 4-byte Folded Spill
	lw	x29, 60(x2)                     # 4-byte Folded Reload
	add	x29, x19, x29
	lui	x17, %hi(a3)
	addi	x17, x17, %lo(a3)
	add	x13, x17, x13
	add	x10, x17, x15
	add	x15, x17, x6
	add	x25, x17, x25
	add	x26, x17, x26
	add	x24, x17, x24
	add	x6, x17, x7
	add	x23, x17, x23
	add	x8, x17, x8
	slli	x29, x29, 8
	add	x7, x18, x29
	lui	x20, %hi(p3)
	addi	x20, x20, %lo(p3)
	add	x20, x20, x29
	addi	x16, x16, 1
	mv	x18, x5
	j	.LBB0_166
.LBB0_165:                              # %for.cond.cleanup42.i522.2.i.2
                                        #   in Loop: Header=BB0_166 Depth=3
	add	x30, x7, x30
	addi	x21, x21, 1
	add	x18, x18, x28
	add	x31, x31, x28
	add	x9, x9, x28
	add	x14, x14, x28
	add	x27, x27, x28
	add	x1, x1, x28
	add	x12, x12, x28
	add	x11, x11, x28
	sw	x29, 0(x30)
	add	x16, x16, x28
	lui	x22, %hi(.L_MergedGlobals)
	addi	x22, x22, %lo(.L_MergedGlobals)
	li	x17, 64
	beq	x21, x17, .LBB0_163
.LBB0_166:                              # %for.body21.i494.i
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_167 Depth 4
                                        #         Child Loop BB0_169 Depth 4
                                        #         Child Loop BB0_171 Depth 4
                                        #         Child Loop BB0_173 Depth 4
                                        #         Child Loop BB0_175 Depth 4
                                        #         Child Loop BB0_177 Depth 4
                                        #         Child Loop BB0_179 Depth 4
                                        #         Child Loop BB0_181 Depth 4
                                        #         Child Loop BB0_183 Depth 4
	slli	x30, x21, 2
	add	x29, x22, x30
	lw	x29, 912(x29)
	mv	x19, x18
	lw	x22, 104(x2)                    # 4-byte Folded Reload
.LBB0_167:                              # %for.body43.i513.i
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x8, .LBB0_167
# %bb.168:                              # %for.cond.cleanup42.i522.i
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x31
	lw	x22, 108(x2)                    # 4-byte Folded Reload
.LBB0_169:                              # %for.body43.i513.1.i
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x23, .LBB0_169
# %bb.170:                              # %for.cond.cleanup42.i522.1.i
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x9
	lw	x22, 112(x2)                    # 4-byte Folded Reload
.LBB0_171:                              # %for.body43.i513.2.i
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x6, .LBB0_171
# %bb.172:                              # %for.cond.cleanup42.i522.2.i
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x14
	lw	x22, 116(x2)                    # 4-byte Folded Reload
.LBB0_173:                              # %for.body43.i513.i.1
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x24, .LBB0_173
# %bb.174:                              # %for.cond.cleanup42.i522.i.1
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x27
	lw	x22, 120(x2)                    # 4-byte Folded Reload
.LBB0_175:                              # %for.body43.i513.1.i.1
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x26, .LBB0_175
# %bb.176:                              # %for.cond.cleanup42.i522.1.i.1
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x1
	lw	x22, 124(x2)                    # 4-byte Folded Reload
.LBB0_177:                              # %for.body43.i513.2.i.1
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x25, .LBB0_177
# %bb.178:                              # %for.cond.cleanup42.i522.2.i.1
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x12
	lw	x22, 128(x2)                    # 4-byte Folded Reload
.LBB0_179:                              # %for.body43.i513.i.2
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x15, .LBB0_179
# %bb.180:                              # %for.cond.cleanup42.i522.i.2
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x11
	lw	x22, 132(x2)                    # 4-byte Folded Reload
.LBB0_181:                              # %for.body43.i513.1.i.2
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x10, .LBB0_181
# %bb.182:                              # %for.cond.cleanup42.i522.1.i.2
                                        #   in Loop: Header=BB0_166 Depth=3
	mv	x19, x16
	lw	x22, 136(x2)                    # 4-byte Folded Reload
.LBB0_183:                              # %for.body43.i513.2.i.2
                                        #   Parent Loop BB0_162 Depth=1
                                        #     Parent Loop BB0_164 Depth=2
                                        #       Parent Loop BB0_166 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x17, 0(x19)
	lw	x5, 0(x22)
	addi	x22, x22, 4
	mul	x17, x5, x17
	add	x29, x17, x29
	addi	x19, x19, 4
	bne	x22, x13, .LBB0_183
# %bb.184:                              # %for.cond.cleanup42.i522.2.i.2
                                        #   in Loop: Header=BB0_166 Depth=3
	add	x17, x20, x30
	lw	x17, 0(x17)
	srai	x5, x29, 5
	add	x17, x17, x5
	sgtz	x5, x17
	neg	x5, x5
	and	x29, x5, x17
	li	x17, 127
	blt	x29, x17, .LBB0_165
# %bb.185:                              # %for.cond.cleanup42.i522.2.i.2
                                        #   in Loop: Header=BB0_166 Depth=3
	li	x29, 127
	j	.LBB0_165
.LBB0_186:                              # %conv.exit540.i
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
	addi	x16, x14, 768
	lui	x17, 4
	lui	x5, 5
	li	x6, 256
.LBB0_187:                              # %for.cond1.preheader.i9
                                        # =>This Inner Loop Header: Depth=1
	add	x7, x18, x10
	addi	x18, x7, 2047
	lui	x9, 1
	add	x9, x7, x9
	lui	x28, 2
	add	x28, x7, x28
	add	x29, x7, x15
	add	x31, x7, x16
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
	add	x18, x20, x18
	add	x23, x23, x24
	lw	x29, -512(x29)
	lw	x31, 0(x31)
	add	x12, x12, x28
	lw	x28, -768(x30)
	add	x29, x19, x29
	lw	x19, -2048(x8)
	add	x31, x22, x31
	lui	x20, %hi(.L_MergedGlobals)
	addi	x20, x20, %lo(.L_MergedGlobals)
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
	lui	x18, %hi(y3)
	addi	x18, x18, %lo(y3)
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
	add	x28, x20, x10
	add	x11, x11, x29
	add	x12, x7, x12
	add	x11, x11, x12
	srai	x12, x11, 31
	srli	x12, x12, 26
	add	x11, x11, x12
	srai	x11, x11, 6
	addi	x10, x10, 4
	sw	x11, 1424(x28)
	bne	x10, x6, .LBB0_187
# %bb.188:                              # %for.body21.i.preheader
	li	x10, 0
	lui	x11, %hi(w_fc)
	addi	x11, x11, %lo(w_fc)
	addi	x12, x20, 1680
	li	x13, 10
	lw	x7, 8(x2)                       # 4-byte Folded Reload
.LBB0_189:                              # %for.body21.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_190 Depth 2
	slli	x14, x10, 2
	add	x14, x20, x14
	lw	x15, 40(x14)
	mv	x16, x11
	mv	x17, x7
.LBB0_190:                              # %for.body27.i
                                        #   Parent Loop BB0_189 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x5, 0(x16)
	lw	x6, 0(x17)
	addi	x17, x17, 4
	mul	x5, x6, x5
	add	x15, x5, x15
	addi	x16, x16, 4
	bne	x17, x12, .LBB0_190
# %bb.191:                              # %for.cond.cleanup26.i
                                        #   in Loop: Header=BB0_189 Depth=1
	sw	x15, 0(x14)
	addi	x10, x10, 1
	addi	x11, x11, 256
	bne	x10, x13, .LBB0_189
# %bb.192:                              # %resnet8.exit
	#APP
	#NO_APP
	lui	x10, 65555
	li	x11, 5
	sw	x11, 0(x10)
	#APP
	#NO_APP
	lw	x10, 0(x20)
	lw	x11, 4(x20)
	lw	x12, 8(x20)
	slt	x11, x10, x11
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_194
# %bb.193:                              # %resnet8.exit
	li	x11, 2
.LBB0_194:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x12, 12(x20)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_196
# %bb.195:                              # %resnet8.exit
	li	x11, 3
.LBB0_196:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x12, 16(x20)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_198
# %bb.197:                              # %resnet8.exit
	li	x11, 4
.LBB0_198:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x12, 20(x20)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_200
# %bb.199:                              # %resnet8.exit
	li	x11, 5
.LBB0_200:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x12, 24(x20)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_202
# %bb.201:                              # %resnet8.exit
	li	x11, 6
.LBB0_202:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x12, 28(x20)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_204
# %bb.203:                              # %resnet8.exit
	li	x11, 7
.LBB0_204:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x12, 32(x20)
	lw	x10, 0(x10)
	bge	x10, x12, .LBB0_206
# %bb.205:                              # %resnet8.exit
	li	x11, 8
.LBB0_206:                              # %resnet8.exit
	slli	x10, x11, 2
	add	x10, x20, x10
	lw	x12, 36(x20)
	lw	x13, 0(x10)
	lui	x10, 4096
	bge	x13, x12, .LBB0_208
# %bb.207:                              # %resnet8.exit
	li	x11, 9
.LBB0_208:                              # %resnet8.exit
	addi	x8, x10, 403
	lui	x10, %hi(.L.str.1)
	addi	x10, x10, %lo(.L.str.1)
	call	printf
	lui	x10, 528842
	li	x11, 25
	addi	x10, x10, -571
	slli	x11, x11, 10
	add	x11, x18, x11
.LBB0_209:                              # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	lw	x12, 0(x18)
	addi	x18, x18, 4
	xor	x10, x12, x10
	mul	x10, x10, x8
	bne	x18, x11, .LBB0_209
# %bb.210:                              # %for.body.i15.preheader
	lw	x11, 0(x20)
	lw	x12, 4(x20)
	lw	x13, 8(x20)
	lw	x14, 12(x20)
	xor	x10, x11, x10
	mul	x10, x10, x8
	xor	x10, x12, x10
	mul	x10, x10, x8
	xor	x10, x13, x10
	mul	x10, x10, x8
	xor	x10, x14, x10
	lw	x11, 16(x20)
	lw	x12, 20(x20)
	lw	x13, 24(x20)
	lw	x14, 28(x20)
	mul	x10, x10, x8
	xor	x10, x11, x10
	mul	x10, x10, x8
	xor	x10, x12, x10
	mul	x10, x10, x8
	xor	x10, x13, x10
	lw	x11, 32(x20)
	mul	x10, x10, x8
	xor	x10, x14, x10
	lw	x12, 36(x20)
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
	bne	x8, x13, .LBB0_212
# %bb.211:                              # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x10, 0
	j	.LBB0_213
.LBB0_212:                              # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	li	x10, 1
.LBB0_213:                              # %bench_report.exit
	lw	x1, 188(x2)                     # 4-byte Folded Reload
	lw	x8, 184(x2)                     # 4-byte Folded Reload
	lw	x9, 180(x2)                     # 4-byte Folded Reload
	lw	x18, 176(x2)                    # 4-byte Folded Reload
	lw	x19, 172(x2)                    # 4-byte Folded Reload
	lw	x20, 168(x2)                    # 4-byte Folded Reload
	lw	x21, 164(x2)                    # 4-byte Folded Reload
	lw	x22, 160(x2)                    # 4-byte Folded Reload
	lw	x23, 156(x2)                    # 4-byte Folded Reload
	lw	x24, 152(x2)                    # 4-byte Folded Reload
	lw	x25, 148(x2)                    # 4-byte Folded Reload
	lw	x26, 144(x2)                    # 4-byte Folded Reload
	lw	x27, 140(x2)                    # 4-byte Folded Reload
	addi	x2, x2, 192
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
