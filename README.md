# VMath

`nimble install vmath`

Collection of math routines for 2d and 3d graphics.

Has functions for Vec2, Vec3, Vec4, Mat3, Mat4 and Quat.

# API: vmath

```nim
import vmath
```

## **proc** between

Returns true if value is between min and max or equal to them.

```nim
proc between(value, min, max: float32): bool {.inline.}
```

## **proc** sign

Returns the sign of a number, -1 or 1.

```nim
proc sign(v: float32): float32 {.inline.}
```

## **proc** quantize

Makes v be multipe of n. Rounding to integer quantize by 1.0.

```nim
proc quantize(v, n: float32): float32 {.inline.}
```

## **proc** lerp

Interpolates value between a and b.
 * 0 -> a
 * 1 -> b
 * 0.5 -> between a and b

```nim
proc lerp(a, b, v: float32): float32 {.inline.}
```

## **proc** fixAngle

Make angle be from -PI to PI radians.

```nim
proc fixAngle(angle: float32): float32
```

## **proc** angleBetween

Angle between angle a and angle b.

```nim
proc angleBetween(a, b: float32): float32 {.inline.}
```

## **proc** turnAngle

Move from angle a to angle b with step of v.

```nim
proc turnAngle(a, b, speed: float32): float32
```

## **type** Vec2

2D vector

```nim
Vec2 = object
 x*: float32
 y*: float32
```

## **proc** vec2


```nim
proc vec2(x, y: float32): Vec2 {.inline.}
```

## **proc** vec2


```nim
proc vec2(v: float32): Vec2 {.inline.}
```

## **proc** vec2


```nim
proc vec2(a: Vec2): Vec2 {.inline.}
```

## **proc** `+`


```nim
proc `+`(a, b: Vec2): Vec2 {.inline.}
```

## **proc** `-`


```nim
proc `-`(a, b: Vec2): Vec2 {.inline.}
```

## **proc** `*`


```nim
proc `*`(a: Vec2; b: float32): Vec2 {.inline.}
```

## **proc** `*`


```nim
proc `*`(a: float32; b: Vec2): Vec2 {.inline.}
```

## **proc** `/`


```nim
proc `/`(a: Vec2; b: float32): Vec2 {.inline.}
```

## **proc** `+=`


```nim
proc `+=`(a: var Vec2; b: Vec2) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`(a: var Vec2; b: Vec2) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`(a: var Vec2; b: float32) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`(a: var Vec2; b: float32) {.inline.}
```

## **proc** zero


```nim
proc zero(a: var Vec2) {.inline.}
```

## **proc** `-`


```nim
proc `-`(a: Vec2): Vec2 {.inline.}
```

## **proc** hash


```nim
proc hash(a: Vec2): Hash {.inline.}
```

## **proc** lengthSq


```nim
proc lengthSq(a: Vec2): float32 {.inline.}
```

## **proc** length


```nim
proc length(a: Vec2): float32 {.inline.}
```

## **proc** length=


```nim
proc length=(a: var Vec2; b: float32) {.inline.}
```

## **proc** normalize


```nim
proc normalize(a: Vec2): Vec2 {.inline.}
```

## **proc** dot


```nim
proc dot(a, b: Vec2): float32 {.inline.}
```

## **proc** dir


```nim
proc dir(at, to: Vec2): Vec2 {.inline.}
```

## **proc** dir


```nim
proc dir(th: float32): Vec2 {.inline.}
```

## **proc** dist


```nim
proc dist(at, to: Vec2): float32 {.inline.}
```

## **proc** distSq


```nim
proc distSq(at, to: Vec2): float32 {.inline.}
```

## **proc** lerp


```nim
proc lerp(a, b: Vec2; v: float32): Vec2 {.inline.}
```

## **proc** quantize


```nim
proc quantize(v: Vec2; n: float32): Vec2 {.inline.}
```

## **proc** inRect

Check to see if v is inside a rectange formed by a and b. It does not matter how a and b are arranged.

```nim
proc inRect(v, a, b: Vec2): bool {.inline.}
```

## **proc** `[]`


```nim
proc `[]`(a: Vec2; i: int): float32
```

## **proc** `[]=`


```nim
proc `[]=`(a: var Vec2; i: int; b: float32)
```

## **proc** randVec2


```nim
proc randVec2(r: var Rand): Vec2
```

## **proc** `$`


```nim
proc `$`(a: Vec2): string {.raises: [ValueError].}
```

## **proc** angle

Angle of a Vec2.

```nim
proc angle(a: Vec2): float32 {.inline.}
```

## **proc** angleBetween

Angle between 2 Vec2.

```nim
proc angleBetween(a: Vec2; b: Vec2): float32 {.inline.}
```

## **type** Vec3

3D vector

```nim
Vec3 = object
 x*: float32
 y*: float32
 z*: float32
```

## **proc** vec3


```nim
proc vec3(x, y, z: float32): Vec3 {.inline.}
```

## **proc** vec3


```nim
proc vec3(v: float32): Vec3 {.inline.}
```

## **proc** vec3


```nim
proc vec3(a: Vec3): Vec3 {.inline.}
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

## **proc** `+`


```nim
proc `+`(a, b: Vec3): Vec3 {.inline.}
```

## **proc** `-`


```nim
proc `-`(a, b: Vec3): Vec3 {.inline.}
```

## **proc** `-`


```nim
proc `-`(a: Vec3): Vec3 {.inline.}
```

## **proc** `*`


```nim
proc `*`(a: Vec3; b: float32): Vec3 {.inline.}
```

## **proc** `*`


```nim
proc `*`(a: float32; b: Vec3): Vec3 {.inline.}
```

## **proc** `/`


```nim
proc `/`(a: Vec3; b: float32): Vec3 {.inline.}
```

## **proc** `/`


```nim
proc `/`(a: float32; b: Vec3): Vec3 {.inline.}
```

## **proc** `+=`


```nim
proc `+=`(a: var Vec3; b: Vec3) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`(a: var Vec3; b: Vec3) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`(a: var Vec3; b: float32) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`(a: var Vec3; b: float32) {.inline.}
```

## **proc** zero


```nim
proc zero(a: var Vec3) {.inline.}
```

## **proc** `-`


```nim
proc `-`(a: var Vec3): Vec3 {.inline.}
```

## **proc** hash


```nim
proc hash(a: Vec3): Hash {.inline.}
```

## **proc** lengthSq


```nim
proc lengthSq(a: Vec3): float32 {.inline.}
```

## **proc** length


```nim
proc length(a: Vec3): float32 {.inline.}
```

## **proc** length=


```nim
proc length=(a: var Vec3; b: float32) {.inline.}
```

## **proc** floor


```nim
proc floor(a: Vec3): Vec3 {.inline.}
```

## **proc** round


```nim
proc round(a: Vec3): Vec3 {.inline.}
```

## **proc** ceil


```nim
proc ceil(a: Vec3): Vec3 {.inline.}
```

## **proc** normalize


```nim
proc normalize(a: Vec3): Vec3 {.inline.}
```

## **proc** cross


```nim
proc cross(a, b: Vec3): Vec3 {.inline.}
```

## **proc** computeNormal


```nim
proc computeNormal(a, b, c: Vec3): Vec3
```

## **proc** dot


```nim
proc dot(a, b: Vec3): float32 {.inline.}
```

## **proc** dir


```nim
proc dir(at, to: Vec3): Vec3 {.inline.}
```

## **proc** dist


```nim
proc dist(at, to: Vec3): float32 {.inline.}
```

## **proc** distSq


```nim
proc distSq(at, to: Vec3): float32 {.inline.}
```

## **proc** lerp


```nim
proc lerp(a, b: Vec3; v: float32): Vec3 {.inline.}
```

## **proc** quantize


```nim
proc quantize(v: Vec3; n: float32): Vec3
```

## **proc** angleBetween


```nim
proc angleBetween(a, b: Vec3): float32
```

## **proc** `[]`


```nim
proc `[]`(a: Vec3; i: int): float32
```

## **proc** `[]=`


```nim
proc `[]=`(a: var Vec3; i: int; b: float32)
```

## **proc** xy


```nim
proc xy(a: Vec3): Vec2 {.inline.}
```

## **proc** xz


```nim
proc xz(a: Vec3): Vec2 {.inline.}
```

## **proc** yx


```nim
proc yx(a: Vec3): Vec2 {.inline.}
```

## **proc** yz


```nim
proc yz(a: Vec3): Vec2 {.inline.}
```

## **proc** zx


```nim
proc zx(a: Vec3): Vec2 {.inline.}
```

## **proc** zy


```nim
proc zy(a: Vec3): Vec2 {.inline.}
```

## **proc** almostEquals


```nim
proc almostEquals(a, b: Vec3; precision = 1e-006): bool {.inline, tags: [].}
```

## **proc** randVec3

Generates a random unit vector based on <a class="reference external" href="http://mathworld.wolfram.com/SpherePointPicking.html">http://mathworld.wolfram.com/SpherePointPicking.html</a>

```nim
proc randVec3(r: var Rand): Vec3
```

## **proc** `$`


```nim
proc `$`(a: Vec3): string {.raises: [ValueError].}
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

## **proc** vec4


```nim
proc vec4(x, y, z, w: float32): Vec4 {.inline.}
```

## **proc** vec4


```nim
proc vec4(v: float32): Vec4 {.inline.}
```

## **proc** `+`


```nim
proc `+`(a, b: Vec4): Vec4 {.inline.}
```

## **proc** `-`


```nim
proc `-`(a, b: Vec4): Vec4 {.inline.}
```

## **proc** `-`


```nim
proc `-`(a: Vec4): Vec4 {.inline.}
```

## **proc** `*`


```nim
proc `*`(a: Vec4; b: float32): Vec4 {.inline.}
```

## **proc** `*`


```nim
proc `*`(a: float32; b: Vec4): Vec4 {.inline.}
```

## **proc** `/`


```nim
proc `/`(a: Vec4; b: float32): Vec4 {.inline.}
```

## **proc** `/`


```nim
proc `/`(a: float32; b: Vec4): Vec4 {.inline.}
```

## **proc** `+=`


```nim
proc `+=`(a: var Vec4; b: Vec4) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`(a: var Vec4; b: Vec4) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`(a: var Vec4; b: float32) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`(a: var Vec4; b: float32) {.inline.}
```

## **proc** zero


```nim
proc zero(a: var Vec4) {.inline.}
```

## **proc** hash


```nim
proc hash(a: Vec4): Hash {.inline.}
```

## **proc** `[]`


```nim
proc `[]`(a: Vec4; i: int): float32
```

## **proc** `[]=`


```nim
proc `[]=`(a: var Vec4; i: int; b: float32)
```

## **proc** lerp


```nim
proc lerp(a: Vec4; b: Vec4; v: float32): Vec4 {.inline.}
```

## **proc** xyz


```nim
proc xyz(a: Vec4): Vec3 {.inline.}
```

## **proc** `$`


```nim
proc `$`(a: Vec4): string {.raises: [ValueError].}
```

## **proc** vec3


```nim
proc vec3(a: Vec2; z = 0.0): Vec3 {.inline.}
```

## **proc** vec4


```nim
proc vec4(a: Vec3; w = 0.0): Vec4 {.inline.}
```

## **proc** vec4


```nim
proc vec4(a: Vec2; z = 0.0; w = 0.0): Vec4 {.inline.}
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

## **proc** mat3


```nim
proc mat3(a, b, c, d, e, f, g, h, i: float32): Mat3 {.inline, tags: [].}
```

## **proc** mat3


```nim
proc mat3(a: Mat3): Mat3 {.inline.}
```

## **proc** identity


```nim
proc identity(a: var Mat3) {.inline.}
```

## **proc** mat3


```nim
proc mat3(): Mat3 {.inline.}
```

## **proc** transpose


```nim
proc transpose(a: Mat3): Mat3 {.inline.}
```

## **proc** `$`


```nim
proc `$`(a: Mat3): string {.raises: [ValueError].}
```

## **proc** `*`


```nim
proc `*`(a, b: Mat3): Mat3
```

## **proc** scale


```nim
proc scale(a: Mat3; v: Vec2): Mat3 {.inline.}
```

## **proc** scale


```nim
proc scale(a: Mat3; v: Vec3): Mat3 {.inline.}
```

## **proc** translate


```nim
proc translate(v: Vec2): Mat3 {.inline.}
```

## **proc** scale


```nim
proc scale(v: Vec2): Mat3 {.inline.}
```

## **proc** rotationMat3


```nim
proc rotationMat3(angle: float32): Mat3 {.inline.}
```

## **proc** rotate


```nim
proc rotate(a: Mat3; angle: float32): Mat3 {.inline.}
```

## **proc** `*`


```nim
proc `*`(a: Mat3; b: Vec2): Vec2
```

## **proc** `*`


```nim
proc `*`(a: Mat3; b: Vec3): Vec3
```

## **proc** inverse


```nim
proc inverse(a: Mat3): Mat3
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

## **proc** mat4


```nim
proc mat4(v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15: float32): Mat4 {. inline.}
```

## **proc** mat4


```nim
proc mat4(a: Mat4): Mat4 {.inline.}
```

## **proc** identity


```nim
proc identity(): Mat4 {.inline.}
```

## **proc** mat4


```nim
proc mat4(): Mat4 {.inline.}
```

## **proc** transpose


```nim
proc transpose(a: Mat4): Mat4 {.inline.}
```

## **proc** determinant


```nim
proc determinant(a: Mat4): float32
```

## **proc** inverse


```nim
proc inverse(a: Mat4): Mat4
```

## **proc** `*`


```nim
proc `*`(a, b: Mat4): Mat4
```

## **proc** `*`


```nim
proc `*`(a: Mat4; b: Vec3): Vec3
```

## **proc** `*`


```nim
proc `*`(a: Mat4; b: Vec4): Vec4
```

## **proc** right


```nim
proc right(a: Mat4): Vec3 {.inline.}
```

## **proc** right=


```nim
proc right=(a: var Mat4; b: Vec3) {.inline.}
```

## **proc** up


```nim
proc up(a: Mat4): Vec3 {.inline.}
```

## **proc** up=


```nim
proc up=(a: var Mat4; b: Vec3) {.inline.}
```

## **proc** forward


```nim
proc forward(a: Mat4): Vec3 {.inline.}
```

## **proc** forward=


```nim
proc forward=(a: var Mat4; b: Vec3) {.inline.}
```

## **proc** pos


```nim
proc pos(a: Mat4): Vec3 {.inline.}
```

## **proc** pos=


```nim
proc pos=(a: var Mat4; b: Vec3) {.inline.}
```

## **proc** rotationOnly


```nim
proc rotationOnly(a: Mat4): Mat4 {.inline.}
```

## **proc** dist


```nim
proc dist(a, b: Mat4): float32 {.inline.}
```

## **proc** translate


```nim
proc translate(v: Vec3): Mat4
```

## **proc** scale


```nim
proc scale(v: Vec3): Mat4
```

## **proc** close


```nim
proc close(a: Mat4; b: Mat4): bool
```

## **proc** hrp


```nim
proc hrp(m: Mat4): Vec3
```

## **proc** frustum


```nim
proc frustum(left, right, bottom, top, near, far: float32): Mat4
```

## **proc** perspective


```nim
proc perspective(fovy, aspect, near, far: float32): Mat4
```

## **proc** ortho


```nim
proc ortho(left, right, bottom, top, near, far: float32): Mat4
```

## **proc** lookAt


```nim
proc lookAt(eye, center, up: Vec3): Mat4
```

## **proc** mat3

Gets rotation and translation, ignoring z coordinates.

```nim
proc mat3(m: Mat4): Mat3
```

## **proc** mat3Rotation

Gets the rotational part of the 4x4 matrix.

```nim
proc mat3Rotation(m: Mat4): Mat3
```

## **proc** mat4

Takes a 2d Mat3 with position and converts to a 3d matrix.

```nim
proc mat4(m: Mat3): Mat4
```

## **proc** mat4Rotation

Gets the rotational part of the 3x3 matrix into a 4x4 matrix.

```nim
proc mat4Rotation(m: Mat3): Mat4
```

## **proc** `$`


```nim
proc `$`(a: Mat4): string {.raises: [ValueError].}
```

## **type** Quat


```nim
Quat = object
 x*: float32
 y*: float32
 z*: float32
 w*: float32
```

## **proc** quat


```nim
proc quat(x, y, z, w: float32): Quat {.inline.}
```

## **proc** conjugate


```nim
proc conjugate(q: Quat): Quat {.inline.}
```

## **proc** length


```nim
proc length(q: Quat): float32 {.inline.}
```

## **proc** normalize


```nim
proc normalize(q: Quat): Quat
```

## **proc** xyz


```nim
proc xyz(q: Quat): Vec3 {.inline.}
```

## **proc** xyz=


```nim
proc xyz=(q: var Quat; v: Vec3) {.inline.}
```

## **proc** `-`


```nim
proc `-`(a: var Quat): Quat {.inline.}
```

## **proc** `+`


```nim
proc `+`(a: Quat; b: Quat): Quat {.inline.}
```

## **proc** `*`

Multiply the quaternion by a quaternion.

```nim
proc `*`(a, b: Quat): Quat
```

## **proc** `*`

Multiply the quaternion by a float32.

```nim
proc `*`(q: Quat; v: float32): Quat {.inline.}
```

## **proc** `/`

Divide the quaternion by a float32.

```nim
proc `/`(q: Quat; v: float32): Quat {.inline.}
```

## **proc** `*=`


```nim
proc `*=`(a: var Quat; b: float32) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`(a: var Quat; b: float32) {.inline.}
```

## **proc** `*`

Multiply the quaternion by a vector.

```nim
proc `*`(q: Quat; v: Vec3): Vec3
```

## **proc** `[]`


```nim
proc `[]`(a: var Quat; i: int; b: float32)
```

## **proc** `[]=`


```nim
proc `[]=`(a: var Quat; i: int; b: float32)
```

## **proc** mat3


```nim
proc mat3(q: Quat): Mat3
```

## **proc** mat4


```nim
proc mat4(q: Quat): Mat4
```

## **proc** reciprocalSqrt


```nim
proc reciprocalSqrt(x: float32): float32 {.inline.}
```

## **proc** quat


```nim
proc quat(m: Mat4): Quat
```

## **proc** fromAxisAngle


```nim
proc fromAxisAngle(axis: Vec3; angle: float32): Quat
```

## **proc** toAxisAngle


```nim
proc toAxisAngle(q: Quat; axis: var Vec3; angle: var float32)
```

## **proc** quat


```nim
proc quat(heading, pitch, roll: float32): Quat
```

## **proc** quat


```nim
proc quat(hpr: Vec3): Quat {.inline.}
```

## **proc** hrp


```nim
proc hrp(q: Quat): Vec3
```

## **proc** dot


```nim
proc dot(a: Quat; b: Quat): float32 {.inline.}
```

## **proc** nlerp


```nim
proc nlerp(a: Quat; b: Quat; v: float32): Quat
```

## **proc** `$`


```nim
proc `$`(a: Quat): string {.raises: [ValueError].}
```

## **proc** rotate


```nim
proc rotate(angle: float32; axis: Vec3): Mat4 {.inline.}
```

## **proc** rotateX


```nim
proc rotateX(angle: float32): Mat4 {.inline.}
```

## **proc** rotateY


```nim
proc rotateY(angle: float32): Mat4 {.inline.}
```

## **proc** rotateZ


```nim
proc rotateZ(angle: float32): Mat4 {.inline.}
```

## **proc** scaleMat


```nim
proc scaleMat(scale: Vec3): Mat4 {.inline.}
```

## **proc** scaleMat


```nim
proc scaleMat(scale: float32): Mat4 {.inline.}
```

## **type** Rect


```nim
Rect = object
 x*: float32
 y*: float32
 w*: float32
 h*: float32
```

## **proc** rect


```nim
proc rect(x, y, w, h: float32): Rect
```

## **proc** rect


```nim
proc rect(pos, size: Vec2): Rect
```

## **proc** xy

Gets the xy as a Vec2.

```nim
proc xy(rect: Rect): Vec2
```

## **proc** xy=

Sets the xy from Vec2.

```nim
proc xy=(rect: var Rect; v: Vec2)
```

## **proc** wh

Gets the wh as a Vec2.

```nim
proc wh(rect: Rect): Vec2
```

## **proc** wh=

Sets the wh from Vec2.

```nim
proc wh=(rect: var Rect; v: Vec2)
```

## **proc** `*`

* all elements of a Rect.

```nim
proc `*`(r: Rect; v: float): Rect
```

## **proc** `/`

/ all elements of a Rect.

```nim
proc `/`(r: Rect; v: float): Rect
```

## **proc** `+`

Add two boxes together.

```nim
proc `+`(a, b: Rect): Rect
```

## **proc** `$`


```nim
proc `$`(a: Rect): string {.raises: [ValueError].}
```

## **proc** inside

Checks if pos is inside rect.

```nim
proc inside(pos: Vec2; rect: Rect): bool
```

## **proc** overlap

Returns true if box a overlaps box b.

```nim
proc overlap(a, b: Rect): bool
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
