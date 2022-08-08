import random, vmath

randomize(1234)

block:
  # Test ~=.
  doAssert 1.0 ~= 1.0
  doAssert 0.0 ~= 0.0
  doAssert -1.0 ~= -1.0
  doAssert not(0.1 ~= 0.2)
  doAssert not(0.01 ~= 0.02)
  doAssert not(0.001 ~= 0.002)
  doAssert not(0.0001 ~= 0.0002)
  doAssert not(0.00001 ~= 0.00002)

  # Diff < epsilon.
  doAssert 0.000001 ~= 0.000002
  doAssert -0.000001 ~= -0.000002

  doAssert vec2(1.0, 2.0) ~= vec2(1.0, 2.0)
  doAssert vec3(1.0, 2.0, 3.0) ~= vec3(1.0, 2.0, 3.0)
  doAssert vec4(1.0, 2.0, 3.0, 4.0) ~= vec4(1.0, 2.0, 3.0, 4.0)
  doAssert quat(1.0, 2.0, 3.0, 4.0) ~= quat(1.0, 2.0, 3.0, 4.0)

  doAssert dvec2(1) ~= dvec2(1)
  doAssert dvec4(1, 2, 3, 4).xy ~= dvec2(1, 2)

  when compiles(1 ~= 1):
    doAssert false

block:
  # Test simple functions.
  doAssert between(0.5, 0, 1)
  doAssert not between(1.5, 0, 1)

  doAssert sign(-1.0) == -1.0
  doAssert sign(0.0) == 1.0
  doAssert sign(1.0) == 1.0

  block:
    proc quantize2(v, n: float32): float32 =
      ## Makes v be multiple of n. Rounding to integer quantize by 1.0.
      sign(v) * trunc(abs(v) / n) * n

    let n = 1.float32 / 10

    for _ in 0 ..< 10_000:
      let f = rand(-100.float32 .. 100.float32)
      doAssert quantize(f, n) == quantize2(f, n)

  doAssert quantize(1.23456789, 1.0) ~= 1
  doAssert quantize(1.23456789, 0.1) ~= 1.2
  doAssert quantize(1.23456789, 0.01) ~= 1.23
  doAssert quantize(-1.23456789, 0.01) ~= -1.23

  doAssert fractional(0.0) ~= 0.0
  doAssert fractional(3.14) ~= 0.14
  doAssert fractional(-3.14) ~= 0.14
  doAssert fractional(1.23456789) ~= 0.23456789
  doAssert fractional(-1.23456789) ~= 0.23456789

  doAssert lerp(0.0, 1.0, 0.5) ~= 0.5
  doAssert lerp(0.0, 10.0, 0.5) ~= 5.0
  doAssert lerp(0.0, 100.0, 0.5) ~= 50.0
  doAssert lerp(-1.0, 1.0, 0.25) ~= -0.5
  doAssert lerp(-10.0, 10.0, 0.25) ~= -5.0
  doAssert lerp(-100.0, 100.0, 0.25) ~= -50.0

  doAssert mix(0.0, 1.0, 0.5) ~= 0.5
  doAssert mix(0.0, 10.0, 0.5) ~= 5.0
  doAssert mix(0.0, 100.0, 0.5) ~= 50.0
  doAssert mix(-1.0, 1.0, 0.25) ~= -0.5
  doAssert mix(-10.0, 10.0, 0.25) ~= -5.0
  doAssert mix(-100.0, 100.0, 0.25) ~= -50.0

  doAssert fixAngle(0.1) ~= 0.1
  doAssert fixAngle(1.1) ~= 1.1
  doAssert fixAngle(2.1) ~= 2.1
  doAssert fixAngle(3.1) ~= 3.1
  doAssert fixAngle(4.1) ~= -2.183185577392578
  doAssert fixAngle(-0.1) ~= -0.1
  doAssert fixAngle(-1.1) ~= -1.1
  doAssert fixAngle(-2.1) ~= -2.1
  doAssert fixAngle(-3.1) ~= -3.1
  doAssert fixAngle(-4.1) ~= 2.183185577392578

  doAssert angleBetween(0.0, 1.0) ~= 1.0
  doAssert angleBetween(0.0, PI) ~= PI
  doAssert angleBetween(0.0, PI + 0.2) ~= (-PI + 0.2)
  doAssert angleBetween(0.1, 0.2) ~= 0.1
  doAssert angleBetween(0.1, 0.2 + PI*2) ~= 0.1
  doAssert angleBetween(0.1, 0.2 - PI*2) ~= 0.1
  doAssert angleBetween(0.1 + PI*2, 0.2) ~= 0.1
  doAssert angleBetween(0.1 - PI*2, 0.2) ~= 0.1
  doAssert angleBetween(0.2, 0.1) ~= -0.1
  doAssert angleBetween(0.2, 0.1 - PI*2) ~= -0.1
  doAssert angleBetween(0.2, 0.1 + PI*2) ~= -0.1
  doAssert angleBetween(0.2 + PI*2, 0.1) ~= -0.1
  doAssert angleBetween(0.2 - PI*2, 0.1) ~= -0.1

  doAssert turnAngle(0.0, PI, 0.5) ~= 0.5
  doAssert turnAngle(0.5, PI, 3.5) ~= PI

  proc isNaNSlow(f: SomeFloat): bool =
    ## Returns true if number is a NaN.
    f.classify notin {fcNormal, fcZero, fcSubnormal}

  doAssert isNaNSlow(0.3) == false
  doAssert isNaNSlow(0.0) == false
  doAssert isNaNSlow(0.3/0.0) == true
  doAssert isNaNSlow(-0.3/0.0) == true
  doAssert isNaNSlow(5.0e-324) == false

  doAssert isNan(float32(0.3)) == false
  doAssert isNan(float32(0.0)) == false
  doAssert isNan(float32(0.3/0.0)) == true
  doAssert isNan(float32(-0.3/0.0)) == true
  doAssert isNan(float32(5.0e-324)) == false

  doAssert isNan(float64(0.3)) == false
  doAssert isNan(float64(0.0)) == false
  doAssert isNan(float64(0.3/0.0)) == true
  doAssert isNan(float64(-0.3/0.0)) == true
  doAssert isNan(float64(5.0e-324)) == false

block:
  when not defined(js):
    # Test vec2 cast.
    var v = vec2(1.0, 2.0)
    var a = cast[array[2, float32]](v)
    doAssert a[0] ~= 1.0
    doAssert a[1] ~= 2.0

block:
  # Test position assignment
  var
    v2 = vec2(0)
    v3 = vec3(0)
    v4 = vec4(0)
  v2[0] = 1.0
  v2[1] = 2.0
  doAssert v2 ~= vec2(1, 2)
  v3[0] = 1.0
  v3[1] = 2.0
  v3[2] = 3.0
  doAssert v3 ~= vec3(1, 2, 3)
  v4[0] = 1.0
  v4[1] = 2.0
  v4[2] = 3.0
  v4[3] = 4.0
  doAssert v4 ~= vec4(1, 2, 3, 4)

block:
  # Test vec2 constructor.
  doAssert vec2(PI, PI) ~= vec2(PI)

block:
  # Test basic vector vec2.
  var a = vec2(1, 2)
  var b = vec2(7, 6)
  var n = 13.7
  doAssert a + b ~= vec2(8.0, 8.0)
  doAssert a - b ~= vec2(-6.0, -4.0)
  doAssert a * n ~= vec2(13.7, 27.4)
  doAssert a / n ~= vec2(0.0729927, 0.1459854)
  a += b
  doAssert a ~= vec2(8.0, 8.0)
  a -= b
  doAssert a ~= vec2(1.0, 2.0)
  a *= n
  doAssert a ~= vec2(13.7, 27.4)
  a /= n
  doAssert a ~= vec2(1.0, 2.0)

block:
  # Test basic vector vec3.
  var a = vec3(1, 2, 3)
  var b = vec3(7, 6, 5)
  var n = 13.7
  doAssert a + b ~= vec3(8.0, 8.0, 8.0)
  doAssert a - b ~= vec3(-6.0, -4.0, -2.0)
  doAssert a * n ~= vec3(13.69999981, 27.39999962, 41.09999847)
  doAssert a / n ~= vec3(0.07299270, 0.14598541, 0.21897811)
  a += b
  doAssert a ~= vec3(8.0, 8.0, 8.0)
  a -= b
  doAssert a ~= vec3(1.0, 2.0, 3.0)
  a *= n
  doAssert a ~= vec3(13.69999981, 27.39999962, 41.09999847)
  a /= n
  doAssert a ~= vec3(1.0, 2.0, 3.0)

block:
  # Test basic vector vec4.
  var a = vec4(1, 2, 3, 4)
  var b = vec4(7, 6, 5, 4)
  var n = 13.7
  doAssert a + b ~= vec4(8.0, 8.0, 8.0, 8.0)
  doAssert a - b ~= vec4(-6.0, -4.0, -2.0, 0.0)
  doAssert a * n ~= vec4(13.69999981, 27.39999962, 41.09999847, 54.79999924)
  doAssert a / n ~= vec4(0.07299270, 0.14598541, 0.21897811, 0.29197082)
  a += b
  doAssert a ~= vec4(8.0, 8.0, 8.0, 8.0)
  a -= b
  doAssert a ~= vec4(1.0, 2.0, 3.0, 4.0)
  a *= n
  doAssert a ~= vec4(13.69999981, 27.39999962, 41.09999847, 54.79999924)
  a /= n
  doAssert a ~= vec4(1.0, 2.0, 3.0, 4.0)

block:
  # Test all type constructors compile
  let
    _ = bvec2(true, false)
    _ = bvec3(true, false, true)
    _ = bvec4(true, false, true, false)

    _ = ivec2(-1, 2)
    _ = ivec3(-1, 2, 3)
    _ = ivec4(-1, 2, 3, 4)

    _ = uvec2(1, 2)
    _ = uvec3(1, 2, 3)
    _ = uvec4(1, 2, 3, 4)

    _ = vec2(1.0, 2.0)
    _ = vec3(1.0, 2.0, 3.0)
    _ = vec4(1.0, 2.0, 3.0, 4.0)

    _ = dvec2(1.0, 2.0)
    _ = dvec3(1.0, 2.0, 3.0)
    _ = dvec4(1.0, 2.0, 3.0, 4.0)

    _ = bvec2(true)
    _ = bvec3(true)
    _ = bvec4(true)

    _ = ivec2(-1)
    _ = ivec3(-1)
    _ = ivec4(-1)

    _ = uvec2(1)
    _ = uvec3(1)
    _ = uvec4(1)

    _ = vec2(1.0)
    _ = vec3(1.0)
    _ = vec4(1.0)

    _ = dvec2(1.0)
    _ = dvec3(1.0)
    _ = dvec4(1.0)

    _ = bvec2()
    _ = bvec3()
    _ = bvec4()

    _ = ivec2()
    _ = ivec3()
    _ = ivec4()

    _ = uvec2()
    _ = uvec3()
    _ = uvec4()

    _ = vec2()
    _ = vec3()
    _ = vec4()

    _ = dvec2()
    _ = dvec3()
    _ = dvec4()

  var a = vec3(vec2(1, 2), 3)
  doAssert a == vec3(1, 2, 3)

  var b = vec4(vec3(1, 2, 3), 4)
  doAssert b == vec4(1, 2, 3, 4)

  var c = vec4(vec2(1, 2), vec2(3, 4))
  doAssert c == vec4(1, 2, 3, 4)

block:
  # test $ string functions
  doAssert $bvec2(true, false) == "bvec2(true, false)"
  doAssert $bvec3(true, false, true) == "bvec3(true, false, true)"
  doAssert $bvec4(true, false, true, false) == "bvec4(true, false, true, false)"

  doAssert $ivec2(1, 2) == "ivec2(1, 2)"
  doAssert $ivec3(1, 2, 3) == "ivec3(1, 2, 3)"
  doAssert $ivec4(1, 2, 3, 4) == "ivec4(1, 2, 3, 4)"

  doAssert $uvec2(1, 2) == "uvec2(1, 2)"
  doAssert $uvec3(1, 2, 3) == "uvec3(1, 2, 3)"
  doAssert $uvec4(1, 2, 3, 4) == "uvec4(1, 2, 3, 4)"

  doAssert $vec2(1.0, 2.0) == "vec2(1.0, 2.0)"
  doAssert $vec3(1.0, 2.0, 3.0) == "vec3(1.0, 2.0, 3.0)"
  doAssert $vec4(1.0, 2.0, 3.0, 4.0) == "vec4(1.0, 2.0, 3.0, 4.0)"

  doAssert $dvec2(1.0, 2.0) == "dvec2(1.0, 2.0)"
  doAssert $dvec3(1.0, 2.0, 3.0) == "dvec3(1.0, 2.0, 3.0)"
  doAssert $dvec4(1.0, 2.0, 3.0, 4.0) == "dvec4(1.0, 2.0, 3.0, 4.0)"

block:
  # test swizzle vec
  var a = vec2(1, 2)
  doAssert a.x == 1.0
  doAssert a.y == 2.0
  doAssert a.yx == vec2(2, 1)
  doAssert a.gr == vec2(2, 1)
  doAssert a.ts == vec2(2, 1)
  doAssert a.xxx == vec3(1, 1, 1)

  a.yx = vec2(-1, -2)
  doAssert a == vec2(-2, -1)

  a.xx = vec2(-7, -3)
  doAssert a == vec2(-3, -1)

  when compiles(a.xyzxyz):
    doAssert false

  when compiles(a.z = 123):
    doAssert false

  var b = vec4(1, 2, 3, 4)
  doAssert b == vec4(1, 2, 3, 4)
  b.wzyx = b
  doAssert b == vec4(4, 3, 2, 1)

  b.g = 123
  doAssert b == vec4(4.0, 123.0, 2.0, 1.0)

block:
  # test swizzle dvec float64
  var a = dvec2(1, 2)
  doAssert a.x == 1.0
  doAssert a.y == 2.0
  doAssert a.yx == dvec2(2, 1)
  doAssert a.gr == dvec2(2, 1)
  doAssert a.ts == dvec2(2, 1)
  doAssert a.xxx == dvec3(1, 1, 1)

  a.yx = dvec2(-1, -2)
  doAssert a == dvec2(-2, -1)

  a.xx = dvec2(-7, -3)
  doAssert a == dvec2(-3, -1)

  when compiles(a.xyzxyz):
    doAssert false

  when compiles(a.z = 123):
    doAssert false

  var b = dvec4(1, 2, 3, 4)
  doAssert b == dvec4(1, 2, 3, 4)

  b.g = 123
  doAssert b == dvec4(1.0, 123.0, 3.0, 4.0)

block:
  # test swizzle self-assignment
  var a = dvec2(1, 2)
  a.yx = a
  doAssert a == dvec2(2, 1)

  var b = dvec3(1, 2, 3)
  b.zyx = b
  doAssert b == dvec3(3, 2, 1)

  var c = dvec4(1, 2, 3, 4)
  c.wzyx = c
  doAssert c == dvec4(4, 3, 2, 1)

block:
  # Test swizzle calls only once
  var callCount = 0
  proc countsCalls(): Vec2 =
    inc callCount

  doAssert countsCalls().yx == vec2(0, 0)
  doAssert callCount == 1

  callCount = 0
  doAssert vec2(0, 0) == countsCalls().yx
  doAssert callCount == 1

  var tmp: Vec2
  proc countsCalls2(): var Vec2 =
    inc callCount
    return tmp

  callCount = 0
  countsCalls2().yx = vec2(0, 0)
  doAssert callCount == 1

block:
  # Test swizzle with complex expressions
  var a = [
    vec2(1, 2),
    vec2(3, 4),
    vec2(5, 6),
    vec2(7, 8),
  ]
  var i = 0
  proc f(): var Vec2 =
    # function with side effects
    result = a[i]
    inc i

  doAssert f().yx == vec2(2, 1)
  doAssert f().gr == vec2(4, 3)
  doAssert f().ts == vec2(6, 5)
  doAssert f().yx == vec2(8, 7)
  doAssert i == 4

  i = 0
  f().yx = f()
  doAssert a[0] == vec2(4, 3)
  doAssert a[1] == vec2(3, 4)
  doAssert i == 2

  var b = [
    vec3(1, 2, 3),
    vec3(4, 5, 6),
    vec3(7, 8, 9),
  ]
  i = 0
  proc g(): var Vec3 =
    # function with side effects
    result = b[i]
    inc i

  doAssert g().yxz == vec3(2, 1, 3)
  doAssert g().bgr == vec3(6, 5, 4)
  doAssert g().tps == vec3(8, 9, 7)
  doAssert i == 3

  i = 0
  g().yxz = g()
  doAssert b[0] == vec3(5, 4, 6)
  doAssert b[1] == vec3(4, 5, 6)
  doAssert i == 2

  var c = [
    vec4(1, 2, 3, 4),
    vec4(5, 6, 7, 8),
  ]
  i = 0
  proc h(): var Vec4 =
    # function with side effects
    result = c[i]
    inc i

  doAssert h().yxzw == vec4(2, 1, 3, 4)
  doAssert h().tqsp == vec4(6, 8, 5, 7)
  doAssert i == 2

  i = 0
  h().wzyx = h()
  doAssert c[0] == vec4(8, 7, 6, 5)
  doAssert c[1] == vec4(5, 6, 7, 8)
  doAssert i == 2


block:
  # Test basic mat constructors.
  block:
    let
      _ = mat2()
      _ = mat3()
      _ = mat4()

  block:
    let
      _ = mat2(
        1, 0,
        0, 1
      )
      _ = mat3(
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
      )
      _ = mat4(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
      )

  block:
    # test $ string functions
    doAssert $mat2(
      1, 3,
      0, 1
    ) == """mat2(
  1.0, 3.0,
  0.0, 1.0
)"""
    doAssert $mat3(
      1, 3, 0,
      0, 1, 0,
      0, 3, 1
    ) == """mat3(
  1.0, 3.0, 0.0,
  0.0, 1.0, 0.0,
  0.0, 3.0, 1.0
)"""
    doAssert $mat4(
      1, 3, 0, 0,
      0, 1, 0, 0,
      0, 3, 1, 0,
      0, 3, 0, 1
    ) == """mat4(
  1.0, 3.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0,
  0.0, 3.0, 1.0, 0.0,
  0.0, 3.0, 0.0, 1.0
)"""
    doAssert $dmat2(
      1, 0,
      4, 1
    ) == """dmat2(
  1.0, 0.0,
  4.0, 1.0
)"""
    doAssert $dmat3(
      1, 0, 0,
      4, 1, 0,
      4, 0, 1
    ) == """dmat3(
  1.0, 0.0, 0.0,
  4.0, 1.0, 0.0,
  4.0, 0.0, 1.0
)"""
    doAssert $dmat4(
      1, 0, 0, 0,
      4, 1, 0, 0,
      4, 0, 1, 0,
      4, 0, 0, 1
    ) == """dmat4(
  1.0, 0.0, 0.0, 0.0,
  4.0, 1.0, 0.0, 0.0,
  4.0, 0.0, 1.0, 0.0,
  4.0, 0.0, 0.0, 1.0
)"""

  block:
    let
      _ = mat2(
        vec2(1, 0),
        vec2(0, 1)
      )
      _ = mat3(
        vec3(1, 0, 0),
        vec3(0, 1, 0),
        vec3(0, 0, 1)
      )
      _ = mat4(
        vec4(1, 0, 0, 0),
        vec4(0, 1, 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1)
      )

  block:
    let
      _ = dmat2()
      _ = dmat3()
      _ = dmat4()

  block:
    let
      _ = dmat2(
        1, 0,
        0, 1
      )
      _ = dmat3(
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
      )
      _ = dmat4(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
      )

  block:
    let
      _ = dmat2(
        dvec2(1, 0),
        dvec2(0, 1)
      )
      _ = dmat3(
        dvec3(1, 0, 0),
        dvec3(0, 1, 0),
        dvec3(0, 0, 1)
      )
      _ = dmat4(
        dvec4(1, 0, 0, 0),
        dvec4(0, 1, 0, 0),
        dvec4(0, 0, 1, 0),
        dvec4(0, 0, 0, 1)
      )

  block:
    var
      d2 = dmat2()
      d3 = dmat3()
      d4 = dmat4()

    d2[0, 0] = 123.123
    d2[1, 1] = 123.123

    d3[0, 0] = 123.123
    d3[1, 1] = 123.123
    d3[2, 2] = 123.123

    d4[0, 0] = 123.123
    d4[1, 1] = 123.123
    d4[2, 2] = 123.123
    d4[3, 3] = 123.123

block:
  # Test basic mat functions.
  doAssert dmat3().transpose() ~= dmat3(
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    0.0, 0.0, 1.0
  )
  doAssert dmat4().transpose() ~= dmat4(
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0
  )

  doAssert scale(dvec2(1, 2)) ~= dmat3(
    1.0, 0.0, 0.0,
    0.0, 2.0, 0.0,
    0.0, 0.0, 1.0
  )
  doAssert scale(dvec3(2, 2, 3)) ~= dmat4(
    2.0, 0.0, 0.0, 0.0,
    0.0, 2.0, 0.0, 0.0,
    0.0, 0.0, 3.0, 0.0,
    0.0, 0.0, 0.0, 1.0
  )

  doAssert translate(dvec2(1, 2)) ~= dmat3(
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    1.0, 2.0, 1.0
  )
  doAssert translate(dvec3(1, 2, 3)) ~= dmat4(
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    1.0, 2.0, 3.0, 1.0
  )

  doAssert rotate(1.0) ~= dmat3(
    0.5403023058681398, -0.8414709848078965, 0.0,
    0.8414709848078965, 0.5403023058681398, 0.0,
    0.0, 0.0, 1.0
  )

  doAssert scale(dvec2(2)) ~= dmat3(
    2.0, 0.0, 0.0,
    0.0, 2.0, 0.0,
    0.0, 0.0, 1.0
  )
  doAssert scale(dvec3(2)) ~= dmat4(
    2.0, 0.0, 0.0, 0.0,
    0.0, 2.0, 0.0, 0.0,
    0.0, 0.0, 2.0, 0.0,
    0.0, 0.0, 0.0, 1.0
  )

  doAssert translate(dvec2(2)) ~= dmat3(
    1.0, 0.0, 0.0,
    0.0, 1.0, 0.0,
    2.0, 2.0, 1.0
  )
  doAssert translate(dvec3(2)) ~= dmat4(
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    2.0, 2.0, 2.0, 1.0
  )

  doAssert rotate(1.0).inverse() ~= dmat3(
    0.5403023058681398, 0.8414709848078965, -0.0,
    -0.8414709848078965, 0.5403023058681398, -0.0,
    0.0, -0.0, 1.0
  )
  doAssert rotate(1.0, dvec3(1, 0, 0)).inverse() ~= dmat4(
    1.0, 0.0, 0.0, 0.0,
    -0.0, 0.5403022766113281, 0.8414710164070129, 0.0,
    0.0, -0.8414710164070129, 0.5403022766113281, 0.0,
    0.0, 0.0, 0.0, 1.0
  )


  block:
    doAssert translate(vec2(1, 2)).pos == vec2(1, 2)

    var translation = translate(vec2(1, 2))
    translation.pos = vec2(3, 4)
    doAssert translation.pos == vec2(3, 4)

  block:
    doAssert translate(vec3(1, 2, 3)).pos == vec3(1, 2, 3)

    var translation = translate(vec3(1, 2, 3))
    translation.pos = vec3(3, 4, 5)
    doAssert translation.pos == vec3(3, 4, 5)

block:
  # Test basic vector mat4 and quat.
  var m1 = mat4(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1)
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m2 ~= mat4(
    1.00000, 0.00000, 0.00000, 0.00000,
    0.00000, 1.00000, 0.00000, 0.00000,
    0.00000, 0.00000, 1.00000, 0.00000,
    0.00000, 0.00000, 0.00000, 1.00000
  )
  doAssert m1 ~= (m2)

block:
  # Test basic vector mat4 -1.
  var m1 = mat4(
    1, 0, 0, 0,
    0, 0, -1, 0,
    0, 1, 0, 0,
    0, 0, 0, 1)
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test Y 90.
  var m1 = rotate(PI/2, dvec3(0, 1, 0))
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test -Y 90.
  var m1 = rotate(PI/2, dvec3(0, -1, 0))
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test X 90.
  var m1 = rotate(PI/2, dvec3(1, 0, 0))
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test Y 90.
  var m1 = rotate(PI/2, dvec3(1, 0, 0))
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test 1,1,1 1.11rad.
  var m1 = rotate(PI*1.11, dvec3(1, 1, 1).normalize())
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test 1,1,1 1.11rad.
  var m1 = rotate(PI*1.11, dvec3(-1, 1, 1).normalize())
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test 1,1,1 1.11rad.
  var m1 = rotate(PI*1.11, dvec3(-1, 0.34, 1.123).normalize())
  var q1 = m1.quat()
  var m2 = q1.mat4()
  doAssert m1 ~= m2

block:
  # Test super random quat test.
  for i in 0 ..< 1000:
    var m1 = rotate(
      PI*rand(2.0),
      dvec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
    )
    var q1 = m1.quat()
    var m2 = q1.mat4()
    doAssert m1 ~= m2

block:
  # Test *=1 /=1 don't change anything.
  var v2 = vec2(0, 0)
  v2 *= 1
  v2 /= 1
  doAssert v2 == vec2(0, 0)

  var v3 = vec3(0, 0, 0)
  v3 *= 1
  v3 /= 1
  doAssert v3 == vec3(0, 0, 0)

  var v4 = vec4(0, 0, 0, 0)
  v4 *= 1
  v4 /= 1
  doAssert v4 == vec4(0, 0, 0, 0)

  var q = quat(0, 0, 0, 0)
  q *= 1
  q /= 1
  doAssert q == quat(0, 0, 0, 0)

block:
  # Test matrix and vector multiplication.
  var a3 = mat3(
    0.9659258723258972, -0.258819043636322, 0.0,
    0.258819043636322, 0.9659258723258972, 0.0,
    -25.00000953674316, 70.09619140625, 1.0
  )
  var b3 = mat3(
    0.9659258127212524, 0.258819043636322, 0.0,
    -0.258819043636322, 0.9659258127212524, 0.0,
    77.64571380615234, 0.0, 1.0
  )

  when not defined(js):
    # TODO: Figure out why we loose soo much precision in js.

    doAssert a3 * b3 ~= mat3(
      1.0000, 0.0000, 0.0000,
      0.0000, 1.0000, 0.0000,
      50.0000, 50.0000, 1.0000
    )

    doAssert a3 * vec2(77.64571380615234, 0) ~= vec2(50.0, 50.0)

  doAssert mat3(1, 2, 3, 4, 5, 6, 7, 8, 9) *
    mat3(10, 20, 30, 40, 50, 60, 70, 80, 90) ~= mat3(
      300.0000, 360.0000, 420.0000,
      660.0000, 810.0000, 960.0000,
      1020.0000, 1260.0000, 1500.0000
    )

block:
  # test quat and matrix lookat
  doAssert lookAt(vec3(1, 2, 3), vec3(0, 0, 0)).quat ~=
    quat(
      0.07232953608036041,
      0.3063928484916687,
      0.9237624406814575,
      0.2180707305669785
    )
  doAssert lookAt(vec3(0, 0, 0), vec3(0, 0, 0)).quat ~= quat(0.0, 0.0, 0.0, 1.0)
  doAssert lookAt(vec3(1, 0, 0), vec3(0, 0, 0)).quat ~= quat(0.5, 0.5, 0.5, 0.5)
  doAssert lookAt(vec3(0, 1, 0), vec3(0, 0, 0)).quat ~=
    quat(
      0.0,
      0.7071067690849304,
      0.7071067690849304,
      0.0
    )
  doAssert lookAt(vec3(0, 0, 1), vec3(0, 0, 0)).quat ~= quat(0.0, 0.0, 0.0, 1.0)

  doAssert ortho[float32](-1, 1, 1, -1, -1000, 1000) ~= mat4(
    1.0, 0.0, 0.0, 0.0,
    0.0, -1.0, 0.0, 0.0,
    0.0, 0.0, -0.001000000047497451,
    0.0, -0.0, 0.0, -0.0, 1.0
  )

  doAssert perspective[float32](75, 1.666, 1, 1000) ~= mat4(
    0.7822480201721191, 0.0, 0.0, 0.0,
    0.0, 1.30322527885437, 0.0, 0.0,
    0.0, 0.0, -1.002002000808716, -1.0,
    0.0, 0.0, -2.002002000808716, 0.0
  )

  # Test super random quat test.
  for i in 0 ..< 1000:
    var m1 = rotate(
      PI*rand(2.0),
      dvec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
    )
    var q1 = m1.quat()
    var m2 = q1.mat4()
    doAssert m1 ~= m2

block:
  # test fromTwoVectors
  let
    a = vec3(1, 0, 0)
    b = vec3(0, 1, 0)
    q1 = fromTwoVectors(a, b)
  doAssert q1.mat4 * a ~= b

  for i in 0 ..< 1000:
    let
      a = vec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
      b = vec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
      q = fromTwoVectors(a, b)
    doAssert dist(q.mat4 * a, b) < 1E5

block:
  let mat2d = translate(vec2(10, 20)) * rotate(45.toRadians) * scale(vec2(2))

  let mat3d = translate(vec3(10, 20, 0)) * rotateZ(45.toRadians) * scale(vec3(2))

  doAssert mat2d ~= mat3(
    1.414213538169861, -1.414213538169861, 0.0,
    1.414213538169861, 1.414213538169861, 0.0,
    10.0, 20.0, 1.0
  )

  doAssert mat3d ~= mat4(
    1.414213418960571, -1.41421365737915, 0.0, 0.0,
    1.41421365737915, 1.414213418960571, 0.0, 0.0,
    0.0, 0.0, 2.0, 0.0,
    10.0, 20.0, 0.0, 1.0
  )

block:
  let
    a2 = vec2(10, -10)
    b2 = vec2(-10, 10)
    a3 = vec3(10, -10, 7)
    b3 = vec3(-10, 10, 0)
    a4 = vec4(10, -10, 7, -2)
    b4 = vec4(-10, 10, 0, -1)

  doAssert min(a2, b2) == vec2(-10, -10)
  doAssert min(a3, b3) == vec3(-10, -10, 0)
  doAssert min(a4, b4) == vec4(-10, -10, 0, -2)

  doAssert max(a2, b2) == vec2(10, 10)
  doAssert max(a3, b3) == vec3(10, 10, 7)
  doAssert max(a4, b4) == vec4(10, 10, 7, -1)

  doAssert mix(10f, 7, 0.75) == 7.75
  doAssert mix(a2, b2, 0.75) == vec2(-5.0, 5.0)
  doAssert mix(a3, b3, 0.75) == vec3(-5.0, 5.0, 1.75)
  doAssert mix(a4, b4, 0.75) == vec4(-5.0, 5.0, 1.75, -1.25)

  doAssert `mod`(1, 2) == 1
  doAssert `mod`(vec2(12, 6), vec2(6, 12)) == vec2(0, 6)
  doAssert `mod`(vec3(12, 6, 18), vec3(6, 12, 7)) == vec3(0, 6, 4)
  doAssert `mod`(vec4(12, 6, 18, 16), vec4(6, 12, 7, 15)) == vec4(0, 6, 4, 1)

  doAssert `zmod`(1, 2) == 1
  doAssert `zmod`(vec2(12, 6), vec2(6, 12)) == vec2(0, 6)
  doAssert `zmod`(vec3(12, 6, 18), vec3(6, 12, 7)) == vec3(0, 6, 4)
  doAssert `zmod`(vec4(12, 6, 18, 16), vec4(6, 12, 7, 15)) == vec4(0, 6, 4, 1)

block:
  doAssert vec2(1, 1) == vec2(1, 1)
  doAssert dvec2(2, 2) == dvec2(2, 2)
  doAssert bvec2(true, true) == bvec2(true, true)
  doAssert ivec2(3, 3) == ivec2(3, 3)
  doAssert uvec2(3, 3) == uvec2(3, 3)

  doAssert vec3(1, 1, 1) == vec3(1, 1, 1)
  doAssert dvec3(2, 2, 2) == dvec3(2, 2, 2)
  doAssert bvec3(true, true, true) == bvec3(true, true, true)
  doAssert ivec3(3, 3, 3) == ivec3(3, 3, 3)
  doAssert uvec3(3, 3, 3) == uvec3(3, 3, 3)

  doAssert vec4(1, 1, 1, 1) == vec4(1, 1, 1, 1)
  doAssert dvec4(2, 2, 2, 2) == dvec4(2, 2, 2, 2)
  doAssert bvec4(true, true, true, false) == bvec4(true, true, true, false)
  doAssert ivec4(3, 3, 3, 3) == ivec4(3, 3, 3, 3)
  doAssert uvec4(3, 3, 3, 3) == uvec4(3, 3, 3, 3)

  doAssert vec2(1, 1) != vec2(1, 2)
  doAssert dvec2(2, 2) != dvec2(2, 3)
  doAssert bvec2(true, true) != bvec2(true, false)
  doAssert ivec2(3, 3) != ivec2(3, 4)
  doAssert uvec2(3, 3) != uvec2(3, 4)

  doAssert vec3(1, 1, 1) != vec3(1, 1, 2)
  doAssert dvec3(2, 2, 2) != dvec3(2, 2, 3)
  doAssert bvec3(true, true, true) != bvec3(true, true, false)
  doAssert ivec3(3, 3, 3) != ivec3(3, 3, 4)
  doAssert uvec3(3, 3, 3) != uvec3(3, 3, 4)

  doAssert vec4(1, 1, 1, 1) != vec4(1, 1, 1, 2)
  doAssert dvec4(2, 2, 2, 2) != dvec4(2, 2, 2, 3)
  doAssert bvec4(true, true, true, false) != bvec4(true, true, true, true)
  doAssert ivec4(3, 3, 3, 3) != ivec4(3, 3, 3, 4)
  doAssert uvec4(3, 3, 3, 3) != uvec4(3, 3, 3, 4)

block:
  doAssert vec2(ivec2(1, 1)) == vec2(1, 1)
  doAssert vec2(uvec2(5, 5)) == vec2(5, 5)
  doAssert ivec2(uvec2(23, 23)) == ivec2(23, 23)
  doAssert uvec2(ivec2(12, 12)) == uvec2(12, 12)
  doAssert vec3(ivec3(1, 2, 3)) == vec3(1, 2, 3)
  doAssert vec3(uvec3(4, 5, 6)) == vec3(4, 5, 6)
  doAssert ivec3(uvec3(7, 8, 9)) == ivec3(7, 8, 9)
  doAssert uvec3(ivec3(10, 11, 12)) == uvec3(10, 11, 12)
  doAssert vec4(ivec4(13, 14, 15, 16)) == vec4(13, 14, 15, 16)
  doAssert vec4(uvec4(17, 18, 19, 20)) == vec4(17, 18, 19, 20)
  doAssert ivec4(uvec4(21, 22, 23, 24)) == ivec4(21, 22, 23, 24)
  doAssert uvec4(ivec4(25, 26, 27, 28)) == uvec4(25, 26, 27, 28)

block:
  # Test for https://github.com/treeform/vmath/issues/44
  doAssert PI.toDegrees() == 180
  doAssert (PI*2).toDegrees() == 360

block:
  # Test for https://github.com/treeform/vmath/issues/45
  block:
    let a = uvec2(10, 10)
    var b: UVec2
    when compiles(b = a / 2): doAssert false # type mismatch
    b = a div 2

  block:
    let a = vec2(10, 10)
    var b: Vec2
    b = a / 2
    when compiles(b = a div 2): doAssert false # type mismatch

echo "test finished successfully"
