; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=loop-unroll-full -S < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,KEEP
; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=loop-unroll-full -S < %s \
; RUN:   -riscv-xrepeat-keep-small-loops=false | FileCheck %s --check-prefixes=CHECK,UNROLL
; RUN: opt -mtriple=riscv32 -mattr=+m -passes=loop-unroll-full -S < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,UNROLL

; With XRepeat, the early full unroll leaves small loops that the loop
; vectorizer can turn into whole blocks rolled (gepdot: C[v] += a * B[v] for
; v < 8). Loops with other types or operations are still fully unrolled.

; CHECK-LABEL: define void @rank1_row(
; KEEP:          for.body:
; KEEP:          br i1 {{.*}}, label %exit, label %for.body
; UNROLL-NOT:    br i1 {{.*}}, label %exit, label %for.body
define void @rank1_row(ptr noalias %C, ptr noalias %B, i32 %a) {
entry:
  br label %for.body

for.body:
  %v = phi i32 [ 0, %entry ], [ %v.next, %for.body ]
  %pb = getelementptr inbounds i32, ptr %B, i32 %v
  %pc = getelementptr inbounds i32, ptr %C, i32 %v
  %b = load i32, ptr %pb, align 4
  %c = load i32, ptr %pc, align 4
  %m = mul i32 %a, %b
  %s = add i32 %c, %m
  store i32 %s, ptr %pc, align 4
  %v.next = add nuw nsw i32 %v, 1
  %done = icmp eq i32 %v.next, 8
  br i1 %done, label %exit, label %for.body

exit:
  ret void
}

; i16 data: not an XRepeat block, so it is still unrolled.
; CHECK-LABEL: define void @i16_row(
; CHECK-NOT:     br i1 {{.*}}, label %exit, label %for.body
define void @i16_row(ptr noalias %C, ptr noalias %B, i16 %a) {
entry:
  br label %for.body

for.body:
  %v = phi i32 [ 0, %entry ], [ %v.next, %for.body ]
  %pb = getelementptr inbounds i16, ptr %B, i32 %v
  %pc = getelementptr inbounds i16, ptr %C, i32 %v
  %b = load i16, ptr %pb, align 2
  %c = load i16, ptr %pc, align 2
  %m = mul i16 %a, %b
  %s = add i16 %c, %m
  store i16 %s, ptr %pc, align 2
  %v.next = add nuw nsw i32 %v, 1
  %done = icmp eq i32 %v.next, 8
  br i1 %done, label %exit, label %for.body

exit:
  ret void
}

; Trip count 6 is not a multiple of 4: still unrolled.
; CHECK-LABEL: define void @trip6(
; CHECK-NOT:     br i1 {{.*}}, label %exit, label %for.body
define void @trip6(ptr noalias %C, ptr noalias %B, i32 %a) {
entry:
  br label %for.body

for.body:
  %v = phi i32 [ 0, %entry ], [ %v.next, %for.body ]
  %pb = getelementptr inbounds i32, ptr %B, i32 %v
  %pc = getelementptr inbounds i32, ptr %C, i32 %v
  %b = load i32, ptr %pb, align 4
  %m = mul i32 %a, %b
  store i32 %m, ptr %pc, align 4
  %v.next = add nuw nsw i32 %v, 1
  %done = icmp eq i32 %v.next, 6
  br i1 %done, label %exit, label %for.body

exit:
  ret void
}

; Only an induction variable and a store of a constant: nothing for a MAC to
; do, so it is still unrolled.
; CHECK-LABEL: define void @zero_fill(
; CHECK-NOT:     br i1 {{.*}}, label %exit, label %for.body
define void @zero_fill(ptr %C) {
entry:
  br label %for.body

for.body:
  %v = phi i32 [ 0, %entry ], [ %v.next, %for.body ]
  %pc = getelementptr inbounds i32, ptr %C, i32 %v
  store i32 0, ptr %pc, align 4
  %v.next = add nuw nsw i32 %v, 1
  %done = icmp eq i32 %v.next, 4
  br i1 %done, label %exit, label %for.body

exit:
  ret void
}

; Stride 2 store: still unrolled.
; CHECK-LABEL: define void @stride2(
; CHECK-NOT:     br i1 {{.*}}, label %exit, label %for.body
define void @stride2(ptr noalias %C, ptr noalias %B, i32 %a) {
entry:
  br label %for.body

for.body:
  %v = phi i32 [ 0, %entry ], [ %v.next, %for.body ]
  %pb = getelementptr inbounds i32, ptr %B, i32 %v
  %v2 = shl nuw nsw i32 %v, 1
  %pc = getelementptr inbounds i32, ptr %C, i32 %v2
  %b = load i32, ptr %pb, align 4
  %m = mul i32 %a, %b
  store i32 %m, ptr %pc, align 4
  %v.next = add nuw nsw i32 %v, 1
  %done = icmp eq i32 %v.next, 8
  br i1 %done, label %exit, label %for.body

exit:
  ret void
}
