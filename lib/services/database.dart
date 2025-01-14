import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/end_points.dart';

import 'package:smees/models/department.dart';
import 'package:smees/models/user.dart';

var apiUrl = dotenv.env["API_BASE_URL"];
// var apiKey = dotenv.env['API_KEY'];

Future getAllDepartments({int limit = 0}) async {
  final url = Uri.parse("$apiUrl/$getDepartmentsApi?$limit");
  var message = "";
  try {
    var response = await http.get(url);
    message = "data: ${response.body}";
    var deps = [];
    for (var d in jsonDecode(response.body)) {
      deps.add(DepartmentModel(name: d['name'], description: d['description']));
    }

    return message;
    // return deps;
  } catch (e) {
    message = "Error: $e";
  }

  print(message);
  return message;
}

Future<Map<String, dynamic>> loadUserData() async {
  // get user department
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString("smees-user");

  if (jsonString != null) {
    Map<String, dynamic> userData = jsonDecode(jsonString!);
    return userData;
  }
  return {};
}

Future fetchQuizQuestions({int year = 2024, int limit = 100}) async {
  // get user department
  final userData = await loadUserData();
  int departmentId = userData['departmentId'];
  if (userData.isEmpty) {
    return [];
  }
  final url = Uri.parse("$apiUrl/questions$departmentId/index?$limit");
  Map<String, String> headers = {
    'Authorization': "Bearer ${userData['token']}",
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  try {
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (err) {
    return {"Error": err};
  }
}

Future fetchUsers() async {
  final url = Uri.parse("$apiUrl/$usersGetAllApi");

  var response = await http.get(url);
  var users = [];
  for (var u in jsonDecode(response.body)) {
    // users.add(User(u['id'], u['name'], u['email'], u['password']));
  }
  print(response.body);
  // print("users: $users");
  return users;
}
