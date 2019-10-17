# VMath

Collection of math rutines that for 2d and 3d graphics.

Has functinos for Vec2, Vec3, Vec4, Mat3, Mat4 and Quat.
# API: vmath

```nim
import vmath
```

## **proc** clamp

Clamps n to min or max if its over.

```nim
proc clamp(n, min, max: float32): float32 
```

## **proc** sign

Returns the sign of a number, -1 or 1.

```nim
proc sign(v: float32): float32 
```

## **proc** quantize

Makes v be multipe of n. Rounding to intger quantize by 1.0.

```nim
proc quantize(v: float32; n: float32): float32 
```

## **proc** lerp

Interpolates value between a and b.
 * 0 -> a
 * 1 -> b
 * 0.5 -> between a and b



```nim
proc lerp(a: float32; b: float32; v: float32): float32 
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
proc vec2(x, y: float32): Vec2 
```

## **proc** vec2


```nim
proc vec2(a: Vec2): Vec2 
```

## **proc** `+`


```nim
proc `+`(a: Vec2; b: Vec2): Vec2 
```

## **proc** `-`


```nim
proc `-`(a: Vec2; b: Vec2): Vec2 
```

## **proc** `*`


```nim
proc `*`(a: Vec2; b: float32): Vec2 
```

## **proc** `*`


```nim
proc `*`(a: float32; b: Vec2): Vec2 
```

## **proc** `/`


```nim
proc `/`(a: Vec2; b: float32): Vec2 
```

## **proc** `+=`


```nim
proc `+=`(a: var Vec2; b: Vec2) 
```

## **proc** `-=`


```nim
proc `-=`(a: var Vec2; b: Vec2) 
```

## **proc** `*=`


```nim
proc `*=`(a: var Vec2; b: float32) 
```

## **proc** `/=`


```nim
proc `/=`(a: var Vec2; b: float32) 
```

## **proc** zero


```nim
proc zero(a: var Vec2) 
```

## **proc** `-`


```nim
proc `-`(a: Vec2): Vec2 
```

## **proc** lengthSq


```nim
proc lengthSq(a: Vec2): float32 
```

## **proc** length


```nim
proc length(a: Vec2): float32 
```

## **proc** length=


```nim
proc length=(a: var Vec2; b: float32) 
```

## **proc** normalize


```nim
proc normalize(a: Vec2): Vec2 
```

## **proc** dot


```nim
proc dot(a: Vec2; b: Vec2): float32 
```

## **proc** dir


```nim
proc dir(at: Vec2; to: Vec2): Vec2 
```

## **proc** dir


```nim
proc dir(th: float32): Vec2 
```

## **proc** dist


```nim
proc dist(at: Vec2; to: Vec2): float32 
```

## **proc** distSq


```nim
proc distSq(at: Vec2; to: Vec2): float32 
```

## **proc** lerp


```nim
proc lerp(a: Vec2; b: Vec2; v: float32): Vec2 
```

## **proc** quantize


```nim
proc quantize(v: Vec2; n: float32): Vec2 
```

## **proc** inRect

Check to see if v is inside a rectange formed by a and b. It does not matter how a and b are arranged.

```nim
proc inRect(v: Vec2; a: Vec2; b: Vec2): bool 
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
proc randVec2(): Vec2 
```

## **proc** `$`


```nim
proc `$`(a: Vec2): string 
```

## **proc** fixAngle

Make angle be from -PI to PI radians.

```nim
proc fixAngle(angle: float32): float32 
```

## **proc** angle

Angle of a vec2.

```nim
proc angle(a: Vec2): float32 
```

## **proc** angleBetween

Angle between 2 vec

```nim
proc angleBetween(a: Vec2; b: Vec2): float32 
```

## **proc** angleBetween

Angle between angle a and angle b

```nim
proc angleBetween(a, b: float32): float32 
```

## **proc** turnAngle

Move from angle a to angle b with step of v

```nim
proc turnAngle(a, b, speed: float32): float32 
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
proc vec3(x, y, z: float32): Vec3 
```

## **proc** vec3


```nim
proc vec3(a: Vec3): Vec3 
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
proc `+`(a: Vec3; b: Vec3): Vec3 
```

## **proc** `-`


```nim
proc `-`(a: Vec3; b: Vec3): Vec3 
```

## **proc** `-`


```nim
proc `-`(a: Vec3): Vec3 
```

## **proc** `*`


```nim
proc `*`(a: Vec3; b: float32): Vec3 
```

## **proc** `*`


```nim
proc `*`(a: float32; b: Vec3): Vec3 
```

## **proc** `/`


```nim
proc `/`(a: Vec3; b: float32): Vec3 
```

## **proc** `/`


```nim
proc `/`(a: float32; b: Vec3): Vec3 
```

## **proc** `+=`


```nim
proc `+=`(a: var Vec3; b: Vec3) 
```

## **proc** `-=`


```nim
proc `-=`(a: var Vec3; b: Vec3) 
```

## **proc** `*=`


```nim
proc `*=`(a: var Vec3; b: float32) 
```

## **proc** `/=`


```nim
proc `/=`(a: var Vec3; b: float32) 
```

## **proc** zero


```nim
proc zero(a: var Vec3) 
```

## **proc** `-`


```nim
proc `-`(a: var Vec3): Vec3 
```

## **proc** lengthSq


```nim
proc lengthSq(a: Vec3): float32 
```

## **proc** length


```nim
proc length(a: Vec3): float32 
```

## **proc** length=


```nim
proc length=(a: var Vec3; b: float32) 
```

## **proc** normalize


```nim
proc normalize(a: Vec3): Vec3 
```

## **proc** cross


```nim
proc cross(a: Vec3; b: Vec3): Vec3 
```

## **proc** computeNormal


```nim
proc computeNormal(a, b, c: Vec3): Vec3 
```

## **proc** dot


```nim
proc dot(a: Vec3; b: Vec3): float32 
```

## **proc** dir


```nim
proc dir(at: Vec3; to: Vec3): Vec3 
```

## **proc** dist


```nim
proc dist(at: Vec3; to: Vec3): float32 
```

## **proc** distSq


```nim
proc distSq(at: Vec3; to: Vec3): float32 
```

## **proc** lerp


```nim
proc lerp(a: Vec3; b: Vec3; v: float32): Vec3 
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
proc xy(a: Vec3): Vec2 
```

## **proc** xz


```nim
proc xz(a: Vec3): Vec2 
```

## **proc** yx


```nim
proc yx(a: Vec3): Vec2 
```

## **proc** yz


```nim
proc yz(a: Vec3): Vec2 
```

## **proc** zx


```nim
proc zx(a: Vec3): Vec2 
```

## **proc** zy


```nim
proc zy(a: Vec3): Vec2 
```

## **proc** almostEquals


```nim
proc almostEquals(a, b: Vec3; precision = 1e-006): bool 
```

## **proc** randVec3

Generates a random vector based on: <a class="reference external" href="http://mathworld.wolfram.com/SpherePointPicking.html">http://mathworld.wolfram.com/SpherePointPicking.html</a> .

```nim
proc randVec3(): Vec3 
```

## **proc** `$`


```nim
proc `$`(a: Vec3): string 
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
proc vec4(x, y, z, w: float32): Vec4 
```

## **proc** `+`


```nim
proc `+`(a: Vec4; b: Vec4): Vec4 
```

## **proc** `-`


```nim
proc `-`(a: Vec4; b: Vec4): Vec4 
```

## **proc** `-`


```nim
proc `-`(a: Vec4): Vec4 
```

## **proc** `*`


```nim
proc `*`(a: Vec4; b: float32): Vec4 
```

## **proc** `*`


```nim
proc `*`(a: float32; b: Vec4): Vec4 
```

## **proc** `/`


```nim
proc `/`(a: Vec4; b: float32): Vec4 
```

## **proc** `/`


```nim
proc `/`(a: float32; b: Vec4): Vec4 
```

## **proc** `+=`


```nim
proc `+=`(a: var Vec4; b: Vec4) 
```

## **proc** `-=`


```nim
proc `-=`(a: var Vec4; b: Vec4) 
```

## **proc** `*=`


```nim
proc `*=`(a: var Vec4; b: float32) 
```

## **proc** `/=`


```nim
proc `/=`(a: var Vec4; b: float32) 
```

## **proc** zero


```nim
proc zero(a: var Vec4) 
```

## **proc** xyz


```nim
proc xyz(a: Vec4): Vec3 
```

## **proc** `$`


```nim
proc `$`(a: Vec4): string 
```

## **proc** vec3


```nim
proc vec3(a: Vec2; z = 0.0): Vec3 
```

## **proc** vec4


```nim
proc vec4(a: Vec3; w = 0.0): Vec4 
```

## **proc** vec4


```nim
proc vec4(a: Vec2; z = 0.0; w = 0.0): Vec4 
```

## **type** Mat3

3x3 Matrix

```nim
Mat3 = array[9, float32]
```

## **proc** mat3


```nim
proc mat3(a, b, c, d, e, f, g, h, i: float32): Mat3 
```

## **proc** mat3


```nim
proc mat3(a: Mat3): Mat3 
```

## **proc** identity


```nim
proc identity(a: var Mat3) 
```

## **proc** mat3


```nim
proc mat3(): Mat3 
```

## **proc** transpose


```nim
proc transpose(a: Mat3): Mat3 
```

## **proc** `$`


```nim
proc `$`(a: Mat3): string 
```

## **proc** `*`


```nim
proc `*`(a: Mat3; b: Mat3): Mat3 
```

## **proc** `*`


```nim
proc `*`(m: Mat3; v: Vec3): Vec3 
```

## **proc** scale


```nim
proc scale(a: Mat3; v: Vec2): Mat3 
```

## **proc** scale


```nim
proc scale(a: Mat3; v: Vec3): Mat3 
```

## **proc** rotationMat3


```nim
proc rotationMat3(angle: float32): Mat3 
```

## **proc** rotate


```nim
proc rotate(a: Mat3; angle: float32): Mat3 
```

## **proc** `*`


```nim
proc `*`(a: Mat3; b: Vec2): Vec2 
```

## **type** Mat4

4x4 Matrix - OpenGL row order

```nim
Mat4 = array[16, float32]
```

## **proc** mat4


```nim
proc mat4(v0, v1, Vec2, Vec3, Vec4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15: float32): Mat4 
```

## **proc** mat4


```nim
proc mat4(a: Mat4): Mat4 
```

## **proc** identity


```nim
proc identity(): Mat4 
```

## **proc** mat4


```nim
proc mat4(): Mat4 
```

## **proc** transpose


```nim
proc transpose(a: Mat4): Mat4 
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

## **proc** right


```nim
proc right(a: Mat4): Vec3 
```

## **proc** right=


```nim
proc right=(a: var Mat4; b: Vec3) 
```

## **proc** up


```nim
proc up(a: Mat4): Vec3 
```

## **proc** up=


```nim
proc up=(a: var Mat4; b: Vec3) 
```

## **proc** fov


```nim
proc fov(a: Mat4): Vec3 
```

## **proc** fov=


```nim
proc fov=(a: var Mat4; b: Vec3) 
```

## **proc** pos


```nim
proc pos(a: Mat4): Vec3 
```

## **proc** pos=


```nim
proc pos=(a: var Mat4; b: Vec3) 
```

## **proc** rotationOnly


```nim
proc rotationOnly(a: Mat4): Mat4 
```

## **proc** dist


```nim
proc dist(a, b: Mat4): float32 
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

## **proc** tofloat32


```nim
proc tofloat32(m: Mat4): array[16, float32] 
```

## **proc** `$`


```nim
proc `$`(a: Mat4): string 
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
proc quat(x, y, z, w: float32): Quat 
```

## **proc** conjugate


```nim
proc conjugate(q: Quat): Quat 
```

## **proc** length


```nim
proc length(q: Quat): float32 
```

## **proc** normalize


```nim
proc normalize(q: Quat): Quat 
```

## **proc** xyz


```nim
proc xyz(q: Quat): Vec3 
```

## **proc** xyz=


```nim
proc xyz=(q: var Quat; v: Vec3) 
```

## **proc** `*`

Multiply the quaternion by a quaternion

```nim
proc `*`(a, b: Quat): Quat 
```

## **proc** `*`

Multiply the quaternion by a float32

```nim
proc `*`(q: Quat; v: float32): Quat 
```

## **proc** `*`

Multiply the quaternion by a vector

```nim
proc `*`(q: Quat; v: Vec3): Vec3 
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
proc reciprocalSqrt(x: float32): float32 
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

## **proc** hrp


```nim
proc hrp(q: Quat): Vec3 
```

## **proc** `$`


```nim
proc `$`(a: Quat): string 
```

## **proc** rotate


```nim
proc rotate(angle: float32; axis: Vec3): Mat4 
```

## **proc** rotateX


```nim
proc rotateX(angle: float32): Mat4 
```

## **proc** rotateY


```nim
proc rotateY(angle: float32): Mat4 
```

## **proc** rotateZ


```nim
proc rotateZ(angle: float32): Mat4 
```

## **proc** scaleMat


```nim
proc scaleMat(scale: Vec3): Mat4 
```

## **proc** scaleMat


```nim
proc scaleMat(scale: float32): Mat4 
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

Gets the xy as a vec2

```nim
proc xy(rect: Rect): Vec2 
```

## **proc** xy=

Sets the xy from vec2

```nim
proc xy=(rect: var Rect; v: Vec2) 
```

## **proc** wh

Gets the wh as a vec2

```nim
proc wh(rect: Rect): Vec2 
```

## **proc** wh=

Sets the wh from vec2

```nim
proc wh=(rect: var Rect; v: Vec2) 
```

## **proc** `*`


 * all elements of a rect



```nim
proc `*`(r: Rect; v: float): Rect 
```

## **proc** `/`

/ all elements of a rect

```nim
proc `/`(r: Rect; v: float): Rect 
```

## **proc** intersects

Checks if point is inside the rectangle

```nim
proc intersects(rect: Rect; pos: Vec2): bool 
```

## **proc** `$`


```nim
proc `$`(a: Rect): string 
```

