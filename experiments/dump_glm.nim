import
  std/[math, os, strutils],
  glm

const
  OutputPath = parentDir(currentSourcePath()) / "dump_glm.txt"

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

proc dumpVec3(lines: var seq[string], label: string, value: Vec3f) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ">")

proc dumpVec4(lines: var seq[string], label: string, value: Vec4f) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ", " & fmt(value.w) & ">")

proc dumpQuat(lines: var seq[string], label: string, value: Quatf) =
  lines.appendLine(label & ": <" & fmt(value.x) & ", " & fmt(value.y) & ", " & fmt(value.z) & ", " & fmt(value.w) & ">")

proc dumpMat4(lines: var seq[string], label: string, value: Mat4f) =
  lines.appendLine(label & ":")
  lines.appendLine("[")
  for col in 0 ..< 4:
    lines.appendLine(
      "  " &
      fmt(value[col, 0]) & " " &
      fmt(value[col, 1]) & " " &
      fmt(value[col, 2]) & " " &
      fmt(value[col, 3])
    )
  lines.appendLine("]")

proc heading(lines: var seq[string], title: string) =
  if lines.len > 0:
    lines.appendLine()
  lines.appendLine("== " & title & " ==")

proc mat4FromRows(
  m00, m01, m02, m03: float32,
  m10, m11, m12, m13: float32,
  m20, m21, m22, m23: float32,
  m30, m31, m32, m33: float32
): Mat4f =
  result[0] = vec4f(m00, m10, m20, m30)
  result[1] = vec4f(m01, m11, m21, m31)
  result[2] = vec4f(m02, m12, m22, m32)
  result[3] = vec4f(m03, m13, m23, m33)

proc transformVec3ByMat4(matrix: Mat4f, value: Vec3f): Vec3f =
  (matrix * vec4f(value, 1'f32)).xyz

proc transformVec4ByMat4(matrix: Mat4f, value: Vec4f): Vec4f =
  matrix * value

proc rotationOnlyCopy(value: Mat4f): Mat4f =
  result = value
  result[3] = vec4f(0'f32, 0'f32, 0'f32, 1'f32)

proc main() =
  var lines: seq[string]

  let
    angleA = 37'f32 * PI.float32 / 180'f32
    angleB = -23'f32 * PI.float32 / 180'f32
    angleC = 71'f32 * PI.float32 / 180'f32

    matA = mat4FromRows(
      1.0, 2.0, 3.0, 4.0,
      5.0, 6.0, 7.0, 8.0,
      9.0, 10.0, 11.0, 12.0,
      13.0, 14.0, 15.0, 16.0
    )
    matB = mat4FromRows(
      0.5, -1.0, 2.0, 0.25,
      1.5, 0.75, -0.5, 2.0,
      -3.0, 4.0, 1.25, -2.5,
      0.0, 1.0, -1.5, 3.0
    )
    vecA = vec3f(1.25, -2.5, 3.75)
    vecB = vec4f(1.25, -2.5, 3.75, 1.0)

    scaleM = mat4f(1).scale(2'f32, 3'f32, 4'f32)
    translateM = mat4f(1).translate(10'f32, 20'f32, 30'f32)
    rotateXM = mat4f(1).rotateX(angleA)
    rotateYM = mat4f(1).rotateY(angleB)
    rotateZM = mat4f(1).rotateZ(angleC)
    pureRotationM = rotateZM * rotateYM * rotateXM

    axis = normalize(vec3f(1.0, 2.0, -3.0))
    axisAngle = 48'f32 * PI.float32 / 180'f32
    axisQuat = quatf(axis, axisAngle)
    axisMat = axisQuat.mat4()
    transformM = translateM * rotateZM * rotateYM * rotateXM * scaleM

    quatX = quatf(vec3f(1'f32, 0'f32, 0'f32), angleA)
    quatY = quatf(vec3f(0'f32, 1'f32, 0'f32), angleB)
    quatZ = quatf(vec3f(0'f32, 0'f32, 1'f32), angleC)
    quatXY = quatX * quatY
    quatXYZ = quatXY * quatZ

    rotationOnlyM = rotationOnlyCopy(transformM)
    basisRight = vec3f(1'f32, 0'f32, 0'f32)
    basisUp = vec3f(0'f32, 1'f32, 0'f32)
    basisForward = vec3f(0'f32, 0'f32, 1'f32)

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in raw in-memory order, four scalars per line")

  lines.heading("matrix constructors and composition")
  lines.dumpMat4("identity", mat4f())
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
  lines.dumpVec3("transform * vec3", transformVec3ByMat4(transformM, vecA))
  lines.dumpVec4("transform * vec4", transformVec4ByMat4(transformM, vecB))
  lines.dumpVec3("rotate_z * vec3", transformVec3ByMat4(rotateZM, vecA))
  lines.dumpVec3("translate * vec3", transformVec3ByMat4(translateM, vecA))

  lines.heading("quaternion constructors")
  lines.dumpQuat("quat_identity", quatf())
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
  lines.dumpVec3("quat_rotate(quat_x, input)", quatX * vecA)
  lines.dumpVec3("quat_rotate(quat_y, input)", quatY * vecA)
  lines.dumpVec3("quat_rotate(quat_z, input)", quatZ * vecA)
  lines.dumpVec3("quat_rotate(from_axis_angle, input)", axisQuat * vecA)
  lines.dumpVec3("quat_z * input", quatZ * vecA)

  lines.heading("matrix quaternion roundtrip")
  let pureRotationQuat = quat(pureRotationM)
  lines.dumpQuat("pure_rotation.quat", pureRotationQuat)
  lines.dumpMat4("pure_rotation", pureRotationM)
  lines.dumpMat4("pure_rotation.quat.mat4", pureRotationQuat.mat4())
  lines.appendLine("transform.rotation_only.note: skipped exact quaternion/matrix roundtrip comparison because scaled-matrix decomposition differs by library")
  lines.dumpMat4("transform.rotation_only", rotationOnlyM)
  let axisMatQuat = quat(axisMat)
  lines.dumpQuat("axis_mat.quat", axisMatQuat)
  lines.dumpMat4("axis_mat.quat.mat4", axisMatQuat.mat4())

  lines.heading("basis directions")
  lines.dumpVec3("canonical_right", basisRight)
  lines.dumpVec3("canonical_up", basisUp)
  lines.dumpVec3("canonical_forward", basisForward)
  lines.dumpVec3("quat_z.right", quatZ * basisRight)
  lines.dumpVec3("quat_z.up", quatZ * basisUp)
  lines.dumpVec3("quat_z.forward", quatZ * basisForward)

  lines.heading("element access [row,col]")
  lines.appendLine("notes: [row,col] in math convention, element (i,j) = row i, col j")
  lines.appendLine("notes: GLM uses [col,row], so element (r,c) = value[c,r]")
  lines.dumpScalar("transform[0,0]", transformM[0, 0])
  lines.dumpScalar("transform[0,1]", transformM[1, 0])
  lines.dumpScalar("transform[0,2]", transformM[2, 0])
  lines.dumpScalar("transform[0,3]", transformM[3, 0])
  lines.dumpScalar("transform[1,0]", transformM[0, 1])
  lines.dumpScalar("transform[1,3]", transformM[3, 1])
  lines.dumpScalar("transform[2,0]", transformM[0, 2])
  lines.dumpScalar("transform[2,3]", transformM[3, 2])
  lines.dumpScalar("transform[3,3]", transformM[3, 3])

  writeFile(OutputPath, lines.join("\n") & "\n")
  echo "Wrote ", OutputPath

main()
