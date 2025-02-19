import 'package:flutter/material.dart';
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
  bool otpValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmeesAppbar(title: "SMEES - App"),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: !otpValid
              ? Form(
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
                          onPressed: () {},
                          child: Text("Send Reset Code"),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: otpCodeController,
                        decoration: InputDecoration(
                            hintText: "Enter Code sent via your email"),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          child: Text("Confirm Code"),
                        ),
                      )
                    ],
                  ),
                )
              : Form(
                  child: Column(
                    children: [
                      Text(
                        "Account Reset form",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: usernameController,
                      ),
                      TextField(
                        controller: password1Controller,
                      ),
                      TextField(
                        controller: password2Controller,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("Confirm Code"),
                      )
                    ],
                  ),
                )),
    );
  }
}
