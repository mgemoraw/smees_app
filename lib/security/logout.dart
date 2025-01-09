import 'package:shared_preferences/shared_preferences.dart';

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('smees-token', "");
  await prefs.setString("smees-role", "");
  await prefs.setString("smees-user", "");
}
