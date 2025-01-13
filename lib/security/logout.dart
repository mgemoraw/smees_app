import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('smees-user', "");
}

Future<bool> isAuthenticated() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString("smees-user");
  final userData = jsonDecode(jsonString!);
  String? token = userData['token'];

  if (token == null) {
    return false;
  }
  return true;
}
