; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeatint -passes=loop-vectorize -S < %s \
; RUN:   | FileCheck %s

; With XRepeat (and no V), loops are vectorized with VF = 8 (one <8 x i32>
; block) or VF = 4 (one <4 x i32> block), whichever is cheaper, and no
; interleaving, since there are only three (or six) blocks.

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

; A trip count of 4 only fits a <4 x i32> block.
; CHECK-LABEL: @dot_tc4(
; CHECK:       vector.body:
; CHECK:         load <4 x i32>
; CHECK:         load <4 x i32>
; CHECK-NOT:   <8 x i32>
; CHECK:       ret i32
define i32 @dot_tc4(ptr %a, ptr %b, i32 %n) {
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
  %done = icmp eq i32 %i.next, 4
  br i1 %done, label %exit, label %loop
exit:
  ret i32 %acc.next
}

; With 20 iterations, five <4 x i32> iterations are cheaper than two
; <8 x i32> iterations plus four scalar ones.
; CHECK-LABEL: @dot_tc20(
; CHECK:       vector.body:
; CHECK:         load <4 x i32>
; CHECK:         load <4 x i32>
; CHECK-NOT:   <8 x i32>
; CHECK:       ret i32
define i32 @dot_tc20(ptr %a, ptr %b, i32 %n) {
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
  %done = icmp eq i32 %i.next, 20
  br i1 %done, label %exit, label %loop
exit:
  ret i32 %acc.next
}

; With 16 iterations, <8 x i32> blocks take half as many instructions.
; CHECK-LABEL: @dot_tc16(
; CHECK:       vector.body:
; CHECK:         load <8 x i32>
; CHECK:         load <8 x i32>
; CHECK:       ret i32
define i32 @dot_tc16(ptr %a, ptr %b, i32 %n) {
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
  %done = icmp eq i32 %i.next, 16
  br i1 %done, label %exit, label %loop
exit:
  ret i32 %acc.next
}

; Six vectors are live at once: they fit in the six <4 x i32> blocks but not
; in the three <8 x i32> ones.
; CHECK-LABEL: @pressure(
; CHECK:       vector.body:
; CHECK-COUNT-6: load <4 x i32>
; CHECK-NOT:   <8 x i32>
; CHECK:       ret void
define void @pressure(ptr noalias %a, ptr noalias %b, ptr noalias %c, ptr noalias %d, ptr noalias %e, ptr noalias %f, ptr noalias %o, i32 %n) {
entry:
  br label %loop
loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %pa = getelementptr inbounds i32, ptr %a, i32 %i
  %va = load i32, ptr %pa, align 4
  %pb = getelementptr inbounds i32, ptr %b, i32 %i
  %vb = load i32, ptr %pb, align 4
  %pc = getelementptr inbounds i32, ptr %c, i32 %i
  %vc = load i32, ptr %pc, align 4
  %pd = getelementptr inbounds i32, ptr %d, i32 %i
  %vd = load i32, ptr %pd, align 4
  %pe = getelementptr inbounds i32, ptr %e, i32 %i
  %ve = load i32, ptr %pe, align 4
  %pf = getelementptr inbounds i32, ptr %f, i32 %i
  %vf = load i32, ptr %pf, align 4
  %m1 = mul i32 %va, %vb
  %m2 = mul i32 %vc, %vd
  %m3 = mul i32 %ve, %vf
  %s1 = add i32 %m1, %m2
  %s2 = add i32 %s1, %m3
  %po = getelementptr inbounds i32, ptr %o, i32 %i
  store i32 %s2, ptr %po, align 4
  %i.next = add nuw i32 %i, 1
  %done = icmp eq i32 %i.next, %n
  br i1 %done, label %exit, label %loop
exit:
  ret void
}
