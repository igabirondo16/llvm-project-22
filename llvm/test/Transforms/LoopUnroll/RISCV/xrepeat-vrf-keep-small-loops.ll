; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=loop-unroll-full -S < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,KEEP
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=loop-unroll-full -S < %s \
; RUN:   -riscv-xrepeat-keep-small-loops=false | FileCheck %s --check-prefixes=CHECK,UNROLL
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=loop-unroll-full -S < %s \
; RUN:   -riscv-xrepeat-keep-small-reductions=false | FileCheck %s --check-prefixes=CHECK,NORED

; XRepeat (VRF core): the early full unroll leaves small loops that the loop
; vectorizer can turn into whole 8- or 16-wide blocks rolled: a trip count that
; is a multiple of 8, and i32 or float arithmetic on unit-stride loads. Other
; loops are still fully unrolled.

; C[0..15] += a * B[0..15] on i32.
; CHECK-LABEL: define void @i32_tc16(
; KEEP:          br i1 %{{.*}}, label %exit, label %loop
; UNROLL-NOT:    br i1
define void @i32_tc16(ptr noalias %c, ptr noalias %b, i32 %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb
  %m = mul i32 %vb, %a
  %pc = getelementptr inbounds i32, ptr %c, i32 %i
  %vc = load i32, ptr %pc
  %r = add i32 %vc, %m
  store i32 %r, ptr %pc
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 16
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; The same with floats and fmuladd, 8 elements.
; CHECK-LABEL: define void @float_tc8(
; KEEP:          br i1 %{{.*}}, label %exit, label %loop
; UNROLL-NOT:    br i1
define void @float_tc8(ptr noalias %c, ptr noalias %b, float %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds float, ptr %b, i32 %i
  %vb = load float, ptr %pb
  %pc = getelementptr inbounds float, ptr %c, i32 %i
  %vc = load float, ptr %pc
  %r = call float @llvm.fmuladd.f32(float %vb, float %a, float %vc)
  store float %r, ptr %pc
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 8
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; A trip count of 4 is not a whole block: unrolled.
; CHECK-LABEL: define void @i32_tc4(
; CHECK-NOT:     br i1
; CHECK:         ret void
define void @i32_tc4(ptr noalias %c, ptr noalias %b, i32 %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb
  %m = mul i32 %vb, %a
  %pc = getelementptr inbounds i32, ptr %c, i32 %i
  store i32 %m, ptr %pc
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 4
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; i16 data has no blocks: unrolled.
; CHECK-LABEL: define void @i16_tc8(
; CHECK-NOT:     br i1
; CHECK:         ret void
define void @i16_tc8(ptr noalias %c, ptr noalias %b) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pb = getelementptr inbounds i16, ptr %b, i32 %i
  %vb = load i16, ptr %pb
  %pc = getelementptr inbounds i16, ptr %c, i32 %i
  %vc = load i16, ptr %pc
  %r = add i16 %vc, %vb
  store i16 %r, ptr %pc
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 8
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; A ReLU that is exactly maximumNumber (RISCVXRepeatFMinMaxPass makes it
; fmax.s + REPEAT later): kept.
; CHECK-LABEL: define void @relu_tc8(
; KEEP:          br i1 %{{.*}}, label %exit, label %loop
; UNROLL-NOT:    br i1
define void @relu_tc8(ptr noalias %d, ptr noalias %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %c = fcmp ogt float %va, 0.0
  %r = select i1 %c, float %va, float 0.0
  %pd = getelementptr inbounds float, ptr %d, i32 %i
  store float %r, ptr %pd
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 8
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; x < 0 ? 0 : x is not (a NaN x selects x): unrolled as before.
; CHECK-LABEL: define void @relu_nan_tc8(
; CHECK-NOT:     br i1
define void @relu_nan_tc8(ptr noalias %d, ptr noalias %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %c = fcmp olt float %va, 0.0
  %r = select i1 %c, float 0.0, float %va
  %pd = getelementptr inbounds float, ptr %d, i32 %i
  store float %r, ptr %pd
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 8
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; A float dot product of 16 elements, no store: kept, so the loop vectorizer
; makes it one in-order fmadd.s + REPEAT per block (unrolled, SLP leaves an
; in-order float reduction scalar).
; CHECK-LABEL: define float @fdot_tc16(
; KEEP:          br i1 %{{.*}}, label %exit, label %loop
; UNROLL-NOT:    br i1
; NORED-NOT:     br i1
define float @fdot_tc16(ptr %a, ptr %b, float %s0) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %s = phi float [ %s0, %entry ], [ %s1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %pb = getelementptr inbounds float, ptr %b, i32 %i
  %vb = load float, ptr %pb
  %s1 = call float @llvm.fmuladd.f32(float %va, float %vb, float %s)
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 16
  br i1 %done, label %exit, label %loop
exit:
  ret float %s1
}

; An i32 sum: SLP vectorizes it unrolled, so it is unrolled as before.
; CHECK-LABEL: define i32 @isum_tc16(
; CHECK-NOT:     br i1
define i32 @isum_tc16(ptr %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %s = phi i32 [ 0, %entry ], [ %s1, %loop ]
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  %va = load i32, ptr %pa
  %s1 = add i32 %s, %va
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 16
  br i1 %done, label %exit, label %loop
exit:
  ret i32 %s1
}

; 8 iterations with a store that may alias the load: the loop vectorizer emits
; no runtime alias check below 16 iterations, so it is unrolled as before.
; CHECK-LABEL: define void @fadd_tc8_alias(
; CHECK-NOT:     br i1
define void @fadd_tc8_alias(ptr %d, ptr %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %r = fadd float %va, 2.5
  %pd = getelementptr inbounds float, ptr %d, i32 %i
  store float %r, ptr %pd
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 8
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; ... kept with noalias pointers, or with 16 iterations (checks allowed).
; CHECK-LABEL: define void @fadd_tc8_noalias(
; KEEP:          br i1 %{{.*}}, label %exit, label %loop
define void @fadd_tc8_noalias(ptr noalias %d, ptr noalias %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %r = fadd float %va, 2.5
  %pd = getelementptr inbounds float, ptr %d, i32 %i
  store float %r, ptr %pd
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 8
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

; CHECK-LABEL: define void @fadd_tc16_alias(
; KEEP:          br i1 %{{.*}}, label %exit, label %loop
define void @fadd_tc16_alias(ptr %d, ptr %a) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i1, %loop ]
  %pa = getelementptr inbounds float, ptr %a, i32 %i
  %va = load float, ptr %pa
  %r = fadd float %va, 2.5
  %pd = getelementptr inbounds float, ptr %d, i32 %i
  store float %r, ptr %pd
  %i1 = add nuw nsw i32 %i, 1
  %done = icmp eq i32 %i1, 16
  br i1 %done, label %exit, label %loop
exit:
  ret void
}
