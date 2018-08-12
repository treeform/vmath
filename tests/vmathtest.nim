# nim c -r --verbosity:0 test\vmathtest > test\vmathtest.test.txt; dos2unix test\vmathtest.test.txt; git diff test\vmathtest.test.txt

include vmath


randomize(1234)


block:
  echo "--- basic vector vec2"
  var a = vec2(1, 2)
  var b = vec2(7, 6)
  var n = 13.7
  echo a + b
  echo a - b
  echo a * n
  echo a / n
  a += b
  echo a
  a -= b
  echo a
  a *= n
  echo a
  a /= n
  echo a

block:
  echo "--- basic vector vec3"
  var a = vec3(1, 2, 3)
  var b = vec3(7, 6, 5)
  var n = 13.7
  echo a + b
  echo a - b
  echo a * n
  echo a / n
  a += b
  echo a
  a -= b
  echo a
  a *= n
  echo a
  a /= n
  echo a

block:
  echo "--- basic vector vec4"
  var a = vec4(1, 2, 3, 4)
  var b = vec4(7, 6, 5, 4)
  var n = 13.7
  echo a + b
  echo a - b
  echo a * n
  echo a / n
  a += b
  echo a
  a -= b
  echo a
  a *= n
  echo a
  a /= n
  echo a

block:
  echo "---"
  var m1 = mat4(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1)
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)

block:
  echo "---"
  var m1 = mat4(
    1, 0, 0, 0,
    0, 0, -1, 0,
    0, 1, 0, 0,
    0, 0, 0, 1)
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)

block:
  echo "--- Y 90"
  var m1 = rotate(PI/2, vec3(0, 1, 0))
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)

block:
  echo "--- -Y 90"
  var m1 = rotate(PI/2, vec3(0, -1, 0))
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)

block:
  echo "--- X 90"
  var m1 = rotate(PI/2, vec3(1, 0, 0))
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  echo m1.close(m2)

block:
  echo "--- Y 90"
  var m1 = rotate(PI/2, vec3(1, 0, 0))
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  echo m1.close(m2)

block:
  echo "--- 1,1,1 1.11rad"
  var m1 = rotate(PI*1.11, vec3(1, 1, 1).normalize())
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)

block:
  echo "--- 1,1,1 1.11rad"
  var m1 = rotate(PI*1.11, vec3(-1, 1, 1).normalize())
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)


block:
  echo "--- 1,1,1 1.11rad"
  var m1 = rotate(PI*1.11, vec3(-1, 0.34, 1.123).normalize())
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)

block:
  echo "--- super random"
  for i in 0..100:
    var m1 = rotate(PI*rand(2.0), vec3(rand(2.0)-0.5, rand(2.0)-0.5, rand(2.0)-0.5).normalize())
    echo m1
    var q1 = m1.quat()
    echo q1
    var m2 = q1.mat4()
    echo m2
    assert m1.close(m2)

block:
  echo "--- random X"
  var m1 = mat4(
    -0.33089, -0.51266, -0.79227, 0.00000,
            0,     -1.0,        0, 0.00000,
            0,        0,      1.0, 0.00000,
      0.00000,  0.00000,  0.00000, 1.00000)
  echo m1
  var q1 = m1.quat()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)

block:
  echo "--- random"
  var m1 = mat4(
    -0.33089, -0.51266, -0.79227, 0.00000,
    -0.44681,  0.82460, -0.34697, 0.00000,
    -0.83119, -0.23918,  0.50191, 0.00000,
      0.00000,  0.00000,  0.00000, 1.00000)

  echo vec3(  -0.33089, -0.51266, -0.79227).length
  echo vec3(  -0.44681,  0.82460, -0.34697).length
  echo vec3(  -0.83119, -0.23918,  0.50191).length

  echo m1
  var q1 = m1.quat().normalize()
  echo q1
  var m2 = q1.mat4()
  echo m2
  assert m1.close(m2)
