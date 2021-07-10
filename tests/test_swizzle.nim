import vmath

block:
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
