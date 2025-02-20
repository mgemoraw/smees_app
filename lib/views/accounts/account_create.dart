import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:smees/views/common/appbar.dart';
import 'package:smees/api/end_points.dart';

class AccountCreate extends StatefulWidget {
  const AccountCreate({super.key});

  @override
  State<AccountCreate> createState() => _AccountCreateState();
}

class _AccountCreateState extends State<AccountCreate> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  bool isRegistered = false;
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmeesAppbar(title: "SMEES - App"),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
                  child: Column(
                    children: [
                      Text(
                        "User Registeration Form",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "User name / User ID",
                        ),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                        ),
                      ),
                      TextField(
                        controller: departmentController,
                        decoration: InputDecoration(
                          hintText: "Department",
                        ),
                      ),
                      Container(
                        height: 170,
                        child: Markdown(
                        data: """
**Note that Password should include:**
- atleat 8 characters in length
- atlease on Capslock letter
- at least one small letter
- at least one symbol character
"""
                      ),),
                      
                      TextField(
                        controller: password1Controller,
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                        ),
                      ),
                      TextField(
                        controller: password2Controller,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                        ),
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
                        onPressed: backToLogin, 
                        child: Text("Back to Login", style: TextStyle(fontSize: 18,)),),
                      ])
                    ],
                  ),
                )),
    );
  }

  Future <void> registerUser() async {
    String? username = usernameController.text.trim();
    String? email = emailController.text.trim();
    String? department = departmentController.text.trim();
    String? password1 = password1Controller.text.trim();
    String? password2 = password2Controller.text.trim();
    if (username.isEmpty || password1.isEmpty || password2.isEmpty ||
        department.isEmpty || password1.isEmpty || password2.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text("All Fields are required"),
        ),
      );
    }
    if (password1 != password2){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text("Passwords Do Not match"),
        ),
      );
    } else {

      // handle registration
      try {
        final url = Uri.parse('${API_BASE_URL}$registerApi');
      } catch (err) {
        setState(() {
          message = err.toString();
        });
      } 
    }
  }


  void backToLogin()  {
    //
    Navigator.pop(context);

  }
}