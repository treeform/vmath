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
  let d = cast[array[16, float32]](value)
  lines.appendLine("[")
  lines.appendLine("  " & fmt(d[0]) & " " & fmt(d[4]) & " " & fmt(d[8]) & " " & fmt(d[12]) )
  lines.appendLine("  " & fmt(d[1]) & " " & fmt(d[5]) & " " & fmt(d[9]) & " " & fmt(d[13]) )
  lines.appendLine("  " & fmt(d[2]) & " " & fmt(d[6]) & " " & fmt(d[10]) & " " & fmt(d[14]) )
  lines.appendLine("  " & fmt(d[3]) & " " & fmt(d[7]) & " " & fmt(d[11]) & " " & fmt(d[15]) )
  lines.appendLine("]")

proc dumpMat4Default(lines: var seq[string], label: string, value: Mat4f) =
  lines.appendLine(label & ": " & $value)

proc heading(lines: var seq[string], title: string) =
  if lines.len > 0:
    lines.appendLine()
  lines.appendLine("== " & title & " ==")

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

    matA = cast[Mat4f]([
      1.0f, 2.0f, 3.0f, 4.0f,
      5.0f, 6.0f, 7.0f, 8.0f,
      9.0f, 10.0f, 11.0f, 12.0f,
      13.0f, 14.0f, 15.0f, 16.0f
    ])
    matB = cast[Mat4f]([
      -10.0f, -20.0f, -30.0f, -40.0f,
      50.0f, 60.0f, 70.0f, 80.0f,
      90.0f, 100.0f, 110.0f, 120.0f,
      130.0f, 140.0f, 150.0f, 160.0f
    ])
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

    hardAxis = normalize(vec3f(1.0, -2.0, 3.0))
    hardAngle = 170'f32 * PI.float32 / 180'f32
    hardQuat = quatf(hardAxis, hardAngle)
    hardMat = hardQuat.mat4()

    rotationOnlyM = rotationOnlyCopy(transformM)

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in common column-major order")

  lines.heading("matrix basics")
  lines.dumpMat4("identity", mat4f())
  lines.dumpMat4("matrix_a", matA)
  lines.dumpMat4("matrix_b", matB)

  lines.heading("matrix multiply")
  lines.dumpMat4("matrix_a * matrix_b", matA * matB)
  lines.dumpMat4("matrix_b * matrix_a", matB * matA)

  lines.heading("element access [row, col]")
  lines.dumpScalar("transform[0, 0]", matA[0, 0])
  lines.dumpScalar("transform[0, 1]", matA[0, 1])
  lines.dumpScalar("transform[0, 2]", matA[0, 2])
  lines.dumpScalar("transform[0, 3]", matA[0, 3])
  lines.dumpScalar("transform[1, 0]", matA[1, 0])
  lines.dumpScalar("transform[1, 1]", matA[1, 1])
  lines.dumpScalar("transform[1, 2]", matA[1, 2])
  lines.dumpScalar("transform[1, 3]", matA[1, 3])
  lines.dumpScalar("transform[2, 0]", matA[2, 0])
  lines.dumpScalar("transform[2, 1]", matA[2, 1])
  lines.dumpScalar("transform[2, 2]", matA[2, 2])
  lines.dumpScalar("transform[2, 3]", matA[2, 3])
  lines.dumpScalar("transform[3, 0]", matA[3, 0])
  lines.dumpScalar("transform[3, 1]", matA[3, 1])
  lines.dumpScalar("transform[3, 2]", matA[3, 2])
  lines.dumpScalar("transform[3, 3]", matA[3, 3])

  lines.heading("matrix constructors and composition")
  lines.dumpMat4("scale", scaleM)
  lines.dumpMat4("translate", translateM)
  lines.dumpMat4("rotate_x", rotateXM)
  lines.dumpMat4("rotate_y", rotateYM)
  lines.dumpMat4("rotate_z", rotateZM)
  lines.dumpMat4("pure_rotation = rotate_z * rotate_y * rotate_x", pureRotationM)
  lines.dumpMat4("transform = translate * rotate_z * rotate_y * rotate_x * scale", transformM)

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
  lines.dumpMat4("transform.rotation_only", rotationOnlyM)
  lines.dumpQuat("transform.rotation_only.quat", quat(rotationOnlyM))
  let axisMatQuat = quat(axisMat)
  lines.dumpQuat("axis_mat.quat", axisMatQuat)
  lines.dumpMat4("axis_mat.quat.mat4", axisMatQuat.mat4())
  lines.appendLine("hard_decomp.note: 170 degrees around (1,-2,3) normalized - w near zero")
  lines.dumpQuat("hard_decomp.quat_original", hardQuat)
  lines.dumpQuat("hard_decomp.quat_from_mat", quat(hardMat))
  lines.dumpMat4("hard_decomp.mat4", hardMat)
  lines.dumpMat4("hard_decomp.quat_from_mat.mat4", quat(hardMat).mat4())

  lines.heading("lookAt matrix")
  lines.appendLine("notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)")
  lines.dumpMat4("lookAt", lookAtRH(vec3f(5, 5, 5), vec3f(0, 0, 0), vec3f(0, 1, 0)))

  lines.heading("euler angle decomposition")
  lines.appendLine("notes: euler angles as vec3(pitch/x, yaw/y, roll/z) in radians")
  let pureRotAngles = eulerAngles(quat(pureRotationM))
  let axisAngles = eulerAngles(axisQuat)
  lines.dumpVec3("pure_rotation.quat.euler", pureRotAngles)
  lines.dumpVec3("from_axis_angle.euler", axisAngles)

  lines.heading("matrix inverse")
  lines.dumpMat4("transform.inverse", inverse(transformM))
  lines.dumpMat4("pure_rotation.inverse", inverse(pureRotationM))

  lines.heading("cross product")
  lines.appendLine("notes: cross(a, b) where a and b are vec3")
  let crossA = vec3f(1, 0, 0)
  let crossB = vec3f(0, 1, 0)
  let crossC = normalize(vec3f(1, 2, 3))
  let crossD = normalize(vec3f(-1, 0.5, 2))
  lines.dumpVec3("cross(x_axis, y_axis)", cross(crossA, crossB))
  lines.dumpVec3("cross(y_axis, x_axis)", cross(crossB, crossA))
  lines.dumpVec3("cross(c, d)", cross(crossC, crossD))

  lines.heading("slerp")
  lines.appendLine("notes: slerp(a, b, t) between quat_x and quat_z")
  lines.dumpQuat("slerp(quat_x, quat_z, 0.25)", slerp(quatX, quatZ, 0.25'f32))
  lines.dumpQuat("slerp(quat_x, quat_z, 0.5)", slerp(quatX, quatZ, 0.5'f32))
  lines.dumpQuat("slerp(quat_x, quat_z, 0.75)", slerp(quatX, quatZ, 0.75'f32))

  lines.heading("fromTwoVectors")
  lines.appendLine("notes: quaternion that rotates vector a to vector b")
  proc fromTwoVectors(a, b: Vec3f): Quatf =
    let d = dot(a, b)
    let c = cross(a, b)
    let w = sqrt(dot(a, a) * dot(b, b)) + d
    result = quatf(c.x, c.y, c.z, w)
    result = normalize(result)
  let fromA = vec3f(1, 0, 0)
  let fromB = vec3f(0, 1, 0)
  let fromC = normalize(vec3f(1, 2, -1))
  let fromD = normalize(vec3f(-1, 0.5, 2))
  lines.dumpQuat("from_x_to_y", fromTwoVectors(fromA, fromB))
  lines.dumpQuat("from_c_to_d", fromTwoVectors(fromC, fromD))
  lines.dumpVec3("verify_x_to_y", fromTwoVectors(fromA, fromB) * fromA)
  lines.dumpVec3("verify_c_to_d", fromTwoVectors(fromC, fromD) * fromC)

  lines.heading("quaternion inverse")
  lines.dumpQuat("from_axis_angle.inverse", inverse(axisQuat))
  lines.dumpQuat("verify_q_mul_qinv", axisQuat * inverse(axisQuat))

  lines.heading("quaternion to axis-angle")
  lines.dumpVec3("from_axis_angle.axis", axis(axisQuat))
  lines.dumpScalar("from_axis_angle.angle", angle(axisQuat))
  lines.dumpVec3("quat_xyz.axis", axis(quatXYZ))
  lines.dumpScalar("quat_xyz.angle", angle(quatXYZ))

  lines.heading("perspective matrix")
  lines.appendLine("notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0")
  let fovyRad = 60'f32 * PI.float32 / 180'f32
  lines.dumpMat4("perspective", perspectiveRH(fovyRad, 1.5'f32, 0.1'f32, 100'f32))

  lines.heading("ortho matrix")
  lines.appendLine("notes: left=-10, right=10, bottom=-7.5, top=7.5, near=0.1, far=100.0")
  lines.dumpMat4("ortho", ortho(-10'f32, 10'f32, -7.5'f32, 7.5'f32, 0.1'f32, 100'f32))

  lines.heading("basis directions")
  lines.appendLine("N/A")

  lines.heading("default matrix printer")
  lines.dumpMat4Default("matrix_a.default", matA)
  lines.dumpMat4Default("transform.default", transformM)

  writeFile(OutputPath, lines.join("\n") & "\n")
  echo "Wrote ", OutputPath

main()
