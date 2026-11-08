; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=riscv-xrepeat-loop-fusion \
; RUN:   -S < %s | FileCheck %s --check-prefix=FUSED
; RUN: opt -mtriple=riscv32 -mattr=+m,+f -passes=riscv-xrepeat-loop-fusion \
; RUN:   -S < %s | FileCheck %s --check-prefix=KEPT
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=riscv-xrepeat-loop-fusion \
; RUN:   -riscv-xrepeat-loop-fusion=false -S < %s | FileCheck %s --check-prefix=KEPT
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes='default<O2>' \
; RUN:   -S < %s | FileCheck %s --check-prefix=O2

; XRepeat (VRF core): dotxvf, y[u] = A[u] . x for 4 rows, after the early full
; unroll of the u loop: four k loops that each load x[k]. Right before the
; vectorizers, riscv-xrepeat-loop-fusion fuses them (LoopFuse), merges their
; induction variables (indvars) and the four loads of x[k] (GVN): one k loop
; with four accumulators and one load of x. Without XRepeat, or with
; -riscv-xrepeat-loop-fusion=false, nothing changes.

; FUSED-LABEL: @dotxvf(
; FUSED:       for.body4:
; FUSED-COUNT-5: = phi i32
; FUSED-COUNT-2: load i32
; FUSED-NOT:   load i32, ptr %arrayidx6
; FUSED-COUNT-3: load i32
; FUSED:       br i1
; FUSED-NOT:   for.body4.1:

; KEPT-LABEL: @dotxvf(
; KEPT:        for.body4.1:
; KEPT:        for.body4.2:
; KEPT:        for.body4.3:

; With the whole -O2 pipeline, the fused loop is vectorized at VF 8: one
; block of x and four of A, each feeding its own in-loop reduction (the
; vectorizer counts five blocks live; the VRF core's register estimate allows
; five, since the backend loads each A block right before its MAC).
; O2-LABEL: @dotxvf(
; O2:          vector.body:
; O2-COUNT-5:    load <8 x i32>
; O2-COUNT-4:    call i32 @llvm.vector.reduce.add.v8i32(
; O2-NOT:      vector.body{{[0-9]+}}:
; O2-LABEL:    @unrelated(

; Only loops that share a load are fused: two loops over unrelated arrays are
; kept apart (fusing them only adds register pressure), while two loop nests of
; the same shape whose inner loops read the same in[t][k] (like bert_tiny's Q
; and K projections) are fused at both levels.
; FUSED-LABEL: @unrelated(
; FUSED:       for.body:
; FUSED:       for.body6:
; FUSED-LABEL: @nests(
; FUSED:       for.cond1.preheader:
; FUSED:       for.body4:
; FUSED-COUNT-3: = phi i32
; FUSED-NOT:   for.body{{[0-9]+}}:
; FUSED:       ret void

@P = global [256 x i32] zeroinitializer
@Q = global [256 x i32] zeroinitializer
@R = global [256 x i32] zeroinitializer
@S = global [256 x i32] zeroinitializer
@in = global [8 x [64 x i32]] zeroinitializer
@wq = global [64 x i32] zeroinitializer
@wk = global [64 x i32] zeroinitializer
@oq = global [8 x i32] zeroinitializer
@ok = global [8 x i32] zeroinitializer
@A = global [4 x [1024 x i32]] zeroinitializer, align 4
@x = global [1024 x i32] zeroinitializer, align 4
@y = global [4 x i32] zeroinitializer, align 4

define void @dotxvf() {
entry:
  br label %for.body4

for.cond.cleanup3:                                ; preds = %for.body4
  store i32 %add, ptr @y, align 4
  br label %for.body4.1

for.body4.1:                                      ; preds = %for.body4.1, %for.cond.cleanup3
  %k.019.1 = phi i32 [ 0, %for.cond.cleanup3 ], [ %inc.1, %for.body4.1 ]
  %acc.018.1 = phi i32 [ 0, %for.cond.cleanup3 ], [ %add.1, %for.body4.1 ]
  %arrayidx5.1 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @A, i32 4096), i32 %k.019.1
  %0 = load i32, ptr %arrayidx5.1, align 4
  %arrayidx6.1 = getelementptr inbounds nuw i32, ptr @x, i32 %k.019.1
  %1 = load i32, ptr %arrayidx6.1, align 4
  %mul.1 = mul nsw i32 %1, %0
  %add.1 = add nsw i32 %mul.1, %acc.018.1
  %inc.1 = add nuw nsw i32 %k.019.1, 1
  %exitcond.1.not = icmp eq i32 %inc.1, 1024
  br i1 %exitcond.1.not, label %for.cond.cleanup3.1, label %for.body4.1

for.cond.cleanup3.1:                              ; preds = %for.body4.1
  store i32 %add.1, ptr getelementptr inbounds nuw (i8, ptr @y, i32 4), align 4
  br label %for.body4.2

for.body4.2:                                      ; preds = %for.body4.2, %for.cond.cleanup3.1
  %k.019.2 = phi i32 [ 0, %for.cond.cleanup3.1 ], [ %inc.2, %for.body4.2 ]
  %acc.018.2 = phi i32 [ 0, %for.cond.cleanup3.1 ], [ %add.2, %for.body4.2 ]
  %arrayidx5.2 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @A, i32 8192), i32 %k.019.2
  %2 = load i32, ptr %arrayidx5.2, align 4
  %arrayidx6.2 = getelementptr inbounds nuw i32, ptr @x, i32 %k.019.2
  %3 = load i32, ptr %arrayidx6.2, align 4
  %mul.2 = mul nsw i32 %3, %2
  %add.2 = add nsw i32 %mul.2, %acc.018.2
  %inc.2 = add nuw nsw i32 %k.019.2, 1
  %exitcond.2.not = icmp eq i32 %inc.2, 1024
  br i1 %exitcond.2.not, label %for.cond.cleanup3.2, label %for.body4.2

for.cond.cleanup3.2:                              ; preds = %for.body4.2
  store i32 %add.2, ptr getelementptr inbounds nuw (i8, ptr @y, i32 8), align 4
  br label %for.body4.3

for.body4.3:                                      ; preds = %for.body4.3, %for.cond.cleanup3.2
  %k.019.3 = phi i32 [ 0, %for.cond.cleanup3.2 ], [ %inc.3, %for.body4.3 ]
  %acc.018.3 = phi i32 [ 0, %for.cond.cleanup3.2 ], [ %add.3, %for.body4.3 ]
  %arrayidx5.3 = getelementptr inbounds nuw i32, ptr getelementptr inbounds nuw (i8, ptr @A, i32 12288), i32 %k.019.3
  %4 = load i32, ptr %arrayidx5.3, align 4
  %arrayidx6.3 = getelementptr inbounds nuw i32, ptr @x, i32 %k.019.3
  %5 = load i32, ptr %arrayidx6.3, align 4
  %mul.3 = mul nsw i32 %5, %4
  %add.3 = add nsw i32 %mul.3, %acc.018.3
  %inc.3 = add nuw nsw i32 %k.019.3, 1
  %exitcond.3.not = icmp eq i32 %inc.3, 1024
  br i1 %exitcond.3.not, label %for.cond.cleanup3.3, label %for.body4.3

for.cond.cleanup3.3:                              ; preds = %for.body4.3
  store i32 %add.3, ptr getelementptr inbounds nuw (i8, ptr @y, i32 12), align 4
  ret void

for.body4:                                        ; preds = %entry, %for.body4
  %k.019 = phi i32 [ 0, %entry ], [ %inc, %for.body4 ]
  %acc.018 = phi i32 [ 0, %entry ], [ %add, %for.body4 ]
  %arrayidx5 = getelementptr inbounds nuw i32, ptr @A, i32 %k.019
  %6 = load i32, ptr %arrayidx5, align 4
  %arrayidx6 = getelementptr inbounds nuw i32, ptr @x, i32 %k.019
  %7 = load i32, ptr %arrayidx6, align 4
  %mul = mul nsw i32 %7, %6
  %add = add nsw i32 %mul, %acc.018
  %inc = add nuw nsw i32 %k.019, 1
  %exitcond.not = icmp eq i32 %inc, 1024
  br i1 %exitcond.not, label %for.cond.cleanup3, label %for.body4
}

define void @unrelated() {
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %i.021 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %arrayidx = getelementptr inbounds nuw i32, ptr @P, i32 %i.021
  %0 = load i32, ptr %arrayidx, align 4
  %mul = mul nsw i32 %0, 3
  %add = add nsw i32 %mul, 1
  store i32 %add, ptr %arrayidx, align 4
  %inc = add nuw nsw i32 %i.021, 1
  %exitcond.not = icmp eq i32 %inc, 256
  br i1 %exitcond.not, label %for.body6, label %for.body

for.cond.cleanup5:                                ; preds = %for.body6
  ret void

for.body6:                                        ; preds = %for.body, %for.body6
  %i2.022 = phi i32 [ %inc12, %for.body6 ], [ 0, %for.body ]
  %arrayidx7 = getelementptr inbounds nuw i32, ptr @R, i32 %i2.022
  %1 = load i32, ptr %arrayidx7, align 4
  %arrayidx8 = getelementptr inbounds nuw i32, ptr @S, i32 %i2.022
  %2 = load i32, ptr %arrayidx8, align 4
  %add9 = add nsw i32 %2, %1
  %arrayidx10 = getelementptr inbounds nuw i32, ptr @Q, i32 %i2.022
  store i32 %add9, ptr %arrayidx10, align 4
  %inc12 = add nuw nsw i32 %i2.022, 1
  %exitcond23.not = icmp eq i32 %inc12, 256
  br i1 %exitcond23.not, label %for.cond.cleanup5, label %for.body6
}
define void @nests() {
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %entry, %for.cond.cleanup3
  %t.050 = phi i32 [ 0, %entry ], [ %inc9, %for.cond.cleanup3 ]
  %arrayidx = getelementptr inbounds nuw [64 x i32], ptr @in, i32 %t.050
  br label %for.body4

for.cond.cleanup3:                                ; preds = %for.body4
  %arrayidx7 = getelementptr inbounds nuw i32, ptr @oq, i32 %t.050
  store i32 %add, ptr %arrayidx7, align 4
  %inc9 = add nuw nsw i32 %t.050, 1
  %exitcond54.not = icmp eq i32 %inc9, 8
  br i1 %exitcond54.not, label %for.cond18.preheader, label %for.cond1.preheader

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %k.049 = phi i32 [ 0, %for.cond1.preheader ], [ %inc, %for.body4 ]
  %a.048 = phi i32 [ 0, %for.cond1.preheader ], [ %add, %for.body4 ]
  %arrayidx5 = getelementptr inbounds nuw i32, ptr %arrayidx, i32 %k.049
  %0 = load i32, ptr %arrayidx5, align 4
  %arrayidx6 = getelementptr inbounds nuw i32, ptr @wq, i32 %k.049
  %1 = load i32, ptr %arrayidx6, align 4
  %mul = mul nsw i32 %1, %0
  %add = add nsw i32 %mul, %a.048
  %inc = add nuw nsw i32 %k.049, 1
  %exitcond.not = icmp eq i32 %inc, 64
  br i1 %exitcond.not, label %for.cond.cleanup3, label %for.body4

for.cond18.preheader:                             ; preds = %for.cond.cleanup3, %for.cond.cleanup20
  %t11.053 = phi i32 [ %inc32, %for.cond.cleanup20 ], [ 0, %for.cond.cleanup3 ]
  %arrayidx22 = getelementptr inbounds nuw [64 x i32], ptr @in, i32 %t11.053
  br label %for.body21

for.cond.cleanup14:                               ; preds = %for.cond.cleanup20
  ret void

for.cond.cleanup20:                               ; preds = %for.body21
  %arrayidx30 = getelementptr inbounds nuw i32, ptr @ok, i32 %t11.053
  store i32 %add26, ptr %arrayidx30, align 4
  %inc32 = add nuw nsw i32 %t11.053, 1
  %exitcond56.not = icmp eq i32 %inc32, 8
  br i1 %exitcond56.not, label %for.cond.cleanup14, label %for.cond18.preheader

for.body21:                                       ; preds = %for.cond18.preheader, %for.body21
  %k17.052 = phi i32 [ 0, %for.cond18.preheader ], [ %inc28, %for.body21 ]
  %a16.051 = phi i32 [ 0, %for.cond18.preheader ], [ %add26, %for.body21 ]
  %arrayidx23 = getelementptr inbounds nuw i32, ptr %arrayidx22, i32 %k17.052
  %2 = load i32, ptr %arrayidx23, align 4
  %arrayidx24 = getelementptr inbounds nuw i32, ptr @wk, i32 %k17.052
  %3 = load i32, ptr %arrayidx24, align 4
  %mul25 = mul nsw i32 %3, %2
  %add26 = add nsw i32 %mul25, %a16.051
  %inc28 = add nuw nsw i32 %k17.052, 1
  %exitcond55.not = icmp eq i32 %inc28, 64
  br i1 %exitcond55.not, label %for.cond.cleanup20, label %for.body21
}

; The same nests, already unroll-and-jammed by riscv-xrepeat-unroll-jam (the
; riscv.xrepeat.jammed loop attribute): not fused, their inner loops already
; share every load among the jammed outputs.
; FUSED-LABEL: @nests_jammed(
; FUSED:       for.body4:
; FUSED:       for.cond18.preheader:
; FUSED:       for.body21:
define void @nests_jammed() {
entry:
  br label %for.cond1.preheader

for.cond1.preheader:                              ; preds = %entry, %for.cond.cleanup3
  %t.050 = phi i32 [ 0, %entry ], [ %inc9, %for.cond.cleanup3 ]
  %arrayidx = getelementptr inbounds nuw [64 x i32], ptr @in, i32 %t.050
  br label %for.body4

for.cond.cleanup3:                                ; preds = %for.body4
  %arrayidx7 = getelementptr inbounds nuw i32, ptr @oq, i32 %t.050
  store i32 %add, ptr %arrayidx7, align 4
  %inc9 = add nuw nsw i32 %t.050, 1
  %exitcond54.not = icmp eq i32 %inc9, 8
  br i1 %exitcond54.not, label %for.cond18.preheader, label %for.cond1.preheader, !llvm.loop !0

for.body4:                                        ; preds = %for.cond1.preheader, %for.body4
  %k.049 = phi i32 [ 0, %for.cond1.preheader ], [ %inc, %for.body4 ]
  %a.048 = phi i32 [ 0, %for.cond1.preheader ], [ %add, %for.body4 ]
  %arrayidx5 = getelementptr inbounds nuw i32, ptr %arrayidx, i32 %k.049
  %0 = load i32, ptr %arrayidx5, align 4
  %arrayidx6 = getelementptr inbounds nuw i32, ptr @wq, i32 %k.049
  %1 = load i32, ptr %arrayidx6, align 4
  %mul = mul nsw i32 %1, %0
  %add = add nsw i32 %mul, %a.048
  %inc = add nuw nsw i32 %k.049, 1
  %exitcond.not = icmp eq i32 %inc, 64
  br i1 %exitcond.not, label %for.cond.cleanup3, label %for.body4

for.cond18.preheader:                             ; preds = %for.cond.cleanup3, %for.cond.cleanup20
  %t11.053 = phi i32 [ %inc32, %for.cond.cleanup20 ], [ 0, %for.cond.cleanup3 ]
  %arrayidx22 = getelementptr inbounds nuw [64 x i32], ptr @in, i32 %t11.053
  br label %for.body21

for.cond.cleanup14:                               ; preds = %for.cond.cleanup20
  ret void

for.cond.cleanup20:                               ; preds = %for.body21
  %arrayidx30 = getelementptr inbounds nuw i32, ptr @ok, i32 %t11.053
  store i32 %add26, ptr %arrayidx30, align 4
  %inc32 = add nuw nsw i32 %t11.053, 1
  %exitcond56.not = icmp eq i32 %inc32, 8
  br i1 %exitcond56.not, label %for.cond.cleanup14, label %for.cond18.preheader, !llvm.loop !2

for.body21:                                       ; preds = %for.cond18.preheader, %for.body21
  %k17.052 = phi i32 [ 0, %for.cond18.preheader ], [ %inc28, %for.body21 ]
  %a16.051 = phi i32 [ 0, %for.cond18.preheader ], [ %add26, %for.body21 ]
  %arrayidx23 = getelementptr inbounds nuw i32, ptr %arrayidx22, i32 %k17.052
  %2 = load i32, ptr %arrayidx23, align 4
  %arrayidx24 = getelementptr inbounds nuw i32, ptr @wk, i32 %k17.052
  %3 = load i32, ptr %arrayidx24, align 4
  %mul25 = mul nsw i32 %3, %2
  %add26 = add nsw i32 %mul25, %a16.051
  %inc28 = add nuw nsw i32 %k17.052, 1
  %exitcond55.not = icmp eq i32 %inc28, 64
  br i1 %exitcond55.not, label %for.cond.cleanup20, label %for.body21
}

!0 = distinct !{!0, !1}
!1 = !{!"riscv.xrepeat.jammed", i32 1}
!2 = distinct !{!2, !1}
