; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=loop-vectorize -S < %s \
; RUN:   | FileCheck %s

; XRepeat (VRF core): loops are vectorized into blocks of F registers, VF = 8
; or 16 (i32 and float), without interleaving.

; Two vector streams: VF = 8 (two 16-wide vectors would fill the F registers,
; see getNumberOfRegisters). The splat of %s is sunk next to its user, where
; it is a single F register (CodeGenPrepare, isProfitableToSinkOperands).
; CHECK-LABEL: @axpy(
; CHECK:       vector.body:
; CHECK:         load <8 x i32>
; CHECK:         mul nsw <8 x i32>
; CHECK:         load <8 x i32>
; CHECK:         add nsw <8 x i32>
; CHECK:         store <8 x i32>
; CHECK-NOT:   <16 x i32>
define void @axpy(ptr noalias %a, ptr noalias %b, ptr noalias %c, i32 %s, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb
  %m = mul nsw i32 %vb, %s
  %pc = getelementptr inbounds i32, ptr %c, i32 %i
  %vc = load i32, ptr %pc
  %r = add nsw i32 %m, %vc
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  store i32 %r, ptr %pa
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; A dot product is reduced in the loop into a scalar accumulator (one xr.mac
; with the accumulator fixed, REPEAT mask 0110), as on the GPR core.
; CHECK-LABEL: @dot(
; CHECK:       vector.body:
; CHECK:         [[ACC:%vec.phi]] = phi i32
; CHECK:         load <8 x i32>
; CHECK:         load <8 x i32>
; CHECK:         [[M:%.*]] = mul nsw <8 x i32>
; CHECK:         [[R:%.*]] = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> [[M]])
; CHECK:         add i32 [[ACC]], [[R]]
; CHECK:       middle.block:
define i32 @dot(ptr %a, ptr %b, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc1, %loop ]
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  %va = load i32, ptr %pa
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb
  %m = mul nsw i32 %va, %vb
  %acc1 = add nsw i32 %m, %acc
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret i32 %acc1
}

; One vector stream: VF = 16 (a 16-wide block plus scalars fits).
; CHECK-LABEL: @scale(
; CHECK:       vector.body:
; CHECK:         load <16 x i32>
; CHECK:         mul nsw <16 x i32>
; CHECK:         add nsw <16 x i32>
; CHECK:         store <16 x i32>
define void @scale(ptr noalias %a, i32 %s, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  %va = load i32, ptr %pa
  %m = mul nsw i32 %va, %s
  %r = add nsw i32 %m, 1
  store i32 %r, ptr %pa
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; Float: fmuladd is fmadd.s + REPEAT.
; CHECK-LABEL: @faxpy(
; CHECK:       vector.body:
; CHECK:         call <8 x float> @llvm.fmuladd.v8f32(
; CHECK:         store <8 x float>
define void @faxpy(ptr noalias %a, ptr noalias %b, float %s, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds float, ptr %b, i32 %i
  %vb = load float, ptr %pb
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %r = call float @llvm.fmuladd.f32(float %vb, float %s, float %va)
  store float %r, ptr %pa
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; An ordered float sum stays in the loop and in order: fadd.s into one F
; register, the block walking.
; CHECK-LABEL: @fsum(
; CHECK:       vector.body:
; CHECK:         [[ACC:%.*]] = phi float
; CHECK:         [[V:%.*]] = load <16 x float>
; CHECK:         call float @llvm.vector.reduce.fadd.v16f32(float [[ACC]], <16 x float> [[V]])
define float @fsum(ptr %a, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %acc = phi float [ 0.0, %entry ], [ %acc1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %acc1 = fadd float %acc, %va
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret float %acc1
}

; No vector division: the loop stays scalar.
; CHECK-LABEL: @div(
; CHECK-NOT:   <{{[0-9]+}} x i32>
; CHECK:       ret void
define void @div(ptr noalias %a, ptr noalias %b, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  %va = load i32, ptr %pa
  %r = sdiv i32 %va, %vb
  store i32 %r, ptr %pa
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; Only i32 and float blocks: i16 stays scalar.
; CHECK-LABEL: @i16(
; CHECK-NOT:   <{{[0-9]+}} x i16>
; CHECK:       ret void
define void @i16(ptr noalias %a, ptr noalias %b, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds i16, ptr %b, i32 %i
  %vb = load i16, ptr %pb
  %pa = getelementptr inbounds i16, ptr %a, i32 %i
  %va = load i16, ptr %pa
  %r = add i16 %va, %vb
  store i16 %r, ptr %pa
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}


; An ordered float dot product (llvm.fmuladd, no fast-math): the fmul and the
; in-order reduction are marked `contract` (preferFusedFMulAddReduction), as
; llvm.fmuladd allows, so the backend can fuse them into one fmadd.s + REPEAT.
; CHECK-LABEL: @fdot(
; CHECK:       vector.body:
; CHECK:         [[M:%.*]] = fmul contract <8 x float>
; CHECK:         call contract float @llvm.vector.reduce.fadd.v8f32(float %{{.*}}, <8 x float> [[M]])
define float @fdot(ptr %a, ptr %b, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %acc = phi float [ 0.0, %entry ], [ %acc1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %pb = getelementptr inbounds float, ptr %b, i32 %i
  %vb = load float, ptr %pb
  %acc1 = call float @llvm.fmuladd.f32(float %va, float %vb, float %acc)
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret float %acc1
}

; Interleave groups: each field is a strided flw/fsw + REPEAT (see
; lowerXRepeatInterleaved{Load,Store}), so both the factor-2 load group and
; the factor-2 store group are vectorized at VF 8.
; CHECK-LABEL: @cmag(
; CHECK:       vector.body:
; CHECK:         [[W:%.*]] = load <16 x i32>
; CHECK:         shufflevector <16 x i32> [[W]], <16 x i32> poison, <8 x i32> <i32 0, i32 2,
; CHECK:         shufflevector <16 x i32> [[W]], <16 x i32> poison, <8 x i32> <i32 1, i32 3,
define void @cmag(ptr noalias %o, ptr noalias %c, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %i2 = shl nuw nsw i32 %i, 1
  %pre = getelementptr inbounds i32, ptr %c, i32 %i2
  %re = load i32, ptr %pre
  %i2b = or disjoint i32 %i2, 1
  %pim = getelementptr inbounds i32, ptr %c, i32 %i2b
  %im = load i32, ptr %pim
  %r2 = mul nsw i32 %re, %re
  %m2 = mul nsw i32 %im, %im
  %s = add nsw i32 %r2, %m2
  %po = getelementptr inbounds i32, ptr %o, i32 %i
  store i32 %s, ptr %po
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; CHECK-LABEL: @ilv(
; CHECK:       vector.body:
; CHECK:         [[I:%.*]] = shufflevector <16 x float> %{{.*}}, <16 x float> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9,
; CHECK:         store <16 x float> [[I]]
define void @ilv(ptr noalias %o, ptr noalias %a, ptr noalias %b, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %pb = getelementptr inbounds float, ptr %b, i32 %i
  %vb = load float, ptr %pb
  %s = fadd float %va, %vb
  %m = fmul float %va, %vb
  %i2 = shl nuw nsw i32 %i, 1
  %p0 = getelementptr inbounds float, ptr %o, i32 %i2
  store float %s, ptr %p0
  %i2b = or disjoint i32 %i2, 1
  %p1 = getelementptr inbounds float, ptr %o, i32 %i2b
  store float %m, ptr %p1
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; A clamp (what RISCVXRepeatFMinMaxPass makes of exact compare + select
; clamps): fmin.s/fmax.s + REPEAT, so it is vectorized.
; CHECK-LABEL: @clamp(
; CHECK:       vector.body:
; CHECK:         [[LO:%.*]] = call <16 x float> @llvm.maximumnum.v16f32(<16 x float> %{{.*}}, <16 x float> splat (float -1.280000e+02))
; CHECK:         call <16 x float> @llvm.minimumnum.v16f32(<16 x float> [[LO]], <16 x float> splat (float 1.270000e+02))
define void @clamp(ptr noalias %a, ptr noalias %b, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %lo = call float @llvm.maximumnum.f32(float %va, float -128.0)
  %hi = call float @llvm.minimumnum.f32(float %lo, float 127.0)
  %pb = getelementptr inbounds float, ptr %b, i32 %i
  store float %hi, ptr %pb
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}
