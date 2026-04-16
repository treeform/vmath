import
  std/[math, os, strformat, strutils],
  opengl,
  windy,
  vmath

const
  OutputPath = parentDir(currentSourcePath()) / "dump_glsl.txt"
  ShaderPath = parentDir(currentSourcePath()) / "dump_glsl.comp"

  VertexShaderSrc = """
#version 410
void main() {
  float x = (gl_VertexID == 1) ? 3.0 : -1.0;
  float y = (gl_VertexID == 2) ? 3.0 : -1.0;
  gl_Position = vec4(x, y, 0.0, 1.0);
}
"""

var
  contextInitialized = false
  window: Window
  vao: GLuint

proc ensureContext() =
  if contextInitialized:
    return
  window = newWindow(
    title = "GLSL dump",
    size = ivec2(100, 100),
    visible = false,
    openglVersion = OpenGL4Dot1
  )
  window.makeContextCurrent()
  loadExtensions()
  glGenVertexArrays(1, vao.addr)
  glBindVertexArray(vao)
  glDisable(GL_DEPTH_TEST)
  glDisable(GL_BLEND)
  contextInitialized = true

proc compileShader(shaderType: GLenum, source: string): GLuint =
  result = glCreateShader(shaderType)
  var srcArray = allocCStringArray([source])
  glShaderSource(result, 1, srcArray, nil)
  deallocCStringArray(srcArray)
  glCompileShader(result)
  var status: GLint
  glGetShaderiv(result, GL_COMPILE_STATUS, status.addr)
  if status == 0:
    var logLen: GLint
    glGetShaderiv(result, GL_INFO_LOG_LENGTH, logLen.addr)
    var log = newString(logLen)
    glGetShaderInfoLog(result, logLen, nil, log.cstring)
    echo "Shader compile error:"
    echo log
    echo "Source:"
    echo source
    quit(1)

proc compileProgram(vertSrc, fragSrc: string): GLuint =
  let vertShader = compileShader(GL_VERTEX_SHADER, vertSrc)
  let fragShader = compileShader(GL_FRAGMENT_SHADER, fragSrc)
  result = glCreateProgram()
  glAttachShader(result, vertShader)
  glAttachShader(result, fragShader)
  glLinkProgram(result)
  var status: GLint
  glGetProgramiv(result, GL_LINK_STATUS, status.addr)
  if status == 0:
    var logLen: GLint
    glGetProgramiv(result, GL_INFO_LOG_LENGTH, logLen.addr)
    var log = newString(logLen)
    glGetProgramInfoLog(result, logLen, nil, log.cstring)
    echo "Program link error:"
    echo log
    quit(1)
  glDeleteShader(vertShader)
  glDeleteShader(fragShader)

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

proc dumpVec2(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ": <" & fmt(value[0]) & ", " & fmt(value[1]) & ">")

proc dumpVec3(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ": <" & fmt(value[0]) & ", " & fmt(value[1]) & ", " & fmt(value[2]) & ">")

proc dumpVec4(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ": <" & fmt(value[0]) & ", " & fmt(value[1]) & ", " & fmt(value[2]) & ", " & fmt(value[3]) & ">")

proc dumpQuat(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ": <" & fmt(value[0]) & ", " & fmt(value[1]) & ", " & fmt(value[2]) & ", " & fmt(value[3]) & ">")

proc dumpMat2(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ":")
  lines.appendLine("[")
  lines.appendLine("  " & fmt(value[0]) & " " & fmt(value[2]))
  lines.appendLine("  " & fmt(value[1]) & " " & fmt(value[3]))
  lines.appendLine("]")

proc dumpMat3(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ":")
  lines.appendLine("[")
  lines.appendLine("  " & fmt(value[0]) & " " & fmt(value[3]) & " " & fmt(value[6]))
  lines.appendLine("  " & fmt(value[1]) & " " & fmt(value[4]) & " " & fmt(value[7]))
  lines.appendLine("  " & fmt(value[2]) & " " & fmt(value[5]) & " " & fmt(value[8]))
  lines.appendLine("]")

proc dumpMat4(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ":")
  lines.appendLine("[")
  lines.appendLine("  " & fmt(value[0]) & " " & fmt(value[4]) & " " & fmt(value[8]) & " " & fmt(value[12]))
  lines.appendLine("  " & fmt(value[1]) & " " & fmt(value[5]) & " " & fmt(value[9]) & " " & fmt(value[13]))
  lines.appendLine("  " & fmt(value[2]) & " " & fmt(value[6]) & " " & fmt(value[10]) & " " & fmt(value[14]))
  lines.appendLine("  " & fmt(value[3]) & " " & fmt(value[7]) & " " & fmt(value[11]) & " " & fmt(value[15]))
  lines.appendLine("]")

proc heading(lines: var seq[string], title: string) =
  if lines.len > 0:
    lines.appendLine()
  lines.appendLine("== " & title & " ==")

proc shaderTemplate(mainBody: string): string =
  readFile(ShaderPath).replace("__MAIN_BODY__", mainBody)

proc setUniformMat4(program: GLuint, name: string, value: openArray[float32]) =
  let location = glGetUniformLocation(program, name)
  if location < 0:
    return
  doAssert value.len == 16
  glUniformMatrix4fv(location, 1, GLboolean(GL_FALSE), cast[ptr GLfloat](unsafeAddr value[0]))

proc setUniformMat3(program: GLuint, name: string, value: openArray[float32]) =
  let location = glGetUniformLocation(program, name)
  if location < 0:
    return
  doAssert value.len == 9
  glUniformMatrix3fv(location, 1, GLboolean(GL_FALSE), cast[ptr GLfloat](unsafeAddr value[0]))

proc setUniformMat2(program: GLuint, name: string, value: openArray[float32]) =
  let location = glGetUniformLocation(program, name)
  if location < 0:
    return
  doAssert value.len == 4
  glUniformMatrix2fv(location, 1, GLboolean(GL_FALSE), cast[ptr GLfloat](unsafeAddr value[0]))

proc setUniformVec2(program: GLuint, name: string, value: openArray[float32]) =
  let location = glGetUniformLocation(program, name)
  if location < 0:
    return
  doAssert value.len == 2
  glUniform2f(location, value[0], value[1])

proc setUniformVec3(program: GLuint, name: string, value: openArray[float32]) =
  let location = glGetUniformLocation(program, name)
  if location < 0:
    return
  doAssert value.len == 3
  glUniform3f(location, value[0], value[1], value[2])

proc setUniformVec4(program: GLuint, name: string, value: openArray[float32]) =
  let location = glGetUniformLocation(program, name)
  if location < 0:
    return
  doAssert value.len == 4
  glUniform4f(location, value[0], value[1], value[2], value[3])

proc uploadDumpUniforms(program: GLuint) =
  let
    angleA = degToRad(37.0f)
    angleB = degToRad(-23.0f)
    angleC = degToRad(71.0f)
    axisAngle = degToRad(48.0f)
    hardAngle = degToRad(170.0f)
    rotateXSin = sin(angleA)
    rotateXCos = cos(angleA)
    rotateYSin = sin(angleB)
    rotateYCos = cos(angleB)
    rotateZSin = sin(angleC)
    rotateZCos = cos(angleC)
    axisLenInv = 1.0f / sqrt(1.0f * 1.0f + 2.0f * 2.0f + (-3.0f) * (-3.0f))
    axisX = 1.0f * axisLenInv
    axisY = 2.0f * axisLenInv
    axisZ = -3.0f * axisLenInv
    axisQuatSin = sin(axisAngle * 0.5f)
    axisQuatCos = cos(axisAngle * 0.5f)
    axisQuat = [
      axisX * axisQuatSin,
      axisY * axisQuatSin,
      axisZ * axisQuatSin,
      axisQuatCos
    ]
    hardAxisLenInv = 1.0f / sqrt(1.0f * 1.0f + (-2.0f) * (-2.0f) + 3.0f * 3.0f)
    hardAxisX = 1.0f * hardAxisLenInv
    hardAxisY = -2.0f * hardAxisLenInv
    hardAxisZ = 3.0f * hardAxisLenInv
    hardQuatSin = sin(hardAngle * 0.5f)
    hardQuatCos = cos(hardAngle * 0.5f)
    hardQuat = [
      hardAxisX * hardQuatSin,
      hardAxisY * hardQuatSin,
      hardAxisZ * hardQuatSin,
      hardQuatCos
    ]
    axisQuatXX = axisQuat[0] * axisQuat[0]
    axisQuatXY = axisQuat[0] * axisQuat[1]
    axisQuatXZ = axisQuat[0] * axisQuat[2]
    axisQuatXW = axisQuat[0] * axisQuat[3]
    axisQuatYY = axisQuat[1] * axisQuat[1]
    axisQuatYZ = axisQuat[1] * axisQuat[2]
    axisQuatYW = axisQuat[1] * axisQuat[3]
    axisQuatZZ = axisQuat[2] * axisQuat[2]
    axisQuatZW = axisQuat[2] * axisQuat[3]
    hardQuatXX = hardQuat[0] * hardQuat[0]
    hardQuatXY = hardQuat[0] * hardQuat[1]
    hardQuatXZ = hardQuat[0] * hardQuat[2]
    hardQuatXW = hardQuat[0] * hardQuat[3]
    hardQuatYY = hardQuat[1] * hardQuat[1]
    hardQuatYZ = hardQuat[1] * hardQuat[2]
    hardQuatYW = hardQuat[1] * hardQuat[3]
    hardQuatZZ = hardQuat[2] * hardQuat[2]
    hardQuatZW = hardQuat[2] * hardQuat[3]
    uIdentityM = [
      1.0f, 0.0f, 0.0f, 0.0f,
      0.0f, 1.0f, 0.0f, 0.0f,
      0.0f, 0.0f, 1.0f, 0.0f,
      0.0f, 0.0f, 0.0f, 1.0f
    ]
    uMatA = [
      1.0f, 2.0f, 3.0f, 4.0f,
      5.0f, 6.0f, 7.0f, 8.0f,
      9.0f, 10.0f, 11.0f, 12.0f,
      13.0f, 14.0f, 15.0f, 16.0f
    ]
    uMatB = [
      -10.0f, -20.0f, -30.0f, -40.0f,
      50.0f, 60.0f, 70.0f, 80.0f,
      90.0f, 100.0f, 110.0f, 120.0f,
      130.0f, 140.0f, 150.0f, 160.0f
    ]
    uScaleM = [
      2.0f, 0.0f, 0.0f, 0.0f,
      0.0f, 3.0f, 0.0f, 0.0f,
      0.0f, 0.0f, 4.0f, 0.0f,
      0.0f, 0.0f, 0.0f, 1.0f
    ]
    uTranslateM = [
      1.0f, 0.0f, 0.0f, 0.0f,
      0.0f, 1.0f, 0.0f, 0.0f,
      0.0f, 0.0f, 1.0f, 0.0f,
      10.0f, 20.0f, 30.0f, 1.0f
    ]
    uRotateXM = [
      1.0f, 0.0f, 0.0f, 0.0f,
      0.0f, rotateXCos, rotateXSin, 0.0f,
      0.0f, -rotateXSin, rotateXCos, 0.0f,
      0.0f, 0.0f, 0.0f, 1.0f
    ]
    uRotateYM = [
      rotateYCos, 0.0f, -rotateYSin, 0.0f,
      0.0f, 1.0f, 0.0f, 0.0f,
      rotateYSin, 0.0f, rotateYCos, 0.0f,
      0.0f, 0.0f, 0.0f, 1.0f
    ]
    uRotateZM = [
      rotateZCos, rotateZSin, 0.0f, 0.0f,
      -rotateZSin, rotateZCos, 0.0f, 0.0f,
      0.0f, 0.0f, 1.0f, 0.0f,
      0.0f, 0.0f, 0.0f, 1.0f
    ]
    uAxisMat = [
      1.0f - 2.0f * (axisQuatYY + axisQuatZZ), 2.0f * (axisQuatXY + axisQuatZW), 2.0f * (axisQuatXZ - axisQuatYW), 0.0f,
      2.0f * (axisQuatXY - axisQuatZW), 1.0f - 2.0f * (axisQuatXX + axisQuatZZ), 2.0f * (axisQuatYZ + axisQuatXW), 0.0f,
      2.0f * (axisQuatXZ + axisQuatYW), 2.0f * (axisQuatYZ - axisQuatXW), 1.0f - 2.0f * (axisQuatXX + axisQuatYY), 0.0f,
      0.0f, 0.0f, 0.0f, 1.0f
    ]
    uHardMat = [
      1.0f - 2.0f * (hardQuatYY + hardQuatZZ), 2.0f * (hardQuatXY + hardQuatZW), 2.0f * (hardQuatXZ - hardQuatYW), 0.0f,
      2.0f * (hardQuatXY - hardQuatZW), 1.0f - 2.0f * (hardQuatXX + hardQuatZZ), 2.0f * (hardQuatYZ + hardQuatXW), 0.0f,
      2.0f * (hardQuatXZ + hardQuatYW), 2.0f * (hardQuatYZ - hardQuatXW), 1.0f - 2.0f * (hardQuatXX + hardQuatYY), 0.0f,
      0.0f, 0.0f, 0.0f, 1.0f
    ]
    uVecA = [1.25f, -2.5f, 3.75f]
    uVecB = [1.25f, -2.5f, 3.75f, 1.0f]
    uMat2A = [1.0f, 2.0f, 3.0f, 4.0f]
    uMat2B = [5.0f, -6.0f, 7.0f, -8.0f]
    uVec2A = [1.25f, -2.5f]
    uMat3A = [1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f, 10.0f]
    uMat3B = [-1.0f, 3.0f, 5.0f, 7.0f, -2.0f, 4.0f, 6.0f, 8.0f, -3.0f]
    uVec2B = [3.0f, -1.5f]
    uVec3C = [1.0f, -2.0f, 3.0f]
  setUniformMat4(program, "uIdentityM", uIdentityM)
  setUniformMat4(program, "uMatA", uMatA)
  setUniformMat4(program, "uMatB", uMatB)
  setUniformMat4(program, "uScaleM", uScaleM)
  setUniformMat4(program, "uTranslateM", uTranslateM)
  setUniformMat4(program, "uRotateXM", uRotateXM)
  setUniformMat4(program, "uRotateYM", uRotateYM)
  setUniformMat4(program, "uRotateZM", uRotateZM)
  setUniformMat4(program, "uAxisMat", uAxisMat)
  setUniformMat4(program, "uHardMat", uHardMat)
  setUniformVec3(program, "uVecA", uVecA)
  setUniformVec4(program, "uVecB", uVecB)
  setUniformMat2(program, "uMat2A", uMat2A)
  setUniformMat2(program, "uMat2B", uMat2B)
  setUniformMat3(program, "uMat3A", uMat3A)
  setUniformMat3(program, "uMat3B", uMat3B)
  setUniformVec2(program, "uVec2A", uVec2A)
  setUniformVec2(program, "uVec2B", uVec2B)
  setUniformVec3(program, "uVec3C", uVec3C)

proc runShader(fragSrc: string, pixelCount: int): seq[float32] =
  ensureContext()

  let program = compileProgram(VertexShaderSrc, fragSrc)
  glUseProgram(program)
  uploadDumpUniforms(program)

  var fbo, texture: GLuint
  glGenFramebuffers(1, fbo.addr)
  glBindFramebuffer(GL_FRAMEBUFFER, fbo)

  glGenTextures(1, texture.addr)
  glBindTexture(GL_TEXTURE_2D, texture)
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F.GLint, pixelCount.GLsizei, 1.GLsizei, 0.GLint, GL_RGBA, cGL_FLOAT, nil)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST.GLint)
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0)

  let status = glCheckFramebufferStatus(GL_FRAMEBUFFER)
  if status != GL_FRAMEBUFFER_COMPLETE:
    echo "Framebuffer incomplete: ", status.uint32
    quit(1)

  glViewport(0, 0, pixelCount.GLsizei, 1)
  glDrawArrays(GL_TRIANGLES, 0, 3)

  result.setLen(pixelCount * 4)
  glReadPixels(0, 0, pixelCount.GLsizei, 1.GLsizei, GL_RGBA, cGL_FLOAT, result[0].addr)

  glBindFramebuffer(GL_FRAMEBUFFER, 0)
  glDeleteTextures(1, texture.addr)
  glDeleteFramebuffers(1, fbo.addr)
  glDeleteProgram(program)

proc runMatrix(expr: string): seq[float32] =
  let shaderSrc = shaderTemplate(fmt"""
  int index = int(gl_FragCoord.x);
  mat4 value = {expr};
  fragColor = value[index];
""")
  runShader(shaderSrc, 4)

proc runMat3(expr: string): seq[float32] =
  let shaderSrc = shaderTemplate(fmt"""
  int index = int(gl_FragCoord.x);
  mat3 value = {expr};
  fragColor = vec4(value[index], 0.0);
""")
  let raw = runShader(shaderSrc, 3)
  result = @[raw[0], raw[1], raw[2], raw[4], raw[5], raw[6], raw[8], raw[9], raw[10]]

proc runMat2(expr: string): seq[float32] =
  let shaderSrc = shaderTemplate(fmt"""
  int index = int(gl_FragCoord.x);
  mat2 value = {expr};
  fragColor = vec4(value[index], 0.0, 0.0);
""")
  let raw = runShader(shaderSrc, 2)
  result = @[raw[0], raw[1], raw[4], raw[5]]

proc runVec3(expr: string): seq[float32] =
  let shaderSrc = shaderTemplate(fmt"""
  vec3 value = {expr};
  fragColor = vec4(value, 0.0);
""")
  runShader(shaderSrc, 1)

proc runVec4(expr: string): seq[float32] =
  let shaderSrc = shaderTemplate(fmt"""
  vec4 value = {expr};
  fragColor = value;
""")
  runShader(shaderSrc, 1)

proc runVec2(expr: string): seq[float32] =
  let shaderSrc = shaderTemplate(fmt"""
  vec2 value = {expr};
  fragColor = vec4(value, 0.0, 0.0);
""")
  let raw = runShader(shaderSrc, 1)
  result = @[raw[0], raw[1]]

proc runScalar(expr: string): float32 =
  runVec4(expr).toOpenArray(0, 3)[0]

proc main() =
  var lines: seq[string]

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in common column-major order")

  lines.heading("matrix basics")
  lines.dumpMat4("identity", runMatrix("identityM()"))
  lines.dumpMat4("matrix_a", runMatrix("matA()"))
  lines.dumpMat4("matrix_b", runMatrix("matB()"))

  lines.heading("matrix multiply")
  lines.dumpMat4("matrix_a * matrix_b", runMatrix("matA() * matB()"))
  lines.dumpMat4("matrix_b * matrix_a", runMatrix("matB() * matA()"))

  lines.heading("element access [row, col]")
  lines.dumpScalar("transform[0, 0]", runScalar("vec4(matA()[0][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[0, 1]", runScalar("vec4(matA()[0][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[0, 2]", runScalar("vec4(matA()[0][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[0, 3]", runScalar("vec4(matA()[0][3], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[1, 0]", runScalar("vec4(matA()[1][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[1, 1]", runScalar("vec4(matA()[1][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[1, 2]", runScalar("vec4(matA()[1][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[1, 3]", runScalar("vec4(matA()[1][3], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[2, 0]", runScalar("vec4(matA()[2][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[2, 1]", runScalar("vec4(matA()[2][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[2, 2]", runScalar("vec4(matA()[2][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[2, 3]", runScalar("vec4(matA()[2][3], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[3, 0]", runScalar("vec4(matA()[3][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[3, 1]", runScalar("vec4(matA()[3][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[3, 2]", runScalar("vec4(matA()[3][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[3, 3]", runScalar("vec4(matA()[3][3], 0.0, 0.0, 0.0)"))

  lines.heading("mat2 basics")
  lines.dumpMat2("identity", runMat2("mat2(1.0)"))
  lines.dumpMat2("mat2_a", runMat2("mat2A()"))
  lines.dumpMat2("mat2_b", runMat2("mat2B()"))

  lines.heading("mat2 multiply")
  lines.dumpMat2("mat2_a * mat2_b", runMat2("mat2A() * mat2B()"))
  lines.dumpMat2("mat2_b * mat2_a", runMat2("mat2B() * mat2A()"))

  lines.heading("mat2 element access [row, col]")
  lines.dumpScalar("mat2[0, 0]", runScalar("vec4(mat2A()[0][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat2[0, 1]", runScalar("vec4(mat2A()[0][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat2[1, 0]", runScalar("vec4(mat2A()[1][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat2[1, 1]", runScalar("vec4(mat2A()[1][1], 0.0, 0.0, 0.0)"))

  lines.heading("mat2 vector multiply")
  lines.dumpVec2("vec2_input", runVec2("vec2A()"))
  lines.dumpVec2("mat2_a * vec2", runVec2("mat2A() * vec2A()"))

  lines.heading("mat2 transpose")
  lines.dumpMat2("mat2_a.transpose", runMat2("transpose(mat2A())"))

  lines.heading("mat2 inverse")
  lines.dumpMat2("mat2_a.inverse", runMat2("inverse(mat2A())"))

  lines.heading("mat3 basics")
  lines.dumpMat3("identity", runMat3("mat3(1.0)"))
  lines.dumpMat3("mat3_a", runMat3("mat3A()"))
  lines.dumpMat3("mat3_b", runMat3("mat3B()"))

  lines.heading("mat3 multiply")
  lines.dumpMat3("mat3_a * mat3_b", runMat3("mat3A() * mat3B()"))
  lines.dumpMat3("mat3_b * mat3_a", runMat3("mat3B() * mat3A()"))

  lines.heading("mat3 element access [row, col]")
  lines.dumpScalar("mat3[0, 0]", runScalar("vec4(mat3A()[0][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[0, 1]", runScalar("vec4(mat3A()[0][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[0, 2]", runScalar("vec4(mat3A()[0][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[1, 0]", runScalar("vec4(mat3A()[1][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[1, 1]", runScalar("vec4(mat3A()[1][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[1, 2]", runScalar("vec4(mat3A()[1][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[2, 0]", runScalar("vec4(mat3A()[2][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[2, 1]", runScalar("vec4(mat3A()[2][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("mat3[2, 2]", runScalar("vec4(mat3A()[2][2], 0.0, 0.0, 0.0)"))

  lines.heading("mat3 vector multiply")
  lines.dumpVec2("vec2_input", runVec2("vec2B()"))
  lines.dumpVec3("vec3_input", runVec3("vec3C()"))
  lines.dumpVec2("mat3_a * vec2", runVec2("(mat3A() * vec3(vec2B(), 1.0)).xy"))
  lines.dumpVec3("mat3_a * vec3", runVec3("mat3A() * vec3C()"))

  lines.heading("mat3 transpose")
  lines.dumpMat3("mat3_a.transpose", runMat3("transpose(mat3A())"))

  lines.heading("mat3 inverse")
  lines.dumpMat3("mat3_a.inverse", runMat3("inverse(mat3A())"))

  lines.heading("mat3 constructors")
  lines.dumpMat3("scale2d", runMat3("scale2D(vec2(2.0, 3.0))"))
  lines.dumpMat3("translate2d", runMat3("translate2D(vec2(5.0, 10.0))"))
  lines.dumpScalar("rotate_angle_radians", runScalar("vec4(rotAngle2D, 0.0, 0.0, 0.0)"))
  lines.dumpMat3("rotate2d", runMat3("rotate2D(rotAngle2D)"))
  lines.dumpMat3("translate * rotate * scale", runMat3("translate2D(vec2(5.0, 10.0)) * rotate2D(rotAngle2D) * scale2D(vec2(2.0, 3.0))"))

  lines.heading("matrix constructors and composition")
  lines.dumpMat4("scale", runMatrix("scaleM()"))
  lines.dumpMat4("translate", runMatrix("translateM()"))
  lines.dumpMat4("rotate_x", runMatrix("rotateXM()"))
  lines.dumpMat4("rotate_y", runMatrix("rotateYM()"))
  lines.dumpMat4("rotate_z", runMatrix("rotateZM()"))
  lines.dumpMat4("pure_rotation = rotate_z * rotate_y * rotate_x", runMatrix("pureRotationM()"))
  lines.dumpMat4("transform = translate * rotate_z * rotate_y * rotate_x * scale", runMatrix("transformM()"))

  lines.heading("matrix vector multiply")
  lines.dumpVec3("vec3_input", runVec3("vecA()"))
  lines.dumpVec4("vec4_input", runVec4("vecB()"))
  lines.dumpVec3("transform * vec3", runVec3("(transformM() * vec4(vecA(), 1.0)).xyz"))
  lines.dumpVec4("transform * vec4", runVec4("transformM() * vecB()"))
  lines.dumpVec3("rotate_z * vec3", runVec3("(rotateZM() * vec4(vecA(), 1.0)).xyz"))
  lines.dumpVec3("translate * vec3", runVec3("(translateM() * vec4(vecA(), 1.0)).xyz"))

  lines.heading("quaternion constructors")
  lines.dumpQuat("quat_identity", runVec4("quatIdentity()"))
  lines.dumpQuat("quat_rotate_x", runVec4("quatX()"))
  lines.dumpQuat("quat_rotate_y", runVec4("quatY()"))
  lines.dumpQuat("quat_rotate_z", runVec4("quatZ()"))
  lines.dumpVec3("axis_normalized", runVec3("axisNormalized()"))
  lines.dumpScalar("axis_angle_radians", runScalar("vec4(axisAngle, 0.0, 0.0, 0.0)"))
  lines.dumpQuat("from_axis_angle", runVec4("axisQuat()"))
  lines.dumpMat4("from_axis_angle.mat4", runMatrix("axisMat()"))

  lines.heading("quaternion multiply")
  lines.dumpQuat("quat_x", runVec4("quatX()"))
  lines.dumpQuat("quat_y", runVec4("quatY()"))
  lines.dumpQuat("quat_z", runVec4("quatZ()"))
  lines.dumpQuat("quat_multiply(quat_x, quat_y)", runVec4("quatMultiply(quatX(), quatY())"))
  lines.dumpQuat("quat_multiply(quat_multiply(quat_x, quat_y), quat_z)", runVec4("quatMultiply(quatMultiply(quatX(), quatY()), quatZ())"))
  lines.dumpMat4("quat_xy.mat4", runMatrix("quatMat4(quatMultiply(quatX(), quatY()))"))
  lines.dumpMat4("quat_xyz.mat4", runMatrix("quatMat4(quatMultiply(quatMultiply(quatX(), quatY()), quatZ()))"))

  lines.heading("quaternion vector rotate")
  lines.dumpVec3("input", runVec3("vecA()"))
  lines.dumpVec3("quat_rotate(quat_x, input)", runVec3("quatRotate(quatX(), vecA())"))
  lines.dumpVec3("quat_rotate(quat_y, input)", runVec3("quatRotate(quatY(), vecA())"))
  lines.dumpVec3("quat_rotate(quat_z, input)", runVec3("quatRotate(quatZ(), vecA())"))
  lines.dumpVec3("quat_rotate(from_axis_angle, input)", runVec3("quatRotate(axisQuat(), vecA())"))
  lines.dumpVec3("quat_z * input", runVec3("quatRotate(quatZ(), vecA())"))

  lines.heading("matrix quaternion roundtrip")
  lines.dumpQuat("pure_rotation.quat", runVec4("mat4Quat(pureRotationM())"))
  lines.dumpMat4("pure_rotation", runMatrix("pureRotationM()"))
  lines.dumpMat4("pure_rotation.quat.mat4", runMatrix("quatMat4(mat4Quat(pureRotationM()))"))
  lines.dumpMat4("transform.rotation_only", runMatrix("rotationOnly(transformM())"))
  lines.dumpQuat("transform.rotation_only.quat", runVec4("mat4Quat(rotationOnly(transformM()))"))
  lines.dumpQuat("axis_mat.quat", runVec4("mat4Quat(axisMat())"))
  lines.dumpMat4("axis_mat.quat.mat4", runMatrix("quatMat4(mat4Quat(axisMat()))"))
  lines.appendLine("hard_decomp.note: 170 degrees around (1,-2,3) normalized - w near zero")
  lines.dumpQuat("hard_decomp.quat_original", runVec4("hardQuat()"))
  lines.dumpQuat("hard_decomp.quat_from_mat", runVec4("mat4Quat(hardMat())"))
  lines.dumpMat4("hard_decomp.mat4", runMatrix("hardMat()"))
  lines.dumpMat4("hard_decomp.quat_from_mat.mat4", runMatrix("quatMat4(mat4Quat(hardMat()))"))

  lines.heading("lookAt matrix")
  lines.appendLine("notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)")
  lines.dumpMat4("lookAt", runMatrix("lookAtM(vec3(5.0, 5.0, 5.0), vec3(0.0), vec3(0.0, 1.0, 0.0))"))

  lines.heading("euler angle decomposition")
  lines.appendLine("notes: euler angles as vec3(pitch/x, yaw/y, roll/z) in radians")
  lines.dumpVec3("pure_rotation.quat.euler", runVec3("quatToAngles(mat4Quat(pureRotationM()))"))
  lines.dumpVec3("from_axis_angle.euler", runVec3("quatToAngles(axisQuat())"))

  lines.heading("matrix inverse")
  lines.dumpMat4("transform.inverse", runMatrix("inverse(transformM())"))
  lines.dumpMat4("pure_rotation.inverse", runMatrix("inverse(pureRotationM())"))

  lines.heading("cross product")
  lines.appendLine("notes: cross(a, b) where a and b are vec3")
  lines.dumpVec3("cross(x_axis, y_axis)", runVec3("cross(vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0))"))
  lines.dumpVec3("cross(y_axis, x_axis)", runVec3("cross(vec3(0.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0))"))
  lines.dumpVec3("cross(c, d)", runVec3("cross(normalize(vec3(1.0, 2.0, 3.0)), normalize(vec3(-1.0, 0.5, 2.0)))"))

  lines.heading("slerp")
  lines.appendLine("notes: slerp(a, b, t) between quat_x and quat_z")
  lines.dumpQuat("slerp(quat_x, quat_z, 0.25)", runVec4("slerpQ(quatX(), quatZ(), 0.25)"))
  lines.dumpQuat("slerp(quat_x, quat_z, 0.5)", runVec4("slerpQ(quatX(), quatZ(), 0.5)"))
  lines.dumpQuat("slerp(quat_x, quat_z, 0.75)", runVec4("slerpQ(quatX(), quatZ(), 0.75)"))

  lines.heading("fromTwoVectors")
  lines.appendLine("notes: quaternion that rotates vector a to vector b")
  lines.dumpQuat("from_x_to_y", runVec4("fromTwoVectorsQ(normalize(vec3(1.0, 0.0, 0.0)), normalize(vec3(0.0, 1.0, 0.0)))"))
  lines.dumpQuat("from_c_to_d", runVec4("fromTwoVectorsQ(normalize(vec3(1.0, 2.0, -1.0)), normalize(vec3(-1.0, 0.5, 2.0)))"))
  lines.dumpVec3("verify_x_to_y", runVec3("quatRotate(fromTwoVectorsQ(normalize(vec3(1.0, 0.0, 0.0)), normalize(vec3(0.0, 1.0, 0.0))), normalize(vec3(1.0, 0.0, 0.0)))"))
  lines.dumpVec3("verify_c_to_d", runVec3("quatRotate(fromTwoVectorsQ(normalize(vec3(1.0, 2.0, -1.0)), normalize(vec3(-1.0, 0.5, 2.0))), normalize(vec3(1.0, 2.0, -1.0)))"))

  lines.heading("quaternion inverse")
  lines.dumpQuat("from_axis_angle.inverse", runVec4("quatInverse(axisQuat())"))
  lines.dumpQuat("verify_q_mul_qinv", runVec4("quatMultiply(axisQuat(), quatInverse(axisQuat()))"))

  lines.heading("quaternion to axis-angle")
  lines.dumpVec3("from_axis_angle.axis", runVec3("quatAxisOnly(axisQuat())"))
  lines.dumpScalar("from_axis_angle.angle", runScalar("vec4(quatAngleOnly(axisQuat()), 0.0, 0.0, 0.0)"))
  lines.dumpVec3("quat_xyz.axis", runVec3("quatAxisOnly(quatMultiply(quatMultiply(quatX(), quatY()), quatZ()))"))
  lines.dumpScalar("quat_xyz.angle", runScalar("vec4(quatAngleOnly(quatMultiply(quatMultiply(quatX(), quatY()), quatZ())), 0.0, 0.0, 0.0)"))

  lines.heading("perspective matrix")
  lines.appendLine("notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0")
  lines.dumpMat4("perspective", runMatrix("perspectiveM(60.0, 1.5, 0.1, 100.0)"))

  lines.heading("ortho matrix")
  lines.appendLine("notes: left=-10, right=10, bottom=-7.5, top=7.5, near=0.1, far=100.0")
  lines.dumpMat4("ortho", runMatrix("orthoM(-10.0, 10.0, -7.5, 7.5, 0.1, 100.0)"))

  lines.heading("basis directions")
  lines.appendLine("N/A")

  lines.heading("default matrix printer")
  lines.appendLine("N/A")

  writeFile(OutputPath, lines.join("\n") & "\n")
  echo "Wrote ", OutputPath

main()
