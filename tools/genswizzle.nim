import strformat

var swizzles = @["xyzw", "rgba", "stpq"]

echo "# Generated by tools/gensswizzle"

for swizzle in swizzles[1 .. ^1]:
  echo "\n# 1 x ", swizzle
  for i1, s1 in swizzle:
    echo &"template {s1}*[T](a: GVec234[T]): T = a[{i1}]"
    echo &"func `{s1}=`*[T](a: var GVec234[T], b: T) = a[{i1}] = b"

for swizzle in swizzles:
  echo "\n# 2 x ", swizzle
  for i1, s1 in swizzle:
    for i2, s2 in swizzle:
      echo &"template {s1}{s2}*[T](a: GVec234[T]): GVec2[T] ="
      echo &"  gvec2(a[{i1}], a[{i2}])"
      echo &"template `{s1}{s2}=`*[T](a: var GVec234[T], b: GVec2[T]) ="
      echo &"  let x = b.x; let y = b.y"
      echo &"  a[0{i1}] = x; a[{i2}] = y"

for swizzle in swizzles:
  echo "\n# 3 x ", swizzle
  for i1, s1 in swizzle:
    for i2, s2 in swizzle:
      for i3, s3 in swizzle:
        echo &"template {s1}{s2}{s3}*[T](a: GVec234[T]): GVec3[T] ="
        echo &"  gvec3(a[{i1}], a[{i2}], a[{i3}])"
        echo &"template `{s1}{s2}{s3}=`*[T](a: var GVec234[T], b: GVec3[T]) ="
        echo &"  let x = b.x; let y = b.y; let z = b.z"
        echo &"  a[{i1}] = x; a[{i2}] = y; a[{i3}] = z"

for swizzle in swizzles:
  echo "\n# 4 x ", swizzle
  for i1, s1 in swizzle:
    for i2, s2 in swizzle:
      for i3, s3 in swizzle:
        for i4, s4 in swizzle:
          echo &"template {s1}{s2}{s3}{s4}*[T](a: GVec234[T]): GVec4[T] ="
          echo &"  gvec4(a [{i1}], a[{i2}], a[{i3}], a[{i4}])"
          echo &"template `{s1}{s2}{s3}{s4}=`*[T](a: var GVec234[T], b: GVec4[T]) ="
          echo &"  let x = b.x; let y = b.y; let z = b.z; let w = b.w"
          echo &"  a[{i1}] = x; a[{i2}] = y; a[{i3}] = z; a[{i4}] = w"
