when not defined(amd64):
  {.error: "experiments/vmath_simd.nim is an amd64 SIMD-only experiment".}

when defined(gcc) or defined(clang):
  {.passc: "-msse4.1 -march=native -mtune=native -ffast-math".}

import nimsimd/sse41

type
  Vec3* = M128

template vec3*[T: SomeNumber](x, y, z: T): Vec3 =
  mm_set_ps(float32(z), float32(z), float32(y), float32(x))

template vec3*[T: SomeNumber](v: T): Vec3 =
  vec3(v, v, v)

template vec3*(): Vec3 =
  vec3(0'f32)

template x*(a: Vec3): float32 =
  mm_cvtss_f32(a)

template y*(a: Vec3): float32 =
  mm_cvtss_f32(mm_shuffle_ps(a, a, MM_SHUFFLE(1, 1, 1, 1)))

template z*(a: Vec3): float32 =
  mm_cvtss_f32(mm_shuffle_ps(a, a, MM_SHUFFLE(2, 2, 2, 2)))

template `+`*(a, b: Vec3): Vec3 =
  mm_add_ps(a, b)

template `-`*(a, b: Vec3): Vec3 =
  mm_sub_ps(a, b)

template `-`*(a: Vec3): Vec3 =
  mm_sub_ps(mm_setzero_ps(), a)

template `*`*(a, b: Vec3): Vec3 =
  mm_mul_ps(a, b)

template `*`*(a: Vec3, b: float32): Vec3 =
  mm_mul_ps(a, mm_set1_ps(b))

template `*`*(a: float32, b: Vec3): Vec3 =
  b * a

template `/`*(a: Vec3, b: float32): Vec3 =
  mm_div_ps(a, mm_set1_ps(b))

template dot*(a, b: Vec3): float32 =
  mm_cvtss_f32(mm_dp_ps(a, b, 0x7f))

template lengthSq*(a: Vec3): float32 =
  a.dot(a)

template length*(a: Vec3): float32 =
  mm_cvtss_f32(mm_sqrt_ss(mm_dp_ps(a, a, 0x7f)))

template normalize*(a: Vec3): Vec3 =
  mm_div_ps(a, mm_sqrt_ps(mm_dp_ps(a, a, 0x7f)))

template cross*(a, b: Vec3): Vec3 =
  block:
    var t1 = mm_shuffle_ps(b, b, MM_SHUFFLE(0, 0, 2, 1))
    t1 = mm_mul_ps(t1, a)
    var t2 = mm_shuffle_ps(a, a, MM_SHUFFLE(0, 0, 2, 1))
    t2 = mm_mul_ps(t2, b)
    let t3 = mm_sub_ps(t1, t2)
    mm_shuffle_ps(t3, t3, MM_SHUFFLE(0, 0, 2, 1))
