import benchy

type
  Vec3Obj = object
    x, y, z: float32

  Vec3Arr = array[3, float32]

  Vec3ObjArr = object
    arr: array[3, float32]

  Vec3Tuple = tuple[x: float32, y: float32, z: float32]

proc vec3Obj(x, y, z: float32): Vec3Obj {.inline.} =
  Vec3Obj(x: x, y: y, z: z)

proc vec3Arr(x, y, z: float32): Vec3Arr {.inline.} =
  [x, y, z]

proc vec3ObjArr(x, y, z: float32): Vec3ObjArr {.inline.} =
  Vec3ObjArr(arr: [x, y, z])

proc vec3Tuple(x, y, z: float32): Vec3Tuple {.inline.} =
  (x, y, z)

timeIt "create vec3Obj", 1000:
  var s = newSeq[Vec3Obj](100000)
  for i in 0 ..< 100000:
    s[i] = vec3Obj(i.float32, 0, 0)
  keep s

timeIt "create vec3Arr", 1000:
  var s = newSeq[Vec3Arr](100000)
  for i in 0 ..< 100000:
    s[i] = vec3Arr(i.float32, 0, 0)
  keep s

timeIt "create vec3ObjArr", 1000:
  var s = newSeq[Vec3ObjArr](100000)
  for i in 0 ..< 100000:
    s[i] = vec3ObjArr(i.float32, 0, 0)
  keep s

timeIt "create vec3Tuple", 1000:
  var s = newSeq[Vec3Tuple](100000)
  for i in 0 ..< 100000:
    s[i] = vec3Tuple(i.float32, 0, 0)
  keep s

echo "..."

proc `[]`(a: Vec3Arr, i: int): float32 {.inline.} =
  cast[array[3, float32]](a)[i]

proc `[]`(a: Vec3Obj, i: int): float32 {.inline.} =
  cast[array[3, float32]](a)[i]

proc `[]`(a: Vec3ObjArr, i: int): float32 {.inline.} =
  a.arr[i]

proc get(a: Vec3Tuple, i: int): float32 {.inline.} =
  cast[array[3, float32]](a)[i]

timeIt "vec3Obj[static]", 1000:
  var v = vec3Obj(1, 2, 3)
  for i in 0 .. 1000000:
    keep v[0]
    keep v[1]
    keep v[2]

timeIt "vec3Arr[static]", 1000:
  var v = vec3Arr(1, 2, 3)
  for i in 0 .. 1000000:
    keep v[0]
    keep v[1]
    keep v[2]

timeIt "vec3ObjArr[static]", 1000:
  var v = vec3ObjArr(1, 2, 3)
  for i in 0 .. 1000000:
    keep v[0]
    keep v[1]
    keep v[2]

timeIt "vec3Tuple[static]", 1000:
  var v = vec3Tuple(1, 2, 3)
  for i in 0 .. 1000000:
    keep v[0]
    keep v[1]
    keep v[2]

echo "..."

timeIt "vec3Obj[]", 1000:
  var v = vec3Obj(1, 2, 3)
  for i in 0 .. 1000000:
    keep v[i mod 3]

timeIt "vec3Arr[]", 1000:
  var v = vec3Arr(1, 2, 3)
  for i in 0 .. 1000000:
    keep v[i mod 3]

timeIt "vec3ObjArr[]", 1000:
  var v = vec3ObjArr(1, 2, 3)
  for i in 0 .. 1000000:
    keep v[i mod 3]

timeIt "vec3Tuple[]", 1000:
  var v = vec3Tuple(1, 2, 3)
  for i in 0 .. 1000000:
    keep v.get(i mod 3)

echo "..."

proc `x`(a: Vec3Arr): float32 {.inline.} = a[0]
proc `y`(a: Vec3Arr): float32 {.inline.} = a[1]
proc `z`(a: Vec3Arr): float32 {.inline.} = a[2]

proc `x`(a: Vec3ObjArr): float32 {.inline.} = a.arr[0]
proc `y`(a: Vec3ObjArr): float32 {.inline.} = a.arr[1]
proc `z`(a: Vec3ObjArr): float32 {.inline.} = a.arr[2]

timeIt "vec3Obj.xyz", 1000:
  var v = vec3Obj(1, 2, 3)
  for i in 0 .. 1000000:
    keep v.x
    keep v.y
    keep v.z

timeIt "vec3Arr.xyz", 1000:
  var v = vec3Arr(1, 2, 3)
  for i in 0 .. 1000000:
    keep v.x
    keep v.y
    keep v.z

timeIt "vec3ObjArr.xyz", 1000:
  var v = vec3ObjArr(1, 2, 3)
  for i in 0 .. 1000000:
    keep v.x
    keep v.y
    keep v.z

timeIt "vec3Tuple.xyz", 1000:
  var v = vec3Tuple(1, 2, 3)
  for i in 0 .. 1000000:
    keep v.x
    keep v.y
    keep v.z

echo "..."

proc `[]=`(a: var Vec3Obj, i: int, v: float32) {.inline.} =
  cast[ptr float32](cast[uint64](a.addr) + i.uint64 * sizeof(float32).uint64)[] = v

proc `[]=`(a: var Vec3ObjArr, i: int, v: float32) {.inline.} =
  a.arr[i] = v

proc set(a: var Vec3Tuple, i: int, v: float32) {.inline.} =
  cast[ptr float32](cast[uint64](a.addr) + i.uint64 * sizeof(float32).uint64)[] = v

timeIt "vec3Obj[static]=", 1000:
  var v = vec3Obj(1, 2, 3)
  for i in 0 .. 1000000:
    v[0] = i.float32
    v[1] = i.float32
    v[2] = i.float32
    keep v

timeIt "vec3Arr[static]=", 1000:
  var v = vec3Arr(1, 2, 3)
  for i in 0 .. 1000000:
    v[0] = i.float32
    v[1] = i.float32
    v[2] = i.float32
    keep v

timeIt "vec3ObjArr[static]=", 1000:
  var v = vec3ObjArr(1, 2, 3)
  for i in 0 .. 1000000:
    v[0] = i.float32
    v[1] = i.float32
    v[2] = i.float32
    keep v

timeIt "vec3Tuple[static]=", 1000:
  var v = vec3Tuple(1, 2, 3)
  for i in 0 .. 1000000:
    v[0] = i.float32
    v[1] = i.float32
    v[2] = i.float32
    keep v

echo "..."

proc `x=`(a: var Vec3Arr, v: float32) {.inline.} = a[0] = v
proc `y=`(a: var Vec3Arr, v: float32) {.inline.} = a[1] = v
proc `z=`(a: var Vec3Arr, v: float32) {.inline.} = a[2] = v

proc `x=`(a: var Vec3ObjArr, v: float32) {.inline.} = a.arr[0] = v
proc `y=`(a: var Vec3ObjArr, v: float32) {.inline.} = a.arr[1] = v
proc `z=`(a: var Vec3ObjArr, v: float32) {.inline.} = a.arr[2] = v

timeIt "vec3Obj.xyz=", 1000:
  var v = vec3Obj(1, 2, 3)
  for i in 0 .. 1000000:
    v.x = i.float32
    v.y = i.float32
    v.z = i.float32
    keep v

timeIt "vec3Arr.xyz=", 1000:
  var v = vec3Arr(1, 2, 3)
  for i in 0 .. 1000000:
    v.x = i.float32
    v.y = i.float32
    v.z = i.float32
    keep v

timeIt "vec3ObjArr.xyz=", 1000:
  var v = vec3ObjArr(1, 2, 3)
  for i in 0 .. 1000000:
    v.x = i.float32
    v.y = i.float32
    v.z = i.float32
    keep v

timeIt "vec3Tuple.xyz=", 1000:
  var v = vec3Tuple(1, 2, 3)
  for i in 0 .. 1000000:
    v.x = i.float32
    v.y = i.float32
    v.z = i.float32
    keep v

echo "..."

timeIt "vec3Obj[]=", 1000:
  var v = vec3Obj(1, 2, 3)
  for i in 0 .. 1000000:
    v[i mod 3] = i.float32
    keep v

timeIt "vec3Arr[]=", 1000:
  var v = vec3Arr(1, 2, 3)
  for i in 0 .. 1000000:
    v[i mod 3] = i.float32
    keep v

timeIt "vec3ObjArr[]=", 1000:
  var v = vec3ObjArr(1, 2, 3)
  for i in 0 .. 1000000:
    v[i mod 3] = i.float32
    keep v

timeIt "vec3Tuple[]=", 1000:
  var v = vec3Tuple(1, 2, 3)
  for i in 0 .. 1000000:
    v.set(i mod 3, i.float32)
    keep v
