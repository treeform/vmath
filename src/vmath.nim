import hashes, math, random, strformat, strutils

export math

proc between*(value, min, max: float32): bool {.inline.} =
  ## Returns true if value is between min and max or equal to them.
  (value >= min) and (value <= max)

proc sign*(v: float32): float32 {.inline.} =
  ## Returns the sign of a number, -1 or 1.
  if v >= 0: 1.0 else: -1.0

proc quantize*(v: float32, n: float32): float32 {.inline.} =
  ## Makes v be multipe of n. Rounding to integer quantize by 1.0.
  sign(v) * floor(abs(v) / n) * n

proc lerp*(a: float32, b: float32, v: float32): float32 {.inline.} =
  ## Interpolates value between a and b.
  ## * 0 -> a
  ## * 1 -> b
  ## * 0.5 -> between a and b
  a * (1.0 - v) + b * v

proc fixAngle*(angle: float32): float32 =
  ## Make angle be from -PI to PI radians.
  var angle = angle
  while angle > PI:
    angle -= PI * 2
  while angle < -PI:
    angle += PI * 2
  angle

proc angleBetween*(a, b: float32): float32 =
  ## Angle between angle a and angle b.
  fixAngle(b - a)

proc turnAngle*(a, b, speed: float32): float32 =
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

type Vec2* = object
  ## 2D vector
  x*: float32
  y*: float32

proc vec2*(x, y: float32): Vec2 {.inline.} =
  result.x = x
  result.y = y

proc vec2*(v: float32): Vec2 {.inline.} =
  result.x = v
  result.y = v

proc vec2*(a: Vec2): Vec2 {.inline.} =
  result.x = a.x
  result.y = a.y

proc `+`*(a: Vec2, b: Vec2): Vec2 {.inline.} =
  result.x = a.x + b.x
  result.y = a.y + b.y

proc `-`*(a: Vec2, b: Vec2): Vec2 {.inline.} =
  result.x = a.x - b.x
  result.y = a.y - b.y

proc `*`*(a: Vec2, b: float32): Vec2 {.inline.} =
  result.x = a.x * b
  result.y = a.y * b

proc `*`*(a: float32, b: Vec2): Vec2 {.inline.} =
  b * a

proc `/`*(a: Vec2, b: float32): Vec2 {.inline.} =
  result.x = a.x / b
  result.y = a.y / b

proc `+=`*(a: var Vec2, b: Vec2) {.inline.} =
  a.x += b.x
  a.y += b.y

proc `-=`*(a: var Vec2, b: Vec2) {.inline.} =
  a.x -= b.x
  a.y -= b.y

proc `*=`*(a: var Vec2, b: float32) {.inline.} =
  a.x *= b
  a.y *= b

proc `/=`*(a: var Vec2, b: float32) {.inline.} =
  a.x /= b
  a.y /= b

proc zero*(a: var Vec2) {.inline.} =
  a.x = 0
  a.y = 0

proc `-`*(a: Vec2): Vec2 {.inline.} =
  result.x = -a.x
  result.y = -a.y

proc hash*(a: Vec2): Hash {.inline.} =
  hash((a.x, a.y))

proc lengthSq*(a: Vec2): float32 {.inline.} =
  a.x * a.x + a.y * a.y

proc length*(a: Vec2): float32 {.inline.} =
  sqrt(a.lengthSq)

proc `length=`*(a: var Vec2, b: float32) {.inline.} =
  a *= b / a.length

proc normalize*(a: Vec2): Vec2 {.inline.} =
  a / a.length

proc dot*(a: Vec2, b: Vec2): float32 {.inline.} =
  a.x * b.x + a.y * b.y

proc dir*(at: Vec2, to: Vec2): Vec2 {.inline.} =
  (at - to).normalize()

proc dir*(th: float32): Vec2 {.inline.} =
  vec2(cos(th), sin(th))

proc dist*(at: Vec2, to: Vec2): float32 {.inline.} =
  (at - to).length

proc distSq*(at: Vec2, to: Vec2): float32 {.inline.} =
  (at - to).lengthSq

proc lerp*(a: Vec2, b: Vec2, v: float32): Vec2 {.inline.} =
  a * (1.0 - v) + b * v

proc quantize*(v: Vec2, n: float32): Vec2 {.inline.} =
  result.x = sign(v.x) * floor(abs(v.x) / n) * n
  result.y = sign(v.y) * floor(abs(v.y) / n) * n

proc inRect*(v: Vec2, a: Vec2, b: Vec2): bool {.inline.} =
  ## Check to see if v is inside a rectange formed by a and b.
  ## It does not matter how a and b are arranged.
  let
    min = vec2(min(a.x, b.x), min(a.y, b.y))
    max = vec2(max(a.x, b.x), max(a.y, b.y))
  v.x > min.x and v.x < max.x and v.y > min.y and v.y < max.y

proc `[]`*(a: Vec2, i: int): float32 =
  case i
  of 0: a.x
  of 1: a.y
  else: raise newException(IndexDefect, "Index not in 0 .. 1")

proc `[]=`*(a: var Vec2, i: int, b: float32) =
  case i
  of 0: a.x = b
  of 1: a.y = b
  else: raise newException(IndexDefect, "Index not in 0 .. 1")

proc randVec2*(r: var Rand): Vec2 =
  let a = r.rand(PI * 2)
  let v = r.rand(1.0)
  vec2(cos(a) * v, sin(a) * v)

proc `$`*(a: Vec2): string =
  &"({a.x:.4f}, {a.y:.4f})"

proc angle*(a: Vec2): float32 =
  ## Angle of a Vec2.
  arctan2(a.y, a.x)

proc angleBetween*(a: Vec2, b: Vec2): float32 =
  ## Angle between 2 Vec2.
  fixAngle(arctan2(a.y - b.y, a.x - b.x))

type Vec3* = object
  ## 3D vector
  x*: float32
  y*: float32
  z*: float32

proc vec3*(x, y, z: float32): Vec3 {.inline.} =
  result.x = x
  result.y = y
  result.z = z

proc vec3*(v: float32): Vec3 {.inline.} =
  result.x = v
  result.y = v
  result.z = v

proc vec3*(a: Vec3): Vec3 {.inline.} =
  result.x = a.x
  result.y = a.y
  result.z = a.z

const X_DIR* = vec3(1.0, 0.0, 0.0)
const Y_DIR* = vec3(0.0, 1.0, 0.0)
const Z_DIR* = vec3(0.0, 0.0, 1.0)

proc `+`*(a: Vec3, b: Vec3): Vec3 {.inline.} =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z

proc `-`*(a: Vec3, b: Vec3): Vec3 {.inline.} =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z

proc `-`*(a: Vec3): Vec3 {.inline.} =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z

proc `*`*(a: Vec3, b: float32): Vec3 {.inline.} =
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b

proc `*`*(a: float32, b: Vec3): Vec3 {.inline.} =
  b * a

proc `/`*(a: Vec3, b: float32): Vec3 {.inline.} =
  result.x = a.x / b
  result.y = a.y / b
  result.z = a.z / b

proc `/`*(a: float32, b: Vec3): Vec3 {.inline.} =
  result.x = a / b.x
  result.y = a / b.y
  result.z = a / b.z

proc `+=`*(a: var Vec3, b: Vec3) {.inline.} =
  a.x += b.x
  a.y += b.y
  a.z += b.z

proc `-=`*(a: var Vec3, b: Vec3) {.inline.} =
  a.x -= b.x
  a.y -= b.y
  a.z -= b.z

proc `*=`*(a: var Vec3, b: float32) {.inline.} =
  a.x *= b
  a.y *= b
  a.z *= b

proc `/=`*(a: var Vec3, b: float32) {.inline.} =
  a.x /= b
  a.y /= b
  a.z /= b

proc zero*(a: var Vec3) {.inline.} =
  a.x = 0
  a.y = 0
  a.z = 0

proc `-`*(a: var Vec3): Vec3 {.inline.} =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z

proc hash*(a: Vec3): Hash {.inline.} =
  hash((a.x, a.y, a.z))

proc lengthSq*(a: Vec3): float32 {.inline.} =
  a.x * a.x + a.y * a.y + a.z * a.z

proc length*(a: Vec3): float32 {.inline.} =
  sqrt(a.lengthSq)

proc `length=`*(a: var Vec3, b: float32) {.inline.} =
  a *= b / a.length

proc floor*(a: Vec3): Vec3 {.inline.} =
  vec3(floor(a.x), floor(a.y), floor(a.z))

proc round*(a: Vec3): Vec3 {.inline.} =
  vec3(round(a.x), round(a.y), round(a.z))

proc ceil*(a: Vec3): Vec3 {.inline.} =
  vec3(ceil(a.x), ceil(a.y), ceil(a.z))

proc normalize*(a: Vec3): Vec3 {.inline.} =
  a / sqrt(a.x * a.x + a.y * a.y + a.z * a.z)

proc cross*(a: Vec3, b: Vec3): Vec3 {.inline.} =
  result.x = a.y * b.z - a.z * b.y
  result.y = a.z * b.x - a.x * b.z
  result.z = a.x * b.y - a.y * b.x

proc computeNormal*(a, b, c: Vec3): Vec3 =
  cross(c - b, b - a).normalize()

proc dot*(a: Vec3, b: Vec3): float32 {.inline.} =
  a.x * b.x + a.y * b.y + a.z * b.z

proc dir*(at: Vec3, to: Vec3): Vec3 =
  (at - to).normalize()

proc dist*(at: Vec3, to: Vec3): float32 =
  (at - to).length

proc distSq*(at: Vec3, to: Vec3): float32 =
  (at - to).lengthSq

proc lerp*(a: Vec3, b: Vec3, v: float32): Vec3 =
  a * (1.0 - v) + b * v

proc quantize*(v: Vec3, n: float32): Vec3 =
  result.x = sign(v.x) * floor(abs(v.x) / n) * n
  result.y = sign(v.y) * floor(abs(v.y) / n) * n
  result.z = sign(v.z) * floor(abs(v.z) / n) * n

proc angleBetween*(a, b: Vec3): float32 =
  var dot = dot(a, b)
  dot = dot / (a.length * b.length)
  arccos(dot)

proc `[]`*(a: Vec3, i: int): float32 =
  case i
  of 0: a.x
  of 1: a.y
  of 2: a.z
  else: raise newException(IndexDefect, "Index not in 0 .. 2")

proc `[]=`*(a: var Vec3, i: int, b: float32) =
  case i
  of 0: a.x = b
  of 1: a.y = b
  of 2: a.z = b
  else: raise newException(IndexDefect, "Index not in 0 .. 2")

proc xy*(a: Vec3): Vec2 {.inline.} =
  vec2(a.x, a.y)

proc xz*(a: Vec3): Vec2 {.inline.} =
  vec2(a.x, a.z)

proc yx*(a: Vec3): Vec2 {.inline.} =
  vec2(a.y, a.x)

proc yz*(a: Vec3): Vec2 {.inline.} =
  vec2(a.y, a.z)

proc zx*(a: Vec3): Vec2 {.inline.} =
  vec2(a.y, a.x)

proc zy*(a: Vec3): Vec2 {.inline.} =
  vec2(a.z, a.y)

proc almostEquals*(a, b: Vec3, precision = 1e-6): bool {.inline.} =
  let c = a - b
  abs(c.x) < precision and abs(c.y) < precision and abs(c.z) < precision

proc randVec3*(r: var Rand): Vec3 =
  ## Generates a random unit vector based on
  ## http://mathworld.wolfram.com/SpherePointPicking.html
  let
    u = r.rand(0.0 .. 1.0)
    v = r.rand(0.0 .. 1.0)
    th = 2 * PI * u
    ph = arccos(2 * v - 1)
  vec3(
    cos(th) * sin(ph),
    sin(th) * sin(ph),
    cos(ph)
  )

proc `$`*(a: Vec3): string =
  &"({a.x:.8f}, {a.y:.8f}, {a.z:.8f})"

type Vec4* = object
  ## 4D Vector.
  x*: float32
  y*: float32
  z*: float32
  w*: float32

proc vec4*(x, y, z, w: float32): Vec4 {.inline.} =
  result.x = x
  result.y = y
  result.z = z
  result.w = w

proc vec4*(v: float32): Vec4 {.inline.} =
  result.x = v
  result.y = v
  result.z = v
  result.w = v

proc `+`*(a: Vec4, b: Vec4): Vec4 {.inline.} =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z
  result.w = a.w + b.w

proc `-`*(a: Vec4, b: Vec4): Vec4 {.inline.} =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z
  result.w = a.w - b.w

proc `-`*(a: Vec4): Vec4 {.inline.} =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z
  result.w = -a.w

proc `*`*(a: Vec4, b: float32): Vec4 {.inline.} =
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b
  result.w = a.w * b

proc `*`*(a: float32, b: Vec4): Vec4 {.inline.} =
  b * a

proc `/`*(a: Vec4, b: float32): Vec4 {.inline.} =
  result.x = a.x / b
  result.y = a.y / b
  result.z = a.z / b
  result.w = a.w / b

proc `/`*(a: float32, b: Vec4): Vec4 {.inline.}=
  result.x = a / b.x
  result.y = a / b.y
  result.z = a / b.z
  result.w = a / b.w

proc `+=`*(a: var Vec4, b: Vec4) {.inline.} =
  a.x += b.x
  a.y += b.y
  a.z += b.z
  a.w += b.w

proc `-=`*(a: var Vec4, b: Vec4) {.inline.} =
  a.x -= b.x
  a.y -= b.y
  a.z -= b.z
  a.w -= b.w

proc `*=`*(a: var Vec4, b: float32) {.inline.} =
  a.x *= b
  a.y *= b
  a.z *= b
  a.w *= b

proc `/=`*(a: var Vec4, b: float32) {.inline.} =
  a.x /= b
  a.y /= b
  a.z /= b
  a.w /= b

proc zero*(a: var Vec4) {.inline.} =
  a.x = 0
  a.y = 0
  a.z = 0
  a.w = 0

proc hash*(a: Vec4): Hash {.inline.} =
  hash((a.x, a.y, a.z, a.w))

proc `[]`*(a: Vec4, i: int): float32 =
  case i
  of 0: a.x
  of 1: a.y
  of 2: a.z
  of 3: a.w
  else: raise newException(IndexDefect, "Index not in 0 .. 3")

proc `[]=`*(a: var Vec4, i: int, b: float32) =
  case i
  of 0: a.x = b
  of 1: a.y = b
  of 2: a.z = b
  of 3: a.w = b
  else: raise newException(IndexDefect, "Index not in 0 .. 3")

proc lerp*(a: Vec4, b: Vec4, v: float32): Vec4 =
  a * (1.0 - v) + b * v

proc xyz*(a: Vec4): Vec3 {.inline.} =
  vec3(a.x, a.y, a.z)

proc `$`*(a: Vec4): string =
  &"({a.x:.8f}, {a.y:.8f}, {a.z:.8f}, {a.w:.8f})"

proc vec3*(a: Vec2, z = 0.0): Vec3 {.inline.} =
  vec3(a.x, a.y, z)

proc vec4*(a: Vec3, w = 0.0): Vec4 {.inline.} =
  vec4(a.x, a.y, a.z, w)

proc vec4*(a: Vec2, z = 0.0, w = 0.0): Vec4 {.inline.} =
  vec4(a.x, a.y, z, w)


















type Mat3* = array[9, float32] ## 3x3 Matrix

template `[]`*(a: Mat3, i, j: int): float32 = a[i * 3 + j]
template `[]=`*(a: Mat3, i, j: int, v: float32) = a[i * 3 + j] = v

proc mat3*(a, b, c, d, e, f, g, h, i: float32): Mat3 =
  result[0] = a
  result[1] = b
  result[2] = c
  result[3] = d
  result[4] = e
  result[5] = f
  result[6] = g
  result[7] = h
  result[8] = i

proc mat3*(a: Mat3): Mat3 =
  a

proc identity*(a: var Mat3) =
  a[0] = 1
  a[1] = 0
  a[2] = 0
  a[3] = 0
  a[4] = 1
  a[5] = 0
  a[6] = 0
  a[7] = 0
  a[8] = 1

proc mat3*(): Mat3 {.inline.} =
  result.identity()

proc transpose*(a: Mat3): Mat3 =
  result[0] = a[0]
  result[1] = a[3]
  result[2] = a[6]
  result[3] = a[1]
  result[4] = a[4]
  result[5] = a[7]
  result[6] = a[2]
  result[7] = a[5]
  result[8] = a[8]

proc `$`*(a: Mat3): string =
  &"""[{a[0]:.4f}, {a[1]:.4f}, {a[2]:.4f},
{a[3]:.4f}, {a[4]:.4f}, {a[5]:.4f},
{a[6]:.4f}, {a[7]:.4f}, {a[8]:.4f}]"""

proc `*`*(a: Mat3, b: Mat3): Mat3 =
  result[0, 0] += b[0, 0] * a[0, 0] + b[0, 1] * a[1, 0] + b[0, 2] * a[2, 0]
  result[0, 1] += b[0, 0] * a[0, 1] + b[0, 1] * a[1, 1] + b[0, 2] * a[2, 1]
  result[0, 2] += b[0, 0] * a[0, 2] + b[0, 1] * a[1, 2] + b[0, 2] * a[2, 2]
  result[1, 0] += b[1, 0] * a[0, 0] + b[1, 1] * a[1, 0] + b[1, 2] * a[2, 0]
  result[1, 1] += b[1, 0] * a[0, 1] + b[1, 1] * a[1, 1] + b[1, 2] * a[2, 1]
  result[1, 2] += b[1, 0] * a[0, 2] + b[1, 1] * a[1, 2] + b[1, 2] * a[2, 2]
  result[2, 0] += b[2, 0] * a[0, 0] + b[2, 1] * a[1, 0] + b[2, 2] * a[2, 0]
  result[2, 1] += b[2, 0] * a[0, 1] + b[2, 1] * a[1, 1] + b[2, 2] * a[2, 1]
  result[2, 2] += b[2, 0] * a[0, 2] + b[2, 1] * a[1, 2] + b[2, 2] * a[2, 2]

proc scale*(a: Mat3, v: Vec2): Mat3 =
  result[0] = v.x * a[0]
  result[1] = v.x * a[1]
  result[2] = v.x * a[2]
  result[3] = v.y * a[3]
  result[4] = v.y * a[4]
  result[5] = v.y * a[5]
  result[6] = a[6]
  result[7] = a[7]
  result[8] = a[8]

proc scale*(a: Mat3, v: Vec3): Mat3 =
  result[0] = v.x * a[0]
  result[1] = v.x * a[1]
  result[2] = v.x * a[2]
  result[3] = v.y * a[3]
  result[4] = v.y * a[4]
  result[5] = v.y * a[5]
  result[6] = v.z * a[6]
  result[7] = v.z * a[7]
  result[8] = v.z * a[8]

proc translate*(v: Vec2): Mat3 =
  result[0, 0] = 1
  result[1, 1] = 1
  result[2, 0] = v.x
  result[2, 1] = v.y
  result[2, 2] = 1

proc scale*(v: Vec2): Mat3 =
  result[0, 0] = v.x
  result[1, 1] = v.y
  result[2, 2] = 1

proc rotationMat3*(angle: float32): Mat3 =
  # Create a matrix from an angle.
  let
    sin = sin(angle)
    cos = cos(angle)
  result[0, 0] = cos
  result[0, 1] = -sin
  result[0, 2] = 0

  result[1, 0] = sin
  result[1, 1] = cos
  result[1, 2] = 0

  result[2, 0] = 0
  result[2, 1] = 0
  result[2, 2] = 1

proc rotate*(a: Mat3, angle: float32): Mat3 =
  # Rotates a matrix by an angle.
  a * rotationMat3(angle)

proc `*`*(a: Mat3, b: Vec2): Vec2 =
  result.x = a[0, 0]*b.x + a[1, 0]*b.y + a[2, 0]
  result.y = a[0, 1]*b.x + a[1, 1]*b.y + a[2, 1]

proc `*`*(a: Mat3, b: Vec3): Vec3 =
  result.x = a[0, 0]*b.x + a[1, 0]*b.y + a[2, 0]*b.z
  result.y = a[0, 1]*b.x + a[1, 1]*b.y + a[2, 1]*b.z
  result.z = a[0, 2]*b.x + a[1, 2]*b.y + a[2, 2]*b.z

proc inverse*(a: Mat3): Mat3 =
  let determinant = (
    a[0, 0] * (a[1, 1] * a[2, 2] - a[2, 1] * a[1, 2]) -
    a[0, 1] * (a[1, 0] * a[2, 2] - a[1, 2] * a[2, 0]) +
    a[0, 2] * (a[1, 0] * a[2, 1] - a[1, 1] * a[2, 0])
  )
  let invDet = 1 / determinant
  result[0, 0] =  (a[1, 1] * a[2, 2] - a[2, 1] * a[1, 2]) * invDet
  result[0, 1] = -(a[0, 1] * a[2, 2] - a[0, 2] * a[2, 1]) * invDet
  result[0, 2] =  (a[0, 1] * a[1, 2] - a[0, 2] * a[1, 1]) * invDet

  result[1, 0] = -(a[1, 0] * a[2, 2] - a[1, 2] * a[2, 0]) * invDet
  result[1, 1] =  (a[0, 0] * a[2, 2] - a[0, 2] * a[2, 0]) * invDet
  result[1, 2] = -(a[0, 0] * a[1, 2] - a[1, 0] * a[0, 2]) * invDet

  result[2, 0] =  (a[1, 0] * a[2, 1] - a[2, 0] * a[1, 1]) * invDet
  result[2, 1] = -(a[0, 0] * a[2, 1] - a[2, 0] * a[0, 1]) * invDet
  result[2, 2] =  (a[0, 0] * a[1, 1] - a[1, 0] * a[0, 1]) * invDet

type Mat4* = array[16, float32] ## 4x4 Matrix - OpenGL row order

template `[]`*(a: Mat4, i, j: int): float32 = a[i * 4 + j]
template `[]=`*(a: Mat4, i, j: int, v: float32) = a[i * 4 + j] = v

proc mat4*(v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13,
    v14, v15: float32): Mat4 =
  result[0] = v0
  result[1] = v1
  result[2] = v2
  result[3] = v3
  result[4] = v4
  result[5] = v5
  result[6] = v6
  result[7] = v7
  result[8] = v8
  result[9] = v9
  result[10] = v10
  result[11] = v11
  result[12] = v12
  result[13] = v13
  result[14] = v14
  result[15] = v15

proc mat4*(a: Mat4): Mat4 =
  a

proc identity*(): Mat4 =
  result[0] = 1
  result[1] = 0
  result[2] = 0
  result[3] = 0
  result[4] = 0
  result[5] = 1
  result[6] = 0
  result[7] = 0
  result[8] = 0
  result[9] = 0
  result[10] = 1
  result[11] = 0
  result[12] = 0
  result[13] = 0
  result[14] = 0
  result[15] = 1

proc mat4*(): Mat4 =
  identity()

proc transpose*(a: Mat4): Mat4 =
  result[0] = a[0]
  result[1] = a[4]
  result[2] = a[8]
  result[3] = a[12]

  result[4] = a[1]
  result[5] = a[5]
  result[6] = a[9]
  result[7] = a[13]

  result[8] = a[2]
  result[9] = a[6]
  result[10] = a[10]
  result[11] = a[14]

  result[12] = a[3]
  result[13] = a[7]
  result[14] = a[11]
  result[15] = a[15]

proc determinant*(a: Mat4): float32 =
  var
    a00 = a[0]
    a01 = a[1]
    a02 = a[2]
    a03 = a[3]
    a10 = a[4]
    a11 = a[5]
    a12 = a[6]
    a13 = a[7]
    a20 = a[8]
    a21 = a[9]
    a22 = a[10]
    a23 = a[11]
    a30 = a[12]
    a31 = a[13]
    a32 = a[14]
    a33 = a[15]

  (
    a30*a21*a12*a03 - a20*a31*a12*a03 - a30*a11*a22*a03 + a10*a31*a22*a03 +
    a20*a11*a32*a03 - a10*a21*a32*a03 - a30*a21*a02*a13 + a20*a31*a02*a13 +
    a30*a01*a22*a13 - a00*a31*a22*a13 - a20*a01*a32*a13 + a00*a21*a32*a13 +
    a30*a11*a02*a23 - a10*a31*a02*a23 - a30*a01*a12*a23 + a00*a31*a12*a23 +
    a10*a01*a32*a23 - a00*a11*a32*a23 - a20*a11*a02*a33 + a10*a21*a02*a33 +
    a20*a01*a12*a33 - a00*a21*a12*a33 - a10*a01*a22*a33 + a00*a11*a22*a33
  )

proc inverse*(a: Mat4): Mat4 =
  var
    a00 = a[0]
    a01 = a[1]
    a02 = a[2]
    a03 = a[3]
    a10 = a[4]
    a11 = a[5]
    a12 = a[6]
    a13 = a[7]
    a20 = a[8]
    a21 = a[9]
    a22 = a[10]
    a23 = a[11]
    a30 = a[12]
    a31 = a[13]
    a32 = a[14]
    a33 = a[15]

  var
    b00 = a00*a11 - a01*a10
    b01 = a00*a12 - a02*a10
    b02 = a00*a13 - a03*a10
    b03 = a01*a12 - a02*a11
    b04 = a01*a13 - a03*a11
    b05 = a02*a13 - a03*a12
    b06 = a20*a31 - a21*a30
    b07 = a20*a32 - a22*a30
    b08 = a20*a33 - a23*a30
    b09 = a21*a32 - a22*a31
    b10 = a21*a33 - a23*a31
    b11 = a22*a33 - a23*a32

  # Calculate the inverse determinant.
  var invDet = 1.0/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

  result[00] = (+a11*b11 - a12*b10 + a13*b09)*invDet
  result[01] = (-a01*b11 + a02*b10 - a03*b09)*invDet
  result[02] = (+a31*b05 - a32*b04 + a33*b03)*invDet
  result[03] = (-a21*b05 + a22*b04 - a23*b03)*invDet
  result[04] = (-a10*b11 + a12*b08 - a13*b07)*invDet
  result[05] = (+a00*b11 - a02*b08 + a03*b07)*invDet
  result[06] = (-a30*b05 + a32*b02 - a33*b01)*invDet
  result[07] = (+a20*b05 - a22*b02 + a23*b01)*invDet
  result[08] = (+a10*b10 - a11*b08 + a13*b06)*invDet
  result[09] = (-a00*b10 + a01*b08 - a03*b06)*invDet
  result[10] = (+a30*b04 - a31*b02 + a33*b00)*invDet
  result[11] = (-a20*b04 + a21*b02 - a23*b00)*invDet
  result[12] = (-a10*b09 + a11*b07 - a12*b06)*invDet
  result[13] = (+a00*b09 - a01*b07 + a02*b06)*invDet
  result[14] = (-a30*b03 + a31*b01 - a32*b00)*invDet
  result[15] = (+a20*b03 - a21*b01 + a22*b00)*invDet

proc `*`*(a, b: Mat4): Mat4 =
  var
    a00 = a[0]
    a01 = a[1]
    a02 = a[2]
    a03 = a[3]
    a10 = a[4]
    a11 = a[5]
    a12 = a[6]
    a13 = a[7]
    a20 = a[8]
    a21 = a[9]
    a22 = a[10]
    a23 = a[11]
    a30 = a[12]
    a31 = a[13]
    a32 = a[14]
    a33 = a[15]

  var
    b00 = b[0]
    b01 = b[1]
    b02 = b[2]
    b03 = b[3]
    b10 = b[4]
    b11 = b[5]
    b12 = b[6]
    b13 = b[7]
    b20 = b[8]
    b21 = b[9]
    b22 = b[10]
    b23 = b[11]
    b30 = b[12]
    b31 = b[13]
    b32 = b[14]
    b33 = b[15]

  result[00] = b00*a00 + b01*a10 + b02*a20 + b03*a30
  result[01] = b00*a01 + b01*a11 + b02*a21 + b03*a31
  result[02] = b00*a02 + b01*a12 + b02*a22 + b03*a32
  result[03] = b00*a03 + b01*a13 + b02*a23 + b03*a33
  result[04] = b10*a00 + b11*a10 + b12*a20 + b13*a30
  result[05] = b10*a01 + b11*a11 + b12*a21 + b13*a31
  result[06] = b10*a02 + b11*a12 + b12*a22 + b13*a32
  result[07] = b10*a03 + b11*a13 + b12*a23 + b13*a33
  result[08] = b20*a00 + b21*a10 + b22*a20 + b23*a30
  result[09] = b20*a01 + b21*a11 + b22*a21 + b23*a31
  result[10] = b20*a02 + b21*a12 + b22*a22 + b23*a32
  result[11] = b20*a03 + b21*a13 + b22*a23 + b23*a33
  result[12] = b30*a00 + b31*a10 + b32*a20 + b33*a30
  result[13] = b30*a01 + b31*a11 + b32*a21 + b33*a31
  result[14] = b30*a02 + b31*a12 + b32*a22 + b33*a32
  result[15] = b30*a03 + b31*a13 + b32*a23 + b33*a33

proc `*`*(a: Mat4, b: Vec3): Vec3 =
  result.x = a[0]*b.x + a[4]*b.y + a[8]*b.z + a[12]
  result.y = a[1]*b.x + a[5]*b.y + a[9]*b.z + a[13]
  result.z = a[2]*b.x + a[6]*b.y + a[10]*b.z + a[14]

proc `*`*(a: Mat4, b: Vec4): Vec4 =
  result.x = a[0]*b.x + a[4]*b.y + a[8]*b.z + a[12]*b.w
  result.y = a[1]*b.x + a[5]*b.y + a[9]*b.z + a[13]*b.w
  result.z = a[2]*b.x + a[6]*b.y + a[10]*b.z + a[14]*b.w
  result.w = a[3]*b.x + a[7]*b.y + a[11]*b.z + a[15]*b.w

proc right*(a: Mat4): Vec3 =
  result.x = a[0]
  result.y = a[1]
  result.z = a[2]

proc `right=`*(a: var Mat4, b: Vec3) =
  a[0] = b.x
  a[1] = b.y
  a[2] = b.z

proc up*(a: Mat4): Vec3 =
  result.x = a[4]
  result.y = a[5]
  result.z = a[6]

proc `up=`*(a: var Mat4, b: Vec3) =
  a[4] = b.x
  a[5] = b.y
  a[6] = b.z

proc forward*(a: Mat4): Vec3 =
  result.x = a[8]
  result.y = a[9]
  result.z = a[10]

proc `forward=`*(a: var Mat4, b: Vec3) =
  a[8] = b.x
  a[9] = b.y
  a[10] = b.z

proc pos*(a: Mat4): Vec3 =
  result.x = a[12]
  result.y = a[13]
  result.z = a[14]

proc `pos=`*(a: var Mat4, b: Vec3) =
  a[12] = b.x
  a[13] = b.y
  a[14] = b.z

proc rotationOnly*(a: Mat4): Mat4 =
  result = a
  result.pos = vec3(0, 0, 0)

proc dist*(a, b: Mat4): float32 =
  var
    x = a[12] - b[12]
    y = a[13] - b[13]
    z = a[14] - b[14]
  sqrt(x*x + y*y + z*z)

#[
proc translate*(a: Mat4, v: Vec3): Mat4 =
  var
    a00 = a[0]
    a01 = a[1]
    a02 = a[2]
    a03 = a[3]
    a10 = a[4]
    a11 = a[5]
    a12 = a[6]
    a13 = a[7]
    a20 = a[8]
    a21 = a[9]
    a22 = a[10]
    a23 = a[11]

  result[0] = a00
  result[1] = a01
  result[2] = a02
  result[3] = a03
  result[4] = a10
  result[5] = a11
  result[6] = a12
  result[7] = a13
  result[8] = a20
  result[9] = a21
  result[10] = a22
  result[11] = a23

  result[12] = a00*v.x + a10*v.y + a20*v.z + a[12]
  result[13] = a01*v.x + a11*v.y + a21*v.z + a[13]
  result[14] = a02*v.x + a12*v.y + a22*v.z + a[14]
  result[15] = a03*v.x + a13*v.y + a23*v.z + a[15]
]#

proc translate*(v: Vec3): Mat4 =
  result[0] = 1
  result[5] = 1
  result[10] = 1
  result[15] = 1
  result[12] = v.x
  result[13] = v.y
  result[14] = v.z

proc scale*(v: Vec3): Mat4 =
  result[0] = v.x
  result[5] = v.y
  result[10] = v.z
  result[15] = 1

proc close*(a: Mat4, b: Mat4): bool =
  for i in 0..15:
    if abs(a[i] - b[i]) > 0.001:
      return false
  true

proc hrp*(m: Mat4): Vec3 =
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
  result.x = heading
  result.y = pitch
  result.z = roll

proc frustum*(left, right, bottom, top, near, far: float32): Mat4 =
  var
    rl = (right - left)
    tb = (top - bottom)
    fn = (far - near)
  result[0] = (near*2) / rl
  result[1] = 0
  result[2] = 0
  result[3] = 0
  result[4] = 0
  result[5] = (near*2) / tb
  result[6] = 0
  result[7] = 0
  result[8] = (right + left) / rl
  result[9] = (top + bottom) / tb
  result[10] = -(far + near) / fn
  result[11] = -1
  result[12] = 0
  result[13] = 0
  result[14] = -(far*near*2) / fn
  result[15] = 0

proc perspective*(fovy, aspect, near, far: float32): Mat4 =
  var
    top = near * tan(fovy*PI / 360.0)
    right = top * aspect
  frustum(-right, right, -top, top, near, far)

proc ortho*(left, right, bottom, top, near, far: float32): Mat4 =
  var
    rl = (right - left)
    tb = (top - bottom)
    fn = (far - near)
  result[0] = 2 / rl
  result[1] = 0
  result[2] = 0
  result[3] = 0
  result[4] = 0
  result[5] = 2 / tb
  result[6] = 0
  result[7] = 0
  result[8] = 0
  result[9] = 0
  result[10] = -2 / fn
  result[11] = 0
  result[12] = -(left + right) / rl
  result[13] = -(top + bottom) / tb
  result[14] = -(far + near) / fn
  result[15] = 1

proc lookAt*(eye, center, up: Vec3): Mat4 =
  var
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
    return identity()

  var
    # vec3.direction(eye, center, z)
    z0 = eyex - center[0]
    z1 = eyey - center[1]
    z2 = eyez - center[2]

  # normalize (no check needed for 0 because of early return)
  var len = 1/sqrt(z0*z0 + z1*z1 + z2*z2)
  z0 *= len
  z1 *= len
  z2 *= len

  var
    # vec3.normalize(vec3.cross(up, z, x))
    x0 = upy*z2 - upz*z1
    x1 = upz*z0 - upx*z2
    x2 = upx*z1 - upy*z0
  len = sqrt(x0*x0 + x1*x1 + x2*x2)
  if len == 0:
    x0 = 0
    x1 = 0
    x2 = 0
  else:
    len = 1/len
    x0 *= len
    x1 *= len
    x2 *= len

  var
    # vec3.normalize(vec3.cross(z, x, y))
    y0 = z1*x2 - z2*x1
    y1 = z2*x0 - z0*x2
    y2 = z0*x1 - z1*x0

  len = sqrt(y0*y0 + y1*y1 + y2*y2)
  if len == 0:
    y0 = 0
    y1 = 0
    y2 = 0
  else:
    len = 1/len
    y0 *= len
    y1 *= len
    y2 *= len

  result[0] = x0
  result[1] = y0
  result[2] = z0
  result[3] = 0
  result[4] = x1
  result[5] = y1
  result[6] = z1
  result[7] = 0
  result[8] = x2
  result[9] = y2
  result[10] = z2
  result[11] = 0
  result[12] = -(x0*eyex + x1*eyey + x2*eyez)
  result[13] = -(y0*eyex + y1*eyey + y2*eyez)
  result[14] = -(z0*eyex + z1*eyey + z2*eyez)
  result[15] = 1

proc mat3*(m: Mat4): Mat3 =
  ## Gets rotation and translation, ignoring z coordinates.
  result[0, 0] = m[0, 0]
  result[0, 1] = m[0, 1]
  result[0, 2] = 0
  result[1, 0] = m[1, 0]
  result[1, 1] = m[1, 1]
  result[1, 2] = 0
  result[2, 0] = m[3, 0]
  result[2, 1] = m[3, 1]
  result[2, 2] = 0

proc mat3Rotation*(m: Mat4): Mat3 =
  ## Gets the rotational part of the 4x4 matrix.
  result[0, 0] = m[0, 0]
  result[0, 1] = m[0, 1]
  result[0, 2] = m[0, 2]
  result[1, 0] = m[1, 0]
  result[1, 1] = m[1, 1]
  result[1, 2] = m[1, 2]
  result[2, 0] = m[2, 0]
  result[2, 1] = m[2, 1]
  result[2, 2] = m[2, 2]

proc mat4*(m: Mat3): Mat4 =
  ## Takes a 2d Mat3 with position and converts to a 3d matrix.
  result[0, 0] = m[0, 0]
  result[0, 1] = m[0, 1]
  result[0, 2] = 0
  result[0, 3] = 0

  result[1, 0] = m[1, 0]
  result[1, 1] = m[1, 1]
  result[1, 2] = 0
  result[1, 3] = 0

  result[2, 0] = 0
  result[2, 1] = 0
  result[2, 2] = 1
  result[2, 3] = 0

  result[3, 0] = m[2, 0]
  result[3, 1] = m[2, 1]
  result[3, 2] = 0
  result[3, 3] = 1

proc mat4Rotation*(m: Mat3): Mat4 =
  ## Gets the rotational part of the 3x3 matrix into a 4x4 matrix.
  result[0, 0] = m[0, 0]
  result[0, 1] = m[0, 1]
  result[0, 2] = m[0, 2]
  result[1, 0] = m[1, 0]
  result[1, 1] = m[1, 1]
  result[1, 2] = m[1, 2]
  result[2, 0] = m[2, 0]
  result[2, 1] = m[2, 1]
  result[2, 2] = m[2, 2]

proc `$`*(a: Mat4): string =
  &"""[{a[0]:.5f}, {a[1]:.5f}, {a[2]:.5f}, {a[3]:.5f},
{a[4]:.5f}, {a[5]:.5f}, {a[6]:.5f}, {a[7]:.5f},
{a[8]:.5f}, {a[9]:.5f}, {a[10]:.5f}, {a[11]:.5f},
{a[12]:.5f}, {a[13]:.5f}, {a[14]:.5f}, {a[15]:.5f}]"""

type Quat* = object
  x*: float32
  y*: float32
  z*: float32
  w*: float32

proc quat*(x, y, z, w: float32): Quat =
  result.x = x
  result.y = y
  result.z = z
  result.w = w

proc conjugate*(q: Quat): Quat =
  result.w = +q.w
  result.x = -q.x
  result.y = -q.y
  result.z = -q.z

proc length*(q: Quat): float32 =
  sqrt(
    q.w * q.w +
    q.x * q.x +
    q.y * q.y +
    q.z * q.z
  )

proc normalize*(q: Quat): Quat =
  var m = q.length
  result.x = q.x / m
  result.y = q.y / m
  result.z = q.z / m
  result.w = q.w / m

proc xyz*(q: Quat): Vec3 =
  result.x = q.x
  result.y = q.y
  result.z = q.z

proc `xyz=`*(q: var Quat, v: Vec3) =
  q.x = v.x
  q.y = v.y
  q.z = v.z

proc `-`*(a: var Quat): Quat =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z
  result.w = -a.w

proc `+`*(a: Quat, b: Quat): Quat =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z
  result.w = a.w + b.w

proc `*`*(a, b: Quat): Quat =
  ## Multiply the quaternion by a quaternion.
  #[
  var q = quat(0,0,0,0)
  q.w = dot(a.xyz, b.xyz)
  var va = cross(a.xyz, b.xyz)
  var vb = a.xyz * b.w
  var vc = b.xyz * a.w
  va = va + vb
  q.xyz = va + vc
  return q.normalize()
  ]#

  result.x = a.x * b.w + a.w * b.x + a.y * b.z - a.z * b.y
  result.y = a.y * b.w + a.w * b.y + a.z * b.x - a.x * b.z
  result.z = a.z * b.w + a.w * b.z + a.x * b.y - a.y * b.x
  result.w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z

proc `*`*(q: Quat, v: float32): Quat =
  ## Multiply the quaternion by a float32.
  result.x = q.x * v
  result.y = q.y * v
  result.z = q.z * v
  result.w = q.w * v

proc `*`*(q: Quat, v: Vec3): Vec3 =
  ## Multiply the quaternion by a vector.
  var
    x = v.x
    y = v.y
    z = v.z

    qx = q.x
    qy = q.y
    qz = q.z
    qw = q.w

    ix = +qw * x + qy * z - qz * y
    iy = +qw * y + qz * x - qx * z
    iz = +qw * z + qx * y - qy * x
    iw = -qx * x - qy * y - qz * z

  result.x = ix * qw + iw * -qx + iy * -qz - iz * -qy
  result.y = iy * qw + iw * -qy + iz * -qx - ix * -qz
  result.z = iz * qw + iw * -qz + ix * -qy - iy * -qx

proc `[]=`*(a: var Quat, i: int, b: float32) =
  assert(i == 0 or i == 1 or i == 2 or i == 3)
  if i == 0:
    a.x = b
  elif i == 1:
    a.y = b
  elif i == 2:
    a.z = b
  elif i == 3:
    a.w = b

proc mat3*(q: Quat): Mat3 =
  var xx = q.x * q.x
  var xy = q.x * q.y
  var xz = q.x * q.z
  var xw = q.x * q.w

  var yy = q.y * q.y
  var yz = q.y * q.z
  var yw = q.y * q.w

  var zz = q.z * q.z
  var zw = q.z * q.w

  result[0] = 1 - 2 * (yy + zz)
  result[1] = 0 + 2 * (xy - zw)
  result[2] = 0 + 2 * (xz + yw)
  result[3] = 0 + 2 * (xy + zw)
  result[4] = 1 - 2 * (xx + zz)
  result[5] = 0 + 2 * (yz - xw)
  result[6] = 0 + 2 * (xz - yw)
  result[7] = 0 + 2 * (yz + xw)
  result[8] = 1 - 2 * (xx + yy)

proc mat4*(q: Quat): Mat4 =
  var xx = q.x * q.x
  var xy = q.x * q.y
  var xz = q.x * q.z
  var xw = q.x * q.w

  var yy = q.y * q.y
  var yz = q.y * q.z
  var yw = q.y * q.w

  var zz = q.z * q.z
  var zw = q.z * q.w

  result[00] = 1 - 2 * (yy + zz)
  result[01] = 0 + 2 * (xy - zw)
  result[02] = 0 + 2 * (xz + yw)
  result[04] = 0 + 2 * (xy + zw)
  result[05] = 1 - 2 * (xx + zz)
  result[06] = 0 + 2 * (yz - xw)
  result[08] = 0 + 2 * (xz - yw)
  result[09] = 0 + 2 * (yz + xw)
  result[10] = 1 - 2 * (xx + yy)

  result[3] = 0
  result[7] = 0
  result[11] = 0
  result[12] = 0
  result[13] = 0
  result[14] = 0
  result[15] = 1.0

proc recifuncalSqrt*(x: float32): float32 =
  1.0/sqrt(x)

proc quat*(m: Mat4): Quat =
  var
    m00 = m[0]
    m01 = m[4]
    m02 = m[8]

    m10 = m[1]
    m11 = m[5]
    m12 = m[9]

    m20 = m[2]
    m21 = m[6]
    m22 = m[10]

  var q: Quat
  var t: float32

  if m22 < 0:
    if m00 > m11:
      t = 1 + m00 - m11 - m22
      q = quat(t, m01 + m10, m20 + m02, m12 - m21)
    else:
      t = 1 - m00 + m11 - m22
      q = quat(m01 + m10, t, m12 + m21, m20 - m02)
  else:
    if m00 < - m11:
      t = 1 - m00 - m11 + m22
      q = quat(m20 + m02, m12 + m21, t, m01 - m10)
    else:
      t = 1 + m00 + m11 + m22
      q = quat(m12 - m21, m20 - m02, m01 - m10, t)
  q = q * (0.5 / sqrt(t))

  assert abs(q.length - 1.0) < 0.001
  q

proc fromAxisAngle*(axis: Vec3, angle: float32): Quat =
  var a = axis.normalize()
  var s = sin(angle / 2)
  result.x = a.x * s
  result.y = a.y * s
  result.z = a.z * s
  result.w = cos(angle / 2)

proc toAxisAngle*(q: Quat, axis: var Vec3, angle: var float32) =
  var cosAngle = q.w
  angle = arccos(cosAngle) * 2.0
  var sinAngle = sqrt(1.0 - cosAngle * cosAngle)

  if abs(sinAngle) < 0.0005:
    sinAngle = 1.0

  axis.x = q.x / sinAngle
  axis.y = q.y / sinAngle
  axis.z = q.z / sinAngle

proc quat*(heading, pitch, roll: float32): Quat =
  var t0 = cos(heading * 0.5)
  var t1 = sin(heading * 0.5)
  var t2 = cos(roll * 0.5)
  var t3 = sin(roll * 0.5)
  var t4 = cos(pitch * 0.5)
  var t5 = sin(pitch * 0.5)
  result.w = t0 * t2 * t4 + t1 * t3 * t5
  result.x = t0 * t3 * t4 - t1 * t2 * t5
  result.y = t0 * t2 * t5 + t1 * t3 * t4
  result.z = t1 * t2 * t4 - t0 * t3 * t5

proc quat*(hpr: Vec3): Quat =
  quat(hpr.x, hpr.y, hpr.z)

proc hrp*(q: Quat): Vec3 =
  var ysqr = q.y * q.y
  # roll
  var t0 = +2.0 * (q.w * q.x + q.y * q.z)
  var t1 = +1.0 - 2.0 * (q.x * q.x + ysqr)
  result.z = arctan2(t0, t1)
  # pitch
  var t2 = +2.0 * (q.w * q.y - q.z * q.x)
  if t2 > 1.0:
    t2 = 1.0
  if t2 < -1.0:
    t2 = -1.0
  result.y = arcsin(t2)
  # heading
  var t3 = +2.0 * (q.w * q.z + q.x * q.y)
  var t4 = +1.0 - 2.0 * (ysqr + q.z * q.z)
  result.x = arctan2(t3, t4)

proc dot*(a: Quat, b: Quat): float32 =
  a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w

proc nlerp*(a: Quat, b: Quat, v: float32): Quat =
  if dot(a, b) < 0:
    var c = a
    (-c * (1.0 - v) + b * v).normalize()
  else:
    (a * (1.0 - v) + b * v).normalize()

proc `$`*(a: Quat): string =
  &"q({a.x:.8f}, {a.y:.8f}, {a.z:.8f}, {a.w:.8f})"

proc rotate*(angle: float32, axis: Vec3): Mat4 =
  fromAxisAngle(axis, angle).mat4()

proc rotateX*(angle: float32): Mat4 =
  rotate(angle, vec3(1, 0, 0))

proc rotateY*(angle: float32): Mat4 =
  rotate(angle, vec3(0, 1, 0))

proc rotateZ*(angle: float32): Mat4 =
  rotate(angle, vec3(0, 0, 1))

proc scaleMat*(scale: Vec3): Mat4 =
  result[0] = scale.x
  result[5] = scale.y
  result[10] = scale.z
  result[15] = 1.0

proc scaleMat*(scale: float32): Mat4 =
  scaleMat(vec3(scale, scale, scale))

type Rect* = object
  x*: float32
  y*: float32
  w*: float32
  h*: float32

proc rect*(x, y, w, h: float32): Rect =
  result.x = x
  result.y = y
  result.w = w
  result.h = h

proc rect*(pos, size: Vec2): Rect =
  result.x = pos.x
  result.y = pos.y
  result.w = size.x
  result.h = size.y

proc xy*(rect: Rect): Vec2 =
  ## Gets the xy as a Vec2.
  vec2(rect.x, rect.y)

proc `xy=`*(rect: var Rect, v: Vec2) =
  ## Sets the xy from Vec2.
  rect.x = v.x
  rect.y = v.y

proc wh*(rect: Rect): Vec2 =
  ## Gets the wh as a Vec2.
  vec2(rect.w, rect.h)

proc `wh=`*(rect: var Rect, v: Vec2) =
  ## Sets the wh from Vec2.
  rect.w = v.x
  rect.h = v.y

proc `*`*(r: Rect, v: float): Rect =
  ## * all elements of a Rect.
  rect(r.x * v, r.y * v, r.w * v, r.h * v)

proc `/`*(r: Rect, v: float): Rect =
  ## / all elements of a Rect.
  rect(r.x / v, r.y / v, r.w / v, r.h / v)

proc `+`*(a, b: Rect): Rect =
  ## Add two boxes together.
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.w = a.w
  result.h = a.h

proc `$`*(a: Rect): string =
  &"({a.x}, {a.y}: {a.w} x {a.h})"

proc inside*(pos: Vec2, rect: Rect): bool =
  ## Checks if pos is inside rect.
  (rect.x <= pos.x and pos.x <= rect.x + rect.w) and (
    rect.y <= pos.y and pos.y <= rect.y + rect.h)

proc overlap*(a, b: Rect): bool =
  ## Returns true if box a overlaps box b.
  let
    xOverlap = between(a.x, b.x, b.x + b.w) or between(b.x, a.x, a.x + a.w)
    yOverlap = between(a.y, b.y, b.y + b.h) or between(b.y, a.y, a.y + a.h)
  xOverlap and yOverlap

proc `or`*(a, b: Rect): Rect =
  ## Union of two rectangles.
  result.x = min(a.x, b.x)
  result.y = min(a.y, b.y)
  result.w = max(a.x + a.w, b.x + b.w) - result.x
  result.h = max(a.y + a.h, b.y + b.h) - result.y

proc `and`*(a, b: Rect): Rect =
  ## Intersection of two rectangles.
  result.x = max(a.x, b.x)
  result.y = max(a.y, b.y)
  result.w = min(a.x + a.w, b.x + b.w) - result.x
  result.h = min(a.y + a.h, b.y + b.h) - result.y
