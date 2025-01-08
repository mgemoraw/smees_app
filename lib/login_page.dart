// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/home.dart';
import 'package:smees/home_page.dart';
import 'package:smees/models/user.dart';
import 'package:smees/services/database.dart';
import 'package:smees/views/readme.dart';

var files = {
  "Automotive Engineering": "AutomotiveEngineering",
  "Industrial Engineering": "IndustrialEngineering",
  "Mechanical Engineering": "MechanicalEngineering",
  "Civil Engineering": "CivilEngineering",
  'Water Resources and Irrigation Engineering': "wrie",
  'Hydraulic and Water Resources Engineering': "hwre",
  "Chemical Engineering": "ChemicalEngineering",
  "Food Engineering": "FoodEngineering",
  "Human Nutrition": "HumanNutrition",
  "Electrical Engineering": "ElectricalEngineering",
  "Computer Engineering": "ComputerEngineering",
  "Computer Science": "ComputerScience",
  "Software Engineering": "SoftwareEngineering",
};

// login class
class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final departmentController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  var department = "";

  @override
  void dispose() {
    super.dispose();
    departmentController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  List<DropdownMenuItem<String>> getDepartments() {
    //
    List<DropdownMenuItem<String>> departments = [];
    for (String key in files.keys) {
      var menuItem = DropdownMenuItem(value: files[key], child: Text(key));
      departments.add(menuItem);
    }
    return departments;
  }

  Future<String?> getToken(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
        key); // Use appropriate methods like getInt, getBool, etc. based on the data type
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/graduation.png', height: 100),
                    Text("BiT-ExitE"),
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
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('BiT ExitE'),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
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
              ];
            }),
          ],
        ),
        // backgroundColor: Colors.redAccent[700],
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Welcome to Your key to exit exam success!',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 15, fontWeight: FontWeight.w400,
                    ),
                  ),

                  Text(description),
                  // Markdown(
                  //     data: description,
                  //    selectable: false,
                  //   ),

                  const Text("Please Choose your Field of Study to Continue",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      )),
                  const University(),

                  TextField(
                    controller: usernameController,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        hintText: 'User ID'),
                  ),
                  TextField(
                    controller: passwordController,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: 'Password',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      late UserLogin user = UserLogin(
                          username: usernameController.text,
                          password: passwordController.text);

                      var dd = getDepartments().toList();
                      print("deps: ${dd}");
                      print(
                          "Username: ${user.username}, password: ${user.password}");
                      // String message = await loginUser(user);

                      // Save token to local storage
                      final prefs = await SharedPreferences.getInstance();
                      String? token = prefs.getString("authToken");
                      // print(message);
                      print("token: $token");

                      // print(departmentController.text);
                      // if (usernameController.text == "user" &&
                      //     passwordController.text == "sgetme") {
                      //   Navigator.pushNamed(context, "/home");
                      // }
                    },
                    child: const Text('Login',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    title: const Text('Forgot Password?',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class University extends StatefulWidget {
  const University({super.key});

  @override
  State<University> createState() => _UniversityState();
}

class _UniversityState extends State<University> {
  var items = [
    'Civil Engineering',
    'Water Resources and Irrigation Engineering',
    'Hydraulic and Water Resources Engineering',
    'Computer Science',
    'Software Engineering',
    'Computer Engineering',
    'Electrical Engineering',
    'Food Engineering',
    'Chemical Engineering',
    'Human Nutrition',
    'Automotive Engineering',
    'Mechanical Engineering',
    'Industrial Engineering',
  ];

  String file_path = "CivilEngineering";
  String? department;

  final TextEditingController universityController = TextEditingController();
  String university = 'Civil Engineering';
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      leadingIcon: Icon(Icons.school),
      hintText: 'Select Field of Study',
      initialSelection: 'Civil Engineering',
      expandedInsets: const EdgeInsets.all(1.0),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        fillColor: Colors.amber,
      ),
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      controller: universityController,
      dropdownMenuEntries: items
          .map<DropdownMenuEntry<String>>(
              (String value) => DropdownMenuEntry<String>(
                    value: value,
                    label: value,
                  ))
          .toList(),
      onSelected: (String? value) {
        setState(() {
          index++;
          university = items[index];
        });
      },
    );
  }
}
