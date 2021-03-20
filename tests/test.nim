import vmath, random

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

  when compiles( 1 ~= 1):
    doAssert false

block:
  # Test simple functions.
  doAssert between(0.5, 0, 1)
  doAssert not between(1.5, 0, 1)

  doAssert sign(-1.0) == -1.0
  doAssert sign(0.0) == 1.0
  doAssert sign(1.0) == 1.0

  doAssert quantize(1.23456789, 1.0) ~= 1
  doAssert quantize(1.23456789, 0.1) ~= 1.2
  doAssert quantize(1.23456789, 0.01) ~= 1.23

  doAssert lerp(0.0, 1.0, 0.5) ~= 0.5
  doAssert lerp(0.0, 10.0, 0.5) ~= 5.0
  doAssert lerp(0.0, 100.0, 0.5) ~= 50.0
  doAssert lerp(-1.0, 1.0, 0.25) ~= -0.5
  doAssert lerp(-10.0, 10.0, 0.25) ~= -5.0
  doAssert lerp(-100.0, 100.0, 0.25) ~= -50.0

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

block:
  # Test vec2 cast.
  var v = vec2(1.0, 2.0)
  var a = cast[array[2, float32]](v)
  doAssert a[0] ~= 1.0
  doAssert a[1] ~= 2.0

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

    _ = bvec2(true, false)
    _ = bvec3(true, false, true)
    _ = bvec4(true, false, true, false)

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

  # let swazzle = "xyzw"
  # for a in swazzle:
  #   echo a
  #   echo a & "="

  # for a in swazzle:
  #   for b in swazzle:
  #     echo a & b
  #     echo a & b & "="

  # for a in swazzle:
  #   for b in swazzle:
  #     for c in swazzle:
  #       echo a & b & c
  #       echo a & b & c & "="

  # for a in swazzle:
  #   for b in swazzle:
  #     for c in swazzle:
  #       for d in swazzle:
  #         echo a & b & c & d
  #         echo a & b & c & d & "="


block:
  # Test basic vector mat constructors.
  block:
    let
      m2 = mat2()
      m3 = mat3()
      m4 = mat4()

  block:
    let
      m2 = mat2(
        1, 0,
        0, 1
      )
      m3 = mat3(
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
      )
      m4 = mat4(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
      )

  block:
    let
      m2 = mat2(
        vec2(1, 0),
        vec2(0, 1)
      )
      m3 = mat3(
        vec3(1, 0, 0),
        vec3(0, 1, 0),
        vec3(0, 0, 1)
      )
      m4 = mat4(
        vec4(1, 0, 0, 0),
        vec4(0, 1, 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1)
      )

  block:
    let
      m2 = dmat2()
      m3 = dmat3()
      m4 = dmat4()

  block:
    let
      m2 = dmat2(
        1, 0,
        0, 1
      )
      m3 = dmat3(
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
      )
      m4 = dmat4(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
      )

  block:
    let
      m2 = dmat2(
        dvec2(1, 0),
        dvec2(0, 1)
      )
      m3 = dmat3(
        dvec3(1, 0, 0),
        dvec3(0, 1, 0),
        dvec3(0, 0, 1)
      )
      m4 = dmat4(
        dvec4(1, 0, 0, 0),
        dvec4(0, 1, 0, 0),
        dvec4(0, 0, 1, 0),
        dvec4(0, 0, 0, 1)
      )

  doAssert dmat3().transpose() ~= [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]

  doAssert dmat4() ~= [[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]]

  echo scale(dvec2(1, 2))
  echo scale(dvec3(2, 2, 3))
  echo translate(dvec2(1, 2))
  echo translate(dvec3(1, 2, 3))

  echo scale(vec2(1, 2))
  echo scale(vec3(2, 2, 3))
  echo translate(vec2(1, 2))
  echo translate(vec3(1, 2, 3))

  echo rotate(1.0)
  echo rotate(1.0.float32)


  # doAssert scale(dvec2(2)) ~= [[2.0, 2.0], [2.0, 2.0]]
  # doAssert scale(dvec3(2)) ~= [[2.0, 2.0, 2.0], [2.0, 2.0, 2.0], [0.0, 0.0, 1.0]]
  # doAssert translate(dvec2(2)) ~= [[2.0, 2.0, 2.0], [2.0, 2.0, 2.0], [0.0, 0.0, 1.0]]
  # doAssert translate(dvec3(2)) ~= [[2.0, 2.0, 2.0, 2.0], [2.0, 2.0, 2.0, 2.0], [2.0, 2.0, 2.0, 2.0], [0.0, 0.0, 0.0, 1.0]]


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
  echo m1
  echo m2
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
  for i in 0 .. 100:
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
  # Test matrix to quat test.
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

  doAssert a3 * b3 ~= mat3(
    1.0000, 0.0000, 0.0000,
    0.0000, 1.0000, 0.0000,
    50.0000, 50.0000, 1.0000
  )

  # doAssert (a3.mat4 * b3.mat4).mat3 ~= mat3(
  #   1.0000, 0.0000, 0.0000,
  #   0.0000, 1.0000, 0.0000,
  #   50.0000, 50.0000, 0.0000
  # )

#   doAssert (
#       mat3(1,2,3,4,5,6,7,8,9).mat4Rotation *
#       mat3(10,20,30,40,50,60,70,80,90).mat4Rotation
#     ).mat3Rotation ~= mat3(
#       300.0000, 360.0000, 420.0000,
#       660.0000, 810.0000, 960.0000,
#       1020.0000, 1260.0000, 1500.0000
#     )

  doAssert mat3(1,2,3,4,5,6,7,8,9) * mat3(10,20,30,40,50,60,70,80,90) ~= mat3(
    300.0000, 360.0000, 420.0000,
    660.0000, 810.0000, 960.0000,
    1020.0000, 1260.0000, 1500.0000
  )
#   doAssert a3.mat4 * vec3(77.64571380615234, 0, 1) ~= vec3(50.0, 50.0, 1.0)
  doAssert a3 * vec2(77.64571380615234, 0) ~= vec2(50.0, 50.0)
  #doAssert a3 * vec3(77.64571380615234, 0, 1.0) ~= vec3(50.0, 50.0, 1.0)

block:
  # hashing
  doAssert hash(vec2(PI, E)) == 1311648097060332001
  doAssert hash(vec3(PI, E, TAU)) == 5625953707464987239
  doAssert hash(vec4(PI, E, TAU, sqrt(2.0))) == -6538384897102876123
  doAssert hash(quat(1, 0, 0, sqrt(2.0))) == 1497919211694084820
  # doAssert hash( mat3(
  #   300.0000, 360.0000, 420.0000,
  #   660.0000, 810.0000, 960.0000,
  #   1020.0000, 1260.0000, 1500.0000
  # )) == -4194936143766837151
  # doAssert hash(mat4(
  #   1.00000, 0.00000, 0.00000, 0.00000,
  #   0.00000, 1.00000, 0.00000, 0.00000,
  #   0.00000, 0.00000, 1.00000, 0.00000,
  #   7.00000, 8.00000, 9.00000, 1.00000
  # )) == 7507518476139335223
