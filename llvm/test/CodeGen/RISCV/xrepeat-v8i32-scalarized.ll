; RUN: llc -mtriple=riscv32 -mattr=+m,+xrepeat -verify-machineinstrs < %s \
; RUN:   | FileCheck %s
; RUN: llc -mtriple=riscv32 -mattr=+m,+xrepeatint -verify-machineinstrs < %s \
; RUN:   | FileCheck %s
; RUN: llc -mtriple=riscv32 -mattr=+xrepeat -verify-machineinstrs -O0 < %s \
; RUN:   | FileCheck %s
; RUN: llc -mtriple=riscv32 -mattr=+xrepeatint -verify-machineinstrs -O0 < %s \
; RUN:   | FileCheck %s

; <8 x i32> operations XRepeat has no instruction for. They must be expanded
; element by element instead of reaching RVV-only code.

; CHECK-LABEL: sext_load:
define void @sext_load(ptr %ph, ptr %out) {
  %h = load <8 x i16>, ptr %ph, align 2
  %x = sext <8 x i16> %h to <8 x i32>
  store <8 x i32> %x, ptr %out, align 4
  ret void
}

; CHECK-LABEL: trunc_store:
define void @trunc_store(ptr %pa, ptr %out) {
  %a = load <8 x i32>, ptr %pa, align 4
  %t = trunc <8 x i32> %a to <8 x i16>
  store <8 x i16> %t, ptr %out, align 2
  ret void
}

; CHECK-LABEL: select_cmp:
define void @select_cmp(ptr %pa, ptr %pb, ptr %out) {
  %a = load <8 x i32>, ptr %pa, align 4
  %b = load <8 x i32>, ptr %pb, align 4
  %c = icmp slt <8 x i32> %a, %b
  %s = select <8 x i1> %c, <8 x i32> %a, <8 x i32> %b
  store <8 x i32> %s, ptr %out, align 4
  ret void
}

; CHECK-LABEL: shuffle_concat:
define void @shuffle_concat(ptr %pa, ptr %out) {
  %a = load <8 x i32>, ptr %pa, align 4
  %lo = shufflevector <8 x i32> %a, <8 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %cat = shufflevector <4 x i32> %lo, <4 x i32> %lo, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x i32> %cat, ptr %out, align 4
  ret void
}

; CHECK-LABEL: reverse:
define void @reverse(ptr %pa, ptr %out) {
  %a = load <8 x i32>, ptr %pa, align 4
  %r = shufflevector <8 x i32> %a, <8 x i32> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <8 x i32> %r, ptr %out, align 4
  ret void
}

; CHECK-LABEL: dot:
; CHECK: xr.mac
define i32 @dot(ptr %pa, ptr %pb) {
  %a = load <8 x i32>, ptr %pa, align 4
  %b = load <8 x i32>, ptr %pb, align 4
  %m = mul <8 x i32> %a, %b
  %r = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> %m)
  ret i32 %r
}
