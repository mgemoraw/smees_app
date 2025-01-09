import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/endPoints.dart';
import 'package:smees/models/user.dart';

Future<void> loginUser(UserLogin user) async {
  late String? message = "";
  // final url = Uri.parse('http://localhost:8000/$tokenApi');
  final url = Uri.parse('http://169.254.130.149:8000/$tokenApi');

  final headers = {'Content-Type': 'application/X-WWW-form-urlencoded'};
  // final headers = {"Content-Type": "application/json"};

  final body = {
    'username': user.username,
    'password': user.password,
  };

  try {
    var http;
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data['access_token'];
      final role = data['role'];
      final username = data['username'];

      // Save token to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('smees-token', token);
      await prefs.setString("smees-role", role);
      await prefs.setString("smees-user", username);

      // message = response.body;
    } else {
      // Show error message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Invalid email or password")),
      // );

      message = response.body;
    }
  } catch (e) {
    message = "Error: $e";
  }
  // finally {
  // setState(() {
  //   isLoading = false;
  // });
  // message = "done";
  // }

  // return message;
}
