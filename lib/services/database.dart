import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/endPoints.dart';
import 'package:smees/depreciated/department.dart';
import 'package:smees/models/department.dart';
import 'package:smees/models/user.dart';

Future loginUser(UserLogin user) async {
  late String? message = "";
  final url = Uri.parse('http://localhost:8000/$tokenApi');
  // final url = Uri.parse('http://localhost:8000/$loginApi');

  final headers = {'Content-Type': 'application/X-WWW-form-urlencoded'};
  // final headers = {"Content-Type": "application/json"};

  final body = {
    'username': user.username,
    'password': user.password,
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data['access_token'];
      final role = data['role'];

      // Save token to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      await prefs.setString("role", role);

      // Navigate to the home screen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
      message = response.body;
    } else {
      // Show error message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Invalid email or password")),
      // );

      message = "${response.statusCode}, ${response.body}";
    }
  } catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Error: $e")),
    // );
    message = "Error: $e";
  }
  // finally {
  // setState(() {
  //   isLoading = false;
  // });
  // message = "done";
  // }

  return message;
}

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
