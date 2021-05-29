<img src="docs/banner.png">

# VMath

`nimble install vmath`

Your single stop for vector math routines for 2d and 3d graphics.

* Pure nim no dependencies.
* Tries to be similar to GLSL Shader Language but adds extra stuff.
* Extensively Benchmarked.
* Docs: https://nimdocs.com/treeform/vmath

## Has vector functions for GLSL tyes:

Type  | Constructor | Description
------|-------------| ---------------------------------------------------
BVec# | bvec#       | a vector of booleans
IVec# | ivec#       | a vector of signed integers
UVec# | uvec#       | a vector of unsigned integers
Vec#  | vec#        | a vector of single-precision floating-point numbers
DVec# | dvec#       | a vector of double-precision floating-point numbers

You can use these constructors to make them:

NIM     | GLSL   | 2     | 3     | 4     | 9     | 16    | 4     |
--------|--------|-------|-------|-------|-------|-------|-------|
bool    | bool   | BVec2 | BVec3 | BVec4 |       |       |       |
int32   | int    | IVec2 | IVec3 | IVec4 |       |       |       |
uint32  | uint   | UVec2 | UVec3 | UVec4 |       |       |       |
float32 | float  | Vec2  | Vec3  | Vec4  | Mat3  | Mat4  | Quat  |
float64 | double | DVec2 | DVec3 | DVec4 | DMat3 | DMat4 | DQuat |

## 2D & 3D Matrix math

You can combine and create matrices 2d and 3d matrices by passing 2d or 3d vectors to matrix functions:

```nim
let mat2d = translate(vec2(10, 20)) * rotate(45.toRadians) * scale(vec2(2))
let mat3d = translate(vec3(10, 20, 0)) * rotateZ(45.toRadians) * scale(vec3(2))
```

## Almost equal operator

You can check if float point numbers are close, very useful for tests:
```nim
1.0 ~= 1.0
0.0 ~= 0.0
-1.0 ~= -1.0
not(0.1 ~= 0.2)
not(0.01 ~= 0.02)
not(0.001 ~= 0.002)
not(0.0001 ~= 0.0002)
not(0.00001 ~= 0.00002)
```

## Number functions

* `between` - Returns true if value is between min and max or equal to them.
* `sign` - Returns the sign of a number, -1 or 1.
* `quantize` - Makes v be multiple of n. Rounding to integer quantize by 1.0.
* `fractional` - Returns fractional part of a number. 3.14 -> 0.14
* `lerp` - Interpolates value between a and b.

## Angle functions

* `fixAngle` - Make angle be from -PI to PI radians.
* `angleBetween` - Angle between angle a and angle b.
* `turnAngle` - Move from angle a to angle b with step of v.

# 0.x.x to 1.0.0 vmath breaking changes:

* `vec3(v)` no longer works please use `vec3(v.x, v.y, 0)` instead.
* `vec3(v, 0)` no longer works please use `vec3(v.x, v.y, 0)` instead.
* `2 * v` no longer works due to more vec types please use `v * 2` instead.
* `m[15]` no longer works because matrices are now m[x, y].
* Concept of 3x3 rotation 3d matrix was removed.
* `angleBetween` got renamed to `angle(a, b)`
* `scaleMat` got renamed to `scale(v)`
* `rotationMat3` got renamed to `rotate(x)`
