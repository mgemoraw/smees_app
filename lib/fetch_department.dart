import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const firebaseUrl = "https://exit-exam-7280e-default-rtdb.firebaseio.com/.json";

// Future<http.Response> fetchDepartments() {
//   return http.get(Uri.parse(firebaseUrl));
// }

void main() {
  runApp(ExplainFutures());
}

class ExplainFutures extends StatefulWidget {
  const ExplainFutures({super.key});

  @override
  State<ExplainFutures> createState() => _ExplainFuturesState();
}

class _ExplainFuturesState extends State<ExplainFutures> {
  @override
  void initState() {
    // getStudentDetails();
    super.initState();
  }

  Future<String> getStudentDetails() async {
    // then approach - 1st one
    // http.get(Uri.parse(firebaseUrl)).then((value) => print(value.body));
    // return {'user_id': 'user', 'password': 'User@@'};

    // Response
    try {
      http.Response res = await http.get(Uri.parse(firebaseUrl));
      print(res.body);
      return res.body;
    } catch (err) {
      print(err.toString());
    }
    return "null";
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Departments {
  final String university;
  final String department;
  final double timeAllowed;
  final String faculty;
  final String college;
  final int questions;
  final String icon;
  final String route;
  Departments(
      {required this.university,
      required this.department,
      required this.timeAllowed,
      required this.faculty,
      required this.college,
      required this.questions,
      required this.icon,
      required this.route});
}
