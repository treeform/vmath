import benchy, vmath

echo "new vmath"
var v = vec3(1, 2, 3)
timeIt "+":
  for i in 0 ..< 1_000_000:
    v += vec3(4, 5, 6)

timeIt "-":
  for i in 0 ..< 1_000_000:
    v -= vec3(4, 5, 6)

timeIt "*":
  for i in 0 ..< 1_000_000:
    v *= PI

timeIt "/":
  for i in 0 ..< 1_000_000:
    v /= PI

echo v

# timeIt "matrix mat4":
#   var m = mat4()
#   for i in 0 ..< 10_000:
#     m = m * rotate(0.2.float32, vec3(1, 0, 0)) * scale(vec3(0.3)) * translate(vec3(1))
#   keep m

# timeIt "matrix mat3":
#   var m = mat3()
#   for i in 0 ..< 10_000:
#     m = m * rotate(0.2.float32) * scale(vec2(0.3)) * translate(vec2(1))
#   keep m

# timeIt "matrix quat":
#   var m = rotate(0.2.float32, vec3(1, 0, 0)) * scale(vec3(0.3)) * translate(vec3(1))
#   for i in 0 ..< 100_000:
#     keep m.quat().mat4()

# timeIt "int +":
#   var v = ivec3(1, 2, 3)
#   for i in 0 ..< 1_000_000:
#     keep v + ivec3(4, 5, 6)

# timeIt "int -":
#   var v = ivec3(1, 2, 3)
#   for i in 0 ..< 1_000_000:
#     keep v - ivec3(4, 5, 6)


# new vmath
# name ............................... min time      avg time    std dv   runs
# + .................................. 0.250 ms      0.251 ms    ±0.003  x1000
# - .................................. 0.250 ms      0.251 ms    ±0.003  x1000
# * .................................. 0.250 ms      0.252 ms    ±0.011  x1000
# / .................................. 0.250 ms      0.251 ms    ±0.002  x1000


# old vmath
# name ............................... min time      avg time    std dv   runs
# + .................................. 1.001 ms      1.003 ms    ±0.002  x1000
# - .................................. 1.002 ms      1.009 ms    ±0.021  x1000
# * .................................. 0.250 ms      0.251 ms    ±0.003  x1000
# / .................................. 0.250 ms      0.253 ms    ±0.011  x1000


new vmath
name ............................... min time      avg time    std dv   runs
+ .................................. 1.001 ms      1.002 ms    ±0.001  x1000
- .................................. 1.001 ms      1.002 ms    ±0.001  x1000
* .................................. 1.001 ms      1.004 ms    ±0.004  x1000
/ .................................. 2.753 ms      2.759 ms    ±0.014  x1000

old vmath
name ............................... min time      avg time    std dv   runs
+ .................................. 1.002 ms      1.003 ms    ±0.002  x1000
- .................................. 1.002 ms      1.005 ms    ±0.009  x1000
* .................................. 1.001 ms      1.002 ms    ±0.001  x1000
/ .................................. 2.753 ms      2.757 ms    ±0.004  x1000
