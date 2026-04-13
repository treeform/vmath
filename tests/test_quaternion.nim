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

block:
  # toAxisAngle should roundtrip with fromAxisAngle.
  let
    axis = dvec3(1, 2, -3).normalize()
    angle = 48.0.toRadians
    q = fromAxisAngle(axis, angle)
    (extractedAxis, extractedAngle) = toAxisAngle(q)
  doAssert extractedAxis ~= axis
  doAssert abs(extractedAngle - angle) < 1e-5

  # Identity quaternion should give 0 angle.
  let (_, identityAngle) = toAxisAngle(dquat(0, 0, 0, 1))
  doAssert abs(identityAngle) < 1e-5

  # 90 degree rotations around each axis.
  for axisVec in [dvec3(1, 0, 0), dvec3(0, 1, 0), dvec3(0, 0, 1)]:
    let
      q = fromAxisAngle(axisVec, PI / 2)
      (a, ang) = toAxisAngle(q)
    doAssert a ~= axisVec
    doAssert abs(ang - PI / 2) < 1e-5

  # Random roundtrip fuzz test.
  for _ in 0 ..< 2000:
    let
      axis = randomAxis()
      angle = rand(0.001 .. PI) # positive angles, avoid 0 and 2*PI degeneracy
      q = fromAxisAngle(axis, angle)
      (a, ang) = toAxisAngle(q)
    doAssert a ~= axis
    doAssert abs(ang - angle) < 1e-4

block:
  # quatInverse: q * q^-1 should be identity.
  let
    axis = dvec3(1, 2, -3).normalize()
    angle = 48.0.toRadians
    q = fromAxisAngle(axis, angle)
    qInv = quatInverse(q)
    product = quatMultiply(q, qInv)
  doAssert quatEquivalent(product, dquat(0, 0, 0, 1))

  # Inverse should undo rotation.
  let
    v = dvec3(1.25, -2.5, 3.75)
    rotated = quatRotate(q, v)
    unrotated = quatRotate(qInv, rotated)
  doAssert unrotated ~= v

  # For unit quaternions, inverse == conjugate.
  let conjugate = dquat(-q.x, -q.y, -q.z, q.w)
  doAssert qInv ~= conjugate

  # Random fuzz test.
  for _ in 0 ..< 2000:
    let
      q = fromAxisAngle(randomAxis(), rand(-PI .. PI))
      qInv = quatInverse(q)
      product = quatMultiply(q, qInv)
    doAssert quatEquivalent(product, dquat(0, 0, 0, 1))

block:
  # slerp at endpoints should return the inputs.
  let
    qx = quatRotateX(0.37)
    qz = quatRotateZ(1.24)
  doAssert slerp(qx, qz, 0.0) ~= qx
  doAssert quatEquivalent(slerp(qx, qz, 1.0), qz)

  # slerp at t=0.5 should be halfway between.
  let mid = slerp(qx, qz, 0.5)
  # The midpoint should be equidistant in angle from both endpoints.
  let angleTo0 = arccos(clamp(dot(qx, mid), -1.0, 1.0))
  let angleTo1 = arccos(clamp(dot(mid, qz), -1.0, 1.0))
  doAssert abs(angleTo0 - angleTo1) < 1e-5

  # slerp should produce unit quaternions.
  for i in 0 .. 10:
    let t = i.float64 / 10.0
    let q = slerp(qx, qz, t)
    doAssert abs(q.length - 1.0) < 1e-5

  # slerp with identical quaternions should return the same quaternion.
  doAssert slerp(qx, qx, 0.5) ~= qx

  # slerp should handle opposite quaternions (q and -q represent same rotation).
  let qNeg = -qz
  let result = slerp(qx, qNeg, 0.5)
  doAssert abs(result.length - 1.0) < 1e-5

  # Random fuzz: slerp result should always be unit length.
  for _ in 0 ..< 2000:
    let
      a = fromAxisAngle(randomAxis(), rand(-PI .. PI))
      b = fromAxisAngle(randomAxis(), rand(-PI .. PI))
      t = rand(0.0 .. 1.0)
      q = slerp(a, b, t)
    doAssert abs(q.length - 1.0) < 1e-5
    # The slerp rotation should produce the same result as its matrix form.
    let v = randomAxis()
    doAssert quatRotate(q, v) ~= q.mat4() * v

echo "test_quaternion finished successfully"
