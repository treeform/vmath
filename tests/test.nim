import
  std/[math, random, unittest],
  vmath

randomize(1234)

suite "approximate equality":
  test "float ~=":
    check 1.0 ~= 1.0
    check 0.0 ~= 0.0
    check -1.0 ~= -1.0
    check not(0.1 ~= 0.2)
    check not(0.01 ~= 0.02)
    check not(0.001 ~= 0.002)
    check not(0.0001 ~= 0.0002)
    check not(0.00001 ~= 0.00002)
    check 0.000001 ~= 0.000002
    check -0.000001 ~= -0.000002

  test "vec ~=":
    check vec2(1.0, 2.0) ~= vec2(1.0, 2.0)
    check vec3(1.0, 2.0, 3.0) ~= vec3(1.0, 2.0, 3.0)
    check vec4(1.0, 2.0, 3.0, 4.0) ~= vec4(1.0, 2.0, 3.0, 4.0)
    check quat(1.0, 2.0, 3.0, 4.0) ~= quat(1.0, 2.0, 3.0, 4.0)
    check dvec2(1) ~= dvec2(1)
    check dvec4(1, 2, 3, 4).xy ~= dvec2(1, 2)

  test "int ~= should not compile":
    check not compiles(1 ~= 1)

suite "scalar utilities":
  test "between":
    check between(0.5, 0, 1)
    check not between(1.5, 0, 1)

  test "sign":
    check sign(-1.0) == -1.0
    check sign(0.0) == 1.0
    check sign(1.0) == 1.0

  test "quantize":
    check quantize(1.23456789, 1.0) ~= 1
    check quantize(1.23456789, 0.1) ~= 1.2
    check quantize(1.23456789, 0.01) ~= 1.23
    check quantize(-1.23456789, 0.01) ~= -1.23

  test "fract":
    check fract(0.0) ~= 0.0
    check fract(3.14) ~= 0.14
    check fract(-3.14) ~= 0.14
    check fract(1.23456789) ~= 0.23456789

  test "mix":
    check mix(0.0, 1.0, 0.5) ~= 0.5
    check mix(0.0, 10.0, 0.5) ~= 5.0
    check mix(-1.0, 1.0, 0.25) ~= -0.5

  test "fixAngle":
    check fixAngle(0.1) ~= 0.1
    check fixAngle(3.1) ~= 3.1
    check fixAngle(4.1) ~= -2.183185577392578
    check fixAngle(-4.1) ~= 2.183185577392578

  test "angleBetween":
    check angleBetween(0.0, 1.0) ~= 1.0
    check angleBetween(0.0, PI) ~= PI
    check angleBetween(0.1, 0.2) ~= 0.1
    check angleBetween(0.1, 0.2 + PI*2) ~= 0.1
    check angleBetween(0.2, 0.1) ~= -0.1

  test "isNan":
    check vmath.isNan(float32(0.3)) == false
    check vmath.isNan(float32(0.0)) == false
    check vmath.isNan(float32(0.3/0.0)) == true
    check vmath.isNan(float64(0.3/0.0)) == true

suite "vector memory layout":
  test "vec2 cast to array":
    when not defined(js):
      let v = vec2(1.0, 2.0)
      let a = cast[array[2, float32]](v)
      check a[0] == 1.0f
      check a[1] == 2.0f

  test "vec3 cast to array":
    when not defined(js):
      let v = vec3(1.0, 2.0, 3.0)
      let a = cast[array[3, float32]](v)
      check a[0] == 1.0f
      check a[1] == 2.0f
      check a[2] == 3.0f

  test "vec4 cast to array":
    when not defined(js):
      let v = vec4(1.0, 2.0, 3.0, 4.0)
      let a = cast[array[4, float32]](v)
      check a[0] == 1.0f
      check a[1] == 2.0f
      check a[2] == 3.0f
      check a[3] == 4.0f

  test "vec component access matches array index":
    let v2 = vec2(10, 20)
    check v2.x == v2[0]
    check v2.y == v2[1]

    let v3 = vec3(10, 20, 30)
    check v3.x == v3[0]
    check v3.y == v3[1]
    check v3.z == v3[2]

    let v4 = vec4(10, 20, 30, 40)
    check v4.x == v4[0]
    check v4.y == v4[1]
    check v4.z == v4[2]
    check v4.w == v4[3]

  test "vec component assignment":
    var v2 = vec2(0)
    v2[0] = 1.0; v2[1] = 2.0
    check v2 ~= vec2(1, 2)

    var v3 = vec3(0)
    v3[0] = 1.0; v3[1] = 2.0; v3[2] = 3.0
    check v3 ~= vec3(1, 2, 3)

    var v4 = vec4(0)
    v4[0] = 1.0; v4[1] = 2.0; v4[2] = 3.0; v4[3] = 4.0
    check v4 ~= vec4(1, 2, 3, 4)

suite "mat2 memory layout and element access":
  test "mat2 cast to flat array is column-major":
    when not defined(js):
      # Memory: [col0_row0, col0_row1, col1_row0, col1_row1]
      let m = cast[Mat2]([1.0f, 2.0f, 3.0f, 4.0f])
      let a = cast[array[4, float32]](m)
      check a[0] == 1.0f  # col 0 row 0
      check a[1] == 2.0f  # col 0 row 1
      check a[2] == 3.0f  # col 1 row 0
      check a[3] == 4.0f  # col 1 row 1

  test "mat2 [row, col] element access":
    when not defined(js):
      let m = cast[Mat2]([1.0f, 2.0f, 3.0f, 4.0f])
      # [row, col] indexing into column-major memory
      check m[0, 0] == 1.0f  # arr[0*2+0] = arr[0]
      check m[0, 1] == 2.0f  # arr[0*2+1] = arr[1]
      check m[1, 0] == 3.0f  # arr[1*2+0] = arr[2]
      check m[1, 1] == 4.0f  # arr[1*2+1] = arr[3]

  test "mat2 element assignment":
    var m = mat2()
    m[0, 0] = 5.0; m[0, 1] = 6.0
    m[1, 0] = 7.0; m[1, 1] = 8.0
    check m[0, 0] == 5.0f
    check m[0, 1] == 6.0f
    check m[1, 0] == 7.0f
    check m[1, 1] == 8.0f

  test "mat2 identity":
    let m = mat2()
    check m[0, 0] == 1.0f
    check m[0, 1] == 0.0f
    check m[1, 0] == 0.0f
    check m[1, 1] == 1.0f

  test "mat2 scalar constructor":
    let m = mat2(1, 2, 3, 4)
    check m[0, 0] == 1.0f
    check m[0, 1] == 2.0f
    check m[1, 0] == 3.0f
    check m[1, 1] == 4.0f

  test "mat2 vector column constructor":
    let m = mat2(vec2(1, 2), vec2(3, 4))
    check m[0, 0] == 1.0f
    check m[0, 1] == 2.0f
    check m[1, 0] == 3.0f
    check m[1, 1] == 4.0f

suite "mat2 operations":
  let
    a = cast[Mat2]([1.0f, 2.0f, 3.0f, 4.0f])
    b = cast[Mat2]([5.0f, -6.0f, 7.0f, -8.0f])

  test "mat2 multiply":
    let ab = a * b
    let ba = b * a
    check not(ab ~= ba)  # non-commutative
    # identity * a = a
    check mat2() * a ~= a
    check a * mat2() ~= a

  test "mat2 transpose":
    let t = transpose(a)
    check t[0, 0] == a[0, 0]
    check t[0, 1] == a[1, 0]
    check t[1, 0] == a[0, 1]
    check t[1, 1] == a[1, 1]
    # double transpose = original
    check transpose(transpose(a)) ~= a

  test "mat2 determinant":
    check determinant(a) == 1.0f * 4.0f - 3.0f * 2.0f  # ad - bc = -2

  test "mat2 inverse":
    let inv = inverse(a)
    check a * inv ~= mat2()
    check inv * a ~= mat2()

  test "mat2 * vec2":
    let v = vec2(1.25, -2.5)
    let result = a * v
    # Verify by manual computation
    check result.x ~= (a[0, 0] * v.x + a[1, 0] * v.y)
    check result.y ~= (a[0, 1] * v.x + a[1, 1] * v.y)

suite "mat3 memory layout and element access":
  test "mat3 cast to flat array is column-major":
    when not defined(js):
      # 9 floats: col0(3), col1(3), col2(3)
      let m = cast[Mat3]([1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f, 10.0f])
      let a = cast[array[9, float32]](m)
      check a[0] == 1.0f   # col 0 row 0
      check a[1] == 2.0f   # col 0 row 1
      check a[2] == 3.0f   # col 0 row 2
      check a[3] == 4.0f   # col 1 row 0
      check a[4] == 5.0f   # col 1 row 1
      check a[5] == 6.0f   # col 1 row 2
      check a[6] == 7.0f   # col 2 row 0
      check a[7] == 8.0f   # col 2 row 1
      check a[8] == 10.0f  # col 2 row 2

  test "mat3 [row, col] element access":
    when not defined(js):
      let m = cast[Mat3]([1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f, 10.0f])
      check m[0, 0] == 1.0f
      check m[0, 1] == 2.0f
      check m[0, 2] == 3.0f
      check m[1, 0] == 4.0f
      check m[1, 1] == 5.0f
      check m[1, 2] == 6.0f
      check m[2, 0] == 7.0f
      check m[2, 1] == 8.0f
      check m[2, 2] == 10.0f

  test "mat3 identity":
    let m = mat3()
    for r in 0 .. 2:
      for c in 0 .. 2:
        if r == c:
          check m[r, c] == 1.0f
        else:
          check m[r, c] == 0.0f

  test "mat3 element assignment":
    var m = mat3()
    m[1, 2] = 42.0
    check m[1, 2] == 42.0f

suite "mat3 operations":
  let
    a = cast[Mat3]([1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f, 10.0f])
    b = cast[Mat3]([-1.0f, 3.0f, 5.0f, 7.0f, -2.0f, 4.0f, 6.0f, 8.0f, -3.0f])

  test "mat3 multiply":
    check mat3() * a ~= a
    check a * mat3() ~= a
    check not(a * b ~= b * a)

  test "mat3 transpose":
    let t = transpose(a)
    for r in 0 .. 2:
      for c in 0 .. 2:
        check t[r, c] == a[c, r]
    check transpose(transpose(a)) ~= a

  test "mat3 determinant non-zero":
    # [1..8, 10] has det = -3
    check abs(determinant(a) - (-3.0f)) < 0.001f

  test "mat3 inverse":
    let inv = inverse(a)
    check a * inv ~= mat3()
    check inv * a ~= mat3()

  test "mat3 * vec3":
    let v = vec3(1.0, -2.0, 3.0)
    let result = a * v
    check result.x ~= (a[0, 0] * v.x + a[1, 0] * v.y + a[2, 0] * v.z)
    check result.y ~= (a[0, 1] * v.x + a[1, 1] * v.y + a[2, 1] * v.z)
    check result.z ~= (a[0, 2] * v.x + a[1, 2] * v.y + a[2, 2] * v.z)

  test "mat3 * vec2 (2D homogeneous)":
    let v = vec2(3.0, -1.5)
    let result = a * v
    # Should treat vec2 as vec3(x, y, 1) and return xy
    let full = a * vec3(v.x, v.y, 1.0)
    check result.x ~= full.x
    check result.y ~= full.y

suite "mat3 2D constructors":
  test "scale2D":
    let s = scale(vec2(2.0, 3.0))
    check s[0, 0] == 2.0f
    check s[1, 1] == 3.0f
    check s[2, 2] == 1.0f
    check s[1, 0] == 0.0f
    # Scaling a point
    let v = s * vec2(5.0, 10.0)
    check v ~= vec2(10.0, 30.0)

  test "translate2D":
    let t = translate(vec2(5.0, 10.0))
    check t[2, 0] == 5.0f
    check t[2, 1] == 10.0f
    let v = t * vec2(1.0, 2.0)
    check v ~= vec2(6.0, 12.0)

  test "rotate2D":
    let r = rotate(45.0f.toRadians)
    # cos(45) ~= 0.707, sin(45) ~= 0.707
    check r[0, 0] ~= cos(45.0f.toRadians)
    check r[0, 1] ~= sin(45.0f.toRadians)
    check r[1, 0] ~= -sin(45.0f.toRadians)
    check r[1, 1] ~= cos(45.0f.toRadians)
    # Rotating (1, 0) by 90 degrees should give (0, 1)
    let r90 = rotate(90.0f.toRadians)
    check r90 * vec2(1.0, 0.0) ~= vec2(0.0, 1.0)

  test "2D transform composition":
    let mat2d = translate(vec2(10, 20)) * rotate(45.toRadians) * scale(vec2(2))
    check mat2d ~= mat3(
      1.414213538169861, 1.414213538169861, 0.0,
      -1.414213538169861, 1.414213538169861, 0.0,
      10.0, 20.0, 1.0
    )

suite "mat4 memory layout and element access":
  test "mat4 cast to flat array is column-major":
    when not defined(js):
      let m = cast[Mat4]([
        1.0f, 2.0f, 3.0f, 4.0f,
        5.0f, 6.0f, 7.0f, 8.0f,
        9.0f, 10.0f, 11.0f, 12.0f,
        13.0f, 14.0f, 15.0f, 16.0f
      ])
      let a = cast[array[16, float32]](m)
      # Column 0
      check a[0] == 1.0f; check a[1] == 2.0f; check a[2] == 3.0f; check a[3] == 4.0f
      # Column 1
      check a[4] == 5.0f; check a[5] == 6.0f; check a[6] == 7.0f; check a[7] == 8.0f
      # Column 2
      check a[8] == 9.0f; check a[9] == 10.0f; check a[10] == 11.0f; check a[11] == 12.0f
      # Column 3
      check a[12] == 13.0f; check a[13] == 14.0f; check a[14] == 15.0f; check a[15] == 16.0f

  test "mat4 [row, col] element access matches flat column-major":
    when not defined(js):
      let m = cast[Mat4]([
        1.0f, 2.0f, 3.0f, 4.0f,
        5.0f, 6.0f, 7.0f, 8.0f,
        9.0f, 10.0f, 11.0f, 12.0f,
        13.0f, 14.0f, 15.0f, 16.0f
      ])
      let a = cast[array[16, float32]](m)
      for row in 0 .. 3:
        for col in 0 .. 3:
          # m[row, col] should equal a[row * 4 + col]
          check m[row, col] == a[row * 4 + col]

  test "mat4 identity":
    let m = mat4()
    for r in 0 .. 3:
      for c in 0 .. 3:
        if r == c:
          check m[r, c] == 1.0f
        else:
          check m[r, c] == 0.0f

  test "mat4 constructors match":
    let fromScalars = mat4(
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1
    )
    let fromVecs = mat4(
      vec4(1, 0, 0, 0),
      vec4(0, 1, 0, 0),
      vec4(0, 0, 1, 0),
      vec4(0, 0, 0, 1)
    )
    check fromScalars ~= fromVecs
    check fromScalars ~= mat4()

suite "mat4 operations":
  let
    a = cast[Mat4]([
      1.0f, 2.0f, 3.0f, 4.0f,
      5.0f, 6.0f, 7.0f, 8.0f,
      9.0f, 10.0f, 11.0f, 12.0f,
      13.0f, 14.0f, 15.0f, 16.0f
    ])
    b = cast[Mat4]([
      -10.0f, -20.0f, -30.0f, -40.0f,
      50.0f, 60.0f, 70.0f, 80.0f,
      90.0f, 100.0f, 110.0f, 120.0f,
      130.0f, 140.0f, 150.0f, 160.0f
    ])

  test "mat4 multiply identity":
    check mat4() * a ~= a
    check a * mat4() ~= a

  test "mat4 multiply non-commutative":
    check not(a * b ~= b * a)

  test "mat4 transpose":
    let t = transpose(a)
    for r in 0 .. 3:
      for c in 0 .. 3:
        check t[r, c] == a[c, r]
    check transpose(transpose(a)) ~= a

  test "mat4 inverse (float32)":
    let m = translate(vec3(1, 2, 3)) * rotateZ(45.toRadians)
    let inv = inverse(m)
    check m * inv ~= mat4()
    check inv * m ~= mat4()

  test "mat4 inverse (float64, compound transform)":
    # Multi-rotation + non-uniform scale needs float64 to stay within ~= tolerance
    let m = translate(dvec3(10, 20, 30)) * rotateZ(71.0.toRadians) *
            rotateY(-23.0.toRadians) * rotateX(37.0.toRadians) * scale(dvec3(2, 3, 4))
    let inv = inverse(m)
    check m * inv ~= dmat4()
    check inv * m ~= dmat4()

  test "mat4 * vec3":
    let m = translate(vec3(10, 20, 30))
    let v = vec3(1.25, -2.5, 3.75)
    let result = m * v
    check result ~= vec3(11.25, 17.5, 33.75)

  test "mat4 * vec4":
    let m = translate(vec3(10, 20, 30))
    let v = vec4(1.25, -2.5, 3.75, 1.0)
    let result = m * v
    check result ~= vec4(11.25, 17.5, 33.75, 1.0)

suite "mat4 constructors":
  test "scale matrix":
    let s = scale(vec3(2, 3, 4))
    check s[0, 0] == 2.0f
    check s[1, 1] == 3.0f
    check s[2, 2] == 4.0f
    check s[3, 3] == 1.0f
    check s * vec3(1, 1, 1) ~= vec3(2, 3, 4)

  test "translate matrix":
    let t = translate(vec3(10, 20, 30))
    check t[3, 0] == 10.0f
    check t[3, 1] == 20.0f
    check t[3, 2] == 30.0f
    check t * vec3(0, 0, 0) ~= vec3(10, 20, 30)

  test "rotateX matrix":
    let r = rotateX(90.0f.toRadians)
    # Rotating Y-axis around X by 90 should give Z-axis
    check r * vec3(0, 1, 0) ~= vec3(0, 0, 1)

  test "rotateY matrix":
    let r = rotateY(90.0f.toRadians)
    # Rotating X-axis around Y by 90 should give -Z-axis
    check r * vec3(1, 0, 0) ~= vec3(0, 0, -1)

  test "rotateZ matrix":
    let r = rotateZ(90.0f.toRadians)
    # Rotating X-axis around Z by 90 should give Y-axis
    check r * vec3(1, 0, 0) ~= vec3(0, 1, 0)

  test "transform composition order":
    # T * R * S: scale first, then rotate, then translate
    let t = translate(vec3(10, 20, 30))
    let r = rotateZ(71.0f.toRadians) * rotateY(-23.0f.toRadians) * rotateX(37.0f.toRadians)
    let s = scale(vec3(2, 3, 4))
    let transform = t * r * s
    check transform[3, 0] ~= 10.0f
    check transform[3, 1] ~= 20.0f
    check transform[3, 2] ~= 30.0f

  test "3D and 2D composition consistency":
    let mat2d = translate(vec2(10, 20)) * rotate(45.toRadians) * scale(vec2(2))
    let mat3d = translate(vec3(10, 20, 0)) * rotateZ(45.toRadians) * scale(vec3(2))
    # The 2D and 3D transforms should produce matching XY results
    let v2 = mat2d * vec2(1, 0)
    let v3 = mat3d * vec3(1, 0, 0)
    check v2.x ~= v3.x
    check v2.y ~= v3.y

suite "vector operations":
  test "length":
    check vec2(3, 4).length ~= 5.0f
    check vec3(1, 2, 2).length ~= 3.0f
    check vec4(1, 0, 0, 0).length ~= 1.0f
    check dvec3(0, 0, 0).length ~= 0.0

  test "lengthSq":
    check vec2(3, 4).lengthSq ~= 25.0f
    check vec3(1, 2, 2).lengthSq ~= 9.0f
    check vec4(2, 0, 0, 0).lengthSq ~= 4.0f

  test "normalize":
    check normalize(vec2(10, 0)) ~= vec2(1, 0)
    check normalize(vec3(0, 0, 5)) ~= vec3(0, 0, 1)
    check abs(normalize(vec4(1, 1, 1, 1)).length - 1.0f) < 1e-5f

  test "dist and distSq":
    check dist(vec2(0, 0), vec2(3, 4)) ~= 5.0f
    check distSq(vec2(0, 0), vec2(3, 4)) ~= 25.0f
    check dist(vec3(0, 0, 0), vec3(1, 2, 2)) ~= 3.0f
    check distSq(vec3(0, 0, 0), vec3(1, 2, 2)) ~= 9.0f

  test "dot product":
    check dot(vec2(1, 0), vec2(0, 1)) ~= 0.0f
    check dot(vec2(1, 0), vec2(1, 0)) ~= 1.0f
    check dot(vec3(1, 2, 3), vec3(4, 5, 6)) ~= 32.0f
    check dot(vec4(1, 2, 3, 4), vec4(5, 6, 7, 8)) ~= 70.0f

  test "dir (point to point)":
    let d = dir(vec3(0, 0, 0), vec3(10, 0, 0))
    check abs(d.length - 1.0f) < 1e-5f
    let d2 = dir(vec2(0, 0), vec2(0, 5))
    check abs(d2.length - 1.0f) < 1e-5f

  test "dir (angle to vec2)":
    check dir(0.0f) ~= vec2(1, 0)
    check dir(float32(PI / 2)) ~= vec2(0, 1)
    check dir(float32(PI)) ~= vec2(-1, 0)

  test "angle of vec2":
    check angle(vec2(1, 0)) ~= 0.0f
    check angle(vec2(0, 1)) ~= float32(PI / 2)
    check angle(vec2(-1, 0)) ~= float32(PI)

  test "mix (vector lerp)":
    check mix(vec2(0, 0), vec2(10, 20), 0.5f) ~= vec2(5, 10)
    check mix(vec3(0, 0, 0), vec3(10, 20, 30), 0.25f) ~= vec3(2.5, 5.0, 7.5)
    check mix(vec4(0, 0, 0, 0), vec4(4, 8, 12, 16), 0.5f) ~= vec4(2, 4, 6, 8)

  test "mix (per-component vector)":
    check mix(vec2(0, 0), vec2(10, 20), vec2(0.5, 1.0)) ~= vec2(5, 20)
    check mix(vec3(0, 0, 0), vec3(10, 20, 30), vec3(0.0, 0.5, 1.0)) ~= vec3(0, 10, 30)

  test "clamp (vector bounds)":
    check clamp(vec2(5, -5), vec2(0, 0), vec2(3, 3)) == vec2(3, 0)
    check clamp(vec3(5, -5, 1), vec3(0, 0, 0), vec3(3, 3, 3)) == vec3(3, 0, 1)

  test "clamp (scalar bounds)":
    check clamp(vec2(5, -5), 0.0f, 3.0f) == vec2(3, 0)
    check clamp(vec3(5, -5, 1), 0.0f, 3.0f) == vec3(3, 0, 1)

  test "inversesqrt":
    check inversesqrt(4.0f) ~= 0.5f
    check inversesqrt(1.0f) ~= 1.0f
    check inversesqrt(16.0) ~= 0.25

  test "zmod":
    # GLSL-style mod: a - b * floor(a/b)
    check zmod(5.5f, 3.0f) ~= 2.5f
    check zmod(-1.0f, 3.0f) ~= 2.0f  # differs from Nim mod for negatives
    check zmod(7.0f, 3.0f) ~= 1.0f

  test "turnAngle":
    # Should step toward target angle, clamped by speed
    let a = 0.0f
    let b = 1.0f
    check turnAngle(a, b, 0.5f) ~= 0.5f  # step partway
    check turnAngle(a, b, 2.0f) ~= b      # speed exceeds gap, snap to target
    check turnAngle(a, b, 0.01f) ~= 0.01f # small step

suite "mat4 direction accessors":
  test "identity directions":
    let m = mat4()
    check m.forward ~= vec3(0, 0, 1)
    check m.back ~= vec3(0, 0, -1)
    check m.left ~= vec3(-1, 0, 0)
    check m.right ~= vec3(1, 0, 0)
    check m.up ~= vec3(0, 1, 0)
    check m.down ~= vec3(0, -1, 0)

  test "rotated directions":
    let m = rotateY(float32(PI / 2))
    # After 90° CCW around Y: forward (+Z) rotates toward +X
    check m.forward ~= vec3(1, 0, 0)
    check m.right ~= vec3(0, 0, -1)
    check m.up ~= vec3(0, 1, 0)

  test "rotationOnly strips translation":
    let m = translate(vec3(10, 20, 30)) * rotateX(float32(PI / 4))
    let r = rotationOnly(m)
    check r.pos ~= vec3(0, 0, 0)
    check r.forward ~= m.forward
    check r.up ~= m.up

suite "frustum and projection":
  test "frustum matrix":
    let f = frustum[float32](-1, 1, -1, 1, 1, 100)
    # Near plane, center should map to origin
    let v = f * vec4(0, 0, -1, 1)
    check v.x ~= 0.0f
    check v.y ~= 0.0f
    # Should match perspective with 90° fov, aspect 1
    let p = perspective[float32](90, 1, 1, 100)
    check f ~= p

suite "euler angles (extended)":
  test "toAngles from origin to target":
    let angles = toAngles(vec3(0, 0, 0), vec3(0, 0, 1))
    check angles ~= vec3(0, 0, 0)  # looking forward
    let angles2 = toAngles(vec3(0, 0, 0), vec3(1, 0, 0))
    check angles2 ~= toAngles(vec3(1, 0, 0))

  test "toAngles from quaternion":
    # Identity quaternion = no rotation
    check toAngles(quat(0, 0, 0, 1)) ~= vec3(0, 0, 0)
    # Quaternion euler roundtrip
    let q = quatRotateX(0.3f) * quatRotateY(0.5f) * quatRotateZ(0.1f)
    let anglesFromQuat = toAngles(q)
    let anglesFromMat = toAngles(q.mat4())
    check anglesFromQuat ~= anglesFromMat

  test "rotate around arbitrary axis":
    let axis = normalize(vec3(1.0, 1.0, 0.0))
    let m = rotate(float32(PI / 2), axis)
    # Should be a valid rotation matrix (det = 1, orthogonal)
    check abs(determinant(m) - 1.0f) < 0.01f
    let inv = inverse(m)
    check m * inv ~= mat4()

suite "quaternion nlerp":
  test "nlerp endpoints":
    let
      qx = quatRotateX(0.37f)
      qz = quatRotateZ(1.24f)
    check nlerp(qx, qz, 0.0f) ~= qx

  test "nlerp produces unit quaternions":
    let
      qx = quatRotateX(0.37f)
      qz = quatRotateZ(1.24f)
    for i in 0 .. 10:
      let q = nlerp(qx, qz, i.float32 / 10.0f)
      check abs(q.length - 1.0f) < 1e-5f

  test "nlerp vs slerp similar for close quats":
    let
      qx = quatRotateX(0.1f)
      qy = quatRotateX(0.2f)
      nl = nlerp(qx, qy, 0.5f)
      sl = slerp(qx, qy, 0.5f)
    # For close quaternions, nlerp and slerp should be very similar
    check dist(nl, sl) < 0.01f

suite "orthogonal vector":
  test "orthogonal is perpendicular to abs(v)":
    # orthogonal() uses abs(v) internally, so result is perpendicular to abs(v)
    for v in [vec3(1, 0, 0), vec3(0, 1, 0), vec3(0, 0, 1),
              vec3(1, 1, 0), vec3(1, 1, 1), vec3(3, 2, 7)]:
      let o = orthogonal(v)
      check abs(dot(v, o)) < 1e-5f

  test "orthogonal is nonzero for nonzero input":
    for v in [vec3(1, 0, 0), vec3(0, 1, 0), vec3(0, 0, 1), vec3(5, 3, 2)]:
      check orthogonal(v).length > 0.0f

suite "degenerate matrices":
  test "all-zero mat2":
    let z = mat2(0, 0, 0, 0)
    check determinant(z) == 0.0f
    # zero * anything = zero
    check z * mat2() ~= z
    check mat2() * z ~= z
    check z * z ~= z
    # zero * vec = zero
    check z * vec2(1, 2) ~= vec2(0, 0)
    # transpose of zero is zero
    check transpose(z) ~= z

  test "all-zero mat3":
    let z = mat3(0, 0, 0, 0, 0, 0, 0, 0, 0)
    check determinant(z) == 0.0f
    check z * mat3() ~= z
    check mat3() * z ~= z
    check z * z ~= z
    check z * vec3(1, 2, 3) ~= vec3(0, 0, 0)
    check transpose(z) ~= z

  test "all-zero mat4":
    let z = mat4(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    check determinant(z) == 0.0f
    check z * mat4() ~= z
    check mat4() * z ~= z
    check z * z ~= z
    check z * vec3(1, 2, 3) ~= vec3(0, 0, 0)
    check transpose(z) ~= z

  test "singular mat2 (det=0)":
    # Rows are linearly dependent
    let s = mat2(1, 2, 2, 4)
    check determinant(s) == 0.0f
    # Inverse produces Inf/NaN (division by zero det)
    let inv = inverse(s)
    check vmath.isNan(inv[0, 0]) or abs(inv[0, 0]) == Inf

  test "singular mat3 (det=0)":
    # Row 2 = Row 0 + Row 1
    let s = mat3(1, 0, 0, 0, 1, 0, 1, 1, 0)
    check abs(determinant(s)) < 1e-6f
    let inv = inverse(s)
    check vmath.isNan(inv[0, 0]) or abs(inv[0, 0]) == Inf

  test "singular mat4 (det=0)":
    # Duplicate rows → det = 0
    let s = mat4(
      1, 0, 0, 0,
      0, 1, 0, 0,
      1, 0, 0, 0,
      0, 0, 0, 1
    )
    check abs(determinant(s)) < 1e-6f
    let inv = inverse(s)
    check vmath.isNan(inv[0, 0]) or abs(inv[0, 0]) == Inf

  test "zero diagonal mat2":
    let m = mat2(0, 3, 7, 0)
    check determinant(m) == -(7.0f * 3.0f)  # -21
    # Still invertible (det != 0)
    let inv = inverse(m)
    check m * inv ~= mat2()

  test "zero diagonal mat3":
    let m = mat3(0, 1, 0, 0, 0, 1, 1, 0, 0)
    # Permutation matrix, det = 1
    check abs(determinant(m) - 1.0f) < 1e-5f
    let inv = inverse(m)
    check m * inv ~= mat3()

  test "zero diagonal mat4":
    # Anti-diagonal matrix
    let m = mat4(
      0, 0, 0, 1,
      0, 0, 1, 0,
      0, 1, 0, 0,
      1, 0, 0, 0
    )
    check abs(determinant(m)) > 0.0f
    let inv = inverse(m)
    check m * inv ~= mat4()

  test "near-singular mat3 (tiny det)":
    let m = dmat3(
      1.0, 0.0, 0.0,
      0.0, 1e-15, 0.0,
      0.0, 0.0, 1.0
    )
    check abs(determinant(m)) < 1e-10
    check determinant(m) != 0.0
    # Inverse exists but is huge
    let inv = inverse(m)
    check inv[1, 1] > 1e14

  test "scale by zero (rank-deficient mat4)":
    let m = scale(vec3(1, 0, 1))
    check determinant(m) == 0.0f
    # Multiply still works, just collapses one axis
    check m * vec3(5, 5, 5) ~= vec3(5, 0, 5)

  test "all-ones matrices":
    let m2 = mat2(1, 1, 1, 1)
    check determinant(m2) == 0.0f
    # m * m = 2 * m (idempotent up to scaling)
    check m2 * m2 ~= mat2(2, 2, 2, 2)

    let m3 = mat3(1, 1, 1, 1, 1, 1, 1, 1, 1)
    check determinant(m3) == 0.0f
    check m3 * m3 ~= mat3(3, 3, 3, 3, 3, 3, 3, 3, 3)

  test "negative identity":
    let m2 = mat2(-1, 0, 0, -1)
    check determinant(m2) == 1.0f
    check m2 * m2 ~= mat2()  # (-I)^2 = I
    check inverse(m2) ~= m2  # (-I)^-1 = -I

    let m3 = mat3(-1, 0, 0, 0, -1, 0, 0, 0, -1)
    check determinant(m3) == -1.0f
    check m3 * m3 ~= mat3()
    check inverse(m3) ~= m3

    let m4 = mat4(
      -1, 0, 0, 0,
       0,-1, 0, 0,
       0, 0,-1, 0,
       0, 0, 0, 1
    )
    check abs(determinant(m4) - (-1.0f)) < 1e-5f
    check inverse(m4) ~= m4

  test "projection matrix (non-invertible rank 1)":
    # Projects onto x-axis: P^2 = P
    let p = mat3(1, 0, 0, 0, 0, 0, 0, 0, 0)
    check determinant(p) == 0.0f
    check p * p ~= p  # idempotent
    check p * vec3(5, 7, 9) ~= vec3(5, 0, 0)

  test "very large values":
    let big = 1e18f
    let m = mat2(big, 0, 0, big)
    check determinant(m) == big * big
    let inv = inverse(m)
    check inv[0, 0] ~= (1.0f / big)
    check m * inv ~= mat2()

  test "mixed large and small values":
    let m = dmat3(
      1e10, 0.0, 0.0,
      0.0, 1e-10, 0.0,
      0.0, 0.0, 1.0
    )
    let inv = inverse(m)
    check m * inv ~= dmat3()

  test "skew/shear matrix":
    # Shear in x by y
    let m = mat3(1, 0, 0, 3, 1, 0, 0, 0, 1)
    check determinant(m) == 1.0f
    let inv = inverse(m)
    check m * inv ~= mat3()
    # Shearing (1, 0) should give (1, 0), shearing (0, 1) should give (3, 1)
    check m * vec3(0, 1, 0) ~= vec3(3, 1, 0)

suite "quaternion constructors":
  test "identity quaternion":
    let q = quat(0, 0, 0, 1)
    check q.x == 0.0f
    check q.y == 0.0f
    check q.z == 0.0f
    check q.w == 1.0f

  test "axis-angle constructors":
    let qx = quatRotateX(37.0f.toRadians)
    let qy = quatRotateY(-23.0f.toRadians)
    let qz = quatRotateZ(71.0f.toRadians)
    # Should be unit quaternions
    check abs(qx.length - 1.0f) < 1e-5f
    check abs(qy.length - 1.0f) < 1e-5f
    check abs(qz.length - 1.0f) < 1e-5f

  test "fromAxisAngle":
    let axis = normalize(vec3(1.0, 2.0, -3.0))
    let angle = 48.0f.toRadians
    let q = fromAxisAngle(axis, angle)
    check abs(q.length - 1.0f) < 1e-5f
    check q.w ~= cos(angle * 0.5f)

  test "quaternion matrix constructors match rotation matrices":
    check quatRotateX(PI / 2).mat4() ~= rotateX(PI / 2)
    check quatRotateY(PI / 2).mat4() ~= rotateY(PI / 2)
    check quatRotateZ(PI / 2).mat4() ~= rotateZ(PI / 2)

suite "quaternion arithmetic":
  test "quat + - * / operators":
    let
      a = dquat(1, 2, 3, 4)
      b = dquat(-0.5, 0.25, 2.0, -3.0)
    check a + b ~= dquat(0.5, 2.25, 5.0, 1.0)
    check a - b ~= dquat(1.5, 1.75, 1.0, 7.0)
    check a * 2.0 ~= dquat(2, 4, 6, 8)
    check b / 2.0 ~= dquat(-0.25, 0.125, 1.0, -1.5)

suite "quaternion multiply":
  test "quaternion composition matches matrix composition":
    let
      qx = quatRotateX(0.37)
      qy = quatRotateY(-0.91)
      qz = quatRotateZ(1.24)
      mxyz = rotateX(0.37) * rotateY(-0.91) * rotateZ(1.24)
    check quatMultiply(quatMultiply(qx, qy), qz).mat4() ~= mxyz

  test "quaternion multiply identity":
    let q = fromAxisAngle(normalize(vec3(1, 2, -3)), 48.0f.toRadians)
    let identity = quat(0, 0, 0, 1)
    check quatMultiply(q, identity) ~= q
    check quatMultiply(identity, q) ~= q

suite "quaternion vector rotation":
  test "rotate basis vectors":
    let x = dvec3(1, 0, 0)
    let y = dvec3(0, 1, 0)
    check quatRotateY(PI / 2) * x ~= dvec3(0, 0, -1)
    check quatRotateX(PI / 2) * y ~= dvec3(0, 0, 1)
    check quatRotateZ(PI / 2) * x ~= dvec3(0, 1, 0)

  test "quatRotate matches matrix multiply":
    for _ in 0 ..< 1000:
      let
        axis = dvec3(rand(2.0)-1.0, rand(2.0)-1.0, rand(2.0)-1.0)
        angle = rand(-PI .. PI)
        q = fromAxisAngle(axis.normalize, angle)
        v = dvec3(rand(2.0)-1.0, rand(2.0)-1.0, rand(2.0)-1.0)
      check quatRotate(q, v) ~= q.mat4() * v
      check q * v ~= q.mat4() * v

suite "quaternion matrix roundtrip":
  test "identity roundtrip":
    let m = mat4()
    check m.quat().mat4() ~= m

  test "single axis rotations":
    for angle in [PI/6, PI/4, PI/3, PI/2, PI, -PI/4]:
      let mx = rotateX(angle)
      check mx.quat().mat4() ~= mx
      let my = rotateY(angle)
      check my.quat().mat4() ~= my
      let mz = rotateZ(angle)
      check mz.quat().mat4() ~= mz

  test "arbitrary rotations fuzz":
    for _ in 0 ..< 2000:
      let m = rotate(
        PI*rand(2.0),
        dvec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
      )
      check m.quat().mat4() ~= m

  test "hard decomposition near 180 degrees":
    let
      axis = normalize(vec3(1.0, -2.0, 3.0))
      angle = 170.0f.toRadians
      q = fromAxisAngle(axis, angle)
      m = q.mat4()
    check m.quat().mat4() ~= m

suite "quaternion inverse":
  test "q * q^-1 = identity":
    let q = fromAxisAngle(normalize(dvec3(1, 2, -3)), 48.0.toRadians)
    let product = quatMultiply(q, quatInverse(q))
    check abs(product.x) < 1e-5
    check abs(product.y) < 1e-5
    check abs(product.z) < 1e-5
    check abs(product.w - 1.0) < 1e-5

  test "inverse undoes rotation":
    let
      q = fromAxisAngle(normalize(dvec3(1, 2, -3)), 48.0.toRadians)
      v = dvec3(1.25, -2.5, 3.75)
      rotated = quatRotate(q, v)
      unrotated = quatRotate(quatInverse(q), rotated)
    check unrotated ~= v

  test "unit quaternion inverse = conjugate":
    let q = fromAxisAngle(normalize(dvec3(1, 2, -3)), 48.0.toRadians)
    let inv = quatInverse(q)
    let conj = dquat(-q.x, -q.y, -q.z, q.w)
    check inv ~= conj

  test "inverse fuzz":
    for _ in 0 ..< 1000:
      let
        axis = dvec3(rand(2.0)-1.0, rand(2.0)-1.0, rand(2.0)-1.0).normalize()
        q = fromAxisAngle(axis, rand(-PI .. PI))
        product = quatMultiply(q, quatInverse(q))
      check abs(product.w) ~= 1.0

suite "quaternion to axis-angle":
  test "known axis-angle roundtrip":
    let
      axis = normalize(dvec3(1, 2, -3))
      angle = 48.0.toRadians
      q = fromAxisAngle(axis, angle)
      (extractedAxis, extractedAngle) = toAxisAngle(q)
    check extractedAxis ~= axis
    check abs(extractedAngle - angle) < 1e-5

  test "identity gives zero angle":
    let (_, angle) = toAxisAngle(dquat(0, 0, 0, 1))
    check abs(angle) < 1e-5

  test "90 degree axes":
    for axisVec in [dvec3(1, 0, 0), dvec3(0, 1, 0), dvec3(0, 0, 1)]:
      let
        q = fromAxisAngle(axisVec, PI / 2)
        (a, ang) = toAxisAngle(q)
      check a ~= axisVec
      check abs(ang - PI / 2) < 1e-5

  test "axis-angle fuzz":
    for _ in 0 ..< 1000:
      let
        axis = dvec3(rand(2.0)-1.0, rand(2.0)-1.0, rand(2.0)-1.0).normalize()
        angle = rand(0.001 .. PI)
        q = fromAxisAngle(axis, angle)
        (a, ang) = toAxisAngle(q)
      check a ~= axis
      check abs(ang - angle) < 1e-4

suite "slerp":
  test "endpoints":
    let
      qx = quatRotateX(0.37)
      qz = quatRotateZ(1.24)
    check slerp(qx, qz, 0.0) ~= qx

  test "midpoint equidistant":
    let
      qx = quatRotateX(0.37)
      qz = quatRotateZ(1.24)
      mid = slerp(qx, qz, 0.5)
      a0 = arccos(clamp(dot(qx, mid), -1.0, 1.0))
      a1 = arccos(clamp(dot(mid, qz), -1.0, 1.0))
    check abs(a0 - a1) < 1e-5

  test "slerp unit length":
    let
      qx = quatRotateX(0.37)
      qz = quatRotateZ(1.24)
    for i in 0 .. 10:
      let q = slerp(qx, qz, i.float64 / 10.0)
      check abs(q.length - 1.0) < 1e-5

  test "slerp identical inputs":
    let qx = quatRotateX(0.37)
    check slerp(qx, qx, 0.5) ~= qx

  test "slerp with opposite quaternion":
    let
      qx = quatRotateX(0.37)
      qz = quatRotateZ(1.24)
      qNeg = -qz
      result = slerp(qx, qNeg, 0.5)
    check abs(result.length - 1.0) < 1e-5

  test "slerp fuzz unit length":
    for _ in 0 ..< 1000:
      let
        a = fromAxisAngle(dvec3(rand(2.0)-1, rand(2.0)-1, rand(2.0)-1).normalize(), rand(-PI .. PI))
        b = fromAxisAngle(dvec3(rand(2.0)-1, rand(2.0)-1, rand(2.0)-1).normalize(), rand(-PI .. PI))
        t = rand(0.0 .. 1.0)
        q = slerp(a, b, t)
      check abs(q.length - 1.0) < 1e-5

suite "fromTwoVectors":
  test "basic rotation":
    let
      a = vec3(1, 0, 0)
      b = vec3(0, 1, 0)
      q = fromTwoVectors(a, b)
    check q.mat4() * a ~= b

  test "fromTwoVectors fuzz":
    for _ in 0 ..< 1000:
      let
        a = vec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
        b = vec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
        q = fromTwoVectors(a, b)
      check dist(q.mat4() * a, b) < 1e-5

suite "cross product":
  test "basis vectors":
    check cross(vec3(1, 0, 0), vec3(0, 1, 0)) ~= vec3(0, 0, 1)
    check cross(vec3(0, 1, 0), vec3(1, 0, 0)) ~= vec3(0, 0, -1)

  test "cross product anticommutative":
    let
      a = normalize(vec3(1.0, 2.0, 3.0))
      b = normalize(vec3(-1.0, 0.5, 2.0))
    check cross(a, b) ~= -cross(b, a)

suite "euler angles":
  const PI = PI.float32

  proc eq(a, b: Vec3): bool =
    const epsilon = 0.001
    abs(angleBetween(a.x, b.x)) < epsilon and
      abs(angleBetween(a.y, b.y)) < epsilon and
      abs(angleBetween(a.z, b.z)) < epsilon

  test "from vector":
    check vec3(0, 0, 1).toAngles.eq vec3(0f, 0f, 0f)      # forward
    check vec3(0, 0, -1).toAngles.eq vec3(0f, PI, 0f)      # back
    check vec3(-1, 0, 0).toAngles.eq vec3(0f, PI/2, 0f)    # right
    check vec3(1, 0, 0).toAngles.eq vec3(0f, -PI/2, 0f)    # left
    check vec3(0, 1, 0).toAngles.eq vec3(PI/2, 0f, 0f)     # up
    check vec3(0, -1, 0).toAngles.eq vec3(-PI/2, 0f, 0f)   # down

  test "from matrix":
    check mat4().toAngles.eq vec3(0, 0, 0)
    check rotateX(10.toRadians()).toAngles.eq vec3(10.toRadians(), 0, 0)
    check rotateY(10.toRadians()).toAngles.eq vec3(0, 10.toRadians(), 0)
    check rotateZ(10.toRadians()).toAngles.eq vec3(0, 0, 10.toRadians())

  test "euler roundtrip fuzz (non-polar)":
    for _ in 0 .. 1000:
      let
        xr = rand(-89.9f .. 89.9f).toRadians
        yr = rand(-180 .. 180).toRadians
        zr = rand(-180 .. 180).toRadians
        b = vec3(xr, yr, zr)
        a = fromAngles(b).toAngles()
      check a.eq(b)

suite "lookAt":
  test "basic lookAt":
    let m = lookAt(vec3(5, 5, 5), vec3(0, 0, 0), vec3(0, 1, 0))
    check m[3, 3] ~= 1.0f
    # Should be orthogonal (inverse == transpose for the rotation part)
    let det = determinant(m)
    check abs(det - 1.0f) < 0.01f

  test "lookAt with default up":
    let m = lookAt(vec3(0, 0, 5), vec3(0, 0, 0))
    check m * vec3(0, 0, 0) ~= vec3(0, 0, -5)

suite "projection matrices":
  test "ortho":
    let o = ortho[float32](-1, 1, 1, -1, -1000, 1000)
    check o ~= mat4(
      1.0, 0.0, 0.0, 0.0,
      0.0, -1.0, 0.0, 0.0,
      0.0, 0.0, -0.001000000047497451, 0.0,
      -0.0, 0.0, -0.0, 1.0
    )

  test "perspective":
    let p = perspective[float32](75, 1.666, 1, 1000)
    check p ~= mat4(
      0.7822480201721191, 0.0, 0.0, 0.0,
      0.0, 1.30322527885437, 0.0, 0.0,
      0.0, 0.0, -1.002002000808716, -1.0,
      0.0, 0.0, -2.002002000808716, 0.0
    )

suite "vector constructors":
  test "all types compile":
    check bvec2(true, false) == bvec2(true, false)
    check ivec3(-1, 2, 3) == ivec3(-1, 2, 3)
    check uvec4(1, 2, 3, 4) == uvec4(1, 2, 3, 4)
    check vec2(1.0) == vec2(1.0, 1.0)
    check dvec3(1.0) == dvec3(1.0, 1.0, 1.0)

  test "composite constructors":
    check vec3(vec2(1, 2), 3) == vec3(1, 2, 3)
    check vec4(vec3(1, 2, 3), 4) == vec4(1, 2, 3, 4)
    check vec4(vec2(1, 2), vec2(3, 4)) == vec4(1, 2, 3, 4)

  test "type conversions":
    check vec2(ivec2(1, 1)) == vec2(1, 1)
    check vec2(uvec2(5, 5)) == vec2(5, 5)
    check vec3(ivec3(1, 2, 3)) == vec3(1, 2, 3)
    check vec4(uvec4(17, 18, 19, 20)) == vec4(17, 18, 19, 20)

suite "vector arithmetic":
  test "vec2 operations":
    let a = vec2(1, 2)
    let b = vec2(7, 6)
    check a + b ~= vec2(8, 8)
    check a - b ~= vec2(-6, -4)
    check a * 2.0 ~= vec2(2, 4)
    check a / 2.0 ~= vec2(0.5, 1.0)

  test "vec3 operations":
    let a = vec3(1, 2, 3)
    let b = vec3(7, 6, 5)
    check a + b ~= vec3(8, 8, 8)
    check a - b ~= vec3(-6, -4, -2)

  test "vec4 operations":
    let a = vec4(1, 2, 3, 4)
    let b = vec4(7, 6, 5, 4)
    check a + b ~= vec4(8, 8, 8, 8)
    check a - b ~= vec4(-6, -4, -2, 0)

  test "compound assignment":
    var a = vec3(1, 2, 3)
    a += vec3(7, 6, 5)
    check a ~= vec3(8, 8, 8)
    a -= vec3(7, 6, 5)
    check a ~= vec3(1, 2, 3)

  test "min max":
    check min(vec3(10, -10, 7), vec3(-10, 10, 0)) == vec3(-10, -10, 0)
    check max(vec3(10, -10, 7), vec3(-10, 10, 0)) == vec3(10, 10, 7)

  test "equality and inequality":
    check vec2(1, 1) == vec2(1, 1)
    check vec2(1, 1) != vec2(1, 2)
    check vec3(1, 1, 1) == vec3(1, 1, 1)
    check vec3(1, 1, 1) != vec3(1, 1, 2)
    check vec4(1, 1, 1, 1) == vec4(1, 1, 1, 1)
    check vec4(1, 1, 1, 1) != vec4(1, 1, 1, 2)

suite "vector swizzling":
  test "vec2 swizzle read":
    let a = vec2(1, 2)
    check a.x == 1.0
    check a.y == 2.0
    check a.yx == vec2(2, 1)
    check a.xxx == vec3(1, 1, 1)

  test "vec2 swizzle write":
    var a = vec2(1, 2)
    a.yx = vec2(-1, -2)
    check a == vec2(-2, -1)

  test "vec4 swizzle self-assignment":
    var b = vec4(1, 2, 3, 4)
    b.wzyx = b
    check b == vec4(4, 3, 2, 1)

suite "string representation":
  test "vec2 $":
    check $vec2(1.0, 2.0) == "vec2(1.0, 2.0)"

  test "vec3 $":
    check $vec3(1.0, 2.0, 3.0) == "vec3(1.0, 2.0, 3.0)"

  test "vec4 $":
    check $vec4(1.0, 2.0, 3.0, 4.0) == "vec4(1.0, 2.0, 3.0, 4.0)"

  test "dvec2 $":
    check $dvec2(1.0, 2.0) == "dvec2(1.0, 2.0)"

  test "dvec3 $":
    check $dvec3(1.0, 2.0, 3.0) == "dvec3(1.0, 2.0, 3.0)"

  test "dvec4 $":
    check $dvec4(1.0, 2.0, 3.0, 4.0) == "dvec4(1.0, 2.0, 3.0, 4.0)"

  test "ivec2 $":
    check $ivec2(1, 2) == "ivec2(1, 2)"

  test "ivec3 $":
    check $ivec3(1, 2, 3) == "ivec3(1, 2, 3)"

  test "ivec4 $":
    check $ivec4(1, 2, 3, 4) == "ivec4(1, 2, 3, 4)"

  test "uvec2 $":
    check $uvec2(1, 2) == "uvec2(1, 2)"

  test "uvec3 $":
    check $uvec3(1, 2, 3) == "uvec3(1, 2, 3)"

  test "uvec4 $":
    check $uvec4(1, 2, 3, 4) == "uvec4(1, 2, 3, 4)"

  test "bvec2 $":
    check $bvec2(true, false) == "bvec2(true, false)"

  test "bvec3 $":
    check $bvec3(true, false, true) == "bvec3(true, false, true)"

  test "bvec4 $":
    check $bvec4(true, false, true, false) == "bvec4(true, false, true, false)"

  test "quat $ (prints as vec4)":
    check $quat(1.0, 2.0, 3.0, 4.0) == "vec4(1.0, 2.0, 3.0, 4.0)"
    check $dquat(1.0, 2.0, 3.0, 4.0) == "dvec4(1.0, 2.0, 3.0, 4.0)"

  test "mat2 $":
    check $mat2(1, 2, 3, 4) == """mat2(
  1.0, 2.0,
  3.0, 4.0
)"""

  test "mat3 $":
    check $mat3(1, 2, 3, 4, 5, 6, 7, 8, 9) == """mat3(
  1.0, 2.0, 3.0,
  4.0, 5.0, 6.0,
  7.0, 8.0, 9.0
)"""

  test "mat4 $":
    check $mat4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16) == """mat4(
  1.0, 2.0, 3.0, 4.0,
  5.0, 6.0, 7.0, 8.0,
  9.0, 10.0, 11.0, 12.0,
  13.0, 14.0, 15.0, 16.0
)"""

  test "dmat2 $":
    check $dmat2(1, 2, 3, 4) == """dmat2(
  1.0, 2.0,
  3.0, 4.0
)"""

  test "dmat3 $":
    check $dmat3(1, 2, 3, 4, 5, 6, 7, 8, 9) == """dmat3(
  1.0, 2.0, 3.0,
  4.0, 5.0, 6.0,
  7.0, 8.0, 9.0
)"""

  test "dmat4 $":
    check $dmat4(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16) == """dmat4(
  1.0, 2.0, 3.0, 4.0,
  5.0, 6.0, 7.0, 8.0,
  9.0, 10.0, 11.0, 12.0,
  13.0, 14.0, 15.0, 16.0
)"""

  test "mat4 identity $":
    check $mat4() == """mat4(
  1.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 0.0, 0.0,
  0.0, 0.0, 1.0, 0.0,
  0.0, 0.0, 0.0, 1.0
)"""

suite "double precision":
  test "dmat constructors":
    let m2 = dmat2(); let m3 = dmat3(); let m4 = dmat4()
    check m2[0, 0] == 1.0
    check m3[1, 1] == 1.0
    check m4[2, 2] == 1.0

  test "dmat element access":
    var d4 = dmat4()
    d4[0, 0] = 123.123
    check d4[0, 0] == 123.123

  test "dmat transpose":
    check dmat3().transpose() ~= dmat3()
    check dmat4().transpose() ~= dmat4()

  test "dmat scale translate rotate":
    check scale(dvec2(1, 2)) ~= dmat3(
      1.0, 0.0, 0.0,
      0.0, 2.0, 0.0,
      0.0, 0.0, 1.0
    )
    check translate(dvec3(1, 2, 3)) ~= dmat4(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      1.0, 2.0, 3.0, 1.0
    )

  test "mat4 and dmat4 conversion":
    let m = mat4(
      1, 2, 3, 4,
      5, 6, 7, 8,
      9, 10, 11, 12,
      13, 14, 15, 16
    )
    let d = dmat4(m)
    let m2 = mat4(d)
    check m ~= m2

suite "angle conversions":
  test "toDegrees and toRadians":
    check PI.toDegrees() == 180
    check (PI*2).toDegrees() == 360
    check 180.0.toRadians() ~= PI
    check 360.0.toRadians() ~= PI*2

suite "position accessors":
  test "mat3 pos":
    check translate(vec2(1, 2)).pos == vec2(1, 2)
    var m = translate(vec2(1, 2))
    m.pos = vec2(3, 4)
    check m.pos == vec2(3, 4)

  test "mat4 pos":
    check translate(vec3(1, 2, 3)).pos == vec3(1, 2, 3)
    var m = translate(vec3(1, 2, 3))
    m.pos = vec3(3, 4, 5)
    check m.pos == vec3(3, 4, 5)

suite "angle between vectors":
  test "vec2 angle":
    check angle(vec2(1, 0), vec2(1, 0)) ~= 0
    check angle(vec2(1, 0), vec2(0, 1)) ~= PI/2
    check angle(vec2(1, 0), vec2(-1, 0)) ~= PI
    check vmath.isNan(angle(vec2(0, 0), vec2(1, 0)))

  test "vec3 angle":
    check angle(vec3(1, 0, 0), vec3(1, 0, 0)) ~= 0
    check angle(vec3(1, 0, 0), vec3(0, 1, 0)) ~= PI/2
    check angle(vec3(1, 0, 0), vec3(-1, 0, 0)) ~= PI
    check vmath.isNan(angle(vec3(0, 0, 0), vec3(1, 0, 0)))
