import math
export math

proc between*(value, min, max: float32): bool {.inline.} =
  ## Returns true if value is between min and max or equal to them.
  (value >= min) and (value <= max)

proc sign*(v: float32): float32 {.inline.} =
  ## Returns the sign of a number, -1 or 1.
  if v >= 0: 1.0 else: -1.0

proc quantize*(v, n: float32): float32 {.inline.} =
  ## Makes v be multipe of n. Rounding to integer quantize by 1.0.
  sign(v) * floor(abs(v) / n) * n

proc lerp*(a, b, v: float32): float32 {.inline.} =
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

proc angleBetween*(a, b: float32): float32 {.inline.} =
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


import glm
export glm except Vec2, Vec3, Vec4, Mat3, Mat4, Quat, vec2, vec3, vec4, mat3, mat4, quat


type
  Vec2* = glm.Vec2[float32]
  Vec3* = glm.Vec3[float32]
  Vec4* = glm.Vec4[float32]

  Mat3* = glm.Mat3[float32]
  Mat4* = glm.Mat4[float32]

  Quat* = glm.Quat[float32]

proc lengthSq*(a: Vec2): float32 {.inline.} =
  a.x * a.x + a.y * a.y

proc dist*(at, to: Vec2): float32 {.inline.} =
  (at - to).length

proc distSq*(at, to: Vec2): float32 {.inline.} =
  (at - to).lengthSq

proc `*`*(m: Mat3, v: Vec2): Vec2 =
  (m * vec3(v.x, v.y, 1.0)).xy

template vec2*(x, y: float32): Vec2 = glm.vec2[float32](x, y)
template vec2*(x: float32): Vec2 = glm.vec2[float32](x, x)
template vec3*(x, y, z: float32): Vec3 = glm.vec2[float32](x, y, z)
template mat3*(): Mat3 = glm.mat3[float32]()

proc mat3*(a,b,c,d,e,f,g,h,i: float32): Mat3 {.inline.} =
  result[0, 0] = a
  result[0, 1] = b
  result[0, 2] = c
  result[1, 0] = d
  result[1, 1] = e
  result[1, 2] = f
  result[2, 0] = g
  result[2, 1] = h
  result[2, 2] = i

proc scale*(v:Vec2): Mat3 {.inline.} =
  result[0, 0] = v.x
  result[1, 0] = v.y

proc translate*(v:Vec2): Mat3 {.inline.} =
  result[2, 0] = v.x
  result[2, 1] = v.y

proc angle*(a: Vec2): float32 {.inline.} =
  ## Angle of a Vec2.
  arctan2(a.y, a.x)

proc rotate*(angle: float32): Mat3 {.inline.} =
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

proc pos*(a: Mat3): Vec2 {.inline.} =
  result.x = a[2, 0]
  result.y = a[2, 1]

proc `pos=`*(a: var Mat3, b: Vec2) {.inline.} =
  a[2, 0] = b.x
  a[2, 1] = b.y
