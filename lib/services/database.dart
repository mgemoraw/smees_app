import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/endPoints.dart';
import 'package:smees/models/user.dart';

Future<String> loginUser(UserLogin user) async {
  late String? message = "";
  // final url = Uri.parse('http://localhost:8000/$loginApi');
  final url = Uri.parse('http://10.161.70.179:8000/$loginApi');
  // final headers = {"Content-Type": "application/x-www-form-urlencoded"};
  final headers = {"Content-Type": "application/json"};
  final body = jsonEncode({
    'username': user.username,
    'password': user.password,
  });

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

      message = "Error ${response.statusCode}, ${response.body}";
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

Future getDepartments() async {
  final url = Uri.parse("http://10.161.70.179:8000/departments/index");
  var response = await http.get(url);

  // var deps = [];
  // for (var d in jsonDecode(response.body)) {
  //   deps.add(d);
  // }
  // return deps.toString();
  return response.body;
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
