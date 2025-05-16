import "package:flutter/material.dart";
import "package:flutter_markdown/flutter_markdown.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/security/logout.dart";
import "package:smees/views/user_provider.dart";
import 'package:smees/api/end_points.dart';

// setting app version
const SMEES_APP_VERSION  = "2025.04.1";
class LeftNavigation extends StatefulWidget {
  const LeftNavigation({super.key});

  @override
  State<LeftNavigation> createState() => _LeftNavigationState();
}

class _LeftNavigationState extends State<LeftNavigation> {
  late bool userLoggedIn = false;
  bool isOnline = false;
  bool isDark = false;
  Color bgColor = const Color.fromARGB(31, 24, 1, 1);
  static const developers = [
    {
      "name": "Mengistu Getie",
      "email": "mengistu.getie@bdu.edu.et",
    },
    {
      "name": "Tadele Yigrem",
      "email": "tadele.yigrem@bdu.edu.et",
    }
  ];
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final useModeProvider = Provider.of<UseModeProvider>(context);

    return Drawer(
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
                Image.asset('assets/images/bdu_logo.png', height: 60),
                // Text("BiT (SEMS)-App"
                //     "$SMEES_APP_VERSION"),
                ListTile(
                  title: Text("BiT SEMS App"
                      "-App"),
                  subtitle: Text("Release Version: $SMEES_APP_VERSION"),
                ),
              ],
            ),
          ),
          ExpansionTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            children: [
              ListTile(
                leading: !useModeProvider.offlineMode
                    ? const Icon(Icons.online_prediction)
                    : const Icon(Icons.network_locked),
                title: const Text('Network Mode'),
                onTap: () {
                  // Navigator.pushNamed(context, "/settings");
                },
                trailing: Switch(
                    value: !useModeProvider.offlineMode,
                    onChanged: (value) {
                      setState(() {
                        // change offlineMode state
                        context.read<UseModeProvider>().changeUseMode();
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        //   backgroundColor: Colors.redAccent,
                        //   content: Text("This feature is not available in "
                        //       "this version of the app"),
                        // ));
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blue,
                        content: useModeProvider.offlineMode
                            ? Text("Offline Mode")
                            : Text("Online Mode"),
                      ));
                    }),
                subtitle:
                    Text(useModeProvider.offlineMode ? "Offline" : "Online"),
              ),
              ListTile(
                leading: themeProvider.isDark
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.light_mode),
                title: const Text("Theme"),
                trailing: Switch(
                    value: themeProvider.isDark,
                    onChanged: (value) {
                      setState(() {
                        themeProvider.changeTheme();
                      });
                    }),
                subtitle: Text(themeProvider.isDark ? "Dark" : "Light"),
              ),
            ],
          ),
          ExpansionTile(
              title: Text("About App"),
              leading: Icon(Icons.info),
              children: [
                ListTile(
                  // leading: Icon(Icons.info),

                  onTap: () {},
                  title: Column(
                    children: [
                      ListTile(
                        title: RichText(
                          softWrap: true,
                          text: const TextSpan(
                            text:
                                "This Bahir Dar Institute of Technology's "
                                    "Student Model Exist Exam Practice "
                                    "Application is developed by Mengistu "
                                    "Getie & Tadele Yigrem. It is submitted "
                                    "to Bahir Dar Institute of Technology as "
                                    "TT project to support BiT Students "
                                    "practice and gain knowledge from model "
                                    "exam questions. Mr. Tadele Yigrem has "
                                    "made a great contribution starting from "
                                    "initiating the project up to data "
                                    "collection and processing. The "
                                    "source code is written by "
                                    "Mengistu Getie. Bahir Dar "
                                    "Institute of Technology, BiT has given "
                                    "its ultimate support and finance which "
                                    "helped us in covering data collection, "
                                    "testing and deployment related costs. "
                                    "please reach us through our contact mail "
                                    "for support and feedbacks",
                            style: TextStyle(color: Colors.blue, overflow:
                            TextOverflow.fade ),
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Contact us on: mengist.dev@gmail"
                              ".com"),
                        )),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: const Text('Send Us feedback'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/feedback");
                  },
                ),
              ]),
          const LoginLogout(),
        ],
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
    bool loggedIn = await isAuthenticated();
    setState(() {
      isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoggedIn
          ? ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                setState(() {
                  Navigator.pushNamed(context, "/login");
                });
              },
            )
          : ListTile(
              leading: Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                logout();
                setState(() {
                  Navigator.pushNamed(context, "/login");
                });
              },
            ),
    );
  }
}
