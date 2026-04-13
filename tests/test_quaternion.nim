import
  std/[math, random],
  vmath

randomize(4321)

proc quatEquivalent[T](a, b: GVec4[T]): bool =
  (a ~= b) or (a ~= (b * -1.0))

proc randomAxis(): DVec3 =
  while true:
    let axis = dvec3(rand(2.0) - 1.0, rand(2.0) - 1.0, rand(2.0) - 1.0)
    if axis.length > 0.0001:
      return axis.normalize()

block:
  # Axis-angle and quaternion constructors should agree on the same matrix.
  doAssert quatRotateX(PI / 2).mat4() ~= rotateX(PI / 2)
  doAssert quatRotateY(PI / 2).mat4() ~= rotateY(PI / 2)
  doAssert quatRotateZ(PI / 2).mat4() ~= rotateZ(PI / 2)

  for _ in 0 ..< 2000:
    let
      axis = randomAxis()
      angle = rand(-PI .. PI)
      q = fromAxisAngle(axis, angle)
      m = rotate(angle, axis)
    doAssert q.mat4() ~= m
    doAssert quatEquivalent(m.quat(), q)
    doAssert m.quat().mat4() ~= m

block:
  # Known rotations should produce the expected quaternion values.
  doAssert quatEquivalent(rotateX(PI / 2).quat(), quatRotateX(PI / 2))
  doAssert quatEquivalent(rotateY(PI / 2).quat(), quatRotateY(PI / 2))
  doAssert quatEquivalent(rotateZ(PI / 2).quat(), quatRotateZ(PI / 2))
  doAssert quatEquivalent(mat4().quat(), quat(0f, 0f, 0f, 1f))

block:
  # Quaternion multiplication should compose rotations in matrix order.
  let
    qx = quatRotateX(0.37)
    qy = quatRotateY(-0.91)
    qz = quatRotateZ(1.24)

    mxy = rotateX(0.37) * rotateY(-0.91)
    myz = rotateY(-0.91) * rotateZ(1.24)
    mxyz = rotateX(0.37) * rotateY(-0.91) * rotateZ(1.24)

  doAssert quatMultiply(qx, qy).mat4() ~= mxy
  doAssert quatMultiply(qy, qz).mat4() ~= myz
  doAssert quatMultiply(quatMultiply(qx, qy), qz).mat4() ~= mxyz

block:
  # Rotating vectors with quaternion-derived matrices should match helpers.
  let
    x = dvec3(1, 0, 0)
    y = dvec3(0, 1, 0)
    z = dvec3(0, 0, 1)

  doAssert quatRotateY(PI / 2).mat4() * x ~= dvec3(0, 0, -1)
  doAssert quatRotateX(PI / 2).mat4() * y ~= dvec3(0, 0, 1)
  doAssert quatRotateZ(PI / 2).mat4() * x ~= dvec3(0, 1, 0)
  doAssert quatRotate(quatRotateY(PI / 2), x) ~= dvec3(0, 0, -1)
  doAssert quatRotate(quatRotateX(PI / 2), y) ~= dvec3(0, 0, 1)
  doAssert quatRotate(quatRotateZ(PI / 2), x) ~= dvec3(0, 1, 0)
  doAssert quatRotateY(PI / 2) * x ~= dvec3(0, 0, -1)
  doAssert quatRotateX(PI / 2) * y ~= dvec3(0, 0, 1)
  doAssert quatRotateZ(PI / 2) * x ~= dvec3(0, 1, 0)
  doAssert fromTwoVectors(x, y).mat4() * x ~= y
  doAssert fromTwoVectors(y, z).mat4() * y ~= z

  for _ in 0 ..< 2000:
    let
      a = randomAxis()
      b = randomAxis()
      q = fromTwoVectors(a, b)
      v = randomAxis()
    doAssert dist(q.mat4() * a, b) < 1e-5
    doAssert quatRotate(q, v) ~= q.mat4() * v
    doAssert q * v ~= q.mat4() * v

block:
  # Basic arithmetic operators should still behave like vec4 math.
  let
    a = dquat(1, 2, 3, 4)
    b = dquat(-0.5, 0.25, 2.0, -3.0)
  doAssert a + b ~= dquat(0.5, 2.25, 5.0, 1.0)
  doAssert a - b ~= dquat(1.5, 1.75, 1.0, 7.0)
  doAssert a * 2.0 ~= dquat(2, 4, 6, 8)
  doAssert b / 2.0 ~= dquat(-0.25, 0.125, 1.0, -1.5)
