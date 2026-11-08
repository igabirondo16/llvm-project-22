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

; COL: [[COLINNER]] = distinct !{[[COLINNER]], [[ISVEC:![0-9]+]]}
; COL: [[ISVEC]] = !{!"llvm.loop.isvectorized", i32 1}
; ROW-NOT: llvm.loop.isvectorized

declare float @llvm.fmuladd.f32(float, float, float)
