import
  std/[math, os, strformat, strutils],
  opengl,
  shady/compute

const
  OutputPath = parentDir(currentSourcePath()) / "dump_glsl.txt"
  ShaderPath = parentDir(currentSourcePath()) / "dump_glsl.comp"

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

proc dumpVec3(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ": <" & fmt(value[0]) & ", " & fmt(value[1]) & ", " & fmt(value[2]) & ">")

proc dumpVec4(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ": <" & fmt(value[0]) & ", " & fmt(value[1]) & ", " & fmt(value[2]) & ", " & fmt(value[3]) & ">")

proc dumpQuat(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ": <" & fmt(value[0]) & ", " & fmt(value[1]) & ", " & fmt(value[2]) & ", " & fmt(value[3]) & ">")

proc dumpMat4(lines: var seq[string], label: string, value: openArray[float32]) =
  lines.appendLine(label & ":")
  lines.appendLine("[")
  for offset in countup(0, 12, 4):
    lines.appendLine(
      "  " &
      fmt(value[offset + 0]) & " " &
      fmt(value[offset + 1]) & " " &
      fmt(value[offset + 2]) & " " &
      fmt(value[offset + 3])
    )
  lines.appendLine("]")

proc heading(lines: var seq[string], title: string) =
  if lines.len > 0:
    lines.appendLine()
  lines.appendLine("== " & title & " ==")

proc glslPrelude(): string =
  result = """
#version 430
layout (local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
layout (rgba32f, binding = 0) uniform writeonly imageBuffer outputBuffer;

const float angleA = radians(37.0);
const float angleB = radians(-23.0);
const float angleC = radians(71.0);
const float axisAngle = radians(48.0);

mat4 identityM() {
  return mat4(
    vec4(1.0, 0.0, 0.0, 0.0),
    vec4(0.0, 1.0, 0.0, 0.0),
    vec4(0.0, 0.0, 1.0, 0.0),
    vec4(0.0, 0.0, 0.0, 1.0)
  );
}

mat4 matA() {
  return mat4(
    vec4(1.0, 5.0, 9.0, 13.0),
    vec4(2.0, 6.0, 10.0, 14.0),
    vec4(3.0, 7.0, 11.0, 15.0),
    vec4(4.0, 8.0, 12.0, 16.0)
  );
}

mat4 matB() {
  return mat4(
    vec4(0.5, 1.5, -3.0, 0.0),
    vec4(-1.0, 0.75, 4.0, 1.0),
    vec4(2.0, -0.5, 1.25, -1.5),
    vec4(0.25, 2.0, -2.5, 3.0)
  );
}

vec3 vecA() {
  return vec3(1.25, -2.5, 3.75);
}

vec4 vecB() {
  return vec4(1.25, -2.5, 3.75, 1.0);
}

mat4 scaleM() {
  return mat4(
    vec4(2.0, 0.0, 0.0, 0.0),
    vec4(0.0, 3.0, 0.0, 0.0),
    vec4(0.0, 0.0, 4.0, 0.0),
    vec4(0.0, 0.0, 0.0, 1.0)
  );
}

mat4 translateM() {
  return mat4(
    vec4(1.0, 0.0, 0.0, 0.0),
    vec4(0.0, 1.0, 0.0, 0.0),
    vec4(0.0, 0.0, 1.0, 0.0),
    vec4(10.0, 20.0, 30.0, 1.0)
  );
}

mat4 rotateXM() {
  float s = sin(angleA);
  float c = cos(angleA);
  return mat4(
    vec4(1.0, 0.0, 0.0, 0.0),
    vec4(0.0, c, s, 0.0),
    vec4(0.0, -s, c, 0.0),
    vec4(0.0, 0.0, 0.0, 1.0)
  );
}

mat4 rotateYM() {
  float s = sin(angleB);
  float c = cos(angleB);
  return mat4(
    vec4(c, 0.0, -s, 0.0),
    vec4(0.0, 1.0, 0.0, 0.0),
    vec4(s, 0.0, c, 0.0),
    vec4(0.0, 0.0, 0.0, 1.0)
  );
}

mat4 rotateZM() {
  float s = sin(angleC);
  float c = cos(angleC);
  return mat4(
    vec4(c, s, 0.0, 0.0),
    vec4(-s, c, 0.0, 0.0),
    vec4(0.0, 0.0, 1.0, 0.0),
    vec4(0.0, 0.0, 0.0, 1.0)
  );
}

mat4 pureRotationM() {
  return rotateZM() * rotateYM() * rotateXM();
}

vec3 axisNormalized() {
  return normalize(vec3(1.0, 2.0, -3.0));
}

vec4 quatIdentity() {
  return vec4(0.0, 0.0, 0.0, 1.0);
}

vec4 quatAxisAngle(vec3 axis, float angle) {
  vec3 a = normalize(axis);
  float s = sin(angle * 0.5);
  return vec4(a * s, cos(angle * 0.5));
}

vec4 quatX() {
  return quatAxisAngle(vec3(1.0, 0.0, 0.0), angleA);
}

vec4 quatY() {
  return quatAxisAngle(vec3(0.0, 1.0, 0.0), angleB);
}

vec4 quatZ() {
  return quatAxisAngle(vec3(0.0, 0.0, 1.0), angleC);
}

vec4 axisQuat() {
  return quatAxisAngle(axisNormalized(), axisAngle);
}

vec4 quatMultiply(vec4 a, vec4 b) {
  return vec4(
    a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
    a.w * b.y + a.y * b.w + a.z * b.x - a.x * b.z,
    a.w * b.z + a.z * b.w + a.x * b.y - a.y * b.x,
    a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z
  );
}

vec3 quatRotate(vec4 q, vec3 v) {
  vec3 uv = cross(q.xyz, v);
  vec3 uuv = cross(q.xyz, uv);
  return v + ((uv * q.w) + uuv) * 2.0;
}

mat4 quatMat4(vec4 q) {
  float xx = q.x * q.x;
  float xy = q.x * q.y;
  float xz = q.x * q.z;
  float xw = q.x * q.w;
  float yy = q.y * q.y;
  float yz = q.y * q.z;
  float yw = q.y * q.w;
  float zz = q.z * q.z;
  float zw = q.z * q.w;

  return mat4(
    vec4(1.0 - 2.0 * (yy + zz), 2.0 * (xy + zw), 2.0 * (xz - yw), 0.0),
    vec4(2.0 * (xy - zw), 1.0 - 2.0 * (xx + zz), 2.0 * (yz + xw), 0.0),
    vec4(2.0 * (xz + yw), 2.0 * (yz - xw), 1.0 - 2.0 * (xx + yy), 0.0),
    vec4(0.0, 0.0, 0.0, 1.0)
  );
}

vec4 mat4Quat(mat4 m) {
  float m00 = m[0][0];
  float m11 = m[1][1];
  float m22 = m[2][2];

  float fourXSquaredMinus1 = m00 - m11 - m22;
  float fourYSquaredMinus1 = m11 - m00 - m22;
  float fourZSquaredMinus1 = m22 - m00 - m11;
  float fourWSquaredMinus1 = m00 + m11 + m22;

  int biggestIndex = 0;
  float fourBiggestSquaredMinus1 = fourWSquaredMinus1;
  if (fourXSquaredMinus1 > fourBiggestSquaredMinus1) {
    fourBiggestSquaredMinus1 = fourXSquaredMinus1;
    biggestIndex = 1;
  }
  if (fourYSquaredMinus1 > fourBiggestSquaredMinus1) {
    fourBiggestSquaredMinus1 = fourYSquaredMinus1;
    biggestIndex = 2;
  }
  if (fourZSquaredMinus1 > fourBiggestSquaredMinus1) {
    fourBiggestSquaredMinus1 = fourZSquaredMinus1;
    biggestIndex = 3;
  }

  float biggestVal = sqrt(fourBiggestSquaredMinus1 + 1.0) * 0.5;
  float mult = 0.25 / biggestVal;
  vec4 q = vec4(0.0);

  if (biggestIndex == 0) {
    q.w = biggestVal;
    q.x = (m[1][2] - m[2][1]) * mult;
    q.y = (m[2][0] - m[0][2]) * mult;
    q.z = (m[0][1] - m[1][0]) * mult;
  } else if (biggestIndex == 1) {
    q.w = (m[1][2] - m[2][1]) * mult;
    q.x = biggestVal;
    q.y = (m[0][1] + m[1][0]) * mult;
    q.z = (m[2][0] + m[0][2]) * mult;
  } else if (biggestIndex == 2) {
    q.w = (m[2][0] - m[0][2]) * mult;
    q.x = (m[0][1] + m[1][0]) * mult;
    q.y = biggestVal;
    q.z = (m[1][2] + m[2][1]) * mult;
  } else {
    q.w = (m[0][1] - m[1][0]) * mult;
    q.x = (m[2][0] + m[0][2]) * mult;
    q.y = (m[1][2] + m[2][1]) * mult;
    q.z = biggestVal;
  }

  return q;
}

mat4 axisMat() {
  return quatMat4(axisQuat());
}

mat4 transformM() {
  return translateM() * rotateZM() * rotateYM() * rotateXM() * scaleM();
}

mat4 rotationOnly(mat4 m) {
  m[3] = vec4(0.0, 0.0, 0.0, 1.0);
  return m;
}

vec3 hardAxis() {
  return normalize(vec3(1.0, -2.0, 3.0));
}

vec4 hardQuat() {
  return quatAxisAngle(hardAxis(), radians(170.0));
}

mat4 hardMat() {
  return quatMat4(hardQuat());
}

mat4 frustumM(float left, float right, float bottom, float top, float nearV, float farV) {
  float rl = right - left;
  float tb = top - bottom;
  float fn = farV - nearV;
  return mat4(
    vec4((nearV * 2.0) / rl, 0.0, 0.0, 0.0),
    vec4(0.0, (nearV * 2.0) / tb, 0.0, 0.0),
    vec4((right + left) / rl, (top + bottom) / tb, -(farV + nearV) / fn, -1.0),
    vec4(0.0, 0.0, -(farV * nearV * 2.0) / fn, 0.0)
  );
}

mat4 perspectiveM(float fovyDeg, float aspect, float nearV, float farV) {
  float top = nearV * tan(fovyDeg * 3.14159265359 / 360.0);
  float right = top * aspect;
  return frustumM(-right, right, -top, top, nearV, farV);
}

mat4 orthoM(float left, float right, float bottom, float top, float nearV, float farV) {
  float rl = right - left;
  float tb = top - bottom;
  float fn = farV - nearV;
  return mat4(
    vec4(2.0 / rl, 0.0, 0.0, 0.0),
    vec4(0.0, 2.0 / tb, 0.0, 0.0),
    vec4(0.0, 0.0, -2.0 / fn, 0.0),
    vec4(-(left + right) / rl, -(top + bottom) / tb, -(farV + nearV) / fn, 1.0)
  );
}

mat4 lookAtM(vec3 eye, vec3 center, vec3 up) {
  if (all(equal(eye, center))) {
    return identityM();
  }

  vec3 z = normalize(eye - center);
  vec3 x = cross(up, z);
  if (length(x) == 0.0) {
    x = vec3(0.0);
  } else {
    x = normalize(x);
  }
  vec3 y = cross(z, x);

  return mat4(
    vec4(x.x, y.x, z.x, 0.0),
    vec4(x.y, y.y, z.y, 0.0),
    vec4(x.z, y.z, z.z, 0.0),
    vec4(-dot(x, eye), -dot(y, eye), -dot(z, eye), 1.0)
  );
}

vec4 quatInverse(vec4 q) {
  float d = dot(q, q);
  return vec4(-q.x / d, -q.y / d, -q.z / d, q.w / d);
}

vec3 orthogonalV(vec3 v) {
  vec3 av = abs(v);
  vec3 other;
  if (av.x < av.y) {
    other = av.x < av.z ? vec3(1.0, 0.0, 0.0) : vec3(0.0, 0.0, 1.0);
  } else {
    other = av.y < av.z ? vec3(0.0, 1.0, 0.0) : vec3(0.0, 0.0, 1.0);
  }
  return cross(av, other);
}

vec4 fromTwoVectorsQ(vec3 a, vec3 b) {
  vec3 u = normalize(b);
  vec3 v = normalize(a);
  if (all(equal(u, -v))) {
    vec3 q = normalize(orthogonalV(u));
    return vec4(q.x, q.y, q.z, 0.0);
  }
  vec3 halfV = normalize(u + v);
  vec3 q = cross(v, halfV);
  float w = dot(v, halfV);
  return vec4(q.x, q.y, q.z, w);
}

vec4 slerpQ(vec4 a, vec4 b, float t) {
  vec4 z = b;
  float cosTheta = dot(a, b);
  if (cosTheta < 0.0) {
    z = -b;
    cosTheta = -cosTheta;
  }
  if (cosTheta > 1.0 - 1e-6) {
    return vec4(
      a.x + (z.x - a.x) * t,
      a.y + (z.y - a.y) * t,
      a.z + (z.z - a.z) * t,
      a.w + (z.w - a.w) * t
    );
  } else {
    float angle = acos(cosTheta);
    return (sin((1.0 - t) * angle) * a + sin(t * angle) * z) / sin(angle);
  }
}

vec3 quatAxisOnly(vec4 q) {
  float cosAngle = q.w;
  float sinAngle = sqrt(max(0.0, 1.0 - cosAngle * cosAngle));
  if (abs(sinAngle) < 0.0005) {
    sinAngle = 1.0;
  }
  return vec3(q.x / sinAngle, q.y / sinAngle, q.z / sinAngle);
}

float quatAngleOnly(vec4 q) {
  return acos(q.w) * 2.0;
}

vec3 quatToAngles(vec4 q) {
  float x = q.x;
  float y = q.y;
  float z = q.z;
  float w = q.w;
  return vec3(
    atan(2.0 * (w * x + y * z), 1.0 - 2.0 * (x * x + y * y)),
    asin(2.0 * (w * y - z * x)),
    atan(2.0 * (w * z + x * y), 1.0 - 2.0 * (y * y + z * z))
  );
}
"""

proc runComputeShader(shaderSrc: string, invocationCount: int): seq[float32] =
  writeFile(ShaderPath, shaderSrc)
  initOffscreenWindow()

  let shaderId = compileComputeShader((ShaderPath, shaderSrc))
  glUseProgram(shaderId)

  var
    outputBufferId: GLuint
    outputTextureId: GLuint
  glGenBuffers(1, outputBufferId.addr)
  glBindBuffer(GL_TEXTURE_BUFFER, outputBufferId)
  glBufferData(GL_TEXTURE_BUFFER, invocationCount * 4 * sizeof(float32), nil, GL_STATIC_DRAW)

  glGenTextures(1, outputTextureId.addr)
  glActiveTexture(GL_TEXTURE0)
  glBindTexture(GL_TEXTURE_BUFFER, outputTextureId)
  glTexBuffer(GL_TEXTURE_BUFFER, GL_RGBA32F, outputBufferId)
  glBindImageTexture(0, outputTextureId, 0, GL_FALSE, 0, GL_WRITE_ONLY, GL_RGBA32F)

  glDispatchCompute(invocationCount.GLuint, 1, 1)
  glMemoryBarrier(GL_BUFFER_UPDATE_BARRIER_BIT or GL_SHADER_IMAGE_ACCESS_BARRIER_BIT)

  result.setLen(invocationCount * 4)
  let mapped = cast[ptr UncheckedArray[float32]](glMapNamedBuffer(outputBufferId, GL_READ_ONLY))
  copyMem(result[0].addr, mapped, result.len * sizeof(float32))
  discard glUnmapNamedBuffer(outputBufferId)

  glBindTexture(GL_TEXTURE_BUFFER, 0)
  glBindBuffer(GL_TEXTURE_BUFFER, 0)
  glDeleteTextures(1, outputTextureId.addr)
  glDeleteBuffers(1, outputBufferId.addr)
  glDeleteProgram(shaderId)

proc runMatrix(expr: string): seq[float32] =
  let shaderSrc = glslPrelude() & "\n" & fmt"""
void main() {{
  uint index = gl_GlobalInvocationID.x;
  mat4 value = {expr};
  imageStore(outputBuffer, int(index), value[int(index)]);
}}
"""
  runComputeShader(shaderSrc, 4)

proc runVec3(expr: string): seq[float32] =
  let shaderSrc = glslPrelude() & "\n" & fmt"""
void main() {{
  vec3 value = {expr};
  imageStore(outputBuffer, 0, vec4(value, 0.0));
}}
"""
  runComputeShader(shaderSrc, 1)

proc runVec4(expr: string): seq[float32] =
  let shaderSrc = glslPrelude() & "\n" & fmt"""
void main() {{
  vec4 value = {expr};
  imageStore(outputBuffer, 0, value);
}}
"""
  runComputeShader(shaderSrc, 1)

proc runScalar(expr: string): float32 =
  runVec4(expr).toOpenArray(0, 3)[0]

proc main() =
  var lines: seq[string]

  lines.heading("dump")
  lines.appendLine("notes: matrices are printed in raw in-memory order, four scalars per line")

  lines.heading("matrix constructors and composition")
  lines.dumpMat4("identity", runMatrix("identityM()"))
  lines.dumpMat4("matrix_a", runMatrix("matA()"))
  lines.dumpMat4("matrix_b", runMatrix("matB()"))
  lines.dumpMat4("scale", runMatrix("scaleM()"))
  lines.dumpMat4("translate", runMatrix("translateM()"))
  lines.dumpMat4("rotate_x", runMatrix("rotateXM()"))
  lines.dumpMat4("rotate_y", runMatrix("rotateYM()"))
  lines.dumpMat4("rotate_z", runMatrix("rotateZM()"))
  lines.dumpMat4("pure_rotation = rotate_z * rotate_y * rotate_x", runMatrix("pureRotationM()"))
  lines.dumpMat4("transform = translate * rotate_z * rotate_y * rotate_x * scale", runMatrix("transformM()"))

  lines.heading("matrix multiply")
  lines.dumpMat4("lhs", runMatrix("matA()"))
  lines.dumpMat4("rhs", runMatrix("matB()"))
  lines.dumpMat4("lhs * rhs", runMatrix("matA() * matB()"))
  lines.dumpMat4("rhs * lhs", runMatrix("matB() * matA()"))

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

  lines.heading("perspective matrix")
  lines.appendLine("notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0")
  lines.dumpMat4("perspective", runMatrix("perspectiveM(60.0, 1.5, 0.1, 100.0)"))

  lines.heading("ortho matrix")
  lines.appendLine("notes: left=-10, right=10, bottom=-7.5, top=7.5, near=0.1, far=100.0")
  lines.dumpMat4("ortho", runMatrix("orthoM(-10.0, 10.0, -7.5, 7.5, 0.1, 100.0)"))

  lines.heading("lookAt matrix")
  lines.appendLine("notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)")
  lines.dumpMat4("lookAt", runMatrix("lookAtM(vec3(5.0, 5.0, 5.0), vec3(0.0), vec3(0.0, 1.0, 0.0))"))

  lines.heading("euler angle decomposition")
  lines.appendLine("notes: euler angles as vec3(pitch/x, yaw/y, roll/z) in radians")
  lines.dumpVec3("pure_rotation.quat.euler", runVec3("quatToAngles(mat4Quat(pureRotationM()))"))
  lines.dumpVec3("from_axis_angle.euler", runVec3("quatToAngles(axisQuat())"))

  lines.heading("basis directions")
  lines.appendLine("notes: library-specific, N/A for libraries without canonical basis helpers")
  lines.dumpVec3("canonical_right", runVec3("vec3(1.0, 0.0, 0.0)"))
  lines.dumpVec3("canonical_up", runVec3("vec3(0.0, 1.0, 0.0)"))
  lines.dumpVec3("canonical_forward", runVec3("vec3(0.0, 0.0, 1.0)"))
  lines.dumpVec3("quat_z.right", runVec3("quatRotate(quatZ(), vec3(1.0, 0.0, 0.0))"))
  lines.dumpVec3("quat_z.up", runVec3("quatRotate(quatZ(), vec3(0.0, 1.0, 0.0))"))
  lines.dumpVec3("quat_z.forward", runVec3("quatRotate(quatZ(), vec3(0.0, 0.0, 1.0))"))

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

  lines.heading("element access [row,col]")
  lines.appendLine("notes: [row,col] in math convention, element (i,j) = row i, col j")
  lines.dumpScalar("transform[0,0]", runScalar("vec4(transformM()[0][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[0,1]", runScalar("vec4(transformM()[1][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[0,2]", runScalar("vec4(transformM()[2][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[0,3]", runScalar("vec4(transformM()[3][0], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[1,0]", runScalar("vec4(transformM()[0][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[1,3]", runScalar("vec4(transformM()[3][1], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[2,0]", runScalar("vec4(transformM()[0][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[2,3]", runScalar("vec4(transformM()[3][2], 0.0, 0.0, 0.0)"))
  lines.dumpScalar("transform[3,3]", runScalar("vec4(transformM()[3][3], 0.0, 0.0, 0.0)"))

  writeFile(OutputPath, lines.join("\n") & "\n")
  echo "Wrote ", OutputPath

main()
