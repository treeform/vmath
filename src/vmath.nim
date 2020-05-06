import hashes, math, random, strformat, strutils

export math

func between*(value, min, max: float32): bool =
  ## Returns true if value is between min and max or equal to them.
  (value >= min) and (value <= max)

func sign*(v: float32): float32 =
  ## Returns the sign of a number, -1 or 1.
  if v >= 0:
    return 1.0
  return -1.0

func quantize*(v: float32, n: float32): float32 =
  ## Makes v be multipe of n. Rounding to integer quantize by 1.0.
  sign(v) * floor(abs(v) / n) * n

func lerp*(a: float32, b: float32, v: float32): float32 =
  ## Interpolates value between a and b.
  ## * 0 -> a
  ## * 1 -> b
  ## * 0.5 -> between a and b
  a * (1.0 - v) + b * v

type Vec2* = object
  ## 2D vector
  x*: float32
  y*: float32

func vec2*(x, y: float32): Vec2 =
  result.x = x
  result.y = y

func vec2*(a: Vec2): Vec2 =
  result.x = a.x
  result.y = a.y

func `+`*(a: Vec2, b: Vec2): Vec2 =
  result.x = a.x + b.x
  result.y = a.y + b.y

func `-`*(a: Vec2, b: Vec2): Vec2 =
  result.x = a.x - b.x
  result.y = a.y - b.y

func `*`*(a: Vec2, b: float32): Vec2 =
  result.x = a.x * b
  result.y = a.y * b

func `*`*(a: float32, b: Vec2): Vec2 =
  b * a

func `/`*(a: Vec2, b: float32): Vec2 =
  result.x = a.x / b
  result.y = a.y / b

func `+=`*(a: var Vec2, b: Vec2) =
  a.x += b.x
  a.y += b.y

func `-=`*(a: var Vec2, b: Vec2) =
  a.x -= b.x
  a.y -= b.y

func `*=`*(a: var Vec2, b: float32) =
  a.x *= b
  a.y *= b

func `/=`*(a: var Vec2, b: float32) =
  a.x /= b
  a.y /= b

func zero*(a: var Vec2) =
  a.x = 0
  a.y = 0

func `-`*(a: Vec2): Vec2 =
  result.x = -a.x
  result.y = -a.y

func hash*(a: Vec2): Hash =
  hash((a.x, a.y))

func lengthSq*(a: Vec2): float32 =
  a.x * a.x + a.y * a.y

func length*(a: Vec2): float32 =
  math.sqrt(a.lengthSq)

func `length=`*(a: var Vec2, b: float32) =
  a *= b / a.length

func normalize*(a: Vec2): Vec2 =
  a / a.length

func dot*(a: Vec2, b: Vec2): float32 =
  a.x*b.x + a.y*b.y

func dir*(at: Vec2, to: Vec2): Vec2 =
  (at - to).normalize()

func dir*(th: float32): Vec2 =
  vec2(cos(th), sin(th))

func dist*(at: Vec2, to: Vec2): float32 =
  (at - to).length

func distSq*(at: Vec2, to: Vec2): float32 =
  (at - to).lengthSq

func lerp*(a: Vec2, b: Vec2, v: float32): Vec2 =
  a * (1.0 - v) + b * v

func quantize*(v: Vec2, n: float32): Vec2 =
  result.x = sign(v.x) * floor(abs(v.x) / n) * n
  result.y = sign(v.y) * floor(abs(v.y) / n) * n

func inRect*(v: Vec2, a: Vec2, b: Vec2): bool =
  ## Check to see if v is inside a rectange formed by a and b.
  ## It does not matter how a and b are arranged.
  let
    min = vec2(min(a.x, b.x), min(a.y, b.y))
    max = vec2(max(a.x, b.x), max(a.y, b.y))
  v.x > min.x and v.x < max.x and v.y > min.y and v.y < max.y

func `[]`*(a: Vec2, i: int): float32 =
  assert(i == 0 or i == 1)
  if i == 0:
    return a.x
  elif i == 1:
    return a.y

func `[]=`*(a: var Vec2, i: int, b: float32) =
  assert(i == 0 or i == 1)
  if i == 0:
    a.x = b
  elif i == 1:
    a.y = b

proc randVec2*(): Vec2 =
  let a = rand(PI*2)
  let v = rand(1.0)
  vec2(cos(a)*v, sin(a)*v)

func `$`*(a: Vec2): string =
  &"({a.x:.4f}, {a.y:.4f})"

func fixAngle*(angle: float32): float32 =
  ## Make angle be from -PI to PI radians.
  var angle = angle
  while angle > PI:
    angle -= PI*2
  while angle < -PI:
    angle += PI*2
  angle

func angle*(a: Vec2): float32 =
  ## Angle of a Vec2.
  math.arctan2(a.y, a.x)

func angleBetween*(a: Vec2, b: Vec2): float32 =
  ## Angle between 2 Vec2.
  fixAngle(math.arctan2(a.y - b.y, a.x - b.x))

func angleBetween*(a, b: float32): float32 =
  ## Angle between angle a and angle b.
  (b - a).fixAngle

func turnAngle*(a, b, speed: float32): float32 =
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

type Vec3* = object
  ## 3D vector
  x*: float32
  y*: float32
  z*: float32

func vec3*(x, y, z: float32): Vec3 =
  result.x = x
  result.y = y
  result.z = z

func vec3*(a: Vec3): Vec3 =
  result.x = a.x
  result.y = a.y
  result.z = a.z

const X_DIR* = vec3(1.0, 0.0, 0.0)
const Y_DIR* = vec3(0.0, 1.0, 0.0)
const Z_DIR* = vec3(0.0, 0.0, 1.0)

func `+`*(a: Vec3, b: Vec3): Vec3 =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z

func `-`*(a: Vec3, b: Vec3): Vec3 =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z

func `-`*(a: Vec3): Vec3 =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z

func `*`*(a: Vec3, b: float32): Vec3 =
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b

func `*`*(a: float32, b: Vec3): Vec3 =
  b * a

func `/`*(a: Vec3, b: float32): Vec3 =
  result.x = a.x / b
  result.y = a.y / b
  result.z = a.z / b

func `/`*(a: float32, b: Vec3): Vec3 =
  result.x = a / b.x
  result.y = a / b.y
  result.z = a / b.z

func `+=`*(a: var Vec3, b: Vec3) =
  a.x += b.x
  a.y += b.y
  a.z += b.z

func `-=`*(a: var Vec3, b: Vec3) =
  a.x -= b.x
  a.y -= b.y
  a.z -= b.z

func `*=`*(a: var Vec3, b: float32) =
  a.x *= b
  a.y *= b
  a.z *= b

func `/=`*(a: var Vec3, b: float32) =
  a.x /= b
  a.y /= b
  a.z /= b

func zero*(a: var Vec3) =
  a.x = 0
  a.y = 0
  a.z = 0

func `-`*(a: var Vec3): Vec3 =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z

func hash*(a: Vec3): Hash =
  hash((a.x, a.y, a.z))

func lengthSq*(a: Vec3): float32 =
  a.x * a.x + a.y * a.y + a.z * a.z

func length*(a: Vec3): float32 =
  math.sqrt(a.lengthSq)

func `length=`*(a: var Vec3, b: float32) =
  a *= b / a.length

func floor*(a: Vec3): Vec3 =
  vec3(floor(a.x), floor(a.y), floor(a.z))

func round*(a: Vec3): Vec3 =
  vec3(round(a.x), round(a.y), round(a.z))

func ceil*(a: Vec3): Vec3 =
  vec3(ceil(a.x), ceil(a.y), ceil(a.z))

func normalize*(a: Vec3): Vec3 =
  a / math.sqrt(a.x*a.x + a.y*a.y + a.z*a.z)

func cross*(a: Vec3, b: Vec3): Vec3 =
  result.x = a.y*b.z - a.z*b.y
  result.y = a.z*b.x - a.x*b.z
  result.z = a.x*b.y - a.y*b.x

func computeNormal*(a, b, c: Vec3): Vec3 =
  cross(c - b, b - a).normalize()

func dot*(a: Vec3, b: Vec3): float32 =
  a.x*b.x + a.y*b.y + a.z*b.z

func dir*(at: Vec3, to: Vec3): Vec3 =
  (at - to).normalize()

func dist*(at: Vec3, to: Vec3): float32 =
  (at - to).length

func distSq*(at: Vec3, to: Vec3): float32 =
  (at - to).lengthSq

func lerp*(a: Vec3, b: Vec3, v: float32): Vec3 =
  a * (1.0 - v) + b * v

func quantize*(v: Vec3, n: float32): Vec3 =
  result.x = sign(v.x) * floor(abs(v.x) / n) * n
  result.y = sign(v.y) * floor(abs(v.y) / n) * n
  result.z = sign(v.z) * floor(abs(v.z) / n) * n

func angleBetween*(a, b: Vec3): float32 =
  var dot = dot(a, b)
  dot = dot / (a.length * b.length)
  arccos(dot)

func `[]`*(a: Vec3, i: int): float32 =
  assert(i == 0 or i == 1 or i == 2)
  if i == 0:
    return a.x
  elif i == 1:
    return a.y
  elif i == 2:
    return a.z

func `[]=`*(a: var Vec3, i: int, b: float32) =
  assert(i == 0 or i == 1 or i == 2)
  if i == 0:
    a.x = b
  elif i == 1:
    a.y = b
  elif i == 2:
    a.z = b

func xy*(a: Vec3): Vec2 =
  vec2(a.x, a.y)

func xz*(a: Vec3): Vec2 =
  vec2(a.x, a.z)

func yx*(a: Vec3): Vec2 =
  vec2(a.y, a.x)

func yz*(a: Vec3): Vec2 =
  vec2(a.y, a.z)

func zx*(a: Vec3): Vec2 =
  vec2(a.y, a.x)

func zy*(a: Vec3): Vec2 =
  vec2(a.z, a.y)

func almostEquals*(a, b: Vec3, precision = 1e-6): bool =
  let c = a - b
  abs(c.x) < precision and abs(c.y) < precision and abs(c.z) < precision

proc randVec3*(): Vec3 =
  ## Generates a random unit vector based on
  ## http://mathworld.wolfram.com/SpherePointPicking.html
  let
    u = rand(0.0 .. 1.0)
    v = rand(0.0 .. 1.0)
    th = 2 * PI * u
    ph = arccos(2 * v - 1)
  vec3(
    cos(th) * sin(ph),
    sin(th) * sin(ph),
    cos(ph)
  )

func `$`*(a: Vec3): string =
  &"({a.x:.8f}, {a.y:.8f}, {a.z:.8f})"

type Vec4* = object
  ## 4D Vector.
  x*: float32
  y*: float32
  z*: float32
  w*: float32

func vec4*(x, y, z, w: float32): Vec4 =
  result.x = x
  result.y = y
  result.z = z
  result.w = w

func `+`*(a: Vec4, b: Vec4): Vec4 =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z
  result.w = a.w + b.w

func `-`*(a: Vec4, b: Vec4): Vec4 =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z
  result.w = a.w - b.w

func `-`*(a: Vec4): Vec4 =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z
  result.w = -a.w

func `*`*(a: Vec4, b: float32): Vec4 =
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b
  result.w = a.w * b

func `*`*(a: float32, b: Vec4): Vec4 =
  b * a

func `/`*(a: Vec4, b: float32): Vec4 =
  result.x = a.x / b
  result.y = a.y / b

  result.z = a.z / b
  result.w = a.w / b

func `/`*(a: float32, b: Vec4): Vec4 =
  result.x = a / b.x
  result.y = a / b.y
  result.z = a / b.z
  result.w = a / b.w

func `+=`*(a: var Vec4, b: Vec4) =
  a.x += b.x
  a.y += b.y
  a.z += b.z
  a.w += b.w

func `-=`*(a: var Vec4, b: Vec4) =
  a.x -= b.x
  a.y -= b.y
  a.z -= b.z
  a.w -= b.w

func `*=`*(a: var Vec4, b: float32) =
  a.x *= b
  a.y *= b
  a.z *= b
  a.w *= b

func `/=`*(a: var Vec4, b: float32) =
  a.x /= b
  a.y /= b
  a.z /= b
  a.w /= b

func zero*(a: var Vec4) =
  a.x = 0
  a.y = 0
  a.z = 0
  a.w = 0

func hash*(a: Vec4): Hash =
  hash((a.x, a.y, a.z, a.w))

func `[]`*(a: Vec4, i: int): float32 =
  assert(i == 0 or i == 1 or i == 2)
  if i == 0:
    return a.x
  elif i == 1:
    return a.y
  elif i == 2:
    return a.z
  elif i == 3:
    return a.w

func `[]=`*(a: var Vec4, i: int, b: float32) =
  assert(i == 0 or i == 1 or i == 2)
  if i == 0:
    a.x = b
  elif i == 1:
    a.y = b
  elif i == 2:
    a.z = b
  elif i == 3:
    a.w = b

func lerp*(a: Vec4, b: Vec4, v: float32): Vec4 =
  a * (1.0 - v) + b * v

func xyz*(a: Vec4): Vec3 =
  vec3(a.x, a.y, a.z)

func `$`*(a: Vec4): string =
  &"({a.x:.8f}, {a.y:.8f}, {a.z:.8f}, {a.w:.8f})"

func vec3*(a: Vec2, z = 0.0): Vec3 =
  vec3(a.x, a.y, z)

func vec4*(a: Vec3, w = 0.0): Vec4 =
  vec4(a.x, a.y, a.z, w)

func vec4*(a: Vec2, z = 0.0, w = 0.0): Vec4 =
  vec4(a.x, a.y, z, w)

type Mat3* = array[9, float32] ## 3x3 Matrix

func mat3*(a, b, c, d, e, f, g, h, i: float32): Mat3 =
  result[0] = a
  result[1] = b
  result[2] = c
  result[3] = d
  result[4] = e
  result[5] = f
  result[6] = g
  result[7] = h
  result[8] = i

func mat3*(a: Mat3): Mat3 =
  a

func identity*(a: var Mat3) =
  a[0] = 1
  a[1] = 0
  a[2] = 0
  a[3] = 0
  a[4] = 1
  a[5] = 0
  a[6] = 0
  a[7] = 0
  a[8] = 1

func mat3*(): Mat3 =
  result.identity()

func transpose*(a: Mat3): Mat3 =
  result[0] = a[0]
  result[1] = a[3]
  result[2] = a[6]
  result[3] = a[1]
  result[4] = a[4]
  result[5] = a[7]
  result[6] = a[2]
  result[7] = a[5]
  result[8] = a[8]

func `$`*(a: Mat3): string =
  &"""[{a[0]:.4f}, {a[1]:.4f}, {a[2]:.4f},
{a[3]:.4f}, {a[4]:.4f}, {a[5]:.4f},
{a[6]:.4f}, {a[7]:.4f}, {a[8]:.4f}]"""

func `*`*(a: Mat3, b: Mat3): Mat3 =
  let
    a00 = a[0]
    a01 = a[1]
    a02 = a[2]
    a10 = a[3]
    a11 = a[4]
    a12 = a[5]
    a20 = a[6]
    a21 = a[7]
    a22 = a[8]

    b00 = b[0]
    b01 = b[1]
    b02 = b[2]
    b10 = b[3]
    b11 = b[4]
    b12 = b[5]
    b20 = b[6]
    b21 = b[7]
    b22 = b[8]

  result[0] = b00 * a00 + b01 * a10 + b02 * a20
  result[1] = b00 * a01 + b01 * a11 + b02 * a21
  result[2] = b00 * a02 + b01 * a12 + b02 * a22

  result[3] = b10 * a00 + b11 * a10 + b12 * a20
  result[4] = b10 * a01 + b11 * a11 + b12 * a21
  result[5] = b10 * a02 + b11 * a12 + b12 * a22

  result[6] = b20 * a00 + b21 * a10 + b22 * a20
  result[7] = b20 * a01 + b21 * a11 + b22 * a21
  result[8] = b20 * a02 + b21 * a12 + b22 * a22

func `*`*(m: Mat3, v: Vec3): Vec3 =
  result.x = m[0]*v.x + m[1]*v.y + m[2]*v.z
  result.y = m[3]*v.x + m[4]*v.y + m[5]*v.z
  result.z = m[6]*v.x + m[7]*v.y + m[8]*v.z

func scale*(a: Mat3, v: Vec2): Mat3 =
  result[0] = v.x * a[0]
  result[1] = v.x * a[1]
  result[2] = v.x * a[2]
  result[3] = v.y * a[3]
  result[4] = v.y * a[4]
  result[5] = v.y * a[5]
  result[6] = a[6]
  result[7] = a[7]
  result[8] = a[8]

func scale*(a: Mat3, v: Vec3): Mat3 =
  result[0] = v.x * a[0]
  result[1] = v.x * a[1]
  result[2] = v.x * a[2]
  result[3] = v.y * a[3]
  result[4] = v.y * a[4]
  result[5] = v.y * a[5]
  result[6] = v.z * a[6]
  result[7] = v.z * a[7]
  result[8] = v.z * a[8]

func rotationMat3*(angle: float32): Mat3 =
  # Create a matrix from an angle.
  let
    sin = sin(angle)
    cos = cos(angle)
  result[0] = cos
  result[1] = -sin
  result[2] = 0

  result[3] = sin
  result[4] = cos
  result[5] = 0

  result[6] = 0
  result[7] = 0
  result[8] = 1

func rotate*(a: Mat3, angle: float32): Mat3 =
  # Rotates a matrix by an angle.
  a * rotationMat3(angle)

func `*`*(a: Mat3, b: Vec2): Vec2 =
  result.x = a[0]*b.x + a[1]*b.y + a[6]
  result.y = a[3]*b.x + a[4]*b.y + a[7]

type Mat4* = array[16, float32] ## 4x4 Matrix - OpenGL row order

func mat4*(v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13,
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

func mat4*(a: Mat4): Mat4 =
  a

func identity*(): Mat4 =
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

func mat4*(): Mat4 =
  identity()

func transpose*(a: Mat4): Mat4 =
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

func determinant*(a: Mat4): float32 =
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

func inverse*(a: Mat4): Mat4 =
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

  # Calculate the invese determinant
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

func `*`*(a, b: Mat4): Mat4 =
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

func `*`*(a: Mat4, b: Vec3): Vec3 =
  result.x = a[0]*b.x + a[4]*b.y + a[8]*b.z + a[12]
  result.y = a[1]*b.x + a[5]*b.y + a[9]*b.z + a[13]
  result.z = a[2]*b.x + a[6]*b.y + a[10]*b.z + a[14]

func `*`*(a: Mat4, b: Vec4): Vec4 =
  result.x = a[0]*b.x + a[4]*b.y + a[8]*b.z + a[12]*b.w
  result.y = a[1]*b.x + a[5]*b.y + a[9]*b.z + a[13]*b.w
  result.z = a[2]*b.x + a[6]*b.y + a[10]*b.z + a[14]*b.w
  result.w = a[3]*b.x + a[7]*b.y + a[11]*b.z + a[15]*b.w

func right*(a: Mat4): Vec3 =
  result.x = a[0]
  result.y = a[1]
  result.z = a[2]

func `right=`*(a: var Mat4, b: Vec3) =
  a[0] = b.x
  a[1] = b.y
  a[2] = b.z

func up*(a: Mat4): Vec3 =
  result.x = a[4]
  result.y = a[5]
  result.z = a[6]

func `up=`*(a: var Mat4, b: Vec3) =
  a[4] = b.x
  a[5] = b.y
  a[6] = b.z

func forward*(a: Mat4): Vec3 =
  result.x = a[8]
  result.y = a[9]
  result.z = a[10]

func `forward=`*(a: var Mat4, b: Vec3) =
  a[8] = b.x
  a[9] = b.y
  a[10] = b.z

func pos*(a: Mat4): Vec3 =
  result.x = a[12]
  result.y = a[13]
  result.z = a[14]

func `pos=`*(a: var Mat4, b: Vec3) =
  a[12] = b.x
  a[13] = b.y
  a[14] = b.z

func rotationOnly*(a: Mat4): Mat4 =
  result = a
  result.pos = vec3(0, 0, 0)

func dist*(a, b: Mat4): float32 =
  var
    x = a[12] - b[12]
    y = a[13] - b[13]
    z = a[14] - b[14]
  sqrt(x*x + y*y + z*z)

#[
func translate*(a: Mat4, v: Vec3): Mat4 =
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

func translate*(v: Vec3): Mat4 =
  result[0] = 1
  result[5] = 1
  result[10] = 1
  result[15] = 1
  result[12] = v.x
  result[13] = v.y
  result[14] = v.z

func scale*(v: Vec3): Mat4 =
  result[0] = v.x
  result[5] = v.y
  result[10] = v.z
  result[15] = 1

func close*(a: Mat4, b: Mat4): bool =
  for i in 0..15:
    if abs(a[i] - b[i]) > 0.001:
      return false
  true

func hrp*(m: Mat4): Vec3 =
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

func frustum*(left, right, bottom, top, near, far: float32): Mat4 =
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

func perspective*(fovy, aspect, near, far: float32): Mat4 =
  var
    top = near * tan(fovy*PI / 360.0)
    right = top * aspect
  frustum(-right, right, -top, top, near, far)

func ortho*(left, right, bottom, top, near, far: float32): Mat4 =
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

func lookAt*(eye, center, up: Vec3): Mat4 =
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

func `$`*(a: Mat4): string =
  &"""[{a[0]:.5f}, {a[1]:.5f}, {a[2]:.5f}, {a[3]:.5f},
{a[4]:.5f}, {a[5]:.5f}, {a[6]:.5f}, {a[7]:.5f},
{a[8]:.5f}, {a[9]:.5f}, {a[10]:.5f}, {a[11]:.5f},
{a[12]:.5f}, {a[13]:.5f}, {a[14]:.5f}, {a[15]:.5f}]"""

type Quat* = object
  x*: float32
  y*: float32
  z*: float32
  w*: float32

func quat*(x, y, z, w: float32): Quat =
  result.x = x
  result.y = y
  result.z = z
  result.w = w

func conjugate*(q: Quat): Quat =
  result.w = +q.w
  result.x = -q.x
  result.y = -q.y
  result.z = -q.z

func length*(q: Quat): float32 =
  sqrt(
    q.w * q.w +
    q.x * q.x +
    q.y * q.y +
    q.z * q.z)

func normalize*(q: Quat): Quat =
  var m = q.length
  result.x = q.x / m
  result.y = q.y / m
  result.z = q.z / m
  result.w = q.w / m

func xyz*(q: Quat): Vec3 =
  result.x = q.x
  result.y = q.y
  result.z = q.z

func `xyz=`*(q: var Quat, v: Vec3) =
  q.x = v.x
  q.y = v.y
  q.z = v.z

func `-`*(a: var Quat): Quat =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z
  result.w = -a.w

func `+`*(a: Quat, b: Quat): Quat =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z
  result.w = a.w + b.w

func `*`*(a, b: Quat): Quat =
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

func `*`*(q: Quat, v: float32): Quat =
  ## Multiply the quaternion by a float32.
  result.x = q.x * v
  result.y = q.y * v
  result.z = q.z * v
  result.w = q.w * v

func `*`*(q: Quat, v: Vec3): Vec3 =
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

func `[]=`*(a: var Quat, i: int, b: float32) =
  assert(i == 0 or i == 1 or i == 2 or i == 3)
  if i == 0:
    a.x = b
  elif i == 1:
    a.y = b
  elif i == 2:
    a.z = b
  elif i == 3:
    a.w = b

func mat3*(q: Quat): Mat3 =
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

func mat4*(q: Quat): Mat4 =
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

func recifuncalSqrt*(x: float32): float32 =
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

func fromAxisAngle*(axis: Vec3, angle: float32): Quat =
  var a = axis.normalize()
  var s = sin(angle / 2)
  result.x = a.x * s
  result.y = a.y * s
  result.z = a.z * s
  result.w = cos(angle / 2)

func toAxisAngle*(q: Quat, axis: var Vec3, angle: var float32) =
  var cosAngle = q.w
  angle = arccos(cosAngle) * 2.0
  var sinAngle = sqrt(1.0 - cosAngle * cosAngle)

  if abs(sinAngle) < 0.0005:
    sinAngle = 1.0

  axis.x = q.x / sinAngle
  axis.y = q.y / sinAngle
  axis.z = q.z / sinAngle

func quat*(heading, pitch, roll: float32): Quat =
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

func hrp*(q: Quat): Vec3 =
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

func dot*(a: Quat, b: Quat): float32 =
  a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w

func nlerp*(a: Quat, b: Quat, v: float32): Quat =
  if dot(a, b) < 0:
    var c = a
    (-c * (1.0 - v) + b * v).normalize()
  else:
    (a * (1.0 - v) + b * v).normalize()

func `$`*(a: Quat): string =
  &"q({a.x:.8f}, {a.y:.8f}, {a.z:.8f}, {a.w:.8f})"

func rotate*(angle: float32, axis: Vec3): Mat4 =
  fromAxisAngle(axis, angle).mat4()

func rotateX*(angle: float32): Mat4 =
  rotate(angle, vec3(1, 0, 0))

func rotateY*(angle: float32): Mat4 =
  rotate(angle, vec3(0, 1, 0))

func rotateZ*(angle: float32): Mat4 =
  rotate(angle, vec3(0, 0, 1))

func scaleMat*(scale: Vec3): Mat4 =
  result[0] = scale.x
  result[5] = scale.y
  result[10] = scale.z
  result[15] = 1.0

func scaleMat*(scale: float32): Mat4 =
  scaleMat(vec3(scale, scale, scale))

type Rect* = object
  x*: float32
  y*: float32
  w*: float32
  h*: float32

func rect*(x, y, w, h: float32): Rect =
  result.x = x
  result.y = y
  result.w = w
  result.h = h

func rect*(pos, size: Vec2): Rect =
  result.x = pos.x
  result.y = pos.y
  result.w = size.x
  result.h = size.y

func xy*(rect: Rect): Vec2 =
  ## Gets the xy as a Vec2.
  vec2(rect.x, rect.y)

func `xy=`*(rect: var Rect, v: Vec2) =
  ## Sets the xy from Vec2.
  rect.x = v.x
  rect.y = v.y

func wh*(rect: Rect): Vec2 =
  ## Gets the wh as a Vec2.
  vec2(rect.w, rect.h)

func `wh=`*(rect: var Rect, v: Vec2) =
  ## Sets the wh from Vec2.
  rect.w = v.x
  rect.h = v.y

func `*`*(r: Rect, v: float): Rect =
  ## * all elements of a Rect.
  rect(r.x * v, r.y * v, r.w * v, r.h * v)

func `/`*(r: Rect, v: float): Rect =
  ## / all elements of a Rect.
  rect(r.x / v, r.y / v, r.w / v, r.h / v)

func `+`*(a, b: Rect): Rect =
  ## Add two boxes together.
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.w = a.w
  result.h = a.h

func `$`*(a: Rect): string =
  &"({a.x}, {a.y}: {a.w} x {a.h})"

func inside*(pos: Vec2, rect: Rect): bool =
  ## Checks if pos is inside rect.
  (rect.x <= pos.x and pos.x <= rect.x + rect.w) and (
    rect.y <= pos.y and pos.y <= rect.y + rect.h)

func overlap*(a, b: Rect): bool =
  ## Returns true if box a overlaps box b.
  let
    xOverlap = between(a.x, b.x, b.x + b.w) or between(b.x, a.x, a.x + a.w)
    yOverlap = between(a.y, b.y, b.y + b.h) or between(b.y, a.y, a.y + a.h)
  xOverlap and yOverlap
