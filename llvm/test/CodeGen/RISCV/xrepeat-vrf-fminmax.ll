; RUN: opt -mtriple=riscv32 -mattr=+m,+xrepeat -passes=riscv-xrepeat-fminmax \
; RUN:   -S < %s | FileCheck %s
; RUN: opt -mtriple=riscv32 -mattr=+m,+f -passes=riscv-xrepeat-fminmax \
; RUN:   -S < %s | FileCheck %s --check-prefix=NOXR --implicit-check-not=imumnum

; Selects that are a min/max of x and a constant become minimumnum/maximumnum
; on the VRF core; others stay. Without XRepeat nothing changes.

; x > 0 ? x : 0 is maximumNumber(x, +0.0) exactly.
define float @relu(float %x) {
; CHECK-LABEL: @relu(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximumnum.f32(float [[X:%.*]], float 0.000000e+00)
; CHECK-NEXT:    ret float [[R]]
; NOXR-LABEL: @relu(
; NOXR:         select
  %c = fcmp ogt float %x, 0.0
  %r = select i1 %c, float %x, float 0.0
  ret float %r
}

; Constant on the left of the compare.
define float @clamp_hi(float %x) {
; CHECK-LABEL: @clamp_hi(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.minimumnum.f32(float [[X:%.*]], float 1.270000e+02)
; CHECK-NEXT:    ret float [[R]]
  %c = fcmp ogt float 127.0, %x
  %r = select i1 %c, float %x, float 127.0
  ret float %r
}

; The constant on the true side, with the inverse (unordered) predicate.
define float @clamp_lo_inverse(float %x) {
; CHECK-LABEL: @clamp_lo_inverse(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximumnum.f32(float [[X:%.*]], float -1.280000e+02)
; CHECK-NEXT:    ret float [[R]]
  %c = fcmp ule float %x, -128.0
  %r = select i1 %c, float -128.0, float %x
  ret float %r
}

; x < 0 ? 0 : x selects a NaN x (maximumNumber gives 0): kept.
define float @relu_nan_differs(float %x) {
; CHECK-LABEL: @relu_nan_differs(
; CHECK:         select
  %c = fcmp olt float %x, 0.0
  %r = select i1 %c, float 0.0, float %x
  ret float %r
}

; ... unless the compare says there are no NaNs; x = -0.0 still gives -0.0
; (maximumNumber +0.0), so it also needs nsz.
define float @relu_nnan(float %x) {
; CHECK-LABEL: @relu_nnan(
; CHECK:         select
  %c = fcmp nnan olt float %x, 0.0
  %r = select i1 %c, float 0.0, float %x
  ret float %r
}

define float @relu_nnan_nsz(float %x) {
; CHECK-LABEL: @relu_nnan_nsz(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximumnum.f32(float [[X:%.*]], float 0.000000e+00)
; CHECK-NEXT:    ret float [[R]]
  %c = fcmp nnan nsz olt float %x, 0.0
  %r = select i1 %c, float 0.0, float %x
  ret float %r
}

; Signed zeros: x > -0.0 ? x : -0.0 gives -0.0 for x = +0.0: kept;
; x >= 0.0 ? x : 0.0 gives -0.0 for x = -0.0: kept; x >= -0.0 is fine.
define float @gt_negzero(float %x) {
; CHECK-LABEL: @gt_negzero(
; CHECK:         select
  %c = fcmp ogt float %x, -0.0
  %r = select i1 %c, float %x, float -0.0
  ret float %r
}

define float @ge_poszero(float %x) {
; CHECK-LABEL: @ge_poszero(
; CHECK:         select
  %c = fcmp oge float %x, 0.0
  %r = select i1 %c, float %x, float 0.0
  ret float %r
}

define float @ge_negzero(float %x) {
; CHECK-LABEL: @ge_negzero(
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximumnum.f32(float [[X:%.*]], float -0.000000e+00)
; CHECK-NEXT:    ret float [[R]]
  %c = fcmp oge float %x, -0.0
  %r = select i1 %c, float %x, float -0.0
  ret float %r
}

define float @le_negzero(float %x) {
; CHECK-LABEL: @le_negzero(
; CHECK:         select
  %c = fcmp ole float %x, -0.0
  %r = select i1 %c, float %x, float -0.0
  ret float %r
}

; Fast-math clamp as InstCombine leaves it: x > -128 ? min(x, 127) : -128.
define float @clamp_fast(float %x) {
; CHECK-LABEL: @clamp_fast(
; CHECK-NEXT:    [[M:%.*]] = call fast float @llvm.minnum.f32(float [[X:%.*]], float 1.270000e+02)
; CHECK-NEXT:    [[R:%.*]] = call float @llvm.maximumnum.f32(float [[M]], float -1.280000e+02)
; CHECK-NEXT:    ret float [[R]]
  %c = fcmp fast ogt float %x, -128.0
  %m = call fast float @llvm.minnum.f32(float %x, float 127.0)
  %r = select i1 %c, float %m, float -128.0
  ret float %r
}

; ... but not when the inner bound is below the outer one, nor without
; fast-math.
define float @clamp_fast_bad_bounds(float %x) {
; CHECK-LABEL: @clamp_fast_bad_bounds(
; CHECK:         select
  %c = fcmp fast ogt float %x, 10.0
  %m = call fast float @llvm.minnum.f32(float %x, float 5.0)
  %r = select i1 %c, float %m, float 10.0
  ret float %r
}

define float @clamp_strict(float %x) {
; CHECK-LABEL: @clamp_strict(
; CHECK:         select
  %c = fcmp ogt float %x, -128.0
  %m = call float @llvm.minnum.f32(float %x, float 127.0)
  %r = select i1 %c, float %m, float -128.0
  ret float %r
}

; Not a constant, a NaN constant, a different value: kept.
define float @not_const(float %x, float %y) {
; CHECK-LABEL: @not_const(
; CHECK:         select
  %c = fcmp ogt float %x, %y
  %r = select i1 %c, float %x, float %y
  ret float %r
}

define float @nan_const(float %x) {
; CHECK-LABEL: @nan_const(
; CHECK:         select
  %c = fcmp ogt float %x, 0x7FF8000000000000
  %r = select i1 %c, float %x, float 0x7FF8000000000000
  ret float %r
}

define float @other_value(float %x, float %y) {
; CHECK-LABEL: @other_value(
; CHECK:         select
  %c = fcmp ogt float %x, 0.0
  %r = select i1 %c, float %y, float 0.0
  ret float %r
}
