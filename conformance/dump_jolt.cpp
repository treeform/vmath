#include <cmath>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include <Jolt/Jolt.h>
#include <Jolt/Math/Mat44.h>
#include <Jolt/Math/Quat.h>
#include <Jolt/Math/Vec3.h>
#include <Jolt/Math/Vec4.h>

using namespace JPH;

static std::string CleanFloat(float value)
{
	if (std::abs(value) < 0.0000005f)
		value = 0.0f;

	std::ostringstream out;
	out << (value < 0.0f ? "-" : "+")
		<< std::setw(3) << std::setfill('0') << static_cast<int>(std::floor(std::abs(value)))
		<< "."
		<< std::setw(3) << std::setfill('0') << static_cast<int>(std::round((std::abs(value) - std::floor(std::abs(value))) * 1000.0f));

	std::string result = out.str();
	if (result.size() >= 4 && result.substr(result.size() - 4) == "1000")
	{
		int whole = std::stoi(result.substr(1, 3)) + 1;
		std::ostringstream fixed;
		fixed << result[0]
			  << std::setw(3) << std::setfill('0') << whole
			  << ".000";
		return fixed.str();
	}

	return result;
}

static void AppendLine(std::vector<std::string> &lines, const std::string &line = {})
{
	lines.push_back(line);
}

static void DumpScalar(std::vector<std::string> &lines, const std::string &label, float value)
{
	AppendLine(lines, label + ": " + CleanFloat(value));
}

static void DumpVec3(std::vector<std::string> &lines, const std::string &label, Vec3Arg value)
{
	AppendLine(lines, label + ": <" + CleanFloat(value.GetX()) + ", " + CleanFloat(value.GetY()) + ", " + CleanFloat(value.GetZ()) + ">");
}

static void DumpVec4(std::vector<std::string> &lines, const std::string &label, Vec4Arg value)
{
	AppendLine(lines, label + ": <" + CleanFloat(value.GetX()) + ", " + CleanFloat(value.GetY()) + ", " + CleanFloat(value.GetZ()) + ", " + CleanFloat(value.GetW()) + ">");
}

static void DumpQuat(std::vector<std::string> &lines, const std::string &label, QuatArg value)
{
	AppendLine(lines, label + ": <" + CleanFloat(value.GetX()) + ", " + CleanFloat(value.GetY()) + ", " + CleanFloat(value.GetZ()) + ", " + CleanFloat(value.GetW()) + ">");
}

static void DumpMat4(std::vector<std::string> &lines, const std::string &label, Mat44Arg value)
{
	static_assert(sizeof(Mat44) == sizeof(float) * 16, "Mat44 storage is expected to be 16 floats");
	float d[16];
	std::memcpy(d, &value, sizeof(d));

	AppendLine(lines, label + ":");
	AppendLine(lines, "[");
	AppendLine(lines, "  " + CleanFloat(d[0]) + " " + CleanFloat(d[4]) + " " + CleanFloat(d[8]) + " " + CleanFloat(d[12]));
	AppendLine(lines, "  " + CleanFloat(d[1]) + " " + CleanFloat(d[5]) + " " + CleanFloat(d[9]) + " " + CleanFloat(d[13]));
	AppendLine(lines, "  " + CleanFloat(d[2]) + " " + CleanFloat(d[6]) + " " + CleanFloat(d[10]) + " " + CleanFloat(d[14]));
	AppendLine(lines, "  " + CleanFloat(d[3]) + " " + CleanFloat(d[7]) + " " + CleanFloat(d[11]) + " " + CleanFloat(d[15]));
	AppendLine(lines, "]");
}

static void Heading(std::vector<std::string> &lines, const std::string &title)
{
	if (!lines.empty())
		AppendLine(lines);
	AppendLine(lines, "== " + title + " ==");
}

static Mat44 RotationOnlyCopy(Mat44 value)
{
	value(0, 3) = 0.0f;
	value(1, 3) = 0.0f;
	value(2, 3) = 0.0f;
	value(3, 3) = 1.0f;
	return value;
}

int main()
{
	const std::string output_path = "C:/p/vmath/conformance/dump_jolt.txt";

	std::vector<std::string> lines;

	const float angle_a = 37.0f * JPH_PI / 180.0f;
	const float angle_b = -23.0f * JPH_PI / 180.0f;
	const float angle_c = 71.0f * JPH_PI / 180.0f;

	const float mat_a_data[16] = {
		1.0f, 2.0f, 3.0f, 4.0f,
		5.0f, 6.0f, 7.0f, 8.0f,
		9.0f, 10.0f, 11.0f, 12.0f,
		13.0f, 14.0f, 15.0f, 16.0f
	};
	Mat44 mat_a;
	std::memcpy(&mat_a, mat_a_data, sizeof(mat_a));

	const float mat_b_data[16] = {
		-10.0f, -20.0f, -30.0f, -40.0f,
		50.0f, 60.0f, 70.0f, 80.0f,
		90.0f, 100.0f, 110.0f, 120.0f,
		130.0f, 140.0f, 150.0f, 160.0f
	};
	Mat44 mat_b;
	std::memcpy(&mat_b, mat_b_data, sizeof(mat_b));

	const Vec3 vec_a(1.25f, -2.5f, 3.75f);
	const Vec4 vec_b(1.25f, -2.5f, 3.75f, 1.0f);

	const Mat44 scale_m = Mat44::sScale(Vec3(2.0f, 3.0f, 4.0f));
	const Mat44 translate_m = Mat44::sTranslation(Vec3(10.0f, 20.0f, 30.0f));
	const Mat44 rotate_x_m = Mat44::sRotationX(angle_a);
	const Mat44 rotate_y_m = Mat44::sRotationY(angle_b);
	const Mat44 rotate_z_m = Mat44::sRotationZ(angle_c);
	const Mat44 pure_rotation_m = rotate_z_m * rotate_y_m * rotate_x_m;

	const Vec3 axis = Vec3(1.0f, 2.0f, -3.0f).Normalized();
	const float axis_angle = 48.0f * JPH_PI / 180.0f;
	const Quat axis_quat = Quat::sRotation(axis, axis_angle);
	const Mat44 axis_mat = Mat44::sRotation(axis_quat);
	const Mat44 transform_m = translate_m * rotate_z_m * rotate_y_m * rotate_x_m * scale_m;

	const Quat quat_x = Quat::sRotation(Vec3(1.0f, 0.0f, 0.0f), angle_a);
	const Quat quat_y = Quat::sRotation(Vec3(0.0f, 1.0f, 0.0f), angle_b);
	const Quat quat_z = Quat::sRotation(Vec3(0.0f, 0.0f, 1.0f), angle_c);
	const Quat quat_xy = quat_x * quat_y;
	const Quat quat_xyz = quat_xy * quat_z;

	const Vec3 hard_axis = Vec3(1.0f, -2.0f, 3.0f).Normalized();
	const float hard_angle = 170.0f * JPH_PI / 180.0f;
	const Quat hard_quat = Quat::sRotation(hard_axis, hard_angle);
	const Mat44 hard_mat = Mat44::sRotation(hard_quat);

	const Mat44 rotation_only_m = RotationOnlyCopy(transform_m);

	Heading(lines, "dump");
	AppendLine(lines, "notes: matrices are printed in common column-major order");

	Heading(lines, "matrix basics");
	DumpMat4(lines, "identity", Mat44::sIdentity());
	DumpMat4(lines, "matrix_a", mat_a);
	DumpMat4(lines, "matrix_b", mat_b);

	Heading(lines, "matrix multiply");
	DumpMat4(lines, "matrix_a * matrix_b", mat_a * mat_b);
	DumpMat4(lines, "matrix_b * matrix_a", mat_b * mat_a);

	Heading(lines, "element access [row, col]");

	DumpScalar(lines, "transform[0, 0]", mat_a(0, 0));
	DumpScalar(lines, "transform[0, 1]", mat_a(0, 1));
	DumpScalar(lines, "transform[0, 2]", mat_a(0, 2));
	DumpScalar(lines, "transform[0, 3]", mat_a(0, 3));
	DumpScalar(lines, "transform[1, 0]", mat_a(1, 0));
	DumpScalar(lines, "transform[1, 1]", mat_a(1, 1));
	DumpScalar(lines, "transform[1, 2]", mat_a(1, 2));
	DumpScalar(lines, "transform[1, 3]", mat_a(1, 3));
	DumpScalar(lines, "transform[2, 0]", mat_a(2, 0));
	DumpScalar(lines, "transform[2, 1]", mat_a(2, 1));
	DumpScalar(lines, "transform[2, 2]", mat_a(2, 2));
	DumpScalar(lines, "transform[2, 3]", mat_a(2, 3));
	DumpScalar(lines, "transform[3, 0]", mat_a(3, 0));
	DumpScalar(lines, "transform[3, 1]", mat_a(3, 1));
	DumpScalar(lines, "transform[3, 2]", mat_a(3, 2));
	DumpScalar(lines, "transform[3, 3]", mat_a(3, 3));

	Heading(lines, "matrix constructors and composition");
	DumpMat4(lines, "scale", scale_m);
	DumpMat4(lines, "translate", translate_m);
	DumpMat4(lines, "rotate_x", rotate_x_m);
	DumpMat4(lines, "rotate_y", rotate_y_m);
	DumpMat4(lines, "rotate_z", rotate_z_m);
	DumpMat4(lines, "pure_rotation = rotate_z * rotate_y * rotate_x", pure_rotation_m);
	DumpMat4(lines, "transform = translate * rotate_z * rotate_y * rotate_x * scale", transform_m);

	Heading(lines, "matrix vector multiply");
	DumpVec3(lines, "vec3_input", vec_a);
	DumpVec4(lines, "vec4_input", vec_b);
	DumpVec3(lines, "transform * vec3", transform_m * vec_a);
	DumpVec4(lines, "transform * vec4", transform_m * vec_b);
	DumpVec3(lines, "rotate_z * vec3", rotate_z_m * vec_a);
	DumpVec3(lines, "translate * vec3", translate_m * vec_a);

	Heading(lines, "quaternion constructors");
	DumpQuat(lines, "quat_identity", Quat::sIdentity());
	DumpQuat(lines, "quat_rotate_x", quat_x);
	DumpQuat(lines, "quat_rotate_y", quat_y);
	DumpQuat(lines, "quat_rotate_z", quat_z);
	DumpVec3(lines, "axis_normalized", axis);
	DumpScalar(lines, "axis_angle_radians", axis_angle);
	DumpQuat(lines, "from_axis_angle", axis_quat);
	DumpMat4(lines, "from_axis_angle.mat4", axis_mat);

	Heading(lines, "quaternion multiply");
	DumpQuat(lines, "quat_x", quat_x);
	DumpQuat(lines, "quat_y", quat_y);
	DumpQuat(lines, "quat_z", quat_z);
	DumpQuat(lines, "quat_multiply(quat_x, quat_y)", quat_xy);
	DumpQuat(lines, "quat_multiply(quat_multiply(quat_x, quat_y), quat_z)", quat_xyz);
	DumpMat4(lines, "quat_xy.mat4", Mat44::sRotation(quat_xy));
	DumpMat4(lines, "quat_xyz.mat4", Mat44::sRotation(quat_xyz));

	Heading(lines, "quaternion vector rotate");
	DumpVec3(lines, "input", vec_a);
	DumpVec3(lines, "quat_rotate(quat_x, input)", quat_x * vec_a);
	DumpVec3(lines, "quat_rotate(quat_y, input)", quat_y * vec_a);
	DumpVec3(lines, "quat_rotate(quat_z, input)", quat_z * vec_a);
	DumpVec3(lines, "quat_rotate(from_axis_angle, input)", axis_quat * vec_a);
	DumpVec3(lines, "quat_z * input", quat_z * vec_a);

	Heading(lines, "matrix quaternion roundtrip");
	const Quat pure_rotation_quat = pure_rotation_m.GetQuaternion();
	DumpQuat(lines, "pure_rotation.quat", pure_rotation_quat);
	DumpMat4(lines, "pure_rotation", pure_rotation_m);
	DumpMat4(lines, "pure_rotation.quat.mat4", Mat44::sRotation(pure_rotation_quat));
	DumpMat4(lines, "transform.rotation_only", rotation_only_m);
	DumpQuat(lines, "transform.rotation_only.quat", rotation_only_m.GetQuaternion());
	const Quat axis_mat_quat = axis_mat.GetQuaternion();
	DumpQuat(lines, "axis_mat.quat", axis_mat_quat);
	DumpMat4(lines, "axis_mat.quat.mat4", Mat44::sRotation(axis_mat_quat));
	AppendLine(lines, "hard_decomp.note: 170 degrees around (1,-2,3) normalized - w near zero");
	DumpQuat(lines, "hard_decomp.quat_original", hard_quat);
	const Quat hard_mat_quat = hard_mat.GetQuaternion();
	DumpQuat(lines, "hard_decomp.quat_from_mat", hard_mat_quat);
	DumpMat4(lines, "hard_decomp.mat4", hard_mat);
	DumpMat4(lines, "hard_decomp.quat_from_mat.mat4", Mat44::sRotation(hard_mat_quat));

	Heading(lines, "lookAt matrix");
	AppendLine(lines, "notes: eye=(5,5,5), center=(0,0,0), up=(0,1,0)");
	DumpMat4(lines, "lookAt", Mat44::sLookAt(Vec3(5.0f, 5.0f, 5.0f), Vec3(0.0f, 0.0f, 0.0f), Vec3(0.0f, 1.0f, 0.0f)));

	Heading(lines, "euler angle decomposition");
	AppendLine(lines, "notes: euler angles as vec3(pitch/x, yaw/y, roll/z) in radians");
	DumpVec3(lines, "pure_rotation.quat.euler", pure_rotation_quat.GetEulerAngles());
	DumpVec3(lines, "from_axis_angle.euler", axis_quat.GetEulerAngles());

	Heading(lines, "matrix inverse");
	DumpMat4(lines, "transform.inverse", transform_m.Inversed());
	DumpMat4(lines, "pure_rotation.inverse", pure_rotation_m.Inversed());

	Heading(lines, "cross product");
	AppendLine(lines, "notes: cross(a, b) where a and b are vec3");
	DumpVec3(lines, "cross(x_axis, y_axis)", Vec3(1.0f, 0.0f, 0.0f).Cross(Vec3(0.0f, 1.0f, 0.0f)));
	DumpVec3(lines, "cross(y_axis, x_axis)", Vec3(0.0f, 1.0f, 0.0f).Cross(Vec3(1.0f, 0.0f, 0.0f)));
	const Vec3 cross_c = Vec3(1.0f, 2.0f, 3.0f).Normalized();
	const Vec3 cross_d = Vec3(-1.0f, 0.5f, 2.0f).Normalized();
	DumpVec3(lines, "cross(c, d)", cross_c.Cross(cross_d));

	Heading(lines, "slerp");
	AppendLine(lines, "notes: slerp(a, b, t) between quat_x and quat_z");
	DumpQuat(lines, "slerp(quat_x, quat_z, 0.25)", quat_x.SLERP(quat_z, 0.25f));
	DumpQuat(lines, "slerp(quat_x, quat_z, 0.5)", quat_x.SLERP(quat_z, 0.5f));
	DumpQuat(lines, "slerp(quat_x, quat_z, 0.75)", quat_x.SLERP(quat_z, 0.75f));

	Heading(lines, "fromTwoVectors");
	AppendLine(lines, "notes: quaternion that rotates vector a to vector b");
	const Vec3 ft_from_a(1.0f, 0.0f, 0.0f);
	const Vec3 ft_from_b(0.0f, 1.0f, 0.0f);
	const Vec3 ft_from_c = Vec3(1.0f, 2.0f, -1.0f).Normalized();
	const Vec3 ft_from_d = Vec3(-1.0f, 0.5f, 2.0f).Normalized();
	const Quat ft_qab = Quat::sFromTo(ft_from_a, ft_from_b);
	const Quat ft_qcd = Quat::sFromTo(ft_from_c, ft_from_d);
	DumpQuat(lines, "from_x_to_y", ft_qab);
	DumpQuat(lines, "from_c_to_d", ft_qcd);
	DumpVec3(lines, "verify_x_to_y", ft_qab * ft_from_a);
	DumpVec3(lines, "verify_c_to_d", ft_qcd * ft_from_c);

	Heading(lines, "quaternion inverse");
	const Quat axis_quat_inv = axis_quat.Inversed();
	DumpQuat(lines, "from_axis_angle.inverse", axis_quat_inv);
	DumpQuat(lines, "verify_q_mul_qinv", axis_quat * axis_quat_inv);

	Heading(lines, "quaternion to axis-angle");
	Vec3 aa_axis1;
	float aa_angle1 = 0.0f;
	axis_quat.GetAxisAngle(aa_axis1, aa_angle1);
	Vec3 aa_axis2;
	float aa_angle2 = 0.0f;
	quat_xyz.GetAxisAngle(aa_axis2, aa_angle2);
	DumpVec3(lines, "from_axis_angle.axis", aa_axis1);
	DumpScalar(lines, "from_axis_angle.angle", aa_angle1);
	DumpVec3(lines, "quat_xyz.axis", aa_axis2);
	DumpScalar(lines, "quat_xyz.angle", aa_angle2);

	Heading(lines, "perspective matrix");
	AppendLine(lines, "notes: fovy=60 degrees, aspect=1.5, near=0.1, far=100.0");
	DumpMat4(lines, "perspective", Mat44::sPerspective(60.0f * JPH_PI / 180.0f, 1.5f, 0.1f, 100.0f));

	Heading(lines, "ortho matrix");
	AppendLine(lines, "N/A");

	Heading(lines, "basis directions");
	AppendLine(lines, "N/A");

	std::ofstream out(output_path, std::ios::binary);
	for (size_t i = 0; i < lines.size(); ++i)
	{
		out << lines[i];
		if (i + 1 < lines.size())
			out << '\n';
	}
	out << '\n';

	std::cout << "Wrote " << output_path << "\n";
	return 0;
}
