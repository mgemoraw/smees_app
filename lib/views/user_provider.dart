import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void login() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
class UserProvider extends ChangeNotifier {
  String departmentName;

  UserProvider({this.departmentName = "Guest Department"});

  // bool get offlineMode => null;

  void changeDepartmentName({
    required String newDepartmentName,
  }) async {
    departmentName = newDepartmentName;
    notifyListeners();
  }
}

class UseModeProvider extends ChangeNotifier {
  bool _offlineMode = false;

  bool get offlineMode => _offlineMode;

  // UseModeProvider({this.offlineMode = false});

  void changeUseMode() async {
    _offlineMode = !_offlineMode;
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  void changeTheme() async {
    _isDark = !_isDark;
    notifyListeners();
  }
}

