<img src="docs/banner.png">

# VMath - 2D and 3D vector math.

`nimble install vmath`

![Github Actions](https://github.com/treeform/vmath/workflows/Github%20Actions/badge.svg)

[API reference](https://treeform.github.io/vmath)

This library has no dependencies other than the Nim standard library.

Supports c, cpp and js backend.

## About

Your one stop shop for vector math routines for 2D and 3D graphics.

* Pure Nim with no dependencies.
* Very similar to GLSL Shader Language with extra stuff.
* Extensively [benchmarked](tests/bench_raytracer.nim).

## Has vector functions for GLSL types:

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

## 2D & 3D matrix math

You can combine and create 2D and 3D matrices by passing 2D or 3D vectors to matrix functions:

```nim
let mat2d = translate(vec2(10, 20)) * rotate(45.toRadians) * scale(vec2(2))
let mat3d = translate(vec3(10, 20, 0)) * rotateZ(45.toRadians) * scale(vec3(2))
```

## Almost equal operator

Easily check if floating point numbers are close, very useful for tests:
```nim
1.0 ~= 1.0
vec2(1.0, 2.0) ~= vec2(1.0, 2.0)
dvec2(1) ~= dvec2(1)
quat(1.0, 2.0, 3.0, 4.0) ~= quat(1.0, 2.0, 3.0, 4.0)
```

## Number functions

* `between` - Returns true if value is between min and max or equal to them.
* `sign` - Returns the sign of a number, -1 or 1.
* `quantize` - Makes v be a multiple of n. Rounding to integer quantizes by 1.0.
* `lerp` - Interpolates value between a and b.
* `len` - Returns the vector component count or matrix column count.
* `step` - Returns 0.0 if x is less than edge, otherwise 1.0.
* `smoothstep` - Performs smooth Hermite interpolation between 0.0 and 1.0.

## Angle functions

* `fixAngle` - Makes angle be from -PI to PI radians.
* `angleBetween` - Finds the angle between angle a and angle b.
* `turnAngle` - Moves from angle a to angle b with step of v.

## Vector and matrix representation and benchmarks.

C compilers seem to optimize different representations differently. This is very surprising for us and vmath has 3 different implementations:

* `-d:vmathObjBased` - A vector is an object of 3 floats.
* `-d:vmathArrayBased` - A vector is an array of 3 floats.
* `-d:vmathObjArrayBased` (default) - A vector is an object that has an array of 3 floats.

```
name ............................... min time      avg time    std dv   runs
vmathObjBased ..................... 74.061 ms     74.297 ms    ±0.347   x100
vmathArrayBased ................... 89.498 ms     89.911 ms    ±1.019   x100
vmathObjArrayBased ................ 73.968 ms     74.292 ms    ±0.631   x100
```

* [3d Ray Trace Benchmark](tests/bench_raytracer.nim)
* [2d SVG Render Benchmark](https://github.com/treeform/pixie/blob/master/tests/bench_svg.nim)

## Zmod - GLSL mod

GLSL uses a different type of float point mod. Because mod is a Nim keyword, please use `zmod` when you need GLSL `mod` behavior.

## Coordinate System

Right-hand Z-forward coordinate system

This is the same system used in the GLTF file format.

> glTF uses a right-handed coordinate system.
> glTF defines +Y as up, +Z as forward, and -X as right;
> the front of a glTF asset faces +Z.

[glTF Spec 2.0](https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#coordinate-system-and-units)

## How does vmath compare to other libraries?

vmath follows the standard glTF / OpenGL conventions: right-handed coordinate system, column-major matrix storage, and math-style `[row, col]` indexing.

We run identical math operations across vmath, GLSL, [nim-glm](https://github.com/nickelsworth/nim-glm), [gl-matrix](https://github.com/toji/gl-matrix), and [Jolt Physics](https://github.com/jrouwe/JoltPhysics) and compare the generated dumps in [conformance/](conformance/).


| Feature                    | vmath | GLSL | nim-GLM | gl-matrix | Jolt Physics |
|----------------------------|:-----:|:----:|:-------:|:---------:|:------------:|
| Vectors                    | ✅ | ✅ | ✅ | ✅ | ✅ |
| Matrix memory layout       | ✅ | ✅ | ✅ | ✅ | ✅ |
| Matrix multiply            | ✅ | ✅ | ✅ | ✅ | ✅ |
| Matrix-vector multiply     | ✅ | ✅ | ✅ | ✅ | ✅ |
| Rotation matrices          | ✅ | ✅ | ✅ | ✅ | ✅ |
| Translation matrices       | ✅ | ✅ | ✅ | ✅ | ✅ |
| Scale matrices             | ✅ | ✅ | ✅ | ✅ | ✅ |
| Mat2                       | ✅ | ✅ | ✅ | ✅ | N/A |
| Mat3                       | ✅ | ✅ | ✅ | ✅ | N/A |
| Mat3 2D constructors.      | ✅ | ✅ | ✅ | ✅ | N/A |
| Quaternion constructors    | ✅ | ✅ | ✅ | ✅ | ✅ |
| Quaternion multiply        | ✅ | ✅ | ✅ | ✅ | ✅ |
| Quaternion vector rotation | ✅ | ✅ | ✅ | ✅ | ✅ |
| Quaternion-matrix roundtrip| ✅ | ✅ | ✅ | ✅ | ✅ |
| Quaternion inverse         | ✅ | ✅ | ✅ | ✅ | ✅ |
| Quaternion to axis-angle   | ✅ | ✅ | ✅ | ✅ | ✅ |
| Matrix inverse             | ✅ | ✅ | ✅ | ✅ | ✅ |
| Cross product              | ✅ | ✅ | ✅ | ✅ | ✅ |
| Orthogonal vector          | ✅ | ❌ | ❌ | ❌ | ✅ |
| Slerp                      | ✅ | ✅ | ✅ | ✅ | ✅ |
| fromTwoVectors             | ✅ | ✅ | ✅ | ✅ | ✅ |
| Quat decomposition (sign)  | ✅ | ✅ | ✅ | ✅ | ✅ |
| Scaled-matrix decomposition| ✅ | ✅ | ✅ | ✅ | ✅ |
| LookAt matrix              | ✅ | ✅ | ✅ | ✅ | ✅ |
| Perspective matrix         | ✅ | ✅ | ✅ | ✅ | ❌ |
| Ortho matrix               | ✅ | ✅ | ✅ | ✅ | N/A |
| Euler angle decomposition  | ✅ | ✅ | ✅ | N/A | ✅ |
| Element access             | ✅ | ✅ | ✅ | N/A | ❌ |

❌ **Perspective matrix**: Jolt Physics uses Z range `[0, 1]` (Vulkan/DirectX convention) while vmath uses Z range `[-1, 1]` (OpenGL convention). The X and Y scaling match, but Z-related elements differ.

❌ **Element access note**: Jolt does convention differs from vmath's math-style `[row, col]` interpretation it follows the DirectX/HLSL convention.

❌ **Orthogonal vector note**: Jolt Physics provides `GetNormalizedPerpendicular()`. vmath's `orthogonal()` returns a perpendicular vector without normalizing it. GLSL and nim-GLM have no direct equivalent, while gl-matrix only computes one internally as part of `quat.rotationTo()`.

# 2.x.x to 3.0.0 vmath breaking changes:

Version `3.0.0` changed rotation to be CCW (counter-clockwise) and updated the quaternion conventions to match GLSL, GLM, gl-matrix. Added a multi-library conformance suite.

* **Rotation matrices (`rotateX`, `rotateY`, `rotateZ`, 2D `rotate`) now use standard CCW (counter-clockwise) convention.** The sin/cos sign placement in the rotation matrices was swapped. If your code relied on the old CW direction, please negate the angle.
* **Quaternion ↔ matrix conversion (`quat()`, `mat4()`) rewritten.** Uses the standard "biggest component" algorithm matching GLM/GLSL. The off-diagonal signs in `mat4(quat)` were swapped to match the new rotation direction.
* **`toAngles` corrected signs and added gimbal-lock clamping.** No longer negates the Y and Z angles to match the new rotation direction.
* **`fromTwoVectors(a, b)` now rotates `a` into `b`.** Previous behavior had that direction reversed.
* **`lookAt()` un-deprecated.** Restored with Y-up which is glTF/OpenGL convention.
* **New functions added:** `quatInverse`, `slerp`, `quatMultiply`, `quatRotate`, `quatRotateX/Y/Z`, `toAngles(quat)`, `mat4(DMat4)`, `dmat4(Mat4)`, and Mat2 operations (`*`, `transpose`, `determinant`, `inverse`).

# 1.x.x to 2.0.0 vmath breaking changes:
* New right-hand-Z-forward coordinate system and functions that care about
coordinate system were moved there.
* Deprecated `lookAt()`, please use `toAngles()`/`fromAngles()` instead.
* Deprecated `fractional()`, use `frac()` instead.

# 0.x.x to 1.0.0 vmath breaking changes:

* `vec3(v)` no longer works, please use `vec3(v.x, v.y, 0)` instead.
* `vec3(v, 0)` no longer works, please use `vec3(v.x, v.y, 0)` instead.
* `2 * v` no longer works due to more vec types, please use `v * 2` instead.
* `m[15]` no longer works because matrices are now m[x, y].
* Concept of 3x3 rotation 3D matrix was removed.
* `angleBetween` got renamed to `angle(a, b)`
* `scaleMat` got renamed to `scale(v)`
* `rotationMat3` got renamed to `rotate(x)`
