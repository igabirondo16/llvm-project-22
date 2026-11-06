; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeatint -passes=slp-vectorizer -S < %s | FileCheck %s

; SLP asks for the cost of a splat of %s as a single-source permute with an
; all-zero mask. XRepeat must price it as a broadcast (a valid, cheap cost),
; not as an unsupported shuffle, so the tree out[i] = s * b[i] + c[i] is
; vectorized.

define void @scalar_times_vector(ptr noalias %out, ptr noalias %b, ptr noalias %c, ptr noalias %ps) {
entry:
  %s = load i32, ptr %ps, align 4
  %b0 = load i32, ptr %b, align 4
  %c0 = load i32, ptr %c, align 4
  %m0 = mul i32 %s, %b0
  %a0 = add i32 %m0, %c0
  store i32 %a0, ptr %out, align 4
  %b1p = getelementptr inbounds i8, ptr %b, i32 4
  %c1p = getelementptr inbounds i8, ptr %c, i32 4
  %o1p = getelementptr inbounds i8, ptr %out, i32 4
  %b1 = load i32, ptr %b1p, align 4
  %c1 = load i32, ptr %c1p, align 4
  %m1 = mul i32 %s, %b1
  %a1 = add i32 %m1, %c1
  store i32 %a1, ptr %o1p, align 4
  %b2p = getelementptr inbounds i8, ptr %b, i32 8
  %c2p = getelementptr inbounds i8, ptr %c, i32 8
  %o2p = getelementptr inbounds i8, ptr %out, i32 8
  %b2 = load i32, ptr %b2p, align 4
  %c2 = load i32, ptr %c2p, align 4
  %m2 = mul i32 %s, %b2
  %a2 = add i32 %m2, %c2
  store i32 %a2, ptr %o2p, align 4
  %b3p = getelementptr inbounds i8, ptr %b, i32 12
  %c3p = getelementptr inbounds i8, ptr %c, i32 12
  %o3p = getelementptr inbounds i8, ptr %out, i32 12
  %b3 = load i32, ptr %b3p, align 4
  %c3 = load i32, ptr %c3p, align 4
  %m3 = mul i32 %s, %b3
  %a3 = add i32 %m3, %c3
  store i32 %a3, ptr %o3p, align 4
  %b4p = getelementptr inbounds i8, ptr %b, i32 16
  %c4p = getelementptr inbounds i8, ptr %c, i32 16
  %o4p = getelementptr inbounds i8, ptr %out, i32 16
  %b4 = load i32, ptr %b4p, align 4
  %c4 = load i32, ptr %c4p, align 4
  %m4 = mul i32 %s, %b4
  %a4 = add i32 %m4, %c4
  store i32 %a4, ptr %o4p, align 4
  %b5p = getelementptr inbounds i8, ptr %b, i32 20
  %c5p = getelementptr inbounds i8, ptr %c, i32 20
  %o5p = getelementptr inbounds i8, ptr %out, i32 20
  %b5 = load i32, ptr %b5p, align 4
  %c5 = load i32, ptr %c5p, align 4
  %m5 = mul i32 %s, %b5
  %a5 = add i32 %m5, %c5
  store i32 %a5, ptr %o5p, align 4
  %b6p = getelementptr inbounds i8, ptr %b, i32 24
  %c6p = getelementptr inbounds i8, ptr %c, i32 24
  %o6p = getelementptr inbounds i8, ptr %out, i32 24
  %b6 = load i32, ptr %b6p, align 4
  %c6 = load i32, ptr %c6p, align 4
  %m6 = mul i32 %s, %b6
  %a6 = add i32 %m6, %c6
  store i32 %a6, ptr %o6p, align 4
  %b7p = getelementptr inbounds i8, ptr %b, i32 28
  %c7p = getelementptr inbounds i8, ptr %c, i32 28
  %o7p = getelementptr inbounds i8, ptr %out, i32 28
  %b7 = load i32, ptr %b7p, align 4
  %c7 = load i32, ptr %c7p, align 4
  %m7 = mul i32 %s, %b7
  %a7 = add i32 %m7, %c7
  store i32 %a7, ptr %o7p, align 4
  ret void
}
; CHECK-LABEL: define void @scalar_times_vector(
; CHECK: [[S:%.*]] = load i32, ptr %ps
; CHECK: load <8 x i32>, ptr %b
; CHECK: insertelement <8 x i32> poison, i32 [[S]], i32 0
; CHECK: shufflevector <8 x i32> {{.*}}, <8 x i32> poison, <8 x i32> zeroinitializer
; CHECK: mul <8 x i32>
; CHECK: add <8 x i32>
; CHECK: store <8 x i32> {{.*}}, ptr %out
