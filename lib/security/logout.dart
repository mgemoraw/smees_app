import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('smees-token', "");
  await prefs.setString("smees-role", "");
  await prefs.setString("smees-user", "");
}

Future<bool> isAuthenticated() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("smees-token");

  if (token == null) {
    return false;
  }
  return true;
}
