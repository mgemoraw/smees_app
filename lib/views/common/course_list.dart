import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/end_points.dart';
import 'package:smees/models/user.dart';


Future <List<Map<String, dynamic>>> getCoursesList() async {

  List<Map<String, dynamic>> data = [];

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userString = prefs.getString('smees-user');
  final userData = jsonDecode(userString!);
  User user = User.fromMap(userData);
  String token = userData['token'];

  final headers = {
    'Authentication': 'Bearer $token',
  };
  final url = Uri.parse("${API_BASE_URL}${getAllCourses}/${user.department}");

  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
    return data;
  } catch (err){
    // print debug message
  }

  return data;
}