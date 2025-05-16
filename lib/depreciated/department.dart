import 'package:flutter/material.dart';
// import 'package:smees/exam_page.dart';

class Departments extends StatelessWidget {
  const Departments({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        child: Column(
      children: [
        Department(
          university: 'Bahir Dar Univercity',
          department: 'Civil Engineering',
          faculty: 'Faculty of Civil and Water Resources Engineering',
          college: 'BiT',
          questions: 60,
          timeAllowed: 60,
          icon: 'construction.png',
          route: 'civilEngineering',
        ),
      ],
    ));
  }
}

// Department object
class Department extends StatefulWidget {
  final String university;
  final String department;
  final double timeAllowed;
  final String faculty;
  final String college;
  final int questions;
  final String icon;
  final String route;
  const Department(
      {super.key,
      required this.university,
      required this.department,
      required this.timeAllowed,
      required this.faculty,
      required this.college,
      required this.questions,
      required this.icon,
      required this.route});

  @override
  State<Department> createState() => _DepartmentState(university, department,
      icon, college, faculty, questions, timeAllowed, route);
}

class _DepartmentState extends State<Department> {
  late String university;
  late String department;
  late String icon;
  late String college, faculty, route;
  late int questions;
  late double timeAllowed;
  _DepartmentState(university, department, icon, college, faculty, questions,
      timeAllowed, route) {
    this.university = university;
    this.department = department;
    this.icon = icon;
    this.college = college;
    this.faculty = faculty;
    this.route = route;
    this.questions = questions;
    this.timeAllowed = timeAllowed;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              ListTile(
                leading: Image.asset('images/$icon'),
                title: Text(
                  '$department',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  '$university, $college',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const ExamPage(
                      //             title: 'Depatment',
                      //           )),
                      // );
                    },
                    child: Text('Take Exam'),
                  ),
                  Text('#Quesitons: $questions Total'),
                  Text('Time: $timeAllowed minutes'),
                ],
              )
            ],
          )),
    );
  }
}
