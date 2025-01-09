import "package:flutter/material.dart";

class LeftNavigation extends StatefulWidget {
  const LeftNavigation({super.key});

  @override
  State<LeftNavigation> createState() => _LeftNavigationState();
}

class _LeftNavigationState extends State<LeftNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/atom.png', height: 100),
                  const Text("SMEES-Aapp"),
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
              leading: Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
