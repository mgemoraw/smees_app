import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../views/user_provider.dart';

class LogoutService {
  static final _secureStorage = FlutterSecureStorage();

  /// Logs the user out by clearing all local and secure storage data.
  static Future<void> logout(BuildContext context) async {
    try {
      // Clear SharedPreferences (non-sensitive data)
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("smees-user");

      // Clear SecureStorage (sensitive data like tokens)
      await _secureStorage.delete(key: 'smees-token');

      //  set user provider to null
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.clearUser();

      debugPrint('✅ User successfully logged out. All data cleared.');
    } catch (e) {
      debugPrint('❌ Error during logout: $e');
    }
  }
}
