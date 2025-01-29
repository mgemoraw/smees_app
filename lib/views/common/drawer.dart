import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:smees/security/logout.dart";
import "package:smees/views/user_provider.dart";

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
    {"name": "Mengistu Getie", "email": "mengistu.getie@bdu.edu.et",},
    {"name": "Tadele Yigrem", "email": "tadele.yigrem@bdu.edu.et",}
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
            ExpansionTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              children: [
                ListTile(
                leading: !useModeProvider.offlineMode ? const Icon(Icons.online_prediction) : const Icon(Icons.network_locked),
                title: const Text('Network Mode'),
                onTap: () {
                  // Navigator.pushNamed(context, "/settings");
                  },

                trailing: Switch(value: !useModeProvider.offlineMode, onChanged: (value) {
                  setState(() {
                    // change offlineMode state
                    context.read<UseModeProvider>().changeUseMode();
                              
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blue,
                      
                      content: useModeProvider.offlineMode ? Text("Offline Mode") : Text("Online Mode"),
                    )
                  );
                }),
                subtitle: Text(useModeProvider.offlineMode ? "Offline": "Online"),

                ),
                ListTile(
                  leading: themeProvider.isDark ? const Icon(Icons.dark_mode) : const Icon(Icons.light_mode),
                  title: const Text("Theme"),
                  trailing: Switch(
                    value: themeProvider.isDark, 
                    onChanged: (value){
                  setState((){
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
              children:[
                ListTile(
                // leading: Icon(Icons.info),
                
                onTap: () {},
                title: Column(
                  children: [
                    ListTile(title: RichText(
                      softWrap: true,
                      text: const TextSpan(
                        text: "This app is developed by Mengistu Getie & Tadele Yigrem in Collaboration with Bahir Dar Institute of Technology as TT project to support BiT Students practice and gain knowledge from model exam questions. Mr. Tadele Yigrem has a great contribution starting from initiating the project up to data collection and processing. Bahir Dar Institute of Technology, BiT has given its ultimate support and finance which helped us in covering data collection, testing and deployment related costs. please contact us for support and feedbacks",
                        style: TextStyle(color: Colors.blue),),
                      ),
                      subtitle: TextButton(onPressed: (){
                        // contact mail
                        print("contact mail send");
                      }, child: Text("Contact Us")),
                    ),
                    
                  ],
                ),
              ),
              ListTile(
              leading: Icon(Icons.feedback),
              title: const Text('Send Us feedback'),
              onTap: () {},
            ),
              ] 
            ),
            const LoginLogout(),
            
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
    setState(() async {
      isLoggedIn = await isAuthenticated();
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
                  Navigator.pushNamed(context, "/login");
                });
              },
            )
          : ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
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
