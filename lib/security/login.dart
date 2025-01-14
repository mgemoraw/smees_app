import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smees/api/end_points.dart';
import 'package:smees/models/user.dart';
import "package:http/http.dart" as http;
import 'package:smees/services/database.dart';

var apiUrl = dotenv.env["API_BASE_URL"];
Future loginUser(UserLogin user) async {
  late String? message = "";
  final url = Uri.parse('$apiUrl/$tokenApi');
  // final url = Uri.parse('$apiUrl/$loginApi');

  final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
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
      final username = data['username'];
      final departmentId = data['department_id'];
      final department = data['department'];

      String smeesUser = jsonEncode({
        'username': username,
        'token': token,
        'role': role,
        'departmentId': departmentId,
        'department': department,
      });

      // Save token to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('smees-user', smeesUser);

      message = response.body;
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

  return message;
}
