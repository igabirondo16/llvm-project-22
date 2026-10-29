; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=loop-vectorize -S < %s \
; RUN:   | FileCheck %s

; With XRepeat (and no V), loops are vectorized with VF = 8 (one <8 x i32>
; block) and no interleaving, since there are only three blocks.

; A dot product keeps its reduction in the loop: acc += reduce.add(a * b) is a
; single MAC that accumulates into the scalar.
; CHECK-LABEL: @dot(
; CHECK:       vector.body:
; CHECK:         [[A:%.*]] = load <8 x i32>
; CHECK:         [[B:%.*]] = load <8 x i32>
; CHECK:         [[M:%.*]] = mul nsw <8 x i32>
; CHECK:         [[R:%.*]] = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> [[M]])
; CHECK:         add i32 %{{.*}}, [[R]]
; CHECK-NOT:   load <8 x i32>
; CHECK:       middle.block:
define i32 @dot(ptr %a, ptr %b, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  %va = load i32, ptr %pa, align 4
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb, align 4
  %mul = mul nsw i32 %va, %vb
  %acc.next = add nsw i32 %mul, %acc
  %i.next = add nuw i32 %i, 1
  %done = icmp eq i32 %i.next, %n
  br i1 %done, label %exit, label %loop

exit:
  ret i32 %acc.next
}

; Element-wise a[i] = b[i] * s + c[i].
; CHECK-LABEL: @axpy(
; CHECK:       vector.body:
; CHECK:         load <8 x i32>
; CHECK:         mul nsw <8 x i32>
; CHECK:         load <8 x i32>
; CHECK:         add nsw <8 x i32>
; CHECK:         store <8 x i32>
define void @axpy(ptr noalias %a, ptr noalias %b, ptr noalias %c, i32 %s, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb, align 4
  %mul = mul nsw i32 %vb, %s
  %pc = getelementptr inbounds i32, ptr %c, i32 %i
  %vc = load i32, ptr %pc, align 4
  %add = add nsw i32 %mul, %vc
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  store i32 %add, ptr %pa, align 4
  %i.next = add nuw i32 %i, 1
  %done = icmp eq i32 %i.next, %n
  br i1 %done, label %exit, label %loop

exit:
  ret void
}

; XRepeat has no vector xor: the loop stays scalar.
; CHECK-LABEL: @xor(
; CHECK-NOT:   <{{[0-9]+}} x i32>
; CHECK:       ret void
define void @xor(ptr noalias %a, ptr noalias %b, i32 %n) {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb, align 4
  %x = xor i32 %vb, 12345
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  store i32 %x, ptr %pa, align 4
  %i.next = add nuw i32 %i, 1
  %done = icmp eq i32 %i.next, %n
  br i1 %done, label %exit, label %loop

exit:
  ret void
}
