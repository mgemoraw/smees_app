import 'package:flutter_dotenv/flutter_dotenv.dart';

// final SMEES_APP_VERSION = dotenv.env['SMEES_APP_VERSION'];
String SMEES_APP_VERSION = "1.0.1";

final API_BASE_URL = dotenv.env["API_BASE_URL"];
const loginApi = "auth/users/login";
const tokenApi = "auth/token";
const questionsApi = "questions/index";
const getDepartmentsApi = "departments/index";
const usersGetAllApi = "users/index";
const studentAnswersApi = "tests/student-response";
const examStartApi = "tests/exam/start";
const testsGetAllApi = "tests/index";
