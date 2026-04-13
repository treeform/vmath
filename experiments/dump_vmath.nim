import
  std/[math, os, strutils],
  vmath

const
  OutputPath = parentDir(currentSourcePath()) / "dump_vmath.txt"

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
  lines.add(line)

proc dumpScalar(lines: var seq[string], label: string, value: float32) =
  lines.appendLine(label & ": " & fmt(value))

proc dumpVec3(lines: var seq[string], label: string, value: Vec3) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ">")

proc dumpVec4(lines: var seq[string], label: string, value: Vec4) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ", " & fmt(value.w) & ">")

proc dumpQuat(lines: var seq[string], label: string, value: Quat) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ", " & fmt(value.w) & ">")

proc dumpMat4(lines: var seq[string], label: string, value: Mat4) =
  lines.appendLine(label & ":")
  lines.appendLine("[")
  for row in 0 ..< 4:
    lines.appendLine(
      "  " &
      fmt(value[row, 0]) & " " &
      fmt(value[row, 1]) & " " &
      fmt(value[row, 2]) & " " &
      fmt(value[row, 3])
    )
  lines.appendLine("]")

proc heading(lines: var seq[string], title: string) =
  if lines.len > 0:
    lines.appendLine()
  lines.appendLine("== " & title & " ==")

proc rotationOnlyCopy(value: Mat4): Mat4 =
  result = value
  result[3, 0] = 0
  result[3, 1] = 0
  result[3, 2] = 0

proc main() =
  var lines: seq[string]

  let
    angleA = 37'f32.toRadians
    angleB = -23'f32.toRadians
    angleC = 71'f32.toRadians

    matA = mat4(
      1.0, 2.0, 3.0, 4.0,
      5.0, 6.0, 7.0, 8.0,
      9.0, 10.0, 11.0, 12.0,
      13.0, 14.0, 15.0, 16.0
    )
    matB = mat4(
      0.5, -1.0, 2.0, 0.25,
      1.5, 0.75, -0.5, 2.0,
      -3.0, 4.0, 1.25, -2.5,
      0.0, 1.0, -1.5, 3.0
    )
    vecA = vec3(1.25, -2.5, 3.75)
    vecB = vec4(1.25, -2.5, 3.75, 1.0)

    scaleM = scale(vec3(2.0, 3.0, 4.0))
    translateM = translate(vec3(10.0, 20.0, 30.0))
    rotateXM = rotateX(angleA)
    rotateYM = rotateY(angleB)
    rotateZM = rotateZ(angleC)
    pureRotationM = rotateZM * rotateYM * rotateXM
    axis = normalize(vec3(1.0, 2.0, -3.0))
    axisAngle = 48'f32.toRadians
    axisQuat = fromAxisAngle(axis, axisAngle)
    axisMat = axisQuat.mat4()
    transformM = translateM * rotateZM * rotateYM * rotateXM * scaleM

    quatX = quatRotateX(angleA)
    quatY = quatRotateY(angleB)
    quatZ = quatRotateZ(angleC)
    quatXY = quatMultiply(quatX, quatY)
    quatXYZ = quatMultiply(quatXY, quatZ)

    rotationOnlyM = rotationOnlyCopy(transformM)
    basisRight = vec3(1.0, 0.0, 0.0)
    basisUp = vec3(0.0, 1.0, 0.0)
    basisForward = mat4().forward()

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in raw in-memory order, four scalars per line")

  lines.heading("matrix constructors and composition")
  lines.dumpMat4("identity", mat4())
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
  lines.dumpMat4("lhs * rhs", matA * matB)
  lines.dumpMat4("rhs * lhs", matB * matA)

  lines.heading("matrix vector multiply")
  lines.dumpVec3("vec3_input", vecA)
  lines.dumpVec4("vec4_input", vecB)
  lines.dumpVec3("transform * vec3", transformM * vecA)
  lines.dumpVec4("transform * vec4", transformM * vecB)
  lines.dumpVec3("rotate_z * vec3", rotateZM * vecA)
  lines.dumpVec3("translate * vec3", translateM * vecA)

  lines.heading("quaternion constructors")
  lines.dumpQuat("quat_identity", quat())
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
  lines.dumpMat4("quat_xy.mat4", quatXY.mat4())
  lines.dumpMat4("quat_xyz.mat4", quatXYZ.mat4())

  lines.heading("quaternion vector rotate")
  lines.dumpVec3("input", vecA)
  lines.dumpVec3("quat_rotate(quat_x, input)", quatRotate(quatX, vecA))
  lines.dumpVec3("quat_rotate(quat_y, input)", quatRotate(quatY, vecA))
  lines.dumpVec3("quat_rotate(quat_z, input)", quatRotate(quatZ, vecA))
  lines.dumpVec3("quat_rotate(from_axis_angle, input)", quatRotate(axisQuat, vecA))
  lines.dumpVec3("quat_z * input", quatZ * vecA)

  lines.heading("matrix quaternion roundtrip")
  lines.dumpQuat("pure_rotation.quat", pureRotationM.quat())
  lines.dumpMat4("pure_rotation", pureRotationM)
  lines.dumpMat4("pure_rotation.quat.mat4", pureRotationM.quat().mat4())
  lines.appendLine("transform.rotation_only.note: skipped exact quaternion/matrix roundtrip comparison because scaled-matrix decomposition differs by library")
  lines.dumpMat4("transform.rotation_only", rotationOnlyM)
  lines.dumpQuat("axis_mat.quat", axisMat.quat())
  lines.dumpMat4("axis_mat.quat.mat4", axisMat.quat().mat4())

  lines.heading("basis directions")
  lines.dumpVec3("canonical_right", basisRight)
  lines.dumpVec3("canonical_up", basisUp)
  lines.dumpVec3("canonical_forward", basisForward)
  lines.dumpVec3("quat_z.right", quatZ * basisRight)
  lines.dumpVec3("quat_z.up", quatZ * basisUp)
  lines.dumpVec3("quat_z.forward", quatZ * basisForward)

  writeFile(OutputPath, lines.join("\n") & "\n")
  echo "Wrote ", OutputPath

main()
