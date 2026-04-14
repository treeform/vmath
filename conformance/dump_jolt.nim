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
  # for offset in countup(0, 12, 4):
  #   lines.appendLine(
  #     "  " &
  #     fmt(value.m[offset + 0]) & " " &
  #     fmt(value.m[offset + 1]) & " " &
  #     fmt(value.m[offset + 2]) & " " &
  #     fmt(value.m[offset + 3])
  #   )
  let d = cast[array[16, float32]](value)
  lines.appendLine("  " & fmt(d[0]) & " " & fmt(d[4]) & " " & fmt(d[8]) & " " & fmt(d[12]) )
  lines.appendLine("  " & fmt(d[1]) & " " & fmt(d[5]) & " " & fmt(d[9]) & " " & fmt(d[13]) )
  lines.appendLine("  " & fmt(d[2]) & " " & fmt(d[6]) & " " & fmt(d[10]) & " " & fmt(d[14]) )
  lines.appendLine("  " & fmt(d[3]) & " " & fmt(d[7]) & " " & fmt(d[11]) & " " & fmt(d[15]) )
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

    matA = cast[JoltMat44]([
      1.0f, 2.0f, 3.0f, 4.0f,
      5.0f, 6.0f, 7.0f, 8.0f,
      9.0f, 10.0f, 11.0f, 12.0f,
      13.0f, 14.0f, 15.0f, 16.0f
    ])

    matB = cast[JoltMat44]([
      -10.0f, -20.0f, -30.0f, -40.0f,
      50.0f, 60.0f, 70.0f, 80.0f,
      90.0f, 100.0f, 110.0f, 120.0f,
      130.0f, 140.0f, 150.0f, 160.0f
    ])
  #   matB = joltMat44FromMemory(
  #     0.5, 1.5, -3.0, 0.0,
  #     -1.0, 0.75, 4.0, 1.0,
  #     2.0, -0.5, 1.25, -1.5,
  #     0.25, 2.0, -2.5, 3.0
  #   )
  #   vecA = JoltFloat3(x: 1.25, y: -2.5, z: 3.75)
  #   vecB = JoltFloat4(x: 1.25, y: -2.5, z: 3.75, w: 1.0)
  # let
  #   scaleM = joltMat44Scale(2.0, 3.0, 4.0)
  #   translateM = joltMat44Translation(10.0, 20.0, 30.0)
  #   rotateXM = joltMat44RotationX(angleA)
  #   rotateYM = joltMat44RotationY(angleB)
  #   rotateZM = joltMat44RotationZ(angleC)
  #   pureRotationM = multiply(multiply(rotateZM, rotateYM), rotateXM)
  # let
  #   axis = joltVec3Normalize(1.0, 2.0, -3.0)
  #   axisAngle = 48'f32 * PI.float32 / 180'f32
  #   axisQuat = quatRotate(axis.x, axis.y, axis.z, axisAngle)
  #   axisMat = joltMat44FromQuat(axisQuat.x, axisQuat.y, axisQuat.z, axisQuat.w)
  #   transformM = multiply(multiply(multiply(multiply(translateM, rotateZM), rotateYM), rotateXM), scaleM)
  # let
  #   quatX = quatRotate(1.0, 0.0, 0.0, angleA)
  #   quatY = quatRotate(0.0, 1.0, 0.0, angleB)
  #   quatZ = quatRotate(0.0, 0.0, 1.0, angleC)
  #   quatXY = quatMultiply(quatX, quatY)
  #   quatXYZ = quatMultiply(quatXY, quatZ)
  # let
  #   hardAxis = joltVec3Normalize(1.0, -2.0, 3.0)
  #   hardAngle = 170'f32 * PI.float32 / 180'f32
  #   hardQuat = quatRotate(hardAxis.x, hardAxis.y, hardAxis.z, hardAngle)
  #   hardMat = joltMat44FromQuat(hardQuat.x, hardQuat.y, hardQuat.z, hardQuat.w)
  # let
  #   rotationOnlyM = getRotationSafe(transformM)

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in raw in-memory order, four scalars per line")

  lines.heading("matrix constructors and composition")
  #lines.dumpMat4("identity", joltMat44Identity())
  lines.dumpMat4("matrix_a", matA)
  lines.dumpMat4("matrix_b", matB)
  lines.dumpMat4("matrix_a * matrix_b", multiply(matA, matB))
  lines.dumpMat4("matrix_b * matrix_a", multiply(matB, matA))
  # lines.dumpMat4("matrix_b", matB)
  # lines.dumpMat4("scale", scaleM)
  # lines.dumpMat4("translate", translateM)
  # lines.dumpMat4("rotate_x", rotateXM)
  # lines.dumpMat4("rotate_y", rotateYM)
  # lines.dumpMat4("rotate_z", rotateZM)
  # lines.dumpMat4("pure_rotation = rotate_z * rotate_y * rotate_x", pureRotationM)
  # lines.dumpMat4("transform = translate * rotate_z * rotate_y * rotate_x * scale", transformM)

  # lines.heading("matrix multiply")
  # lines.dumpMat4("lhs", matA)
  # lines.dumpMat4("rhs", matB)
  # lines.dumpMat4("lhs * rhs", multiply(matA, matB))
  # lines.dumpMat4("rhs * lhs", multiply(matB, matA))

  # lines.heading("matrix vector multiply")
  # lines.dumpVec3("vec3_input", vecA)
  # lines.dumpVec4("vec4_input", vecB)
  # lines.dumpVec3("transform * vec3", multiply(transformM, vecA))
  # lines.dumpVec4("transform * vec4", multiply(transformM, vecB))
  # lines.dumpVec3("rotate_z * vec3", multiply(rotateZM, vecA))
  # lines.dumpVec3("translate * vec3", multiply(translateM, vecA))

  # lines.heading("quaternion constructors")
  # lines.dumpQuat("quat_identity", joltQuatIdentity())
  # lines.dumpQuat("quat_rotate_x", quatX)
  # lines.dumpQuat("quat_rotate_y", quatY)
  # lines.dumpQuat("quat_rotate_z", quatZ)
  # lines.dumpVec3("axis_normalized", axis)
  # lines.dumpScalar("axis_angle_radians", axisAngle)
  # lines.dumpQuat("from_axis_angle", axisQuat)
  # lines.dumpMat4("from_axis_angle.mat4", axisMat)

  # lines.heading("quaternion multiply")
  # lines.dumpQuat("quat_x", quatX)
  # lines.dumpQuat("quat_y", quatY)
  # lines.dumpQuat("quat_z", quatZ)
  # lines.dumpQuat("quat_multiply(quat_x, quat_y)", quatXY)
  # lines.dumpQuat("quat_multiply(quat_multiply(quat_x, quat_y), quat_z)", quatXYZ)
  # lines.dumpMat4("quat_xy.mat4", joltMat44FromQuat(quatXY.x, quatXY.y, quatXY.z, quatXY.w))
  # lines.dumpMat4("quat_xyz.mat4", joltMat44FromQuat(quatXYZ.x, quatXYZ.y, quatXYZ.z, quatXYZ.w))

  # lines.heading("quaternion vector rotate")
  # lines.dumpVec3("input", vecA)
  # lines.dumpVec3("quat_rotate(quat_x, input)", quatRotateVec3(quatX, vecA))
  # lines.dumpVec3("quat_rotate(quat_y, input)", quatRotateVec3(quatY, vecA))
  # lines.dumpVec3("quat_rotate(quat_z, input)", quatRotateVec3(quatZ, vecA))
  # lines.dumpVec3("quat_rotate(from_axis_angle, input)", quatRotateVec3(axisQuat, vecA))
  # lines.dumpVec3("quat_z * input", quatRotateVec3(quatZ, vecA))

  # lines.heading("matrix quaternion roundtrip")
  # let pureRotationQuat = getQuaternion(pureRotationM)
  # lines.dumpQuat("pure_rotation.quat", pureRotationQuat)
  # lines.dumpMat4("pure_rotation", pureRotationM)
  # lines.dumpMat4("pure_rotation.quat.mat4", joltMat44FromQuat(pureRotationQuat.x, pureRotationQuat.y, pureRotationQuat.z, pureRotationQuat.w))
  # lines.dumpMat4("transform.rotation_only", rotationOnlyM)
  # lines.dumpQuat("transform.rotation_only.quat", getQuaternion(rotationOnlyM))
  # let axisMatQuat = axisQuat
  # lines.dumpQuat("axis_mat.quat", axisMatQuat)
  # lines.dumpMat4("axis_mat.quat.mat4", joltMat44FromQuat(axisMatQuat.x, axisMatQuat.y, axisMatQuat.z, axisMatQuat.w))
  # lines.appendLine("hard_decomp.note: 170 degrees around (1,-2,3) normalized - w near zero")
  # lines.dumpQuat("hard_decomp.quat_original", hardQuat)
  # let hardMatQuat = getQuaternion(hardMat)
  # lines.dumpQuat("hard_decomp.quat_from_mat", hardMatQuat)
  # lines.dumpMat4("hard_decomp.mat4", hardMat)
  # lines.dumpMat4("hard_decomp.quat_from_mat.mat4", joltMat44FromQuat(hardMatQuat.x, hardMatQuat.y, hardMatQuat.z, hardMatQuat.w))

  # let fovyRad = 60'f32 * PI.float32 / 180'f32

  # lines.heading("perspective matrix")
  # lines.appendLine("notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0")
  # lines.appendLine("notes: Jolt uses Z range [0,1] (Vulkan/DirectX convention), values will differ from OpenGL [-1,1]")
  # lines.dumpMat4("perspective", joltMat44Perspective(fovyRad, 1.5'f32, 0.1'f32, 100'f32))

  # lines.heading("ortho matrix")
  # lines.appendLine("N/A")

  # lines.heading("lookAt matrix")
  # lines.appendLine("notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)")
  # lines.dumpMat4("lookAt", joltMat44LookAt(5, 5, 5, 0, 0, 0, 0, 1, 0))

  # lines.heading("euler angle decomposition")
  # lines.appendLine("notes: euler angles as vec3(pitch/x, yaw/y, roll/z) in radians")
  # let pureRotEuler = joltQuatGetEulerAngles(pureRotationQuat.x, pureRotationQuat.y, pureRotationQuat.z, pureRotationQuat.w)
  # let axisEuler = joltQuatGetEulerAngles(axisQuat.x, axisQuat.y, axisQuat.z, axisQuat.w)
  # lines.dumpVec3("pure_rotation.quat.euler", pureRotEuler)
  # lines.dumpVec3("from_axis_angle.euler", axisEuler)

  # lines.heading("matrix inverse")
  # var transformInv = transformM
  # lines.dumpMat4("transform.inverse", joltMat44Inverse(addr transformInv))
  # var pureRotInv = pureRotationM
  # lines.dumpMat4("pure_rotation.inverse", joltMat44Inverse(addr pureRotInv))

  # lines.heading("cross product")
  # lines.appendLine("notes: cross(a, b) where a and b are vec3")
  # lines.dumpVec3("cross(x_axis, y_axis)", joltVec3Cross(1, 0, 0, 0, 1, 0))
  # lines.dumpVec3("cross(y_axis, x_axis)", joltVec3Cross(0, 1, 0, 1, 0, 0))
  # let crossC = joltVec3Normalize(1, 2, 3)
  # let crossD = joltVec3Normalize(-1, 0.5, 2)
  # lines.dumpVec3("cross(c, d)", joltVec3Cross(crossC.x, crossC.y, crossC.z, crossD.x, crossD.y, crossD.z))

  # lines.heading("slerp")
  # lines.appendLine("notes: slerp(a, b, t) between quat_x and quat_z")
  # lines.dumpQuat("slerp(quat_x, quat_z, 0.25)", joltQuatSlerp(quatX.x, quatX.y, quatX.z, quatX.w, quatZ.x, quatZ.y, quatZ.z, quatZ.w, 0.25))
  # lines.dumpQuat("slerp(quat_x, quat_z, 0.5)", joltQuatSlerp(quatX.x, quatX.y, quatX.z, quatX.w, quatZ.x, quatZ.y, quatZ.z, quatZ.w, 0.5))
  # lines.dumpQuat("slerp(quat_x, quat_z, 0.75)", joltQuatSlerp(quatX.x, quatX.y, quatX.z, quatX.w, quatZ.x, quatZ.y, quatZ.z, quatZ.w, 0.75))

  # lines.heading("fromTwoVectors")
  # lines.appendLine("notes: quaternion that rotates vector a to vector b")
  # let ftFromA = JoltFloat3(x: 1, y: 0, z: 0)
  # let ftFromB = JoltFloat3(x: 0, y: 1, z: 0)
  # let ftFromC = joltVec3Normalize(1, 2, -1)
  # let ftFromD = joltVec3Normalize(-1, 0.5, 2)
  # let ftQAB = joltQuatFromTo(ftFromA.x, ftFromA.y, ftFromA.z, ftFromB.x, ftFromB.y, ftFromB.z)
  # let ftQCD = joltQuatFromTo(ftFromC.x, ftFromC.y, ftFromC.z, ftFromD.x, ftFromD.y, ftFromD.z)
  # lines.dumpQuat("from_x_to_y", ftQAB)
  # lines.dumpQuat("from_c_to_d", ftQCD)
  # lines.dumpVec3("verify_x_to_y", quatRotateVec3(ftQAB, ftFromA))
  # lines.dumpVec3("verify_c_to_d", quatRotateVec3(ftQCD, ftFromC))

  # lines.heading("quaternion inverse")
  # let axisQuatInv = joltQuatInverse(axisQuat.x, axisQuat.y, axisQuat.z, axisQuat.w)
  # lines.dumpQuat("from_axis_angle.inverse", axisQuatInv)
  # let verifyInv = quatMultiply(axisQuat, axisQuatInv)
  # lines.dumpQuat("verify_q_mul_qinv", verifyInv)

  # lines.heading("quaternion to axis-angle")
  # let aa1 = joltQuatGetAxisAngle(axisQuat.x, axisQuat.y, axisQuat.z, axisQuat.w)
  # let aa2 = joltQuatGetAxisAngle(quatXYZ.x, quatXYZ.y, quatXYZ.z, quatXYZ.w)
  # lines.dumpVec3("from_axis_angle.axis", JoltFloat3(x: aa1.x, y: aa1.y, z: aa1.z))
  # lines.dumpScalar("from_axis_angle.angle", aa1.w)
  # lines.dumpVec3("quat_xyz.axis", JoltFloat3(x: aa2.x, y: aa2.y, z: aa2.z))
  # lines.dumpScalar("quat_xyz.angle", aa2.w)

  # lines.heading("basis directions")
  # lines.appendLine("N/A")

  # lines.heading("element access [row,col]")
  # lines.appendLine("notes: [row,col] in math convention, element (i,j) = row i, col j")
  # lines.dumpScalar("transform[0,0]", transformM.get(0, 0))
  # lines.dumpScalar("transform[0,1]", transformM.get(0, 1))
  # lines.dumpScalar("transform[0,2]", transformM.get(0, 2))
  # lines.dumpScalar("transform[0,3]", transformM.get(0, 3))
  # lines.dumpScalar("transform[1,0]", transformM.get(1, 0))
  # lines.dumpScalar("transform[1,3]", transformM.get(1, 3))
  # lines.dumpScalar("transform[2,0]", transformM.get(2, 0))
  # lines.dumpScalar("transform[2,3]", transformM.get(2, 3))
  # lines.dumpScalar("transform[3,3]", transformM.get(3, 3))

  writeFile(OutputPath, lines.join("\n") & "\n")
  physics.destroy()
  echo "Wrote ", OutputPath

main()
