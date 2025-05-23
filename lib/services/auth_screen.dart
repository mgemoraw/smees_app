import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smees/home_page.dart';
import 'package:smees/models/firestore_user_model.dart';
import 'package:smees/models/user.dart';
import 'package:smees/views/user_provider.dart';
import 'firebase_auth_service.dart';
import 'package:smees/constants.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController mnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController sexController = TextEditingController();

  var department;
  User _user = User();
  String emptyError = "";
  bool isLogin = true;
  bool _isObscure = true;
  final AuthService authService = AuthService();
  bool isLoading = false;

  @override
  void dispose(){
    fnameController.dispose();
    mnameController.dispose();
    lnameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    password1Controller.dispose();
    password2Controller.dispose();
    universityController.dispose();
    super.dispose();
  }
  List<DropdownMenuItem<String>> getDepartments() {
    //
    List<DropdownMenuItem<String>> departments = [];
    for (String key in files.keys) {
      var menuItem = DropdownMenuItem(value: key, child: Text(key));
      departments.add(menuItem);
    }
    return departments;
  }
  void handleAuth() async {
    String email = emailController.text.trim();
    String password1 = password1Controller.text.trim();
    String password2 = password2Controller.text.trim();
    String username = usernameController.text.trim();

    String university = universityController.text.trim();
    String fname = fnameController.text.trim();
    String mname = mnameController.text.trim();
    String lname = lnameController.text.trim();
    String sex = sexController.text.trim();
    String password = "";
    UserModel? data;


    if (isLogin){
      if (email.isEmpty||password1.isEmpty){
        setState(() {
          emptyError = "This field is required";
        });

        return;
      }
      setState(() {
        emptyError = "";
      });
      // Login
      try {
        setState(() {
          isLoading = true;
        });
        var user = await authService.login(email, password1);

        // avoids unsafe usage of BuildContext after await operation
        if (!mounted) return; // checks if the widget is still in the tree

        if (user != null){ // && user.role == 'student') {
          // final userProvider = Provider.of<UserProvider>(context, listen: false);
          setState(() {
            // set global user state
            User newUser = User(
              fname: user.fname,
              mname: user.mname,
              lname: user.lname,
              sex: user.sex,
              username: user.username,
              email: user.email,
              department: user.department,
              university: user.university,
              createdAt: user.createdAt,
            );
            _user =newUser;

            Provider.of<UserProvider>(context, listen: false).setUser(newUser: newUser);
          });

          Navigator.pushReplacementNamed(context, "/");

        } else {

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Login Error: Access denied "),backgroundColor: Colors.redAccent,));
        }
      } catch(err){
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login Error: ${err.toString()}")));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else{
      //
      if (username.isNotEmpty || email.isNotEmpty || password1.isNotEmpty || password2.isNotEmpty || department.isNotEmpty||university.isNotEmpty) {
        if (password1 != password2){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Passwords do not match"),
            ),
          );
          return ;
        } else {
          password = password1;
        }

        data = UserModel(
          uid: "",
          fname: fname,
          mname: mname,
          lname:lname,
          sex: sex,
          username: username,
          email: email,
          department: department!,
          createdAt: DateTime.now(),
          role: 'student',
        );
      }

      // Register
      try {
        setState(() {
          isLoading = true;
        });
        var user =
        await authService.register(email, password, data!);
        if (user != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Register Sucess"),
            backgroundColor: Colors.green,));
        }
        // return;
      }catch (err){
        //
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(
              content: Text("Register Failed: Please "
            "use valid email and user id", style:TextStyle
                (color: Colors
                  .blue[900])),
              backgroundColor: Colors.red[300],));
      } finally {
        setState(() {
          isLoading = false;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return PopScope(
        canPop: false,
        child: Scaffold(
      appBar: AppBar(
            leading: Icon(Icons.school),
      title: const Text("SMEES"),
      backgroundColor: Colors.blue,
    ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isLogin ? "Welcome To SMEES, Please Login to continue" :
                "Create Free SMEES Account",
                  style:
                TextStyle(fontSize: 24,color: Colors.blue[900], fontWeight:
                FontWeight.bold),),
                  SizedBox(height: 16.0),
                  if (!isLogin) Column(
                    children: [
                      TextField(
                        controller: fnameController,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          error: fnameController.text.isEmpty ? Text("Required") : null,
                        ),

                      ),
                      TextField(
                        controller: mnameController,
                        decoration: InputDecoration(
                          labelText: "Father Name",
                          error: mnameController.text.isEmpty ? Text("Required") : null,
                        ),
                        style: TextStyle(fontSize:15),
                      ),
                      TextField(
                        controller: lnameController,
                        decoration: InputDecoration(
                          labelText: "G.F Name",
                          error: lnameController.text.isEmpty ? Text("Required") : null,
                        ),
                        style: TextStyle(fontSize:15),
                      ),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Student ID",
                          prefixIcon: Icon(Icons.group),
                          error: usernameController.text.isEmpty ? Text("Required") : null,
                        ),
                        style: TextStyle(fontSize:15),

                      ),
                      // university
                      TextField(
                        controller: universityController,
                        decoration: InputDecoration(
                          labelText: "University",
                          prefixIcon: Icon(Icons.account_balance),
                          error: universityController.text.isEmpty ? Text
                            ("Required") : null,
                        ),
                        style: TextStyle(fontSize:15),
                      ),
                      // department dropdown option to choose
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DropdownButton(
                          hint: Text("Choose you field of study"),
                            padding: EdgeInsets.all(16.0),
                            icon: Icon(Icons.school),
                            items: getDepartments(),
                            value: department,
                            onChanged: (value){
                              setState(() {
                                department = value;
                              });
                            },
                        ),
                      ),
                    ],
                  ),

                  // login fields
                Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "Your Email",
                        prefixIcon: Icon(Icons.email),
                        error: emailController.text.isEmpty ? Text
                          ("Required") : null,
                      ),
                      style: TextStyle(fontSize:15),
                    ),
                    SizedBox(height: 30),
                    TextField(
                      controller: password1Controller,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          error: password1Controller.text.isEmpty ? Text
                            ("Required") : null,
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
                  ],
                ),

                SizedBox(height: 20),
                if(!isLogin)  Column(
                  children:[
                    TextField(
                      controller: password2Controller,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          error: password1Controller.text.isEmpty
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
                  ]
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: handleAuth,
                    // onPressed: ()  async {
                    //   handleAuth();
                    //   if (_user.username != null && _user.department != null) {
                    //     print(_user!.department);
                    //     setState(() {
                    //       userProvider.setUser(newUser: _user);
                    //     });
                    //     // Navigator.pushNamed(context, "/");
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => Home(title: "SMEES", department: ""))
                    //     );
                    //   }
                    // },

                    child: isLoading ? const CircularProgressIndicator()
                        : Text(isLogin ? "Login" : "Register", style:
                    TextStyle(fontSize: 15, color: Colors.blue[900], fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 30),

                ListTile(
                  title: Text(
                    isLogin ? "Create an Account" : "Already have an "
                        "account?",
                    style: TextStyle(fontSize: 15,
                        fontWeight: FontWeight.bold ),),
                  trailing: TextButton(
                    child:Text(isLogin ? "Sign Up" : "Log In",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold)),
                    onPressed:  () => setState(() => isLogin = !isLogin),
                ),
                ),

              ],
            ),

          ),
        ),
      ),
    ),
    );
  }
}
