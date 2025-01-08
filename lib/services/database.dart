import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> loginUser(String userId, String password) async {
  late String? message = null;
  final url = Uri.parse(
      'http://localhost:8000/auth/users/login'); // Replace with your endpoint
  final headers = {"Content-Type": "application/x-www-form-urlencoded"};
  final body = jsonEncode({
    "userId": userId,
    "password": password,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final token = data['access_token'];
      print(token);

      // Save token to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);
      await prefs.setString("role", data['role']);

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
      message = "Invalid email or password";
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
