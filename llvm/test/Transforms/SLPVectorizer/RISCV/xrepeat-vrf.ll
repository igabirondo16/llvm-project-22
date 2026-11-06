; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=slp-vectorizer -S < %s \
; RUN:   | FileCheck %s

; XRepeat (VRF core): SLP builds 8-wide trees of i32 or float (it doesn't
; check register pressure, and a 16-wide tree with two vectors and a scalar
; doesn't fit in the F registers), so 16 floats are two 8-wide trees.

; CHECK-LABEL: @i8x(
; CHECK:         load <8 x i32>
; CHECK:         load <8 x i32>
; CHECK:         mul <8 x i32>
; CHECK:         add <8 x i32>
; CHECK:         store <8 x i32>
define void @i8x(ptr noalias %a, ptr noalias %b, i32 %s) {
  %pb0 = getelementptr inbounds i32, ptr %b, i32 0
  %b0 = load i32, ptr %pb0
  %pa0 = getelementptr inbounds i32, ptr %a, i32 0
  %a0 = load i32, ptr %pa0
  %m0 = mul i32 %b0, %s
  %r0 = add i32 %m0, %a0
  store i32 %r0, ptr %pa0
  %pb1 = getelementptr inbounds i32, ptr %b, i32 1
  %b1 = load i32, ptr %pb1
  %pa1 = getelementptr inbounds i32, ptr %a, i32 1
  %a1 = load i32, ptr %pa1
  %m1 = mul i32 %b1, %s
  %r1 = add i32 %m1, %a1
  store i32 %r1, ptr %pa1
  %pb2 = getelementptr inbounds i32, ptr %b, i32 2
  %b2 = load i32, ptr %pb2
  %pa2 = getelementptr inbounds i32, ptr %a, i32 2
  %a2 = load i32, ptr %pa2
  %m2 = mul i32 %b2, %s
  %r2 = add i32 %m2, %a2
  store i32 %r2, ptr %pa2
  %pb3 = getelementptr inbounds i32, ptr %b, i32 3
  %b3 = load i32, ptr %pb3
  %pa3 = getelementptr inbounds i32, ptr %a, i32 3
  %a3 = load i32, ptr %pa3
  %m3 = mul i32 %b3, %s
  %r3 = add i32 %m3, %a3
  store i32 %r3, ptr %pa3
  %pb4 = getelementptr inbounds i32, ptr %b, i32 4
  %b4 = load i32, ptr %pb4
  %pa4 = getelementptr inbounds i32, ptr %a, i32 4
  %a4 = load i32, ptr %pa4
  %m4 = mul i32 %b4, %s
  %r4 = add i32 %m4, %a4
  store i32 %r4, ptr %pa4
  %pb5 = getelementptr inbounds i32, ptr %b, i32 5
  %b5 = load i32, ptr %pb5
  %pa5 = getelementptr inbounds i32, ptr %a, i32 5
  %a5 = load i32, ptr %pa5
  %m5 = mul i32 %b5, %s
  %r5 = add i32 %m5, %a5
  store i32 %r5, ptr %pa5
  %pb6 = getelementptr inbounds i32, ptr %b, i32 6
  %b6 = load i32, ptr %pb6
  %pa6 = getelementptr inbounds i32, ptr %a, i32 6
  %a6 = load i32, ptr %pa6
  %m6 = mul i32 %b6, %s
  %r6 = add i32 %m6, %a6
  store i32 %r6, ptr %pa6
  %pb7 = getelementptr inbounds i32, ptr %b, i32 7
  %b7 = load i32, ptr %pb7
  %pa7 = getelementptr inbounds i32, ptr %a, i32 7
  %a7 = load i32, ptr %pa7
  %m7 = mul i32 %b7, %s
  %r7 = add i32 %m7, %a7
  store i32 %r7, ptr %pa7
  ret void
}

; CHECK-LABEL: @f16x(
; CHECK-COUNT-2: fmul <8 x float>
; CHECK-NOT:     <16 x float>
; CHECK:         ret void
define void @f16x(ptr noalias %a, ptr noalias %b, float %s) {
  %pb0 = getelementptr inbounds float, ptr %b, i32 0
  %b0 = load float, ptr %pb0
  %pa0 = getelementptr inbounds float, ptr %a, i32 0
  %a0 = load float, ptr %pa0
  %m0 = fmul float %b0, %s
  %r0 = fadd float %m0, %a0
  store float %r0, ptr %pa0
  %pb1 = getelementptr inbounds float, ptr %b, i32 1
  %b1 = load float, ptr %pb1
  %pa1 = getelementptr inbounds float, ptr %a, i32 1
  %a1 = load float, ptr %pa1
  %m1 = fmul float %b1, %s
  %r1 = fadd float %m1, %a1
  store float %r1, ptr %pa1
  %pb2 = getelementptr inbounds float, ptr %b, i32 2
  %b2 = load float, ptr %pb2
  %pa2 = getelementptr inbounds float, ptr %a, i32 2
  %a2 = load float, ptr %pa2
  %m2 = fmul float %b2, %s
  %r2 = fadd float %m2, %a2
  store float %r2, ptr %pa2
  %pb3 = getelementptr inbounds float, ptr %b, i32 3
  %b3 = load float, ptr %pb3
  %pa3 = getelementptr inbounds float, ptr %a, i32 3
  %a3 = load float, ptr %pa3
  %m3 = fmul float %b3, %s
  %r3 = fadd float %m3, %a3
  store float %r3, ptr %pa3
  %pb4 = getelementptr inbounds float, ptr %b, i32 4
  %b4 = load float, ptr %pb4
  %pa4 = getelementptr inbounds float, ptr %a, i32 4
  %a4 = load float, ptr %pa4
  %m4 = fmul float %b4, %s
  %r4 = fadd float %m4, %a4
  store float %r4, ptr %pa4
  %pb5 = getelementptr inbounds float, ptr %b, i32 5
  %b5 = load float, ptr %pb5
  %pa5 = getelementptr inbounds float, ptr %a, i32 5
  %a5 = load float, ptr %pa5
  %m5 = fmul float %b5, %s
  %r5 = fadd float %m5, %a5
  store float %r5, ptr %pa5
  %pb6 = getelementptr inbounds float, ptr %b, i32 6
  %b6 = load float, ptr %pb6
  %pa6 = getelementptr inbounds float, ptr %a, i32 6
  %a6 = load float, ptr %pa6
  %m6 = fmul float %b6, %s
  %r6 = fadd float %m6, %a6
  store float %r6, ptr %pa6
  %pb7 = getelementptr inbounds float, ptr %b, i32 7
  %b7 = load float, ptr %pb7
  %pa7 = getelementptr inbounds float, ptr %a, i32 7
  %a7 = load float, ptr %pa7
  %m7 = fmul float %b7, %s
  %r7 = fadd float %m7, %a7
  store float %r7, ptr %pa7
  %pb8 = getelementptr inbounds float, ptr %b, i32 8
  %b8 = load float, ptr %pb8
  %pa8 = getelementptr inbounds float, ptr %a, i32 8
  %a8 = load float, ptr %pa8
  %m8 = fmul float %b8, %s
  %r8 = fadd float %m8, %a8
  store float %r8, ptr %pa8
  %pb9 = getelementptr inbounds float, ptr %b, i32 9
  %b9 = load float, ptr %pb9
  %pa9 = getelementptr inbounds float, ptr %a, i32 9
  %a9 = load float, ptr %pa9
  %m9 = fmul float %b9, %s
  %r9 = fadd float %m9, %a9
  store float %r9, ptr %pa9
  %pb10 = getelementptr inbounds float, ptr %b, i32 10
  %b10 = load float, ptr %pb10
  %pa10 = getelementptr inbounds float, ptr %a, i32 10
  %a10 = load float, ptr %pa10
  %m10 = fmul float %b10, %s
  %r10 = fadd float %m10, %a10
  store float %r10, ptr %pa10
  %pb11 = getelementptr inbounds float, ptr %b, i32 11
  %b11 = load float, ptr %pb11
  %pa11 = getelementptr inbounds float, ptr %a, i32 11
  %a11 = load float, ptr %pa11
  %m11 = fmul float %b11, %s
  %r11 = fadd float %m11, %a11
  store float %r11, ptr %pa11
  %pb12 = getelementptr inbounds float, ptr %b, i32 12
  %b12 = load float, ptr %pb12
  %pa12 = getelementptr inbounds float, ptr %a, i32 12
  %a12 = load float, ptr %pa12
  %m12 = fmul float %b12, %s
  %r12 = fadd float %m12, %a12
  store float %r12, ptr %pa12
  %pb13 = getelementptr inbounds float, ptr %b, i32 13
  %b13 = load float, ptr %pb13
  %pa13 = getelementptr inbounds float, ptr %a, i32 13
  %a13 = load float, ptr %pa13
  %m13 = fmul float %b13, %s
  %r13 = fadd float %m13, %a13
  store float %r13, ptr %pa13
  %pb14 = getelementptr inbounds float, ptr %b, i32 14
  %b14 = load float, ptr %pb14
  %pa14 = getelementptr inbounds float, ptr %a, i32 14
  %a14 = load float, ptr %pa14
  %m14 = fmul float %b14, %s
  %r14 = fadd float %m14, %a14
  store float %r14, ptr %pa14
  %pb15 = getelementptr inbounds float, ptr %b, i32 15
  %b15 = load float, ptr %pb15
  %pa15 = getelementptr inbounds float, ptr %a, i32 15
  %a15 = load float, ptr %pa15
  %m15 = fmul float %b15, %s
  %r15 = fadd float %m15, %a15
  store float %r15, ptr %pa15
  ret void
}

; Four elements are not a whole block: scalar.
; CHECK-LABEL: @i4x(
; CHECK-NOT:     <4 x i32>
; CHECK:         ret void
define void @i4x(ptr noalias %a, ptr noalias %b, i32 %s) {
  %pb0 = getelementptr inbounds i32, ptr %b, i32 0
  %b0 = load i32, ptr %pb0
  %pa0 = getelementptr inbounds i32, ptr %a, i32 0
  %a0 = load i32, ptr %pa0
  %m0 = mul i32 %b0, %s
  %r0 = add i32 %m0, %a0
  store i32 %r0, ptr %pa0
  %pb1 = getelementptr inbounds i32, ptr %b, i32 1
  %b1 = load i32, ptr %pb1
  %pa1 = getelementptr inbounds i32, ptr %a, i32 1
  %a1 = load i32, ptr %pa1
  %m1 = mul i32 %b1, %s
  %r1 = add i32 %m1, %a1
  store i32 %r1, ptr %pa1
  %pb2 = getelementptr inbounds i32, ptr %b, i32 2
  %b2 = load i32, ptr %pb2
  %pa2 = getelementptr inbounds i32, ptr %a, i32 2
  %a2 = load i32, ptr %pa2
  %m2 = mul i32 %b2, %s
  %r2 = add i32 %m2, %a2
  store i32 %r2, ptr %pa2
  %pb3 = getelementptr inbounds i32, ptr %b, i32 3
  %b3 = load i32, ptr %pb3
  %pa3 = getelementptr inbounds i32, ptr %a, i32 3
  %a3 = load i32, ptr %pa3
  %m3 = mul i32 %b3, %s
  %r3 = add i32 %m3, %a3
  store i32 %r3, ptr %pa3
  ret void
}

; A column (stride 64 bytes) is a strided load, flw + REPEAT with the stride
; register.
; CHECK-LABEL: @col(
; CHECK:         call <8 x i32> @llvm.experimental.vp.strided.load.v8i32.p0.i32(ptr align 4 %m, i32 64,
define void @col(ptr noalias %o, ptr noalias %m) {
  %p1 = getelementptr inbounds i32, ptr %m, i32 16
  %p2 = getelementptr inbounds i32, ptr %m, i32 32
  %p3 = getelementptr inbounds i32, ptr %m, i32 48
  %p4 = getelementptr inbounds i32, ptr %m, i32 64
  %p5 = getelementptr inbounds i32, ptr %m, i32 80
  %p6 = getelementptr inbounds i32, ptr %m, i32 96
  %p7 = getelementptr inbounds i32, ptr %m, i32 112
  %v0 = load i32, ptr %m
  %v1 = load i32, ptr %p1
  %v2 = load i32, ptr %p2
  %v3 = load i32, ptr %p3
  %v4 = load i32, ptr %p4
  %v5 = load i32, ptr %p5
  %v6 = load i32, ptr %p6
  %v7 = load i32, ptr %p7
  %a0 = add i32 %v0, 1
  %a1 = add i32 %v1, 1
  %a2 = add i32 %v2, 1
  %a3 = add i32 %v3, 1
  %a4 = add i32 %v4, 1
  %a5 = add i32 %v5, 1
  %a6 = add i32 %v6, 1
  %a7 = add i32 %v7, 1
  %o1 = getelementptr inbounds i32, ptr %o, i32 1
  %o2 = getelementptr inbounds i32, ptr %o, i32 2
  %o3 = getelementptr inbounds i32, ptr %o, i32 3
  %o4 = getelementptr inbounds i32, ptr %o, i32 4
  %o5 = getelementptr inbounds i32, ptr %o, i32 5
  %o6 = getelementptr inbounds i32, ptr %o, i32 6
  %o7 = getelementptr inbounds i32, ptr %o, i32 7
  store i32 %a0, ptr %o
  store i32 %a1, ptr %o1
  store i32 %a2, ptr %o2
  store i32 %a3, ptr %o3
  store i32 %a4, ptr %o4
  store i32 %a5, ptr %o5
  store i32 %a6, ptr %o6
  store i32 %a7, ptr %o7
  ret void
}

; Stores in reverse order are a strided store with stride -4 (fsw + REPEAT).
; CHECK-LABEL: @rev(
; CHECK:         call void @llvm.experimental.vp.strided.store.v8i32.p0.i32(<8 x i32> %{{.*}}, ptr align 4 %{{.*}}, i32 -4,
define void @rev(ptr noalias %d, ptr noalias %a) {
  %a1p = getelementptr inbounds i32, ptr %a, i32 1
  %a2p = getelementptr inbounds i32, ptr %a, i32 2
  %a3p = getelementptr inbounds i32, ptr %a, i32 3
  %a4p = getelementptr inbounds i32, ptr %a, i32 4
  %a5p = getelementptr inbounds i32, ptr %a, i32 5
  %a6p = getelementptr inbounds i32, ptr %a, i32 6
  %a7p = getelementptr inbounds i32, ptr %a, i32 7
  %v0 = load i32, ptr %a
  %v1 = load i32, ptr %a1p
  %v2 = load i32, ptr %a2p
  %v3 = load i32, ptr %a3p
  %v4 = load i32, ptr %a4p
  %v5 = load i32, ptr %a5p
  %v6 = load i32, ptr %a6p
  %v7 = load i32, ptr %a7p
  %x0 = add i32 %v0, 1
  %x1 = add i32 %v1, 1
  %x2 = add i32 %v2, 1
  %x3 = add i32 %v3, 1
  %x4 = add i32 %v4, 1
  %x5 = add i32 %v5, 1
  %x6 = add i32 %v6, 1
  %x7 = add i32 %v7, 1
  %d1 = getelementptr inbounds i32, ptr %d, i32 1
  %d2 = getelementptr inbounds i32, ptr %d, i32 2
  %d3 = getelementptr inbounds i32, ptr %d, i32 3
  %d4 = getelementptr inbounds i32, ptr %d, i32 4
  %d5 = getelementptr inbounds i32, ptr %d, i32 5
  %d6 = getelementptr inbounds i32, ptr %d, i32 6
  %d7 = getelementptr inbounds i32, ptr %d, i32 7
  store i32 %x0, ptr %d7
  store i32 %x1, ptr %d6
  store i32 %x2, ptr %d5
  store i32 %x3, ptr %d4
  store i32 %x4, ptr %d3
  store i32 %x5, ptr %d2
  store i32 %x6, ptr %d1
  store i32 %x7, ptr %d
  ret void
}

; 16 products summed: SLP reduces them as two 8-wide halves. (A 16-wide
; multiply of two vectors has a large valid cost, not an invalid one, so SLP
; retries at 8 instead of giving up on the reduction.)
; CHECK-LABEL: @dot16x(
; CHECK:         mul nsw <8 x i32>
; CHECK:         mul nsw <8 x i32>
; CHECK:         call i32 @llvm.vector.reduce.add.v8i32(
define i32 @dot16x(ptr noundef readonly captures(none) %w, ptr noundef readonly captures(none) %x, i32 noundef %acc) {
entry:
  %0 = load i32, ptr %w, align 4
  %1 = load i32, ptr %x, align 4
  %mul = mul nsw i32 %1, %0
  %add = add nsw i32 %mul, %acc
  %arrayidx.1 = getelementptr inbounds nuw i8, ptr %w, i32 4
  %2 = load i32, ptr %arrayidx.1, align 4
  %arrayidx1.1 = getelementptr inbounds nuw i8, ptr %x, i32 4
  %3 = load i32, ptr %arrayidx1.1, align 4
  %mul.1 = mul nsw i32 %3, %2
  %add.1 = add nsw i32 %mul.1, %add
  %arrayidx.2 = getelementptr inbounds nuw i8, ptr %w, i32 8
  %4 = load i32, ptr %arrayidx.2, align 4
  %arrayidx1.2 = getelementptr inbounds nuw i8, ptr %x, i32 8
  %5 = load i32, ptr %arrayidx1.2, align 4
  %mul.2 = mul nsw i32 %5, %4
  %add.2 = add nsw i32 %mul.2, %add.1
  %arrayidx.3 = getelementptr inbounds nuw i8, ptr %w, i32 12
  %6 = load i32, ptr %arrayidx.3, align 4
  %arrayidx1.3 = getelementptr inbounds nuw i8, ptr %x, i32 12
  %7 = load i32, ptr %arrayidx1.3, align 4
  %mul.3 = mul nsw i32 %7, %6
  %add.3 = add nsw i32 %mul.3, %add.2
  %arrayidx.4 = getelementptr inbounds nuw i8, ptr %w, i32 16
  %8 = load i32, ptr %arrayidx.4, align 4
  %arrayidx1.4 = getelementptr inbounds nuw i8, ptr %x, i32 16
  %9 = load i32, ptr %arrayidx1.4, align 4
  %mul.4 = mul nsw i32 %9, %8
  %add.4 = add nsw i32 %mul.4, %add.3
  %arrayidx.5 = getelementptr inbounds nuw i8, ptr %w, i32 20
  %10 = load i32, ptr %arrayidx.5, align 4
  %arrayidx1.5 = getelementptr inbounds nuw i8, ptr %x, i32 20
  %11 = load i32, ptr %arrayidx1.5, align 4
  %mul.5 = mul nsw i32 %11, %10
  %add.5 = add nsw i32 %mul.5, %add.4
  %arrayidx.6 = getelementptr inbounds nuw i8, ptr %w, i32 24
  %12 = load i32, ptr %arrayidx.6, align 4
  %arrayidx1.6 = getelementptr inbounds nuw i8, ptr %x, i32 24
  %13 = load i32, ptr %arrayidx1.6, align 4
  %mul.6 = mul nsw i32 %13, %12
  %add.6 = add nsw i32 %mul.6, %add.5
  %arrayidx.7 = getelementptr inbounds nuw i8, ptr %w, i32 28
  %14 = load i32, ptr %arrayidx.7, align 4
  %arrayidx1.7 = getelementptr inbounds nuw i8, ptr %x, i32 28
  %15 = load i32, ptr %arrayidx1.7, align 4
  %mul.7 = mul nsw i32 %15, %14
  %add.7 = add nsw i32 %mul.7, %add.6
  %arrayidx.8 = getelementptr inbounds nuw i8, ptr %w, i32 32
  %16 = load i32, ptr %arrayidx.8, align 4
  %arrayidx1.8 = getelementptr inbounds nuw i8, ptr %x, i32 32
  %17 = load i32, ptr %arrayidx1.8, align 4
  %mul.8 = mul nsw i32 %17, %16
  %add.8 = add nsw i32 %mul.8, %add.7
  %arrayidx.9 = getelementptr inbounds nuw i8, ptr %w, i32 36
  %18 = load i32, ptr %arrayidx.9, align 4
  %arrayidx1.9 = getelementptr inbounds nuw i8, ptr %x, i32 36
  %19 = load i32, ptr %arrayidx1.9, align 4
  %mul.9 = mul nsw i32 %19, %18
  %add.9 = add nsw i32 %mul.9, %add.8
  %arrayidx.10 = getelementptr inbounds nuw i8, ptr %w, i32 40
  %20 = load i32, ptr %arrayidx.10, align 4
  %arrayidx1.10 = getelementptr inbounds nuw i8, ptr %x, i32 40
  %21 = load i32, ptr %arrayidx1.10, align 4
  %mul.10 = mul nsw i32 %21, %20
  %add.10 = add nsw i32 %mul.10, %add.9
  %arrayidx.11 = getelementptr inbounds nuw i8, ptr %w, i32 44
  %22 = load i32, ptr %arrayidx.11, align 4
  %arrayidx1.11 = getelementptr inbounds nuw i8, ptr %x, i32 44
  %23 = load i32, ptr %arrayidx1.11, align 4
  %mul.11 = mul nsw i32 %23, %22
  %add.11 = add nsw i32 %mul.11, %add.10
  %arrayidx.12 = getelementptr inbounds nuw i8, ptr %w, i32 48
  %24 = load i32, ptr %arrayidx.12, align 4
  %arrayidx1.12 = getelementptr inbounds nuw i8, ptr %x, i32 48
  %25 = load i32, ptr %arrayidx1.12, align 4
  %mul.12 = mul nsw i32 %25, %24
  %add.12 = add nsw i32 %mul.12, %add.11
  %arrayidx.13 = getelementptr inbounds nuw i8, ptr %w, i32 52
  %26 = load i32, ptr %arrayidx.13, align 4
  %arrayidx1.13 = getelementptr inbounds nuw i8, ptr %x, i32 52
  %27 = load i32, ptr %arrayidx1.13, align 4
  %mul.13 = mul nsw i32 %27, %26
  %add.13 = add nsw i32 %mul.13, %add.12
  %arrayidx.14 = getelementptr inbounds nuw i8, ptr %w, i32 56
  %28 = load i32, ptr %arrayidx.14, align 4
  %arrayidx1.14 = getelementptr inbounds nuw i8, ptr %x, i32 56
  %29 = load i32, ptr %arrayidx1.14, align 4
  %mul.14 = mul nsw i32 %29, %28
  %add.14 = add nsw i32 %mul.14, %add.13
  %arrayidx.15 = getelementptr inbounds nuw i8, ptr %w, i32 60
  %30 = load i32, ptr %arrayidx.15, align 4
  %arrayidx1.15 = getelementptr inbounds nuw i8, ptr %x, i32 60
  %31 = load i32, ptr %arrayidx1.15, align 4
  %mul.15 = mul nsw i32 %31, %30
  %add.15 = add nsw i32 %mul.15, %add.14
  ret i32 %add.15
}
