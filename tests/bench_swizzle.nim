import benchy, vmath

block:
  var
    a = vec2(1, 10)
    b = vec2(2, 20)
    c = vec2(3, 30)
  timeIt "xy":
    for i in 0 ..< 1_000_000:
      c.yx = a.xy + b.rg + c.xy
  echo c.xy

block:
  var
    a = vec3(1, 10, 100)
    b = vec3(2, 20, 200)
    c = vec3(3, 30, 300)
  timeIt "xyz":
    for i in 0 ..< 1_000_000:
      c.zyx = a.xyz + b.rgb + c.xyz
  echo c.xyz

block:
  var
    a = vec4(1, 10, 100, -1)
    b = vec4(2, 20, 200, -1)
    c = vec4(3, 30, 300, -1)
  timeIt "xyzw":
    for i in 0 ..< 1_000_000:
      c.wzyx = a.xyzw + b.rgba + c.xyzw
  echo c.xyzw
