import fixmath
import strutils
import random
import print

const PI = fix16(3.14159265359)

proc `+=`*(a: var fix16, b: fix16) =
  a = a + b

proc `-=`*(a: var fix16, b: fix16) =
  a = a - b

proc `*=`*(a: var fix16, b: fix16) =
  a = a * b

proc `/=`*(a: var fix16, b: fix16) =
  a = a / b

proc `+`*(a: fix16): fix16 =
  a

proc `-`*(a: fix16): fix16 =
  0.fix16 - a

proc arctan*(a: fix16): fix16 =
  atan(a)

proc arctan2*(a: fix16, b: fix16): fix16 =
  atan2(a, b)

proc arcsin(a: fix16): fix16 =
  asin(a)

proc arccos(a: fix16): fix16 =
  acos(a)

proc clamp*(n, min, max: fix16): fix16 =
  if n < min:
    return min
  if n > max:
    return max
  return n

proc sign*(v: fix16): fix16 =
  ## Returns the sign of a number, -1 or 1.
  if v >= 0:
    return 1.0
  return -1.0

proc quantize*(v: fix16, n: fix16): fix16 =
  result = sign(v) * floor(abs(v) / n) * n

type XVec2* = object
  x*: fix16
  y*: fix16

proc xvec2*(x, y: fix16): XVec2 =
  result.x = x
  result.y = y

proc xvec2*(a: XVec2): XVec2 =
  result.x = a.x
  result.y = a.y

proc `+`*(a: XVec2, b: XVec2): XVec2 =
  result.x = a.x + b.x
  result.y = a.y + b.y

proc `-`*(a: XVec2, b: XVec2): XVec2 =
  result.x = a.x - b.x
  result.y = a.y - b.y

proc `*`*(a: XVec2, b: fix16): XVec2 =
  result.x = a.x * b
  result.y = a.y * b

proc `*`*(a: fix16, b: XVec2): XVec2 =
  b * a

proc `/`*(a: XVec2, b: fix16): XVec2 =
  result.x = a.x / b
  result.y = a.y / b

proc `+=`*(a: var XVec2, b: XVec2) =
  a.x += b.x
  a.y += b.y

proc `-=`*(a: var XVec2, b: XVec2) =
  a.x -= b.x
  a.y -= b.y

proc `*=`*(a: var XVec2, b: fix16) =
  a.x *= b
  a.y *= b

proc `/=`*(a: var XVec2, b: fix16) =
  a.x /= b
  a.y /= b

proc zero*(a: var XVec2) =
  a.x = 0
  a.y = 0

proc `-`*(a: XVec2): XVec2 =
  result.x = -a.x
  result.y = -a.y

proc magSq*(a: XVec2): fix16 =
  a.x * a.x + a.y * a.y

proc length*(a: XVec2): fix16 =
  sqrt(a.magSq)

proc `length=`*(a: var XVec2, b: fix16) =
  a *= b / a.length

proc normalize*(a: XVec2): XVec2 =
  a / a.length

proc dot*(a: XVec2, b: XVec2): fix16 =
  a.x*b.x + a.y*b.y

proc dir*(at: XVec2, to: XVec2): XVec2 =
  result = (at - to).normalize()

proc dist*(at: XVec2, to: XVec2): fix16 =
  (at - to).length

proc lerp*(a: XVec2, b: XVec2, v: fix16): XVec2 =
  a * (1.fix16 - v) + b * v

proc quantize*(v: XVec2, n: fix16): XVec2 =
  result.x = sign(v.x) * floor(abs(v.x) / n) * n
  result.y = sign(v.y) * floor(abs(v.y) / n) * n

proc inRect*(v: XVec2, a: XVec2, b: XVec2): bool =
  ## Check to see if v is inside a rectange formed by a and b
  ## It does not matter how a and b are arranged
  let
    min = xvec2(min(a.x, b.x), min(a.y, b.y))
    max = xvec2(max(a.x, b.x), max(a.y, b.y))
  return v.x > min.x and v.x < max.x and v.y > min.y and v.y < max.y

template `[]`*(a: XVec2, i: int): fix16 =
  assert(i == 0 or i == 1)
  when i == 0:
    a.x
  elif i == 1:
    a.y

template `[]=`*(a: XVec2, i: int, b: fix16) =
  assert(i == 0 or i == 1)
  when i == 0:
    a.x = b
  elif i == 1:
    a.y = b

proc `$`*(a: XVec2): string =
  return "(" &
    a.x.formatFloat(ffDecimal,4) & ", " &
    a.y.formatFloat(ffDecimal,4) & ")"

proc fixAngle*(angle: fix16): fix16 =
  ## Make angle be from 0 to 2PI radians
  while angle > PI:
    return angle - PI * 2.toFix16
  while angle < -PI:
    return angle + PI * 2.toFix16
  return angle

proc angle*(a: XVec2): fix16 =
  ## Angle of a xvec2
  #echo "arctan2(" & $a.y & "," & $a.x & ") = " & $arctan2(a.y, a.x)
  arctan2(a.y, a.x)

proc angleBetween*(a: XVec2, b: XVec2): fix16 =
  ## Angle between 2 vec
  fixAngle(arctan2(a.y - b.y, a.x - b.x))

proc turnAngle*(a, b, speed: fix16): fix16 =
  ## Move from angle a to angle b with step of v
  var
    turn = fixAngle(b - a)
  if abs(turn) < speed:
    return b
  elif turn > speed:
    turn = speed
  elif turn < -speed:
    turn = -speed
  return a + turn


type XVec3* = object
  x*: fix16
  y*: fix16
  z*: fix16

proc xvec3*(x, y, z: fix16): XVec3 =
  result.x = x
  result.y = y
  result.z = z

proc xvec3*(a: XVec3): XVec3 =
  result.x = a.x
  result.y = a.y
  result.z = a.z

let X_DIR* = xvec3(1, 0, 0)
let Y_DIR* = xvec3(0, 1, 0)
let Z_DIR* = xvec3(0, 0, 1)

proc `+`*(a: XVec3, b: XVec3): XVec3 =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z

proc `-`*(a: XVec3, b: XVec3): XVec3 =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z

proc `-`*(a: XVec3): XVec3 =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z

proc `*`*(a: XVec3, b: fix16): XVec3 =
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b

proc `*`*(a: fix16, b: XVec3): XVec3 =
  b * a

proc `/`*(a: XVec3, b: fix16): XVec3 =
  result.x = a.x / b
  result.y = a.y / b
  result.z = a.z / b

proc `/`*(a: fix16, b: XVec3): XVec3 =
  result.x = a / b.x
  result.y = a / b.y
  result.z = a / b.z

proc `+=`*(a: var XVec3, b: XVec3) =
  a.x += b.x
  a.y += b.y
  a.z += b.z

proc `-=`*(a: var XVec3, b: XVec3) =
  a.x -= b.x
  a.y -= b.y
  a.z -= b.z

proc `*=`*(a: var XVec3, b: fix16) =
  a.x *= b
  a.y *= b
  a.z *= b

proc `/=`*(a: var XVec3, b: fix16) =
  a.x /= b
  a.y /= b
  a.z /= b

proc zero*(a: var XVec3) =
  a.x = 0
  a.y = 0
  a.z = 0

proc `-`*(a: var XVec3): XVec3 =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z

proc lengthSqrd*(a: XVec3): fix16 =
  a.x * a.x + a.y * a.y + a.z * a.z

proc length*(a: XVec3): fix16 =
  sqrt(a.lengthSqrd)

proc `length=`*(a: var XVec3, b: fix16) =
  a *= b / a.length

proc normalize*(a: XVec3): XVec3 =
  return a / sqrt(a.x*a.x + a.y*a.y + a.z*a.z)

proc cross*(a: XVec3, b: XVec3): XVec3 =
  result.x = a.y*b.z - a.z*b.y
  result.y = a.z*b.x - a.x*b.z
  result.z = a.x*b.y - a.y*b.x

proc computeNormal*(a, b, c: XVec3): XVec3 =
  result = cross(c - b, b - a).normalize()

proc dot*(a: XVec3, b: XVec3): fix16 =
  a.x*b.x + a.y*b.y + a.z*b.z

proc dir*(at: XVec3, to: XVec3): XVec3 =
  result = (at - to).normalize()

proc dist*(at: XVec3, to: XVec3): fix16 =
  (at - to).length

proc lerp*(a: XVec3, b: XVec3, v: fix16): XVec3 =
  a * (1.fix16 - v) + b * v

proc angleBetween*(a, b: XVec3): fix16 =
  var dot = dot(a, b)
  dot = dot / (a.length * b.length)
  return arccos(dot)

template `[]`*(a: XVec3, i: int): fix16 =
  assert(i == 0 or i == 1 or i == 2)
  when i == 0:
    a.x
  elif i == 1:
    a.y
  elif i == 2:
    a.z

template `[]=`*(a: XVec3, i: int, b: fix16) =
  assert(i == 0 or i == 1 or i == 2)
  when i == 0:
    a.x = b
  elif i == 1:
    a.y = b
  elif i == 2:
    a.z = b

proc xy*(a: XVec3): XVec2 =
  xvec2(a.x, a.y)

proc xz*(a: XVec3): XVec2 =
  xvec2(a.x, a.z)

proc yx*(a: XVec3): XVec2 =
  xvec2(a.y, a.x)

proc yz*(a: XVec3): XVec2 =
  xvec2(a.y, a.z)

proc zx*(a: XVec3): XVec2 =
  xvec2(a.y, a.x)

proc zy*(a: XVec3): XVec2 =
  xvec2(a.z, a.y)

proc almostEquals*(a, b: XVec3, precision = 0.0001.fix16): bool =
  let c = a - b
  return abs(c.x) < precision and abs(c.y) < precision and abs(c.z) < precision

proc `$`*(a: XVec3): string =
  return "(" &
    a.x.formatFloat(ffDecimal,8) & ", " &
    a.y.formatFloat(ffDecimal,8) & ", " &
    a.z.formatFloat(ffDecimal,8) & ")"


type XVec4* = object
  x*: fix16
  y*: fix16
  z*: fix16
  w*: fix16

proc xvec4*(x, y, z, w: fix16): XVec4 =
  result.x = x
  result.y = y
  result.z = z
  result.w = w

proc `+`*(a: XVec4, b: XVec4): XVec4 =
  result.x = a.x + b.x
  result.y = a.y + b.y
  result.z = a.z + b.z
  result.w = a.w + b.w

proc `-`*(a: XVec4, b: XVec4): XVec4 =
  result.x = a.x - b.x
  result.y = a.y - b.y
  result.z = a.z - b.z
  result.w = a.w - b.w

proc `-`*(a: XVec4): XVec4 =
  result.x = -a.x
  result.y = -a.y
  result.z = -a.z
  result.w = -a.w

proc `*`*(a: XVec4, b: fix16): XVec4 =
  result.x = a.x * b
  result.y = a.y * b
  result.z = a.z * b
  result.w = a.w * b

proc `*`*(a: fix16, b: XVec4): XVec4 =
  b * a

proc `/`*(a: XVec4, b: fix16): XVec4 =
  result.x = a.x / b
  result.y = a.y / b

  result.z = a.z / b
  result.w = a.w / b

proc `/`*(a: fix16, b: XVec4): XVec4 =
  result.x = a / b.x
  result.y = a / b.y
  result.z = a / b.z
  result.w = a / b.w

proc `+=`*(a: var XVec4, b: XVec4) =
  a.x += b.x
  a.y += b.y
  a.z += b.z
  a.w += b.w

proc `-=`*(a: var XVec4, b: XVec4) =
  a.x -= b.x
  a.y -= b.y
  a.z -= b.z
  a.w -= b.w

proc `*=`*(a: var XVec4, b: fix16) =
  a.x *= b
  a.y *= b
  a.z *= b
  a.w *= b

proc `/=`*(a: var XVec4, b: fix16) =
  a.x /= b
  a.y /= b
  a.z /= b
  a.w /= b

proc zero*(a: var XVec4) =
  a.x = 0
  a.y = 0
  a.z = 0
  a.w = 0

proc xyz*(a: XVec4): XVec3 =
  xvec3(a.x, a.y, a.z)

proc `$`*(a: XVec4): string =
  return "(" &
    a.x.formatFloat(ffDecimal,8) & ", " &
    a.y.formatFloat(ffDecimal,8) & ", " &
    a.z.formatFloat(ffDecimal,8) & ", " &
    a.w.formatFloat(ffDecimal,8) & ")"


proc xvec3*(a: XVec2, z=0.0): XVec3 =
  xvec3(a.x, a.y, z)

proc xvec4*(a: XVec3, w=0.0): XVec4 =
  xvec4(a.x, a.y, a.z, w)

proc xvec4*(a: XVec2, z=0.0, w=0.0): XVec4 =
  xvec4(a.x, a.y, z, w)


type XMat3* = array[9, fix16]

proc xmat3*(a, b, c, d, e, f, g, h, i: fix16): XMat3 =
  result[0] = a
  result[1] = b
  result[2] = c
  result[3] = d
  result[4] = e
  result[5] = f
  result[6] = g
  result[7] = h
  result[8] = i


proc xmat3*(a: XMat3): XMat3 =
  result = a


proc identity*(a: var XMat3) =
  a[0] = 1
  a[1] = 0
  a[2] = 0
  a[3] = 0
  a[4] = 1
  a[5] = 0
  a[6] = 0
  a[7] = 0
  a[8] = 1


proc xmat3*(): XMat3 =
  result.identity()


proc transpose*(a: XMat3): XMat3 =
  result[0] = a[0]
  result[1] = a[3]
  result[2] = a[6]
  result[3] = a[1]
  result[4] = a[4]
  result[5] = a[7]
  result[6] = a[2]
  result[7] = a[5]
  result[8] = a[8]


proc `$`*(a: XMat3): string =
  return "[" &
    a[0].formatFloat(ffDecimal,4) & ", " &
    a[1].formatFloat(ffDecimal,4) & ", " &
    a[2].formatFloat(ffDecimal,4) & ", " &
    a[3].formatFloat(ffDecimal,4) & ", " &
    a[4].formatFloat(ffDecimal,4) & ", " &
    a[5].formatFloat(ffDecimal,4) & ", " &
    a[6].formatFloat(ffDecimal,4) & ", " &
    a[7].formatFloat(ffDecimal,4) & ", " &
    a[8].formatFloat(ffDecimal,4) & "]"

proc `*`*(a: XMat3, b: XMat3): XMat3 =
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


proc `*`*(m: XMat3, v: XVec3): XVec3 =
  result.x = m[0]*v.x + m[1]*v.y + m[2]*v.z
  result.y = m[3]*v.x + m[4]*v.y + m[5]*v.z
  result.z = m[6]*v.x + m[7]*v.y + m[8]*v.z


proc scale*(a: XMat3, v: XVec2): XMat3 =
  result[0] = v.x * a[0]
  result[1] = v.x * a[1]
  result[2] = v.x * a[2]
  result[3] = v.y * a[3]
  result[4] = v.y * a[4]
  result[5] = v.y * a[5]
  result[6] = a[6]
  result[7] = a[7]
  result[8] = a[8]


proc scale*(a: XMat3, v: XVec3): XMat3 =
  result[0] = v.x * a[0]
  result[1] = v.x * a[1]
  result[2] = v.x * a[2]
  result[3] = v.y * a[3]
  result[4] = v.y * a[4]
  result[5] = v.y * a[5]
  result[6] = v.z * a[6]
  result[7] = v.z * a[7]
  result[8] = v.z * a[8]


type XMat4* = array[16, fix16]


proc xmat4*(v0, v1, XVec2, XVec3, XVec4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15: fix16): XMat4 =
  result[0] = v0
  result[1] = v1
  result[2] = XVec2
  result[3] = XVec3
  result[4] = XVec4
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


proc xmat4*(a: XMat4): XMat4 =
  result = a


proc identity*(): XMat4 =
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


proc xmat4*(): XMat4 =
  return identity()


proc transpose*(a: XMat4): XMat4 =
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


proc determinant*(a: XMat4): fix16 =
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

  return (
    a30*a21*a12*a03 - a20*a31*a12*a03 - a30*a11*a22*a03 + a10*a31*a22*a03 +
    a20*a11*a32*a03 - a10*a21*a32*a03 - a30*a21*a02*a13 + a20*a31*a02*a13 +
    a30*a01*a22*a13 - a00*a31*a22*a13 - a20*a01*a32*a13 + a00*a21*a32*a13 +
    a30*a11*a02*a23 - a10*a31*a02*a23 - a30*a01*a12*a23 + a00*a31*a12*a23 +
    a10*a01*a32*a23 - a00*a11*a32*a23 - a20*a11*a02*a33 + a10*a21*a02*a33 +
    a20*a01*a12*a33 - a00*a21*a12*a33 - a10*a01*a22*a33 + a00*a11*a22*a33
  )


proc inverse*(a: XMat4): XMat4 =
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
  var invDet = 1.fix16/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

  result[ 0] = ( a11*b11 - a12*b10 + a13*b09)*invDet
  result[ 1] = (-a01*b11 + a02*b10 - a03*b09)*invDet
  result[ 2] = ( a31*b05 - a32*b04 + a33*b03)*invDet
  result[ 3] = (-a21*b05 + a22*b04 - a23*b03)*invDet
  result[ 4] = (-a10*b11 + a12*b08 - a13*b07)*invDet
  result[ 5] = ( a00*b11 - a02*b08 + a03*b07)*invDet
  result[ 6] = (-a30*b05 + a32*b02 - a33*b01)*invDet
  result[ 7] = ( a20*b05 - a22*b02 + a23*b01)*invDet
  result[ 8] = ( a10*b10 - a11*b08 + a13*b06)*invDet
  result[ 9] = (-a00*b10 + a01*b08 - a03*b06)*invDet
  result[10] = ( a30*b04 - a31*b02 + a33*b00)*invDet
  result[11] = (-a20*b04 + a21*b02 - a23*b00)*invDet
  result[12] = (-a10*b09 + a11*b07 - a12*b06)*invDet
  result[13] = ( a00*b09 - a01*b07 + a02*b06)*invDet
  result[14] = (-a30*b03 + a31*b01 - a32*b00)*invDet
  result[15] = ( a20*b03 - a21*b01 + a22*b00)*invDet


proc `*`*(a, b: XMat4): XMat4 =
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

  result[ 0] = b00*a00 + b01*a10 + b02*a20 + b03*a30
  result[ 1] = b00*a01 + b01*a11 + b02*a21 + b03*a31
  result[ 2] = b00*a02 + b01*a12 + b02*a22 + b03*a32
  result[ 3] = b00*a03 + b01*a13 + b02*a23 + b03*a33
  result[ 4] = b10*a00 + b11*a10 + b12*a20 + b13*a30
  result[ 5] = b10*a01 + b11*a11 + b12*a21 + b13*a31
  result[ 6] = b10*a02 + b11*a12 + b12*a22 + b13*a32
  result[ 7] = b10*a03 + b11*a13 + b12*a23 + b13*a33
  result[ 8] = b20*a00 + b21*a10 + b22*a20 + b23*a30
  result[ 9] = b20*a01 + b21*a11 + b22*a21 + b23*a31
  result[10] = b20*a02 + b21*a12 + b22*a22 + b23*a32
  result[11] = b20*a03 + b21*a13 + b22*a23 + b23*a33
  result[12] = b30*a00 + b31*a10 + b32*a20 + b33*a30
  result[13] = b30*a01 + b31*a11 + b32*a21 + b33*a31
  result[14] = b30*a02 + b31*a12 + b32*a22 + b33*a32
  result[15] = b30*a03 + b31*a13 + b32*a23 + b33*a33


proc `*`*(a: XMat4, b: XVec3): XVec3 =
  result.x = a[0]*b.x + a[4]*b.y + a[8]*b.z + a[12]
  result.y = a[1]*b.x + a[5]*b.y + a[9]*b.z + a[13]
  result.z = a[2]*b.x + a[6]*b.y + a[10]*b.z + a[14]


proc right*(a: XMat4): XVec3 =
  result.x = a[0]
  result.y = a[1]
  result.z = a[2]


proc `right=`*(a: var XMat4, b: XVec3) =
  a[0] = b.x
  a[1] = b.y
  a[2] = b.z


proc up*(a: XMat4): XVec3 =
  result.x = a[4]
  result.y = a[5]
  result.z = a[6]


proc `up=`*(a: var XMat4, b: XVec3) =
  a[4] = b.x
  a[5] = b.y
  a[6] = b.z


proc fov*(a: XMat4): XVec3 =
  result.x = a[8]
  result.y = a[9]
  result.z = a[10]


proc `fov=`*(a: var XMat4, b: XVec3) =
  a[8] = b.x
  a[9] = b.y
  a[10] = b.z


proc pos*(a: XMat4): XVec3 =
  result.x = a[12]
  result.y = a[13]
  result.z = a[14]


proc `pos=`*(a: var XMat4, b: XVec3) =
  a[12] = b.x
  a[13] = b.y
  a[14] = b.z


proc rotationOnly*(a: XMat4): XMat4 =
  result = a
  result.pos = xvec3(0,0,0)


proc distance*(a, b: XMat4): fix16 =
    var
      x = a[12] - b[12]
      y = a[13] - b[13]
      z = a[14] - b[14]
    return sqrt(x*x + y*y + z*z)

#[
proc translate*(a: XMat4, v: XVec3): XMat4 =
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


proc translate*(v: XVec3): XMat4 =
  result[0] = 1
  result[5] = 1
  result[10] = 1
  result[15] = 1
  result[12] = v.x
  result[13] = v.y
  result[14] = v.z


proc scale*(v: XVec3): XMat4 =
  result[0] = v.x
  result[5] = v.x
  result[10] = v.z
  result[15] = 1


proc close*(a: XMat4, b: XMat4): bool =
  for i in 0..15:
    if abs(a[i] - b[i]) > 0.001:
      return false
  return true


proc hrp*(m: XMat4): XVec3 =
  var heading, pitch, roll: fix16
  if m[1] > 0.998.fix16: # singularity at north pole
    heading = arctan2(m[2], m[10])
    pitch = PI / 2.fix16
    roll = 0
  elif m[1] < -0.998.fix16:  # singularity at sresulth pole
    heading = arctan2(m[2], m[10])
    pitch = -PI / 2.fix16
    roll = 0
  else:
    heading =arctan2(-m[8], m[0])
    pitch = arctan2(-m[6], m[5])
    roll = arcsin(m[4])
  result.x = heading
  result.y = pitch
  result.z = roll


proc frustum*(left, right, bottom, top, near, far: fix16): XMat4 =
  var
    rl = (right - left)
    tb = (top - bottom)
    fn = (far - near)
  result[0] = (near*2.fix16) / rl
  result[1] = 0
  result[2] = 0
  result[3] = 0
  result[4] = 0
  result[5] = (near*2.fix16) / tb
  result[6] = 0
  result[7] = 0
  result[8] = (right + left) / rl
  result[9] = (top + bottom) / tb
  result[10] = -(far + near) / fn
  result[11] = -1
  result[12] = 0
  result[13] = 0
  result[14] = -(far*near*2.fix16) / fn
  result[15] = 0


proc perspective*(fovy, aspect, near, far: fix16): XMat4 =
  var
    top = near * tan(fovy*PI / 360.0.fix16)
    right = top * aspect
  return frustum(-right, right, -top, top, near, far)


proc ortho*(left, right, bottom, top, near, far: fix16): XMat4 =
    var
      rl = (right - left)
      tb = (top - bottom)
      fn = (far - near)
    result[0] = 2.fix16 / rl
    result[1] = 0
    result[2] = 0
    result[3] = 0
    result[4] = 0
    result[5] = 2.fix16 / tb
    result[6] = 0
    result[7] = 0
    result[8] = 0
    result[9] = 0
    result[10] = -2.fix16 / fn
    result[11] = 0
    result[12] = -(left + right) / rl
    result[13] = -(top + bottom) / tb
    result[14] = -(far + near) / fn
    result[15] = 1


proc lookAt*(eye, center, up: XVec3): XMat4 =
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
      # xvec3.direction(eye, center, z)
      z0 = eyex - center[0]
      z1 = eyey - center[1]
      z2 = eyez - center[2]

    # normalize (no check needed for 0 because of early return)
    var len = 1.fix16/sqrt(z0*z0 + z1*z1 + z2*z2)
    z0 *= len
    z1 *= len
    z2 *= len

    var
      # xvec3.normalize(xvec3.cross(up, z, x))
      x0 = upy*z2 - upz*z1
      x1 = upz*z0 - upx*z2
      x2 = upx*z1 - upy*z0
    len = sqrt(x0*x0 + x1*x1 + x2*x2)
    if len == 0.fix16:
        x0 = 0
        x1 = 0
        x2 = 0
    else:
        len = 1.fix16/len
        x0 *= len
        x1 *= len
        x2 *= len

    var
      # xvec3.normalize(xvec3.cross(z, x, y))
      y0 = z1*x2 - z2*x1
      y1 = z2*x0 - z0*x2
      y2 = z0*x1 - z1*x0

    len = sqrt(y0*y0 + y1*y1 + y2*y2)
    if len == 0.fix16:
        y0 = 0
        y1 = 0
        y2 = 0
    else:
        len = 1.fix16/len
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


proc toFix16Array*(m: XMat4): array[16, fix16] =
   return [
      fix16 m[0],  fix16 m[1],  fix16 m[2],  fix16 m[3],
      fix16 m[4],  fix16 m[5],  fix16 m[6],  fix16 m[7],
      fix16 m[8],  fix16 m[9],  fix16 m[10], fix16 m[11],
      fix16 m[12], fix16 m[13], fix16 m[14], fix16 m[15]
   ]


proc `$`*(a: XMat4): string =
  return "[" &
    a[0].formatFloat(ffDecimal, 5) & ", " &
    a[1].formatFloat(ffDecimal, 5) & ", " &
    a[2].formatFloat(ffDecimal, 5) & ", " &
    a[3].formatFloat(ffDecimal, 5) & ",\n" &
    a[4].formatFloat(ffDecimal, 5) & ", " &
    a[5].formatFloat(ffDecimal, 5) & ", " &
    a[6].formatFloat(ffDecimal, 5) & ", " &
    a[7].formatFloat(ffDecimal, 5) & ",\n " &
    a[8].formatFloat(ffDecimal, 5) & ", " &
    a[9].formatFloat(ffDecimal, 5) & ", " &
    a[10].formatFloat(ffDecimal, 5) & ", " &
    a[11].formatFloat(ffDecimal, 5) & ",\n" &
    a[12].formatFloat(ffDecimal, 5) & ", " &
    a[13].formatFloat(ffDecimal, 5) & ", " &
    a[14].formatFloat(ffDecimal, 5) & ", " &
    a[15].formatFloat(ffDecimal, 5) & "]"


type XQuat* = object
  x*: fix16
  y*: fix16
  z*: fix16
  w*: fix16


proc xquat*(x, y, z, w: fix16): XQuat =
  result.x = x
  result.y = y
  result.z = z
  result.w = w


proc conjugate*(q: XQuat): XQuat =
  result.w =  q.w
  result.x = -q.x
  result.y = -q.y
  result.z = -q.z


proc length*(q: XQuat): fix16 =
  return sqrt(
    q.w * q.w +
    q.x * q.x +
    q.y * q.y +
    q.z * q.z)


proc normalize*(q: XQuat): XQuat =
  var m = q.length
  result.x = q.x / m
  result.y = q.y / m
  result.z = q.z / m
  result.w = q.w / m


proc xyz*(q: XQuat): XVec3 =
  result.x = q.x
  result.y = q.y
  result.z = q.z


proc `xyz=`*(q: var XQuat, v: XVec3) =
  q.x = v.x
  q.y = v.y
  q.z = v.z


proc `*`*(a, b: XQuat): XQuat =
  ## Multiply the xquaternion by a xquaternion
  #[
  var q = xquat(0,0,0,0)
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

proc `*`*(q: XQuat, v: fix16): XQuat =
  ## Multiply the xquaternion by a fix16
  result.x = q.x * v
  result.y = q.y * v
  result.z = q.z * v
  result.w = q.w * v


proc `*`*(q: XQuat, v: XVec3): XVec3 =
  ## Multiply the xquaternion by a vector
  var
    x = v.x
    y = v.y
    z = v.z

    qx = q.x
    qy = q.y
    qz = q.z
    qw = q.w

    ix =  qw * x + qy * z - qz * y
    iy =  qw * y + qz * x - qx * z
    iz =  qw * z + qx * y - qy * x
    iw = -qx * x - qy * y - qz * z

  result.x = ix * qw + iw * -qx + iy * -qz - iz * -qy
  result.y = iy * qw + iw * -qy + iz * -qx - ix * -qz
  result.z = iz * qw + iw * -qz + ix * -qy - iy * -qx


proc xmat3*(q: XQuat): XMat3 =
  var xx     = q.x * q.x
  var xy     = q.x * q.y
  var xz     = q.x * q.z
  var xw     = q.x * q.w

  var yy     = q.y * q.y
  var yz     = q.y * q.z
  var yw     = q.y * q.w

  var zz     = q.z * q.z
  var zw     = q.z * q.w

  result[0]  = 1.fix16 - 2.fix16 * ( yy + zz )
  result[1]  =           2.fix16 * ( xy - zw )
  result[2]  =           2.fix16 * ( xz + yw )

  result[3]  =           2.fix16 * ( xy + zw )
  result[4]  = 1.fix16 - 2.fix16 * ( xx + zz )
  result[5]  =           2.fix16 * ( yz - xw )

  result[6]  =           2.fix16 * ( xz - yw )
  result[7]  =           2.fix16 * ( yz + xw )
  result[8]  = 1.fix16 - 2.fix16 * ( xx + yy )



proc xmat4*(q: XQuat): XMat4 =
  var xx     = q.x * q.x
  var xy     = q.x * q.y
  var xz     = q.x * q.z
  var xw     = q.x * q.w

  var yy     = q.y * q.y
  var yz     = q.y * q.z
  var yw     = q.y * q.w

  var zz     = q.z * q.z
  var zw     = q.z * q.w

  result[0]  = 1.fix16 - 2.fix16 * ( yy + zz )
  result[1]  =           2.fix16 * ( xy - zw )
  result[2]  =           2.fix16 * ( xz + yw )

  result[4]  =           2.fix16 * ( xy + zw )
  result[5]  = 1.fix16 - 2.fix16 * ( xx + zz )
  result[6]  =           2.fix16 * ( yz - xw )

  result[8]  =           2.fix16 * ( xz - yw )
  result[9]  =           2.fix16 * ( yz + xw )
  result[10] = 1.fix16 - 2.fix16 * ( xx + yy )

  result[3]  = 0
  result[7]  = 0
  result[11] = 0
  result[12] = 0
  result[13] = 0
  result[14] = 0
  result[15] = 1.0


proc reciprocalSqrt*(x: fix16): fix16 =
 return 1.fix16/sqrt(x)


proc xquat*(m: XMat4): XQuat =
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

  var q : XQuat
  var t : fix16

  if m22 < 0.fix16:
    if m00 > m11:
      t = 1.fix16 + m00 - m11 - m22
      q = xquat(t, m01 + m10, m20 + m02, m12 - m21)
    else:
      t = 1.fix16 - m00 + m11 - m22
      q = xquat(m01 + m10, t, m12 + m21, m20 - m02)
  else:
    if m00 < - m11:
      t = 1.fix16 - m00 - m11 + m22
      q = xquat(m20 + m02, m12 + m21, t, m01 - m10)
    else:
      t = 1.fix16 + m00 + m11 + m22
      q = xquat(m12 - m21, m20 - m02, m01 - m10, t)
  q = q * (0.5.fix16 / sqrt(t))

  assert abs(q.length - 1.fix16) < 0.001.fix16
  return q


proc fromAxisAngle*(axis: XVec3, angle: fix16): XQuat =
  var a = axis.normalize()
  var s = sin(angle / 2.fix16)
  result.x = a.x * s
  result.y = a.y * s
  result.z = a.z * s
  result.w = cos(angle / 2.fix16)


proc toAxisAngle*(q: XQuat, axis: var XVec3, angle: var fix16) =
  var cosAngle = q.w
  angle = arccos(cosAngle) * 2.fix16
  var sinAngle = sqrt(1.fix16 - cosAngle * cosAngle)

  if abs(sinAngle) < 0.0005.fix16:
    sinAngle = 1.fix16

  axis.x = q.x / sinAngle
  axis.y = q.y / sinAngle
  axis.z = q.z / sinAngle


proc xquat*(heading, pitch, roll: fix16): XQuat =
  var t0 = cos(heading * 0.5.fix16)
  var t1 = sin(heading * 0.5.fix16)
  var t2 = cos(roll * 0.5.fix16)
  var t3 = sin(roll * 0.5.fix16)
  var t4 = cos(pitch * 0.5.fix16)
  var t5 = sin(pitch * 0.5.fix16)
  result.w = t0 * t2 * t4 + t1 * t3 * t5
  result.x = t0 * t3 * t4 - t1 * t2 * t5
  result.y = t0 * t2 * t5 + t1 * t3 * t4
  result.z = t1 * t2 * t4 - t0 * t3 * t5


proc hrp*(q: XQuat): XVec3 =
  var ysqr = q.y * q.y
  # roll
  var t0 = +2.fix16 * (q.w * q.x + q.y * q.z)
  var t1 = +1.fix16 - 2.fix16 * (q.x * q.x + ysqr)
  result.z = arctan2(t0, t1)
  # pitch
  var t2 = +2.fix16 * (q.w * q.y - q.z * q.x)
  if t2 > 1.0:
    t2 = 1.0
  if t2 < -1.fix16:
    t2 = -1.0
  result.y = arcsin(t2)
  # heading
  var t3 = +2.fix16 * (q.w * q.z + q.x * q.y)
  var t4 = +1.fix16 - 2.fix16 * (ysqr + q.z * q.z)
  result.x = arctan2(t3, t4)


proc `$`*(a: XQuat): string =
  return "q(" &
    a.x.formatFloat(ffDecimal,8) & ", " &
    a.y.formatFloat(ffDecimal,8) & ", " &
    a.z.formatFloat(ffDecimal,8) & ", " &
    a.w.formatFloat(ffDecimal,8) & ")"


proc rotate*(angle: fix16, axis: XVec3): XMat4 =
  fromAxisAngle(axis, angle).xmat4()


proc rotateX*(angle: fix16): XMat4 =
  return rotate(angle, xvec3(1, 0, 0))


proc rotateY*(angle: fix16): XMat4 =
  return rotate(angle, xvec3(0, 1, 0))


proc rotateZ*(angle: fix16): XMat4 =
  return rotate(angle, xvec3(0, 0, 1))


proc scaleMat*(scale: XVec3): XMat4 =
  result[0] = scale.x
  result[5] = scale.y
  result[10] = scale.z
  result[15] = 1.0


proc scaleMat*(scale: fix16): XMat4 =
  return scaleMat(xvec3(scale, scale, scale))


