import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/models/user.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/pdf_viewer.dart';
import 'package:smees/views/user_provider.dart';


var faculties = {
  'fcwre': [
    'Civil Engineering',
    'Hydraulic and Water Resources Engineering',
    'Water Resources and Irrigation Engineering',
  ],
  'fmie': [
    'Mechanical Engineering',
    'Industrial Engineering',
    'Automotive Engineering'
  ],
  'fcfe': [
    'Food Engineering',
    'Chemical Engineering',
    'Human Nutrition'
  ],
  'fece': [
    'Electrical Engineering',
    'Computer Engineering',
  ],
  'fc': [
    'Computer Science',
    'Software Engineering',
    'Information Technology',
    'Information Science',
    'Cyber Security',
  ]
};

class Blueprint extends StatefulWidget {
  const Blueprint({super.key});


  @override
  State<Blueprint> createState() => _BlueprintState();
}

class _BlueprintState extends State<Blueprint> {
  late String pdfPath = "";
  String department = "";

  @override
  void initState(){
    super.initState();
    // load department and then the pdf content path
    _loadPDF();
  }

  String getFaculty(String department) {
    String faculty = "";
    faculties.forEach((key, value) {
      for (String item in value){
        if (item == department){
          faculty = key;
        }
      }
    });
    return faculty;
  }
  Future <void> _loadPDF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString("smees-user");
    if (userString != null) {
      Map<String, dynamic> userData = jsonDecode(userString);
      String departmentName = userData['department'];
      String faculty = getFaculty(departmentName);

      if (departmentName.isNotEmpty) {
        String departmentPath = departmentName.toLowerCase().replaceAll(" ", "_");
        String filePath = "assets/$faculty/$departmentPath/$departmentPath.pdf";
        setState(() {
          pdfPath = filePath;
          department = departmentPath;
          // print(filePath);
        });
      }
      setState(() {
        //
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;

    return  Scaffold(
      appBar: SmeesAppbar(title: "${user.department} Blueprint"),
      body: PDFViewScreen(filePath: pdfPath),
    );
  }
}
