<img src="docs/banner.png">

# VMath

`nimble install vmath`

Your single stop for vector math routines for 2d and 3d graphics.

Pure nim no dependencies. Fast. Easy to use.

## Has functions for:

Type  | Constructor | Description
------|-------------| ---------------------------------------------------
BVec# | bvec#       | a vector of booleans
IVec# | ivec#       | a vector of signed integers
UVec# | uvec#       | a vector of unsigned integers
Vec#  | vec#        | a vector of single-precision floating-point numbers
DVec# | dvec#       | a vector of double-precision floating-point numbers

## And these types:

NIM     | GLSL   | 2     | 3     | 4     | 9     | 16    | 4     |
--------|--------|-------|-------|-------|-------|-------|-------|
bool    | bool   | BVec2 | BVec3 | BVec4 |       |       |       |
int32   | int    | IVec2 | IVec3 | IVec4 |       |       |       |
uint32  | uint   | UVec2 | UVec3 | UVec4 |       |       |       |
float32 | float  | Vec2  | Vec3  | Vec4  | Mat3  | Mat4  | Quat  |
float64 | double | DVec2 | DVec3 | DVec4 | DMat3 | DMat4 | DQuat |


# 0.x.x to 1.0.0 vmath breaking changes:

* `vec3(v)` no longer works please use `vec3(v.x, v.y, 0)` instead.
* `vec3(v, 0)` no longer works please use `vec3(v.x, v.y, 0)` instead.
* `2 * v` no longer works due to more vec types please use `v * 2` instead.
* `m[15]` no longer works because matrices are now m[x, y].
* Concept of 3x3 rotation 3d matrix was removed.
* `angleBetween` got renamed to `angle(a, b)`
* `scaleMat` got renamed to `scale(v)`
* `rotationMat3` got renamed to `rotate(x)`

# API: vmath

```nim
import vmath
```

## **type** GVec2


```nim
GVec2[T] = array[2, T]
```

## **type** GVec3


```nim
GVec3[T] = array[3, T]
```

## **type** GVec4


```nim
GVec4[T] = array[4, T]
```

## **type** BVec2


```nim
BVec2 = GVec2[bool]
```

## **type** BVec3


```nim
BVec3 = GVec3[bool]
```

## **type** BVec4


```nim
BVec4 = GVec4[bool]
```

## **type** IVec2


```nim
IVec2 = GVec2[int32]
```

## **type** IVec3


```nim
IVec3 = GVec3[int32]
```

## **type** IVec4


```nim
IVec4 = GVec4[int32]
```

## **type** UVec2


```nim
UVec2 = GVec2[uint32]
```

## **type** UVec3


```nim
UVec3 = GVec3[uint32]
```

## **type** UVec4


```nim
UVec4 = GVec4[uint32]
```

## **type** Vec2


```nim
Vec2 = GVec2[float32]
```

## **type** Vec3


```nim
Vec3 = GVec3[float32]
```

## **type** Vec4


```nim
Vec4 = GVec4[float32]
```

## **type** DVec2


```nim
DVec2 = GVec2[float64]
```

## **type** DVec3


```nim
DVec3 = GVec3[float64]
```

## **type** DVec4


```nim
DVec4 = GVec4[float64]
```

## **proc** `~=`

Almost equal.

```nim
proc `~=`[T: SomeFloat](a, b: T): bool {.inline.}
```

## **proc** between

Returns true if value is between min and max or equal to them.

```nim
proc between[T](value, min, max: T): bool {.inline.}
```

## **proc** sign

Returns the sign of a number, -1 or 1.

```nim
proc sign[T](v: T): T {.inline.}
```

## **proc** quantize

Makes v be multiple of n. Rounding to integer quantize by 1.0.

```nim
proc quantize[T: SomeFloat](v, n: T): T {.inline.}
```

## **proc** lerp

Interpolates value between a and b.
 * 0 -> a
 * 1 -> b
 * 0.5 -> between a and b

```nim
proc lerp[T: SomeFloat](a, b, v: T): T {.inline.}
```

## **proc** fixAngle

Make angle be from -PI to PI radians.

```nim
proc fixAngle[T: SomeFloat](angle: T): T {.inline.}
```

## **proc** angleBetween

Angle between angle a and angle b.

```nim
proc angleBetween[T: SomeFloat](a, b: T): T {.inline.}
```

## **proc** turnAngle

Move from angle a to angle b with step of v.

```nim
proc turnAngle[T: SomeFloat](a, b, speed: T): T {.inline.}
```

## **proc** toRadians


```nim
proc toRadians[T: SomeFloat](deg: T): T {.inline.}
```

## **proc** toDegrees


```nim
proc toDegrees[T: SomeFloat](rad: T): T {.inline.}
```

## **proc** gvec2


```nim
proc gvec2[T](x, y: T): GVec2[T] {.inline.}
```

## **proc** gvec3


```nim
proc gvec3[T](x, y, z: T): GVec3[T] {.inline.}
```

## **proc** gvec4


```nim
proc gvec4[T](x, y, z, w: T): GVec4[T] {.inline.}
```

## **proc** bvec2


```nim
proc bvec2(x`gensym4, y`gensym4: bool): BVec2 {.inline.}
```

## **proc** bvec3


```nim
proc bvec3(x`gensym4, y`gensym4, z`gensym4: bool): BVec3 {.inline, tags: [].}
```

## **proc** bvec4


```nim
proc bvec4(x`gensym4, y`gensym4, z`gensym4, w`gensym4: bool): BVec4 {.inline, raises: [].}
```

## **proc** bvec2


```nim
proc bvec2(x`gensym4: bool): BVec2 {.inline.}
```

## **proc** bvec3


```nim
proc bvec3(x`gensym4: bool): BVec3 {.inline.}
```

## **proc** bvec4


```nim
proc bvec4(x`gensym4: bool): BVec4 {.inline.}
```

## **proc** bvec2


```nim
proc bvec2[T](x`gensym4: GVec2[T]): BVec2 {.inline.}
```

## **proc** bvec3


```nim
proc bvec3[T](x`gensym4: GVec3[T]): BVec3 {.inline.}
```

## **proc** bvec4


```nim
proc bvec4[T](x`gensym4: GVec4[T]): BVec4 {.inline.}
```

## **proc** bvec3


```nim
proc bvec3[T](x`gensym4: GVec2[T]): BVec3 {.inline.}
```

## **proc** bvec4


```nim
proc bvec4[T](x`gensym4: GVec3[T]): BVec4 {.inline.}
```

## **proc** ivec2


```nim
proc ivec2(x`gensym5, y`gensym5: int32): IVec2 {.inline.}
```

## **proc** ivec3


```nim
proc ivec3(x`gensym5, y`gensym5, z`gensym5: int32): IVec3 {.inline, tags: [].}
```

## **proc** ivec4


```nim
proc ivec4(x`gensym5, y`gensym5, z`gensym5, w`gensym5: int32): IVec4 {.inline, raises: [].}
```

## **proc** ivec2


```nim
proc ivec2(x`gensym5: int32): IVec2 {.inline.}
```

## **proc** ivec3


```nim
proc ivec3(x`gensym5: int32): IVec3 {.inline.}
```

## **proc** ivec4


```nim
proc ivec4(x`gensym5: int32): IVec4 {.inline.}
```

## **proc** ivec2


```nim
proc ivec2[T](x`gensym5: GVec2[T]): IVec2 {.inline.}
```

## **proc** ivec3


```nim
proc ivec3[T](x`gensym5: GVec3[T]): IVec3 {.inline.}
```

## **proc** ivec4


```nim
proc ivec4[T](x`gensym5: GVec4[T]): IVec4 {.inline.}
```

## **proc** ivec3


```nim
proc ivec3[T](x`gensym5: GVec2[T]): IVec3 {.inline.}
```

## **proc** ivec4


```nim
proc ivec4[T](x`gensym5: GVec3[T]): IVec4 {.inline.}
```

## **proc** uvec2


```nim
proc uvec2(x`gensym6, y`gensym6: uint32): UVec2 {.inline.}
```

## **proc** uvec3


```nim
proc uvec3(x`gensym6, y`gensym6, z`gensym6: uint32): UVec3 {.inline, tags: [].}
```

## **proc** uvec4


```nim
proc uvec4(x`gensym6, y`gensym6, z`gensym6, w`gensym6: uint32): UVec4 {.inline, raises: [].}
```

## **proc** uvec2


```nim
proc uvec2(x`gensym6: uint32): UVec2 {.inline.}
```

## **proc** uvec3


```nim
proc uvec3(x`gensym6: uint32): UVec3 {.inline.}
```

## **proc** uvec4


```nim
proc uvec4(x`gensym6: uint32): UVec4 {.inline.}
```

## **proc** uvec2


```nim
proc uvec2[T](x`gensym6: GVec2[T]): UVec2 {.inline.}
```

## **proc** uvec3


```nim
proc uvec3[T](x`gensym6: GVec3[T]): UVec3 {.inline.}
```

## **proc** uvec4


```nim
proc uvec4[T](x`gensym6: GVec4[T]): UVec4 {.inline.}
```

## **proc** uvec3


```nim
proc uvec3[T](x`gensym6: GVec2[T]): UVec3 {.inline.}
```

## **proc** uvec4


```nim
proc uvec4[T](x`gensym6: GVec3[T]): UVec4 {.inline.}
```

## **proc** vec2


```nim
proc vec2(x`gensym7, y`gensym7: float32): Vec2 {.inline.}
```

## **proc** vec3


```nim
proc vec3(x`gensym7, y`gensym7, z`gensym7: float32): Vec3 {.inline, tags: [].}
```

## **proc** vec4


```nim
proc vec4(x`gensym7, y`gensym7, z`gensym7, w`gensym7: float32): Vec4 {.inline, raises: [].}
```

## **proc** vec2


```nim
proc vec2(x`gensym7: float32): Vec2 {.inline.}
```

## **proc** vec3


```nim
proc vec3(x`gensym7: float32): Vec3 {.inline.}
```

## **proc** vec4


```nim
proc vec4(x`gensym7: float32): Vec4 {.inline.}
```

## **proc** vec2


```nim
proc vec2[T](x`gensym7: GVec2[T]): Vec2 {.inline.}
```

## **proc** vec3


```nim
proc vec3[T](x`gensym7: GVec3[T]): Vec3 {.inline.}
```

## **proc** vec4


```nim
proc vec4[T](x`gensym7: GVec4[T]): Vec4 {.inline.}
```

## **proc** vec3


```nim
proc vec3[T](x`gensym7: GVec2[T]): Vec3 {.inline.}
```

## **proc** vec4


```nim
proc vec4[T](x`gensym7: GVec3[T]): Vec4 {.inline.}
```

## **proc** dvec2


```nim
proc dvec2(x`gensym8, y`gensym8: float64): DVec2 {.inline.}
```

## **proc** dvec3


```nim
proc dvec3(x`gensym8, y`gensym8, z`gensym8: float64): DVec3 {.inline, raises: [].}
```

## **proc** dvec4


```nim
proc dvec4(x`gensym8, y`gensym8, z`gensym8, w`gensym8: float64): DVec4 {.inline, raises: [].}
```

## **proc** dvec2


```nim
proc dvec2(x`gensym8: float64): DVec2 {.inline.}
```

## **proc** dvec3


```nim
proc dvec3(x`gensym8: float64): DVec3 {.inline.}
```

## **proc** dvec4


```nim
proc dvec4(x`gensym8: float64): DVec4 {.inline.}
```

## **proc** dvec2


```nim
proc dvec2[T](x`gensym8: GVec2[T]): DVec2 {.inline.}
```

## **proc** dvec3


```nim
proc dvec3[T](x`gensym8: GVec3[T]): DVec3 {.inline.}
```

## **proc** dvec4


```nim
proc dvec4[T](x`gensym8: GVec4[T]): DVec4 {.inline.}
```

## **proc** dvec3


```nim
proc dvec3[T](x`gensym8: GVec2[T]): DVec3 {.inline.}
```

## **proc** dvec4


```nim
proc dvec4[T](x`gensym8: GVec3[T]): DVec4 {.inline.}
```

## **proc** x


```nim
proc x[T](a: var GVec2[T]): var T {.inline.}
```

## **proc** y


```nim
proc y[T](a: var GVec2[T]): var T {.inline.}
```

## **proc** x


```nim
proc x[T](a: var GVec3[T]): var T {.inline.}
```

## **proc** y


```nim
proc y[T](a: var GVec3[T]): var T {.inline.}
```

## **proc** z


```nim
proc z[T](a: var GVec3[T]): var T {.inline.}
```

## **proc** x


```nim
proc x[T](a: var GVec4[T]): var T {.inline.}
```

## **proc** y


```nim
proc y[T](a: var GVec4[T]): var T {.inline.}
```

## **proc** z


```nim
proc z[T](a: var GVec4[T]): var T {.inline.}
```

## **proc** w


```nim
proc w[T](a: var GVec4[T]): var T {.inline.}
```

## **proc** x


```nim
proc x[T](a: GVec2[T]): T {.inline.}
```

## **proc** x


```nim
proc x[T](a: GVec3[T]): T {.inline.}
```

## **proc** x


```nim
proc x[T](a: GVec4[T]): T {.inline.}
```

## **proc** y


```nim
proc y[T](a: GVec2[T]): T {.inline.}
```

## **proc** y


```nim
proc y[T](a: GVec3[T]): T {.inline.}
```

## **proc** y


```nim
proc y[T](a: GVec4[T]): T {.inline.}
```

## **proc** z


```nim
proc z[T](a: GVec2[T]): T {.inline.}
```

## **proc** z


```nim
proc z[T](a: GVec3[T]): T {.inline.}
```

## **proc** z


```nim
proc z[T](a: GVec4[T]): T {.inline.}
```

## **proc** w


```nim
proc w[T](a: GVec2[T]): T {.inline.}
```

## **proc** w


```nim
proc w[T](a: GVec3[T]): T {.inline.}
```

## **proc** w


```nim
proc w[T](a: GVec4[T]): T {.inline.}
```

## **proc** x=


```nim
proc x=[T](a: var GVec234[T]; value: T) {.inline.}
```

## **proc** y=


```nim
proc y=[T](a: var GVec234[T]; value: T) {.inline.}
```

## **proc** z=


```nim
proc z=[T](a: var GVec34[T]; value: T) {.inline.}
```

## **proc** w=


```nim
proc w=[T](a: var GVec4[T]; value: T) {.inline.}
```

## **proc** xy


```nim
proc xy[T](a: GVec234[T]): GVec2[T] {.inline.}
```

## **proc** xz


```nim
proc xz[T](a: GVec234[T]): GVec2[T] {.inline.}
```

## **proc** yx


```nim
proc yx[T](a: GVec234[T]): GVec2[T] {.inline.}
```

## **proc** yz


```nim
proc yz[T](a: GVec234[T]): GVec2[T] {.inline.}
```

## **proc** zx


```nim
proc zx[T](a: GVec234[T]): GVec2[T] {.inline.}
```

## **proc** zy


```nim
proc zy[T](a: GVec234[T]): GVec2[T] {.inline.}
```

## **proc** xxx


```nim
proc xxx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xxy


```nim
proc xxy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xxz


```nim
proc xxz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xyx


```nim
proc xyx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xyy


```nim
proc xyy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xyz


```nim
proc xyz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xzx


```nim
proc xzx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xzy


```nim
proc xzy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** xzz


```nim
proc xzz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yxx


```nim
proc yxx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yxy


```nim
proc yxy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yxz


```nim
proc yxz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yyx


```nim
proc yyx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yyy


```nim
proc yyy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yyz


```nim
proc yyz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yzx


```nim
proc yzx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yzy


```nim
proc yzy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** yzz


```nim
proc yzz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zxx


```nim
proc zxx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zxy


```nim
proc zxy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zxz


```nim
proc zxz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zyx


```nim
proc zyx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zyy


```nim
proc zyy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zyz


```nim
proc zyz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zzx


```nim
proc zzx[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zzy


```nim
proc zzy[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** zzz


```nim
proc zzz[T](a: GVec34[T]): GVec3[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9, b`gensym9: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9, b`gensym9: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9, b`gensym9: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9: GVec2[T]; b`gensym9: T): GVec2[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9: GVec3[T]; b`gensym9: T): GVec3[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9: GVec4[T]; b`gensym9: T): GVec4[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9: T; b`gensym9: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9: T; b`gensym9: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `+`


```nim
proc `+`[T](a`gensym9: T; b`gensym9: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10, b`gensym10: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10, b`gensym10: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10, b`gensym10: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10: GVec2[T]; b`gensym10: T): GVec2[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10: GVec3[T]; b`gensym10: T): GVec3[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10: GVec4[T]; b`gensym10: T): GVec4[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10: T; b`gensym10: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10: T; b`gensym10: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](a`gensym10: T; b`gensym10: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11, b`gensym11: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11, b`gensym11: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11, b`gensym11: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11: GVec2[T]; b`gensym11: T): GVec2[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11: GVec3[T]; b`gensym11: T): GVec3[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11: GVec4[T]; b`gensym11: T): GVec4[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11: T; b`gensym11: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11: T; b`gensym11: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a`gensym11: T; b`gensym11: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12, b`gensym12: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12, b`gensym12: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12, b`gensym12: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12: GVec2[T]; b`gensym12: T): GVec2[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12: GVec3[T]; b`gensym12: T): GVec3[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12: GVec4[T]; b`gensym12: T): GVec4[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12: T; b`gensym12: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12: T; b`gensym12: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `/`


```nim
proc `/`[T](a`gensym12: T; b`gensym12: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13, b`gensym13: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13, b`gensym13: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13, b`gensym13: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13: GVec2[T]; b`gensym13: T): GVec2[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13: GVec3[T]; b`gensym13: T): GVec3[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13: GVec4[T]; b`gensym13: T): GVec4[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13: T; b`gensym13: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13: T; b`gensym13: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `mod`


```nim
proc `mod`[T](a`gensym13: T; b`gensym13: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14, b`gensym14: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14, b`gensym14: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14, b`gensym14: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14: GVec2[T]; b`gensym14: T): GVec2[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14: GVec3[T]; b`gensym14: T): GVec3[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14: GVec4[T]; b`gensym14: T): GVec4[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14: T; b`gensym14: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14: T; b`gensym14: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `div`


```nim
proc `div`[T](a`gensym14: T; b`gensym14: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `+=`


```nim
proc `+=`[T](a`gensym15: var GVec2[T]; b`gensym15: GVec2[T]) {.inline.}
```

## **proc** `+=`


```nim
proc `+=`[T](a`gensym15: var GVec3[T]; b`gensym15: GVec3[T]) {.inline.}
```

## **proc** `+=`


```nim
proc `+=`[T](a`gensym15: var GVec4[T]; b`gensym15: GVec4[T]) {.inline.}
```

## **proc** `+=`


```nim
proc `+=`[T](a`gensym15: var GVec2[T]; b`gensym15: T) {.inline.}
```

## **proc** `+=`


```nim
proc `+=`[T](a`gensym15: var GVec3[T]; b`gensym15: T) {.inline.}
```

## **proc** `+=`


```nim
proc `+=`[T](a`gensym15: var GVec4[T]; b`gensym15: T) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`[T](a`gensym16: var GVec2[T]; b`gensym16: GVec2[T]) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`[T](a`gensym16: var GVec3[T]; b`gensym16: GVec3[T]) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`[T](a`gensym16: var GVec4[T]; b`gensym16: GVec4[T]) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`[T](a`gensym16: var GVec2[T]; b`gensym16: T) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`[T](a`gensym16: var GVec3[T]; b`gensym16: T) {.inline.}
```

## **proc** `-=`


```nim
proc `-=`[T](a`gensym16: var GVec4[T]; b`gensym16: T) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`[T](a`gensym17: var GVec2[T]; b`gensym17: GVec2[T]) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`[T](a`gensym17: var GVec3[T]; b`gensym17: GVec3[T]) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`[T](a`gensym17: var GVec4[T]; b`gensym17: GVec4[T]) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`[T](a`gensym17: var GVec2[T]; b`gensym17: T) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`[T](a`gensym17: var GVec3[T]; b`gensym17: T) {.inline.}
```

## **proc** `*=`


```nim
proc `*=`[T](a`gensym17: var GVec4[T]; b`gensym17: T) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`[T](a`gensym18: var GVec2[T]; b`gensym18: GVec2[T]) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`[T](a`gensym18: var GVec3[T]; b`gensym18: GVec3[T]) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`[T](a`gensym18: var GVec4[T]; b`gensym18: GVec4[T]) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`[T](a`gensym18: var GVec2[T]; b`gensym18: T) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`[T](a`gensym18: var GVec3[T]; b`gensym18: T) {.inline.}
```

## **proc** `/=`


```nim
proc `/=`[T](a`gensym18: var GVec4[T]; b`gensym18: T) {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](v`gensym19: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](v`gensym19: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** `-`


```nim
proc `-`[T](v`gensym19: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** sin


```nim
proc sin[T](v`gensym20: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** sin


```nim
proc sin[T](v`gensym20: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** sin


```nim
proc sin[T](v`gensym20: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** cos


```nim
proc cos[T](v`gensym21: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** cos


```nim
proc cos[T](v`gensym21: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** cos


```nim
proc cos[T](v`gensym21: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** tan


```nim
proc tan[T](v`gensym22: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** tan


```nim
proc tan[T](v`gensym22: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** tan


```nim
proc tan[T](v`gensym22: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** arcsin


```nim
proc arcsin[T](v`gensym23: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** arcsin


```nim
proc arcsin[T](v`gensym23: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** arcsin


```nim
proc arcsin[T](v`gensym23: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** arccos


```nim
proc arccos[T](v`gensym24: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** arccos


```nim
proc arccos[T](v`gensym24: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** arccos


```nim
proc arccos[T](v`gensym24: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** arctan


```nim
proc arctan[T](v`gensym25: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** arctan


```nim
proc arctan[T](v`gensym25: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** arctan


```nim
proc arctan[T](v`gensym25: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** sinh


```nim
proc sinh[T](v`gensym26: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** sinh


```nim
proc sinh[T](v`gensym26: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** sinh


```nim
proc sinh[T](v`gensym26: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** cosh


```nim
proc cosh[T](v`gensym27: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** cosh


```nim
proc cosh[T](v`gensym27: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** cosh


```nim
proc cosh[T](v`gensym27: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** tanh


```nim
proc tanh[T](v`gensym28: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** tanh


```nim
proc tanh[T](v`gensym28: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** tanh


```nim
proc tanh[T](v`gensym28: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** exp2


```nim
proc exp2[T](v`gensym29: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** exp2


```nim
proc exp2[T](v`gensym29: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** exp2


```nim
proc exp2[T](v`gensym29: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** inversesqrt


```nim
proc inversesqrt[T](v`gensym30: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** inversesqrt


```nim
proc inversesqrt[T](v`gensym30: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** inversesqrt


```nim
proc inversesqrt[T](v`gensym30: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** exp


```nim
proc exp[T](v`gensym31: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** exp


```nim
proc exp[T](v`gensym31: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** exp


```nim
proc exp[T](v`gensym31: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** ln


```nim
proc ln[T](v`gensym32: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** ln


```nim
proc ln[T](v`gensym32: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** ln


```nim
proc ln[T](v`gensym32: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** log2


```nim
proc log2[T](v`gensym33: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** log2


```nim
proc log2[T](v`gensym33: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** log2


```nim
proc log2[T](v`gensym33: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** sqrt


```nim
proc sqrt[T](v`gensym34: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** sqrt


```nim
proc sqrt[T](v`gensym34: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** sqrt


```nim
proc sqrt[T](v`gensym34: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** floor


```nim
proc floor[T](v`gensym35: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** floor


```nim
proc floor[T](v`gensym35: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** floor


```nim
proc floor[T](v`gensym35: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** ciel


```nim
proc ciel[T](v`gensym36: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** ciel


```nim
proc ciel[T](v`gensym36: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** ciel


```nim
proc ciel[T](v`gensym36: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** abs


```nim
proc abs[T](v`gensym37: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** abs


```nim
proc abs[T](v`gensym37: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** abs


```nim
proc abs[T](v`gensym37: GVec4[T]): GVec4[T] {.inline.}
```

## **proc** `~=`

Almost equal.

```nim
proc `~=`[T](a, b: GVec2[T]): bool {.inline.}
```

## **proc** `~=`

Almost equal.

```nim
proc `~=`[T](a, b: GVec3[T]): bool {.inline.}
```

## **proc** `~=`

Almost equal.

```nim
proc `~=`[T](a, b: GVec4[T]): bool {.inline.}
```

## **proc** length


```nim
proc length[T](a: GVec2[T]): T {.inline.}
```

## **proc** length


```nim
proc length[T](a: GVec3[T]): T {.inline.}
```

## **proc** length


```nim
proc length[T](a: GVec4[T]): T {.inline.}
```

## **proc** lengthSq


```nim
proc lengthSq[T](a: GVec2[T]): T {.inline.}
```

## **proc** lengthSq


```nim
proc lengthSq[T](a: GVec3[T]): T {.inline.}
```

## **proc** lengthSq


```nim
proc lengthSq[T](a: GVec4[T]): T {.inline.}
```

## **proc** normalize


```nim
proc normalize[T](a: GVec234[T]): type(a) {.inline.}
```

## **proc** lerp


```nim
proc lerp[T: SomeFloat](a, b: GVec234[T]; v: T): type(a) {.inline.}
```

## **proc** dot


```nim
proc dot[T](a, b: GVec2[T]): T {.inline.}
```

## **proc** dot


```nim
proc dot[T](a, b: GVec3[T]): T {.inline.}
```

## **proc** dot


```nim
proc dot[T](a, b: GVec4[T]): T {.inline.}
```

## **proc** cross


```nim
proc cross[T](a, b: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** dist


```nim
proc dist[T](at, to: GVec234[T]): T {.inline.}
```

## **proc** distSq


```nim
proc distSq[T](at, to: GVec234[T]): T {.inline.}
```

## **proc** dir


```nim
proc dir[T](at, to: GVec234[T]): type(to) {.inline.}
```

## **proc** dir


```nim
proc dir[T](angle: T): GVec2[T] {.inline.}
```

## **type** GMat2


```nim
GMat2[T] = array[2, GVec2[T]]
```

## **type** GMat3


```nim
GMat3[T] = array[3, GVec3[T]]
```

## **type** GMat4


```nim
GMat4[T] = array[4, GVec4[T]]
```

## **type** Mat2


```nim
Mat2 = GMat2[float32]
```

## **type** Mat3


```nim
Mat3 = GMat3[float32]
```

## **type** Mat4


```nim
Mat4 = GMat4[float32]
```

## **type** DMat2


```nim
DMat2 = GMat2[float64]
```

## **type** DMat3


```nim
DMat3 = GMat3[float64]
```

## **type** DMat4


```nim
DMat4 = GMat4[float64]
```

## **proc** mat2


```nim
proc mat2(a`gensym38, b`gensym38, c`gensym38, d`gensym38: float32): Mat2 {. inline.}
```

## **proc** mat3


```nim
proc mat3(a`gensym38, b`gensym38, c`gensym38, d`gensym38, e`gensym38, f`gensym38, g`gensym38, h`gensym38, i`gensym38: float32): Mat3 {. inline.}
```

## **proc** mat4


```nim
proc mat4(a`gensym38, b`gensym38, c`gensym38, d`gensym38, e`gensym38, f`gensym38, g`gensym38, h`gensym38, i`gensym38, j`gensym38, k`gensym38, l`gensym38, m`gensym38, n`gensym38, o`gensym38, p`gensym38: float32): Mat4 {. inline.}
```

## **proc** mat2


```nim
proc mat2(a`gensym38, b`gensym38: GVec2[float32]): Mat2 {.inline, tags: [].}
```

## **proc** mat3


```nim
proc mat3(a`gensym38, b`gensym38, c`gensym38: GVec3[float32]): Mat3 {.inline, raises: [].}
```

## **proc** mat4


```nim
proc mat4(a`gensym38, b`gensym38, c`gensym38, d`gensym38: GVec4[float32]): Mat4 {. inline.}
```

## **proc** mat2


```nim
proc mat2(m`gensym38: GMat3[float32]): Mat2 {.inline.}
```

## **proc** mat3


```nim
proc mat3(m`gensym38: GMat4[float32]): Mat3 {.inline.}
```

## **proc** mat3


```nim
proc mat3(m`gensym38: GMat2[float32]): Mat3 {.inline.}
```

## **proc** mat4


```nim
proc mat4(m`gensym38: GMat3[float32]): Mat4 {.inline.}
```

## **proc** mat2


```nim
proc mat2(): Mat2 {.inline.}
```

## **proc** mat3


```nim
proc mat3(): Mat3 {.inline.}
```

## **proc** mat4


```nim
proc mat4(): Mat4 {.inline.}
```

## **proc** dmat2


```nim
proc dmat2(a`gensym39, b`gensym39, c`gensym39, d`gensym39: float64): DMat2 {. inline.}
```

## **proc** dmat3


```nim
proc dmat3(a`gensym39, b`gensym39, c`gensym39, d`gensym39, e`gensym39, f`gensym39, g`gensym39, h`gensym39, i`gensym39: float64): DMat3 {. inline.}
```

## **proc** dmat4


```nim
proc dmat4(a`gensym39, b`gensym39, c`gensym39, d`gensym39, e`gensym39, f`gensym39, g`gensym39, h`gensym39, i`gensym39, j`gensym39, k`gensym39, l`gensym39, m`gensym39, n`gensym39, o`gensym39, p`gensym39: float64): DMat4 {.inline.}
```

## **proc** dmat2


```nim
proc dmat2(a`gensym39, b`gensym39: GVec2[float64]): DMat2 {.inline, tags: [].}
```

## **proc** dmat3


```nim
proc dmat3(a`gensym39, b`gensym39, c`gensym39: GVec3[float64]): DMat3 {.inline, raises: [].}
```

## **proc** dmat4


```nim
proc dmat4(a`gensym39, b`gensym39, c`gensym39, d`gensym39: GVec4[float64]): DMat4 {. inline.}
```

## **proc** dmat2


```nim
proc dmat2(m`gensym39: GMat3[float64]): DMat2 {.inline.}
```

## **proc** dmat3


```nim
proc dmat3(m`gensym39: GMat4[float64]): DMat3 {.inline.}
```

## **proc** dmat3


```nim
proc dmat3(m`gensym39: GMat2[float64]): DMat3 {.inline.}
```

## **proc** dmat4


```nim
proc dmat4(m`gensym39: GMat3[float64]): DMat4 {.inline.}
```

## **proc** dmat2


```nim
proc dmat2(): DMat2 {.inline.}
```

## **proc** dmat3


```nim
proc dmat3(): DMat3 {.inline.}
```

## **proc** dmat4


```nim
proc dmat4(): DMat4 {.inline.}
```

## **proc** `[]`


```nim
proc `[]`[T](a: GMat234[T]; i, j: int): T {.inline.}
```

## **proc** `[]=`


```nim
proc `[]=`[T](a: var GMat234[T]; i, j: int; v: T) {.inline.}
```

## **proc** `~=`


```nim
proc `~=`[T](a, b: GMat2[T]): bool {.inline.}
```

## **proc** `~=`


```nim
proc `~=`[T](a, b: GMat3[T]): bool {.inline.}
```

## **proc** `~=`


```nim
proc `~=`[T](a, b: GMat4[T]): bool {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a, b: GMat3[T]): GMat3[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a: GMat3[T]; b: GVec2[T]): GVec2[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a, b: GMat4[T]): GMat4[T] {.inline.}
```

## **proc** `*`


```nim
proc `*`[T](a: GMat4[T]; b: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** transpose


```nim
proc transpose[T](a: GMat3[T]): GMat3[T] {.inline.}
```

## **proc** transpose


```nim
proc transpose[T](a: GMat4[T]): GMat4[T] {.inline.}
```

## **proc** determinant


```nim
proc determinant[T](a: GMat4[T]): T {.inline.}
```

## **proc** inverse


```nim
proc inverse[T](a: GMat3[T]): GMat3[T] {.inline.}
```

## **proc** inverse


```nim
proc inverse[T](a: GMat4[T]): GMat4[T] {.inline.}
```

## **proc** scale


```nim
proc scale[T](v: GVec2[T]): GMat3[T] {.inline.}
```

## **proc** scale


```nim
proc scale[T](v: GVec3[T]): GMat4[T] {.inline.}
```

## **proc** translate


```nim
proc translate[T](v: GVec2[T]): GMat3[T] {.inline.}
```

## **proc** translate


```nim
proc translate[T](v: GVec3[T]): GMat4[T] {.inline.}
```

## **proc** rotate


```nim
proc rotate[T](angle: T): GMat3[T] {.inline.}
```

## **proc** hrp


```nim
proc hrp[T](m: GMat4[T]): GVec3[T] {.inline.}
```

## **proc** frustum


```nim
proc frustum[T](left, right, bottom, top, near, far: T): GMat4[T] {.inline.}
```

## **proc** perspective


```nim
proc perspective[T](fovy, aspect, near, far: T): GMat4[T] {.inline.}
```

## **proc** ortho


```nim
proc ortho[T](left, right, bottom, top, near, far: T): GMat4[T] {.inline.}
```

## **proc** lookAt


```nim
proc lookAt[T](eye, center: GVec3[T]; up = [T(0), 0, 1]): GMat4[T] {.inline.}
```

## **proc** angle

Angle of a Vec2.

```nim
proc angle[T](a: GVec2[T]): T {.inline.}
```

## **proc** angle

Angle between 2 Vec2.

```nim
proc angle[T](a, b: GVec2[T]): T {.inline.}
```

## **proc** angle

Angle between 2 Vec3.

```nim
proc angle[T](a, b: GVec3[T]): T {.inline.}
```

## **type** Quat


```nim
Quat = GVec4[float32]
```

## **type** DQuat


```nim
DQuat = GVec4[float64]
```

## **proc** quat


```nim
proc quat(): Quat {.inline.}
```

## **proc** quat


```nim
proc quat(x`gensym41, y`gensym41, z`gensym41, w`gensym41: float32): Quat {. inline.}
```

## **proc** quat


```nim
proc quat(x`gensym41: float32): Quat {.inline.}
```

## **proc** quat


```nim
proc quat[T](x`gensym41: GVec4[T]): Quat {.inline.}
```

## **proc** dquat


```nim
proc dquat(): DQuat {.inline.}
```

## **proc** dquat


```nim
proc dquat(x`gensym42, y`gensym42, z`gensym42, w`gensym42: float64): DQuat {. inline.}
```

## **proc** dquat


```nim
proc dquat(x`gensym42: float64): DQuat {.inline.}
```

## **proc** dquat


```nim
proc dquat[T](x`gensym42: GVec4[T]): DQuat {.inline.}
```

## **proc** fromAxisAngle


```nim
proc fromAxisAngle[T](axis: GVec3[T]; angle: T): GVec4[T] {.inline.}
```

## **proc** toAxisAngle


```nim
proc toAxisAngle[T](q: GVec4[T]): (GVec3[T], T) {.inline.}
```

## **proc** orthogonal


```nim
proc orthogonal[T](v: GVec3[T]): GVec3[T] {.inline.}
```

## **proc** fromTwoVectors

Return a quat that would take a and rotate it into b.

```nim
proc fromTwoVectors[T](a, b: GVec3[T]): GVec4[T] {.inline.}
```

## **proc** quat


```nim
proc quat[T](m: GMat4[T]): GVec4[T] {.inline.}
```

## **proc** mat4


```nim
proc mat4[T](q: GVec4[T]): GMat4[T] {.inline.}
```

## **proc** rotate


```nim
proc rotate[T](angle: T; axis: GVec3[T]): GMat4[T] {.inline.}
```

## **proc** rotateX


```nim
proc rotateX[T](angle: T): GMat4[T] {.inline.}
```

## **proc** rotateY


```nim
proc rotateY[T](angle: T): GMat4[T] {.inline.}
```

## **proc** rotateZ


```nim
proc rotateZ[T](angle: T): GMat4[T] {.inline.}
```
