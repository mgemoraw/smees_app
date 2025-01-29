import 'package:flutter/material.dart';
import 'package:smees/models/user.dart';


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
  User? user;

  UserProvider({this.user = null});

  // bool get offlineMode => null;

  void changeUser({
    required User newUser,
  }) async {
    user = newUser;
    notifyListeners();
  }
}

class UseModeProvider extends ChangeNotifier {
  bool _offlineMode = true;

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

class NavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}