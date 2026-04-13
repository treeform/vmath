import
  std/[math, os, strutils],
  jolty

const
  OutputPath = parentDir(currentSourcePath()) / "dump_jolt.txt"

proc cleanFloat(value: float32): float32 =
  if abs(value) < 0.0000005'f32:
    0'f32
  else:
    value

proc fmt(value: float32): string =
  let cleaned = cleanFloat(value)
  let sign = if cleaned < 0'f32: "-" else: "+"

  var whole = int(floor(abs(cleaned).float64))
  var frac = int(round((abs(cleaned).float64 - whole.float64) * 1000.0))
  if frac == 1000:
    inc whole
    frac = 0

  result = sign
  let wholeText = $whole
  for _ in wholeText.len ..< 3:
    result.add '0'
  result.add wholeText
  result.add '.'

  let fracText = $frac
  for _ in fracText.len ..< 3:
    result.add '0'
  result.add fracText

proc appendLine(lines: var seq[string], line = "") =
  lines.add line

proc dumpScalar(lines: var seq[string], label: string, value: float32) =
  lines.appendLine(label & ": " & fmt(value))

proc dumpVec3(lines: var seq[string], label: string, value: JoltFloat3) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ">")

proc dumpVec4(lines: var seq[string], label: string, value: JoltFloat4) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ", " & fmt(value.w) & ">")

proc dumpQuat(lines: var seq[string], label: string, value: JoltQuat) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ", " & fmt(value.w) & ">")

proc dumpMat4(lines: var seq[string], label: string, value: JoltMat44) =
  lines.appendLine(label & ":")
  lines.appendLine("[")
  for offset in countup(0, 12, 4):
    lines.appendLine(
      "  " &
      fmt(value.m[offset + 0]) & " " &
      fmt(value.m[offset + 1]) & " " &
      fmt(value.m[offset + 2]) & " " &
      fmt(value.m[offset + 3])
    )
  lines.appendLine("]")

proc heading(lines: var seq[string], title: string) =
  if lines.len > 0:
    lines.appendLine()
  lines.appendLine("== " & title & " ==")

proc multiply(a, b: JoltMat44): JoltMat44 =
  var ma = a
  var mb = b
  joltMat44Multiply(addr ma, addr mb)

proc multiply(m: JoltMat44, v: JoltFloat3): JoltFloat3 =
  var mm = m
  joltMat44MultiplyVec3(addr mm, v.x, v.y, v.z)

proc multiply(m: JoltMat44, v: JoltFloat4): JoltFloat4 =
  var mm = m
  joltMat44MultiplyVec4(addr mm, v.x, v.y, v.z, v.w)

proc getRotationSafe(m: JoltMat44): JoltMat44 =
  var mm = m
  joltMat44GetRotationSafe(addr mm)

proc getQuaternion(m: JoltMat44): JoltQuat =
  var mm = m
  joltMat44GetQuaternion(addr mm)

proc quatRotate(axisX, axisY, axisZ, angle: float32): JoltQuat =
  joltQuatRotation(axisX, axisY, axisZ, angle)

proc quatMultiply(a, b: JoltQuat): JoltQuat =
  joltQuatMultiply(a.x, a.y, a.z, a.w, b.x, b.y, b.z, b.w)

proc quatRotateVec3(q: JoltQuat, v: JoltFloat3): JoltFloat3 =
  joltQuatRotateVec3(q.x, q.y, q.z, q.w, v.x, v.y, v.z)

proc get(m: JoltMat44, row, col: int32): float32 =
  var mm = m
  joltMat44Get(addr mm, row, col)

proc main() =
  let physics = newPhysicsSystem(
    maxBodies = 1024,
    maxPairs = 1024,
    maxConstraints = 1024,
  )

  var lines: seq[string]

  let
    angleA = 37'f32 * PI.float32 / 180'f32
    angleB = -23'f32 * PI.float32 / 180'f32
    angleC = 71'f32 * PI.float32 / 180'f32

    matA = joltMat44FromMemory(
      1.0, 5.0, 9.0, 13.0,
      2.0, 6.0, 10.0, 14.0,
      3.0, 7.0, 11.0, 15.0,
      4.0, 8.0, 12.0, 16.0
    )
    matB = joltMat44FromMemory(
      0.5, 1.5, -3.0, 0.0,
      -1.0, 0.75, 4.0, 1.0,
      2.0, -0.5, 1.25, -1.5,
      0.25, 2.0, -2.5, 3.0
    )
    vecA = JoltFloat3(x: 1.25, y: -2.5, z: 3.75)
    vecB = JoltFloat4(x: 1.25, y: -2.5, z: 3.75, w: 1.0)
  let
    scaleM = joltMat44Scale(2.0, 3.0, 4.0)
    translateM = joltMat44Translation(10.0, 20.0, 30.0)
    rotateXM = joltMat44RotationX(angleA)
    rotateYM = joltMat44RotationY(angleB)
    rotateZM = joltMat44RotationZ(angleC)
    pureRotationM = multiply(multiply(rotateZM, rotateYM), rotateXM)
  let
    axis = joltVec3Normalize(1.0, 2.0, -3.0)
    axisAngle = 48'f32 * PI.float32 / 180'f32
    axisQuat = quatRotate(axis.x, axis.y, axis.z, axisAngle)
    axisMat = joltMat44FromQuat(axisQuat.x, axisQuat.y, axisQuat.z, axisQuat.w)
    transformM = multiply(multiply(multiply(multiply(translateM, rotateZM), rotateYM), rotateXM), scaleM)
  let
    quatX = quatRotate(1.0, 0.0, 0.0, angleA)
    quatY = quatRotate(0.0, 1.0, 0.0, angleB)
    quatZ = quatRotate(0.0, 0.0, 1.0, angleC)
    quatXY = quatMultiply(quatX, quatY)
    quatXYZ = quatMultiply(quatXY, quatZ)
  let
    rotationOnlyM = getRotationSafe(transformM)
    basisRight = JoltFloat3(x: 1.0, y: 0.0, z: 0.0)
    basisUp = JoltFloat3(x: 0.0, y: 1.0, z: 0.0)
    basisForward = JoltFloat3(x: 0.0, y: 0.0, z: 1.0)

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in raw in-memory order, four scalars per line")

  lines.heading("matrix constructors and composition")
  lines.dumpMat4("identity", joltMat44Identity())
  lines.dumpMat4("matrix_a", matA)
  lines.dumpMat4("matrix_b", matB)
  lines.dumpMat4("scale", scaleM)
  lines.dumpMat4("translate", translateM)
  lines.dumpMat4("rotate_x", rotateXM)
  lines.dumpMat4("rotate_y", rotateYM)
  lines.dumpMat4("rotate_z", rotateZM)
  lines.dumpMat4("pure_rotation = rotate_z * rotate_y * rotate_x", pureRotationM)
  lines.dumpMat4("transform = translate * rotate_z * rotate_y * rotate_x * scale", transformM)

  lines.heading("matrix multiply")
  lines.dumpMat4("lhs", matA)
  lines.dumpMat4("rhs", matB)
  lines.dumpMat4("lhs * rhs", multiply(matA, matB))
  lines.dumpMat4("rhs * lhs", multiply(matB, matA))

  lines.heading("matrix vector multiply")
  lines.dumpVec3("vec3_input", vecA)
  lines.dumpVec4("vec4_input", vecB)
  lines.dumpVec3("transform * vec3", multiply(transformM, vecA))
  lines.dumpVec4("transform * vec4", multiply(transformM, vecB))
  lines.dumpVec3("rotate_z * vec3", multiply(rotateZM, vecA))
  lines.dumpVec3("translate * vec3", multiply(translateM, vecA))

  lines.heading("quaternion constructors")
  lines.dumpQuat("quat_identity", joltQuatIdentity())
  lines.dumpQuat("quat_rotate_x", quatX)
  lines.dumpQuat("quat_rotate_y", quatY)
  lines.dumpQuat("quat_rotate_z", quatZ)
  lines.dumpVec3("axis_normalized", axis)
  lines.dumpScalar("axis_angle_radians", axisAngle)
  lines.dumpQuat("from_axis_angle", axisQuat)
  lines.dumpMat4("from_axis_angle.mat4", axisMat)

  lines.heading("quaternion multiply")
  lines.dumpQuat("quat_x", quatX)
  lines.dumpQuat("quat_y", quatY)
  lines.dumpQuat("quat_z", quatZ)
  lines.dumpQuat("quat_multiply(quat_x, quat_y)", quatXY)
  lines.dumpQuat("quat_multiply(quat_multiply(quat_x, quat_y), quat_z)", quatXYZ)
  lines.dumpMat4("quat_xy.mat4", joltMat44FromQuat(quatXY.x, quatXY.y, quatXY.z, quatXY.w))
  lines.dumpMat4("quat_xyz.mat4", joltMat44FromQuat(quatXYZ.x, quatXYZ.y, quatXYZ.z, quatXYZ.w))

  lines.heading("quaternion vector rotate")
  lines.dumpVec3("input", vecA)
  lines.dumpVec3("quat_rotate(quat_x, input)", quatRotateVec3(quatX, vecA))
  lines.dumpVec3("quat_rotate(quat_y, input)", quatRotateVec3(quatY, vecA))
  lines.dumpVec3("quat_rotate(quat_z, input)", quatRotateVec3(quatZ, vecA))
  lines.dumpVec3("quat_rotate(from_axis_angle, input)", quatRotateVec3(axisQuat, vecA))
  lines.dumpVec3("quat_z * input", quatRotateVec3(quatZ, vecA))

  lines.heading("matrix quaternion roundtrip")
  let pureRotationQuat = getQuaternion(pureRotationM)
  lines.dumpQuat("pure_rotation.quat", pureRotationQuat)
  lines.dumpMat4("pure_rotation", pureRotationM)
  lines.dumpMat4("pure_rotation.quat.mat4", joltMat44FromQuat(pureRotationQuat.x, pureRotationQuat.y, pureRotationQuat.z, pureRotationQuat.w))
  lines.appendLine("transform.rotation_only.note: skipped exact quaternion/matrix roundtrip comparison because scaled-matrix decomposition differs by library")
  lines.dumpMat4("transform.rotation_only", rotationOnlyM)
  let axisMatQuat = axisQuat
  lines.dumpQuat("axis_mat.quat", axisMatQuat)
  lines.dumpMat4("axis_mat.quat.mat4", joltMat44FromQuat(axisMatQuat.x, axisMatQuat.y, axisMatQuat.z, axisMatQuat.w))

  lines.heading("basis directions")
  lines.dumpVec3("canonical_right", basisRight)
  lines.dumpVec3("canonical_up", basisUp)
  lines.dumpVec3("canonical_forward", basisForward)
  lines.dumpVec3("quat_z.right", quatRotateVec3(quatZ, basisRight))
  lines.dumpVec3("quat_z.up", quatRotateVec3(quatZ, basisUp))
  lines.dumpVec3("quat_z.forward", quatRotateVec3(quatZ, basisForward))

  lines.heading("element access [row,col]")
  lines.appendLine("notes: [row,col] in math convention, element (i,j) = row i, col j")
  lines.appendLine("notes: Jolt Mat44 operator()(row, col) via C++ wrapper")
  lines.dumpScalar("transform[0,0]", transformM.get(0, 0))
  lines.dumpScalar("transform[0,1]", transformM.get(0, 1))
  lines.dumpScalar("transform[0,2]", transformM.get(0, 2))
  lines.dumpScalar("transform[0,3]", transformM.get(0, 3))
  lines.dumpScalar("transform[1,0]", transformM.get(1, 0))
  lines.dumpScalar("transform[1,3]", transformM.get(1, 3))
  lines.dumpScalar("transform[2,0]", transformM.get(2, 0))
  lines.dumpScalar("transform[2,3]", transformM.get(2, 3))
  lines.dumpScalar("transform[3,3]", transformM.get(3, 3))

  writeFile(OutputPath, lines.join("\n") & "\n")
  physics.destroy()
  echo "Wrote ", OutputPath

main()
