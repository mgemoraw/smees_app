import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smees/api/end_points.dart';
import 'package:smees/models/user.dart';
import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/statistics/student_stats_chart.dart';
import 'package:smees/views/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class UserProfile extends StatefulWidget {

  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController password1Controller= TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  late String? _message = null;
  late bool isLoading = false;
  User? user = User();

  @override
  void initState(){
    super.initState();
    setState(() {
      _getCurrentUser();

    });
  }

  Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userData = jsonDecode(prefs.getString('smees-user')!);
    setState(() {
      user = User(
        username: userData['username'] ,
        password: userData['token'],
        email: userData['email'],
        university: userData['university'],
        department: userData['department'],
      );
    });
  }
  Future <void> _updatePassword(Map<String, dynamic> password) async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key:"smees_token");

    final url = Uri.parse('${API_BASE_URL}${changePasswordApi}');
    // final url = Uri.parse('$apiUrl/$loginApi');

    final headers = {
      "Content-Type": "application/json",
      // 'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $token',
      };
    final body = jsonEncode(password);
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200){
        final tokenString = jsonDecode(response.body);
        await storage.write(key:"smees_token", value: tokenString['access_token']);
        setState(() {
          _message = "success";
        });
      } else {
        setState(() {
          _message = "Error: Password is incorrect";
        });
      }
    } catch(err) {
      _message = "Error: Please check your connection!";
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }
  void _updatePasswordDialog(context) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: SingleChildScrollView(
            child: Column(
              children: [
              TextField(
                controller: oldPasswordController,
                autocorrect: true,
                obscureText: true,
                decoration: InputDecoration(hintText: "Old Password", errorText: 'Required'),
                ),
              TextField(
                controller: password1Controller,
                autocorrect: true,
                obscureText: true,
                decoration: InputDecoration(hintText: "New Password", errorText: 'Required'),
              ),
              TextField(
                controller: password2Controller,
                autocorrect: true,
                obscureText: true,
                decoration: InputDecoration(hintText: "Repeat Password", errorText: "Required"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      // update 
                      String oldPassword = oldPasswordController.text;
                      String password1 = password1Controller.text;
                      String password2 = password2Controller.text;
            
                      if (oldPassword.isEmpty || password1.isEmpty || password2.isEmpty){
                        setState(() {
                          _message = "All Fields Required";
                        });
                      } else if(password1!= password2 ){
                        setState(() {
                          _message = "Passwords Do not match";
                        });
                      } else {
                       
                        // send password change
                        await _updatePassword({'old_password': oldPassword, 'new_password': password2});
            
                        // exit the popoup window
                        setState(() {
                          oldPasswordController.text = "";
                          password1Controller.text = "";
                          password2Controller.text = '';
                      });
                        Navigator.of(context).pop();
            
                        (_message == "success")
                        ? ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password Updated"), backgroundColor: Colors.green,),
                        )
                        : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$_message"), backgroundColor: Colors.deepOrange,),
                        );
                      }
                      
                    }, child: isLoading? CircularProgressIndicator(color: Colors.blue) : Text("Update"),
                  ),
                  TextButton(
                    onPressed: (){
                      //
                      setState(() {
                        oldPasswordController.text = "";
                        password1Controller.text = "";
                        password2Controller.text = '';
                      });
                      
                    }, child: Text("Clear"),
                  ),
                ],
              ),
              _message != null ? Text("$_message", style: TextStyle(color: Colors.red),) : Text(""),
            ],),
          ),
          actions: [
            TextButton(
              onPressed: (){
                setState(() {
                  oldPasswordController.text = "";
                  password1Controller.text = "";
                  password2Controller.text = '';
                });
                Navigator.of(context).pop();
              },
              child: Text("Close"),)
          ],
        );
      }
      );
  }

  @override
  Widget build(BuildContext context) {
    
    // final userProvider = Provider.of<UserProvider>(context);
    
    return Center(
      
      child: ListView(
        children: [
          const UserStatusCard(),
          // UserStatistics(),
          ExpansionTile(
            title: Text(
            "User Information",
            style: TextStyle(
              color: Colors.green[900],
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          
            children: [
              
              ListTile(
                title: Text("Username: ${user!.username}"),
                // trailing: TextButton(child: Text("Edit Info"), onPressed: (){},),
              ),
              ListTile(
                title: Text("Full Name: ${user!.fname} ${user!.mname} ${user!.lname}"),
                // trailing: TextButton(child: Text("Edit"), onPressed: (){},),
              ),

              ListTile(
                title: Text("University: ${user!.university != null ? user!.university : ""}"),
                // trailing: TextButton(child: Text("Edit Info"), onPressed: (){},),
              ),

              ListTile(
                title: Text("Department: ${user!.department}"),
              ),

              ListTile(
                title: Text("Email: ${user!.email}"),
                // trailing: TextButton(child: Text("Edit Info"), onPressed: (){},),
              ),
              ListTile(
                title: Text("Password: **********"),
                trailing: TextButton(child: Text("Change Password"), onPressed: (){
                  _updatePasswordDialog(context);
                },),),
            ],
          ),
          LineChartWidget(),
          Container(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              //chart title
                title: ChartTitle(text: "Half yearly sales analysis"),
              // tooltipBehavior: _tooltipBehavior,
              series: <LineSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                  dataSource: <SalesData>[
                    SalesData('Jan', 35),
                    SalesData('Feb', 28),
                    SalesData('Mar', 34),
                    SalesData('Apr', 32),
                    SalesData('May', 40),
              ],
                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales,

                  // enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
            ]
          ),
          ),

        ],
      ),
    );
  }
}


class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;

}