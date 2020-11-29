# VMath

`nimble install vmath`

Collection of math routines for 2d and 3d graphics.

Has functions for Vec2, Vec3, Vec4, Mat3, Mat4 and Quat.

# API: vmath

```nim
import vmath
```

## **func** between

Returns true if value is between min and max or equal to them.

```nim
func between(value, min, max: float32): bool
```

## **func** sign

Returns the sign of a number, -1 or 1.

```nim
func sign(v: float32): float32
```

## **func** quantize

Makes v be multipe of n. Rounding to integer quantize by 1.0.

```nim
func quantize(v: float32; n: float32): float32
```

## **func** lerp

Interpolates value between a and b.
 * 0 -> a
 * 1 -> b
 * 0.5 -> between a and b

```nim
func lerp(a: float32; b: float32; v: float32): float32
```

## **type** Vec2

2D vector

```nim
Vec2 = object
 x*: float32
 y*: float32
```

## **func** vec2


```nim
func vec2(x, y: float32): Vec2
```

## **func** vec2


```nim
func vec2(v: float32): Vec2
```

## **func** vec2


```nim
func vec2(a: Vec2): Vec2
```

## **func** `+`


```nim
func `+`(a: Vec2; b: Vec2): Vec2
```

## **func** `-`


```nim
func `-`(a: Vec2; b: Vec2): Vec2
```

## **func** `*`


```nim
func `*`(a: Vec2; b: float32): Vec2
```

## **func** `*`


```nim
func `*`(a: float32; b: Vec2): Vec2
```

## **func** `/`


```nim
func `/`(a: Vec2; b: float32): Vec2
```

## **func** `+=`


```nim
func `+=`(a: var Vec2; b: Vec2)
```

## **func** `-=`


```nim
func `-=`(a: var Vec2; b: Vec2)
```

## **func** `*=`


```nim
func `*=`(a: var Vec2; b: float32)
```

## **func** `/=`


```nim
func `/=`(a: var Vec2; b: float32)
```

## **func** zero


```nim
func zero(a: var Vec2)
```

## **func** `-`


```nim
func `-`(a: Vec2): Vec2
```

## **func** hash


```nim
func hash(a: Vec2): Hash
```

## **func** lengthSq


```nim
func lengthSq(a: Vec2): float32
```

## **func** length


```nim
func length(a: Vec2): float32
```

## **func** length=


```nim
func length=(a: var Vec2; b: float32)
```

## **func** normalize


```nim
func normalize(a: Vec2): Vec2
```

## **func** dot


```nim
func dot(a: Vec2; b: Vec2): float32
```

## **func** dir


```nim
func dir(at: Vec2; to: Vec2): Vec2
```

## **func** dir


```nim
func dir(th: float32): Vec2
```

## **func** dist


```nim
func dist(at: Vec2; to: Vec2): float32
```

## **func** distSq


```nim
func distSq(at: Vec2; to: Vec2): float32
```

## **func** lerp


```nim
func lerp(a: Vec2; b: Vec2; v: float32): Vec2
```

## **func** quantize


```nim
func quantize(v: Vec2; n: float32): Vec2
```

## **func** inRect

Check to see if v is inside a rectange formed by a and b. It does not matter how a and b are arranged.

```nim
func inRect(v: Vec2; a: Vec2; b: Vec2): bool
```

## **func** `[]`


```nim
func `[]`(a: Vec2; i: int): float32
```

## **func** `[]=`


```nim
func `[]=`(a: var Vec2; i: int; b: float32)
```

## **proc** randVec2


```nim
proc randVec2(): Vec2
```

## **func** `$`


```nim
func `$`(a: Vec2): string {.raises: [ValueError].}
```

## **func** fixAngle

Make angle be from -PI to PI radians.

```nim
func fixAngle(angle: float32): float32
```

## **func** angle

Angle of a Vec2.

```nim
func angle(a: Vec2): float32
```

## **func** angleBetween

Angle between 2 Vec2.

```nim
func angleBetween(a: Vec2; b: Vec2): float32
```

## **func** angleBetween

Angle between angle a and angle b.

```nim
func angleBetween(a, b: float32): float32
```

## **func** turnAngle

Move from angle a to angle b with step of v.

```nim
func turnAngle(a, b, speed: float32): float32
```

## **type** Vec3

3D vector

```nim
Vec3 = object
 x*: float32
 y*: float32
 z*: float32
```

## **func** vec3


```nim
func vec3(x, y, z: float32): Vec3
```

## **func** vec3


```nim
func vec3(v: float32): Vec3
```

## **func** vec3


```nim
func vec3(a: Vec3): Vec3
```

## **const** X_DIR


```nim
X_DIR = (x: 1.0, y: 0.0, z: 0.0)
```

## **const** Y_DIR


```nim
Y_DIR = (x: 0.0, y: 1.0, z: 0.0)
```

## **const** Z_DIR


```nim
Z_DIR = (x: 0.0, y: 0.0, z: 1.0)
```

## **func** `+`


```nim
func `+`(a: Vec3; b: Vec3): Vec3
```

## **func** `-`


```nim
func `-`(a: Vec3; b: Vec3): Vec3
```

## **func** `-`


```nim
func `-`(a: Vec3): Vec3
```

## **func** `*`


```nim
func `*`(a: Vec3; b: float32): Vec3
```

## **func** `*`


```nim
func `*`(a: float32; b: Vec3): Vec3
```

## **func** `/`


```nim
func `/`(a: Vec3; b: float32): Vec3
```

## **func** `/`


```nim
func `/`(a: float32; b: Vec3): Vec3
```

## **func** `+=`


```nim
func `+=`(a: var Vec3; b: Vec3)
```

## **func** `-=`


```nim
func `-=`(a: var Vec3; b: Vec3)
```

## **func** `*=`


```nim
func `*=`(a: var Vec3; b: float32)
```

## **func** `/=`


```nim
func `/=`(a: var Vec3; b: float32)
```

## **func** zero


```nim
func zero(a: var Vec3)
```

## **func** `-`


```nim
func `-`(a: var Vec3): Vec3
```

## **func** hash


```nim
func hash(a: Vec3): Hash
```

## **func** lengthSq


```nim
func lengthSq(a: Vec3): float32
```

## **func** length


```nim
func length(a: Vec3): float32
```

## **func** length=


```nim
func length=(a: var Vec3; b: float32)
```

## **func** floor


```nim
func floor(a: Vec3): Vec3
```

## **func** round


```nim
func round(a: Vec3): Vec3
```

## **func** ceil


```nim
func ceil(a: Vec3): Vec3
```

## **func** normalize


```nim
func normalize(a: Vec3): Vec3
```

## **func** cross


```nim
func cross(a: Vec3; b: Vec3): Vec3
```

## **func** computeNormal


```nim
func computeNormal(a, b, c: Vec3): Vec3
```

## **func** dot


```nim
func dot(a: Vec3; b: Vec3): float32
```

## **func** dir


```nim
func dir(at: Vec3; to: Vec3): Vec3
```

## **func** dist


```nim
func dist(at: Vec3; to: Vec3): float32
```

## **func** distSq


```nim
func distSq(at: Vec3; to: Vec3): float32
```

## **func** lerp


```nim
func lerp(a: Vec3; b: Vec3; v: float32): Vec3
```

## **func** quantize


```nim
func quantize(v: Vec3; n: float32): Vec3
```

## **func** angleBetween


```nim
func angleBetween(a, b: Vec3): float32
```

## **func** `[]`


```nim
func `[]`(a: Vec3; i: int): float32
```

## **func** `[]=`


```nim
func `[]=`(a: var Vec3; i: int; b: float32)
```

## **func** xy


```nim
func xy(a: Vec3): Vec2
```

## **func** xz


```nim
func xz(a: Vec3): Vec2
```

## **func** yx


```nim
func yx(a: Vec3): Vec2
```

## **func** yz


```nim
func yz(a: Vec3): Vec2
```

## **func** zx


```nim
func zx(a: Vec3): Vec2
```

## **func** zy


```nim
func zy(a: Vec3): Vec2
```

## **func** almostEquals


```nim
func almostEquals(a, b: Vec3; precision = 1e-006): bool
```

## **proc** randVec3

Generates a random unit vector based on <a class="reference external" href="http://mathworld.wolfram.com/SpherePointPicking.html">http://mathworld.wolfram.com/SpherePointPicking.html</a>

```nim
proc randVec3(): Vec3
```

## **func** `$`


```nim
func `$`(a: Vec3): string {.raises: [ValueError].}
```

## **type** Vec4

4D Vector.

```nim
Vec4 = object
 x*: float32
 y*: float32
 z*: float32
 w*: float32
```

## **func** vec4


```nim
func vec4(x, y, z, w: float32): Vec4
```

## **func** vec4


```nim
func vec4(v: float32): Vec4
```

## **func** `+`


```nim
func `+`(a: Vec4; b: Vec4): Vec4
```

## **func** `-`


```nim
func `-`(a: Vec4; b: Vec4): Vec4
```

## **func** `-`


```nim
func `-`(a: Vec4): Vec4
```

## **func** `*`


```nim
func `*`(a: Vec4; b: float32): Vec4
```

## **func** `*`


```nim
func `*`(a: float32; b: Vec4): Vec4
```

## **func** `/`


```nim
func `/`(a: Vec4; b: float32): Vec4
```

## **func** `/`


```nim
func `/`(a: float32; b: Vec4): Vec4
```

## **func** `+=`


```nim
func `+=`(a: var Vec4; b: Vec4)
```

## **func** `-=`


```nim
func `-=`(a: var Vec4; b: Vec4)
```

## **func** `*=`


```nim
func `*=`(a: var Vec4; b: float32)
```

## **func** `/=`


```nim
func `/=`(a: var Vec4; b: float32)
```

## **func** zero


```nim
func zero(a: var Vec4)
```

## **func** hash


```nim
func hash(a: Vec4): Hash
```

## **func** `[]`


```nim
func `[]`(a: Vec4; i: int): float32
```

## **func** `[]=`


```nim
func `[]=`(a: var Vec4; i: int; b: float32)
```

## **func** lerp


```nim
func lerp(a: Vec4; b: Vec4; v: float32): Vec4
```

## **func** xyz


```nim
func xyz(a: Vec4): Vec3
```

## **func** `$`


```nim
func `$`(a: Vec4): string {.raises: [ValueError].}
```

## **func** vec3


```nim
func vec3(a: Vec2; z = 0.0): Vec3
```

## **func** vec4


```nim
func vec4(a: Vec3; w = 0.0): Vec4
```

## **func** vec4


```nim
func vec4(a: Vec2; z = 0.0; w = 0.0): Vec4
```

## **type** Mat3

3x3 Matrix

```nim
Mat3 = array[9, float32]
```

## **template** `[]`


```nim
template `[]`(a: Mat3; i, j: int): float32
```

## **template** `[]=`


```nim
template `[]=`(a: Mat3; i, j: int; v: float32)
```

## **func** mat3


```nim
func mat3(a, b, c, d, e, f, g, h, i: float32): Mat3
```

## **func** mat3


```nim
func mat3(a: Mat3): Mat3
```

## **func** identity


```nim
func identity(a: var Mat3)
```

## **func** mat3


```nim
func mat3(): Mat3
```

## **func** transpose


```nim
func transpose(a: Mat3): Mat3
```

## **func** `$`


```nim
func `$`(a: Mat3): string {.raises: [ValueError].}
```

## **func** `*`


```nim
func `*`(a: Mat3; b: Mat3): Mat3
```

## **func** scale


```nim
func scale(a: Mat3; v: Vec2): Mat3
```

## **func** scale


```nim
func scale(a: Mat3; v: Vec3): Mat3
```

## **func** translate


```nim
func translate(v: Vec2): Mat3
```

## **func** scale


```nim
func scale(v: Vec2): Mat3
```

## **func** rotationMat3


```nim
func rotationMat3(angle: float32): Mat3
```

## **func** rotate


```nim
func rotate(a: Mat3; angle: float32): Mat3
```

## **func** `*`


```nim
func `*`(a: Mat3; b: Vec2): Vec2
```

## **func** `*`


```nim
func `*`(a: Mat3; b: Vec3): Vec3
```

## **func** inverse


```nim
func inverse(a: Mat3): Mat3
```

## **type** Mat4

4x4 Matrix - OpenGL row order

```nim
Mat4 = array[16, float32]
```

## **template** `[]`


```nim
template `[]`(a: Mat4; i, j: int): float32
```

## **template** `[]=`


```nim
template `[]=`(a: Mat4; i, j: int; v: float32)
```

## **func** mat4


```nim
func mat4(v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15: float32): Mat4
```

## **func** mat4


```nim
func mat4(a: Mat4): Mat4
```

## **func** identity


```nim
func identity(): Mat4
```

## **func** mat4


```nim
func mat4(): Mat4
```

## **func** transpose


```nim
func transpose(a: Mat4): Mat4
```

## **func** determinant


```nim
func determinant(a: Mat4): float32
```

## **func** inverse


```nim
func inverse(a: Mat4): Mat4
```

## **func** `*`


```nim
func `*`(a, b: Mat4): Mat4
```

## **func** `*`


```nim
func `*`(a: Mat4; b: Vec3): Vec3
```

## **func** `*`


```nim
func `*`(a: Mat4; b: Vec4): Vec4
```

## **func** right


```nim
func right(a: Mat4): Vec3
```

## **func** right=


```nim
func right=(a: var Mat4; b: Vec3)
```

## **func** up


```nim
func up(a: Mat4): Vec3
```

## **func** up=


```nim
func up=(a: var Mat4; b: Vec3)
```

## **func** forward


```nim
func forward(a: Mat4): Vec3
```

## **func** forward=


```nim
func forward=(a: var Mat4; b: Vec3)
```

## **func** pos


```nim
func pos(a: Mat4): Vec3
```

## **func** pos=


```nim
func pos=(a: var Mat4; b: Vec3)
```

## **func** rotationOnly


```nim
func rotationOnly(a: Mat4): Mat4
```

## **func** dist


```nim
func dist(a, b: Mat4): float32
```

## **func** translate


```nim
func translate(v: Vec3): Mat4
```

## **func** scale


```nim
func scale(v: Vec3): Mat4
```

## **func** close


```nim
func close(a: Mat4; b: Mat4): bool
```

## **func** hrp


```nim
func hrp(m: Mat4): Vec3
```

## **func** frustum


```nim
func frustum(left, right, bottom, top, near, far: float32): Mat4
```

## **func** perspective


```nim
func perspective(fovy, aspect, near, far: float32): Mat4
```

## **func** ortho


```nim
func ortho(left, right, bottom, top, near, far: float32): Mat4
```

## **func** lookAt


```nim
func lookAt(eye, center, up: Vec3): Mat4
```

## **func** mat3

Gets rotation and translation, ignoring z coordinates.

```nim
func mat3(m: Mat4): Mat3
```

## **func** mat3Rotation

Gets the rotational part of the 4x4 matrix.

```nim
func mat3Rotation(m: Mat4): Mat3
```

## **func** mat4

Takes a 2d Mat3 with position and converts to a 3d matrix.

```nim
func mat4(m: Mat3): Mat4
```

## **func** mat4Rotation

Gets the rotational part of the 3x3 matrix into a 4x4 matrix.

```nim
func mat4Rotation(m: Mat3): Mat4
```

## **func** `$`


```nim
func `$`(a: Mat4): string {.raises: [ValueError].}
```

## **type** Quat


```nim
Quat = object
 x*: float32
 y*: float32
 z*: float32
 w*: float32
```

## **func** quat


```nim
func quat(x, y, z, w: float32): Quat
```

## **func** conjugate


```nim
func conjugate(q: Quat): Quat
```

## **func** length


```nim
func length(q: Quat): float32
```

## **func** normalize


```nim
func normalize(q: Quat): Quat
```

## **func** xyz


```nim
func xyz(q: Quat): Vec3
```

## **func** xyz=


```nim
func xyz=(q: var Quat; v: Vec3)
```

## **func** `-`


```nim
func `-`(a: var Quat): Quat
```

## **func** `+`


```nim
func `+`(a: Quat; b: Quat): Quat
```

## **func** `*`

Multiply the quaternion by a quaternion.

```nim
func `*`(a, b: Quat): Quat
```

## **func** `*`

Multiply the quaternion by a float32.

```nim
func `*`(q: Quat; v: float32): Quat
```

## **func** `*`

Multiply the quaternion by a vector.

```nim
func `*`(q: Quat; v: Vec3): Vec3
```

## **func** `[]=`


```nim
func `[]=`(a: var Quat; i: int; b: float32)
```

## **func** mat3


```nim
func mat3(q: Quat): Mat3
```

## **func** mat4


```nim
func mat4(q: Quat): Mat4
```

## **func** recifuncalSqrt


```nim
func recifuncalSqrt(x: float32): float32
```

## **proc** quat


```nim
proc quat(m: Mat4): Quat
```

## **func** fromAxisAngle


```nim
func fromAxisAngle(axis: Vec3; angle: float32): Quat
```

## **func** toAxisAngle


```nim
func toAxisAngle(q: Quat; axis: var Vec3; angle: var float32)
```

## **func** quat


```nim
func quat(heading, pitch, roll: float32): Quat
```

## **func** quat


```nim
func quat(hpr: Vec3): Quat
```

## **func** hrp


```nim
func hrp(q: Quat): Vec3
```

## **func** dot


```nim
func dot(a: Quat; b: Quat): float32
```

## **func** nlerp


```nim
func nlerp(a: Quat; b: Quat; v: float32): Quat
```

## **func** `$`


```nim
func `$`(a: Quat): string {.raises: [ValueError].}
```

## **func** rotate


```nim
func rotate(angle: float32; axis: Vec3): Mat4
```

## **func** rotateX


```nim
func rotateX(angle: float32): Mat4
```

## **func** rotateY


```nim
func rotateY(angle: float32): Mat4
```

## **func** rotateZ


```nim
func rotateZ(angle: float32): Mat4
```

## **func** scaleMat


```nim
func scaleMat(scale: Vec3): Mat4
```

## **func** scaleMat


```nim
func scaleMat(scale: float32): Mat4
```

## **type** Rect


```nim
Rect = object
 x*: float32
 y*: float32
 w*: float32
 h*: float32
```

## **func** rect


```nim
func rect(x, y, w, h: float32): Rect
```

## **func** rect


```nim
func rect(pos, size: Vec2): Rect
```

## **func** xy

Gets the xy as a Vec2.

```nim
func xy(rect: Rect): Vec2
```

## **func** xy=

Sets the xy from Vec2.

```nim
func xy=(rect: var Rect; v: Vec2)
```

## **func** wh

Gets the wh as a Vec2.

```nim
func wh(rect: Rect): Vec2
```

## **func** wh=

Sets the wh from Vec2.

```nim
func wh=(rect: var Rect; v: Vec2)
```

## **func** `*`

* all elements of a Rect.

```nim
func `*`(r: Rect; v: float): Rect
```

## **func** `/`

/ all elements of a Rect.

```nim
func `/`(r: Rect; v: float): Rect
```

## **func** `+`

Add two boxes together.

```nim
func `+`(a, b: Rect): Rect
```

## **func** `$`


```nim
func `$`(a: Rect): string {.raises: [ValueError].}
```

## **func** inside

Checks if pos is inside rect.

```nim
func inside(pos: Vec2; rect: Rect): bool
```

## **func** overlap

Returns true if box a overlaps box b.

```nim
func overlap(a, b: Rect): bool
```

## **proc** `or`

Union of two rectangles.

```nim
proc `or`(a, b: Rect): Rect
```

## **proc** `and`

Intersection of two rectangles.

```nim
proc `and`(a, b: Rect): Rect
```
