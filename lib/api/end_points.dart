import 'package:flutter_dotenv/flutter_dotenv.dart';

final API_BASE_URL = dotenv.env["API_BASE_URL"];
const loginApi = "auth/users/login";
const tokenApi = "auth/token";
const questionsApi = "questions/index";
const getDepartmentsApi = "departments/index";
const usersGetAllApi = "users/index";
