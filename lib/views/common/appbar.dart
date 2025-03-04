import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/login_page.dart";
import "package:smees/models/user.dart";
import "package:smees/security/logout.dart";
import "package:smees/views/user_provider.dart";

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

  User? user;
  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  bool isLoggedIn() {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user.username != null){
      return true;
    }
    return false;
  }
  Future<void> _checkUserAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("smees-token");
    final username = prefs.getString("smees-user");
    final department = prefs.getString("smees-user-department");

    setState(() {
      if (token != null) {
        // isLoggedIn = !isLoggedIn;
        user = User(
          username: username,
          university: null,
          department: department,
        );
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
            itemBuilder: (context) =>
                [
                    PopupMenuItem(
                      child: TextButton(
                        child: Text("About Us"),
                        onPressed: () {},
                      ),
                    ),
                  PopupMenuItem(
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, "/settings");
                      },
                    ),
                  ),
                    PopupMenuItem(
                      child: IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () {
                          setState(() {
                            // logout();
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, "/login");
                          });
                        },
                      ),
                    )
                  ]
                 // [
                 //    PopupMenuItem(
                 //      child: TextButton(
                 //        child: Text("About Us"),
                 //        onPressed: () {},
                 //      ),
                 //    ),

                 //    PopupMenuItem(
                 //      child: IconButton(
                 //        onPressed: () {
                 //          logout();
                 //          Navigator.pushNamed(context, "/");
                 //          // Navigator.of(context).pushAndRemoveUntil(
                 //          //   MaterialPageRoute(builder: (context) => Login()),
                 //          //   (Route<dynamic>route=>false),
                 //          // );
                 //        },
                 //        icon: Icon(Icons.logout),
                 //      ),
                 //    ),
                 //  ],
            ),

      ],
    );
  }
}
