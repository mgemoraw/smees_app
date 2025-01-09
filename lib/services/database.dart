import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/endPoints.dart';
import 'package:smees/depreciated/department.dart';
import 'package:smees/models/department.dart';
import 'package:smees/models/user.dart';

Future getAllDepartments() async {
  final url = Uri.parse("http://localhost:8000/departments/index?limit=10");
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

// Future fetch_users() async {
//   final url = Uri.parse("http://localhost:8000/users/index");
//   // final url = Uri.parse('http://10.161.70.104:8000/users/index');
//   var response = await http.get(url);
//   var users = [];
//   for (var u in jsonDecode(response.body)) {
//     users.add(User(u['id'], u['name'], u['email'], u['password']));
//   }
//   print(response.body);
//   // print("users: $users");
//   return users;
// }
