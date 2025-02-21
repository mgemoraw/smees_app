import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smees/home_page.dart';
import 'package:smees/models/firestore_user_model.dart';
import 'package:smees/models/user.dart';
import 'package:smees/views/user_provider.dart';
import 'firebase_auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  
  User _user = User();

  bool isLogin = true;
  bool _isObscure = true;
  final AuthService authService = AuthService();

  Future<void> handleAuth() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    String department = departmentController.text.trim();


    if (isLogin){
      if (username.isEmpty||password.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$username $password"),
          ),
        );
      }
      // Login
      try {
        var user = await authService.loginUser(username, password);
        if (user != null && user.role == 'student') {
          
          setState(() {
            // set global user state
            _user = User.fromMap(user.toMap());
          });
          // Navigator.pushReplacementNamed(context, "/");
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Home(title: "SMEES", department: ""))
          // );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Access denied"),backgroundColor: Colors.redAccent,));
        }
      } catch(err){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Error: ${err.toString()}")));
      }
    } else{
      //
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Plese fill all fields"),
          ),
        );
      }
      // Register
      var user =
      await authService.register(email, password, username, department);
      if (user != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Register Sucess")));
      }
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return PopScope(
        canPop: false,
        child: Scaffold(
      appBar: AppBar(title: Text(isLogin ? "SMEES Login" : "SMEES Register")),
      body: Center(child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Welcome To SMEES, Please Login to continue"),

              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Email"),
              ),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()  async {
                await handleAuth();
                if (_user != null) {
                  print(_user!.department);
                  setState(() {
                    userProvider.setUser(newUser: _user);
                  });
                  // Navigator.pushNamed(context, "/");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home(title: "SMEES", department: ""))
                  );
                }
              },
              child: Text(isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                  isLogin ? "Create an Account" : "Already have an account?"),
            )
          ],
        ),

      ),),
    ),
    );
  }
}
