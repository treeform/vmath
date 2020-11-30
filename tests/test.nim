import vmath, osproc, random, streams

var v2 = vec2(0, 0)
v2 *= 1
v2 /= 1

var v3 = vec3(0, 0, 0)
v3 *= 1
v3 /= 1

var v4 = vec4(0, 0, 0, 0)
v4 *= 1
v4 /= 1

var q = quat(0, 0, 0, 0)
q *= 1
q /= 1

var s = newFileStream("tests/test-output.txt", fmWrite)

randomize(1234)

block:
  s.writeLine "# angle stuff"
  s.writeLine angleBetween(0.1, 0.2), " should be: ", 0.1

  s.writeLine angleBetween(0.1, 0.2 + PI*2), " should be: ", 0.1
  s.writeLine angleBetween(0.1, 0.2 - PI*2), " should be: ", 0.1
  s.writeLine angleBetween(0.1 + PI*2, 0.2), " should be: ", 0.1
  s.writeLine angleBetween(0.1 - PI*2, 0.2), " should be: ", 0.1

  s.writeLine angleBetween(0.2, 0.1), " should be: ", -0.1

  s.writeLine angleBetween(0.2, 0.1 - PI*2), " should be: ", -0.1
  s.writeLine angleBetween(0.2, 0.1 + PI*2), " should be: ", -0.1
  s.writeLine angleBetween(0.2 + PI*2, 0.1), " should be: ", -0.1
  s.writeLine angleBetween(0.2 - PI*2, 0.1), " should be: ", -0.1

block:
  s.writeLine "# basic vector vec2"
  var a = vec2(1, 2)
  var b = vec2(7, 6)
  var n = 13.7
  s.writeLine a + b
  s.writeLine a - b
  s.writeLine a * n
  s.writeLine a / n
  a += b
  s.writeLine a
  a -= b
  s.writeLine a
  a *= n
  s.writeLine a
  a /= n
  s.writeLine a

block:
  s.writeLine "# basic vector vec3"
  var a = vec3(1, 2, 3)
  var b = vec3(7, 6, 5)
  var n = 13.7
  s.writeLine a + b
  s.writeLine a - b
  s.writeLine a * n
  s.writeLine a / n
  a += b
  s.writeLine a
  a -= b
  s.writeLine a
  a *= n
  s.writeLine a
  a /= n
  s.writeLine a

block:
  s.writeLine "# basic vector vec4"
  var a = vec4(1, 2, 3, 4)
  var b = vec4(7, 6, 5, 4)
  var n = 13.7
  s.writeLine a + b
  s.writeLine a - b
  s.writeLine a * n
  s.writeLine a / n
  a += b
  s.writeLine a
  a -= b
  s.writeLine a
  a *= n
  s.writeLine a
  a /= n
  s.writeLine a

block:
  s.writeLine "# basic vector mat4"
  var m1 = mat4(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1)
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  assert m1.close(m2)

block:
  s.writeLine "# basic vector mat4 -1"
  var m1 = mat4(
    1, 0, 0, 0,
    0, 0, -1, 0,
    0, 1, 0, 0,
    0, 0, 0, 1)
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  assert m1.close(m2)

block:
  s.writeLine "# Y 90"
  var m1 = rotate(PI/2, vec3(0, 1, 0))
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  assert m1.close(m2)

block:
  s.writeLine "# -Y 90"
  var m1 = rotate(PI/2, vec3(0, -1, 0))
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  assert m1.close(m2)

block:
  s.writeLine "# X 90"
  var m1 = rotate(PI/2, vec3(1, 0, 0))
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  s.writeLine m1.close(m2)

block:
  s.writeLine "# Y 90"
  var m1 = rotate(PI/2, vec3(1, 0, 0))
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  s.writeLine m1.close(m2)

block:
  s.writeLine "# 1,1,1 1.11rad"
  var m1 = rotate(PI*1.11, vec3(1, 1, 1).normalize())
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  assert m1.close(m2)

block:
  s.writeLine "# 1,1,1 1.11rad"
  var m1 = rotate(PI*1.11, vec3(-1, 1, 1).normalize())
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  assert m1.close(m2)

block:
  s.writeLine "# 1,1,1 1.11rad"
  var m1 = rotate(PI*1.11, vec3(-1, 0.34, 1.123).normalize())
  s.writeLine m1
  var q1 = m1.quat()
  s.writeLine q1
  var m2 = q1.mat4()
  s.writeLine m2
  assert m1.close(m2)

block:
  s.writeLine "# super random"
  for i in 0..100:
    var m1 = rotate(
      PI*rand(2.0),
      vec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize()
    )
    s.writeLine m1
    var q1 = m1.quat()
    s.writeLine q1
    var m2 = q1.mat4()
    s.writeLine m2
    assert m1.close(m2)

block:
  s.writeLine "# matrix to quat test"
  # TODO: Fix this test
  # var m1 = mat4(
  #    -0.33089, -0.51266, -0.79227, 0.00000,
  #           0,     -1.0,        0, 0.00000,
  #           0,        0,      1.0, 0.00000,
  #     0.00000,  0.00000,  0.00000, 1.00000)
  # s.writeLine m1
  # var q1 = m1.quat()
  # s.writeLine q1
  # var m2 = q1.mat4()
  # s.writeLine m2
  # assert m1.close(m2)

block:
  s.writeLine "# matrix to quat test"
  # TODO: Fix this test
  # var m1 = mat4(
  #   -0.33089, -0.51266, -0.79227, 0.00000,
  #   -0.44681,  0.82460, -0.34697, 0.00000,
  #   -0.83119, -0.23918,  0.50191, 0.00000,
  #     0.00000,  0.00000,  0.00000, 1.00000)

  # s.writeLine vec3(  -0.33089, -0.51266, -0.79227).length
  # s.writeLine vec3(  -0.44681,  0.82460, -0.34697).length
  # s.writeLine vec3(  -0.83119, -0.23918,  0.50191).length

  # s.writeLine m1
  # var q1 = m1.quat().normalize()
  # s.writeLine q1
  # var m2 = q1.mat4()
  # s.writeLine m2
  # assert m1.close(m2)

block:
  s.writeLine "# matrix to quat test"
  var a3 = mat3(0.9659258723258972, -0.258819043636322, 0.0, 0.258819043636322, 0.9659258723258972, 0.0, -25.00000953674316, 70.09619140625, 1.0)
  var b3 = mat3(0.9659258127212524, 0.258819043636322, 0.0, -0.258819043636322, 0.9659258127212524, 0.0, 77.64571380615234, 0.0, 1.0)

  s.writeLine "Test Mat3 * Mat3:"
  s.writeLine (a3.mat4 * b3.mat4).mat3
  s.writeLine a3 * b3

  s.writeLine (mat3(1,2,3,4,5,6,7,8,9).mat4Rotation * mat3(10,20,30,40,50,60,70,80,90).mat4Rotation).mat3Rotation
  s.writeLine mat3(1,2,3,4,5,6,7,8,9) * mat3(10,20,30,40,50,60,70,80,90)

  s.writeLine "Test Mat3 * Vec2 and Vec3:"
  s.writeLine a3.mat4 * vec3(77.64571380615234, 0, 1)
  s.writeLine a3 * vec2(77.64571380615234, 0)
  s.writeLine a3 * vec3(77.64571380615234, 0, 1.0)

s.close()

let (outp, _) = execCmdEx("git diff tests/test-output.txt")
if len(outp) != 0:
  echo outp
  quit("Output does not match")
