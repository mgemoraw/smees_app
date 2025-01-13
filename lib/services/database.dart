import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smees/api/end_points.dart';

import 'package:smees/models/department.dart';
import 'package:smees/models/user.dart';

var apiUrl = dotenv.env['API_KEY'];
var BASE_URL = dotenv.env['BASE_URL'];

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

  var response = await http.get(url);
  var users = [];
  for (var u in jsonDecode(response.body)) {
    // users.add(User(u['id'], u['name'], u['email'], u['password']));
  }
  print(response.body);
  // print("users: $users");
  return users;
}
