##[

This library has no dependencies other than the Nim standard libarary.

Your one stop shop for vector math routines for 2d and 3d graphics.

* Pure Nim with no dependencies.
* Very similar to GLSL Shader Language with extra stuff.
* Extensively benchmarked.

====== =========== ===================================================
Type   Constructor Description
====== =========== ===================================================
BVec#  bvec#       a vector of booleans
IVec#  ivec#       a vector of signed integers
UVec#  uvec#       a vector of unsigned integers
Vec#   vec#        a vector of single-precision floating-point numbers
DVec#  dvec#       a vector of double-precision floating-point numbers
====== =========== ===================================================

You can use these constructors to make them:

======= ====== ===== ===== ===== ===== ===== =====
NIM     GLSL   2     3     4     9     16    4
======= ====== ===== ===== ===== ===== ===== =====
bool    bool   BVec2 BVec3 BVec4
int32   int    IVec2 IVec3 IVec4
uint32  uint   UVec2 UVec3 UVec4
float32 float  Vec2  Vec3  Vec4  Mat3  Mat4  Quat
float64 double DVec2 DVec3 DVec4 DMat3 DMat4 DQuat
======= ====== ===== ===== ===== ===== ===== =====

]##

import macros, math, strutils
export math except isNan

{.push inline.}
when defined(release):
  {.push noinit, checks: off.}

when defined(vmathArrayBased):
  type
    GVec2*[T] = array[2, T]
    GVec3*[T] = array[3, T]
    GVec4*[T] = array[4, T]
    GVec34[T] = GVec3[T] | GVec4[T]
    GVec234[T] = GVec2[T] | GVec3[T] | GVec4[T]

  template gvec2*[T](x, y: T): GVec2[T] = [T(x), T(y)]
  template gvec3*[T](x, y, z: T): GVec3[T] = [T(x), T(y), T(z)]
  template gvec4*[T](x, y, z, w: T): GVec4[T] = [T(x), T(y), T(z), T(w)]

  template x*[T](a: GVec2[T]): T = a[0]
  template x*[T](a: GVec3[T]): T = a[0]
  template x*[T](a: GVec4[T]): T = a[0]

  template y*[T](a: GVec2[T]): T = a[1]
  template y*[T](a: GVec3[T]): T = a[1]
  template y*[T](a: GVec4[T]): T = a[1]

  template z*[T](a: GVec2[T]): T = {.error: "using .z on a Vec2".}
  template z*[T](a: GVec3[T]): T = a[2]
  template z*[T](a: GVec4[T]): T = a[2]

  template w*[T](a: GVec2[T]): T = {.error: "using .w on a Vec2".}
  template w*[T](a: GVec3[T]): T = {.error: "using .w on a Vec3".}
  template w*[T](a: GVec4[T]): T = a[3]

  template x*[T](a: var GVec2[T]): var T = a[0]
  template x*[T](a: var GVec3[T]): var T = a[0]
  template x*[T](a: var GVec4[T]): var T = a[0]
  template y*[T](a: var GVec2[T]): var T = a[1]
  template y*[T](a: var GVec3[T]): var T = a[1]
  template y*[T](a: var GVec4[T]): var T = a[1]
  template z*[T](a: var GVec3[T]): var T = a[2]
  template z*[T](a: var GVec4[T]): var T = a[2]
  template w*[T](a: var GVec4[T]): var T = a[3]

  template `x=`*[T](a: var GVec234[T], value: T) = a[0] = value
  template `y=`*[T](a: var GVec234[T], value: T) = a[1] = value
  template `z=`*[T](a: var GVec34[T], value: T) = a[2] = value
  template `w=`*[T](a: var GVec4[T], value: T) = a[3] = value

  type
    GMat2*[T] {.bycopy.} = array[2, GVec2[T]]
    GMat3*[T] {.bycopy.} = array[3, GVec3[T]]
    GMat4*[T] {.bycopy.} = array[4, GVec4[T]]

    GMat234[T] = GMat2[T] | GMat3[T] | GMat4[T]

  proc gmat2*[T](
    m00, m01,
    m10, m11: T
  ): GMat2[T] =
    [
      [m00, m01],
      [m10, m11]
    ]

  proc gmat3*[T](
    m00, m01, m02,
    m10, m11, m12,
    m20, m21, m22: T
  ): GMat3[T] =
    [
      [m00, m01, m02],
      [m10, m11, m12],
      [m20, m21, m22]
    ]

  proc gmat4*[T](
    m00, m01, m02, m03,
    m10, m11, m12, m13,
    m20, m21, m22, m23,
    m30, m31, m32, m33: T
  ): GMat4[T] =
    [
      [m00, m01, m02, m03],
      [m10, m11, m12, m13],
      [m20, m21, m22, m23],
      [m30, m31, m32, m33]
    ]

  template `[]`*[T](a: GMat234[T], i, j: int): T = a[i][j]

  template `[]=`*[T](a: var GMat2[T], i, j: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + (i * 2 + j) * sizeof(T))[] = v

  template `[]=`*[T](a: var GMat3[T], i, j: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + (i * 3 + j) * sizeof(T))[] = v

  template `[]=`*[T](a: var GMat4[T], i, j: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + (i * 4 + j) * sizeof(T))[] = v

elif defined(vmathObjBased):
  type
    GVec2*[T] = object
      x*, y*: T
    GVec3*[T] = object
      x*, y*, z*: T
    GVec4*[T] = object
      x*, y*, z*, w*: T
    GVec34[T] = GVec3[T] | GVec4[T]
    GVec234[T] = GVec2[T] | GVec3[T] | GVec4[T]

  template gvec2*[T](mx, my: T): GVec2[T] =
    GVec2[T](x: mx, y: my)

  template gvec3*[T](mx, my, mz: T): GVec3[T] =
    GVec3[T](x: mx, y: my, z: mz)

  template gvec4*[T](mx, my, mz, mw: T): GVec4[T] =
    GVec4[T](x: mx, y: my, z: mz, w: mw)

  template `[]`*[T](a: GVec2[T], i: int): T = cast[array[2, T]](a)[i]
  template `[]`*[T](a: GVec3[T], i: int): T = cast[array[3, T]](a)[i]
  template `[]`*[T](a: GVec4[T], i: int): T = cast[array[4, T]](a)[i]

  template `[]=`*[T](a: var GVec2[T], i: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + i * sizeof(T))[] = v

  template `[]=`*[T](a: var GVec3[T], i: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + i * sizeof(T))[] = v

  template `[]=`*[T](a: var GVec4[T], i: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + i * sizeof(T))[] = v

  type
    GMat2*[T] {.bycopy.} = object
      m00*, m01*: T
      m10*, m11*: T
    GMat3*[T] {.bycopy.} = object
      m00*, m01*, m02*: T
      m10*, m11*, m12*: T
      m20*, m21*, m22*: T
    GMat4*[T] {.bycopy.} = object
      m00*, m01*, m02*, m03*: T
      m10*, m11*, m12*, m13*: T
      m20*, m21*, m22*, m23*: T
      m30*, m31*, m32*, m33*: T

  proc gmat2*[T](
    m00, m01,
    m10, m11: T
  ): GMat2[T] =
    result.m00 = m00; result.m01 = m01
    result.m10 = m10; result.m11 = m11

  proc gmat3*[T](
    m00, m01, m02,
    m10, m11, m12,
    m20, m21, m22: T
  ): GMat3[T] =
    result.m00 = m00; result.m01 = m01; result.m02 = m02
    result.m10 = m10; result.m11 = m11; result.m12 = m12
    result.m20 = m20; result.m21 = m21; result.m22 = m22

  proc gmat4*[T](
    m00, m01, m02, m03,
    m10, m11, m12, m13,
    m20, m21, m22, m23,
    m30, m31, m32, m33: T
  ): GMat4[T] =
    result.m00 = m00; result.m01 = m01; result.m02 = m02; result.m03 = m03
    result.m10 = m10; result.m11 = m11; result.m12 = m12; result.m13 = m13
    result.m20 = m20; result.m21 = m21; result.m22 = m22; result.m23 = m23
    result.m30 = m30; result.m31 = m31; result.m32 = m32; result.m33 = m33

  template `[]`*[T](a: GMat2[T], i, j: int): T =
    cast[array[4, T]](a)[i * 2 + j]

  template `[]`*[T](a: GMat3[T], i, j: int): T =
    cast[array[9, T]](a)[i * 3 + j]

  template `[]`*[T](a: GMat4[T], i, j: int): T =
    cast[array[16, T]](a)[i * 4 + j]

  template `[]=`*[T](a: var GMat2[T], i, j: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + (i * 2 + j) * sizeof(T))[] = v

  template `[]=`*[T](a: var GMat3[T], i, j: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + (i * 3 + j) * sizeof(T))[] = v

  template `[]=`*[T](a: var GMat4[T], i, j: int, v: T) =
    cast[ptr T](cast[uint64](a.addr) + (i * 4 + j) * sizeof(T))[] = v

  template `[]`*[T](a: GMat2[T], i: int): GVec2[T] =
    gvec2[T](
      a[i, 0],
      a[i, 1]
    )

  template `[]`*[T](a: GMat3[T], i: int): GVec3[T] =
    gvec3[T](
      a[i, 0],
      a[i, 1],
      a[i, 2]
    )

  template `[]`*[T](a: GMat4[T], i: int): GVec4[T] =
    gvec4[T](
      a[i, 0],
      a[i, 1],
      a[i, 2],
      a[i, 3]
    )

elif true or defined(vmathObjArrayBased):
  type
    GVec2*[T] = object
      arr: array[2, T]
    GVec3*[T] = object
      arr: array[3, T]
    GVec4*[T] = object
      arr: array[4, T]
    GVec34[T] = GVec3[T] | GVec4[T]
    GVec234[T] = GVec2[T] | GVec3[T] | GVec4[T]

  template gvec2*[T](x, y: T): GVec2[T] =
    GVec2[T](arr: [T(x), T(y)])

  template gvec3*[T](x, y, z: T): GVec3[T] =
    GVec3[T](arr: [T(x), T(y), T(z)])

  template gvec4*[T](x, y, z, w: T): GVec4[T] =
    GVec4[T](arr: [T(x), T(y), T(z), T(w)])

  template x*[T](a: var GVec2[T]): var T = a.arr[0]
  template y*[T](a: var GVec2[T]): var T = a.arr[1]

  template x*[T](a: var GVec3[T]): var T = a.arr[0]
  template y*[T](a: var GVec3[T]): var T = a.arr[1]
  template z*[T](a: var GVec3[T]): var T = a.arr[2]

  template x*[T](a: var GVec4[T]): var T = a.arr[0]
  template y*[T](a: var GVec4[T]): var T = a.arr[1]
  template z*[T](a: var GVec4[T]): var T = a.arr[2]
  template w*[T](a: var GVec4[T]): var T = a.arr[3]

  template x*[T](a: GVec2[T]): T = a.arr[0]
  template x*[T](a: GVec3[T]): T = a.arr[0]
  template x*[T](a: GVec4[T]): T = a.arr[0]

  template y*[T](a: GVec2[T]): T = a.arr[1]
  template y*[T](a: GVec3[T]): T = a.arr[1]
  template y*[T](a: GVec4[T]): T = a.arr[1]

  template z*[T](a: GVec3[T]): T = a.arr[2]
  template z*[T](a: GVec4[T]): T = a.arr[2]
  template w*[T](a: GVec4[T]): T = a.arr[3]

  template `x=`*[T](a: var GVec234[T], value: T) = a.arr[0] = value
  template `y=`*[T](a: var GVec234[T], value: T) = a.arr[1] = value
  template `z=`*[T](a: var GVec34[T], value: T) = a.arr[2] = value
  template `w=`*[T](a: var GVec4[T], value: T) = a.arr[3] = value

  template `[]`*[T](a: GVec234[T], i: int): T = a.arr[i]
  template `[]=`*[T](a: var GVec234[T], i: int, v: T) = a.arr[i] = v

  type
    GMat2*[T] {.bycopy.} = object
      arr: array[4, T]
    GMat3*[T] {.bycopy.} = object
      arr: array[9, T]
    GMat4*[T] {.bycopy.} = object
      arr: array[16, T]

  proc gmat2*[T](
    m00, m01,
    m10, m11: T
  ): GMat2[T] =
    GMat2[T](arr: [
      m00, m01,
      m10, m11
    ])

  proc gmat3*[T](
    m00, m01, m02,
    m10, m11, m12,
    m20, m21, m22: T
  ): GMat3[T] =
    GMat3[T](arr: [
      m00, m01, m02,
      m10, m11, m12,
      m20, m21, m22
    ])

  proc gmat4*[T](
    m00, m01, m02, m03,
    m10, m11, m12, m13,
    m20, m21, m22, m23,
    m30, m31, m32, m33: T
  ): GMat4[T] =
    GMat4[T](arr: [
      m00, m01, m02, m03,
      m10, m11, m12, m13,
      m20, m21, m22, m23,
      m30, m31, m32, m33
    ])

  template `[]`*[T](a: GMat2[T], i, j: int): T = a.arr[i * 2 + j]
  template `[]`*[T](a: GMat3[T], i, j: int): T = a.arr[i * 3 + j]
  template `[]`*[T](a: GMat4[T], i, j: int): T = a.arr[i * 4 + j]

  template `[]=`*[T](a: var GMat2[T], i, j: int, v: T) = a.arr[i * 2 + j] = v
  template `[]=`*[T](a: var GMat3[T], i, j: int, v: T) = a.arr[i * 3 + j] = v
  template `[]=`*[T](a: var GMat4[T], i, j: int, v: T) = a.arr[i * 4 + j] = v

  template `[]`*[T](a: GMat2[T], i: int): GVec2[T] =
    gvec2[T](
      a[i, 0],
      a[i, 1]
    )

  template `[]`*[T](a: GMat3[T], i: int): GVec3[T] =
    gvec3[T](
      a[i, 0],
      a[i, 1],
      a[i, 2]
    )

  template `[]`*[T](a: GMat4[T], i: int): GVec4[T] =
    gvec4[T](
      a[i, 0],
      a[i, 1],
      a[i, 2],
      a[i, 3]
    )

type
  BVec2* = GVec2[bool]
  BVec3* = GVec3[bool]
  BVec4* = GVec4[bool]

  IVec2* = GVec2[int32]
  IVec3* = GVec3[int32]
  IVec4* = GVec4[int32]

  UVec2* = GVec2[uint32]
  UVec3* = GVec3[uint32]
  UVec4* = GVec4[uint32]

  Vec2* = GVec2[float32]
  Vec3* = GVec3[float32]
  Vec4* = GVec4[float32]

  DVec2* = GVec2[float64]
  DVec3* = GVec3[float64]
  DVec4* = GVec4[float64]

proc `~=`*[T: SomeFloat](a, b: T): bool =
  ## Almost equal.
  const epsilon = 0.000001
  abs(a - b) <= epsilon

proc between*[T](value, min, max: T): bool =
  ## Returns true if value is between min and max or equal to them.
  (value >= min) and (value <= max)

proc sign*[T](v: T): T =
  ## Returns the sign of a number, -1 or 1.
  if v >= 0: 1 else: -1

proc quantize*[T: SomeFloat](v, n: T): T =
  ## Makes v be multiple of n. Rounding to integer quantize by 1.0.
  trunc(v / n) * n

proc fractional*[T: SomeFloat](v: T): T =
  ## Returns fractional part of a number.
  ## 3.14 -> 0.14
  ## -3.14 -> 0.14
  result = abs(v)
  result = result - trunc(result)

proc inversesqrt*[T: float32|float64](v: T): T =
  ## Returns inverse square root.
  1/sqrt(v)

proc mix*[T: SomeFloat](a, b, v: T): T =
  ## Interpolates value between a and b.
  ## * 0 -> a
  ## * 1 -> b
  ## * 0.5 -> between a and b
  v * (b - a) + a

proc fixAngle*[T: SomeFloat](angle: T): T =
  ## Make angle be from -PI to PI radians.
  result = angle
  while result > PI:
    result -= PI * 2
  while result < -PI:
    result += PI * 2

proc angleBetween*[T: SomeFloat](a, b: T): T =
  ## Angle between angle a and angle b.
  fixAngle(b - a)

proc turnAngle*[T: SomeFloat](a, b, speed: T): T =
  ## Move from angle a to angle b with step of v.
  var
    turn = fixAngle(b - a)
  if abs(turn) < speed:
    return b
  elif turn > speed:
    turn = speed
  elif turn < -speed:
    turn = -speed
  a + turn

proc toRadians*[T: SomeFloat](deg: T): T =
  ## Convert degrees to radians.
  PI * deg / 180.0

proc toDegrees*[T: SomeFloat](rad: T): T =
  ## Convert radians to degrees.
  180.0 * rad / PI

proc toRadians*(deg: SomeInteger): float32 =
  ## Convert degrees to radians.
  deg.float32.toRadians

proc toDegrees*(deg: SomeInteger): float32 =
  ## Convert degrees to radians.
  deg.float32.toDegrees

proc isNan*(x: SomeFloat): bool =
  ## Returns true if number is a NaN.
  x != 0.0 and (x != x or x * 0.5 == x)

proc `zmod`*(a, b: float32): float32 =
  ## Float point mod.
  return a - b * floor(a/b)

template lowerType(a: typed): string =
  ($type(a)).toLowerAscii()

template genConstructor(lower, upper, typ: untyped) =

  proc `lower 2`*(): `upper 2` = gvec2[typ](typ(0), typ(0))
  proc `lower 3`*(): `upper 3` = gvec3[typ](typ(0), typ(0), typ(0))
  proc `lower 4`*(): `upper 4` = gvec4[typ](typ(0), typ(0), typ(0), typ(0))

  proc `lower 2`*(x, y: typ): `upper 2` = gvec2[typ](x, y)
  proc `lower 3`*(x, y, z: typ): `upper 3` = gvec3[typ](x, y, z)
  proc `lower 4`*(x, y, z, w: typ): `upper 4` = gvec4[typ](x, y, z, w)

  proc `lower 2`*(x: typ): `upper 2` = gvec2[typ](x, x)
  proc `lower 3`*(x: typ): `upper 3` = gvec3[typ](x, x, x)
  proc `lower 4`*(x: typ): `upper 4` = gvec4[typ](x, x, x, x)

  proc `lower 2`*[T](x: GVec2[T]): `upper 2` =
    gvec2[typ](typ(x[0]), typ(x[1]))
  proc `lower 3`*[T](x: GVec3[T]): `upper 3` =
    gvec3[typ](typ(x[0]), typ(x[1]), typ(x[2]))
  proc `lower 4`*[T](x: GVec4[T]): `upper 4` =
    gvec4[typ](typ(x[0]), typ(x[1]), typ(x[2]), typ(x[3]))

  proc `lower 3`*[T](x: GVec2[T], z: T = 0): `upper 3` =
    gvec3[typ](typ(x[0]), typ(x[1]), z)
  proc `lower 4`*[T](x: GVec3[T], w: T = 0): `upper 4` =
    gvec4[typ](typ(x[0]), typ(x[1]), typ(x[2]), w)

  proc `lower 4`*[T](a, b: GVec2[T]): `upper 4` =
    gvec4[typ](typ(a[0]), typ(a[1]), typ(b[0]), typ(b[1]))

  proc `$`*(a: `upper 2`): string =
    lowerType(a) & "(" & $a.x & ", " & $a.y & ")"
  proc `$`*(a: `upper 3`): string =
    lowerType(a) & "(" & $a.x & ", " & $a.y & ", " & $a.z & ")"
  proc `$`*(a: `upper 4`): string =
    lowerType(a) & "(" & $a.x & ", " & $a.y & ", " & $a.z & ", " & $a.w & ")"

genConstructor(bvec, BVec, bool)
genConstructor(ivec, IVec, int32)
genConstructor(uvec, UVec, uint32)
genConstructor(vec, Vec, float32)
genConstructor(dvec, DVec, float64)

proc vec2*(ivec2: Ivec2): Vec2 =
  vec2(ivec2.x.float32, ivec2.y.float32)

proc vec2*(uvec2: Uvec2): Vec2 =
  vec2(uvec2.x.float32, uvec2.y.float32)

proc ivec2*(uvec2: Uvec2): Ivec2 =
  ivec2(uvec2.x.int32, uvec2.y.int32)

proc uvec2*(ivec2: Ivec2): Uvec2 =
  uvec2(ivec2.x.uint32, ivec2.y.uint32)

proc vec3*(ivec3: Ivec3): Vec3 =
  vec3(ivec3.x.float32, ivec3.y.float32, ivec3.z.float32)

proc vec3*(uvec3: Uvec3): Vec3 =
  vec3(uvec3.x.float32, uvec3.y.float32, uvec3.z.float32)

proc ivec3*(uvec3: Uvec3): Ivec3 =
  ivec3(uvec3.x.int32, uvec3.y.int32, uvec3.z.int32)

proc uvec3*(ivec3: Ivec3): Uvec3 =
  uvec3(ivec3.x.uint32, ivec3.y.uint32, ivec3.z.uint32)

proc vec4*(ivec4: Ivec4): Vec4 =
  vec4(ivec4.x.float32, ivec4.y.float32, ivec4.z.float32, ivec4.w.float32)

proc vec4*(uvec4: Uvec4): Vec4 =
  vec4(uvec4.x.float32, uvec4.y.float32, uvec4.z.float32, uvec4.w.float32)

proc ivec4*(uvec4: Uvec4): Ivec4 =
  ivec4(uvec4.x.int32, uvec4.y.int32, uvec4.z.int32, uvec4.w.int32)

proc uvec4*(ivec4: Ivec4): Uvec4 =
  uvec4(ivec4.x.uint32, ivec4.y.uint32, ivec4.z.uint32, ivec4.w.uint32)

when not defined(nimdoc) or not isMainModule:
  # TODO when https://github.com/nim-lang/Nim/issues/13063 is fixed use macros.
  include vmath/swizzle

proc `==`*[T](a, b: GVec2[T]): bool =
  a.x == b.x and a.y == b.y

proc `==`*[T](a, b: GVec3[T]): bool =
  a.x == b.x and a.y == b.y and a.z == b.z

proc `==`*[T](a, b: GVec4[T]): bool =
  a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w

proc `!=`*[T](a, b: GVec2[T]): bool =
  a.x != b.x or a.y != b.y

proc `!=`*[T](a, b: GVec3[T]): bool =
  a.x != b.x or a.y != b.y or a.z != b.z

proc `!=`*[T](a, b: GVec4[T]): bool =
  a.x != b.x or a.y != b.y or a.z != b.z or a.w != b.w

template genOp(op: untyped) =
  proc op*[T](a, b: GVec2[T]): GVec2[T] =
    gvec2[T](
      op(a[0], b[0]),
      op(a[1], b[1])
    )

  proc op*[T](a, b: GVec3[T]): GVec3[T] =
    gvec3[T](
      op(a[0], b[0]),
      op(a[1], b[1]),
      op(a[2], b[2])
    )

  proc op*[T](a, b: GVec4[T]): GVec4[T] =
    gvec4[T](
      op(a[0], b[0]),
      op(a[1], b[1]),
      op(a[2], b[2]),
      op(a[3], b[3])
    )

  proc op*[T](a: GVec2[T], b: T): GVec2[T] =
    gvec2[T](
      op(a[0], b),
      op(a[1], b)
    )

  proc op*[T](a: GVec3[T], b: T): GVec3[T] =
    gvec3[T](
      op(a[0], b),
      op(a[1], b),
      op(a[2], b)
    )

  proc op*[T](a: GVec4[T], b: T): GVec4[T] =
    gvec4[T](
      op(a[0], b),
      op(a[1], b),
      op(a[2], b),
      op(a[3], b)
    )

  proc op*[T](a: T, b: GVec2[T]): GVec2[T] =
    gvec2[T](
      op(a, b[0]),
      op(a, b[1])
    )

  proc op*[T](a: T, b: GVec3[T]): GVec3[T] =
    gvec3[T](
      op(a, b[0]),
      op(a, b[1]),
      op(a, b[2])
    )

  proc op*[T](a: T, b: GVec4[T]): GVec4[T] =
    gvec4[T](
      op(a, b[0]),
      op(a, b[1]),
      op(a, b[2]),
      op(a, b[3])
    )

genOp(`+`)
genOp(`-`)
genOp(`*`)
genOp(`/`)
genOp(`mod`)
genOp(`div`)
genOp(`zmod`)

template genEqOp(op: untyped) =
  proc op*[T](a: var GVec2[T], b: GVec2[T]) =
    op(a.x, b.x)
    op(a.y, b.y)

  proc op*[T](a: var GVec3[T], b: GVec3[T]) =
    op(a.x, b.x)
    op(a.y, b.y)
    op(a.z, b.z)

  proc op*[T](a: var GVec4[T], b: GVec4[T]) =
    op(a.x, b.x)
    op(a.y, b.y)
    op(a.z, b.z)
    op(a.w, b.w)

  proc op*[T](a: var GVec2[T], b: T) =
    op(a.x, b)
    op(a.y, b)

  proc op*[T](a: var GVec3[T], b: T) =
    op(a.x, b)
    op(a.y, b)
    op(a.z, b)

  proc op*[T](a: var GVec4[T], b: T) =
    op(a.x, b)
    op(a.y, b)
    op(a.z, b)
    op(a.w, b)

genEqOp(`+=`)
genEqOp(`-=`)
genEqOp(`*=`)
genEqOp(`/=`)

template genMathFn(fn: untyped) =
  proc fn*[T](v: GVec2[T]): GVec2[T] =
    gvec2[T](
      fn(v[0]),
      fn(v[1])
    )

  proc fn*[T](v: GVec3[T]): GVec3[T] =
    gvec3[T](
      fn(v[0]),
      fn(v[1]),
      fn(v[2])
    )

  proc fn*[T](v: GVec4[T]): GVec4[T] =
    gvec4[T](
      fn(v[0]),
      fn(v[1]),
      fn(v[2]),
      fn(v[3])
    )

genMathFn(`-`)
genMathFn(sin)
genMathFn(cos)
genMathFn(tan)
genMathFn(arcsin)
genMathFn(arccos)
genMathFn(arctan)
genMathFn(sinh)
genMathFn(cosh)
genMathFn(tanh)
genMathFn(exp2)
genMathFn(inversesqrt)
genMathFn(exp)
genMathFn(ln)
genMathFn(log2)
genMathFn(sqrt)
genMathFn(floor)
genMathFn(ceil)
genMathFn(abs)

template genBoolFn(fn, op: untyped) =
  proc fn*[T](a, b: GVec2[T]): BVec2 =
    result[0] = op(a[0], b[0])
    result[1] = op(a[1], b[1])

  proc fn*[T](a, b: GVec3[T]): BVec3 =
    result[0] = op(a[0], b[0])
    result[1] = op(a[1], b[1])
    result[2] = op(a[2], b[2])

  proc fn*[T](a, b: GVec4[T]): BVec4 =
    result[0] = op(a[0], b[0])
    result[1] = op(a[1], b[1])
    result[2] = op(a[2], b[2])
    result[3] = op(a[3], b[3])

genBoolFn(lessThan, `<`)
genBoolFn(lessThanEqual, `<=`)
genBoolFn(greaterThan, `>`)
genBoolFn(greaterThanEqual, `>=`)
genBoolFn(equal, `==`)
genBoolFn(notEqual, `!=`)

proc `~=`*[T](a, b: GVec2[T]): bool =
  ## Almost equal.
  a.x ~= b.x and a.y ~= b.y

proc `~=`*[T](a, b: GVec3[T]): bool =
  ## Almost equal.
  a.x ~= b.x and a.y ~= b.y and a.z ~= b.z

proc `~=`*[T](a, b: GVec4[T]): bool =
  ## Almost equal.
  a.x ~= b.x and a.y ~= b.y and a.z ~= b.z and a.w ~= b.w

proc length*[T](a: GVec2[T]): T =
  sqrt(a.x*a.x + a.y*a.y)

proc length*[T](a: GVec3[T]): T =
  sqrt(a.x*a.x + a.y*a.y + a.z*a.z)

proc length*[T](a: GVec4[T]): T =
  sqrt(a.x*a.x + a.y*a.y + a.z*a.z + a.w*a.w)

proc lengthSq*[T](a: GVec2[T]): T =
  a.x*a.x + a.y*a.y

proc lengthSq*[T](a: GVec3[T]): T =
  a.x*a.x + a.y*a.y + a.z*a.z

proc lengthSq*[T](a: GVec4[T]): T =
  a.x*a.x + a.y*a.y + a.z*a.z + a.w*a.w

proc normalize*[T](a: GVec234[T]): type(a) =
  a / a.length

proc mix*[T: SomeFloat](a, b: GVec234[T], v: T): type(a) =
  a * (1.0 - v) + b * v

proc lerp*[V, T](a, b: V, v: T): type(a) {.deprecated: "use mix instead".} =
  mix(a, b, v)

proc dot*[T](a, b: GVec2[T]): T =
  a.x * b.x + a.y * b.y

proc dot*[T](a, b: GVec3[T]): T =
  a.x * b.x + a.y * b.y + a.z * b.z

proc dot*[T](a, b: GVec4[T]): T =
  a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w

proc mix*[T: SomeFloat](a, b, v: GVec2[T]): type(a) =
  result.x = a.x * (1.0 - v.x) + b.x * v.x
  result.y = a.y * (1.0 - v.y) + b.y * v.y

proc mix*[T: SomeFloat](a, b, v: GVec3[T]): type(a) =
  result.x = a.x * (1.0 - v.x) + b.x * v.x
  result.y = a.y * (1.0 - v.y) + b.y * v.y
  result.z = a.z * (1.0 - v.z) + b.z * v.z

proc mix*[T: SomeFloat](a, b, v: GVec4[T]): type(a) =
  result.x = a.x * (1.0 - v.x) + b.x * v.x
  result.y = a.y * (1.0 - v.y) + b.y * v.y
  result.z = a.z * (1.0 - v.z) + b.z * v.z
  result.w = a.w * (1.0 - v.w) + b.w * v.w

proc cross*[T](a, b: GVec3[T]): GVec3[T] =
  gvec3(
    a.y * b.z - a.z * b.y,
    a.z * b.x - a.x * b.z,
    a.x * b.y - a.y * b.x
  )

proc dist*[T](at, to: GVec234[T]): T =
  (at - to).length

proc distSq*[T](at, to: GVec234[T]): T =
  (at - to).lengthSq

proc dir*[T](at, to: GVec234[T]): type(to) =
  (at - to).normalize

proc dir*[T](angle: T): GVec2[T] =
  gvec2(
    cos(angle),
    sin(angle),
  )

proc min*(a, b: Vec2): Vec2 =
  vec2(min(a.x, b.x), min(a.y, b.y))

proc min*(a, b: Vec3): Vec3 =
  vec3(min(a.x, b.x), min(a.y, b.y), min(a.z, b.z))

proc min*(a, b: Vec4): Vec4 =
  vec4(min(a.x, b.x), min(a.y, b.y), min(a.z, b.z), min(a.w, b.w))

proc max*(a, b: Vec2): Vec2 =
  vec2(max(a.x, b.x), max(a.y, b.y))

proc max*(a, b: Vec3): Vec3 =
  vec3(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z))

proc max*(a, b: Vec4): Vec4 =
  vec4(max(a.x, b.x), max(a.y, b.y), max(a.z, b.z), max(a.w, b.w))

type
  Mat2* = GMat2[float32]
  Mat3* = GMat3[float32]
  Mat4* = GMat4[float32]

  DMat2* = GMat2[float64]
  DMat3* = GMat3[float64]
  DMat4* = GMat4[float64]

proc matToString[T](a: T, n: int): string =
  result = ($type(a)).toLowerAscii()
  result.add "(\n"
  for x in 0 ..< n:
    result.add "  "
    for y in 0 ..< n:
      result.add $a[x, y] & ", "
    result.setLen(result.len - 1)
    result.add "\n"
  result.setLen(result.len - 2)
  result.add "\n)"

template genMatConstructor(lower, upper, T: untyped) =

  proc `lower 2`*(
    m00, m01,
    m10, m11: T
  ): `upper 2` =
    result[0, 0] = m00; result[0, 1] = m01
    result[1, 0] = m10; result[1, 1] = m11

  proc `lower 3`*(
    m00, m01, m02,
    m10, m11, m12,
    m20, m21, m22: T
  ): `upper 3` =
    result[0, 0] = m00; result[0, 1] = m01; result[0, 2] = m02
    result[1, 0] = m10; result[1, 1] = m11; result[1, 2] = m12
    result[2, 0] = m20; result[2, 1] = m21; result[2, 2] = m22

  proc `lower 4`*(
    m00, m01, m02, m03,
    m10, m11, m12, m13,
    m20, m21, m22, m23,
    m30, m31, m32, m33: T
  ): `upper 4` =
    result[0, 0] = m00; result[0, 1] = m01
    result[0, 2] = m02; result[0, 3] = m03

    result[1, 0] = m10; result[1, 1] = m11
    result[1, 2] = m12; result[1, 3] = m13

    result[2, 0] = m20; result[2, 1] = m21
    result[2, 2] = m22; result[2, 3] = m23

    result[3, 0] = m30; result[3, 1] = m31
    result[3, 2] = m32; result[3, 3] = m33

  proc `lower 2`*(a, b: GVec2[T]): `upper 2` =
    gmat2[T](
      a.x, a.y,
      b.x, b.y
    )
  proc `lower 3`*(a, b, c: GVec3[T]): `upper 3` =
    gmat3[T](
      a.x, a.y, a.z,
      b.x, b.y, b.z,
      c.x, c.y, c.z,
    )
  proc `lower 4`*(a, b, c, d: GVec4[T]): `upper 4` =
    gmat4[T](
      a.x, a.y, a.z, a.w,
      b.x, b.y, b.z, b.w,
      c.x, c.y, c.z, c.w,
      d.x, d.y, d.z, d.w,
    )

  proc `lower 2`*(): `upper 2` =
    gmat2[T](
      1.T, 0.T,
      0.T, 1.T
    )
  proc `lower 3`*(): `upper 3` =
    gmat3[T](
      1.T, 0.T, 0.T,
      0.T, 1.T, 0.T,
      0.T, 0.T, 1.T
    )
  proc `lower 4`*(): `upper 4` =
    gmat4[T](
      1.T, 0.T, 0.T, 0.T,
      0.T, 1.T, 0.T, 0.T,
      0.T, 0.T, 1.T, 0.T,
      0.T, 0.T, 0.T, 1.T
    )

  proc `$`*(a: `upper 2`): string = matToString(a, 2)
  proc `$`*(a: `upper 3`): string = matToString(a, 3)
  proc `$`*(a: `upper 4`): string = matToString(a, 4)

genMatConstructor(mat, Mat, float32)
genMatConstructor(dmat, DMat, float64)

proc `~=`*[T](a, b: GMat2[T]): bool =
  a[0] ~= b[0] and a[1] ~= b[1]

proc `~=`*[T](a, b: GMat3[T]): bool =
  a[0] ~= b[0] and a[1] ~= b[1] and a[2] ~= b[2]

proc `~=`*[T](a, b: GMat4[T]): bool =
  a[0] ~= b[0] and a[1] ~= b[1] and a[2] ~= b[2] and a[3] ~= b[3]

proc pos*[T](a: GMat3[T]): GVec2[T] =
  gvec2[T](a[2].x, a[2].y)

proc `pos=`*[T](a: var GMat3[T], pos: GVec2[T]) =
  a[2, 0] = pos.x
  a[2, 1] = pos.y

proc pos*[T](a: GMat4[T]): GVec3[T] =
  gvec3[T](a[3].x, a[3].y, a[3].z)

proc `pos=`*[T](a: var GMat4[T], pos: GVec3[T]) =
  a[3, 0] = pos.x
  a[3, 1] = pos.y
  a[3, 2] = pos.z

proc `*`*[T](a, b: GMat3[T]): GMat3[T] =
  result[0, 0] = b[0, 0] * a[0, 0] + b[0, 1] * a[1, 0] + b[0, 2] * a[2, 0]
  result[0, 1] = b[0, 0] * a[0, 1] + b[0, 1] * a[1, 1] + b[0, 2] * a[2, 1]
  result[0, 2] = b[0, 0] * a[0, 2] + b[0, 1] * a[1, 2] + b[0, 2] * a[2, 2]

  result[1, 0] = b[1, 0] * a[0, 0] + b[1, 1] * a[1, 0] + b[1, 2] * a[2, 0]
  result[1, 1] = b[1, 0] * a[0, 1] + b[1, 1] * a[1, 1] + b[1, 2] * a[2, 1]
  result[1, 2] = b[1, 0] * a[0, 2] + b[1, 1] * a[1, 2] + b[1, 2] * a[2, 2]

  result[2, 0] = b[2, 0] * a[0, 0] + b[2, 1] * a[1, 0] + b[2, 2] * a[2, 0]
  result[2, 1] = b[2, 0] * a[0, 1] + b[2, 1] * a[1, 1] + b[2, 2] * a[2, 1]
  result[2, 2] = b[2, 0] * a[0, 2] + b[2, 1] * a[1, 2] + b[2, 2] * a[2, 2]

proc `*`*[T](a: GMat2[T], b: GVec2[T]): GVec2[T] =
  gvec2[T](
    a[0, 0] * b.x + a[1, 0] * b.y,
    a[0, 1] * b.x + a[1, 1] * b.y
  )

proc `*`*[T](a: GMat3[T], b: GVec2[T]): GVec2[T] =
  gvec2[T](
    a[0, 0] * b.x + a[1, 0] * b.y + a[2, 0],
    a[0, 1] * b.x + a[1, 1] * b.y + a[2, 1]
  )

proc `*`*[T](a: GMat3[T], b: GVec3[T]): GVec3[T] =
  gvec3[T](
    a[0, 0] * b.x + a[1, 0] * b.y + a[2, 0] * b.z,
    a[0, 1] * b.x + a[1, 1] * b.y + a[2, 1] * b.z,
    a[0, 2] * b.x + a[1, 2] * b.y + a[2, 2] * b.z,
  )

proc `*`*[T](a, b: GMat4[T]): GMat4[T] =
  let
    a00 = a[0, 0]
    a01 = a[0, 1]
    a02 = a[0, 2]
    a03 = a[0, 3]
    a10 = a[1, 0]
    a11 = a[1, 1]
    a12 = a[1, 2]
    a13 = a[1, 3]
    a20 = a[2, 0]
    a21 = a[2, 1]
    a22 = a[2, 2]
    a23 = a[2, 3]
    a30 = a[3, 0]
    a31 = a[3, 1]
    a32 = a[3, 2]
    a33 = a[3, 3]

  let
    b00 = b[0, 0]
    b01 = b[0, 1]
    b02 = b[0, 2]
    b03 = b[0, 3]
    b10 = b[1, 0]
    b11 = b[1, 1]
    b12 = b[1, 2]
    b13 = b[1, 3]
    b20 = b[2, 0]
    b21 = b[2, 1]
    b22 = b[2, 2]
    b23 = b[2, 3]
    b30 = b[3, 0]
    b31 = b[3, 1]
    b32 = b[3, 2]
    b33 = b[3, 3]

  result[0, 0] = b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30
  result[0, 1] = b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31
  result[0, 2] = b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32
  result[0, 3] = b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33

  result[1, 0] = b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30
  result[1, 1] = b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31
  result[1, 2] = b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32
  result[1, 3] = b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33

  result[2, 0] = b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30
  result[2, 1] = b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31
  result[2, 2] = b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32
  result[2, 3] = b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33

  result[3, 0] = b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30
  result[3, 1] = b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31
  result[3, 2] = b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32
  result[3, 3] = b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33

proc `*`*[T](a: GMat4[T], b: GVec3[T]): GVec3[T] =
  gvec3[T](
    a[0, 0] * b.x + a[1, 0] * b.y + a[2, 0] * b.z + a[3, 0],
    a[0, 1] * b.x + a[1, 1] * b.y + a[2, 1] * b.z + a[3, 1],
    a[0, 2] * b.x + a[1, 2] * b.y + a[2, 2] * b.z + a[3, 2]
  )

proc `*`*[T](a: GMat4[T], b: GVec4[T]): GVec4[T] =
  gvec4[T](
    a[0, 0] * b.x + a[1, 0] * b.y + a[2, 0] * b.z + a[3, 0] * b.w,
    a[0, 1] * b.x + a[1, 1] * b.y + a[2, 1] * b.z + a[3, 1] * b.w,
    a[0, 2] * b.x + a[1, 2] * b.y + a[2, 2] * b.z + a[3, 2] * b.w,
    a[0, 3] * b.x + a[1, 3] * b.y + a[2, 3] * b.z + a[3, 3] * b.w
  )

proc transpose*[T](a: GMat3[T]): GMat3[T] =
  ## Return an transpose of the matrix.
  gmat3[T](
    a[0, 0], a[1, 0], a[2, 0],
    a[0, 1], a[1, 1], a[2, 1],
    a[0, 2], a[1, 2], a[2, 2]
  )

proc transpose*[T](a: GMat4[T]): GMat4[T] =
  ## Return an transpose of the matrix.
  gmat4[T](
    a[0, 0], a[1, 0], a[2, 0], a[3, 0],
    a[0, 1], a[1, 1], a[2, 1], a[3, 1],
    a[0, 2], a[1, 2], a[2, 2], a[3, 2],
    a[0, 3], a[1, 3], a[2, 3], a[3, 3]
  )

proc determinant*[T](a: GMat3[T]): T =
  ## Compute a determinant of the matrix.
  (
    a[0, 0] * (a[1, 1] * a[2, 2] - a[2, 1] * a[1, 2]) -
    a[0, 1] * (a[1, 0] * a[2, 2] - a[1, 2] * a[2, 0]) +
    a[0, 2] * (a[1, 0] * a[2, 1] - a[1, 1] * a[2, 0])
  )

proc determinant*[T](a: GMat4[T]): T =
  ## Compute a determinant of the matrix.
  let
    a00 = a[0, 0]
    a01 = a[0, 1]
    a02 = a[0, 2]
    a03 = a[0, 3]
    a10 = a[1, 0]
    a11 = a[1, 1]
    a12 = a[1, 2]
    a13 = a[1, 3]
    a20 = a[2, 0]
    a21 = a[2, 1]
    a22 = a[2, 2]
    a23 = a[2, 3]
    a30 = a[3, 0]
    a31 = a[3, 1]
    a32 = a[3, 2]
    a33 = a[3, 3]
  (
    a30*a21*a12*a03 - a20*a31*a12*a03 - a30*a11*a22*a03 + a10*a31*a22*a03 +
    a20*a11*a32*a03 - a10*a21*a32*a03 - a30*a21*a02*a13 + a20*a31*a02*a13 +
    a30*a01*a22*a13 - a00*a31*a22*a13 - a20*a01*a32*a13 + a00*a21*a32*a13 +
    a30*a11*a02*a23 - a10*a31*a02*a23 - a30*a01*a12*a23 + a00*a31*a12*a23 +
    a10*a01*a32*a23 - a00*a11*a32*a23 - a20*a11*a02*a33 + a10*a21*a02*a33 +
    a20*a01*a12*a33 - a00*a21*a12*a33 - a10*a01*a22*a33 + a00*a11*a22*a33
  )

proc inverse*[T](a: GMat3[T]): GMat3[T] =
  ## Return an inverse of the matrix.
  let
    invDet = 1 / a.determinant

  result[0, 0] = +(a[1, 1] * a[2, 2] - a[2, 1] * a[1, 2]) * invDet
  result[0, 1] = -(a[0, 1] * a[2, 2] - a[0, 2] * a[2, 1]) * invDet
  result[0, 2] = +(a[0, 1] * a[1, 2] - a[0, 2] * a[1, 1]) * invDet

  result[1, 0] = -(a[1, 0] * a[2, 2] - a[1, 2] * a[2, 0]) * invDet
  result[1, 1] = +(a[0, 0] * a[2, 2] - a[0, 2] * a[2, 0]) * invDet
  result[1, 2] = -(a[0, 0] * a[1, 2] - a[1, 0] * a[0, 2]) * invDet

  result[2, 0] = +(a[1, 0] * a[2, 1] - a[2, 0] * a[1, 1]) * invDet
  result[2, 1] = -(a[0, 0] * a[2, 1] - a[2, 0] * a[0, 1]) * invDet
  result[2, 2] = +(a[0, 0] * a[1, 1] - a[1, 0] * a[0, 1]) * invDet

proc inverse*[T](a: GMat4[T]): GMat4[T] =
  ## Return an inverse of the matrix.
  let
    a00 = a[0, 0]
    a01 = a[0, 1]
    a02 = a[0, 2]
    a03 = a[0, 3]
    a10 = a[1, 0]
    a11 = a[1, 1]
    a12 = a[1, 2]
    a13 = a[1, 3]
    a20 = a[2, 0]
    a21 = a[2, 1]
    a22 = a[2, 2]
    a23 = a[2, 3]
    a30 = a[3, 0]
    a31 = a[3, 1]
    a32 = a[3, 2]
    a33 = a[3, 3]

  let
    b00 = a00 * a11 - a01 * a10
    b01 = a00 * a12 - a02 * a10
    b02 = a00 * a13 - a03 * a10
    b03 = a01 * a12 - a02 * a11
    b04 = a01 * a13 - a03 * a11
    b05 = a02 * a13 - a03 * a12
    b06 = a20 * a31 - a21 * a30
    b07 = a20 * a32 - a22 * a30
    b08 = a20 * a33 - a23 * a30
    b09 = a21 * a32 - a22 * a31
    b10 = a21 * a33 - a23 * a31
    b11 = a22 * a33 - a23 * a32

  # Calculate the inverse determinant.
  let invDet = 1 / a.determinant

  result[0, 0] = (+a11 * b11 - a12 * b10 + a13 * b09) * invDet
  result[0, 1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet
  result[0, 2] = (+a31 * b05 - a32 * b04 + a33 * b03) * invDet
  result[0, 3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet

  result[1, 0] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet
  result[1, 1] = (+a00 * b11 - a02 * b08 + a03 * b07) * invDet
  result[1, 2] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet
  result[1, 3] = (+a20 * b05 - a22 * b02 + a23 * b01) * invDet

  result[2, 0] = (+a10 * b10 - a11 * b08 + a13 * b06) * invDet
  result[2, 1] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet
  result[2, 2] = (+a30 * b04 - a31 * b02 + a33 * b00) * invDet
  result[2, 3] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet

  result[3, 0] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet
  result[3, 1] = (+a00 * b09 - a01 * b07 + a02 * b06) * invDet
  result[3, 2] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet
  result[3, 3] = (+a20 * b03 - a21 * b01 + a22 * b00) * invDet

proc scale*[T](v: GVec2[T]): GMat3[T] =
  ## Create scale matrix.
  gmat3[T](
    v.x, 0, 0,
    0, v.y, 0,
    0, 0, 1
  )

proc scale*[T](v: GVec3[T]): GMat4[T] =
  ## Create scale matrix.
  gmat4[T](
    v.x, 0, 0, 0,
    0, v.y, 0, 0,
    0, 0, v.z, 0,
    0, 0, 0, 1
  )

proc translate*[T](v: GVec2[T]): GMat3[T] =
  ## Create translation matrix.
  gmat3[T](
    1, 0, 0,
    0, 1, 0,
    v.x, v.y, 1
  )

proc translate*[T](v: GVec3[T]): GMat4[T] =
  ## Create translation matrix.
  gmat4[T](
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    v.x, v.y, v.z, 1
  )

proc rotate*[T](angle: T): GMat3[T] =
  ## Create a rotation matrix by an angle.
  let
    sin = sin(angle)
    cos = cos(angle)
  gmat3[T](
    cos, -sin, 0,
    sin, cos, 0,
    0, 0, 1
  )

proc hrp*[T](m: GMat4[T]): GVec3[T] =
  ## Return heading, rotation and pivot of a matrix.
  var heading, pitch, roll: float32
  if m[1] > 0.998: # singularity at north pole
    heading = arctan2(m[2], m[10])
    pitch = PI / 2
    roll = 0
  elif m[1] < -0.998: # singularity at south pole
    heading = arctan2(m[2], m[10])
    pitch = -PI / 2
    roll = 0
  else:
    heading = arctan2(-m[8], m[0])
    pitch = arctan2(-m[6], m[5])
    roll = arcsin(m[4])
  gvec3[T](heading, pitch, roll)

proc frustum*[T](left, right, bottom, top, near, far: T): GMat4[T] =
  ## Create a frustum matrix.
  let
    rl = (right - left)
    tb = (top - bottom)
    fn = (far - near)

  result[0, 0] = (near * 2) / rl
  result[0, 1] = 0
  result[0, 2] = 0
  result[0, 3] = 0

  result[1, 0] = 0
  result[1, 1] = (near * 2) / tb
  result[1, 2] = 0
  result[1, 3] = 0

  result[2, 0] = (right + left) / rl
  result[2, 1] = (top + bottom) / tb
  result[2, 2] = -(far + near) / fn
  result[2, 3] = -1

  result[3, 0] = 0
  result[3, 1] = 0
  result[3, 2] = -(far * near * 2) / fn
  result[3, 3] = 0

proc perspective*[T](fovy, aspect, near, far: T): GMat4[T] =
  ## Create a perspective matrix.
  let
    top: T = near * tan(fovy * PI.float32 / 360.0)
    right: T = top * aspect
  frustum(-right, right, -top, top, near, far)

proc ortho*[T](left, right, bottom, top, near, far: T): GMat4[T] =
  ## Create an orthographic matrix.
  let
    rl: T = (right - left)
    tb: T = (top - bottom)
    fn: T = (far - near)

  result[0, 0] = T(2 / rl)
  result[0, 1] = 0
  result[0, 2] = 0
  result[0, 3] = 0

  result[1, 0] = 0
  result[1, 1] = T(2 / tb)
  result[1, 2] = 0
  result[1, 3] = 0

  result[2, 0] = 0
  result[2, 1] = 0
  result[2, 2] = T(-2 / fn)
  result[2, 3] = 0

  result[3, 0] = T(-(left + right) / rl)
  result[3, 1] = T(-(top + bottom) / tb)
  result[3, 2] = T(-(far + near) / fn)
  result[3, 3] = 1

proc lookAt*[T](eye, center, up: GVec3[T]): GMat4[T] =
  ## Create a matrix that would convert eye pos to looking at center.
  let
    eyex = eye[0]
    eyey = eye[1]
    eyez = eye[2]
    upx = up[0]
    upy = up[1]
    upz = up[2]
    centerx = center[0]
    centery = center[1]
    centerz = center[2]

  if eyex == centerx and eyey == centery and eyez == centerz:
    return mat4[T]()

  var
    # vec3.direction(eye, center, z)
    z0 = eyex - center[0]
    z1 = eyey - center[1]
    z2 = eyez - center[2]

  # normalize (no check needed for 0 because of early return)
  var len = 1 / sqrt(z0 * z0 + z1 * z1 + z2 * z2)
  z0 *= len
  z1 *= len
  z2 *= len

  var
    # vec3.normalize(vec3.cross(up, z, x))
    x0 = upy * z2 - upz * z1
    x1 = upz * z0 - upx * z2
    x2 = upx * z1 - upy * z0
  len = sqrt(x0 * x0 + x1 * x1 + x2 * x2)
  if len == 0:
    x0 = 0
    x1 = 0
    x2 = 0
  else:
    len = 1 / len
    x0 *= len
    x1 *= len
    x2 *= len

  var
    # vec3.normalize(vec3.cross(z, x, y))
    y0 = z1 * x2 - z2 * x1
    y1 = z2 * x0 - z0 * x2
    y2 = z0 * x1 - z1 * x0

  len = sqrt(y0 * y0 + y1 * y1 + y2 * y2)
  if len == 0:
    y0 = 0
    y1 = 0
    y2 = 0
  else:
    len = 1/len
    y0 *= len
    y1 *= len
    y2 *= len

  result[0, 0] = x0
  result[0, 1] = y0
  result[0, 2] = z0
  result[0, 3] = 0

  result[1, 0] = x1
  result[1, 1] = y1
  result[1, 2] = z1
  result[1, 3] = 0

  result[2, 0] = x2
  result[2, 1] = y2
  result[2, 2] = z2
  result[2, 3] = 0

  result[3, 0] = -(x0 * eyex + x1 * eyey + x2 * eyez)
  result[3, 1] = -(y0 * eyex + y1 * eyey + y2 * eyez)
  result[3, 2] = -(z0 * eyex + z1 * eyey + z2 * eyez)
  result[3, 3] = 1

proc lookAt*[T](eye, center: GVec3[T]): GMat4[T] =
  ## Look center from eye with default UP vector.
  lookAt(eye, center, gvec3(T(0), 0, 1))

proc angle*[T](a: GVec2[T]): T =
  ## Angle of a Vec2.
  arctan2(a.y, a.x)

proc angle*[T](a, b: GVec2[T]): T =
  ## Angle between 2 Vec2.
  fixAngle(arctan2(a.y - b.y, a.x - b.x))

proc angle*[T](a, b: GVec3[T]): T =
  ## Angle between 2 Vec3.
  var dot = dot(a, b)
  dot = dot / (a.length * b.length)
  arccos(dot)

type
  Quat* = GVec4[float32]
  DQuat* = GVec4[float64]

template genQuatConstructor(lower, upper, typ: untyped) =
  proc `lower`*(): `upper` = gvec4[typ](0, 0, 0, 1)
  proc `lower`*(x, y, z, w: typ): `upper` = gvec4[typ](x, y, z, w)
  proc `lower`*(x: typ): `upper` = gvec4[typ](x, x, x, x)
  proc `lower`*[T](x: GVec4[T]): `upper` =
    gvec4[typ](typ(x[0]), typ(x[1]), typ(x[2]), typ(x[3]))

genQuatConstructor(quat, Quat, float32)
genQuatConstructor(dquat, DQuat, float64)

proc fromAxisAngle*[T](axis: GVec3[T], angle: T): GVec4[T] =
  ## Create a quaternion from axis and angle.
  let
    a = axis.normalize()
    s = sin(angle / 2)
  gvec4[T](
    a.x * s,
    a.y * s,
    a.z * s,
    cos(angle / 2)
  )

proc toAxisAngle*[T](q: GVec4[T]): (GVec3[T], T) =
  ## Convert a quaternion to axis and angle.
  let cosAngle = q.w
  let angle = arccos(cosAngle) * 2.0
  var
    sinAngle = sqrt(1.0 - cosAngle * cosAngle)
    axis: GVec4[T]

  if abs(sinAngle) < 0.0005:
    sinAngle = 1.0

  axis.x = [
    q.x / sinAngle,
    q.y / sinAngle,
    q.z / sinAngle
  ]
  return (axis, angle)

proc orthogonal*[T](v: GVec3[T]): GVec3[T] =
  ## Returns orthogonal vector to given vector.
  let
    v = abs(v)
    other: type(v) =
      if v.x < v.y:
        if v.x < v.z:
          gvec3(T(1), 0, 0) # X_AXIS
        else:
          gvec3(T(0), 0, 1) # Z_AXIS
      elif v.y < v.z:
        gvec3(T(0), 1, 0)   # Y_AXIS
      else:
        gvec3(T(0), 0, 1)   # Z_AXIS
  return cross(v, other)

proc fromTwoVectors*[T](a, b: GVec3[T]): GVec4[T] =
  ## Return a quat that would take a and rotate it into b.

  # It is important that the inputs are of equal length when
  # calculating the half-way vector.
  let
    u = b.normalize()
    v = a.normalize()

  # Unfortunately, we have to check for when u == -v, as u + v
  # in this case will be (0, 0, 0), which cannot be normalized.
  if (u == -v):
    # 180 degree rotation around any orthogonal vector
    let q = normalize(orthogonal(u))
    return gvec4(q.x, q.y, q.z, 0)

  let
    half = normalize(u + v)
    q = cross(u, half)
    w = dot(u, half)
  return gvec4(q.x, q.y, q.z, w)

proc nlerp*(a: Quat, b: Quat, v: float32): Quat =
  if dot(a, b) < 0:
    (-a * (1.0 - v) + b * v).normalize()
  else:
    (a * (1.0 - v) + b * v).normalize()

proc quat*[T](m: GMat4[T]): GVec4[T] =
  ## Create a quaternion from matrix.
  let
    m00 = m[0, 0]
    m01 = m[1, 0]
    m02 = m[2, 0]

    m10 = m[0, 1]
    m11 = m[1, 1]
    m12 = m[2, 1]

    m20 = m[0, 2]
    m21 = m[1, 2]
    m22 = m[2, 2]

  var
    q: GVec4[T]
    t: T

  if m22 < 0:
    if m00 > m11:
      t = 1 + m00 - m11 - m22
      q = gvec4(t, m01 + m10, m20 + m02, m12 - m21)
    else:
      t = 1 - m00 + m11 - m22
      q = gvec4(m01 + m10, t, m12 + m21, m20 - m02)
  else:
    if m00 < - m11:
      t = 1 - m00 - m11 + m22
      q = gvec4(m20 + m02, m12 + m21, t, m01 - m10)
    else:
      t = 1 + m00 + m11 + m22
      q = gvec4(m12 - m21, m20 - m02, m01 - m10, t)
  q = q * (0.5 / sqrt(t))

  if abs(q.length - 1.0) > 0.001:
    return gvec4(T(0), 0, 0, 1)

  return q

proc mat4*[T](q: GVec4[T]): GMat4[T] =
  let
    xx = q.x * q.x
    xy = q.x * q.y
    xz = q.x * q.z
    xw = q.x * q.w

    yy = q.y * q.y
    yz = q.y * q.z
    yw = q.y * q.w

    zz = q.z * q.z
    zw = q.z * q.w

  result[0, 0] = 1 - 2 * (yy + zz)
  result[0, 1] = 0 + 2 * (xy - zw)
  result[0, 2] = 0 + 2 * (xz + yw)
  result[0, 3] = 0

  result[1, 0] = 0 + 2 * (xy + zw)
  result[1, 1] = 1 - 2 * (xx + zz)
  result[1, 2] = 0 + 2 * (yz - xw)
  result[1, 3] = 0

  result[2, 0] = 0 + 2 * (xz - yw)
  result[2, 1] = 0 + 2 * (yz + xw)
  result[2, 2] = 1 - 2 * (xx + yy)
  result[2, 3] = 0

  result[3, 0] = 0
  result[3, 1] = 0
  result[3, 2] = 0
  result[3, 3] = 1.0

proc rotate*[T](angle: T, axis: GVec3[T]): GMat4[T] =
  ## Return a rotation matrix with axis and angle.
  fromAxisAngle(axis, angle).mat4()

proc rotateX*[T](angle: T): GMat4[T] =
  ## Return a rotation matrix around X with angle.
  fromAxisAngle(gvec3[T](1, 0, 0), angle).mat4()

proc rotateY*[T](angle: T): GMat4[T] =
  ## Return a rotation matrix around Y with angle.
  fromAxisAngle(gvec3[T](0, 1, 0), angle).mat4()

proc rotateZ*[T](angle: T): GMat4[T] =
  ## Return a rotation matrix around Z with angle.
  fromAxisAngle(gvec3[T](0, 0, 1), angle).mat4()

when defined(release):
  {.pop.}
{.pop.}
