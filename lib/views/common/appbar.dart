import "package:flutter/material.dart";
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
  bool userLoggedIn = false;

  // @override
  // void initState() {
  //   super.initState();
  //   checkAuthentication();
  // }

  void checkAuthentication() {
    setState(() async {
      userLoggedIn = await isAuthenticated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: Text(widget.title),
      actions: [
        PopupMenuButton(
            itemBuilder: (context) => [
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
                          logout();
                          // Navigator.pop(context);
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
