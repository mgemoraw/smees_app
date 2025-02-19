import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:smees/views/common/appbar.dart';

class AccountReset extends StatefulWidget {
  const AccountReset({super.key});

  @override
  State<AccountReset> createState() => _AccountResetState();
}

class _AccountResetState extends State<AccountReset> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  bool codeValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmeesAppbar(title: "SMEES - App"),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: !codeValid
              ? Center(
                  child: Column(
                    children: [
                      Text(
                        "Use your Email to reset your account",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Enter linked email address"),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            sendPasswordResetCode();
                          },
                          child: Text("Send Reset Code"),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: otpCodeController,
                        decoration: InputDecoration(
                          hintText: "Enter Code sent via your email",
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            await requestPasswordReset();
                          },
                          child: Text("Confirm Code"),
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    children: [
                      Text(
                        "Account Reset form",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 170,
                        child: Markdown(
                        data: """
**Note that Password should include**
- atleat 8 characters
- atlease on Capslock letter
- at least one small letter
- at least one symbol character
"""
                      ),),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: "User name / User ID",
                        ),
                      ),
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
                      TextButton(
                        onPressed: () async {
                          await resetPassword();
                          
                        },
                        child: Text("Reset Password"),
                      )
                    ],
                  ),
                )),
    );
  }

  Future <void> resetPassword() async {
    String? username = usernameController.text.trim();
    String? password1 = password1Controller.text.trim();
    String? password2 = password2Controller.text.trim();
    if (username.isEmpty || password1.isEmpty || password2.isEmpty){
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
      setState((){
        codeValid = false;
      });
    }
  }
  Future <void> sendPasswordResetCode() async {
		String? email = emailController.text.trim();
		if (email.isEmpty){
			ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text("Please Enter a valid email"),
        ),
      );
		}
	}

  Future<void> requestPasswordReset() async {
    String? otpCode = otpCodeController.text.trim();
		if (otpCode.isEmpty){
			ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Text("Please Enter code sent on email"),
        ),
      );
		}

    setState(() {
        codeValid = true;
      });
  }
}
