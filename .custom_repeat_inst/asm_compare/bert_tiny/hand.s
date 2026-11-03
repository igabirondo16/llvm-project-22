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
	addi	x2, x2, -256
	sw	x1, 252(x2)                     # 4-byte Folded Spill
	sw	x8, 248(x2)                     # 4-byte Folded Spill
	sw	x9, 244(x2)                     # 4-byte Folded Spill
	sw	x18, 240(x2)                    # 4-byte Folded Spill
	sw	x19, 236(x2)                    # 4-byte Folded Spill
	sw	x20, 232(x2)                    # 4-byte Folded Spill
	sw	x21, 228(x2)                    # 4-byte Folded Spill
	sw	x22, 224(x2)                    # 4-byte Folded Spill
	sw	x23, 220(x2)                    # 4-byte Folded Spill
	sw	x24, 216(x2)                    # 4-byte Folded Spill
	sw	x25, 212(x2)                    # 4-byte Folded Spill
	sw	x26, 208(x2)                    # 4-byte Folded Spill
	sw	x27, 204(x2)                    # 4-byte Folded Spill
	lui	x10, 247535
	lui	x11, 406
	addi	x8, x10, 863
	addi	x9, x11, 1549
	lui	x10, %hi(.L.str)
	addi	x10, x10, %lo(.L.str)
	li	x11, 32
	li	x12, 128
	li	x13, 2
	li	x14, 512
	li	x15, 2
	li	x16, 2
	call	printf
	lui	x10, %hi(lcg_state)
	lui	x11, %hi(tok_emb)
	addi	x11, x11, %lo(tok_emb)
	lui	x13, 5
	li	x12, 97
	lw	x10, %lo(lcg_state)(x10)
	addi	x13, x13, 465
	lui	x14, 16
	addi	x14, x14, -1
	lui	x15, 128
	add	x15, x11, x15
.LBB0_1:                                # %for.body.i.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x16, x10, 16
	mul	x17, x16, x13
	srli	x17, x17, 16
	sub	x5, x16, x17
	slli	x5, x5, 16
	srli	x5, x5, 17
	add	x17, x5, x17
	srli	x17, x17, 6
	mul	x17, x17, x12
	sub	x16, x16, x17
	and	x16, x16, x14
	addi	x16, x16, -48
	sw	x16, 0(x11)
	addi	x11, x11, 4
	bne	x11, x15, .LBB0_1
# %bb.2:                                # %for.body.i44.i.preheader
	lui	x11, %hi(pos_emb)
	addi	x11, x11, %lo(pos_emb)
	lui	x12, 16
	lui	x13, 4
	addi	x12, x12, -1985
	add	x13, x11, x13
.LBB0_3:                                # %for.body.i44.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x12
	srli	x15, x15, 21
	slli	x16, x15, 5
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -16
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x13, .LBB0_3
# %bb.4:                                # %for.body.i59.i.preheader
	lui	x13, %hi(.L_MergedGlobals)
	addi	x13, x13, %lo(.L_MergedGlobals)
	lui	x12, 15
	addi	x11, x13, 144
	addi	x12, x12, 241
	addi	x13, x13, 656
.LBB0_5:                                # %for.body.i59.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x12
	srli	x15, x15, 20
	slli	x16, x15, 4
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -8
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x13, .LBB0_5
# %bb.6:                                # %for.body.i74.i.preheader
	lui	x14, %hi(.L_MergedGlobals)
	addi	x14, x14, %lo(.L_MergedGlobals)
	addi	x11, x14, 1168
	lui	x12, 14
	lui	x13, 16
	addi	x12, x12, 911
	addi	x13, x13, -1
	addi	x14, x14, 1680
.LBB0_7:                                # %for.body.i74.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x15, x10, 16
	mul	x10, x10, x9
	mul	x16, x15, x12
	add	x10, x10, x8
	srli	x16, x16, 19
	srli	x17, x10, 16
	sub	x15, x15, x16
	slli	x16, x16, 3
	sub	x15, x15, x16
	mul	x16, x17, x12
	srli	x16, x16, 19
	addi	x15, x15, 28
	sub	x17, x17, x16
	slli	x16, x16, 3
	and	x15, x15, x13
	sub	x16, x17, x16
	sw	x15, -512(x11)
	and	x15, x16, x13
	addi	x15, x15, -4
	sw	x15, 0(x11)
	addi	x11, x11, 4
	bne	x11, x14, .LBB0_7
# %bb.8:                                # %init_norm.exit.i
	li	x23, 0
	lui	x11, 194
	lui	x7, %hi(lcg_state)
	li	x13, 1
	lui	x12, 16
	lui	x28, 13
	lui	x29, 1
	lui	x14, 32
	lui	x15, 48
	lui	x18, 64
	lui	x16, 65
	lui	x20, 14
	lui	x17, 129
	lui	x5, 193
	addi	x6, x11, -1536
	sw	x10, %lo(lcg_state)(x7)
	addi	x7, x28, -819
	addi	x28, x12, 512
	addi	x29, x29, -63
	addi	x30, x14, 512
	addi	x31, x15, 1024
	addi	x18, x18, 1536
	addi	x19, x16, -2048
	addi	x20, x20, 911
	addi	x21, x17, -1024
	addi	x22, x5, 1024
.LBB0_9:                                # %for.body.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_10 Depth 2
                                        #     Child Loop BB0_12 Depth 2
                                        #     Child Loop BB0_14 Depth 2
                                        #     Child Loop BB0_16 Depth 2
                                        #     Child Loop BB0_18 Depth 2
                                        #     Child Loop BB0_20 Depth 2
                                        #     Child Loop BB0_22 Depth 2
                                        #     Child Loop BB0_24 Depth 2
                                        #     Child Loop BB0_26 Depth 2
                                        #     Child Loop BB0_28 Depth 2
                                        #     Child Loop BB0_30 Depth 2
                                        #     Child Loop BB0_32 Depth 2
                                        #     Child Loop BB0_34 Depth 2
                                        #     Child Loop BB0_36 Depth 2
	mul	x24, x23, x6
	lui	x11, %hi(layers)
	addi	x11, x11, %lo(layers)
	add	x23, x11, x24
	add	x24, x11, x24
	add	x25, x24, x12
	mv	x26, x23
.LBB0_10:                               # %for.body.i144.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x27, x10, 16
	mul	x1, x27, x7
	srli	x1, x1, 18
	slli	x11, x1, 2
	sub	x27, x27, x1
	sub	x11, x27, x11
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -2
	sw	x11, 0(x26)
	addi	x26, x26, 4
	bne	x26, x25, .LBB0_10
# %bb.11:                               # %fill.exit157.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x23, x12
	add	x26, x24, x28
.LBB0_12:                               # %for.body.i159.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x27, x11, x29
	srli	x27, x27, 18
	slli	x1, x27, 6
	sub	x11, x11, x27
	sub	x11, x11, x1
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -32
	sw	x11, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_12
# %bb.13:                               # %fill.exit172.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x23, x28
	add	x26, x24, x30
.LBB0_14:                               # %for.body.i174.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x27, x11, x7
	srli	x27, x27, 18
	slli	x1, x27, 2
	sub	x11, x11, x27
	sub	x11, x11, x1
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -2
	sw	x11, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_14
# %bb.15:                               # %fill.exit187.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x26, x23, x30
	lui	x25, 32
	addi	x25, x25, 1024
	add	x27, x24, x25
.LBB0_16:                               # %for.body.i189.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x1, x11, x29
	srli	x1, x1, 18
	slli	x14, x1, 6
	sub	x11, x11, x1
	sub	x11, x11, x14
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -32
	sw	x11, 0(x26)
	addi	x26, x26, 4
	bne	x26, x27, .LBB0_16
# %bb.17:                               # %fill.exit202.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x23, x25
	add	x26, x24, x31
.LBB0_18:                               # %for.body.i204.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x7
	srli	x14, x14, 18
	slli	x27, x14, 2
	sub	x11, x11, x14
	sub	x11, x11, x27
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -2
	sw	x11, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_18
# %bb.19:                               # %fill.exit217.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x26, x23, x31
	lui	x25, 48
	addi	x25, x25, 1536
	add	x27, x24, x25
.LBB0_20:                               # %for.body.i219.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x29
	srli	x14, x14, 18
	slli	x1, x14, 6
	sub	x11, x11, x14
	sub	x11, x11, x1
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -32
	sw	x11, 0(x26)
	addi	x26, x26, 4
	bne	x26, x27, .LBB0_20
# %bb.21:                               # %fill.exit232.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x23, x25
	add	x26, x24, x18
.LBB0_22:                               # %for.body.i234.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x7
	srli	x14, x14, 18
	slli	x27, x14, 2
	sub	x11, x11, x14
	sub	x11, x11, x27
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -2
	sw	x11, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_22
# %bb.23:                               # %fill.exit247.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x23, x18
	add	x26, x24, x19
.LBB0_24:                               # %for.body.i249.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x29
	srli	x14, x14, 18
	slli	x27, x14, 6
	sub	x11, x11, x14
	sub	x11, x11, x27
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -32
	sw	x11, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_24
# %bb.25:                               # %fill.exit262.i
                                        #   in Loop: Header=BB0_9 Depth=1
	addi	x27, x16, -1536
	addi	x26, x16, -1024
	add	x27, x23, x27
	add	x1, x24, x26
.LBB0_26:                               # %for.body.i264.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	addi	x25, x12, -1
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x10, x10, x9
	mul	x14, x11, x20
	add	x10, x10, x8
	srli	x14, x14, 19
	srli	x15, x10, 16
	sub	x11, x11, x14
	slli	x14, x14, 3
	sub	x11, x11, x14
	mul	x14, x15, x20
	srli	x14, x14, 19
	addi	x11, x11, 28
	sub	x15, x15, x14
	slli	x14, x14, 3
	and	x11, x11, x25
	sub	x15, x15, x14
	sw	x11, -512(x27)
	and	x11, x15, x25
	addi	x11, x11, -4
	sw	x11, 0(x27)
	addi	x27, x27, 4
	bne	x27, x1, .LBB0_26
# %bb.27:                               # %init_norm.exit285.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x26, x23, x26
	add	x27, x24, x21
.LBB0_28:                               # %for.body.i287.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x7
	srli	x14, x14, 18
	slli	x15, x14, 2
	sub	x11, x11, x14
	sub	x11, x11, x15
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -2
	sw	x11, 0(x26)
	addi	x26, x26, 4
	bne	x26, x27, .LBB0_28
# %bb.29:                               # %fill.exit300.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x27, x23, x21
	addi	x26, x17, 1024
	add	x1, x24, x26
.LBB0_30:                               # %for.body.i302.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x29
	srli	x14, x14, 18
	slli	x15, x14, 6
	sub	x11, x11, x14
	sub	x11, x11, x15
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -32
	sw	x11, 0(x27)
	addi	x27, x27, 4
	bne	x27, x1, .LBB0_30
# %bb.31:                               # %fill.exit315.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x26, x23, x26
	add	x27, x24, x22
.LBB0_32:                               # %for.body.i317.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x7
	srli	x14, x14, 18
	slli	x15, x14, 2
	sub	x11, x11, x14
	sub	x11, x11, x15
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -2
	sw	x11, 0(x26)
	addi	x26, x26, 4
	bne	x26, x27, .LBB0_32
# %bb.33:                               # %fill.exit330.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x26, x23, x22
	addi	x27, x5, 1536
	add	x27, x24, x27
.LBB0_34:                               # %for.body.i332.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x14, x11, x29
	srli	x14, x14, 18
	slli	x15, x14, 6
	sub	x11, x11, x14
	sub	x11, x11, x15
	slli	x11, x11, 16
	srli	x11, x11, 16
	addi	x11, x11, -32
	sw	x11, 0(x26)
	addi	x26, x26, 4
	bne	x26, x27, .LBB0_34
# %bb.35:                               # %fill.exit345.i
                                        #   in Loop: Header=BB0_9 Depth=1
	lui	x11, 194
	addi	x11, x11, -2048
	add	x23, x23, x11
	add	x24, x24, x6
.LBB0_36:                               # %for.body.i347.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x11, x10, 16
	mul	x10, x10, x9
	mul	x14, x11, x20
	add	x10, x10, x8
	srli	x14, x14, 19
	srli	x15, x10, 16
	sub	x11, x11, x14
	slli	x14, x14, 3
	sub	x11, x11, x14
	mul	x14, x15, x20
	srli	x14, x14, 19
	addi	x11, x11, 28
	sub	x15, x15, x14
	slli	x14, x14, 3
	and	x11, x11, x25
	sub	x15, x15, x14
	sw	x11, -512(x23)
	and	x11, x15, x25
	addi	x11, x11, -4
	sw	x11, 0(x23)
	addi	x23, x23, 4
	bne	x23, x24, .LBB0_36
# %bb.37:                               # %init_norm.exit368.i
                                        #   in Loop: Header=BB0_9 Depth=1
	andi	x11, x13, 1
	li	x23, 1
	li	x13, 0
	bnez	x11, .LBB0_9
# %bb.38:                               # %for.body.i84.i.preheader
	lui	x11, %hi(w_pool)
	addi	x11, x11, %lo(w_pool)
	lui	x12, 13
	lui	x13, 16
	addi	x12, x12, -819
	add	x13, x11, x13
.LBB0_39:                               # %for.body.i84.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x9
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
	bne	x11, x13, .LBB0_39
# %bb.40:                               # %for.body.i99.i.preheader
	lui	x11, %hi(.L_MergedGlobals.1)
	addi	x11, x11, %lo(.L_MergedGlobals.1)
	lui	x12, 1
	addi	x12, x12, -63
	addi	x13, x11, 512
.LBB0_41:                               # %for.body.i99.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x9
	add	x10, x10, x8
	srli	x14, x10, 16
	mul	x15, x14, x12
	srli	x15, x15, 18
	slli	x16, x15, 6
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -32
	sw	x14, 0(x11)
	addi	x11, x11, 4
	bne	x11, x13, .LBB0_41
# %bb.42:                               # %for.body.i114.i.preheader
	lui	x11, %hi(w_cls)
	addi	x11, x11, %lo(w_cls)
	lui	x12, 13
	addi	x12, x12, -819
	addi	x13, x11, 1024
.LBB0_43:                               # %for.body.i114.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x10, x10, x9
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
	bne	x11, x13, .LBB0_43
# %bb.44:                               # %fill.exit127.i
	mul	x10, x10, x9
	lui	x11, 1
	lui	x13, 16
	add	x10, x10, x8
	addi	x11, x11, -63
	srli	x14, x10, 16
	mul	x12, x10, x9
	mul	x10, x14, x11
	add	x12, x12, x8
	srli	x10, x10, 18
	sub	x14, x14, x10
	slli	x10, x10, 6
	sub	x14, x14, x10
	srli	x10, x12, 16
	mul	x11, x10, x11
	srli	x11, x11, 18
	sub	x10, x10, x11
	slli	x11, x11, 6
	sub	x10, x10, x11
	li	x11, 1
	addi	x13, x13, -1
	and	x14, x14, x13
	and	x13, x10, x13
	lui	x15, %hi(.L_MergedGlobals)
	addi	x15, x15, %lo(.L_MergedGlobals)
	addi	x10, x15, 20
	addi	x14, x14, -32
	addi	x13, x13, -32
	sw	x14, 8(x15)
	sw	x13, 12(x15)
	sw	x11, 16(x15)
	addi	x15, x15, 144
.LBB0_45:                               # %for.body19.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	slli	x11, x12, 6
	srli	x11, x11, 22
	sw	x11, 0(x10)
	addi	x10, x10, 4
	bne	x10, x15, .LBB0_45
# %bb.46:                               # %init_data.exit
	li	x11, 0
	lui	x13, %hi(lcg_state)
	lui	x14, 65555
	lui	x9, %hi(sum_buf)
	addi	x9, x9, %lo(sum_buf)
	lui	x10, %hi(pos_emb)
	addi	x10, x10, %lo(pos_emb)
	sw	x12, %lo(lcg_state)(x13)
	addi	x12, x9, 16
	#APP
	#NO_APP
	sw	x0, 0(x14)
	#APP
	#NO_APP
	li	x5, 4
	li	x6, 7
	li	x7, 1
	sw	x15, 72(x2)                     # 4-byte Folded Spill
.LBB0_47:                               # %for.body.i9
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_48 Depth 2
                                        #     Child Loop BB0_50 Depth 2
	slli	x13, x11, 9
	slli	x14, x11, 2
	lui	x15, %hi(.L_MergedGlobals)
	addi	x15, x15, %lo(.L_MergedGlobals)
	add	x14, x15, x14
	lw	x15, 16(x14)
	lui	x14, %hi(sum_buf)
	addi	x14, x14, %lo(sum_buf)
	add	x13, x13, x14
	addi	x1, x13, 512
	addi	x14, x13, 528
	slli	x15, x15, 9
	lui	x8, %hi(tok_emb)
	addi	x8, x8, %lo(tok_emb)
	add	x8, x8, x15
	mv	x15, x12
	mv	x13, x10
.LBB0_48:                               # %for.body.i.i11
                                        #   Parent Loop BB0_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	lw	x24, 0(x8)
	.insn r 91, 0, 8, x0, x5, x6
	#NO_APP
	#APP
	lw	x16, 0(x13)
	.insn r 91, 0, 8, x0, x5, x6
	#NO_APP
	addi	x8, x8, 32
	#APP
	.insn r4 11, 0, 0, x24, x7, x16, x24
	.insn r 91, 0, 104, x0, x0, x6
	#NO_APP
	sw	x24, -16(x15)
	sw	x25, -12(x15)
	sw	x26, -8(x15)
	sw	x27, -4(x15)
	sw	x28, 0(x15)
	sw	x29, 4(x15)
	sw	x30, 8(x15)
	sw	x31, 12(x15)
	addi	x15, x15, 32
	addi	x13, x13, 32
	bne	x15, x14, .LBB0_48
# %bb.49:                               # %for.body.i63.i.preheader
                                        #   in Loop: Header=BB0_47 Depth=1
	mv	x13, x9
	lw	x14, 72(x2)                     # 4-byte Folded Reload
.LBB0_50:                               # %for.body.i63.i
                                        #   Parent Loop BB0_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	lw	x24, 0(x13)
	.insn r 91, 0, 8, x0, x5, x6
	#NO_APP
	#APP
	lw	x16, 0(x14)
	.insn r 91, 0, 8, x0, x5, x6
	#NO_APP
	#APP
	.insn r4 11, 0, 0, x24, x7, x16, x24
	.insn r 91, 0, 104, x0, x0, x6
	#NO_APP
	sw	x24, 0(x13)
	sw	x25, 4(x13)
	sw	x26, 8(x13)
	sw	x27, 12(x13)
	sw	x28, 16(x13)
	sw	x29, 20(x13)
	sw	x30, 24(x13)
	sw	x31, 28(x13)
	addi	x13, x13, 32
	addi	x14, x14, 32
	bne	x13, x1, .LBB0_50
# %bb.51:                               # %vadd8.exit101.i
                                        #   in Loop: Header=BB0_47 Depth=1
	addi	x11, x11, 1
	addi	x10, x10, 512
	addi	x12, x12, 512
	addi	x9, x9, 512
	li	x13, 32
	bne	x11, x13, .LBB0_47
# %bb.52:                               # %for.cond1.preheader.i.i.preheader
	li	x10, 0
	lui	x11, %hi(sum_buf)
	addi	x11, x11, %lo(sum_buf)
	lui	x12, %hi(hidden)
	addi	x12, x12, %lo(hidden)
	lui	x13, 512
	lui	x14, %hi(.L_MergedGlobals)
	addi	x14, x14, %lo(.L_MergedGlobals)
	addi	x14, x14, 1168
	li	x15, 32
	mv	x16, x12
	mv	x17, x11
	j	.LBB0_54
.LBB0_53:                               # %for.cond.cleanup23.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	addi	x10, x10, 1
	addi	x17, x17, 512
	addi	x16, x16, 512
	beq	x10, x15, .LBB0_67
.LBB0_54:                               # %for.cond1.preheader.i.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_55 Depth 2
                                        #     Child Loop BB0_57 Depth 2
                                        #     Child Loop BB0_60 Depth 2
                                        #     Child Loop BB0_63 Depth 2
	li	x6, 0
	slli	x5, x10, 9
	addi	x7, x5, 512
	add	x5, x12, x7
	add	x7, x11, x7
	mv	x28, x17
.LBB0_55:                               # %for.body4.i.i
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x29, 0(x28)
	addi	x28, x28, 4
	add	x6, x29, x6
	bne	x28, x7, .LBB0_55
# %bb.56:                               # %for.cond.cleanup3.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	li	x28, 0
	srai	x29, x6, 31
	srli	x29, x29, 25
	add	x6, x6, x29
	srai	x6, x6, 7
	mv	x29, x17
.LBB0_57:                               # %for.body10.i.i
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x30, 0(x29)
	addi	x29, x29, 4
	sub	x30, x30, x6
	mul	x30, x30, x30
	add	x28, x30, x28
	bne	x29, x7, .LBB0_57
# %bb.58:                               # %for.cond.cleanup9.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	srli	x28, x28, 7
	addi	x7, x28, 2
	srli	x29, x7, 1
	addi	x7, x28, 1
	bgeu	x28, x29, .LBB0_60
# %bb.59:                               #   in Loop: Header=BB0_54 Depth=1
	mv	x28, x7
	j	.LBB0_61
.LBB0_60:                               # %while.body.i.i.i
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mv	x28, x29
	div	x29, x7, x29
	add	x29, x29, x28
	srli	x30, x29, 31
	add	x29, x29, x30
	srai	x29, x29, 1
	blt	x29, x28, .LBB0_60
.LBB0_61:                               # %isqrt.exit.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	div	x7, x13, x28
	mv	x28, x17
	mv	x29, x14
	mv	x30, x16
	j	.LBB0_63
.LBB0_62:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	sw	x31, 0(x30)
	addi	x30, x30, 4
	addi	x29, x29, 4
	addi	x28, x28, 4
	beq	x30, x5, .LBB0_53
.LBB0_63:                               # %for.body24.i.i
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x31, 0(x28)
	lw	x8, -512(x29)
	lw	x9, 0(x29)
	sub	x31, x31, x6
	mul	x31, x31, x7
	srai	x31, x31, 16
	mul	x31, x31, x8
	srai	x31, x31, 5
	add	x31, x31, x9
	li	x8, -128
	blt	x8, x31, .LBB0_65
# %bb.64:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	li	x31, -128
.LBB0_65:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	li	x8, 127
	blt	x31, x8, .LBB0_62
# %bb.66:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	li	x31, 127
	j	.LBB0_62
.LBB0_67:                               # %layer_norm.exit.i
	li	x13, 0
	#APP
	#NO_APP
	lui	x14, 65555
	li	x15, 1
	lui	x16, 194
	lui	x9, %hi(hidden)
	addi	x9, x9, %lo(hidden)
	li	x12, 4
	li	x7, 7
	lui	x10, 524288
	li	x8, 56
	lui	x17, %hi(sum_buf)
	addi	x17, x17, %lo(sum_buf)
	lui	x11, 4
	sw	x15, 0(x14)
	addi	x10, x10, 1
	sw	x10, 32(x2)                     # 4-byte Folded Spill
	addi	x11, x11, 16
	#APP
	#NO_APP
	add	x11, x17, x11
	sw	x11, 20(x2)                     # 4-byte Folded Spill
	lui	x10, 65
	addi	x11, x16, -1536
	sw	x11, 8(x2)                      # 4-byte Folded Spill
	addi	x17, x17, 16
	sw	x17, 4(x2)                      # 4-byte Folded Spill
	addi	x10, x10, -1536
	sw	x10, 0(x2)                      # 4-byte Folded Spill
	li	x11, 1
	sw	x0, 68(x2)                      # 4-byte Folded Spill
	j	.LBB0_69
.LBB0_68:                               # %encoder_layer.exit.i
                                        #   in Loop: Header=BB0_69 Depth=1
	lw	x10, 12(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 2
	#APP
	#NO_APP
	lui	x11, 65555
	sw	x10, 0(x11)
	#APP
	#NO_APP
	lw	x10, 16(x2)                     # 4-byte Folded Reload
	andi	x10, x10, 1
	li	x13, 1
	li	x11, 0
	beqz	x10, .LBB0_187
.LBB0_69:                               # %for.body13.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_71 Depth 2
                                        #       Child Loop BB0_73 Depth 3
                                        #         Child Loop BB0_74 Depth 4
                                        #     Child Loop BB0_81 Depth 2
                                        #       Child Loop BB0_83 Depth 3
                                        #         Child Loop BB0_84 Depth 4
                                        #     Child Loop BB0_91 Depth 2
                                        #       Child Loop BB0_93 Depth 3
                                        #         Child Loop BB0_94 Depth 4
                                        #     Child Loop BB0_101 Depth 2
                                        #       Child Loop BB0_103 Depth 3
                                        #         Child Loop BB0_105 Depth 4
                                        #           Child Loop BB0_106 Depth 5
                                        #         Child Loop BB0_111 Depth 4
                                        #         Child Loop BB0_115 Depth 4
                                        #     Child Loop BB0_121 Depth 2
                                        #       Child Loop BB0_123 Depth 3
                                        #         Child Loop BB0_124 Depth 4
                                        #     Child Loop BB0_130 Depth 2
                                        #     Child Loop BB0_133 Depth 2
                                        #       Child Loop BB0_134 Depth 3
                                        #       Child Loop BB0_136 Depth 3
                                        #       Child Loop BB0_139 Depth 3
                                        #       Child Loop BB0_142 Depth 3
                                        #     Child Loop BB0_148 Depth 2
                                        #       Child Loop BB0_150 Depth 3
                                        #         Child Loop BB0_151 Depth 4
                                        #     Child Loop BB0_157 Depth 2
                                        #       Child Loop BB0_158 Depth 3
                                        #     Child Loop BB0_162 Depth 2
                                        #       Child Loop BB0_164 Depth 3
                                        #         Child Loop BB0_165 Depth 4
                                        #     Child Loop BB0_171 Depth 2
                                        #     Child Loop BB0_174 Depth 2
                                        #       Child Loop BB0_175 Depth 3
                                        #       Child Loop BB0_177 Depth 3
                                        #       Child Loop BB0_180 Depth 3
                                        #       Child Loop BB0_183 Depth 3
	sw	x11, 16(x2)                     # 4-byte Folded Spill
	li	x15, 0
	lw	x10, 8(x2)                      # 4-byte Folded Reload
	sw	x13, 12(x2)                     # 4-byte Folded Spill
	mul	x10, x13, x10
	lui	x11, %hi(layers)
	addi	x11, x11, %lo(layers)
	add	x11, x11, x10
	lui	x10, 16
	sw	x11, 24(x2)                     # 4-byte Folded Spill
	add	x10, x11, x10
	sw	x10, 72(x2)                     # 4-byte Folded Spill
	mv	x10, x9
	j	.LBB0_71
.LBB0_70:                               # %for.cond.cleanup3.i.i.i
                                        #   in Loop: Header=BB0_71 Depth=2
	lw	x15, 64(x2)                     # 4-byte Folded Reload
	addi	x15, x15, 1
	addi	x10, x10, 512
	li	x11, 32
	beq	x15, x11, .LBB0_79
.LBB0_71:                               # %for.body.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_73 Depth 3
                                        #         Child Loop BB0_74 Depth 4
	li	x14, 0
	sw	x15, 64(x2)                     # 4-byte Folded Spill
	slli	x15, x15, 9
	lui	x11, %hi(Q)
	addi	x11, x11, %lo(Q)
	add	x15, x11, x15
	lw	x11, 24(x2)                     # 4-byte Folded Reload
	j	.LBB0_73
.LBB0_72:                               # %dot8.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	add	x6, x15, x6
	addi	x14, x14, 1
	sw	x9, 0(x6)
	addi	x11, x11, 512
	li	x13, 128
	beq	x14, x13, .LBB0_70
.LBB0_73:                               # %for.body4.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_71 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_74 Depth 4
	slli	x6, x14, 2
	lw	x13, 72(x2)                     # 4-byte Folded Reload
	add	x13, x13, x6
	lw	x9, 0(x13)
	li	x1, -8
	mv	x13, x10
	mv	x5, x11
.LBB0_74:                               # %for.body.i.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_71 Depth=2
                                        #       Parent Loop BB0_73 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#APP
	lw	x24, 0(x13)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x1, x1, 8
	#APP
	lw	x16, 0(x5)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x5, x5, 32
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	li	x16, 120
	addi	x13, x13, 32
	bltu	x1, x16, .LBB0_74
# %bb.75:                               # %dot8.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	srai	x9, x9, 4
	li	x13, -128
	blt	x13, x9, .LBB0_77
# %bb.76:                               # %dot8.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	li	x9, -128
.LBB0_77:                               # %dot8.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	li	x13, 127
	blt	x9, x13, .LBB0_72
# %bb.78:                               # %dot8.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	li	x9, 127
	j	.LBB0_72
.LBB0_79:                               # %dense.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x13, 0
	lui	x10, 16
	addi	x10, x10, 512
	lw	x11, 24(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	lui	x10, 32
	add	x10, x11, x10
	sw	x10, 72(x2)                     # 4-byte Folded Spill
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	j	.LBB0_81
.LBB0_80:                               # %for.cond.cleanup3.i94.i.i
                                        #   in Loop: Header=BB0_81 Depth=2
	lw	x13, 64(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 1
	addi	x10, x10, 512
	li	x11, 32
	beq	x13, x11, .LBB0_89
.LBB0_81:                               # %for.body.i54.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_83 Depth 3
                                        #         Child Loop BB0_84 Depth 4
	li	x15, 0
	sw	x13, 64(x2)                     # 4-byte Folded Spill
	slli	x5, x13, 9
	lui	x11, %hi(K)
	addi	x11, x11, %lo(K)
	add	x5, x11, x5
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	j	.LBB0_83
.LBB0_82:                               # %dot8.exit.i87.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	add	x9, x5, x9
	addi	x15, x15, 1
	sw	x11, 0(x9)
	addi	x13, x13, 512
	li	x11, 128
	beq	x15, x11, .LBB0_80
.LBB0_83:                               # %for.body4.i59.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_81 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_84 Depth 4
	slli	x9, x15, 2
	lw	x11, 72(x2)                     # 4-byte Folded Reload
	add	x11, x11, x9
	lw	x1, 512(x11)
	li	x11, -8
	mv	x14, x10
	mv	x6, x13
.LBB0_84:                               # %for.body.i.i64.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_81 Depth=2
                                        #       Parent Loop BB0_83 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#APP
	lw	x24, 0(x14)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x11, x11, 8
	#APP
	lw	x16, 0(x6)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x6, x6, 32
	#APP
	.insn r4 11, 0, 0, x1, x24, x16, x1
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	li	x16, 120
	addi	x14, x14, 32
	bltu	x11, x16, .LBB0_84
# %bb.85:                               # %dot8.exit.i87.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	srai	x11, x1, 4
	li	x14, -128
	blt	x14, x11, .LBB0_87
# %bb.86:                               # %dot8.exit.i87.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	li	x11, -128
.LBB0_87:                               # %dot8.exit.i87.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	li	x14, 127
	blt	x11, x14, .LBB0_82
# %bb.88:                               # %dot8.exit.i87.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	li	x11, 127
	j	.LBB0_82
.LBB0_89:                               # %dense.exit97.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x13, 0
	lui	x10, 32
	addi	x10, x10, 1024
	lw	x11, 24(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	lui	x10, 48
	add	x10, x11, x10
	sw	x10, 72(x2)                     # 4-byte Folded Spill
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	j	.LBB0_91
.LBB0_90:                               # %for.cond.cleanup3.i138.i.i
                                        #   in Loop: Header=BB0_91 Depth=2
	lw	x13, 64(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 1
	addi	x10, x10, 512
	li	x11, 32
	beq	x13, x11, .LBB0_99
.LBB0_91:                               # %for.body.i98.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_93 Depth 3
                                        #         Child Loop BB0_94 Depth 4
	li	x15, 0
	sw	x13, 64(x2)                     # 4-byte Folded Spill
	slli	x5, x13, 9
	lui	x11, %hi(V)
	addi	x11, x11, %lo(V)
	add	x5, x11, x5
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	j	.LBB0_93
.LBB0_92:                               # %dot8.exit.i131.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	add	x9, x5, x9
	addi	x15, x15, 1
	sw	x11, 0(x9)
	addi	x13, x13, 512
	li	x11, 128
	beq	x15, x11, .LBB0_90
.LBB0_93:                               # %for.body4.i103.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_91 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_94 Depth 4
	slli	x9, x15, 2
	lw	x11, 72(x2)                     # 4-byte Folded Reload
	add	x11, x11, x9
	lw	x1, 1024(x11)
	li	x11, -8
	mv	x14, x10
	mv	x6, x13
.LBB0_94:                               # %for.body.i.i108.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_91 Depth=2
                                        #       Parent Loop BB0_93 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#APP
	lw	x24, 0(x14)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x11, x11, 8
	#APP
	lw	x16, 0(x6)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x6, x6, 32
	#APP
	.insn r4 11, 0, 0, x1, x24, x16, x1
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	li	x16, 120
	addi	x14, x14, 32
	bltu	x11, x16, .LBB0_94
# %bb.95:                               # %dot8.exit.i131.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	srai	x11, x1, 4
	li	x14, -128
	blt	x14, x11, .LBB0_97
# %bb.96:                               # %dot8.exit.i131.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	li	x11, -128
.LBB0_97:                               # %dot8.exit.i131.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	li	x14, 127
	blt	x11, x14, .LBB0_92
# %bb.98:                               # %dot8.exit.i131.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	li	x11, 127
	j	.LBB0_92
.LBB0_99:                               # %for.body.i142.i.i.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x10, 0
	li	x13, 1
	j	.LBB0_101
.LBB0_100:                              # %for.cond.cleanup3.i173.i.i
                                        #   in Loop: Header=BB0_101 Depth=2
	lw	x11, 28(x2)                     # 4-byte Folded Reload
	andi	x11, x11, 1
	li	x10, 64
	li	x13, 0
	beqz	x11, .LBB0_119
.LBB0_101:                              # %for.body.i142.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_103 Depth 3
                                        #         Child Loop BB0_105 Depth 4
                                        #           Child Loop BB0_106 Depth 5
                                        #         Child Loop BB0_111 Depth 4
                                        #         Child Loop BB0_115 Depth 4
	sw	x13, 28(x2)                     # 4-byte Folded Spill
	li	x13, 0
	slli	x10, x10, 2
	lui	x6, %hi(Q)
	addi	x6, x6, %lo(Q)
	add	x6, x6, x10
	lui	x11, %hi(K)
	addi	x11, x11, %lo(K)
	add	x11, x11, x10
	sw	x11, 56(x2)                     # 4-byte Folded Spill
	lui	x11, %hi(context)
	addi	x11, x11, %lo(context)
	add	x11, x11, x10
	sw	x11, 64(x2)                     # 4-byte Folded Spill
	lui	x11, %hi(V)
	addi	x11, x11, %lo(V)
	add	x14, x11, x10
	lui	x11, 3
	add	x11, x14, x11
	sw	x11, 48(x2)                     # 4-byte Folded Spill
	lui	x11, 2
	add	x11, x14, x11
	sw	x11, 44(x2)                     # 4-byte Folded Spill
	lui	x11, 1
	sw	x14, 52(x2)                     # 4-byte Folded Spill
	add	x11, x14, x11
	sw	x11, 40(x2)                     # 4-byte Folded Spill
	addi	x10, x10, 256
	sw	x10, 36(x2)                     # 4-byte Folded Spill
	j	.LBB0_103
.LBB0_102:                              # %for.cond.cleanup31.i.i.i
                                        #   in Loop: Header=BB0_103 Depth=3
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 1
	addi	x6, x6, 512
	lw	x10, 64(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 512
	sw	x10, 64(x2)                     # 4-byte Folded Spill
	li	x10, 32
	beq	x13, x10, .LBB0_100
.LBB0_103:                              # %for.body4.i143.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_105 Depth 4
                                        #           Child Loop BB0_106 Depth 5
                                        #         Child Loop BB0_111 Depth 4
                                        #         Child Loop BB0_115 Depth 4
	li	x10, 0
	sw	x13, 60(x2)                     # 4-byte Folded Spill
	slli	x11, x13, 9
	lw	x13, 36(x2)                     # 4-byte Folded Reload
	add	x11, x13, x11
	lui	x15, %hi(context)
	addi	x15, x15, %lo(context)
	add	x11, x15, x11
	sw	x11, 72(x2)                     # 4-byte Folded Spill
	lw	x11, 56(x2)                     # 4-byte Folded Reload
	lw	x16, 32(x2)                     # 4-byte Folded Reload
	j	.LBB0_105
.LBB0_104:                              # %dot8.exit.i167.i.i
                                        #   in Loop: Header=BB0_105 Depth=4
	addi	x10, x10, 1
	addi	x11, x11, 512
	li	x13, 32
	beq	x10, x13, .LBB0_109
.LBB0_105:                              # %for.body8.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        #       Parent Loop BB0_103 Depth=3
                                        # =>      This Loop Header: Depth=4
                                        #           Child Loop BB0_106 Depth 5
	li	x14, 0
	mv	x13, x16
	li	x5, -8
	mv	x9, x6
	mv	x1, x11
.LBB0_106:                              # %for.body.i.i144.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        #       Parent Loop BB0_103 Depth=3
                                        #         Parent Loop BB0_105 Depth=4
                                        # =>        This Inner Loop Header: Depth=5
	#APP
	lw	x24, 0(x9)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x5, x5, 8
	#APP
	lw	x16, 0(x1)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x1, x1, 32
	#APP
	.insn r4 11, 0, 0, x14, x24, x16, x14
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	addi	x9, x9, 32
	bltu	x5, x8, .LBB0_106
# %bb.107:                              # %dot8.exit.i167.i.i
                                        #   in Loop: Header=BB0_105 Depth=4
	srai	x16, x14, 11
	slli	x14, x10, 2
	addi	x17, x2, 76
	add	x14, x17, x14
	sw	x16, 0(x14)
	blt	x13, x16, .LBB0_104
# %bb.108:                              # %dot8.exit.i167.i.i
                                        #   in Loop: Header=BB0_105 Depth=4
	mv	x16, x13
	j	.LBB0_104
.LBB0_109:                              # %for.body20.i.i.i.preheader
                                        #   in Loop: Header=BB0_103 Depth=3
	li	x10, 0
	addi	x11, x2, 76
	addi	x17, x2, 204
	lui	x5, %hi(EXP_LUT)
	addi	x5, x5, %lo(EXP_LUT)
	j	.LBB0_111
.LBB0_110:                              # %for.body20.i.i.i
                                        #   in Loop: Header=BB0_111 Depth=4
	slli	x13, x13, 2
	add	x13, x5, x13
	lw	x13, 0(x13)
	sw	x13, 0(x11)
	addi	x11, x11, 4
	add	x10, x13, x10
	beq	x11, x17, .LBB0_113
.LBB0_111:                              # %for.body20.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        #       Parent Loop BB0_103 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x13, 0(x11)
	sub	x13, x16, x13
	li	x14, 15
	blt	x13, x14, .LBB0_110
# %bb.112:                              # %for.body20.i.i.i
                                        #   in Loop: Header=BB0_111 Depth=4
	li	x13, 15
	j	.LBB0_110
.LBB0_113:                              # %for.cond.cleanup19.i.i.i
                                        #   in Loop: Header=BB0_103 Depth=3
	lui	x11, 16
	div	x9, x11, x10
	lw	x13, 52(x2)                     # 4-byte Folded Reload
	lw	x11, 40(x2)                     # 4-byte Folded Reload
	lw	x1, 44(x2)                      # 4-byte Folded Reload
	lw	x5, 48(x2)                      # 4-byte Folded Reload
	lw	x14, 64(x2)                     # 4-byte Folded Reload
	j	.LBB0_115
.LBB0_114:                              # %for.cond34.preheader.i.i.i
                                        #   in Loop: Header=BB0_115 Depth=4
	sw	x10, 0(x14)
	addi	x14, x14, 4
	addi	x5, x5, 4
	addi	x1, x1, 4
	addi	x11, x11, 4
	addi	x13, x13, 4
	lw	x10, 72(x2)                     # 4-byte Folded Reload
	beq	x14, x10, .LBB0_102
.LBB0_115:                              # %for.cond34.preheader.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        #       Parent Loop BB0_103 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	addi	x10, x2, 76
	#APP
	lw	x24, 0(x10)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	li	x15, 512
	#APP
	lw	x16, 0(x13)
	.insn r 91, 0, 8, x0, x15, x7
	#NO_APP
	lw	x10, 68(x2)                     # 4-byte Folded Reload
	#APP
	.insn r4 11, 0, 0, x10, x24, x16, x10
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	addi	x16, x2, 108
	#APP
	lw	x24, 0(x16)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	#APP
	lw	x16, 0(x11)
	.insn r 91, 0, 8, x0, x15, x7
	#NO_APP
	#APP
	.insn r4 11, 0, 0, x10, x24, x16, x10
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	addi	x16, x2, 140
	#APP
	lw	x24, 0(x16)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	#APP
	lw	x16, 0(x1)
	.insn r 91, 0, 8, x0, x15, x7
	#NO_APP
	#APP
	.insn r4 11, 0, 0, x10, x24, x16, x10
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	addi	x16, x2, 172
	#APP
	lw	x24, 0(x16)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	#APP
	lw	x16, 0(x5)
	.insn r 91, 0, 8, x0, x15, x7
	#NO_APP
	#APP
	.insn r4 11, 0, 0, x10, x24, x16, x10
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	mul	x10, x10, x9
	srai	x10, x10, 16
	li	x16, -128
	blt	x16, x10, .LBB0_117
# %bb.116:                              # %for.cond34.preheader.i.i.i
                                        #   in Loop: Header=BB0_115 Depth=4
	li	x10, -128
.LBB0_117:                              # %for.cond34.preheader.i.i.i
                                        #   in Loop: Header=BB0_115 Depth=4
	li	x16, 127
	blt	x10, x16, .LBB0_114
# %bb.118:                              # %for.cond34.preheader.i.i.i
                                        #   in Loop: Header=BB0_115 Depth=4
	li	x10, 127
	j	.LBB0_114
.LBB0_119:                              # %attention.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x13, 0
	lui	x10, 48
	addi	x10, x10, 1536
	lw	x11, 24(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	lui	x10, 64
	add	x10, x11, x10
	sw	x10, 72(x2)                     # 4-byte Folded Spill
	lui	x10, %hi(context)
	addi	x10, x10, %lo(context)
	j	.LBB0_121
.LBB0_120:                              # %for.cond.cleanup3.i214.i.i
                                        #   in Loop: Header=BB0_121 Depth=2
	lw	x13, 64(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 1
	addi	x10, x10, 512
	li	x11, 32
	beq	x13, x11, .LBB0_129
.LBB0_121:                              # %for.body.i174.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_123 Depth 3
                                        #         Child Loop BB0_124 Depth 4
	li	x15, 0
	sw	x13, 64(x2)                     # 4-byte Folded Spill
	slli	x5, x13, 9
	lui	x11, %hi(attn_out)
	addi	x11, x11, %lo(attn_out)
	add	x5, x11, x5
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	j	.LBB0_123
.LBB0_122:                              # %dot8.exit.i207.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	add	x9, x5, x9
	addi	x15, x15, 1
	sw	x11, 0(x9)
	addi	x13, x13, 512
	li	x11, 128
	beq	x15, x11, .LBB0_120
.LBB0_123:                              # %for.body4.i179.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_121 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_124 Depth 4
	slli	x9, x15, 2
	lw	x11, 72(x2)                     # 4-byte Folded Reload
	add	x11, x11, x9
	lw	x1, 1536(x11)
	li	x11, -8
	mv	x14, x10
	mv	x6, x13
.LBB0_124:                              # %for.body.i.i184.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_121 Depth=2
                                        #       Parent Loop BB0_123 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#APP
	lw	x24, 0(x14)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x11, x11, 8
	#APP
	lw	x16, 0(x6)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x6, x6, 32
	#APP
	.insn r4 11, 0, 0, x1, x24, x16, x1
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	li	x16, 120
	addi	x14, x14, 32
	bltu	x11, x16, .LBB0_124
# %bb.125:                              # %dot8.exit.i207.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	srai	x11, x1, 4
	li	x14, -128
	blt	x14, x11, .LBB0_127
# %bb.126:                              # %dot8.exit.i207.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	li	x11, -128
.LBB0_127:                              # %dot8.exit.i207.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	li	x14, 127
	blt	x11, x14, .LBB0_122
# %bb.128:                              # %dot8.exit.i207.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	li	x11, 127
	j	.LBB0_122
.LBB0_129:                              # %for.body.i218.i.i.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	lw	x10, 4(x2)                      # 4-byte Folded Reload
	lui	x11, %hi(attn_out)
	addi	x11, x11, %lo(attn_out)
	lui	x9, %hi(hidden)
	addi	x9, x9, %lo(hidden)
	mv	x13, x9
	li	x14, 1
	lw	x15, 20(x2)                     # 4-byte Folded Reload
.LBB0_130:                              # %for.body.i218.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	lw	x24, 0(x13)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	#APP
	lw	x16, 0(x11)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x13, x13, 32
	#APP
	.insn r4 11, 0, 0, x24, x14, x16, x24
	.insn r 91, 0, 104, x0, x0, x7
	#NO_APP
	sw	x24, -16(x10)
	sw	x25, -12(x10)
	sw	x26, -8(x10)
	sw	x27, -4(x10)
	sw	x28, 0(x10)
	sw	x29, 4(x10)
	sw	x30, 8(x10)
	sw	x31, 12(x10)
	addi	x10, x10, 32
	addi	x11, x11, 32
	bne	x10, x15, .LBB0_130
# %bb.131:                              # %vadd8.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x10, 0
	lw	x11, 0(x2)                      # 4-byte Folded Reload
	lw	x13, 24(x2)                     # 4-byte Folded Reload
	add	x11, x13, x11
	mv	x13, x9
	lui	x14, %hi(sum_buf)
	addi	x14, x14, %lo(sum_buf)
	j	.LBB0_133
.LBB0_132:                              # %for.cond.cleanup23.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=2
	addi	x10, x10, 1
	addi	x14, x14, 512
	addi	x13, x13, 512
	li	x15, 32
	beq	x10, x15, .LBB0_146
.LBB0_133:                              # %for.cond1.preheader.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_134 Depth 3
                                        #       Child Loop BB0_136 Depth 3
                                        #       Child Loop BB0_139 Depth 3
                                        #       Child Loop BB0_142 Depth 3
	li	x16, 0
	slli	x15, x10, 9
	addi	x17, x15, 512
	add	x15, x9, x17
	lui	x5, %hi(sum_buf)
	addi	x5, x5, %lo(sum_buf)
	add	x17, x5, x17
	mv	x5, x14
.LBB0_134:                              # %for.body4.i224.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_133 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x6, 0(x5)
	addi	x5, x5, 4
	add	x16, x6, x16
	bne	x5, x17, .LBB0_134
# %bb.135:                              # %for.cond.cleanup3.i228.i.i
                                        #   in Loop: Header=BB0_133 Depth=2
	li	x5, 0
	srai	x6, x16, 31
	srli	x6, x6, 25
	add	x16, x16, x6
	srai	x16, x16, 7
	mv	x6, x14
.LBB0_136:                              # %for.body10.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_133 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x28, 0(x6)
	addi	x6, x6, 4
	sub	x28, x28, x16
	mul	x28, x28, x28
	add	x5, x28, x5
	bne	x6, x17, .LBB0_136
# %bb.137:                              # %for.cond.cleanup9.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=2
	srli	x5, x5, 7
	addi	x17, x5, 2
	srli	x6, x17, 1
	addi	x17, x5, 1
	bgeu	x5, x6, .LBB0_139
# %bb.138:                              #   in Loop: Header=BB0_133 Depth=2
	mv	x5, x17
	j	.LBB0_140
.LBB0_139:                              # %while.body.i.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_133 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	mv	x5, x6
	div	x6, x17, x6
	add	x6, x6, x5
	srli	x28, x6, 31
	add	x6, x6, x28
	srai	x6, x6, 1
	blt	x6, x5, .LBB0_139
.LBB0_140:                              # %isqrt.exit.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=2
	lui	x17, 512
	div	x17, x17, x5
	mv	x5, x14
	mv	x6, x11
	mv	x28, x13
	j	.LBB0_142
.LBB0_141:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_142 Depth=3
	sw	x29, 0(x28)
	addi	x28, x28, 4
	addi	x6, x6, 4
	addi	x5, x5, 4
	beq	x28, x15, .LBB0_132
.LBB0_142:                              # %for.body24.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_133 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x29, 0(x5)
	lw	x30, -512(x6)
	lw	x31, 0(x6)
	sub	x29, x29, x16
	mul	x29, x29, x17
	srai	x29, x29, 16
	mul	x29, x29, x30
	srai	x29, x29, 5
	add	x29, x29, x31
	li	x30, -128
	blt	x30, x29, .LBB0_144
# %bb.143:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_142 Depth=3
	li	x29, -128
.LBB0_144:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_142 Depth=3
	li	x30, 127
	blt	x29, x30, .LBB0_141
# %bb.145:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_142 Depth=3
	li	x29, 127
	j	.LBB0_141
.LBB0_146:                              # %layer_norm.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x13, 0
	lui	x10, 65
	addi	x10, x10, -1024
	lw	x11, 24(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	lui	x10, 129
	add	x10, x11, x10
	sw	x10, 64(x2)                     # 4-byte Folded Spill
	mv	x10, x9
	j	.LBB0_148
.LBB0_147:                              # %for.cond.cleanup3.i277.i.i
                                        #   in Loop: Header=BB0_148 Depth=2
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 1
	addi	x10, x10, 512
	li	x11, 32
	beq	x13, x11, .LBB0_156
.LBB0_148:                              # %for.body.i237.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_150 Depth 3
                                        #         Child Loop BB0_151 Depth 4
	li	x15, 0
	sw	x13, 60(x2)                     # 4-byte Folded Spill
	slli	x5, x13, 11
	lui	x11, %hi(ffn_hidden)
	addi	x11, x11, %lo(ffn_hidden)
	add	x11, x11, x5
	sw	x11, 72(x2)                     # 4-byte Folded Spill
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	j	.LBB0_150
.LBB0_149:                              # %dot8.exit.i270.i.i
                                        #   in Loop: Header=BB0_150 Depth=3
	lw	x14, 72(x2)                     # 4-byte Folded Reload
	add	x9, x14, x9
	addi	x15, x15, 1
	sw	x11, 0(x9)
	addi	x13, x13, 512
	li	x11, 512
	beq	x15, x11, .LBB0_147
.LBB0_150:                              # %for.body4.i242.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_148 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_151 Depth 4
	slli	x9, x15, 2
	lw	x11, 64(x2)                     # 4-byte Folded Reload
	add	x11, x11, x9
	lw	x1, -1024(x11)
	li	x11, -8
	mv	x14, x10
	mv	x6, x13
	li	x5, 120
.LBB0_151:                              # %for.body.i.i247.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_148 Depth=2
                                        #       Parent Loop BB0_150 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#APP
	lw	x24, 0(x14)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x11, x11, 8
	#APP
	lw	x16, 0(x6)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x6, x6, 32
	#APP
	.insn r4 11, 0, 0, x1, x24, x16, x1
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	addi	x14, x14, 32
	bltu	x11, x5, .LBB0_151
# %bb.152:                              # %dot8.exit.i270.i.i
                                        #   in Loop: Header=BB0_150 Depth=3
	srai	x11, x1, 4
	li	x14, -128
	blt	x14, x11, .LBB0_154
# %bb.153:                              # %dot8.exit.i270.i.i
                                        #   in Loop: Header=BB0_150 Depth=3
	li	x11, -128
.LBB0_154:                              # %dot8.exit.i270.i.i
                                        #   in Loop: Header=BB0_150 Depth=3
	li	x14, 127
	blt	x11, x14, .LBB0_149
# %bb.155:                              # %dot8.exit.i270.i.i
                                        #   in Loop: Header=BB0_150 Depth=3
	li	x11, 127
	j	.LBB0_149
.LBB0_156:                              # %for.cond16.preheader.i.i.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x10, 0
	lui	x11, %hi(ffn_hidden)
	addi	x11, x11, %lo(ffn_hidden)
	lui	x16, %hi(GELU_LUT)
	addi	x16, x16, %lo(GELU_LUT)
.LBB0_157:                              # %for.cond16.preheader.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_158 Depth 3
	slli	x13, x10, 11
	lui	x14, %hi(ffn_hidden)
	addi	x14, x14, %lo(ffn_hidden)
	add	x13, x13, x14
	addi	x13, x13, 2047
	addi	x13, x13, 1
	mv	x14, x11
.LBB0_158:                              # %for.body19.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_157 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x15, 0(x14)
	slli	x15, x15, 2
	add	x15, x16, x15
	lw	x15, 512(x15)
	sw	x15, 0(x14)
	addi	x14, x14, 4
	bne	x14, x13, .LBB0_158
# %bb.159:                              # %for.cond.cleanup18.i.i
                                        #   in Loop: Header=BB0_157 Depth=2
	addi	x10, x10, 1
	addi	x11, x11, 2047
	addi	x11, x11, 1
	li	x13, 32
	bne	x10, x13, .LBB0_157
# %bb.160:                              # %for.cond.cleanup.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x13, 0
	lui	x10, 129
	addi	x10, x10, 1024
	lw	x11, 24(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	lui	x10, 193
	add	x10, x11, x10
	sw	x10, 64(x2)                     # 4-byte Folded Spill
	lui	x10, %hi(ffn_hidden)
	addi	x10, x10, %lo(ffn_hidden)
	j	.LBB0_162
.LBB0_161:                              # %for.cond.cleanup3.i321.i.i
                                        #   in Loop: Header=BB0_162 Depth=2
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 1
	addi	x10, x10, 2047
	addi	x10, x10, 1
	li	x11, 32
	beq	x13, x11, .LBB0_170
.LBB0_162:                              # %for.body.i281.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_164 Depth 3
                                        #         Child Loop BB0_165 Depth 4
	li	x15, 0
	sw	x13, 60(x2)                     # 4-byte Folded Spill
	slli	x5, x13, 9
	lui	x11, %hi(ffn_out)
	addi	x11, x11, %lo(ffn_out)
	add	x11, x11, x5
	sw	x11, 72(x2)                     # 4-byte Folded Spill
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	j	.LBB0_164
.LBB0_163:                              # %dot8.exit.i314.i.i
                                        #   in Loop: Header=BB0_164 Depth=3
	lw	x14, 72(x2)                     # 4-byte Folded Reload
	add	x9, x14, x9
	addi	x15, x15, 1
	addi	x13, x13, 2047
	sw	x11, 0(x9)
	addi	x13, x13, 1
	li	x11, 128
	beq	x15, x11, .LBB0_161
.LBB0_164:                              # %for.body4.i286.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_162 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_165 Depth 4
	slli	x9, x15, 2
	lw	x11, 64(x2)                     # 4-byte Folded Reload
	add	x11, x11, x9
	lw	x1, 1024(x11)
	li	x11, -8
	mv	x14, x10
	mv	x6, x13
	li	x5, 504
.LBB0_165:                              # %for.body.i.i291.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_162 Depth=2
                                        #       Parent Loop BB0_164 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	#APP
	lw	x24, 0(x14)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x11, x11, 8
	#APP
	lw	x16, 0(x6)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x6, x6, 32
	#APP
	.insn r4 11, 0, 0, x1, x24, x16, x1
	.insn r 91, 0, 48, x0, x0, x7
	#NO_APP
	addi	x14, x14, 32
	bltu	x11, x5, .LBB0_165
# %bb.166:                              # %dot8.exit.i314.i.i
                                        #   in Loop: Header=BB0_164 Depth=3
	srai	x11, x1, 5
	li	x14, -128
	blt	x14, x11, .LBB0_168
# %bb.167:                              # %dot8.exit.i314.i.i
                                        #   in Loop: Header=BB0_164 Depth=3
	li	x11, -128
.LBB0_168:                              # %dot8.exit.i314.i.i
                                        #   in Loop: Header=BB0_164 Depth=3
	li	x14, 127
	blt	x11, x14, .LBB0_163
# %bb.169:                              # %dot8.exit.i314.i.i
                                        #   in Loop: Header=BB0_164 Depth=3
	li	x11, 127
	j	.LBB0_163
.LBB0_170:                              # %for.body.i325.i.i.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	lui	x10, %hi(sum_buf)
	addi	x10, x10, %lo(sum_buf)
	addi	x10, x10, 16
	lui	x11, %hi(ffn_out)
	addi	x11, x11, %lo(ffn_out)
	lui	x9, %hi(hidden)
	addi	x9, x9, %lo(hidden)
	mv	x13, x9
	li	x14, 1
	lw	x15, 20(x2)                     # 4-byte Folded Reload
.LBB0_171:                              # %for.body.i325.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	lw	x24, 0(x13)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	#APP
	lw	x16, 0(x11)
	.insn r 91, 0, 8, x0, x12, x7
	#NO_APP
	addi	x13, x13, 32
	#APP
	.insn r4 11, 0, 0, x24, x14, x16, x24
	.insn r 91, 0, 104, x0, x0, x7
	#NO_APP
	sw	x24, -16(x10)
	sw	x25, -12(x10)
	sw	x26, -8(x10)
	sw	x27, -4(x10)
	sw	x28, 0(x10)
	sw	x29, 4(x10)
	sw	x30, 8(x10)
	sw	x31, 12(x10)
	addi	x10, x10, 32
	addi	x11, x11, 32
	bne	x10, x15, .LBB0_171
# %bb.172:                              # %vadd8.exit363.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x10, 0
	lui	x11, 194
	addi	x11, x11, -2048
	lw	x13, 24(x2)                     # 4-byte Folded Reload
	add	x11, x13, x11
	mv	x13, x9
	lui	x14, %hi(sum_buf)
	addi	x14, x14, %lo(sum_buf)
	j	.LBB0_174
.LBB0_173:                              # %for.cond.cleanup23.i417.i.i
                                        #   in Loop: Header=BB0_174 Depth=2
	addi	x10, x10, 1
	addi	x14, x14, 512
	addi	x13, x13, 512
	li	x15, 32
	beq	x10, x15, .LBB0_68
.LBB0_174:                              # %for.cond1.preheader.i364.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_175 Depth 3
                                        #       Child Loop BB0_177 Depth 3
                                        #       Child Loop BB0_180 Depth 3
                                        #       Child Loop BB0_183 Depth 3
	li	x16, 0
	slli	x15, x10, 9
	addi	x17, x15, 512
	add	x15, x9, x17
	lui	x5, %hi(sum_buf)
	addi	x5, x5, %lo(sum_buf)
	add	x17, x5, x17
	mv	x5, x14
.LBB0_175:                              # %for.body4.i367.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_174 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x6, 0(x5)
	addi	x5, x5, 4
	add	x16, x6, x16
	bne	x5, x17, .LBB0_175
# %bb.176:                              # %for.cond.cleanup3.i374.i.i
                                        #   in Loop: Header=BB0_174 Depth=2
	li	x5, 0
	srai	x6, x16, 31
	srli	x6, x6, 25
	add	x16, x16, x6
	srai	x16, x16, 7
	mv	x6, x14
.LBB0_177:                              # %for.body10.i376.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_174 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x28, 0(x6)
	addi	x6, x6, 4
	sub	x28, x28, x16
	mul	x28, x28, x28
	add	x5, x28, x5
	bne	x6, x17, .LBB0_177
# %bb.178:                              # %for.cond.cleanup9.i385.i.i
                                        #   in Loop: Header=BB0_174 Depth=2
	srli	x5, x5, 7
	addi	x17, x5, 2
	srli	x6, x17, 1
	addi	x17, x5, 1
	bgeu	x5, x6, .LBB0_180
# %bb.179:                              #   in Loop: Header=BB0_174 Depth=2
	mv	x5, x17
	j	.LBB0_181
.LBB0_180:                              # %while.body.i.i391.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_174 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	mv	x5, x6
	div	x6, x17, x6
	add	x6, x6, x5
	srli	x28, x6, 31
	add	x6, x6, x28
	srai	x6, x6, 1
	blt	x6, x5, .LBB0_180
.LBB0_181:                              # %isqrt.exit.i397.i.i
                                        #   in Loop: Header=BB0_174 Depth=2
	lui	x17, 512
	div	x17, x17, x5
	mv	x5, x14
	mv	x6, x11
	mv	x28, x13
	j	.LBB0_183
.LBB0_182:                              # %for.body24.i401.i.i
                                        #   in Loop: Header=BB0_183 Depth=3
	sw	x29, 0(x28)
	addi	x28, x28, 4
	addi	x6, x6, 4
	addi	x5, x5, 4
	beq	x28, x15, .LBB0_173
.LBB0_183:                              # %for.body24.i401.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_174 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x29, 0(x5)
	lw	x30, -512(x6)
	lw	x31, 0(x6)
	sub	x29, x29, x16
	mul	x29, x29, x17
	srai	x29, x29, 16
	mul	x29, x29, x30
	srai	x29, x29, 5
	add	x29, x29, x31
	li	x30, -128
	blt	x30, x29, .LBB0_185
# %bb.184:                              # %for.body24.i401.i.i
                                        #   in Loop: Header=BB0_183 Depth=3
	li	x29, -128
.LBB0_185:                              # %for.body24.i401.i.i
                                        #   in Loop: Header=BB0_183 Depth=3
	li	x30, 127
	blt	x29, x30, .LBB0_182
# %bb.186:                              # %for.body24.i401.i.i
                                        #   in Loop: Header=BB0_183 Depth=3
	li	x29, 127
	j	.LBB0_182
.LBB0_187:                              # %for.body21.i.preheader
	li	x11, 0
	lui	x10, %hi(w_pool)
	addi	x10, x10, %lo(w_pool)
	li	x14, 4
	li	x15, 7
	li	x5, 120
	lui	x6, %hi(TANH_LUT)
	addi	x6, x6, %lo(TANH_LUT)
	li	x7, 128
	j	.LBB0_189
.LBB0_188:                              # %dot8.exit.i
                                        #   in Loop: Header=BB0_189 Depth=1
	slli	x9, x9, 2
	add	x9, x6, x9
	lw	x12, 512(x9)
	addi	x11, x11, 1
	sw	x12, 512(x8)
	addi	x10, x10, 512
	beq	x11, x7, .LBB0_195
.LBB0_189:                              # %for.body21.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_190 Depth 2
	slli	x8, x11, 2
	lui	x12, %hi(.L_MergedGlobals.1)
	addi	x12, x12, %lo(.L_MergedGlobals.1)
	add	x8, x12, x8
	lw	x9, 0(x8)
	li	x1, -8
	lui	x13, %hi(hidden)
	addi	x13, x13, %lo(hidden)
	mv	x12, x10
.LBB0_190:                              # %for.body.i105.i
                                        #   Parent Loop BB0_189 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	#APP
	lw	x24, 0(x13)
	.insn r 91, 0, 8, x0, x14, x15
	#NO_APP
	addi	x1, x1, 8
	#APP
	lw	x16, 0(x12)
	.insn r 91, 0, 8, x0, x14, x15
	#NO_APP
	addi	x12, x12, 32
	#APP
	.insn r4 11, 0, 0, x9, x24, x16, x9
	.insn r 91, 0, 48, x0, x0, x15
	#NO_APP
	addi	x13, x13, 32
	bltu	x1, x5, .LBB0_190
# %bb.191:                              # %dot8.exit.i
                                        #   in Loop: Header=BB0_189 Depth=1
	srai	x9, x9, 4
	li	x12, -128
	blt	x12, x9, .LBB0_193
# %bb.192:                              # %dot8.exit.i
                                        #   in Loop: Header=BB0_189 Depth=1
	li	x9, -128
.LBB0_193:                              # %dot8.exit.i
                                        #   in Loop: Header=BB0_189 Depth=1
	li	x12, 127
	blt	x9, x12, .LBB0_188
# %bb.194:                              # %dot8.exit.i
                                        #   in Loop: Header=BB0_189 Depth=1
	li	x9, 127
	j	.LBB0_188
.LBB0_195:                              # %for.body35.preheader.i
	lui	x10, %hi(.L_MergedGlobals.1)
	addi	x10, x10, %lo(.L_MergedGlobals.1)
	addi	x12, x10, 512
	lui	x10, %hi(.L_MergedGlobals)
	addi	x10, x10, %lo(.L_MergedGlobals)
	lw	x11, 8(x10)
	li	x13, -8
	lui	x14, %hi(w_cls)
	addi	x14, x14, %lo(w_cls)
	li	x15, 4
	li	x5, 7
	li	x6, 120
.LBB0_196:                              # %for.body.i127.i
                                        # =>This Inner Loop Header: Depth=1
	#APP
	lw	x24, 0(x12)
	.insn r 91, 0, 8, x0, x15, x5
	#NO_APP
	addi	x13, x13, 8
	#APP
	lw	x16, 0(x14)
	.insn r 91, 0, 8, x0, x15, x5
	#NO_APP
	addi	x14, x14, 32
	#APP
	.insn r4 11, 0, 0, x11, x24, x16, x11
	.insn r 91, 0, 48, x0, x0, x5
	#NO_APP
	addi	x12, x12, 32
	bltu	x13, x6, .LBB0_196
# %bb.197:                              # %dot8.exit151.i
	lui	x10, %hi(.L_MergedGlobals)
	addi	x10, x10, %lo(.L_MergedGlobals)
	sw	x11, 0(x10)
	lui	x11, %hi(w_cls+512)
	addi	x11, x11, %lo(w_cls+512)
	lui	x12, %hi(.L_MergedGlobals.1)
	addi	x12, x12, %lo(.L_MergedGlobals.1)
	addi	x12, x12, 512
	lw	x10, 12(x10)
	li	x13, -8
	li	x14, 4
	li	x15, 7
	li	x5, 120
.LBB0_198:                              # %for.body.i127.1.i
                                        # =>This Inner Loop Header: Depth=1
	#APP
	lw	x24, 0(x12)
	.insn r 91, 0, 8, x0, x14, x15
	#NO_APP
	addi	x13, x13, 8
	#APP
	lw	x16, 0(x11)
	.insn r 91, 0, 8, x0, x14, x15
	#NO_APP
	addi	x11, x11, 32
	#APP
	.insn r4 11, 0, 0, x10, x24, x16, x10
	.insn r 91, 0, 48, x0, x0, x15
	#NO_APP
	addi	x12, x12, 32
	bltu	x13, x5, .LBB0_198
# %bb.199:                              # %bert_tiny.exit
	lui	x18, %hi(.L_MergedGlobals)
	addi	x18, x18, %lo(.L_MergedGlobals)
	sw	x10, 4(x18)
	lui	x10, 65555
	li	x11, 4
	#APP
	#NO_APP
	sw	x11, 0(x10)
	#APP
	#NO_APP
	lw	x12, 0(x18)
	lui	x9, 4096
	addi	x9, x9, 403
	lui	x8, %hi(.L.str.1)
	addi	x8, x8, %lo(.L.str.1)
	mv	x10, x8
	li	x11, 0
	call	printf
	lw	x12, 4(x18)
	li	x11, 1
	mv	x10, x8
	call	printf
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	lui	x11, 528842
	lui	x12, 4
	addi	x11, x11, -571
	add	x12, x10, x12
.LBB0_200:                              # %for.body.i22
                                        # =>This Inner Loop Header: Depth=1
	lw	x13, 0(x10)
	addi	x10, x10, 4
	xor	x11, x13, x11
	mul	x11, x11, x9
	bne	x10, x12, .LBB0_200
# %bb.201:                              # %for.body.i26.preheader
	lui	x12, %hi(.L_MergedGlobals)
	addi	x12, x12, %lo(.L_MergedGlobals)
	lw	x10, 0(x12)
	lw	x12, 4(x12)
	xor	x10, x10, x11
	mul	x10, x10, x9
	xor	x10, x12, x10
	mul	x8, x10, x9
	lui	x10, %hi(.L.str.3)
	addi	x10, x10, %lo(.L.str.3)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	lui	x13, 186961
	addi	x13, x13, 1596
	bne	x8, x13, .LBB0_203
# %bb.202:                              # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x10, 0
	j	.LBB0_204
.LBB0_203:                              # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	li	x10, 1
.LBB0_204:                              # %bench_report.exit
	lw	x1, 252(x2)                     # 4-byte Folded Reload
	lw	x8, 248(x2)                     # 4-byte Folded Reload
	lw	x9, 244(x2)                     # 4-byte Folded Reload
	lw	x18, 240(x2)                    # 4-byte Folded Reload
	lw	x19, 236(x2)                    # 4-byte Folded Reload
	lw	x20, 232(x2)                    # 4-byte Folded Reload
	lw	x21, 228(x2)                    # 4-byte Folded Reload
	lw	x22, 224(x2)                    # 4-byte Folded Reload
	lw	x23, 220(x2)                    # 4-byte Folded Reload
	lw	x24, 216(x2)                    # 4-byte Folded Reload
	lw	x25, 212(x2)                    # 4-byte Folded Reload
	lw	x26, 208(x2)                    # 4-byte Folded Reload
	lw	x27, 204(x2)                    # 4-byte Folded Reload
	addi	x2, x2, 256
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"bert_tiny: BERT-tiny forward pass (TOKENS=%d HIDDEN=%d HEADS=%d FFN=%d LAYERS=%d CLASSES=%d) [repeat_8]\n"
	.size	.L.str, 105

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"logit[%u] = %d\n"
	.size	.L.str.1, 16

	.type	hidden,@object                  # @hidden
	.local	hidden
	.comm	hidden,16384,4
	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"bert_tiny"
	.size	.L.str.2, 10

	.type	tok_emb,@object                 # @tok_emb
	.local	tok_emb
	.comm	tok_emb,524288,4
	.type	pos_emb,@object                 # @pos_emb
	.local	pos_emb
	.comm	pos_emb,16384,4
	.type	layers,@object                  # @layers
	.local	layers
	.comm	layers,1586176,4
	.type	w_pool,@object                  # @w_pool
	.local	w_pool
	.comm	w_pool,65536,4
	.type	w_cls,@object                   # @w_cls
	.local	w_cls
	.comm	w_cls,1024,4
	.type	lcg_state,@object               # @lcg_state
	.data
	.p2align	2, 0x0
lcg_state:
	.word	12345                           # 0x3039
	.size	lcg_state, 4

	.type	sum_buf,@object                 # @sum_buf
	.local	sum_buf
	.comm	sum_buf,16384,4
	.type	TANH_LUT,@object                # @TANH_LUT
	.section	.rodata,"a",@progbits
	.p2align	2, 0x0
TANH_LUT:
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967169                      # 0xffffff81
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967170                      # 0xffffff82
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967171                      # 0xffffff83
	.word	4294967172                      # 0xffffff84
	.word	4294967172                      # 0xffffff84
	.word	4294967172                      # 0xffffff84
	.word	4294967172                      # 0xffffff84
	.word	4294967172                      # 0xffffff84
	.word	4294967173                      # 0xffffff85
	.word	4294967173                      # 0xffffff85
	.word	4294967173                      # 0xffffff85
	.word	4294967173                      # 0xffffff85
	.word	4294967174                      # 0xffffff86
	.word	4294967174                      # 0xffffff86
	.word	4294967174                      # 0xffffff86
	.word	4294967174                      # 0xffffff86
	.word	4294967175                      # 0xffffff87
	.word	4294967175                      # 0xffffff87
	.word	4294967176                      # 0xffffff88
	.word	4294967176                      # 0xffffff88
	.word	4294967176                      # 0xffffff88
	.word	4294967177                      # 0xffffff89
	.word	4294967177                      # 0xffffff89
	.word	4294967178                      # 0xffffff8a
	.word	4294967178                      # 0xffffff8a
	.word	4294967179                      # 0xffffff8b
	.word	4294967180                      # 0xffffff8c
	.word	4294967180                      # 0xffffff8c
	.word	4294967181                      # 0xffffff8d
	.word	4294967182                      # 0xffffff8e
	.word	4294967183                      # 0xffffff8f
	.word	4294967183                      # 0xffffff8f
	.word	4294967184                      # 0xffffff90
	.word	4294967185                      # 0xffffff91
	.word	4294967186                      # 0xffffff92
	.word	4294967187                      # 0xffffff93
	.word	4294967188                      # 0xffffff94
	.word	4294967189                      # 0xffffff95
	.word	4294967191                      # 0xffffff97
	.word	4294967192                      # 0xffffff98
	.word	4294967193                      # 0xffffff99
	.word	4294967195                      # 0xffffff9b
	.word	4294967196                      # 0xffffff9c
	.word	4294967198                      # 0xffffff9e
	.word	4294967199                      # 0xffffff9f
	.word	4294967201                      # 0xffffffa1
	.word	4294967203                      # 0xffffffa3
	.word	4294967205                      # 0xffffffa5
	.word	4294967207                      # 0xffffffa7
	.word	4294967209                      # 0xffffffa9
	.word	4294967211                      # 0xffffffab
	.word	4294967213                      # 0xffffffad
	.word	4294967215                      # 0xffffffaf
	.word	4294967218                      # 0xffffffb2
	.word	4294967220                      # 0xffffffb4
	.word	4294967223                      # 0xffffffb7
	.word	4294967226                      # 0xffffffba
	.word	4294967228                      # 0xffffffbc
	.word	4294967231                      # 0xffffffbf
	.word	4294967234                      # 0xffffffc2
	.word	4294967237                      # 0xffffffc5
	.word	4294967240                      # 0xffffffc8
	.word	4294967244                      # 0xffffffcc
	.word	4294967247                      # 0xffffffcf
	.word	4294967250                      # 0xffffffd2
	.word	4294967254                      # 0xffffffd6
	.word	4294967258                      # 0xffffffda
	.word	4294967261                      # 0xffffffdd
	.word	4294967265                      # 0xffffffe1
	.word	4294967269                      # 0xffffffe5
	.word	4294967272                      # 0xffffffe8
	.word	4294967276                      # 0xffffffec
	.word	4294967280                      # 0xfffffff0
	.word	4294967284                      # 0xfffffff4
	.word	4294967288                      # 0xfffffff8
	.word	4294967292                      # 0xfffffffc
	.word	0                               # 0x0
	.word	4                               # 0x4
	.word	8                               # 0x8
	.word	12                              # 0xc
	.word	16                              # 0x10
	.word	20                              # 0x14
	.word	24                              # 0x18
	.word	27                              # 0x1b
	.word	31                              # 0x1f
	.word	35                              # 0x23
	.word	38                              # 0x26
	.word	42                              # 0x2a
	.word	46                              # 0x2e
	.word	49                              # 0x31
	.word	52                              # 0x34
	.word	56                              # 0x38
	.word	59                              # 0x3b
	.word	62                              # 0x3e
	.word	65                              # 0x41
	.word	68                              # 0x44
	.word	70                              # 0x46
	.word	73                              # 0x49
	.word	76                              # 0x4c
	.word	78                              # 0x4e
	.word	81                              # 0x51
	.word	83                              # 0x53
	.word	85                              # 0x55
	.word	87                              # 0x57
	.word	89                              # 0x59
	.word	91                              # 0x5b
	.word	93                              # 0x5d
	.word	95                              # 0x5f
	.word	97                              # 0x61
	.word	98                              # 0x62
	.word	100                             # 0x64
	.word	101                             # 0x65
	.word	103                             # 0x67
	.word	104                             # 0x68
	.word	105                             # 0x69
	.word	107                             # 0x6b
	.word	108                             # 0x6c
	.word	109                             # 0x6d
	.word	110                             # 0x6e
	.word	111                             # 0x6f
	.word	112                             # 0x70
	.word	113                             # 0x71
	.word	113                             # 0x71
	.word	114                             # 0x72
	.word	115                             # 0x73
	.word	116                             # 0x74
	.word	116                             # 0x74
	.word	117                             # 0x75
	.word	118                             # 0x76
	.word	118                             # 0x76
	.word	119                             # 0x77
	.word	119                             # 0x77
	.word	120                             # 0x78
	.word	120                             # 0x78
	.word	120                             # 0x78
	.word	121                             # 0x79
	.word	121                             # 0x79
	.word	122                             # 0x7a
	.word	122                             # 0x7a
	.word	122                             # 0x7a
	.word	122                             # 0x7a
	.word	123                             # 0x7b
	.word	123                             # 0x7b
	.word	123                             # 0x7b
	.word	123                             # 0x7b
	.word	124                             # 0x7c
	.word	124                             # 0x7c
	.word	124                             # 0x7c
	.word	124                             # 0x7c
	.word	124                             # 0x7c
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	125                             # 0x7d
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	126                             # 0x7e
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.word	127                             # 0x7f
	.size	TANH_LUT, 1024

	.type	Q,@object                       # @Q
	.local	Q
	.comm	Q,16384,4
	.type	K,@object                       # @K
	.local	K
	.comm	K,16384,4
	.type	V,@object                       # @V
	.local	V
	.comm	V,16384,4
	.type	context,@object                 # @context
	.local	context
	.comm	context,16384,4
	.type	attn_out,@object                # @attn_out
	.local	attn_out
	.comm	attn_out,16384,4
	.type	ffn_hidden,@object              # @ffn_hidden
	.local	ffn_hidden
	.comm	ffn_hidden,65536,4
	.type	GELU_LUT,@object                # @GELU_LUT
	.p2align	2, 0x0
GELU_LUT:
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967291                      # 0xfffffffb
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967292                      # 0xfffffffc
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967293                      # 0xfffffffd
	.word	4294967294                      # 0xfffffffe
	.word	4294967294                      # 0xfffffffe
	.word	4294967295                      # 0xffffffff
	.word	4294967295                      # 0xffffffff
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	1                               # 0x1
	.word	1                               # 0x1
	.word	2                               # 0x2
	.word	2                               # 0x2
	.word	3                               # 0x3
	.word	3                               # 0x3
	.word	4                               # 0x4
	.word	5                               # 0x5
	.word	5                               # 0x5
	.word	6                               # 0x6
	.word	7                               # 0x7
	.word	8                               # 0x8
	.word	9                               # 0x9
	.word	9                               # 0x9
	.word	10                              # 0xa
	.word	11                              # 0xb
	.word	12                              # 0xc
	.word	13                              # 0xd
	.word	14                              # 0xe
	.word	15                              # 0xf
	.word	16                              # 0x10
	.word	17                              # 0x11
	.word	18                              # 0x12
	.word	19                              # 0x13
	.word	20                              # 0x14
	.word	21                              # 0x15
	.word	22                              # 0x16
	.word	23                              # 0x17
	.word	24                              # 0x18
	.word	25                              # 0x19
	.word	26                              # 0x1a
	.word	27                              # 0x1b
	.word	28                              # 0x1c
	.word	29                              # 0x1d
	.word	30                              # 0x1e
	.word	31                              # 0x1f
	.word	32                              # 0x20
	.word	34                              # 0x22
	.word	35                              # 0x23
	.word	36                              # 0x24
	.word	37                              # 0x25
	.word	38                              # 0x26
	.word	39                              # 0x27
	.word	40                              # 0x28
	.word	41                              # 0x29
	.word	43                              # 0x2b
	.word	44                              # 0x2c
	.word	45                              # 0x2d
	.word	46                              # 0x2e
	.word	47                              # 0x2f
	.word	48                              # 0x30
	.word	49                              # 0x31
	.word	50                              # 0x32
	.word	52                              # 0x34
	.word	53                              # 0x35
	.word	54                              # 0x36
	.word	55                              # 0x37
	.word	56                              # 0x38
	.word	57                              # 0x39
	.word	58                              # 0x3a
	.word	59                              # 0x3b
	.word	60                              # 0x3c
	.word	61                              # 0x3d
	.word	63                              # 0x3f
	.word	64                              # 0x40
	.word	65                              # 0x41
	.word	66                              # 0x42
	.word	67                              # 0x43
	.word	68                              # 0x44
	.word	69                              # 0x45
	.word	70                              # 0x46
	.word	71                              # 0x47
	.word	72                              # 0x48
	.word	73                              # 0x49
	.word	74                              # 0x4a
	.word	75                              # 0x4b
	.word	76                              # 0x4c
	.word	77                              # 0x4d
	.word	78                              # 0x4e
	.word	80                              # 0x50
	.word	81                              # 0x51
	.word	82                              # 0x52
	.word	83                              # 0x53
	.word	84                              # 0x54
	.word	85                              # 0x55
	.word	86                              # 0x56
	.word	87                              # 0x57
	.word	88                              # 0x58
	.word	89                              # 0x59
	.word	90                              # 0x5a
	.word	91                              # 0x5b
	.word	92                              # 0x5c
	.word	93                              # 0x5d
	.word	94                              # 0x5e
	.word	95                              # 0x5f
	.word	96                              # 0x60
	.word	97                              # 0x61
	.word	98                              # 0x62
	.word	99                              # 0x63
	.word	100                             # 0x64
	.word	101                             # 0x65
	.word	102                             # 0x66
	.word	103                             # 0x67
	.word	104                             # 0x68
	.word	105                             # 0x69
	.word	106                             # 0x6a
	.word	107                             # 0x6b
	.word	108                             # 0x6c
	.word	109                             # 0x6d
	.word	110                             # 0x6e
	.word	111                             # 0x6f
	.word	112                             # 0x70
	.word	113                             # 0x71
	.word	114                             # 0x72
	.word	115                             # 0x73
	.word	116                             # 0x74
	.word	117                             # 0x75
	.word	118                             # 0x76
	.word	119                             # 0x77
	.word	120                             # 0x78
	.word	121                             # 0x79
	.word	122                             # 0x7a
	.word	123                             # 0x7b
	.word	124                             # 0x7c
	.word	125                             # 0x7d
	.word	126                             # 0x7e
	.word	127                             # 0x7f
	.size	GELU_LUT, 1024

	.type	ffn_out,@object                 # @ffn_out
	.local	ffn_out
	.comm	ffn_out,16384,4
	.type	EXP_LUT,@object                 # @EXP_LUT
	.p2align	2, 0x0
EXP_LUT:
	.word	256                             # 0x100
	.word	155                             # 0x9b
	.word	94                              # 0x5e
	.word	57                              # 0x39
	.word	35                              # 0x23
	.word	21                              # 0x15
	.word	13                              # 0xd
	.word	8                               # 0x8
	.word	5                               # 0x5
	.word	3                               # 0x3
	.word	2                               # 0x2
	.word	1                               # 0x1
	.word	1                               # 0x1
	.word	0                               # 0x0
	.word	0                               # 0x0
	.word	0                               # 0x0
	.size	EXP_LUT, 64

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
	.type	.L_MergedGlobals.1,@object      # @_MergedGlobals.1
	.local	.L_MergedGlobals.1
	.comm	.L_MergedGlobals.1,1024,4
logits.0 = .L_MergedGlobals
	.size	logits.0, 4
logits.1 = .L_MergedGlobals+4
	.size	logits.1, 4
b_cls.0 = .L_MergedGlobals+8
	.size	b_cls.0, 4
b_cls.1 = .L_MergedGlobals+12
	.size	b_cls.1, 4
token_ids = .L_MergedGlobals+16
	.size	token_ids, 128
seg_emb = .L_MergedGlobals+144
	.size	seg_emb, 512
emb_gamma = .L_MergedGlobals+656
	.size	emb_gamma, 512
emb_beta = .L_MergedGlobals+1168
	.size	emb_beta, 512
b_pool = .L_MergedGlobals.1
	.size	b_pool, 512
pooled = .L_MergedGlobals.1+512
	.size	pooled, 512
	.ident	"clang version 22.1.8 (https://github.com/igabirondo16/llvm-project-22.git d5087d6b74df14fbf64ee88049d1ce9a2c66567d)"
	.section	".note.GNU-stack","",@progbits
