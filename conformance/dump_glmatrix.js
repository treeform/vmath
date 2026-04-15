import * as mat4 from "../../gl-matrix/src/mat4.js";
import * as mat3 from "../../gl-matrix/src/mat3.js";
import * as vec3 from "../../gl-matrix/src/vec3.js";
import * as vec4 from "../../gl-matrix/src/vec4.js";
import * as quat from "../../gl-matrix/src/quat.js";
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
  if (frac === 1000) {
    whole++;
    frac = 0;
  }
  return sign + String(whole).padStart(3, "0") + "." + String(frac).padStart(3, "0");
}

const lines = [];
function appendLine(line = "") {
  lines.push(line);
}
function heading(title) {
  if (lines.length > 0) appendLine();
  appendLine("== " + title + " ==");
}
function dumpScalar(label, value) {
  appendLine(label + ": " + fmt(value));
}
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
  appendLine("  " + fmt(m[0]) + " " + fmt(m[4]) + " " + fmt(m[8]) + " " + fmt(m[12]));
  appendLine("  " + fmt(m[1]) + " " + fmt(m[5]) + " " + fmt(m[9]) + " " + fmt(m[13]));
  appendLine("  " + fmt(m[2]) + " " + fmt(m[6]) + " " + fmt(m[10]) + " " + fmt(m[14]));
  appendLine("  " + fmt(m[3]) + " " + fmt(m[7]) + " " + fmt(m[11]) + " " + fmt(m[15]));
  appendLine("]");
}
function dumpMat4Default(label, m) {
  appendLine(label + ": " + mat4.str(m));
}

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
  out[12] = 0;
  out[13] = 0;
  out[14] = 0;
  out[15] = 1;
  return out;
}
function quatFromMat(m) {
  return quat.fromMat3(quat.create(), mat3.fromMat4(mat3.create(), m));
}
function quatToEulerXYZ(q) {
  const x = q[0];
  const y = q[1];
  const z = q[2];
  const w = q[3];

  const ex = Math.atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y));
  const ey = Math.asin(Math.max(-1, Math.min(1, 2 * (w * y - z * x))));
  const ez = Math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z));
  return vec3.fromValues(ex, ey, ez);
}
function basisRight(m) {
  return vec3.fromValues(m[0], m[1], m[2]);
}
function basisUp(m) {
  return vec3.fromValues(m[4], m[5], m[6]);
}
function basisForward(m) {
  return vec3.fromValues(m[8], m[9], m[10]);
}
function quatToAxisAngle(q) {
  const normalized = quat.normalize(quat.create(), q);
  const w = Math.max(-1, Math.min(1, normalized[3]));
  const angle = 2 * Math.acos(w);
  const s = Math.sqrt(Math.max(0, 1 - w * w));
  if (s < 0.00001) {
    return {
      axis: vec3.fromValues(1, 0, 0),
      angle: 0,
    };
  }
  return {
    axis: vec3.fromValues(normalized[0] / s, normalized[1] / s, normalized[2] / s),
    angle,
  };
}

const DEG2RAD = Math.PI / 180;
const angleA = 37 * DEG2RAD;
const angleB = -23 * DEG2RAD;
const angleC = 71 * DEG2RAD;

const matA = mat4.fromValues(
  1.0, 2.0, 3.0, 4.0,
  5.0, 6.0, 7.0, 8.0,
  9.0, 10.0, 11.0, 12.0,
  13.0, 14.0, 15.0, 16.0
);
const matB = mat4.fromValues(
  -10.0, -20.0, -30.0, -40.0,
  50.0, 60.0, 70.0, 80.0,
  90.0, 100.0, 110.0, 120.0,
  130.0, 140.0, 150.0, 160.0
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
const pureRotationQuat = quatFromMat(pureRotationM);

heading("dump");
appendLine("notes: matrices are printed in common column-major order");

heading("matrix basics");
dumpMat4("identity", mat4.create());
dumpMat4("matrix_a", matA);
dumpMat4("matrix_b", matB);

heading("matrix multiply");
dumpMat4("matrix_a * matrix_b", mul(matA, matB));
dumpMat4("matrix_b * matrix_a", mul(matB, matA));

heading("element access [row, col]");
appendLine("N/A");

heading("matrix constructors and composition");
dumpMat4("scale", scaleM);
dumpMat4("translate", translateM);
dumpMat4("rotate_x", rotateXM);
dumpMat4("rotate_y", rotateYM);
dumpMat4("rotate_z", rotateZM);
dumpMat4("pure_rotation = rotate_z * rotate_y * rotate_x", pureRotationM);
dumpMat4("transform = translate * rotate_z * rotate_y * rotate_x * scale", transformM);

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
dumpQuat("pure_rotation.quat", pureRotationQuat);
dumpMat4("pure_rotation", pureRotationM);
dumpMat4("pure_rotation.quat.mat4", mat4FromQuat(pureRotationQuat));
dumpMat4("transform.rotation_only", rotationOnlyM);
dumpQuat("transform.rotation_only.quat", quatFromMat(rotationOnlyM));
dumpQuat("axis_mat.quat", quatFromMat(axisMat));
dumpMat4("axis_mat.quat.mat4", mat4FromQuat(quatFromMat(axisMat)));
appendLine("hard_decomp.note: 170 degrees around (1,-2,3) normalized - w near zero");
dumpQuat("hard_decomp.quat_original", hardQuat);
dumpQuat("hard_decomp.quat_from_mat", quatFromMat(hardMat));
dumpMat4("hard_decomp.mat4", hardMat);
dumpMat4("hard_decomp.quat_from_mat.mat4", mat4FromQuat(quatFromMat(hardMat)));

heading("lookAt matrix");
appendLine("notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)");
dumpMat4("lookAt", mat4.lookAt(
  mat4.create(),
  vec3.fromValues(5, 5, 5),
  vec3.fromValues(0, 0, 0),
  vec3.fromValues(0, 1, 0)
));

heading("euler angle decomposition");
appendLine("notes: euler angles as vec3(pitch/x, yaw/y, roll/z) in radians");
dumpVec3("pure_rotation.quat.euler", quatToEulerXYZ(pureRotationQuat));
dumpVec3("from_axis_angle.euler", quatToEulerXYZ(axisQuat));

heading("matrix inverse");
dumpMat4("transform.inverse", mat4.invert(mat4.create(), transformM));
dumpMat4("pure_rotation.inverse", mat4.invert(mat4.create(), pureRotationM));

heading("cross product");
appendLine("notes: cross(a, b) where a and b are vec3");
const crossA = vec3.fromValues(1, 0, 0);
const crossB = vec3.fromValues(0, 1, 0);
const crossC = vec3.normalize(vec3.create(), vec3.fromValues(1, 2, 3));
const crossD = vec3.normalize(vec3.create(), vec3.fromValues(-1, 0.5, 2));
dumpVec3("cross(x_axis, y_axis)", vec3.cross(vec3.create(), crossA, crossB));
dumpVec3("cross(y_axis, x_axis)", vec3.cross(vec3.create(), crossB, crossA));
dumpVec3("cross(c, d)", vec3.cross(vec3.create(), crossC, crossD));

heading("slerp");
appendLine("notes: slerp(a, b, t) between quat_x and quat_z");
dumpQuat("slerp(quat_x, quat_z, 0.25)", quat.slerp(quat.create(), quatX, quatZ, 0.25));
dumpQuat("slerp(quat_x, quat_z, 0.5)", quat.slerp(quat.create(), quatX, quatZ, 0.5));
dumpQuat("slerp(quat_x, quat_z, 0.75)", quat.slerp(quat.create(), quatX, quatZ, 0.75));

heading("fromTwoVectors");
appendLine("notes: quaternion that rotates vector a to vector b");
const fromA = vec3.fromValues(1, 0, 0);
const fromB = vec3.fromValues(0, 1, 0);
const fromC = vec3.normalize(vec3.create(), vec3.fromValues(1, 2, -1));
const fromD = vec3.normalize(vec3.create(), vec3.fromValues(-1, 0.5, 2));
const fromXToY = quat.rotationTo(quat.create(), fromA, fromB);
const fromCToD = quat.rotationTo(quat.create(), fromC, fromD);
dumpQuat("from_x_to_y", fromXToY);
dumpQuat("from_c_to_d", fromCToD);
dumpVec3("verify_x_to_y", vec3.transformQuat(vec3.create(), fromA, fromXToY));
dumpVec3("verify_c_to_d", vec3.transformQuat(vec3.create(), fromC, fromCToD));

heading("quaternion inverse");
dumpQuat("from_axis_angle.inverse", quat.invert(quat.create(), axisQuat));
dumpQuat("verify_q_mul_qinv", quat.multiply(quat.create(), axisQuat, quat.invert(quat.create(), axisQuat)));

heading("quaternion to axis-angle");
const axisAngle1 = quatToAxisAngle(axisQuat);
const axisAngle2 = quatToAxisAngle(quatXYZ);
dumpVec3("from_axis_angle.axis", axisAngle1.axis);
dumpScalar("from_axis_angle.angle", axisAngle1.angle);
dumpVec3("quat_xyz.axis", axisAngle2.axis);
dumpScalar("quat_xyz.angle", axisAngle2.angle);

const DEG2RAD_60 = 60 * DEG2RAD;

heading("perspective matrix");
appendLine("notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0");
dumpMat4("perspective", mat4.perspective(mat4.create(), DEG2RAD_60, 1.5, 0.1, 100.0));

heading("ortho matrix");
appendLine("notes: left=-10, right=10, bottom=-7.5, top=7.5, near=0.1, far=100.0");
dumpMat4("ortho", mat4.ortho(mat4.create(), -10, 10, -7.5, 7.5, 0.1, 100.0));

heading("basis directions");
dumpVec3("forward", basisForward(matA));
dumpVec3("right", basisRight(matA));
dumpVec3("up", basisUp(matA));

heading("default matrix printer");
dumpMat4Default("matrix_a.default", matA);
dumpMat4Default("transform.default", transformM);

writeFileSync(OutputPath, lines.join("\n") + "\n");
console.log("Wrote", OutputPath);
