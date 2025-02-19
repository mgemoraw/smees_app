import 'package:flutter/material.dart';
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

  bool isLogin = true;
  final AuthService authService = AuthService();

  void handleAuth() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text.trim();
    String department = departmentController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        department.isEmpty ||
        (!isLogin && username.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Plese fill all fields"),
        ),
      );
      return;
    }

    if (isLogin) {
      // Login
      var user = await authService.login(email, password);
      if (user != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Sucess")));
      }
    } else {
      // Register
      var user =
          await authService.register(email, password, username, department);
      if (user != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Register Sucess")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Login" : "Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isLogin)
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Email"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAuth,
              child: Text(isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                  isLogin ? "Create an Account" : "Already have an account?"),
            )
          ],
        ),
      ),
    );
  }
}
