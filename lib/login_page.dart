// import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/home.dart';
import 'package:smees/home_page.dart';
import 'package:smees/models/user.dart';
import 'package:smees/security/login.dart';
import 'package:smees/security/logout.dart';
import 'package:smees/services/database.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: LeftNavigation(),
        appBar: AppBar(title: Text("SMEES")),
        // backgroundColor: Colors.redAccent[700],
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text(description),
                    // Markdown(
                    //     data: description,
                    //    selectable: false,
                    //   ),

                    const Text("Welcome to SMEES Please Login to Continue",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    const University(),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                      controller: usernameController,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_2_outlined),
                          hintText: 'User ID'),
                    ),
                    SizedBox(
                      height: 16.0,
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
                    SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        late UserLogin user = UserLogin(
                            username: usernameController.text,
                            password: passwordController.text);

                        final message = await loginUser(user);
                        print(message);
                        // Save token to local storage
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString("smees-token");
                        final role = prefs.getString("smees-role");
                        final username = prefs.getString('smees-user');

                        // print(departmentController.text);
                        if (token != null && role == 'student') {
                          Navigator.pushNamed(context, "/home");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Text("Invalid email or password"),
                            ),
                          );
                        }
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
