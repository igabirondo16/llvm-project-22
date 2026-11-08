; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=riscv-xrepeat-unroll-jam \
; RUN:   -S < %s | FileCheck %s --check-prefixes=CHECK,COL
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=riscv-xrepeat-unroll-jam \
; RUN:   -riscv-xrepeat-unroll-jam=row -S < %s | FileCheck %s --check-prefixes=CHECK,ROW
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=riscv-xrepeat-unroll-jam \
; RUN:   -riscv-xrepeat-unroll-jam=off -S < %s | FileCheck %s --check-prefixes=CHECK,NONE
; RUN: opt -mtriple=riscv32 -mattr=+m,+f -passes=riscv-xrepeat-unroll-jam \
; RUN:   -S < %s | FileCheck %s --check-prefixes=CHECK,NONE
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -O2 -S < %s \
; RUN:   | FileCheck %s --check-prefix=O2

; The output loop of a matrix-vector product (an inner loop with one float
; reduction) is unrolled and jammed on the VRF core: by 16 (or 8) in column
; mode, with the inner loop marked as vectorized so that SLP vectorizes across
; the accumulators, by 4 in row mode, left to the loop vectorizer.

@X = global [64 x float] zeroinitializer
@W = global [32 x [64 x float]] zeroinitializer
@B = global [32 x float] zeroinitializer
@O = global [32 x float] zeroinitializer
@W24 = global [24 x [64 x float]] zeroinitializer
@O24 = global [24 x float] zeroinitializer
@I = global [32 x [64 x i32]] zeroinitializer
@OI = global [32 x i32] zeroinitializer

; 32 outputs: jammed by 16 (column) or 4 (row).
define void @dense() {
; CHECK-LABEL: @dense(
; COL:         inner:
; COL-COUNT-16:  call float @llvm.fmuladd.f32
; COL-NOT:       call float @llvm.fmuladd.f32
; COL:           br i1 {{.*}}, label %inner.exit, label %inner, !llvm.loop [[COLINNER:![0-9]+]]
; ROW:         inner:
; ROW-COUNT-4:   call float @llvm.fmuladd.f32
; ROW-NOT:       call float @llvm.fmuladd.f32
; NONE:        inner:
; NONE-COUNT-1:  call float @llvm.fmuladd.f32
; NONE-NOT:      call float @llvm.fmuladd.f32
; CHECK:       ret void
;
; O2-LABEL: @dense(
; O2:         [[W:%.*]] = {{.*}}call <8 x float> @llvm.experimental.vp.strided.load.v8f32.p0.i32(ptr {{.*}}, i32 256,
; O2:         call <8 x float> @llvm.fmuladd.v8f32(<8 x float> {{.*}}, <8 x float> [[W]],
; O2:         call <8 x float> @llvm.fmuladd.v8f32(
; O2-NOT:     call float @llvm.fmuladd.f32
; O2:         ret void
entry:
  br label %outer

outer:
  %o = phi i32 [ 0, %entry ], [ %o.next, %inner.exit ]
  %pb = getelementptr inbounds [32 x float], ptr @B, i32 0, i32 %o
  %init = load float, ptr %pb
  br label %inner

inner:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner ]
  %acc = phi float [ %init, %outer ], [ %acc.next, %inner ]
  %px = getelementptr inbounds [64 x float], ptr @X, i32 0, i32 %i
  %x = load float, ptr %px
  %pw = getelementptr inbounds [32 x [64 x float]], ptr @W, i32 0, i32 %o, i32 %i
  %w = load float, ptr %pw
  %acc.next = call float @llvm.fmuladd.f32(float %x, float %w, float %acc)
  %i.next = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next, 64
  br i1 %i.done, label %inner.exit, label %inner

inner.exit:
  %res = phi float [ %acc.next, %inner ]
  %po = getelementptr inbounds [32 x float], ptr @O, i32 0, i32 %o
  store float %res, ptr %po
  %o.next = add nuw nsw i32 %o, 1
  %o.done = icmp eq i32 %o.next, 32
  br i1 %o.done, label %exit, label %outer

exit:
  ret void
}

; 24 outputs: not a multiple of 16, jammed by 8 in column mode.
define void @dense24() {
; CHECK-LABEL: @dense24(
; COL:         inner:
; COL-COUNT-8:   call float @llvm.fmuladd.f32
; COL-NOT:       call float @llvm.fmuladd.f32
; ROW:         inner:
; ROW-COUNT-4:   call float @llvm.fmuladd.f32
; ROW-NOT:       call float @llvm.fmuladd.f32
; NONE:        inner:
; NONE-COUNT-1:  call float @llvm.fmuladd.f32
; NONE-NOT:      call float @llvm.fmuladd.f32
; CHECK:       ret void
entry:
  br label %outer

outer:
  %o = phi i32 [ 0, %entry ], [ %o.next, %inner.exit ]
  br label %inner

inner:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner ]
  %acc = phi float [ 0.0, %outer ], [ %acc.next, %inner ]
  %px = getelementptr inbounds [64 x float], ptr @X, i32 0, i32 %i
  %x = load float, ptr %px
  %pw = getelementptr inbounds [24 x [64 x float]], ptr @W24, i32 0, i32 %o, i32 %i
  %w = load float, ptr %pw
  %acc.next = call float @llvm.fmuladd.f32(float %x, float %w, float %acc)
  %i.next = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next, 64
  br i1 %i.done, label %inner.exit, label %inner

inner.exit:
  %res = phi float [ %acc.next, %inner ]
  %po = getelementptr inbounds [24 x float], ptr @O24, i32 0, i32 %o
  store float %res, ptr %po
  %o.next = add nuw nsw i32 %o, 1
  %o.done = icmp eq i32 %o.next, 24
  br i1 %o.done, label %exit, label %outer

exit:
  ret void
}

; An integer reduction is left alone (it can be reassociated, so the loop
; vectorizer handles it without help).
define void @idense() {
; CHECK-LABEL: @idense(
; CHECK:       inner:
; CHECK-COUNT-1: mul i32
; CHECK-NOT:     mul i32
; CHECK:       ret void
entry:
  br label %outer

outer:
  %o = phi i32 [ 0, %entry ], [ %o.next, %inner.exit ]
  br label %inner

inner:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner ]
  %acc = phi i32 [ 0, %outer ], [ %acc.next, %inner ]
  %pw = getelementptr inbounds [32 x [64 x i32]], ptr @I, i32 0, i32 %o, i32 %i
  %w = load i32, ptr %pw
  %m = mul i32 %w, %w
  %acc.next = add i32 %acc, %m
  %i.next = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next, 64
  br i1 %i.done, label %inner.exit, label %inner

inner.exit:
  %res = phi i32 [ %acc.next, %inner ]
  %po = getelementptr inbounds [32 x i32], ptr @OI, i32 0, i32 %o
  store i32 %res, ptr %po
  %o.next = add nuw nsw i32 %o, 1
  %o.done = icmp eq i32 %o.next, 32
  br i1 %o.done, label %exit, label %outer

exit:
  ret void
}

; 12 outputs: not a multiple of 8, left alone in column mode (a multiple of 4,
; jammed in row mode).
define void @dense12() {
; CHECK-LABEL: @dense12(
; COL:         inner:
; COL-COUNT-1:   call float @llvm.fmuladd.f32
; COL-NOT:       call float @llvm.fmuladd.f32
; ROW:         inner:
; ROW-COUNT-4:   call float @llvm.fmuladd.f32
; ROW-NOT:       call float @llvm.fmuladd.f32
; CHECK:       ret void
entry:
  br label %outer

outer:
  %o = phi i32 [ 0, %entry ], [ %o.next, %inner.exit ]
  br label %inner

inner:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner ]
  %acc = phi float [ 0.0, %outer ], [ %acc.next, %inner ]
  %px = getelementptr inbounds [64 x float], ptr @X, i32 0, i32 %i
  %x = load float, ptr %px
  %pw = getelementptr inbounds [32 x [64 x float]], ptr @W, i32 0, i32 %o, i32 %i
  %w = load float, ptr %pw
  %acc.next = call float @llvm.fmuladd.f32(float %x, float %w, float %acc)
  %i.next = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next, 64
  br i1 %i.done, label %inner.exit, label %inner

inner.exit:
  %res = phi float [ %acc.next, %inner ]
  %po = getelementptr inbounds [32 x float], ptr @O, i32 0, i32 %o
  store float %res, ptr %po
  %o.next = add nuw nsw i32 %o, 1
  %o.done = icmp eq i32 %o.next, 12
  br i1 %o.done, label %exit, label %outer

exit:
  ret void
}

; A store in the inner loop: left alone.
define void @dense_store() {
; CHECK-LABEL: @dense_store(
; CHECK:       inner:
; CHECK-COUNT-1: call float @llvm.fmuladd.f32
; CHECK-NOT:     call float @llvm.fmuladd.f32
; CHECK:       ret void
entry:
  br label %outer

outer:
  %o = phi i32 [ 0, %entry ], [ %o.next, %inner.exit ]
  br label %inner

inner:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner ]
  %acc = phi float [ 0.0, %outer ], [ %acc.next, %inner ]
  %px = getelementptr inbounds [64 x float], ptr @X, i32 0, i32 %i
  %x = load float, ptr %px
  %pw = getelementptr inbounds [32 x [64 x float]], ptr @W, i32 0, i32 %o, i32 %i
  %w = load float, ptr %pw
  %acc.next = call float @llvm.fmuladd.f32(float %x, float %w, float %acc)
  %po = getelementptr inbounds [32 x float], ptr @O, i32 0, i32 %o
  store float %acc.next, ptr %po
  %i.next = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next, 64
  br i1 %i.done, label %inner.exit, label %inner

inner.exit:
  %o.next = add nuw nsw i32 %o, 1
  %o.done = icmp eq i32 %o.next, 32
  br i1 %o.done, label %exit, label %outer

exit:
  ret void
}

; A convolution with its kernel loops unrolled: a sequence of inner loops, the
; accumulator flowing from one into the next. Every inner loop is jammed.
@IN = global [128 x float] zeroinitializer
@WC = global [32 x [128 x float]] zeroinitializer
@OC = global [32 x float] zeroinitializer

define void @conv2() {
; CHECK-LABEL: @conv2(
; COL:         inner1:
; COL-COUNT-16:  call float @llvm.fmuladd.f32
; COL-NOT:       call float @llvm.fmuladd.f32
; COL:           br i1 {{.*}}, label %mid, label %inner1, !llvm.loop [[L1:![0-9]+]]
; COL:         inner2:
; COL-COUNT-16:  call float @llvm.fmuladd.f32
; COL-NOT:       call float @llvm.fmuladd.f32
; COL:           br i1 {{.*}}, label %latch, label %inner2, !llvm.loop [[L2:![0-9]+]]
; COL:         latch:
; COL-COUNT-16:  store float
; COL:           icmp eq i32 {{.*}}, 32
; ROW:         inner1:
; ROW-COUNT-4:   call float @llvm.fmuladd.f32
; ROW-NOT:       call float @llvm.fmuladd.f32
; ROW:         inner2:
; ROW-COUNT-4:   call float @llvm.fmuladd.f32
; ROW-NOT:       call float @llvm.fmuladd.f32
; NONE:        inner1:
; NONE-COUNT-1:  call float @llvm.fmuladd.f32
; NONE:        inner2:
; NONE-COUNT-1:  call float @llvm.fmuladd.f32
; NONE-NOT:      call float @llvm.fmuladd.f32
; CHECK:       ret void
;
; O2-LABEL: @conv2(
; O2:         call <8 x float> @llvm.experimental.vp.strided.load.v8f32.p0.i32(ptr {{.*}}, i32 512,
; O2:         call <8 x float> @llvm.fmuladd.v8f32(
; O2:         call <8 x float> @llvm.experimental.vp.strided.load.v8f32.p0.i32(ptr {{.*}}, i32 512,
; O2:         call <8 x float> @llvm.fmuladd.v8f32(
; O2-NOT:     call float @llvm.fmuladd.f32
; O2:         ret void
entry:
  br label %outer

outer:
  %c = phi i32 [ 0, %entry ], [ %c.next, %latch ]
  %pb = getelementptr inbounds [32 x float], ptr @B, i32 0, i32 %c
  %init = load float, ptr %pb
  br label %inner1

inner1:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner1 ]
  %acc = phi float [ %init, %outer ], [ %acc.next, %inner1 ]
  %px = getelementptr inbounds [128 x float], ptr @IN, i32 0, i32 %i
  %x = load float, ptr %px
  %pw = getelementptr inbounds [32 x [128 x float]], ptr @WC, i32 0, i32 %c, i32 %i
  %w = load float, ptr %pw
  %acc.next = call float @llvm.fmuladd.f32(float %x, float %w, float %acc)
  %i.next = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next, 64
  br i1 %i.done, label %mid, label %inner1

mid:
  br label %inner2

inner2:
  %j = phi i32 [ 0, %mid ], [ %j.next, %inner2 ]
  %acc2 = phi float [ %acc.next, %mid ], [ %acc2.next, %inner2 ]
  %j64 = add nuw nsw i32 %j, 64
  %px2 = getelementptr inbounds [128 x float], ptr @IN, i32 0, i32 %j64
  %x2 = load float, ptr %px2
  %pw2 = getelementptr inbounds [32 x [128 x float]], ptr @WC, i32 0, i32 %c, i32 %j64
  %w2 = load float, ptr %pw2
  %acc2.next = call float @llvm.fmuladd.f32(float %x2, float %w2, float %acc2)
  %j.next = add nuw nsw i32 %j, 1
  %j.done = icmp eq i32 %j.next, 64
  br i1 %j.done, label %latch, label %inner2

latch:
  %v = fmul float %acc2.next, 5.000000e-01
  %po = getelementptr inbounds [32 x float], ptr @OC, i32 0, i32 %c
  store float %v, ptr %po
  %c.next = add nuw nsw i32 %c, 1
  %c.done = icmp eq i32 %c.next, 32
  br i1 %c.done, label %exit, label %outer

exit:
  ret void
}

; The same, but the result is stored into an array the inner loops read:
; jamming would move later outputs' loads above earlier outputs' stores.
define void @conv2_alias() {
; CHECK-LABEL: @conv2_alias(
; CHECK:       inner1:
; CHECK-COUNT-1: call float @llvm.fmuladd.f32
; CHECK:       inner2:
; CHECK-COUNT-1: call float @llvm.fmuladd.f32
; CHECK-NOT:     call float @llvm.fmuladd.f32
; CHECK:       ret void
entry:
  br label %outer

outer:
  %c = phi i32 [ 0, %entry ], [ %c.next, %latch ]
  br label %inner1

inner1:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner1 ]
  %acc = phi float [ 0.0, %outer ], [ %acc.next, %inner1 ]
  %px = getelementptr inbounds [128 x float], ptr @IN, i32 0, i32 %i
  %x = load float, ptr %px
  %pw = getelementptr inbounds [32 x [128 x float]], ptr @WC, i32 0, i32 %c, i32 %i
  %w = load float, ptr %pw
  %acc.next = call float @llvm.fmuladd.f32(float %x, float %w, float %acc)
  %i.next = add nuw nsw i32 %i, 1
  %i.done = icmp eq i32 %i.next, 64
  br i1 %i.done, label %mid, label %inner1

mid:
  br label %inner2

inner2:
  %j = phi i32 [ 0, %mid ], [ %j.next, %inner2 ]
  %acc2 = phi float [ %acc.next, %mid ], [ %acc2.next, %inner2 ]
  %px2 = getelementptr inbounds [128 x float], ptr @IN, i32 0, i32 %j
  %x2 = load float, ptr %px2
  %pw2 = getelementptr inbounds [32 x [128 x float]], ptr @WC, i32 0, i32 %c, i32 %j
  %w2 = load float, ptr %pw2
  %acc2.next = call float @llvm.fmuladd.f32(float %x2, float %w2, float %acc2)
  %j.next = add nuw nsw i32 %j, 1
  %j.done = icmp eq i32 %j.next, 64
  br i1 %j.done, label %latch, label %inner2

latch:
  %po = getelementptr inbounds [128 x float], ptr @IN, i32 0, i32 %c
  store float %acc2.next, ptr %po
  %c.next = add nuw nsw i32 %c, 1
  %c.done = icmp eq i32 %c.next, 32
  br i1 %c.done, label %exit, label %outer

exit:
  ret void
}

; An innermost output loop computing a whole dot product per iteration (the
; reduction fully unrolled, like resnet8's first convolution): cloned for 8
; outputs, and the chains vectorized by the pass itself (SLP has no seed: the
; stored values come out of a clamp). The x operands are hoisted scalars.
@W4 = global [16 x [5 x float]] zeroinitializer
@B16 = global [16 x float] zeroinitializer
@O16 = global [16 x float] zeroinitializer

define void @dot4(float %x0, float %x1, float %x2, float %x3, float %x4) {
; CHECK-LABEL: @dot4(
; COL:         loop:
; COL:           [[B:%.*]] = load <8 x float>, ptr
; COL:           [[W0:%.*]] = call <8 x float> @llvm.experimental.vp.strided.load.v8f32.p0.i32(ptr {{.*}}, i32 20,
; COL:           [[F0:%.*]] = call <8 x float> @llvm.fmuladd.v8f32(<8 x float> [[W0]], <8 x float> {{.*}}, <8 x float> [[B]])
; COL-COUNT-4:   call <8 x float> @llvm.fmuladd.v8f32(
; COL-NOT:       call float @llvm.fmuladd.f32
; COL-COUNT-8:   extractelement <8 x float>
; COL-COUNT-8:   store float
; COL:           icmp eq i32 {{.*}}, 16
; ROW:         loop:
; ROW-COUNT-5:   call float @llvm.fmuladd.f32
; ROW-NOT:       call float @llvm.fmuladd.f32
; NONE:        loop:
; NONE-COUNT-5:  call float @llvm.fmuladd.f32
; NONE-NOT:      call float @llvm.fmuladd.f32
; CHECK:       ret void
entry:
  br label %loop

loop:
  %c = phi i32 [ 0, %entry ], [ %c.next, %loop ]
  %pb = getelementptr inbounds [16 x float], ptr @B16, i32 0, i32 %c
  %b = load float, ptr %pb
  %pw0 = getelementptr inbounds [16 x [5 x float]], ptr @W4, i32 0, i32 %c, i32 0
  %w0 = load float, ptr %pw0
  %a0 = call float @llvm.fmuladd.f32(float %w0, float %x0, float %b)
  %pw1 = getelementptr inbounds [16 x [5 x float]], ptr @W4, i32 0, i32 %c, i32 1
  %w1 = load float, ptr %pw1
  %a1 = call float @llvm.fmuladd.f32(float %w1, float %x1, float %a0)
  %pw2 = getelementptr inbounds [16 x [5 x float]], ptr @W4, i32 0, i32 %c, i32 2
  %w2 = load float, ptr %pw2
  %a2 = call float @llvm.fmuladd.f32(float %w2, float %x2, float %a1)
  %pw3 = getelementptr inbounds [16 x [5 x float]], ptr @W4, i32 0, i32 %c, i32 3
  %w3 = load float, ptr %pw3
  %a3 = call float @llvm.fmuladd.f32(float %w3, float %x3, float %a2)
  %pw4 = getelementptr inbounds [16 x [5 x float]], ptr @W4, i32 0, i32 %c, i32 4
  %w4 = load float, ptr %pw4
  %a4 = call float @llvm.fmuladd.f32(float %w4, float %x4, float %a3)
  %v = fmul float %a4, 1.250000e-01
  %neg = fcmp olt float %v, 0.000000e+00
  %relu = select i1 %neg, float 0.000000e+00, float %v
  %po = getelementptr inbounds [16 x float], ptr @O16, i32 0, i32 %c
  store float %relu, ptr %po
  %c.next = add nuw nsw i32 %c, 1
  %c.done = icmp eq i32 %c.next, 16
  br i1 %c.done, label %exit, label %loop

exit:
  ret void
}

; COL: [[COLINNER]] = distinct !{[[COLINNER]], [[ISVEC:![0-9]+]]}
; COL: [[ISVEC]] = !{!"llvm.loop.isvectorized", i32 1}
; COL: [[L1]] = distinct !{[[L1]], [[ISVEC]]}
; COL: [[L2]] = distinct !{[[L2]], [[ISVEC]]}
; ROW-NOT: llvm.loop.isvectorized

declare float @llvm.fmuladd.f32(float, float, float)
