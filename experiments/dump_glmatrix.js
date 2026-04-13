import * as mat4 from "/Users/me/p/gl-matrix/src/mat4.js";
import * as mat3 from "/Users/me/p/gl-matrix/src/mat3.js";
import * as vec3 from "/Users/me/p/gl-matrix/src/vec3.js";
import * as vec4 from "/Users/me/p/gl-matrix/src/vec4.js";
import * as quat from "/Users/me/p/gl-matrix/src/quat.js";
import { writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const OutputPath = join(__dirname, "dump_glmatrix.txt");

function cleanFloat(value) {
  if (Math.abs(value) < 0.0000005) return 0;
  return value;
}

function fmt(value) {
  const cleaned = cleanFloat(value);
  const sign = cleaned < 0 ? "-" : "+";
  let abs = Math.abs(cleaned);
  let whole = Math.floor(abs);
  let frac = Math.round((abs - whole) * 1000);
  if (frac === 1000) { whole++; frac = 0; }
  return sign + String(whole).padStart(3, "0") + "." + String(frac).padStart(3, "0");
}

const lines = [];
function appendLine(line = "") { lines.push(line); }
function heading(title) {
  if (lines.length > 0) appendLine();
  appendLine("== " + title + " ==");
}
function dumpScalar(label, value) { appendLine(label + ": " + fmt(value)); }
function dumpVec3(label, v) {
  appendLine(label + ": <" + fmt(v[0]) + ", " + fmt(v[1]) + ", " + fmt(v[2]) + ">");
}
function dumpVec4(label, v) {
  appendLine(label + ": <" + fmt(v[0]) + ", " + fmt(v[1]) + ", " + fmt(v[2]) + ", " + fmt(v[3]) + ">");
}
function dumpQuat(label, q) {
  appendLine(label + ": <" + fmt(q[0]) + ", " + fmt(q[1]) + ", " + fmt(q[2]) + ", " + fmt(q[3]) + ">");
}
function dumpMat4(label, m) {
  appendLine(label + ":");
  appendLine("[");
  for (let col = 0; col < 4; col++) {
    const off = col * 4;
    appendLine("  " + fmt(m[off]) + " " + fmt(m[off+1]) + " " + fmt(m[off+2]) + " " + fmt(m[off+3]));
  }
  appendLine("]");
}

// Helper: create a mat4 from row-major input (math notation).
// Row-major element (r,c) goes to column-major arr[c*4+r].
function mat4FromRows(
  m00, m01, m02, m03,
  m10, m11, m12, m13,
  m20, m21, m22, m23,
  m30, m31, m32, m33
) {
  return mat4.fromValues(
    m00, m10, m20, m30,
    m01, m11, m21, m31,
    m02, m12, m22, m32,
    m03, m13, m23, m33
  );
}

// gl-matrix transforms take (out, matrix, param) — mutate out.
// Helpers to build fresh matrices from identity.
function scaleMat(sx, sy, sz) {
  return mat4.scale(mat4.create(), mat4.create(), vec3.fromValues(sx, sy, sz));
}
function translateMat(tx, ty, tz) {
  return mat4.translate(mat4.create(), mat4.create(), vec3.fromValues(tx, ty, tz));
}
function rotateXMat(angle) {
  return mat4.rotateX(mat4.create(), mat4.create(), angle);
}
function rotateYMat(angle) {
  return mat4.rotateY(mat4.create(), mat4.create(), angle);
}
function rotateZMat(angle) {
  return mat4.rotateZ(mat4.create(), mat4.create(), angle);
}
function mul(a, b) {
  return mat4.multiply(mat4.create(), a, b);
}
function transformVec3(m, v) {
  return vec3.transformMat4(vec3.create(), v, m);
}
function transformVec4(m, v) {
  return vec4.transformMat4(vec4.create(), v, m);
}
function quatFromAxisAngle(axis, angle) {
  return quat.setAxisAngle(quat.create(), axis, angle);
}
function quatMul(a, b) {
  return quat.multiply(quat.create(), a, b);
}
function quatRotateVec3(q, v) {
  return vec3.transformQuat(vec3.create(), v, q);
}
function mat4FromQuat(q) {
  return mat4.fromQuat(mat4.create(), q);
}
function rotationOnlyCopy(m) {
  const out = mat4.clone(m);
  out[12] = 0; out[13] = 0; out[14] = 0; out[15] = 1;
  return out;
}
function mat3FromMat4Upper(m) {
  return mat3.fromMat4(mat3.create(), m);
}
function quatFromMat(m) {
  const m3 = mat3FromMat4Upper(m);
  return quat.fromMat3(quat.create(), m3);
}

// --- Main ---

const DEG2RAD = Math.PI / 180;
const angleA = 37 * DEG2RAD;
const angleB = -23 * DEG2RAD;
const angleC = 71 * DEG2RAD;

const matA = mat4FromRows(
  1.0, 2.0, 3.0, 4.0,
  5.0, 6.0, 7.0, 8.0,
  9.0, 10.0, 11.0, 12.0,
  13.0, 14.0, 15.0, 16.0
);
const matB = mat4FromRows(
  0.5, -1.0, 2.0, 0.25,
  1.5, 0.75, -0.5, 2.0,
  -3.0, 4.0, 1.25, -2.5,
  0.0, 1.0, -1.5, 3.0
);
const vecA = vec3.fromValues(1.25, -2.5, 3.75);
const vecB = vec4.fromValues(1.25, -2.5, 3.75, 1.0);

const scaleM = scaleMat(2.0, 3.0, 4.0);
const translateM = translateMat(10.0, 20.0, 30.0);
const rotateXM = rotateXMat(angleA);
const rotateYM = rotateYMat(angleB);
const rotateZM = rotateZMat(angleC);
const pureRotationM = mul(rotateZM, mul(rotateYM, rotateXM));

const axis = vec3.normalize(vec3.create(), vec3.fromValues(1.0, 2.0, -3.0));
const axisAngle = 48 * DEG2RAD;
const axisQuat = quatFromAxisAngle(axis, axisAngle);
const axisMat = mat4FromQuat(axisQuat);
const transformM = mul(translateM, mul(rotateZM, mul(rotateYM, mul(rotateXM, scaleM))));

const quatX = quatFromAxisAngle(vec3.fromValues(1, 0, 0), angleA);
const quatY = quatFromAxisAngle(vec3.fromValues(0, 1, 0), angleB);
const quatZ = quatFromAxisAngle(vec3.fromValues(0, 0, 1), angleC);
const quatXY = quatMul(quatX, quatY);
const quatXYZ = quatMul(quatXY, quatZ);

const hardAxis = vec3.normalize(vec3.create(), vec3.fromValues(1.0, -2.0, 3.0));
const hardAngle = 170 * DEG2RAD;
const hardQuat = quatFromAxisAngle(hardAxis, hardAngle);
const hardMat = mat4FromQuat(hardQuat);

const rotationOnlyM = rotationOnlyCopy(transformM);
const basisRight   = vec3.fromValues(1, 0, 0);
const basisUp      = vec3.fromValues(0, 1, 0);
const basisForward = vec3.fromValues(0, 0, 1);

heading("dump");
appendLine("notes: matrices are printed in raw in-memory order, four scalars per line");

heading("matrix constructors and composition");
dumpMat4("identity", mat4.create());
dumpMat4("matrix_a", matA);
dumpMat4("matrix_b", matB);
dumpMat4("scale", scaleM);
dumpMat4("translate", translateM);
dumpMat4("rotate_x", rotateXM);
dumpMat4("rotate_y", rotateYM);
dumpMat4("rotate_z", rotateZM);
dumpMat4("pure_rotation = rotate_z * rotate_y * rotate_x", pureRotationM);
dumpMat4("transform = translate * rotate_z * rotate_y * rotate_x * scale", transformM);

heading("matrix multiply");
dumpMat4("lhs", matA);
dumpMat4("rhs", matB);
dumpMat4("lhs * rhs", mul(matA, matB));
dumpMat4("rhs * lhs", mul(matB, matA));

heading("matrix vector multiply");
dumpVec3("vec3_input", vecA);
dumpVec4("vec4_input", vecB);
dumpVec3("transform * vec3", transformVec3(transformM, vecA));
dumpVec4("transform * vec4", transformVec4(transformM, vecB));
dumpVec3("rotate_z * vec3", transformVec3(rotateZM, vecA));
dumpVec3("translate * vec3", transformVec3(translateM, vecA));

heading("quaternion constructors");
dumpQuat("quat_identity", quat.create());
dumpQuat("quat_rotate_x", quatX);
dumpQuat("quat_rotate_y", quatY);
dumpQuat("quat_rotate_z", quatZ);
dumpVec3("axis_normalized", axis);
dumpScalar("axis_angle_radians", axisAngle);
dumpQuat("from_axis_angle", axisQuat);
dumpMat4("from_axis_angle.mat4", axisMat);

heading("quaternion multiply");
dumpQuat("quat_x", quatX);
dumpQuat("quat_y", quatY);
dumpQuat("quat_z", quatZ);
dumpQuat("quat_multiply(quat_x, quat_y)", quatXY);
dumpQuat("quat_multiply(quat_multiply(quat_x, quat_y), quat_z)", quatXYZ);
dumpMat4("quat_xy.mat4", mat4FromQuat(quatXY));
dumpMat4("quat_xyz.mat4", mat4FromQuat(quatXYZ));

heading("quaternion vector rotate");
dumpVec3("input", vecA);
dumpVec3("quat_rotate(quat_x, input)", quatRotateVec3(quatX, vecA));
dumpVec3("quat_rotate(quat_y, input)", quatRotateVec3(quatY, vecA));
dumpVec3("quat_rotate(quat_z, input)", quatRotateVec3(quatZ, vecA));
dumpVec3("quat_rotate(from_axis_angle, input)", quatRotateVec3(axisQuat, vecA));
dumpVec3("quat_z * input", quatRotateVec3(quatZ, vecA));

heading("matrix quaternion roundtrip");
const pureRotationQuat = quatFromMat(pureRotationM);
dumpQuat("pure_rotation.quat", pureRotationQuat);
dumpMat4("pure_rotation", pureRotationM);
dumpMat4("pure_rotation.quat.mat4", mat4FromQuat(pureRotationQuat));
dumpMat4("transform.rotation_only", rotationOnlyM);
dumpQuat("transform.rotation_only.quat", quatFromMat(rotationOnlyM));
const axisMatQuat = quatFromMat(axisMat);
dumpQuat("axis_mat.quat", axisMatQuat);
dumpMat4("axis_mat.quat.mat4", mat4FromQuat(axisMatQuat));
appendLine("hard_decomp.note: 170 degrees around (1,-2,3) normalized — w near zero");
dumpQuat("hard_decomp.quat_original", hardQuat);
dumpQuat("hard_decomp.quat_from_mat", quatFromMat(hardMat));
dumpMat4("hard_decomp.mat4", hardMat);
dumpMat4("hard_decomp.quat_from_mat.mat4", mat4FromQuat(quatFromMat(hardMat)));

const DEG2RAD_60 = 60 * Math.PI / 180;

heading("perspective matrix");
appendLine("notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0");
dumpMat4("perspective", mat4.perspective(mat4.create(), DEG2RAD_60, 1.5, 0.1, 100.0));

heading("ortho matrix");
appendLine("notes: left=-10, right=10, bottom=-7.5, top=7.5, near=0.1, far=100.0");
dumpMat4("ortho", mat4.ortho(mat4.create(), -10, 10, -7.5, 7.5, 0.1, 100.0));

heading("lookAt matrix");
appendLine("notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)");
dumpMat4("lookAt", mat4.lookAt(mat4.create(),
  vec3.fromValues(5, 5, 5), vec3.fromValues(0, 0, 0), vec3.fromValues(0, 1, 0)));

heading("euler angle decomposition");
appendLine("N/A");

heading("basis directions");
appendLine("N/A");

heading("element access [row,col]");
appendLine("notes: [row,col] in math convention, element (i,j) = row i, col j");
appendLine("notes: gl-matrix uses flat arr[16], so element (r,c) = arr[c*4+r]");
dumpScalar("transform[0,0]", transformM[0*4+0]);
dumpScalar("transform[0,1]", transformM[1*4+0]);
dumpScalar("transform[0,2]", transformM[2*4+0]);
dumpScalar("transform[0,3]", transformM[3*4+0]);
dumpScalar("transform[1,0]", transformM[0*4+1]);
dumpScalar("transform[1,3]", transformM[3*4+1]);
dumpScalar("transform[2,0]", transformM[0*4+2]);
dumpScalar("transform[2,3]", transformM[3*4+2]);
dumpScalar("transform[3,3]", transformM[3*4+3]);

writeFileSync(OutputPath, lines.join("\n") + "\n");
console.log("Wrote", OutputPath);
