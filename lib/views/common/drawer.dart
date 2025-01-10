import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/security/logout.dart";

class LeftNavigation extends StatefulWidget {
  const LeftNavigation({super.key});

  @override
  State<LeftNavigation> createState() => _LeftNavigationState();
}

class _LeftNavigationState extends State<LeftNavigation> {
  late bool userLoggedIn = false;
  bool isDark = false;
  Color bgColor = const Color.fromARGB(31, 24, 1, 1);

  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("smees-token");
    setState(() {
      if (token != null) {
        userLoggedIn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        shadowColor: bgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/profile.png', height: 100),
                  const Text("SMEES-App"),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: const Text('Send Us feedback'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {},
            ),
            const LoginLogout(),
            Switch(
                value: isDark,
                onChanged: (value) {
                  // switch between ligh and dark theme
                  setState(() {
                    isDark = !isDark;
                    bgColor = Colors.black;
                  });
                }),
          ],
        ),
      ),
    );
  }
}

class LoginLogout extends StatefulWidget {
  const LoginLogout({super.key});

  @override
  State<LoginLogout> createState() => _LoginLogoutState();
}

class _LoginLogoutState extends State<LoginLogout> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("smees-token");

    setState(() {
      if (token != null) {
        isLoggedIn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoggedIn
          ? ListTile(
              leading: Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, "/");
                });
              },
            )
          : ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                logout();
                setState(() {
                  Navigator.pushNamed(context, "/");
                });
              },
            ),
    );
  }
}
