import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/models/user.dart";
import "package:smees/security/logout.dart";

class SmeesAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  SmeesAppbar({super.key, required this.title, this.actions});

  @override
  State<SmeesAppbar> createState() => _SmeesAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SmeesAppbarState extends State<SmeesAppbar> {
  bool isLoggedIn = false;
  User? user;
  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("smees-token");
    final username = prefs.getString("smees-user");
    final department = prefs.getString("smees-user-department");

    setState(() {
      if (token != null) {
        isLoggedIn = !isLoggedIn;
        user = User(
            userId: username,
            univesity: null,
            department: department,
            password: null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        PopupMenuButton(
            itemBuilder: (context) => isLoggedIn
                ? [
                    PopupMenuItem(
                      child: TextButton(
                        child: Text("About Us"),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () {
                          setState(() {
                            // logout();
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/");
                          });
                        },
                      ),
                    )
                  ]
                : [
                    PopupMenuItem(
                      child: TextButton(
                        child: Text("About Us"),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          setState(() {
                            // logout();
                            Navigator.pop(context);
                            Navigator.pushNamed(context, "/");
                          });
                        },
                      ),
                    )
                  ]),
      ],
    );
  }
}
