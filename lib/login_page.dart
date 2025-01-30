// import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/api/end_points.dart';
import 'package:smees/home.dart';
import 'package:smees/home_page.dart';
import 'package:smees/models/database.dart';
import 'package:smees/models/user.dart';
import 'package:smees/security/login.dart';
import 'package:smees/security/logout.dart';
import 'package:smees/services/database.dart';
import 'package:smees/user_profile.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/drawer.dart';
import 'package:smees/views/readme.dart';
import 'package:smees/views/user_provider.dart';
import "package:http/http.dart" as http;

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
  String? _token;
  String? _username;
  String? _role;
  String? userDepartment;
  bool isLoading = false;
  var department = "";
  bool _isObscure = true;
  User? _user;
  late String? _message = "";

  @override
  void dispose() {
    super.dispose();
    departmentController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  initState() {
    super.initState();
    // _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('smees-user');
    if (jsonString != null) {
      Map<String, dynamic> userData = jsonDecode(jsonString);
      setState(() {
        // print(jsonString);
        _username = userData['username'];
        _token = userData['token'];
        _role = userData['role'];
        userDepartment = userData['department'];
      });
    }
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
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        // drawer: LeftNavigation(),
        appBar: AppBar(
          leading: Icon(Icons.school),
          title: const Text("SMEES"),
          backgroundColor: Colors.blue,
        ),
        // backgroundColor: Colors.redAccent[700],
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(50.0),
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
                    const SizedBox(height: 20.0),
                    const University(),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: usernameController,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                      decoration: InputDecoration(
                          error: usernameController.text.isEmpty
                              ? Text("Username Required")
                              : null,
                          prefixIcon: const Icon(Icons.person_2_outlined),
                          hintText: 'User ID'),
                    ),
                    const SizedBox(height: 16.0),

                    TextField(
                      controller: passwordController,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          error: passwordController.text.isEmpty
                              ? Text("Password can't be Empty")
                              : null,
                          prefixIcon: Icon(Icons.password),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (usernameController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            return null;
                          } else {
                            //
                          }
                          // final message = await loginUser(userLogin);
                          await _loginUser(
                            usernameController.text,
                            passwordController.text,
                          );

                          if (_user != null) {
                            setState(() {
                              // set global user state
                              userProvider.setUser(newUser: _user!);
                              // insert user data to local db
                              SmeesHelper().addUser(_user!.toMap());
                            });
                          }

                          if (_token != null && _role != 'null') {
                            Navigator.pushNamed(context, "/");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.deepOrange,
                                content: Text("$_message"),
                              ),
                            );
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/");
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

  Future<void> _loginUser(String username, String password) async {
    var apiUrl = dotenv.env["API_BASE_URL"];

    late String? message = "";
    final url = Uri.parse('$apiUrl/$tokenApi');
    // final url = Uri.parse('$apiUrl/$loginApi');

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    // final headers = {"Content-Type": "application/json"};

    final body = {
      'username': username,
      'password': password,
    };
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final token = data['access_token'];
        final role = data['role'];
        // final username = data['username'];
        final departmentId = data['department_id'];
        final department = data['department'];

        String smeesUser = jsonEncode({
          'username': username,
          'token': token,
          'role': role,
          'departmentId': departmentId,
          'department': department,
        });

        // Save token to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('smees-user', smeesUser);

        // message = response.body;

        setState(() {
          _token = token;
          _role = role;
          _message = null;

          _user = User(
            username: username,
            password: token,
            email: null,
            fname: null,
            mname: null,
            university: "Bahir Dar University",
            department: department,
          );
        });
      } else {
        message = response.body;
        setState(() {
          _message = "Invalid Username or Password";
        });
      }
    } on http.ClientException catch (_, err) {
      setState(() {
        _message = "Network Error! Please Check your Internet Connection";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    'Water Resources fluand Irrigation Engineering',
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
