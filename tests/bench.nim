import benchy, vmath

# TODO: I don't trust these simple benchmarks, make a better test.
# echo "new vmath"
# var v = vec3(1, 2, 3)
# timeIt "+":
#   for i in 0 ..< 1_000_000:
#     v += vec3(4, 5, 6)

# timeIt "-":
#   for i in 0 ..< 1_000_000:
#     v -= vec3(4, 5, 6)

# timeIt "*":
#   for i in 0 ..< 1_000_000:
#     v *= PI

# timeIt "/":
#   for i in 0 ..< 1_000_000:
#     v /= PI

# timeIt "int +":
#   var v = ivec3(1, 2, 3)
#   for i in 0 ..< 1_000_000:
#     keep v + ivec3(4, 5, 6)

# timeIt "int -":
#   var v = ivec3(1, 2, 3)
#   for i in 0 ..< 1_000_000:
#     keep v - ivec3(4, 5, 6)

timeIt "matrix mat4":
  var m = mat4()
  for i in 0 ..< 10_000:
    m = m *
      rotate(0.2.float32, vec3(1, 0, 0)) *
      scale(vec3(0.3)) *
      translate(vec3(1))
  keep m

timeIt "matrix mat3":
  var m = mat3()
  for i in 0 ..< 10_000:
    m = m * rotate(0.2.float32) * scale(vec2(0.3)) * translate(vec2(1))
  keep m

timeIt "matrix quat":
  var m = rotate(0.2.float32, vec3(1, 0, 0)) * scale(vec3(0.3)) * translate(vec3(1))
  for i in 0 ..< 100_000:
    keep m.quat().mat4()
