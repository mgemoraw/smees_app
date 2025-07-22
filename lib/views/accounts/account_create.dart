import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:smees/dropdowns.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/api/end_points.dart';

class AccountCreate extends StatefulWidget {
  const AccountCreate({super.key});

  @override
  State<AccountCreate> createState() => _AccountCreateState();
}

class _AccountCreateState extends State<AccountCreate> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController universityController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  bool isRegistered = false;
  String message = "";

  int? selectedDepartmentId;
  int? selectedUniversityId;

  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> universities = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    try {
      final departmentRes = await http.get(Uri.parse
        ('$API_BASE_URL/departments/index'));

      final universityRes = await http.get(Uri.parse
        ('$API_BASE_URL/universities/index'));

      if (departmentRes.statusCode == 200 && universityRes.statusCode==200) {
        setState(() {
          final List<dynamic> depData = jsonDecode(departmentRes.body);
          final List<dynamic> unData = jsonDecode(universityRes.body);

          departments = List<Map<String,dynamic>>.from(depData);
          universities = List<Map<String,dynamic>>.from(unData);
          isLoading = false;
        });
        print(departments);
        print(universities);
      } else {
        throw Exception("Failed to laod data");
      }
    } catch(e) {
      debugPrint("Error loading dropdown data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmeesAppbar(title: "SMEES - App"),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Student Registeration Form",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(
                            hintText: "Full name",
                          ),
                          validator: (value) => value!.isEmpty ? "Required" :
                          null,
                        ),

                        TextFormField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            hintText: "User name / User ID",
                          ),
                          validator: (value) => value!.isEmpty ? "Required" :
                          null,
                        ),

                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                          ),
                          validator: (value) => value!.isEmpty ? "Required" :
                          null,
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField(
                          isExpanded: true,
                          value: selectedDepartmentId,
                          items: departments.map<DropdownMenuItem<int>>(
                                  (item)=>
                              DropdownMenuItem<int>(
                              value: item['id'],
                                child: Text(
                                  item['name'],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ))
                              .toList(),
                          onChanged: (int? value) {
                            setState(() {
                              selectedDepartmentId = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Select Department",
                          ),
                          validator: (value) => value== null ? "Please select "
                              "department" : null,
                          ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField(
                          isExpanded: true,
                          value: selectedUniversityId,
                          items: universities.map((item)=> DropdownMenuItem
                          <int>(value: item['id'],
                              child: Text(
                                  item['name'],
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                              ),
                          )).toList(),
                          onChanged: (int? value) {
                            setState(() {
                              selectedUniversityId = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Select University",
                          ),
                          validator: (value) => value== null ? "Please select "
                              "University" : null,
                        ),

                        SizedBox(height: 12,),

                        Container(
                          height: 120,
                          child: Markdown(
                          data: """
            **Note that Password should include:**
            - atleat 8 characters in length
            - atlease on Capslock letter
            - at least one small letter
            - at least one symbol character
            """
                        ),),
                        TextFormField(
                          controller: password1Controller,
                          obscureText: true,
                          decoration:
                          const InputDecoration(hintText: "Enter Password"),
                          validator: (value) =>
                          value!.length < 8 ? "Password too short" : null,
                        ),
                        TextFormField(
                          controller: password2Controller,
                          obscureText: true,
                          decoration:
                          const InputDecoration(hintText: "Confirm Password"),
                          validator: (value) {
                            if (value != password1Controller.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children: [
                          TextButton(
                          onPressed: () async {
                            await registerUser();

                          },
                          child: Text("Register", style: TextStyle(fontSize: 18,)),),

                          TextButton(
                          onPressed: () => Navigator.pop(context), //backToLogin,
                          child: Text("Back to Login", style: TextStyle(fontSize: 18,)),),
                        ])
                      ],
                    ),
                  ),
          )),
    );
  }

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        final url = Uri.parse('${API_BASE_URL}/$registerApi');
        final headers = {"Content-Type": "application/json"};
        final body = jsonEncode({
          "full_name": fullNameController.text.trim(),
          "user_id": usernameController.text.trim(),
          "email": emailController.text.trim(),
          "password": password1Controller.text.trim(),
          "department_id": selectedDepartmentId,
          "university_id": selectedUniversityId,
          "department": "",
          "username": usernameController.text.trim(),
          "role": "student",
        });


        final response = await http.post(url, headers: headers, body: body);

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Registration successful"),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content:
              Text("Registration failed: ${response.body.toString()}"),
            ),
          );
        }
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Error: $err"),
          ),
        );
      }
    }
  }


  void backToLogin()  {
    //
    Navigator.pop(context);

  }
}