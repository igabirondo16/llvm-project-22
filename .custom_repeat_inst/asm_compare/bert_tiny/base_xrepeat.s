	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0_xrepeat1p0"
	.file	"bert_tiny_base.c"
	.option	push
	.option	arch, +m, +xrepeat, +zmmul
	.text
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:                                # %entry
	addi	x2, x2, -272
	sw	x1, 268(x2)                     # 4-byte Folded Spill
	sw	x8, 264(x2)                     # 4-byte Folded Spill
	sw	x9, 260(x2)                     # 4-byte Folded Spill
	sw	x18, 256(x2)                    # 4-byte Folded Spill
	sw	x19, 252(x2)                    # 4-byte Folded Spill
	sw	x20, 248(x2)                    # 4-byte Folded Spill
	sw	x21, 244(x2)                    # 4-byte Folded Spill
	sw	x22, 240(x2)                    # 4-byte Folded Spill
	sw	x23, 236(x2)                    # 4-byte Folded Spill
	sw	x24, 232(x2)                    # 4-byte Folded Spill
	sw	x25, 228(x2)                    # 4-byte Folded Spill
	sw	x26, 224(x2)                    # 4-byte Folded Spill
	sw	x27, 220(x2)                    # 4-byte Folded Spill
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
	lui	x12, %hi(lcg_state)
	lui	x10, %hi(tok_emb)
	addi	x10, x10, %lo(tok_emb)
	lui	x13, 5
	li	x11, 97
	lw	x12, %lo(lcg_state)(x12)
	addi	x13, x13, 465
	lui	x14, 16
	addi	x14, x14, -1
	lui	x15, 128
	add	x15, x10, x15
.LBB0_1:                                # %for.body.i.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x17, x16, x13
	srli	x17, x17, 16
	sub	x5, x16, x17
	slli	x5, x5, 16
	srli	x5, x5, 17
	add	x17, x5, x17
	srli	x17, x17, 6
	mul	x17, x17, x11
	sub	x16, x16, x17
	and	x16, x16, x14
	addi	x16, x16, -48
	sw	x16, 0(x10)
	addi	x10, x10, 4
	bne	x10, x15, .LBB0_1
# %bb.2:                                # %for.body.i44.i.preheader
	lui	x10, %hi(pos_emb)
	addi	x10, x10, %lo(pos_emb)
	lui	x11, 16
	lui	x13, 4
	addi	x11, x11, -1985
	add	x13, x10, x13
.LBB0_3:                                # %for.body.i44.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x14, x12, 16
	mul	x15, x14, x11
	srli	x15, x15, 21
	slli	x16, x15, 5
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -16
	sw	x14, 0(x10)
	addi	x10, x10, 4
	bne	x10, x13, .LBB0_3
# %bb.4:                                # %for.body.i59.i.preheader
	lui	x14, %hi(.L_MergedGlobals)
	addi	x14, x14, %lo(.L_MergedGlobals)
	lui	x11, 15
	addi	x10, x14, 144
	addi	x13, x11, 241
	addi	x7, x14, 656
.LBB0_5:                                # %for.body.i59.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x14, x12, 16
	mul	x15, x14, x13
	srli	x15, x15, 20
	slli	x16, x15, 4
	sub	x14, x14, x15
	sub	x14, x14, x16
	slli	x14, x14, 16
	srli	x14, x14, 16
	addi	x14, x14, -8
	sw	x14, 0(x10)
	addi	x10, x10, 4
	bne	x10, x7, .LBB0_5
# %bb.6:                                # %for.body.i74.i.preheader
	lui	x11, %hi(.L_MergedGlobals)
	addi	x11, x11, %lo(.L_MergedGlobals)
	addi	x10, x11, 1168
	lui	x13, 14
	lui	x14, 16
	addi	x13, x13, 911
	addi	x14, x14, -1
	addi	x15, x11, 1680
.LBB0_7:                                # %for.body.i74.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x12, x12, x9
	mul	x17, x16, x13
	add	x12, x12, x8
	srli	x17, x17, 19
	srli	x5, x12, 16
	sub	x16, x16, x17
	slli	x17, x17, 3
	sub	x16, x16, x17
	mul	x17, x5, x13
	srli	x17, x17, 19
	addi	x16, x16, 28
	sub	x5, x5, x17
	slli	x17, x17, 3
	and	x16, x16, x14
	sub	x17, x5, x17
	sw	x16, -512(x10)
	and	x16, x17, x14
	addi	x16, x16, -4
	sw	x16, 0(x10)
	addi	x10, x10, 4
	bne	x10, x15, .LBB0_7
# %bb.8:                                # %init_norm.exit.i
	li	x24, 0
	lui	x25, 194
	lui	x10, %hi(lcg_state)
	li	x15, 1
	lui	x14, 16
	lui	x13, 13
	lui	x30, 1
	lui	x16, 32
	lui	x17, 48
	lui	x19, 64
	lui	x5, 65
	lui	x21, 14
	lui	x6, 129
	lui	x22, 193
	addi	x11, x25, -1536
	sw	x11, 24(x2)                     # 4-byte Folded Spill
	sw	x12, %lo(lcg_state)(x10)
	addi	x28, x13, -819
	addi	x29, x14, 512
	addi	x30, x30, -63
	addi	x31, x16, 512
	addi	x18, x17, 1024
	addi	x19, x19, 1536
	addi	x20, x5, -2048
	addi	x10, x21, 911
	addi	x11, x6, -1024
	addi	x23, x22, 1024
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
	addi	x13, x25, -1536
	mul	x13, x24, x13
	lui	x16, %hi(layers)
	addi	x16, x16, %lo(layers)
	add	x24, x16, x13
	add	x13, x16, x13
	add	x25, x13, x14
	mv	x26, x24
.LBB0_10:                               # %for.body.i144.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x21, x12, 16
	mul	x27, x21, x28
	srli	x27, x27, 18
	slli	x1, x27, 2
	sub	x21, x21, x27
	sub	x21, x21, x1
	slli	x21, x21, 16
	srli	x21, x21, 16
	addi	x21, x21, -2
	sw	x21, 0(x26)
	addi	x26, x26, 4
	bne	x26, x25, .LBB0_10
# %bb.11:                               # %fill.exit157.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x24, x14
	add	x26, x13, x29
.LBB0_12:                               # %for.body.i159.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x21, x12, 16
	mul	x27, x21, x30
	srli	x27, x27, 18
	slli	x1, x27, 6
	sub	x21, x21, x27
	sub	x21, x21, x1
	slli	x21, x21, 16
	srli	x21, x21, 16
	addi	x21, x21, -32
	sw	x21, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_12
# %bb.13:                               # %fill.exit172.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x24, x29
	add	x26, x13, x31
.LBB0_14:                               # %for.body.i174.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x21, x12, 16
	mul	x27, x21, x28
	srli	x27, x27, 18
	slli	x1, x27, 2
	sub	x21, x21, x27
	sub	x21, x21, x1
	slli	x21, x21, 16
	srli	x21, x21, 16
	addi	x21, x21, -2
	sw	x21, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_14
# %bb.15:                               # %fill.exit187.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x26, x24, x31
	lui	x25, 32
	addi	x25, x25, 1024
	add	x27, x13, x25
.LBB0_16:                               # %for.body.i189.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x21, x12, 16
	mul	x1, x21, x30
	srli	x1, x1, 18
	slli	x16, x1, 6
	sub	x21, x21, x1
	sub	x16, x21, x16
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -32
	sw	x16, 0(x26)
	addi	x26, x26, 4
	bne	x26, x27, .LBB0_16
# %bb.17:                               # %fill.exit202.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x24, x25
	add	x26, x13, x18
.LBB0_18:                               # %for.body.i204.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x21, x16, x28
	srli	x21, x21, 18
	slli	x27, x21, 2
	sub	x16, x16, x21
	sub	x16, x16, x27
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -2
	sw	x16, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_18
# %bb.19:                               # %fill.exit217.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x26, x24, x18
	lui	x25, 48
	addi	x25, x25, 1536
	add	x27, x13, x25
.LBB0_20:                               # %for.body.i219.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x21, x16, x30
	srli	x21, x21, 18
	slli	x1, x21, 6
	sub	x16, x16, x21
	sub	x16, x16, x1
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -32
	sw	x16, 0(x26)
	addi	x26, x26, 4
	bne	x26, x27, .LBB0_20
# %bb.21:                               # %fill.exit232.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x24, x25
	add	x26, x13, x19
.LBB0_22:                               # %for.body.i234.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x21, x16, x28
	srli	x21, x21, 18
	slli	x27, x21, 2
	sub	x16, x16, x21
	sub	x16, x16, x27
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -2
	sw	x16, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_22
# %bb.23:                               # %fill.exit247.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x24, x19
	add	x26, x13, x20
.LBB0_24:                               # %for.body.i249.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x21, x16, x30
	srli	x21, x21, 18
	slli	x27, x21, 6
	sub	x16, x16, x21
	sub	x16, x16, x27
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -32
	sw	x16, 0(x25)
	addi	x25, x25, 4
	bne	x25, x26, .LBB0_24
# %bb.25:                               # %fill.exit262.i
                                        #   in Loop: Header=BB0_9 Depth=1
	addi	x1, x5, -1536
	addi	x27, x5, -1024
	add	x1, x24, x1
	add	x25, x13, x27
.LBB0_26:                               # %for.body.i264.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	addi	x26, x14, -1
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x12, x12, x9
	mul	x21, x16, x10
	add	x12, x12, x8
	srli	x21, x21, 19
	srli	x17, x12, 16
	sub	x16, x16, x21
	slli	x21, x21, 3
	sub	x16, x16, x21
	mul	x21, x17, x10
	srli	x21, x21, 19
	addi	x16, x16, 28
	sub	x17, x17, x21
	slli	x21, x21, 3
	and	x16, x16, x26
	sub	x17, x17, x21
	sw	x16, -512(x1)
	and	x16, x17, x26
	addi	x16, x16, -4
	sw	x16, 0(x1)
	addi	x1, x1, 4
	bne	x1, x25, .LBB0_26
# %bb.27:                               # %init_norm.exit285.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x27, x24, x27
	add	x25, x13, x11
.LBB0_28:                               # %for.body.i287.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x17, x16, x28
	srli	x17, x17, 18
	slli	x21, x17, 2
	sub	x16, x16, x17
	sub	x16, x16, x21
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -2
	sw	x16, 0(x27)
	addi	x27, x27, 4
	bne	x27, x25, .LBB0_28
# %bb.29:                               # %fill.exit300.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x27, x24, x11
	addi	x25, x6, 1024
	add	x1, x13, x25
.LBB0_30:                               # %for.body.i302.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x17, x16, x30
	srli	x17, x17, 18
	slli	x21, x17, 6
	sub	x16, x16, x17
	sub	x16, x16, x21
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -32
	sw	x16, 0(x27)
	addi	x27, x27, 4
	bne	x27, x1, .LBB0_30
# %bb.31:                               # %fill.exit315.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x24, x25
	add	x27, x13, x23
.LBB0_32:                               # %for.body.i317.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x17, x16, x28
	srli	x17, x17, 18
	slli	x21, x17, 2
	sub	x16, x16, x17
	sub	x16, x16, x21
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -2
	sw	x16, 0(x25)
	addi	x25, x25, 4
	bne	x25, x27, .LBB0_32
# %bb.33:                               # %fill.exit330.i
                                        #   in Loop: Header=BB0_9 Depth=1
	add	x25, x24, x23
	addi	x27, x22, 1536
	add	x27, x13, x27
.LBB0_34:                               # %for.body.i332.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x17, x16, x30
	srli	x17, x17, 18
	slli	x21, x17, 6
	sub	x16, x16, x17
	sub	x16, x16, x21
	slli	x16, x16, 16
	srli	x16, x16, 16
	addi	x16, x16, -32
	sw	x16, 0(x25)
	addi	x25, x25, 4
	bne	x25, x27, .LBB0_34
# %bb.35:                               # %fill.exit345.i
                                        #   in Loop: Header=BB0_9 Depth=1
	lui	x25, 194
	addi	x16, x25, -2048
	add	x24, x24, x16
	addi	x16, x25, -1536
	add	x13, x13, x16
.LBB0_36:                               # %for.body.i347.i
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x16, x12, 16
	mul	x12, x12, x9
	mul	x17, x16, x10
	add	x12, x12, x8
	srli	x17, x17, 19
	srli	x21, x12, 16
	sub	x16, x16, x17
	slli	x17, x17, 3
	sub	x16, x16, x17
	mul	x17, x21, x10
	srli	x17, x17, 19
	addi	x16, x16, 28
	sub	x21, x21, x17
	slli	x17, x17, 3
	and	x16, x16, x26
	sub	x17, x21, x17
	sw	x16, -512(x24)
	and	x16, x17, x26
	addi	x16, x16, -4
	sw	x16, 0(x24)
	addi	x24, x24, 4
	bne	x24, x13, .LBB0_36
# %bb.37:                               # %init_norm.exit368.i
                                        #   in Loop: Header=BB0_9 Depth=1
	andi	x13, x15, 1
	li	x24, 1
	li	x15, 0
	bnez	x13, .LBB0_9
# %bb.38:                               # %for.body.i84.i.preheader
	lui	x13, %hi(w_pool)
	addi	x13, x13, %lo(w_pool)
	lui	x10, 13
	lui	x14, 16
	addi	x10, x10, -819
	add	x14, x13, x14
.LBB0_39:                               # %for.body.i84.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x15, x12, 16
	mul	x16, x15, x10
	srli	x16, x16, 18
	slli	x17, x16, 2
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -2
	sw	x15, 0(x13)
	addi	x13, x13, 4
	bne	x13, x14, .LBB0_39
# %bb.40:                               # %for.body.i99.i.preheader
	lui	x10, %hi(.L_MergedGlobals.1)
	addi	x10, x10, %lo(.L_MergedGlobals.1)
	lui	x13, 1
	addi	x13, x13, -63
	addi	x14, x10, 512
.LBB0_41:                               # %for.body.i99.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x15, x12, 16
	mul	x16, x15, x13
	srli	x16, x16, 18
	slli	x17, x16, 6
	sub	x15, x15, x16
	sub	x15, x15, x17
	slli	x15, x15, 16
	srli	x15, x15, 16
	addi	x15, x15, -32
	sw	x15, 0(x10)
	addi	x10, x10, 4
	bne	x10, x14, .LBB0_41
# %bb.42:                               # %for.body.i114.i.preheader
	lui	x10, %hi(w_cls)
	addi	x10, x10, %lo(w_cls)
	lui	x13, 13
	addi	x13, x13, -819
	addi	x14, x10, 1024
.LBB0_43:                               # %for.body.i114.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x12, x12, x9
	add	x12, x12, x8
	srli	x15, x12, 16
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
	bne	x10, x14, .LBB0_43
# %bb.44:                               # %fill.exit127.i
	mul	x10, x12, x9
	lui	x12, 1
	lui	x13, 16
	add	x10, x10, x8
	addi	x12, x12, -63
	srli	x14, x10, 16
	mul	x17, x10, x9
	mul	x10, x14, x12
	add	x17, x17, x8
	srli	x10, x10, 18
	sub	x14, x14, x10
	slli	x10, x10, 6
	sub	x14, x14, x10
	srli	x10, x17, 16
	mul	x12, x10, x12
	srli	x12, x12, 18
	sub	x10, x10, x12
	slli	x12, x12, 6
	sub	x10, x10, x12
	li	x12, 1
	addi	x13, x13, -1
	and	x14, x14, x13
	and	x13, x10, x13
	lui	x11, %hi(.L_MergedGlobals)
	addi	x11, x11, %lo(.L_MergedGlobals)
	addi	x10, x11, 20
	addi	x14, x14, -32
	addi	x13, x13, -32
	sw	x14, 8(x11)
	sw	x13, 12(x11)
	sw	x12, 16(x11)
	addi	x24, x11, 144
.LBB0_45:                               # %for.body19.i
                                        # =>This Inner Loop Header: Depth=1
	mul	x17, x17, x9
	add	x17, x17, x8
	slli	x13, x17, 6
	srli	x13, x13, 22
	sw	x13, 0(x10)
	addi	x10, x10, 4
	bne	x10, x24, .LBB0_45
# %bb.46:                               # %init_data.exit
	li	x27, 0
	lui	x10, %hi(lcg_state)
	lui	x5, 65555
	lui	x31, %hi(sum_buf)
	addi	x31, x31, %lo(sum_buf)
	lui	x26, %hi(pos_emb)
	addi	x26, x26, %lo(pos_emb)
	sw	x17, %lo(lcg_state)(x10)
	#APP
	#NO_APP
	sw	x0, 0(x5)
	#APP
	#NO_APP
	li	x28, 7
	li	x5, 4
	li	x1, 1
.LBB0_47:                               # %for.body.i9
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_48 Depth 2
                                        #     Child Loop BB0_50 Depth 2
	slli	x10, x27, 2
	lui	x11, %hi(.L_MergedGlobals)
	addi	x11, x11, %lo(.L_MergedGlobals)
	add	x10, x11, x10
	lw	x29, 16(x10)
	slli	x10, x27, 9
	lui	x11, %hi(sum_buf)
	addi	x11, x11, %lo(sum_buf)
	add	x10, x10, x11
	addi	x6, x10, 512
	slli	x29, x29, 9
	lui	x10, %hi(tok_emb)
	addi	x10, x10, %lo(tok_emb)
	add	x29, x10, x29
	mv	x30, x26
	mv	x25, x31
.LBB0_48:                               # %vector.body41
                                        #   Parent Loop BB0_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x8, 0(x29)
	xr.repeat	1, x5, x28
	lw	x16, 0(x30)
	xr.repeat	1, x5, x28
	xr.mac	x16, x1, x8, x16
	xr.repeat	13, x0, x28
	sw	x16, 0(x31)
	sw	x17, 4(x31)
	sw	x18, 8(x31)
	sw	x19, 12(x31)
	sw	x20, 16(x31)
	sw	x21, 20(x31)
	sw	x22, 24(x31)
	sw	x23, 28(x31)
	addi	x31, x31, 32
	addi	x30, x30, 32
	addi	x29, x29, 32
	bne	x31, x6, .LBB0_48
# %bb.49:                               # %vector.body.preheader
                                        #   in Loop: Header=BB0_47 Depth=1
	mv	x31, x25
	mv	x6, x25
	mv	x29, x24
	li	x30, 1
.LBB0_50:                               # %vector.body
                                        #   Parent Loop BB0_47 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x16, 0(x6)
	xr.repeat	1, x5, x28
	lw	x8, 0(x29)
	xr.repeat	1, x5, x28
	addi	x29, x29, 32
	xr.mac	x8, x30, x16, x8
	xr.repeat	13, x0, x28
	sw	x8, 0(x6)
	sw	x9, 4(x6)
	sw	x10, 8(x6)
	sw	x11, 12(x6)
	sw	x12, 16(x6)
	sw	x13, 20(x6)
	sw	x14, 24(x6)
	sw	x15, 28(x6)
	addi	x6, x6, 32
	bne	x29, x7, .LBB0_50
# %bb.51:                               # %vadd.exit74.i
                                        #   in Loop: Header=BB0_47 Depth=1
	addi	x27, x27, 1
	addi	x31, x31, 512
	addi	x26, x26, 512
	li	x10, 32
	bne	x27, x10, .LBB0_47
# %bb.52:                               # %for.cond1.preheader.i.i.preheader
	li	x11, 0
	lui	x12, %hi(sum_buf)
	addi	x12, x12, %lo(sum_buf)
	lui	x13, %hi(hidden)
	addi	x13, x13, %lo(hidden)
	li	x14, 7
	li	x15, 4
	li	x7, 1
	li	x6, -1
	lui	x10, %hi(.L_MergedGlobals)
	addi	x10, x10, %lo(.L_MergedGlobals)
	addi	x10, x10, 1168
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_54
.LBB0_53:                               # %for.cond.cleanup23.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	addi	x11, x5, 1
	addi	x12, x12, 512
	addi	x13, x13, 512
	li	x10, 32
	beq	x11, x10, .LBB0_67
.LBB0_54:                               # %for.cond1.preheader.i.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_55 Depth 2
                                        #     Child Loop BB0_57 Depth 2
                                        #     Child Loop BB0_60 Depth 2
                                        #     Child Loop BB0_63 Depth 2
	li	x31, 0
	mv	x5, x11
	slli	x10, x11, 9
	addi	x8, x10, 512
	lui	x11, %hi(hidden)
	addi	x11, x11, %lo(hidden)
	add	x11, x11, x8
	lui	x10, %hi(sum_buf)
	addi	x10, x10, %lo(sum_buf)
	add	x8, x10, x8
	mv	x10, x12
.LBB0_55:                               # %vector.body54
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x16, 0(x10)
	xr.repeat	1, x15, x14
	addi	x10, x10, 32
	xr.mac	x31, x16, x7, x31
	xr.repeat	2, x0, x14
	bne	x10, x8, .LBB0_55
# %bb.56:                               # %for.cond.cleanup3.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	li	x10, 0
	srai	x16, x31, 31
	srli	x16, x16, 25
	add	x16, x31, x16
	srai	x1, x16, 7
	xr.mac	x24, x1, x7, x0
	xr.repeat	1, x0, x14
	mv	x9, x12
.LBB0_57:                               # %vector.body48
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x16, 0(x9)
	xr.repeat	1, x15, x14
	addi	x9, x9, 32
	xr.mac	x16, x6, x24, x16
	xr.repeat	13, x0, x14
	xr.mac	x10, x16, x16, x10
	xr.repeat	6, x0, x14
	bne	x9, x8, .LBB0_57
# %bb.58:                               # %for.cond.cleanup9.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	srli	x16, x10, 7
	addi	x10, x16, 2
	srli	x29, x10, 1
	addi	x10, x16, 1
	bgeu	x16, x29, .LBB0_60
# %bb.59:                               #   in Loop: Header=BB0_54 Depth=1
	mv	x28, x10
	j	.LBB0_61
.LBB0_60:                               # %while.body.i.i.i
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mv	x28, x29
	div	x16, x10, x29
	add	x16, x16, x29
	srli	x17, x16, 31
	add	x16, x16, x17
	srai	x29, x16, 1
	blt	x29, x28, .LBB0_60
.LBB0_61:                               # %isqrt.exit.i.i
                                        #   in Loop: Header=BB0_54 Depth=1
	lui	x10, 512
	div	x8, x10, x28
	mv	x9, x12
	lw	x18, 60(x2)                     # 4-byte Folded Reload
	mv	x19, x13
	j	.LBB0_63
.LBB0_62:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	sw	x10, 0(x19)
	addi	x19, x19, 4
	addi	x18, x18, 4
	addi	x9, x9, 4
	beq	x19, x11, .LBB0_53
.LBB0_63:                               # %for.body24.i.i
                                        #   Parent Loop BB0_54 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x10, 0(x9)
	lw	x16, -512(x18)
	lw	x17, 0(x18)
	sub	x10, x10, x1
	mul	x10, x10, x8
	srai	x10, x10, 16
	mul	x10, x10, x16
	srai	x10, x10, 5
	add	x10, x10, x17
	li	x16, -128
	blt	x16, x10, .LBB0_65
# %bb.64:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	li	x10, -128
.LBB0_65:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	li	x16, 127
	blt	x10, x16, .LBB0_62
# %bb.66:                               # %for.body24.i.i
                                        #   in Loop: Header=BB0_63 Depth=2
	li	x10, 127
	j	.LBB0_62
.LBB0_67:                               # %layer_norm.exit.i
	li	x15, 0
	#APP
	#NO_APP
	lui	x13, 65555
	li	x14, 1
	lui	x16, 194
	li	x7, 7
	li	x1, 4
	lui	x17, 524288
	lui	x10, 49
	lui	x5, %hi(sum_buf)
	addi	x5, x5, %lo(sum_buf)
	lui	x11, 4
	lui	x12, 130
	sw	x14, 0(x13)
	addi	x10, x10, -2048
	sw	x10, 20(x2)                     # 4-byte Folded Spill
	add	x11, x5, x11
	sw	x11, 36(x2)                     # 4-byte Folded Spill
	addi	x10, x12, -1024
	sw	x10, 16(x2)                     # 4-byte Folded Spill
	#APP
	#NO_APP
	lui	x10, 65
	addi	x11, x16, -1536
	sw	x11, 12(x2)                     # 4-byte Folded Spill
	addi	x17, x17, 1
	sw	x17, 44(x2)                     # 4-byte Folded Spill
	addi	x10, x10, -1536
	sw	x10, 8(x2)                      # 4-byte Folded Spill
	li	x11, 1
	j	.LBB0_69
.LBB0_68:                               # %encoder_layer.exit.i
                                        #   in Loop: Header=BB0_69 Depth=1
	lw	x10, 32(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 2
	#APP
	#NO_APP
	lui	x11, 65555
	sw	x10, 0(x11)
	#APP
	#NO_APP
	lw	x10, 28(x2)                     # 4-byte Folded Reload
	andi	x10, x10, 1
	li	x15, 1
	li	x11, 0
	beqz	x10, .LBB0_207
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
                                        #         Child Loop BB0_104 Depth 4
                                        #       Child Loop BB0_109 Depth 3
                                        #       Child Loop BB0_113 Depth 3
                                        #         Child Loop BB0_114 Depth 4
                                        #     Child Loop BB0_121 Depth 2
                                        #       Child Loop BB0_123 Depth 3
                                        #         Child Loop BB0_124 Depth 4
                                        #       Child Loop BB0_129 Depth 3
                                        #       Child Loop BB0_133 Depth 3
                                        #         Child Loop BB0_134 Depth 4
                                        #     Child Loop BB0_141 Depth 2
                                        #       Child Loop BB0_143 Depth 3
                                        #         Child Loop BB0_144 Depth 4
                                        #     Child Loop BB0_150 Depth 2
                                        #     Child Loop BB0_153 Depth 2
                                        #       Child Loop BB0_154 Depth 3
                                        #       Child Loop BB0_156 Depth 3
                                        #       Child Loop BB0_159 Depth 3
                                        #       Child Loop BB0_162 Depth 3
                                        #     Child Loop BB0_168 Depth 2
                                        #       Child Loop BB0_170 Depth 3
                                        #         Child Loop BB0_171 Depth 4
                                        #     Child Loop BB0_177 Depth 2
                                        #       Child Loop BB0_178 Depth 3
                                        #     Child Loop BB0_182 Depth 2
                                        #       Child Loop BB0_184 Depth 3
                                        #         Child Loop BB0_185 Depth 4
                                        #     Child Loop BB0_191 Depth 2
                                        #     Child Loop BB0_194 Depth 2
                                        #       Child Loop BB0_195 Depth 3
                                        #       Child Loop BB0_197 Depth 3
                                        #       Child Loop BB0_200 Depth 3
                                        #       Child Loop BB0_203 Depth 3
	sw	x11, 28(x2)                     # 4-byte Folded Spill
	li	x13, 0
	lw	x10, 12(x2)                     # 4-byte Folded Reload
	mul	x10, x15, x10
	lw	x11, 24(x2)                     # 4-byte Folded Reload
	sw	x15, 32(x2)                     # 4-byte Folded Spill
	mul	x12, x15, x11
	lui	x11, %hi(layers)
	addi	x11, x11, %lo(layers)
	add	x10, x11, x10
	lui	x5, 16
	sw	x10, 48(x2)                     # 4-byte Folded Spill
	add	x5, x10, x5
	sw	x12, 40(x2)                     # 4-byte Folded Spill
	addi	x10, x12, 512
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	lui	x15, %hi(hidden)
	addi	x15, x15, %lo(hidden)
	j	.LBB0_71
.LBB0_70:                               # %for.cond.cleanup3.i.i.i
                                        #   in Loop: Header=BB0_71 Depth=2
	lw	x13, 56(x2)                     # 4-byte Folded Reload
	addi	x13, x13, 1
	addi	x15, x15, 512
	li	x10, 32
	beq	x13, x10, .LBB0_79
.LBB0_71:                               # %for.body.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_73 Depth 3
                                        #         Child Loop BB0_74 Depth 4
	li	x12, 0
	sw	x13, 56(x2)                     # 4-byte Folded Spill
	slli	x17, x13, 9
	lui	x8, %hi(Q)
	addi	x8, x8, %lo(Q)
	add	x8, x8, x17
	lw	x9, 48(x2)                      # 4-byte Folded Reload
	j	.LBB0_73
.LBB0_72:                               # %dot.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	add	x6, x8, x6
	addi	x12, x12, 1
	sw	x10, 0(x6)
	addi	x9, x9, 512
	li	x10, 128
	beq	x12, x10, .LBB0_70
.LBB0_73:                               # %for.body4.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_71 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_74 Depth 4
	slli	x6, x12, 2
	add	x10, x5, x6
	lw	x10, 0(x10)
	slli	x11, x12, 9
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	add	x11, x13, x11
	lui	x13, %hi(layers)
	addi	x13, x13, %lo(layers)
	add	x11, x13, x11
	mv	x13, x15
	mv	x14, x9
.LBB0_74:                               # %vector.body183
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_71 Depth=2
                                        #       Parent Loop BB0_73 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x13)
	xr.repeat	1, x1, x7
	lw	x24, 0(x14)
	xr.repeat	1, x1, x7
	addi	x14, x14, 32
	xr.mac	x10, x24, x16, x10
	xr.repeat	6, x0, x7
	addi	x13, x13, 32
	bne	x14, x11, .LBB0_74
# %bb.75:                               # %dot.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	srai	x10, x10, 4
	li	x11, -128
	blt	x11, x10, .LBB0_77
# %bb.76:                               # %dot.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	li	x10, -128
.LBB0_77:                               # %dot.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_72
# %bb.78:                               # %dot.exit.i.i.i
                                        #   in Loop: Header=BB0_73 Depth=3
	li	x10, 127
	j	.LBB0_72
.LBB0_79:                               # %dense.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x9, 0
	lui	x10, 16
	addi	x31, x10, 512
	lui	x11, 32
	lw	x8, 48(x2)                      # 4-byte Folded Reload
	add	x11, x8, x11
	sw	x11, 52(x2)                     # 4-byte Folded Spill
	addi	x20, x10, 1024
	add	x8, x8, x31
	lw	x5, 40(x2)                      # 4-byte Folded Reload
	add	x5, x5, x20
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_81
.LBB0_80:                               # %for.cond.cleanup3.i80.i.i
                                        #   in Loop: Header=BB0_81 Depth=2
	addi	x9, x9, 1
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 512
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	li	x10, 32
	beq	x9, x10, .LBB0_89
.LBB0_81:                               # %for.body.i54.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_83 Depth 3
                                        #         Child Loop BB0_84 Depth 4
	li	x12, 0
	slli	x17, x9, 9
	lui	x10, %hi(K)
	addi	x10, x10, %lo(K)
	add	x10, x10, x17
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	mv	x6, x8
	j	.LBB0_83
.LBB0_82:                               # %dot.exit.i73.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	lw	x11, 56(x2)                     # 4-byte Folded Reload
	add	x15, x11, x15
	addi	x12, x12, 1
	sw	x10, 0(x15)
	addi	x6, x6, 512
	li	x10, 128
	beq	x12, x10, .LBB0_80
.LBB0_83:                               # %for.body4.i59.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_81 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_84 Depth 4
	slli	x15, x12, 2
	lw	x10, 52(x2)                     # 4-byte Folded Reload
	add	x10, x10, x15
	lw	x10, 512(x10)
	slli	x11, x12, 9
	add	x11, x5, x11
	lui	x13, %hi(layers)
	addi	x13, x13, %lo(layers)
	add	x11, x13, x11
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	mv	x14, x6
.LBB0_84:                               # %vector.body175
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_81 Depth=2
                                        #       Parent Loop BB0_83 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x13)
	xr.repeat	1, x1, x7
	lw	x24, 0(x14)
	xr.repeat	1, x1, x7
	addi	x14, x14, 32
	xr.mac	x10, x24, x16, x10
	xr.repeat	6, x0, x7
	addi	x13, x13, 32
	bne	x14, x11, .LBB0_84
# %bb.85:                               # %dot.exit.i73.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	srai	x10, x10, 4
	li	x11, -128
	blt	x11, x10, .LBB0_87
# %bb.86:                               # %dot.exit.i73.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	li	x10, -128
.LBB0_87:                               # %dot.exit.i73.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_82
# %bb.88:                               # %dot.exit.i73.i.i
                                        #   in Loop: Header=BB0_83 Depth=3
	li	x10, 127
	j	.LBB0_82
.LBB0_89:                               # %dense.exit83.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x9, 0
	lui	x10, 32
	addi	x6, x10, 1024
	lui	x11, 48
	lw	x12, 48(x2)                     # 4-byte Folded Reload
	add	x11, x12, x11
	sw	x11, 56(x2)                     # 4-byte Folded Spill
	addi	x20, x10, 1536
	add	x12, x12, x6
	sw	x12, 52(x2)                     # 4-byte Folded Spill
	lw	x6, 40(x2)                      # 4-byte Folded Reload
	add	x6, x6, x20
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_91
.LBB0_90:                               # %for.cond.cleanup3.i110.i.i
                                        #   in Loop: Header=BB0_91 Depth=2
	addi	x9, x9, 1
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 512
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	li	x10, 32
	beq	x9, x10, .LBB0_99
.LBB0_91:                               # %for.body.i84.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_93 Depth 3
                                        #         Child Loop BB0_94 Depth 4
	li	x12, 0
	slli	x17, x9, 9
	lui	x5, %hi(V)
	addi	x5, x5, %lo(V)
	add	x5, x5, x17
	lw	x8, 52(x2)                      # 4-byte Folded Reload
	j	.LBB0_93
.LBB0_92:                               # %dot.exit.i103.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	add	x15, x5, x15
	addi	x12, x12, 1
	sw	x10, 0(x15)
	addi	x8, x8, 512
	li	x10, 128
	beq	x12, x10, .LBB0_90
.LBB0_93:                               # %for.body4.i89.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_91 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_94 Depth 4
	slli	x15, x12, 2
	lw	x10, 56(x2)                     # 4-byte Folded Reload
	add	x10, x10, x15
	lw	x10, 1024(x10)
	slli	x11, x12, 9
	add	x11, x6, x11
	lui	x13, %hi(layers)
	addi	x13, x13, %lo(layers)
	add	x11, x13, x11
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	mv	x14, x8
.LBB0_94:                               # %vector.body167
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_91 Depth=2
                                        #       Parent Loop BB0_93 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x13)
	xr.repeat	1, x1, x7
	lw	x24, 0(x14)
	xr.repeat	1, x1, x7
	addi	x14, x14, 32
	xr.mac	x10, x24, x16, x10
	xr.repeat	6, x0, x7
	addi	x13, x13, 32
	bne	x14, x11, .LBB0_94
# %bb.95:                               # %dot.exit.i103.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	srai	x10, x10, 4
	li	x11, -128
	blt	x11, x10, .LBB0_97
# %bb.96:                               # %dot.exit.i103.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	li	x10, -128
.LBB0_97:                               # %dot.exit.i103.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_92
# %bb.98:                               # %dot.exit.i103.i.i
                                        #   in Loop: Header=BB0_93 Depth=3
	li	x10, 127
	j	.LBB0_92
.LBB0_99:                               # %for.body4.i114.i.i.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	sw	x0, 56(x2)                      # 4-byte Folded Spill
	lui	x14, %hi(Q)
	addi	x14, x14, %lo(Q)
	sw	x14, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_101
.LBB0_100:                              # %for.cond.cleanup31.i.i.i
                                        #   in Loop: Header=BB0_101 Depth=2
	lw	x11, 56(x2)                     # 4-byte Folded Reload
	addi	x11, x11, 1
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 512
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	li	x10, 32
	sw	x11, 56(x2)                     # 4-byte Folded Spill
	beq	x11, x10, .LBB0_119
.LBB0_101:                              # %for.body4.i114.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_103 Depth 3
                                        #         Child Loop BB0_104 Depth 4
                                        #       Child Loop BB0_109 Depth 3
                                        #       Child Loop BB0_113 Depth 3
                                        #         Child Loop BB0_114 Depth 4
	li	x8, 0
	lui	x5, %hi(K)
	addi	x5, x5, %lo(K)
	lw	x6, 44(x2)                      # 4-byte Folded Reload
	j	.LBB0_103
.LBB0_102:                              # %dot.exit.i124.i.i
                                        #   in Loop: Header=BB0_103 Depth=3
	addi	x8, x8, 1
	addi	x5, x5, 512
	li	x10, 32
	beq	x8, x10, .LBB0_107
.LBB0_103:                              # %for.body8.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_104 Depth 4
	li	x9, 0
	mv	x12, x6
	slli	x10, x8, 9
	lui	x11, %hi(K)
	addi	x11, x11, %lo(K)
	add	x10, x10, x11
	addi	x10, x10, 256
	lw	x11, 60(x2)                     # 4-byte Folded Reload
	mv	x13, x5
.LBB0_104:                              # %vector.body159
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        #       Parent Loop BB0_103 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x11)
	xr.repeat	1, x1, x7
	lw	x24, 0(x13)
	xr.repeat	1, x1, x7
	addi	x13, x13, 32
	xr.mac	x9, x24, x16, x9
	xr.repeat	6, x0, x7
	addi	x11, x11, 32
	bne	x13, x10, .LBB0_104
# %bb.105:                              # %dot.exit.i124.i.i
                                        #   in Loop: Header=BB0_103 Depth=3
	srai	x6, x9, 11
	slli	x10, x8, 2
	addi	x11, x2, 92
	add	x10, x11, x10
	sw	x6, 0(x10)
	blt	x12, x6, .LBB0_102
# %bb.106:                              # %dot.exit.i124.i.i
                                        #   in Loop: Header=BB0_103 Depth=3
	mv	x6, x12
	j	.LBB0_102
.LBB0_107:                              # %for.body20.i.i.i.preheader
                                        #   in Loop: Header=BB0_101 Depth=2
	li	x12, 0
	addi	x17, x2, 92
	addi	x9, x2, 220
	lui	x13, %hi(EXP_LUT)
	addi	x13, x13, %lo(EXP_LUT)
	j	.LBB0_109
.LBB0_108:                              # %for.body20.i.i.i
                                        #   in Loop: Header=BB0_109 Depth=3
	slli	x10, x10, 2
	add	x10, x13, x10
	lw	x10, 0(x10)
	sw	x10, 0(x17)
	addi	x17, x17, 4
	add	x12, x10, x12
	beq	x17, x9, .LBB0_111
.LBB0_109:                              # %for.body20.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x10, 0(x17)
	sub	x10, x6, x10
	li	x11, 15
	blt	x10, x11, .LBB0_108
# %bb.110:                              # %for.body20.i.i.i
                                        #   in Loop: Header=BB0_109 Depth=3
	li	x10, 15
	j	.LBB0_108
.LBB0_111:                              # %for.cond.cleanup19.i.i.i
                                        #   in Loop: Header=BB0_101 Depth=2
	li	x8, 0
	lui	x10, 16
	div	x5, x10, x12
	lw	x6, 56(x2)                      # 4-byte Folded Reload
	slli	x6, x6, 9
	lui	x10, %hi(context)
	addi	x10, x10, %lo(context)
	add	x6, x10, x6
	lui	x13, %hi(V)
	addi	x13, x13, %lo(V)
	j	.LBB0_113
.LBB0_112:                              # %for.cond.cleanup36.i.i.i
                                        #   in Loop: Header=BB0_113 Depth=3
	slli	x11, x8, 2
	addi	x8, x8, 1
	add	x11, x6, x11
	sw	x10, 0(x11)
	addi	x13, x13, 4
	li	x10, 64
	beq	x8, x10, .LBB0_100
.LBB0_113:                              # %for.cond34.preheader.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_114 Depth 4
	li	x10, 0
	addi	x11, x2, 92
	mv	x12, x13
	li	x15, 512
	lui	x14, 1
.LBB0_114:                              # %vector.body152
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_101 Depth=2
                                        #       Parent Loop BB0_113 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x24, 0(x11)
	xr.repeat	1, x1, x7
	lw	x16, 0(x12)
	xr.repeat	1, x15, x7
	addi	x11, x11, 32
	xr.mac	x10, x16, x24, x10
	xr.repeat	6, x0, x7
	add	x12, x12, x14
	bne	x11, x9, .LBB0_114
# %bb.115:                              # %for.cond.cleanup36.i.i.i
                                        #   in Loop: Header=BB0_113 Depth=3
	mul	x10, x10, x5
	srai	x10, x10, 16
	li	x11, -128
	blt	x11, x10, .LBB0_117
# %bb.116:                              # %for.cond.cleanup36.i.i.i
                                        #   in Loop: Header=BB0_113 Depth=3
	li	x10, -128
.LBB0_117:                              # %for.cond.cleanup36.i.i.i
                                        #   in Loop: Header=BB0_113 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_112
# %bb.118:                              # %for.cond.cleanup36.i.i.i
                                        #   in Loop: Header=BB0_113 Depth=3
	li	x10, 127
	j	.LBB0_112
.LBB0_119:                              # %for.body4.1.i.i.i.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	sw	x0, 56(x2)                      # 4-byte Folded Spill
	lui	x10, %hi(Q)
	addi	x10, x10, %lo(Q)
	addi	x10, x10, 256
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_121
.LBB0_120:                              # %for.cond.cleanup31.1.i.i.i
                                        #   in Loop: Header=BB0_121 Depth=2
	lw	x11, 56(x2)                     # 4-byte Folded Reload
	addi	x11, x11, 1
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 512
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	li	x10, 32
	sw	x11, 56(x2)                     # 4-byte Folded Spill
	beq	x11, x10, .LBB0_139
.LBB0_121:                              # %for.body4.1.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_123 Depth 3
                                        #         Child Loop BB0_124 Depth 4
                                        #       Child Loop BB0_129 Depth 3
                                        #       Child Loop BB0_133 Depth 3
                                        #         Child Loop BB0_134 Depth 4
	li	x8, 0
	lui	x10, %hi(K)
	addi	x10, x10, %lo(K)
	addi	x5, x10, 256
	lui	x6, 524288
	addi	x6, x6, 1
	j	.LBB0_123
.LBB0_122:                              # %dot.exit.1.i.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	addi	x8, x8, 1
	addi	x5, x5, 512
	li	x10, 32
	beq	x8, x10, .LBB0_127
.LBB0_123:                              # %for.body8.1.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_121 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_124 Depth 4
	li	x9, 0
	mv	x12, x6
	slli	x10, x8, 9
	lui	x11, %hi(K)
	addi	x11, x11, %lo(K)
	add	x10, x10, x11
	addi	x10, x10, 512
	lw	x11, 60(x2)                     # 4-byte Folded Reload
	mv	x13, x5
.LBB0_124:                              # %vector.body144
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_121 Depth=2
                                        #       Parent Loop BB0_123 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x11)
	xr.repeat	1, x1, x7
	lw	x24, 0(x13)
	xr.repeat	1, x1, x7
	addi	x13, x13, 32
	xr.mac	x9, x24, x16, x9
	xr.repeat	6, x0, x7
	addi	x11, x11, 32
	bne	x13, x10, .LBB0_124
# %bb.125:                              # %dot.exit.1.i.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	srai	x6, x9, 11
	slli	x10, x8, 2
	addi	x11, x2, 92
	add	x10, x11, x10
	sw	x6, 0(x10)
	blt	x12, x6, .LBB0_122
# %bb.126:                              # %dot.exit.1.i.i.i
                                        #   in Loop: Header=BB0_123 Depth=3
	mv	x6, x12
	j	.LBB0_122
.LBB0_127:                              # %for.body20.1.i.i.i.preheader
                                        #   in Loop: Header=BB0_121 Depth=2
	li	x12, 0
	addi	x10, x2, 92
	addi	x9, x2, 220
	lui	x16, %hi(EXP_LUT)
	addi	x16, x16, %lo(EXP_LUT)
	j	.LBB0_129
.LBB0_128:                              # %for.body20.1.i.i.i
                                        #   in Loop: Header=BB0_129 Depth=3
	slli	x11, x11, 2
	add	x11, x16, x11
	lw	x11, 0(x11)
	sw	x11, 0(x10)
	addi	x10, x10, 4
	add	x12, x11, x12
	beq	x10, x9, .LBB0_131
.LBB0_129:                              # %for.body20.1.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_121 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x11, 0(x10)
	sub	x11, x6, x11
	li	x13, 15
	blt	x11, x13, .LBB0_128
# %bb.130:                              # %for.body20.1.i.i.i
                                        #   in Loop: Header=BB0_129 Depth=3
	li	x11, 15
	j	.LBB0_128
.LBB0_131:                              # %for.cond.cleanup19.1.i.i.i
                                        #   in Loop: Header=BB0_121 Depth=2
	li	x8, 0
	lui	x10, 16
	div	x5, x10, x12
	lw	x6, 56(x2)                      # 4-byte Folded Reload
	slli	x6, x6, 9
	lui	x10, %hi(context)
	addi	x10, x10, %lo(context)
	add	x6, x10, x6
	lui	x10, %hi(V)
	addi	x10, x10, %lo(V)
	addi	x13, x10, 256
	j	.LBB0_133
.LBB0_132:                              # %for.cond.cleanup36.1.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=3
	slli	x11, x8, 2
	addi	x8, x8, 1
	add	x11, x6, x11
	sw	x10, 256(x11)
	addi	x13, x13, 4
	li	x10, 64
	beq	x8, x10, .LBB0_120
.LBB0_133:                              # %for.cond34.preheader.1.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_121 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_134 Depth 4
	li	x10, 0
	addi	x11, x2, 92
	mv	x12, x13
	li	x15, 512
	lui	x14, 1
.LBB0_134:                              # %vector.body137
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_121 Depth=2
                                        #       Parent Loop BB0_133 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x24, 0(x11)
	xr.repeat	1, x1, x7
	lw	x16, 0(x12)
	xr.repeat	1, x15, x7
	addi	x11, x11, 32
	xr.mac	x10, x16, x24, x10
	xr.repeat	6, x0, x7
	add	x12, x12, x14
	bne	x11, x9, .LBB0_134
# %bb.135:                              # %for.cond.cleanup36.1.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=3
	mul	x10, x10, x5
	srai	x10, x10, 16
	li	x11, -128
	blt	x11, x10, .LBB0_137
# %bb.136:                              # %for.cond.cleanup36.1.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=3
	li	x10, -128
.LBB0_137:                              # %for.cond.cleanup36.1.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_132
# %bb.138:                              # %for.cond.cleanup36.1.i.i.i
                                        #   in Loop: Header=BB0_133 Depth=3
	li	x10, 127
	j	.LBB0_132
.LBB0_139:                              # %attention.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x9, 0
	lui	x6, 48
	addi	x6, x6, 1536
	lui	x10, 64
	lw	x11, 48(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	add	x11, x11, x6
	sw	x11, 52(x2)                     # 4-byte Folded Spill
	lw	x6, 20(x2)                      # 4-byte Folded Reload
	lw	x10, 40(x2)                     # 4-byte Folded Reload
	add	x6, x10, x6
	lui	x10, %hi(context)
	addi	x10, x10, %lo(context)
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_141
.LBB0_140:                              # %for.cond.cleanup3.i156.i.i
                                        #   in Loop: Header=BB0_141 Depth=2
	addi	x9, x9, 1
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 512
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	li	x10, 32
	beq	x9, x10, .LBB0_149
.LBB0_141:                              # %for.body.i130.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_143 Depth 3
                                        #         Child Loop BB0_144 Depth 4
	li	x12, 0
	slli	x17, x9, 9
	lui	x5, %hi(attn_out)
	addi	x5, x5, %lo(attn_out)
	add	x5, x5, x17
	lw	x8, 52(x2)                      # 4-byte Folded Reload
	j	.LBB0_143
.LBB0_142:                              # %dot.exit.i149.i.i
                                        #   in Loop: Header=BB0_143 Depth=3
	add	x15, x5, x15
	addi	x12, x12, 1
	sw	x10, 0(x15)
	addi	x8, x8, 512
	li	x10, 128
	beq	x12, x10, .LBB0_140
.LBB0_143:                              # %for.body4.i135.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_141 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_144 Depth 4
	slli	x15, x12, 2
	lw	x10, 56(x2)                     # 4-byte Folded Reload
	add	x10, x10, x15
	lw	x10, 1536(x10)
	slli	x11, x12, 9
	add	x11, x6, x11
	lui	x13, %hi(layers)
	addi	x13, x13, %lo(layers)
	add	x11, x13, x11
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	mv	x14, x8
.LBB0_144:                              # %vector.body129
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_141 Depth=2
                                        #       Parent Loop BB0_143 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x13)
	xr.repeat	1, x1, x7
	lw	x24, 0(x14)
	xr.repeat	1, x1, x7
	addi	x14, x14, 32
	xr.mac	x10, x24, x16, x10
	xr.repeat	6, x0, x7
	addi	x13, x13, 32
	bne	x14, x11, .LBB0_144
# %bb.145:                              # %dot.exit.i149.i.i
                                        #   in Loop: Header=BB0_143 Depth=3
	srai	x10, x10, 4
	li	x11, -128
	blt	x11, x10, .LBB0_147
# %bb.146:                              # %dot.exit.i149.i.i
                                        #   in Loop: Header=BB0_143 Depth=3
	li	x10, -128
.LBB0_147:                              # %dot.exit.i149.i.i
                                        #   in Loop: Header=BB0_143 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_142
# %bb.148:                              # %dot.exit.i149.i.i
                                        #   in Loop: Header=BB0_143 Depth=3
	li	x10, 127
	j	.LBB0_142
.LBB0_149:                              # %vector.body122.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	lui	x11, %hi(attn_out)
	addi	x11, x11, %lo(attn_out)
	lui	x14, %hi(sum_buf)
	addi	x14, x14, %lo(sum_buf)
	mv	x12, x14
	li	x13, 1
	lw	x15, 36(x2)                     # 4-byte Folded Reload
.LBB0_150:                              # %vector.body122
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x24, 0(x10)
	xr.repeat	1, x1, x7
	lw	x16, 0(x11)
	xr.repeat	1, x1, x7
	xr.mac	x16, x13, x24, x16
	xr.repeat	13, x0, x7
	sw	x16, 0(x12)
	sw	x17, 4(x12)
	sw	x18, 8(x12)
	sw	x19, 12(x12)
	sw	x20, 16(x12)
	sw	x21, 20(x12)
	sw	x22, 24(x12)
	sw	x23, 28(x12)
	addi	x12, x12, 32
	addi	x11, x11, 32
	addi	x10, x10, 32
	bne	x12, x15, .LBB0_150
# %bb.151:                              # %vadd.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x30, 0
	lw	x10, 8(x2)                      # 4-byte Folded Reload
	lw	x11, 48(x2)                     # 4-byte Folded Reload
	add	x24, x11, x10
	lui	x26, %hi(hidden)
	addi	x26, x26, %lo(hidden)
	mv	x25, x14
	j	.LBB0_153
.LBB0_152:                              # %for.cond.cleanup23.i.i.i
                                        #   in Loop: Header=BB0_153 Depth=2
	addi	x30, x30, 1
	addi	x25, x25, 512
	addi	x26, x26, 512
	li	x10, 32
	beq	x30, x10, .LBB0_166
.LBB0_153:                              # %for.cond1.preheader.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_154 Depth 3
                                        #       Child Loop BB0_156 Depth 3
                                        #       Child Loop BB0_159 Depth 3
                                        #       Child Loop BB0_162 Depth 3
	li	x5, 0
	slli	x10, x30, 9
	addi	x31, x10, 512
	lui	x6, %hi(hidden)
	addi	x6, x6, %lo(hidden)
	add	x6, x6, x31
	add	x31, x14, x31
	mv	x10, x25
.LBB0_154:                              # %vector.body115
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_153 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x16, 0(x10)
	xr.repeat	1, x1, x7
	addi	x10, x10, 32
	xr.mac	x5, x16, x13, x5
	xr.repeat	2, x0, x7
	bne	x10, x31, .LBB0_154
# %bb.155:                              # %for.cond.cleanup3.i170.i.i
                                        #   in Loop: Header=BB0_153 Depth=2
	li	x29, 0
	srai	x10, x5, 31
	srli	x10, x10, 25
	add	x10, x5, x10
	srai	x27, x10, 7
	xr.mac	x16, x27, x13, x0
	xr.repeat	1, x0, x7
	mv	x5, x25
	li	x28, -1
.LBB0_156:                              # %vector.body108
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_153 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x8, 0(x5)
	xr.repeat	1, x1, x7
	addi	x5, x5, 32
	xr.mac	x8, x28, x16, x8
	xr.repeat	13, x0, x7
	xr.mac	x29, x8, x8, x29
	xr.repeat	6, x0, x7
	bne	x5, x31, .LBB0_156
# %bb.157:                              # %for.cond.cleanup9.i.i.i
                                        #   in Loop: Header=BB0_153 Depth=2
	srli	x11, x29, 7
	addi	x10, x11, 2
	srli	x16, x10, 1
	addi	x10, x11, 1
	bgeu	x11, x16, .LBB0_159
# %bb.158:                              #   in Loop: Header=BB0_153 Depth=2
	mv	x15, x10
	j	.LBB0_160
.LBB0_159:                              # %while.body.i.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_153 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	mv	x15, x16
	div	x11, x10, x16
	add	x11, x11, x16
	srli	x12, x11, 31
	add	x11, x11, x12
	srai	x16, x11, 1
	blt	x16, x15, .LBB0_159
.LBB0_160:                              # %isqrt.exit.i.i.i
                                        #   in Loop: Header=BB0_153 Depth=2
	lui	x10, 512
	div	x17, x10, x15
	mv	x31, x25
	mv	x20, x24
	mv	x5, x26
	li	x13, 1
	lui	x14, %hi(sum_buf)
	addi	x14, x14, %lo(sum_buf)
	j	.LBB0_162
.LBB0_161:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_162 Depth=3
	sw	x10, 0(x5)
	addi	x5, x5, 4
	addi	x20, x20, 4
	addi	x31, x31, 4
	beq	x5, x6, .LBB0_152
.LBB0_162:                              # %for.body24.i.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_153 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x10, 0(x31)
	lw	x11, -512(x20)
	lw	x12, 0(x20)
	sub	x10, x10, x27
	mul	x10, x10, x17
	srai	x10, x10, 16
	mul	x10, x10, x11
	srai	x10, x10, 5
	add	x10, x10, x12
	li	x11, -128
	blt	x11, x10, .LBB0_164
# %bb.163:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_162 Depth=3
	li	x10, -128
.LBB0_164:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_162 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_161
# %bb.165:                              # %for.body24.i.i.i
                                        #   in Loop: Header=BB0_162 Depth=3
	li	x10, 127
	j	.LBB0_161
.LBB0_166:                              # %layer_norm.exit.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x9, 0
	lui	x10, 65
	addi	x6, x10, -1024
	lui	x11, 129
	lw	x12, 48(x2)                     # 4-byte Folded Reload
	add	x11, x12, x11
	sw	x11, 56(x2)                     # 4-byte Folded Spill
	addi	x20, x10, -512
	add	x12, x12, x6
	sw	x12, 52(x2)                     # 4-byte Folded Spill
	lw	x6, 40(x2)                      # 4-byte Folded Reload
	add	x6, x6, x20
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_168
.LBB0_167:                              # %for.cond.cleanup3.i205.i.i
                                        #   in Loop: Header=BB0_168 Depth=2
	addi	x9, x9, 1
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	addi	x10, x10, 512
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	li	x10, 32
	beq	x9, x10, .LBB0_176
.LBB0_168:                              # %for.body.i179.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_170 Depth 3
                                        #         Child Loop BB0_171 Depth 4
	li	x12, 0
	slli	x17, x9, 11
	lui	x5, %hi(ffn_hidden)
	addi	x5, x5, %lo(ffn_hidden)
	add	x5, x5, x17
	lw	x8, 52(x2)                      # 4-byte Folded Reload
	j	.LBB0_170
.LBB0_169:                              # %dot.exit.i198.i.i
                                        #   in Loop: Header=BB0_170 Depth=3
	add	x15, x5, x15
	addi	x12, x12, 1
	sw	x10, 0(x15)
	addi	x8, x8, 512
	beq	x12, x13, .LBB0_167
.LBB0_170:                              # %for.body4.i184.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_168 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_171 Depth 4
	slli	x15, x12, 2
	lw	x10, 56(x2)                     # 4-byte Folded Reload
	add	x10, x10, x15
	lw	x10, -1024(x10)
	slli	x11, x12, 9
	add	x11, x6, x11
	lui	x13, %hi(layers)
	addi	x13, x13, %lo(layers)
	add	x11, x13, x11
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	mv	x14, x8
.LBB0_171:                              # %vector.body98
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_168 Depth=2
                                        #       Parent Loop BB0_170 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x13)
	xr.repeat	1, x1, x7
	lw	x24, 0(x14)
	xr.repeat	1, x1, x7
	addi	x14, x14, 32
	xr.mac	x10, x24, x16, x10
	xr.repeat	6, x0, x7
	addi	x13, x13, 32
	bne	x14, x11, .LBB0_171
# %bb.172:                              # %dot.exit.i198.i.i
                                        #   in Loop: Header=BB0_170 Depth=3
	srai	x10, x10, 4
	li	x11, -128
	blt	x11, x10, .LBB0_174
# %bb.173:                              # %dot.exit.i198.i.i
                                        #   in Loop: Header=BB0_170 Depth=3
	li	x10, -128
.LBB0_174:                              # %dot.exit.i198.i.i
                                        #   in Loop: Header=BB0_170 Depth=3
	li	x11, 127
	li	x13, 512
	blt	x10, x11, .LBB0_169
# %bb.175:                              # %dot.exit.i198.i.i
                                        #   in Loop: Header=BB0_170 Depth=3
	li	x10, 127
	j	.LBB0_169
.LBB0_176:                              # %for.cond16.preheader.i.i.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x16, 0
	lui	x5, %hi(ffn_hidden)
	addi	x5, x5, %lo(ffn_hidden)
	addi	x5, x5, 16
.LBB0_177:                              # %for.cond16.preheader.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_178 Depth 3
	slli	x10, x16, 11
	lui	x11, %hi(ffn_hidden)
	addi	x11, x11, %lo(ffn_hidden)
	add	x10, x10, x11
	addi	x6, x10, 2047
	addi	x6, x6, 17
	mv	x20, x5
	lui	x29, %hi(GELU_LUT)
	addi	x29, x29, %lo(GELU_LUT)
.LBB0_178:                              # %vector.body92
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_177 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x10, -16(x20)
	lw	x11, -12(x20)
	lw	x12, -8(x20)
	lw	x13, -4(x20)
	lw	x14, 0(x20)
	lw	x15, 4(x20)
	lw	x17, 8(x20)
	lw	x28, 12(x20)
	slli	x10, x10, 2
	slli	x11, x11, 2
	slli	x12, x12, 2
	slli	x13, x13, 2
	slli	x14, x14, 2
	slli	x15, x15, 2
	slli	x17, x17, 2
	slli	x28, x28, 2
	add	x10, x29, x10
	add	x11, x29, x11
	add	x12, x29, x12
	add	x13, x29, x13
	add	x14, x29, x14
	add	x15, x29, x15
	add	x17, x29, x17
	add	x28, x29, x28
	lw	x8, 512(x10)
	lw	x9, 512(x11)
	lw	x10, 512(x12)
	lw	x11, 512(x13)
	lw	x12, 512(x14)
	lw	x13, 512(x15)
	lw	x14, 512(x17)
	lw	x15, 512(x28)
	addi	x17, x20, -16
	addi	x20, x20, 32
	sw	x8, 0(x17)
	sw	x9, 4(x17)
	sw	x10, 8(x17)
	sw	x11, 12(x17)
	sw	x12, 16(x17)
	sw	x13, 20(x17)
	sw	x14, 24(x17)
	sw	x15, 28(x17)
	bne	x20, x6, .LBB0_178
# %bb.179:                              # %for.cond.cleanup18.i.i
                                        #   in Loop: Header=BB0_177 Depth=2
	addi	x16, x16, 1
	addi	x5, x5, 2047
	addi	x5, x5, 1
	li	x10, 32
	bne	x16, x10, .LBB0_177
# %bb.180:                              # %for.cond.cleanup.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x9, 0
	lui	x6, 129
	addi	x6, x6, 1024
	lui	x10, 193
	lw	x11, 48(x2)                     # 4-byte Folded Reload
	add	x10, x11, x10
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	add	x11, x11, x6
	sw	x11, 52(x2)                     # 4-byte Folded Spill
	lw	x6, 16(x2)                      # 4-byte Folded Reload
	lw	x10, 40(x2)                     # 4-byte Folded Reload
	add	x6, x10, x6
	lui	x10, %hi(ffn_hidden)
	addi	x10, x10, %lo(ffn_hidden)
	sw	x10, 60(x2)                     # 4-byte Folded Spill
	j	.LBB0_182
.LBB0_181:                              # %for.cond.cleanup3.i235.i.i
                                        #   in Loop: Header=BB0_182 Depth=2
	addi	x9, x9, 1
	lw	x10, 60(x2)                     # 4-byte Folded Reload
	addi	x23, x10, 2047
	addi	x23, x23, 1
	sw	x23, 60(x2)                     # 4-byte Folded Spill
	li	x10, 32
	beq	x9, x10, .LBB0_190
.LBB0_182:                              # %for.body.i209.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_184 Depth 3
                                        #         Child Loop BB0_185 Depth 4
	li	x12, 0
	slli	x17, x9, 9
	lui	x5, %hi(ffn_out)
	addi	x5, x5, %lo(ffn_out)
	add	x5, x5, x17
	lw	x8, 52(x2)                      # 4-byte Folded Reload
	j	.LBB0_184
.LBB0_183:                              # %dot.exit.i228.i.i
                                        #   in Loop: Header=BB0_184 Depth=3
	add	x15, x5, x15
	addi	x12, x12, 1
	addi	x8, x8, 2047
	sw	x10, 0(x15)
	addi	x8, x8, 1
	li	x10, 128
	beq	x12, x10, .LBB0_181
.LBB0_184:                              # %for.body4.i214.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_182 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_185 Depth 4
	slli	x15, x12, 2
	lw	x10, 56(x2)                     # 4-byte Folded Reload
	add	x10, x10, x15
	lw	x10, 1024(x10)
	slli	x11, x12, 11
	add	x11, x6, x11
	lui	x13, %hi(layers)
	addi	x13, x13, %lo(layers)
	add	x11, x13, x11
	lw	x13, 60(x2)                     # 4-byte Folded Reload
	mv	x14, x8
.LBB0_185:                              # %vector.body84
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_182 Depth=2
                                        #       Parent Loop BB0_184 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	lw	x16, 0(x13)
	xr.repeat	1, x1, x7
	lw	x24, 0(x14)
	xr.repeat	1, x1, x7
	addi	x14, x14, 32
	xr.mac	x10, x24, x16, x10
	xr.repeat	6, x0, x7
	addi	x13, x13, 32
	bne	x14, x11, .LBB0_185
# %bb.186:                              # %dot.exit.i228.i.i
                                        #   in Loop: Header=BB0_184 Depth=3
	srai	x10, x10, 5
	li	x11, -128
	blt	x11, x10, .LBB0_188
# %bb.187:                              # %dot.exit.i228.i.i
                                        #   in Loop: Header=BB0_184 Depth=3
	li	x10, -128
.LBB0_188:                              # %dot.exit.i228.i.i
                                        #   in Loop: Header=BB0_184 Depth=3
	li	x11, 127
	blt	x10, x11, .LBB0_183
# %bb.189:                              # %dot.exit.i228.i.i
                                        #   in Loop: Header=BB0_184 Depth=3
	li	x10, 127
	j	.LBB0_183
.LBB0_190:                              # %vector.body77.preheader
                                        #   in Loop: Header=BB0_69 Depth=1
	lui	x10, %hi(hidden)
	addi	x10, x10, %lo(hidden)
	lui	x11, %hi(ffn_out)
	addi	x11, x11, %lo(ffn_out)
	lui	x12, %hi(sum_buf)
	addi	x12, x12, %lo(sum_buf)
	li	x8, 1
	lw	x13, 36(x2)                     # 4-byte Folded Reload
.LBB0_191:                              # %vector.body77
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x24, 0(x10)
	xr.repeat	1, x1, x7
	lw	x16, 0(x11)
	xr.repeat	1, x1, x7
	xr.mac	x16, x8, x24, x16
	xr.repeat	13, x0, x7
	sw	x16, 0(x12)
	sw	x17, 4(x12)
	sw	x18, 8(x12)
	sw	x19, 12(x12)
	sw	x20, 16(x12)
	sw	x21, 20(x12)
	sw	x22, 24(x12)
	sw	x23, 28(x12)
	addi	x12, x12, 32
	addi	x11, x11, 32
	addi	x10, x10, 32
	bne	x12, x13, .LBB0_191
# %bb.192:                              # %vadd.exit247.i.i
                                        #   in Loop: Header=BB0_69 Depth=1
	li	x11, 0
	lui	x31, 194
	addi	x31, x31, -2048
	lw	x10, 48(x2)                     # 4-byte Folded Reload
	add	x10, x10, x31
	sw	x10, 56(x2)                     # 4-byte Folded Spill
	lui	x9, %hi(hidden)
	addi	x9, x9, %lo(hidden)
	lui	x13, %hi(sum_buf)
	addi	x13, x13, %lo(sum_buf)
	j	.LBB0_194
.LBB0_193:                              # %for.cond.cleanup23.i301.i.i
                                        #   in Loop: Header=BB0_194 Depth=2
	addi	x11, x11, 1
	addi	x13, x13, 512
	addi	x9, x9, 512
	li	x10, 32
	beq	x11, x10, .LBB0_68
.LBB0_194:                              # %for.cond1.preheader.i248.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_195 Depth 3
                                        #       Child Loop BB0_197 Depth 3
                                        #       Child Loop BB0_200 Depth 3
                                        #       Child Loop BB0_203 Depth 3
	li	x12, 0
	slli	x10, x11, 9
	addi	x15, x10, 512
	lui	x6, %hi(hidden)
	addi	x6, x6, %lo(hidden)
	add	x6, x6, x15
	lui	x10, %hi(sum_buf)
	addi	x10, x10, %lo(sum_buf)
	add	x15, x10, x15
	mv	x10, x13
.LBB0_195:                              # %vector.body70
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_194 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x16, 0(x10)
	xr.repeat	1, x1, x7
	addi	x10, x10, 32
	xr.mac	x12, x16, x8, x12
	xr.repeat	2, x0, x7
	bne	x10, x15, .LBB0_195
# %bb.196:                              # %for.cond.cleanup3.i258.i.i
                                        #   in Loop: Header=BB0_194 Depth=2
	li	x10, 0
	srai	x14, x12, 31
	srli	x14, x14, 25
	add	x12, x12, x14
	srai	x14, x12, 7
	xr.mac	x24, x14, x8, x0
	xr.repeat	1, x0, x7
	sw	x24, 60(x2)                     # 4-byte Folded Spill
	sw	x25, 64(x2)                     # 4-byte Folded Spill
	sw	x26, 68(x2)                     # 4-byte Folded Spill
	sw	x27, 72(x2)                     # 4-byte Folded Spill
	sw	x28, 76(x2)                     # 4-byte Folded Spill
	sw	x29, 80(x2)                     # 4-byte Folded Spill
	sw	x30, 84(x2)                     # 4-byte Folded Spill
	sw	x31, 88(x2)                     # 4-byte Folded Spill
	mv	x12, x13
	li	x5, -1
.LBB0_197:                              # %vector.body63
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_194 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x16, 0(x12)
	xr.repeat	1, x1, x7
	addi	x12, x12, 32
	lw	x24, 60(x2)                     # 4-byte Folded Reload
	lw	x25, 64(x2)                     # 4-byte Folded Reload
	lw	x26, 68(x2)                     # 4-byte Folded Reload
	lw	x27, 72(x2)                     # 4-byte Folded Reload
	lw	x28, 76(x2)                     # 4-byte Folded Reload
	lw	x29, 80(x2)                     # 4-byte Folded Reload
	lw	x30, 84(x2)                     # 4-byte Folded Reload
	lw	x31, 88(x2)                     # 4-byte Folded Reload
	xr.mac	x16, x5, x24, x16
	xr.repeat	13, x0, x7
	xr.mac	x10, x16, x16, x10
	xr.repeat	6, x0, x7
	bne	x12, x15, .LBB0_197
# %bb.198:                              # %for.cond.cleanup9.i269.i.i
                                        #   in Loop: Header=BB0_194 Depth=2
	srli	x12, x10, 7
	addi	x15, x12, 2
	srli	x15, x15, 1
	addi	x10, x12, 1
	bgeu	x12, x15, .LBB0_200
# %bb.199:                              #   in Loop: Header=BB0_194 Depth=2
	mv	x12, x10
	j	.LBB0_201
.LBB0_200:                              # %while.body.i.i275.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_194 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	mv	x12, x15
	div	x15, x10, x15
	add	x15, x15, x12
	srli	x16, x15, 31
	add	x15, x15, x16
	srai	x15, x15, 1
	blt	x15, x12, .LBB0_200
.LBB0_201:                              # %isqrt.exit.i281.i.i
                                        #   in Loop: Header=BB0_194 Depth=2
	lui	x10, 512
	div	x17, x10, x12
	mv	x18, x13
	lw	x15, 56(x2)                     # 4-byte Folded Reload
	mv	x12, x9
	j	.LBB0_203
.LBB0_202:                              # %for.body24.i285.i.i
                                        #   in Loop: Header=BB0_203 Depth=3
	sw	x10, 0(x12)
	addi	x12, x12, 4
	addi	x15, x15, 4
	addi	x18, x18, 4
	beq	x12, x6, .LBB0_193
.LBB0_203:                              # %for.body24.i285.i.i
                                        #   Parent Loop BB0_69 Depth=1
                                        #     Parent Loop BB0_194 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	lw	x10, 0(x18)
	lw	x16, -512(x15)
	lw	x28, 0(x15)
	sub	x10, x10, x14
	mul	x10, x10, x17
	srai	x10, x10, 16
	mul	x10, x10, x16
	srai	x10, x10, 5
	add	x10, x10, x28
	li	x16, -128
	blt	x16, x10, .LBB0_205
# %bb.204:                              # %for.body24.i285.i.i
                                        #   in Loop: Header=BB0_203 Depth=3
	li	x10, -128
.LBB0_205:                              # %for.body24.i285.i.i
                                        #   in Loop: Header=BB0_203 Depth=3
	li	x16, 127
	blt	x10, x16, .LBB0_202
# %bb.206:                              # %for.body24.i285.i.i
                                        #   in Loop: Header=BB0_203 Depth=3
	li	x10, 127
	j	.LBB0_202
.LBB0_207:                              # %for.body21.i.preheader
	li	x27, 0
	lui	x24, %hi(w_pool)
	addi	x24, x24, %lo(w_pool)
	lui	x26, %hi(.L_MergedGlobals.1)
	addi	x26, x26, %lo(.L_MergedGlobals.1)
	lui	x25, %hi(hidden)
	addi	x25, x25, %lo(hidden)
	li	x1, 7
	li	x31, 4
	mv	x5, x24
	j	.LBB0_209
.LBB0_208:                              # %dot.exit.i
                                        #   in Loop: Header=BB0_209 Depth=1
	slli	x7, x7, 2
	lui	x10, %hi(TANH_LUT)
	addi	x10, x10, %lo(TANH_LUT)
	add	x7, x10, x7
	lw	x10, 512(x7)
	addi	x27, x27, 1
	sw	x10, 512(x6)
	addi	x5, x5, 512
	li	x10, 128
	beq	x27, x10, .LBB0_215
.LBB0_209:                              # %for.body21.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_210 Depth 2
	slli	x6, x27, 2
	add	x6, x26, x6
	lw	x7, 0(x6)
	slli	x28, x27, 9
	add	x28, x28, x24
	addi	x28, x28, 512
	mv	x29, x25
	mv	x30, x5
.LBB0_210:                              # %vector.body191
                                        #   Parent Loop BB0_209 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	lw	x16, 0(x29)
	xr.repeat	1, x31, x1
	lw	x8, 0(x30)
	xr.repeat	1, x31, x1
	addi	x30, x30, 32
	xr.mac	x7, x8, x16, x7
	xr.repeat	6, x0, x1
	addi	x29, x29, 32
	bne	x30, x28, .LBB0_210
# %bb.211:                              # %dot.exit.i
                                        #   in Loop: Header=BB0_209 Depth=1
	srai	x7, x7, 4
	li	x10, -128
	blt	x10, x7, .LBB0_213
# %bb.212:                              # %dot.exit.i
                                        #   in Loop: Header=BB0_209 Depth=1
	li	x7, -128
.LBB0_213:                              # %dot.exit.i
                                        #   in Loop: Header=BB0_209 Depth=1
	li	x10, 127
	blt	x7, x10, .LBB0_208
# %bb.214:                              # %dot.exit.i
                                        #   in Loop: Header=BB0_209 Depth=1
	li	x7, 127
	j	.LBB0_208
.LBB0_215:                              # %vector.ph198
	mv	x5, x26
	addi	x12, x26, 512
	lui	x10, %hi(.L_MergedGlobals)
	addi	x10, x10, %lo(.L_MergedGlobals)
	lw	x11, 8(x10)
	lui	x13, %hi(w_cls)
	addi	x13, x13, %lo(w_cls)
	li	x14, 7
	li	x15, 4
	addi	x10, x13, 512
.LBB0_216:                              # %vector.body199
                                        # =>This Inner Loop Header: Depth=1
	lw	x24, 0(x12)
	xr.repeat	1, x15, x14
	lw	x16, 0(x13)
	xr.repeat	1, x15, x14
	addi	x13, x13, 32
	xr.mac	x11, x16, x24, x11
	xr.repeat	6, x0, x14
	addi	x12, x12, 32
	bne	x13, x10, .LBB0_216
# %bb.217:                              # %dot.exit97.i
	lui	x10, %hi(.L_MergedGlobals)
	addi	x10, x10, %lo(.L_MergedGlobals)
	sw	x11, 0(x10)
	lui	x15, %hi(w_cls)
	addi	x15, x15, %lo(w_cls)
	addi	x11, x5, 512
	lw	x10, 12(x10)
	addi	x12, x15, 512
	li	x13, 7
	li	x14, 4
	addi	x15, x15, 1024
.LBB0_218:                              # %vector.body207
                                        # =>This Inner Loop Header: Depth=1
	lw	x24, 0(x11)
	xr.repeat	1, x14, x13
	lw	x16, 0(x12)
	xr.repeat	1, x14, x13
	addi	x12, x12, 32
	xr.mac	x10, x16, x24, x10
	xr.repeat	6, x0, x13
	addi	x11, x11, 32
	bne	x12, x15, .LBB0_218
# %bb.219:                              # %bert_tiny.exit
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
.LBB0_220:                              # %for.body.i24
                                        # =>This Inner Loop Header: Depth=1
	lw	x13, 0(x10)
	addi	x10, x10, 4
	xor	x11, x13, x11
	mul	x11, x11, x9
	bne	x10, x12, .LBB0_220
# %bb.221:                              # %for.body.i28.preheader
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
	bne	x8, x13, .LBB0_223
# %bb.222:                              # %if.then2.i
	lui	x10, %hi(.L.str.5)
	addi	x10, x10, %lo(.L.str.5)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	call	printf
	li	x10, 0
	j	.LBB0_224
.LBB0_223:                              # %if.end4.i
	lui	x10, %hi(.L.str.6)
	addi	x10, x10, %lo(.L.str.6)
	lui	x11, %hi(.L.str.2)
	addi	x11, x11, %lo(.L.str.2)
	mv	x12, x8
	call	printf
	li	x10, 1
.LBB0_224:                              # %bench_report.exit
	lw	x1, 268(x2)                     # 4-byte Folded Reload
	lw	x8, 264(x2)                     # 4-byte Folded Reload
	lw	x9, 260(x2)                     # 4-byte Folded Reload
	lw	x18, 256(x2)                    # 4-byte Folded Reload
	lw	x19, 252(x2)                    # 4-byte Folded Reload
	lw	x20, 248(x2)                    # 4-byte Folded Reload
	lw	x21, 244(x2)                    # 4-byte Folded Reload
	lw	x22, 240(x2)                    # 4-byte Folded Reload
	lw	x23, 236(x2)                    # 4-byte Folded Reload
	lw	x24, 232(x2)                    # 4-byte Folded Reload
	lw	x25, 228(x2)                    # 4-byte Folded Reload
	lw	x26, 224(x2)                    # 4-byte Folded Reload
	lw	x27, 220(x2)                    # 4-byte Folded Reload
	addi	x2, x2, 272
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.option	pop
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"bert_tiny: BERT-tiny forward pass (TOKENS=%d HIDDEN=%d HEADS=%d FFN=%d LAYERS=%d CLASSES=%d)\n"
	.size	.L.str, 94

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
