include ../src/vmath, streams

var s = newFileStream("tests/vmathtest.test.txt", fmWrite)

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

s.close()
