import 'package:flutter_dotenv/flutter_dotenv.dart';

// final SMEES_APP_VERSION = dotenv.env['SMEES_APP_VERSION'];
String bdu1 = "2025.04.1";

final API_BASE_URL = dotenv.env["API_BASE_URL"];
const registerApi = 'auth/users/register';
const loginApi = "auth/users/login";
const userUpdateApi = "auth/users/update";
const tokenApi = "auth/token";
const questionsApi = "questions/index";
// const questionsByDeptNameApi = "questions/index"

const getDepartmentsApi = "departments/index";
const usersGetAllApi = "users/index";

// change password
const changePasswordApi = "/auth/password/update";

// take test and exam api
const testsGetAllApi = "/tests/index";
const testStartApi = "/tests/start-test";
const testSubmitApi = "/tests/submit-test";
const studentAnswersApi = "/tests/student-response";
const getAllCourses = "/courses/index";