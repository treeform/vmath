import
  std/[math, os, strutils],
  vmath {.all.}

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
  let d = GMat4[float32](value)
  lines.appendLine("[")
  lines.appendLine("  " & fmt(d.arr[0]) & " " & fmt(d.arr[4]) & " " & fmt(d.arr[8]) & " " & fmt(d.arr[12]) )
  lines.appendLine("  " & fmt(d.arr[1]) & " " & fmt(d.arr[5]) & " " & fmt(d.arr[9]) & " " & fmt(d.arr[13]) )
  lines.appendLine("  " & fmt(d.arr[2]) & " " & fmt(d.arr[6]) & " " & fmt(d.arr[10]) & " " & fmt(d.arr[14]) )
  lines.appendLine("  " & fmt(d.arr[3]) & " " & fmt(d.arr[7]) & " " & fmt(d.arr[11]) & " " & fmt(d.arr[15]) )
  lines.appendLine("]")

  # lines.appendLine("direct " & $value)
  # lines.appendLine("array " & $value.arr)

proc heading(lines: var seq[string], title: string) =
  if lines.len > 0:
    lines.appendLine()
  lines.appendLine("== " & title & " ==")

proc mat4FromRows(
  m00, m01, m02, m03,
  m10, m11, m12, m13,
  m20, m21, m22, m23,
  m30, m31, m32, m33: float32
): Mat4 =
  ## Create a mat4 from row-major input (matching math notation).
  mat4(
    m00, m10, m20, m30,
    m01, m11, m21, m31,
    m02, m12, m22, m32,
    m03, m13, m23, m33
  )

proc rotationOnlyCopy(value: Mat4): Mat4 =
  result = value
  result[0, 3] = 0
  result[1, 3] = 0
  result[2, 3] = 0

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

  #   matA = mat4FromRows(
  #     1.0, 2.0, 3.0, 4.0,
  #     5.0, 6.0, 7.0, 8.0,
  #     9.0, 10.0, 11.0, 12.0,
  #     13.0, 14.0, 15.0, 16.0
  #   )
    matB = mat4(
      -10, -20, -30, -40,
      50, 60, 70, 80,
      90, 100, 110, 120,
      130, 140, 150, 160
    )
  #   vecA = vec3(1.25, -2.5, 3.75)
  #   vecB = vec4(1.25, -2.5, 3.75, 1.0)

  #   scaleM = scale(vec3(2.0, 3.0, 4.0))
  #   translateM = translate(vec3(10.0, 20.0, 30.0))
  #   rotateXM = rotateX(angleA)
  #   rotateYM = rotateY(angleB)
  #   rotateZM = rotateZ(angleC)
  #   pureRotationM = rotateZM * rotateYM * rotateXM
  #   axis = normalize(vec3(1.0, 2.0, -3.0))
  #   axisAngle = 48'f32.toRadians
  #   axisQuat = fromAxisAngle(axis, axisAngle)
  #   axisMat = axisQuat.mat4()
  #   transformM = translateM * rotateZM * rotateYM * rotateXM * scaleM

  #   quatX = quatRotateX(angleA)
  #   quatY = quatRotateY(angleB)
  #   quatZ = quatRotateZ(angleC)
  #   quatXY = quatMultiply(quatX, quatY)
  #   quatXYZ = quatMultiply(quatXY, quatZ)

  #   # Hard quat decomposition case: 170° around arbitrary axis (w near zero)
  #   hardAxis = normalize(vec3(1.0, -2.0, 3.0))
  #   hardAngle = 170'f32.toRadians
  #   hardQuat = fromAxisAngle(hardAxis, hardAngle)
  #   hardMat = hardQuat.mat4()

  #   rotationOnlyM = rotationOnlyCopy(transformM)
  #   basisRight = vec3(1.0, 0.0, 0.0)
  #   basisUp = vec3(0.0, 1.0, 0.0)
  #   basisForward = vec3(0.0, 0.0, 1.0)

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in raw in-memory order, four scalars per line")

  lines.heading("matrix constructors and composition")
  #lines.dumpMat4("identity", mat4())
  lines.dumpMat4("matrix_a", matA)
  lines.dumpMat4("matrix_b", matB)

  lines.dumpMat4("matrix_a * matrix_b", matA * matB)
  lines.dumpMat4("matrix_b * matrix_a", matB * matA)
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
  # lines.dumpMat4("lhs * rhs", matA * matB)
  # lines.dumpMat4("rhs * lhs", matB * matA)

  # lines.heading("matrix vector multiply")
  # lines.dumpVec3("vec3_input", vecA)
  # lines.dumpVec4("vec4_input", vecB)
  # lines.dumpVec3("transform * vec3", transformM * vecA)
  # lines.dumpVec4("transform * vec4", transformM * vecB)
  # lines.dumpVec3("rotate_z * vec3", rotateZM * vecA)
  # lines.dumpVec3("translate * vec3", translateM * vecA)

  # lines.heading("quaternion constructors")
  # lines.dumpQuat("quat_identity", quat())
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
  # lines.dumpMat4("quat_xy.mat4", quatXY.mat4())
  # lines.dumpMat4("quat_xyz.mat4", quatXYZ.mat4())

  # lines.heading("quaternion vector rotate")
  # lines.dumpVec3("input", vecA)
  # lines.dumpVec3("quat_rotate(quat_x, input)", quatRotate(quatX, vecA))
  # lines.dumpVec3("quat_rotate(quat_y, input)", quatRotate(quatY, vecA))
  # lines.dumpVec3("quat_rotate(quat_z, input)", quatRotate(quatZ, vecA))
  # lines.dumpVec3("quat_rotate(from_axis_angle, input)", quatRotate(axisQuat, vecA))
  # lines.dumpVec3("quat_z * input", quatZ * vecA)

  # lines.heading("matrix quaternion roundtrip")
  # lines.dumpQuat("pure_rotation.quat", pureRotationM.quat())
  # lines.dumpMat4("pure_rotation", pureRotationM)
  # lines.dumpMat4("pure_rotation.quat.mat4", pureRotationM.quat().mat4())
  # lines.dumpMat4("transform.rotation_only", rotationOnlyM)
  # lines.dumpQuat("transform.rotation_only.quat", rotationOnlyM.quat())
  # lines.dumpQuat("axis_mat.quat", axisMat.quat())
  # lines.dumpMat4("axis_mat.quat.mat4", axisMat.quat().mat4())
  # lines.appendLine("hard_decomp.note: 170 degrees around (1,-2,3) normalized - w near zero")
  # lines.dumpQuat("hard_decomp.quat_original", hardQuat)
  # lines.dumpQuat("hard_decomp.quat_from_mat", hardMat.quat())
  # lines.dumpMat4("hard_decomp.mat4", hardMat)
  # lines.dumpMat4("hard_decomp.quat_from_mat.mat4", hardMat.quat().mat4())

  # lines.heading("perspective matrix")
  # lines.appendLine("notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0")
  # lines.dumpMat4("perspective", perspective(60'f32, 1.5'f32, 0.1'f32, 100'f32))

  # lines.heading("ortho matrix")
  # lines.appendLine("notes: left=-10, right=10, bottom=-7.5, top=7.5, near=0.1, far=100.0")
  # lines.dumpMat4("ortho", ortho(-10'f32, 10'f32, -7.5'f32, 7.5'f32, 0.1'f32, 100'f32))

  # lines.heading("lookAt matrix")
  # lines.appendLine("notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)")
  # lines.dumpMat4("lookAt", lookAt(vec3(5'f32, 5'f32, 5'f32), vec3(0'f32, 0'f32, 0'f32), vec3(0'f32, 1'f32, 0'f32)))

  # lines.heading("euler angle decomposition")
  # lines.appendLine("notes: euler angles as vec3(pitch/x, yaw/y, roll/z) in radians")
  # let pureRotAngles = pureRotationM.quat().toAngles()
  # let axisAngles = axisQuat.toAngles()
  # lines.dumpVec3("pure_rotation.quat.euler", pureRotAngles)
  # lines.dumpVec3("from_axis_angle.euler", axisAngles)

  # lines.heading("basis directions")
  # lines.appendLine("notes: library-specific, N/A for libraries without canonical basis helpers")
  # lines.dumpVec3("canonical_right", basisRight)
  # lines.dumpVec3("canonical_up", basisUp)
  # lines.dumpVec3("canonical_forward", basisForward)
  # lines.dumpVec3("quat_z.right", quatRotate(quatZ, basisRight))
  # lines.dumpVec3("quat_z.up", quatRotate(quatZ, basisUp))
  # lines.dumpVec3("quat_z.forward", quatRotate(quatZ, basisForward))

  # lines.heading("matrix inverse")
  # lines.dumpMat4("transform.inverse", transformM.inverse())
  # lines.dumpMat4("pure_rotation.inverse", pureRotationM.inverse())

  # lines.heading("cross product")
  # lines.appendLine("notes: cross(a, b) where a and b are vec3")
  # let crossA = vec3(1'f32, 0'f32, 0'f32)
  # let crossB = vec3(0'f32, 1'f32, 0'f32)
  # let crossC = normalize(vec3(1'f32, 2'f32, 3'f32))
  # let crossD = normalize(vec3(-1'f32, 0.5'f32, 2'f32))
  # lines.dumpVec3("cross(x_axis, y_axis)", cross(crossA, crossB))
  # lines.dumpVec3("cross(y_axis, x_axis)", cross(crossB, crossA))
  # lines.dumpVec3("cross(c, d)", cross(crossC, crossD))

  # lines.heading("slerp")
  # lines.appendLine("notes: slerp(a, b, t) between quat_x and quat_z")
  # lines.dumpQuat("slerp(quat_x, quat_z, 0.25)", slerp(quatX, quatZ, 0.25'f32))
  # lines.dumpQuat("slerp(quat_x, quat_z, 0.5)", slerp(quatX, quatZ, 0.5'f32))
  # lines.dumpQuat("slerp(quat_x, quat_z, 0.75)", slerp(quatX, quatZ, 0.75'f32))

  # lines.heading("fromTwoVectors")
  # lines.appendLine("notes: quaternion that rotates vector a to vector b")
  # let fromA = normalize(vec3(1'f32, 0'f32, 0'f32))
  # let fromB = normalize(vec3(0'f32, 1'f32, 0'f32))
  # let fromC = normalize(vec3(1'f32, 2'f32, -1'f32))
  # let fromD = normalize(vec3(-1'f32, 0.5'f32, 2'f32))
  # lines.dumpQuat("from_x_to_y", fromTwoVectors(fromA, fromB))
  # lines.dumpQuat("from_c_to_d", fromTwoVectors(fromC, fromD))
  # lines.dumpVec3("verify_x_to_y", fromTwoVectors(fromA, fromB) * fromA)
  # lines.dumpVec3("verify_c_to_d", fromTwoVectors(fromC, fromD) * fromC)

  # lines.heading("quaternion inverse")
  # lines.dumpQuat("from_axis_angle.inverse", quatInverse(axisQuat))
  # lines.dumpQuat("verify_q_mul_qinv", quatMultiply(axisQuat, quatInverse(axisQuat)))

  # lines.heading("quaternion to axis-angle")
  # let (aaAxis1, aaAngle1) = toAxisAngle(axisQuat)
  # let (aaAxis2, aaAngle2) = toAxisAngle(quatXYZ)
  # lines.dumpVec3("from_axis_angle.axis", aaAxis1)
  # lines.dumpScalar("from_axis_angle.angle", aaAngle1)
  # lines.dumpVec3("quat_xyz.axis", aaAxis2)
  # lines.dumpScalar("quat_xyz.angle", aaAngle2)

  # lines.heading("element access [row,col]")
  # lines.appendLine("notes: [row,col] in math convention, element (i,j) = row i, col j")
  # lines.dumpScalar("transform[0,0]", transformM[0, 0])
  # lines.dumpScalar("transform[0,1]", transformM[0, 1])
  # lines.dumpScalar("transform[0,2]", transformM[0, 2])
  # lines.dumpScalar("transform[0,3]", transformM[0, 3])
  # lines.dumpScalar("transform[1,0]", transformM[1, 0])
  # lines.dumpScalar("transform[1,3]", transformM[1, 3])
  # lines.dumpScalar("transform[2,0]", transformM[2, 0])
  # lines.dumpScalar("transform[2,3]", transformM[2, 3])
  # lines.dumpScalar("transform[3,3]", transformM[3, 3])

  writeFile(OutputPath, lines.join("\n") & "\n")
  echo "Wrote ", OutputPath

main()
