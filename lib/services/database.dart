import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/end_points.dart';

import 'package:smees/models/department.dart';
import 'package:smees/models/user.dart';

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

Future fetchQuizQuestions({int year = 2024, int limit = 100}) async {
  //
}

Future fetchUsers() async {
  final url = Uri.parse("$apiUrl/$usersGetAllApi");
  // final url = Uri.parse('http://10.161.70.104:8000/users/index');
  var response = await http.get(url);
  var users = [];
  for (var u in jsonDecode(response.body)) {
    // users.add(User(u['id'], u['name'], u['email'], u['password']));
  }
  print(response.body);
  // print("users: $users");
  return users;
}
