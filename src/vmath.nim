import math
export math

type
  GVec2*[T] = array[2, T]
  GVec3*[T] = array[3, T]
  GVec4*[T] = array[4, T]

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

  GVec34[T] = GVec3[T] | GVec4[T]
  GVec234[T] = GVec2[T] | GVec3[T] | GVec4[T]

{.push inline.}
when defined(release):
  {.push noinit, checks:off.}

proc `~=`*[T:SomeFloat](a, b: T): bool =
  ## Almost equal.
  const epsilon = 0.000001
  abs(a - b) <= epsilon

proc between*[T](value, min, max: T): bool =
  ## Returns true if value is between min and max or equal to them.
  (value >= min) and (value <= max)

proc sign*[T](v: T): T =
  ## Returns the sign of a number, -1 or 1.
  if v >= 0: 1 else: -1

proc quantize*[T:SomeFloat](v, n: T): T =
  ## Makes v be multiple of n. Rounding to integer quantize by 1.0.
  sign(v) * floor(abs(v) / n) * n

proc lerp*[T:SomeFloat](a, b, v: T): T =
  ## Interpolates value between a and b.
  ## * 0 -> a
  ## * 1 -> b
  ## * 0.5 -> between a and b
  a * (1.0 - v) + b * v

proc fixAngle*[T:SomeFloat](angle: T): T =
  ## Make angle be from -PI to PI radians.
  var angle = angle
  while angle > PI:
    angle -= PI * 2
  while angle < -PI:
    angle += PI * 2
  angle

proc angleBetween*[T:SomeFloat](a, b: T): T =
  ## Angle between angle a and angle b.
  fixAngle(b - a)

proc turnAngle*[T:SomeFloat](a, b, speed: T): T =
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

proc toRadians*[T:SomeFloat](deg: T): T =
  return PI * deg / 180.0

proc toDegrees*[T:SomeFloat](rad: T): T =
  return fixAngle(180.0 * rad / PI)

proc gvec2*[T](x, y: T): GVec2[T] =
  [x, y]

proc gvec3*[T](x, y, z: T): GVec3[T] =
  [x, y, z]

proc gvec4*[T](x, y, z, w: T): GVec4[T] =
  [x, y, z, w]

template genConstructor(lower, upper, typ: untyped) =
  proc `lower 2`*(x, y: typ): `upper 2` = gvec2[typ](x, y)
  proc `lower 3`*(x, y, z: typ): `upper 3` = gvec3[typ](x, y, z)
  proc `lower 4`*(x, y, z, w: typ): `upper 4` = gvec4[typ](x, y, z, w)

  proc `lower 2`*(x: typ): `upper 2` = gvec2[typ](x, x)
  proc `lower 3`*(x: typ): `upper 3` = gvec3[typ](x, x, x)
  proc `lower 4`*(x: typ): `upper 4` = gvec4[typ](x, x, x, x)

  proc `lower 2`*[T](x: GVec2[T]): `upper 2` = gvec2[typ](typ(x[0]), typ(x[1]))
  proc `lower 3`*[T](x: GVec3[T]): `upper 3` = gvec3[typ](typ(x[0]), typ(x[1]), typ(x[2]))
  proc `lower 4`*[T](x: GVec4[T]): `upper 4` = gvec4[typ](typ(x[0]), typ(x[1]), typ(x[2]), typ(x[3]))

  proc `lower 3`*[T](x: GVec2[T]): `upper 3` = gvec3[typ](typ(x[0]), typ(x[1]), 0)
  proc `lower 4`*[T](x: GVec3[T]): `upper 4` = gvec4[typ](typ(x[0]), typ(x[1]), typ(x[2]), 0)

genConstructor(bvec, BVec, bool)
genConstructor(ivec, IVec, int32)
genConstructor(uvec, UVec, uint32)
genConstructor(vec, Vec, float32)
genConstructor(dvec, DVec, float64)

proc x*[T](a: var GVec2[T]): var T = a[0]
proc y*[T](a: var GVec2[T]): var T = a[1]

proc x*[T](a: var GVec3[T]): var T = a[0]
proc y*[T](a: var GVec3[T]): var T = a[1]
proc z*[T](a: var GVec3[T]): var T = a[2]

proc x*[T](a: var GVec4[T]): var T = a[0]
proc y*[T](a: var GVec4[T]): var T = a[1]
proc z*[T](a: var GVec4[T]): var T = a[2]
proc w*[T](a: var GVec4[T]): var T = a[3]

proc x*[T](a: GVec2[T]): T = a[0]
proc x*[T](a: GVec3[T]): T = a[0]
proc x*[T](a: GVec4[T]): T = a[0]

proc y*[T](a: GVec2[T]): T = a[1]
proc y*[T](a: GVec3[T]): T = a[1]
proc y*[T](a: GVec4[T]): T = a[1]

proc z*[T](a: GVec2[T]): T = {.error: "using .w on a Vec2".}
proc z*[T](a: GVec3[T]): T = a[2]
proc z*[T](a: GVec4[T]): T = a[2]

proc w*[T](a: GVec2[T]): T = {.error: "using .w on a Vec2".}
proc w*[T](a: GVec3[T]): T = {.error: "using .w on a Vec3".}
proc w*[T](a: GVec4[T]): T = a[3]

proc `x=`*[T](a: var GVec234[T], value: T) = a[0] = value
proc `y=`*[T](a: var GVec234[T], value: T) = a[1] = value
proc `z=`*[T](a: var GVec34[T], value: T) = a[2] = value
proc `w=`*[T](a: var GVec4[T], value: T) = a[3] = value

proc xy*[T](a: GVec234[T]): GVec2[T] = [a.x, a.y]
proc xz*[T](a: GVec234[T]): GVec2[T] = [a.x, a.z]
proc yx*[T](a: GVec234[T]): GVec2[T] = [a.y, a.x]
proc yz*[T](a: GVec234[T]): GVec2[T] = [a.y, a.z]
proc zx*[T](a: GVec234[T]): GVec2[T] = [a.z, a.x]
proc zy*[T](a: GVec234[T]): GVec2[T] = [a.z, a.y]

proc xxx*[T](a: GVec34[T]): GVec3[T] = [a.x, a.x, a.x]
proc xxy*[T](a: GVec34[T]): GVec3[T] = [a.x, a.x, a.y]
proc xxz*[T](a: GVec34[T]): GVec3[T] = [a.x, a.x, a.z]
proc xyx*[T](a: GVec34[T]): GVec3[T] = [a.x, a.y, a.x]
proc xyy*[T](a: GVec34[T]): GVec3[T] = [a.x, a.y, a.y]
proc xyz*[T](a: GVec34[T]): GVec3[T] = [a.x, a.y, a.z]
proc xzx*[T](a: GVec34[T]): GVec3[T] = [a.x, a.z, a.x]
proc xzy*[T](a: GVec34[T]): GVec3[T] = [a.x, a.z, a.y]
proc xzz*[T](a: GVec34[T]): GVec3[T] = [a.x, a.z, a.z]
proc yxx*[T](a: GVec34[T]): GVec3[T] = [a.y, a.x, a.x]
proc yxy*[T](a: GVec34[T]): GVec3[T] = [a.y, a.x, a.y]
proc yxz*[T](a: GVec34[T]): GVec3[T] = [a.y, a.x, a.z]
proc yyx*[T](a: GVec34[T]): GVec3[T] = [a.y, a.y, a.x]
proc yyy*[T](a: GVec34[T]): GVec3[T] = [a.y, a.y, a.y]
proc yyz*[T](a: GVec34[T]): GVec3[T] = [a.y, a.y, a.z]
proc yzx*[T](a: GVec34[T]): GVec3[T] = [a.y, a.z, a.x]
proc yzy*[T](a: GVec34[T]): GVec3[T] = [a.y, a.z, a.y]
proc yzz*[T](a: GVec34[T]): GVec3[T] = [a.y, a.z, a.z]
proc zxx*[T](a: GVec34[T]): GVec3[T] = [a.z, a.x, a.x]
proc zxy*[T](a: GVec34[T]): GVec3[T] = [a.z, a.x, a.y]
proc zxz*[T](a: GVec34[T]): GVec3[T] = [a.z, a.x, a.z]
proc zyx*[T](a: GVec34[T]): GVec3[T] = [a.z, a.y, a.x]
proc zyy*[T](a: GVec34[T]): GVec3[T] = [a.z, a.y, a.y]
proc zyz*[T](a: GVec34[T]): GVec3[T] = [a.z, a.y, a.z]
proc zzx*[T](a: GVec34[T]): GVec3[T] = [a.z, a.z, a.x]
proc zzy*[T](a: GVec34[T]): GVec3[T] = [a.z, a.z, a.y]
proc zzz*[T](a: GVec34[T]): GVec3[T] = [a.z, a.z, a.z]

template genOp(op: untyped) =
  proc op*[T](a, b: GVec2[T]): GVec2[T] =
    [
      op(a[0], b[0]),
      op(a[1], b[1])
    ]

  proc op*[T](a, b: GVec3[T]): GVec3[T] =
    [
      op(a[0], b[0]),
      op(a[1], b[1]),
      op(a[2], b[2])
    ]

  proc op*[T](a, b: GVec4[T]): GVec4[T] =
    [
      op(a[0], b[0]),
      op(a[1], b[1]),
      op(a[2], b[2]),
      op(a[3], b[3])
    ]

  proc op*[T](a: GVec2[T], b: T): GVec2[T] =
    [
      op(a[0], b),
      op(a[1], b)
    ]

  proc op*[T](a: GVec3[T], b: T): GVec3[T] =
    [
      op(a[0], b),
      op(a[1], b),
      op(a[2], b)
    ]

  proc op*[T](a: GVec4[T], b: T): GVec4[T] =
    [
      op(a[0], b),
      op(a[1], b),
      op(a[2], b),
      op(a[3], b)
    ]

  proc op*[T](a: T, b: GVec2[T]): GVec2[T] =
    [
      op(a, b[0]),
      op(a, b[1])
    ]

  proc op*[T](a: T, b: GVec3[T]): GVec3[T] =
    [
      op(a, b[0]),
      op(a, b[1]),
      op(a, b[2])
    ]

  proc op*[T](a: T, b: GVec4[T]): GVec4[T] =
    [
      op(a, b[0]),
      op(a, b[1]),
      op(a, b[2]),
      op(a, b[3])
    ]

genOp(`+`)
genOp(`-`)
genOp(`*`)
genOp(`/`)
genOp(`mod`)
genOp(`div`)

template genEqOp(op: untyped) =
  proc op*[T](a: var GVec2[T], b: GVec2[T]) =
    op(a[0], b[0])
    op(a[1], b[1])

  proc op*[T](a: var GVec3[T], b: GVec3[T]) =
    op(a[0], b[0])
    op(a[1], b[1])
    op(a[2], b[2])

  proc op*[T](a: var GVec4[T], b: GVec4[T]) =
    op(a[0], b[0])
    op(a[1], b[1])
    op(a[2], b[2])
    op(a[3], b[3])

  proc op*[T](a: var GVec2[T], b: T) =
    op(a[0], b)
    op(a[1], b)

  proc op*[T](a: var GVec3[T], b: T) =
    op(a[0], b)
    op(a[1], b)
    op(a[2], b)

  proc op*[T](a: var GVec4[T], b: T) =
    op(a[0], b)
    op(a[1], b)
    op(a[2], b)
    op(a[3], b)

genEqOp(`+=`)
genEqOp(`-=`)
genEqOp(`*=`)
genEqOp(`/=`)

template genMathFn(fn: untyped) =
  proc fn*[T](v: GVec2[T]): GVec2[T] =
    [
      fn(v[0]),
      fn(v[1])
    ]

  proc fn*[T](v: GVec3[T]): GVec3[T] =
    [
      fn(v[0]),
      fn(v[1]),
      fn(v[2])
    ]

  proc fn*[T](v: GVec4[T]): GVec4[T] =
    [
      fn(v[0]),
      fn(v[1]),
      fn(v[2]),
      fn(v[3])
    ]

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
genMathFn(ciel)
genMathFn(abs)

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

proc lerp*[T:SomeFloat](a, b: GVec234[T], v: T): type(a) =
  a * (1.0 - v) + b * v

proc dot*[T](a, b: GVec2[T]): T =
  a.x * b.x + a.y * b.y

proc dot*[T](a, b: GVec3[T]): T =
  a.x * b.x + a.y * b.y + a.z * b.z

proc dot*[T](a, b: GVec4[T]): T =
  a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w

proc cross*[T](a, b: GVec3[T]): GVec3[T] =
  [
    a.y * b.z - a.z * b.y,
    a.z * b.x - a.x * b.z,
    a.x * b.y - a.y * b.x
  ]

proc dist*[T](at, to: GVec234[T]): T =
  (at - to).length

proc distSq*[T](at, to: GVec234[T]): T =
  (at - to).lengthSq

proc dir*[T](at, to: GVec234[T]): type(to) =
  (at - to).normalize

proc dir*[T](angle: T): GVec2[T] =
  [
    cos(angle),
    sin(angle),
  ]

type
  GMat2*[T] = array[2, GVec2[T]]
  GMat3*[T] = array[3, GVec3[T]]
  GMat4*[T] = array[4, GVec4[T]]

  Mat2* = GMat2[float32]
  Mat3* = GMat3[float32]
  Mat4* = GMat4[float32]

  DMat2* = GMat2[float64]
  DMat3* = GMat3[float64]
  DMat4* = GMat4[float64]

  GMat234[T] = GMat2[T] | GMat3[T] | GMat4[T]
  GMat34[T] = GMat3[T] | GMat4[T]

template genMatConstructor(lower, upper, T: untyped) =
  proc `lower 2`*(a, b, c, d: T): `upper 2` =
    [[a, b], [c, d]]
  proc `lower 3`*(a, b, c, d, e, f, g, h, i: T): `upper 3` =
    [[T(a), b, c], [d, e, f], [g, h, i]]
  proc `lower 4`*(
    a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p: T
  ): `upper 4` =
    [[T(a), b, c, d], [e, f, g, h], [i, j, k, l], [m , n, o, p]]

  proc `lower 2`*(a, b: GVec2[T]): `upper 2` = [a, b]
  proc `lower 3`*(a, b, c: GVec3[T]): `upper 3` = [a, b, c]
  proc `lower 4`*(a, b, c, d: GVec4[T]): `upper 4` = [a, b, c, d]

  proc `lower 2`*(m: GMat3[T]): `upper 2` = [m[0].xy, m[1].xy]
  proc `lower 3`*(m: GMat4[T]): `upper 3` =  [m[0].xyz, m[1].xyz, [T(0), 0, 1]]

  proc `lower 3`*(m: GMat2[T]): `upper 3` =
    [
      [m[0][0], m[0][1], 0],
      [m[1][0], m[1][1], 0],
      [T(0), 0, 1]
    ]

  proc `lower 4`*(m: GMat3[T]): `upper 4` =
    [
      [m[0][0], m[0][1], m[0][2], 0],
      [m[1][0], m[1][1], m[1][2], 0],
      [T(0), 0, 1, 0],
      [m[2][0], m[2][1], m[2][2], 1]
    ]

  proc `lower 2`*(): `upper 2` =
    [
      [T(1), 0],
      [T(0), 1]
    ]
  proc `lower 3`*(): `upper 3` =
    [
      [T(1), 0, 0],
      [T(0), 1, 0],
      [T(0), 0, 1]
    ]
  proc `lower 4`*(): `upper 4` =
    [
      [T(1), 0, 0, 0],
      [T(0), 1, 0, 0],
      [T(0), 0, 1, 0],
      [T(0), 0, 0, 1]
    ]

genMatConstructor(mat, Mat, float32)
genMatConstructor(dmat, DMat, float64)

proc `[]`*[T](a: GMat234[T], i, j: int): T = a[i][j]
proc `[]=`*[T](a: var GMat234[T], i, j: int, v: T) = a[i][j] = v

proc `~=`*[T](a, b: GMat2[T]): bool =
  a[0] ~= b[0] and a[1] ~= b[1]

proc `~=`*[T](a, b: GMat3[T]): bool =
  a[0] ~= b[0] and a[1] ~= b[1] and a[2] ~= b[2]

proc `~=`*[T](a, b: GMat4[T]): bool =
  a[0] ~= b[0] and a[1] ~= b[1] and a[2] ~= b[2] and a[3] ~= b[3]

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

proc `*`*[T](a: GMat3[T], b: GVec2[T]): GVec2[T] =
  [
    a[0, 0] * b.x + a[1, 0] * b.y + a[2, 0],
    a[0, 1] * b.x + a[1, 1] * b.y + a[2, 1]
  ]

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
  [
    a[0, 0] * b.x + a[1, 0] * b.y + a[2, 0] * b.z + a[3, 0],
    a[0, 1] * b.x + a[1, 1] * b.y + a[2, 1] * b.z + a[3, 1],
    a[0, 2] * b.x + a[1, 2] * b.y + a[2, 2] * b.z + a[3, 2]
  ]

proc transpose*[T](a: GMat3[T]): GMat3[T] =
  [
    [a[0, 0], a[1, 0], a[2, 0]],
    [a[0, 1], a[1, 1], a[2, 1]],
    [a[0, 2], a[1, 2], a[2, 2]]
  ]

proc transpose*[T](a: GMat4[T]): GMat4[T] =
  [
    [a[0, 0], a[1, 0], a[2, 0], a[3, 0]],
    [a[0, 1], a[1, 1], a[2, 1], a[3, 1]],
    [a[0, 2], a[1, 2], a[2, 2], a[3, 2]],
    [a[0, 3], a[1, 3], a[2, 3], a[3, 3]]
  ]

proc determinant*[T](a: GMat4[T]): T =
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
  let
    determinant = (
      a[0, 0] * (a[1, 1] * a[2, 2] - a[2, 1] * a[1, 2]) -
      a[0, 1] * (a[1, 0] * a[2, 2] - a[1, 2] * a[2, 0]) +
      a[0, 2] * (a[1, 0] * a[2, 1] - a[1, 1] * a[2, 0])
    )
    invDet = 1 / determinant

  result[0, 0] =  (a[1, 1] * a[2, 2] - a[2, 1] * a[1, 2]) * invDet
  result[0, 1] = -(a[0, 1] * a[2, 2] - a[0, 2] * a[2, 1]) * invDet
  result[0, 2] =  (a[0, 1] * a[1, 2] - a[0, 2] * a[1, 1]) * invDet

  result[1, 0] = -(a[1, 0] * a[2, 2] - a[1, 2] * a[2, 0]) * invDet
  result[1, 1] =  (a[0, 0] * a[2, 2] - a[0, 2] * a[2, 0]) * invDet
  result[1, 2] = -(a[0, 0] * a[1, 2] - a[1, 0] * a[0, 2]) * invDet

  result[2, 0] =  (a[1, 0] * a[2, 1] - a[2, 0] * a[1, 1]) * invDet
  result[2, 1] = -(a[0, 0] * a[2, 1] - a[2, 0] * a[0, 1]) * invDet
  result[2, 2] =  (a[0, 0] * a[1, 1] - a[1, 0] * a[0, 1]) * invDet

proc inverse*[T](a: GMat4[T]): GMat4[T] =
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
  let invDet = T(1.0)/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

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
  [
    [v.x, 0, 0],
    [T(0), v.y, 0],
    [T(0), 0, 1]
  ]

proc scale*[T](v: GVec3[T]): GMat4[T] =
  [
    [v.x, 0, 0, 0],
    [T(0), v.y, 0, 0],
    [T(0), 0, v.z, 0],
    [T(0), 0, 0, 1]
  ]

proc translate*[T](v: GVec2[T]): GMat3[T] =
  [
    [T(1), 0, 0],
    [T(0), 1, 0],
    [v.x, v.y, 1]
  ]

proc translate*[T](v: GVec3[T]): GMat4[T] =
  [
    [T(1), 0, 0, 0],
    [T(0), 1, 0, 0],
    [T(0), 0, 1, 0],
    [v.x, v.y, v.z, 1]
  ]

proc rotate*[T](angle: T): GMat3[T] =
  let
    sin = sin(angle)
    cos = cos(angle)
  [
    [cos, -sin, 0],
    [sin, cos, 0],
    [T(0), 0, 1]
  ]

proc hrp*[T](m: GMat4[T]): GVec3[T] =
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
  [heading, pitch, roll]

proc frustum*[T](left, right, bottom, top, near, far: T): GMat4[T] =
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
  let
    top = near * tan(fovy * PI / 360.0)
    right = top * aspect
  frustum(-right, right, -top, top, near, far)

proc ortho*[T](left, right, bottom, top, near, far: T): GMat4[T] =
  let
    rl = (right - left)
    tb = (top - bottom)
    fn = (far - near)

  result[0, 0] = 2 / rl
  result[0, 1] = 0
  result[0, 2] = 0
  result[0, 3] = 0

  result[1, 0] = 0
  result[1, 1] = 2 / tb
  result[1, 2] = 0
  result[1, 3] = 0

  result[2, 0] = 0
  result[2, 1] = 0
  result[2, 2] = -2 / fn
  result[2, 3] = 0

  result[3, 0] = -(left + right) / rl
  result[3, 1] = -(top + bottom) / tb
  result[3, 2] = -(far + near) / fn
  result[3, 3] = 1

proc lookAt*[T](eye, center: GVec3[T], up = [T(0),0,1]): GMat4[T] =
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


proc angle*[T](a: GVec2[T]): T =
  ## Angle of a Vec2.
  arctan2(a.y, a.x)

proc angle*[T](a, b: GVec2[T]): T  =
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
  proc `lower`*[T](x: GVec4[T]): `upper` = gvec4[typ](typ(x[0]), typ(x[1]), typ(x[2]), typ(x[3]))

genQuatConstructor(quat, Quat, float32)
genQuatConstructor(dquat, DQuat, float64)

proc fromAxisAngle*[T](axis: GVec3[T], angle: T): GVec4[T] =
  let
    a = axis.normalize()
    s = sin(angle / 2)
  [
    a.x * s,
    a.y * s,
    a.z * s,
    cos(angle / 2)
  ]

proc toAxisAngle*[T](q: GVec4[T]): (GVec3[T], T) =
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
  let v = abs(v)
  var other: type(v) =
    if v.x < v.y :
      if v.x < v.z:
        [T(1), 0, 0] # X_AXIS
      else:
        [T(0), 0, 1] # Z_AXIS
    elif v.y < v.z :
      [T(0), 1, 0] # Y_AXIS
    else:
      [T(0), 0, 1] # Z_AXIS
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
    return [q.x, q.y, q.z, 0]

  let
    half = normalize(u + v)
    q = cross(u, half)
    w = dot(u, half)
  return [q.x, q.y, q.z, w]

proc quat*[T](m: GMat4[T]): GVec4[T] =
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
    return [T(0), 0, 0, 1]

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
  fromAxisAngle(axis, angle).mat4()

proc rotateX*[T](angle: T): GMat4[T] =
  fromAxisAngle([T(1), 0, 0], angle).mat4()

proc rotateY*[T](angle: T): GMat4[T] =
  fromAxisAngle([T(0), 1, 0], angle).mat4()

proc rotateZ*[T](angle: T): GMat4[T] =
  fromAxisAngle([T(0), 0, 1], angle).mat4()

when defined(release):
  {.pop.}
{.pop.}
