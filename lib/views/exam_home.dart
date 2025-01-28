import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:smees/exam_page.dart';
import 'package:smees/home.dart';
import 'package:smees/home_page.dart';
import 'package:smees/user_profile.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/answer_option.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/drawer.dart';
import 'package:smees/views/learn_zone.dart';
import 'package:smees/views/take_exam.dart';

import '../models/random_index.dart';

var files = {
  "Automotive Engineering": "AutomotiveEngineering",
  "Industrial Engineering": "IndustrialEngineering",
  "Mechanical Engineering": "MechanicalEngineering",
  "Civil Engineering": "CivilEngineering",
  'Water Resources and Irrigation Engineering': "wrie",
  'Hydraulic and Water Resources Engineering': "hwre",
  "Chemical Engineering": "ChemicalEngineering",
  "Food Engineering": "FoodEngineering",
  "Human Nutrition": "HumanNutrition",
  "Electrical Engineering": "ElectricalEngineering",
  "Computer Engineering": "ComputerEngineering",
  "Computer Science": "ComputerScience",
  "Software Engineering": "SoftwareEngineering",
};

// test class
class ExamHome extends StatefulWidget {
  final String department;
  // const ExamHome({Key? key, required this.department});
  const ExamHome({super.key, required this.department});

  @override
  State<ExamHome> createState() => _ExamHomeState();
}

class _ExamHomeState extends State<ExamHome> {
  // list of pages in the bottom appbar
  final pages = {
    'home': const HomePage(department: "AutomotiveEngineering", username: ""),
    'exam': const LearnZone(department: "AutomotiveEngineering"),
    'userstat': const Statistics(),
    'profile': const UserProfile(),
    // 'learn': const LearnZone(),
  };
  List _items = [];
  var department;
  String pageKey = "home";
  int pageIndex = 0;
  // fetch content from json
  Future<void> readJson(String path) async {
    String filePath = "assets/$path/$path.json";

    final String response = await rootBundle.loadString(filePath);
    final data = await json.decode(response);

    setState(() {
      _items = data;
    });
  }

  List<DropdownMenuItem<String>> getDepartents() {
    //
    List<DropdownMenuItem<String>> departments = [];
    for (String item in files.keys) {
      var menuItem = DropdownMenuItem(value: files[item], child: Text(item));
      departments.add(menuItem);
    }
    return departments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftNavigation(),
      appBar: SmeesAppbar(title: "SMEES"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          // user profile card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/user-1.png',
                      fit: BoxFit.contain,
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const Text(
                    'Test User',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Column(
                children: [
                  Text(
                    "Hello User",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Latest Score: 0.0"),
                ],
              ),
            ],
          ),

          // Choose your field of study section
          const Divider(height: 3, color: Colors.blue),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                "Welcome to your Model Exit Exam Page You will be given 100 questions with 1 minute for each question. You cannot exit from the model exam once started. If you stopped the exam in any case the questions you answered up to the stoppage time will be recorded. Once you completed your answers, do not forget to submit your answers to get the final score. If your exam is interrupted, the number of questions you answered will be stored for the allowed exam period only.  You can't submit incomplete questions as the submit button is disabled unless all the questions are checked. Your performance will be sent to Your University's Quality Assurance Office when You are connected to internet. Good Luck and Enjoy"),
          ),

          // dropdown option to choose and take Exam
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    value: department,
                    hint: const Text("Selct your Field of Study Here"),
                    items: getDepartents(),
                    onChanged: (value) {
                      //
                      setState(() {
                        department = value;
                        readJson(department);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // readJson(department);

              int qnos = (_items.length >= 100) ? 100 : _items.length;

              List<int> indexes = [];
              var items = [];

              if (_items.length > 100) {
                indexes = generateIndexes(_items, qnos);
                for (int i in indexes) {
                  items.add(_items[i]);
                }
              } else {
                items = _items;
              }

              if (qnos > 0 && _items.isNotEmpty) {
                // start quiz

                // Navigator.pushNamed(context, "/exam");
                Navigator.pop(context); // pop the exam page first
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeExam(
                      department: department,
                      items: items,
                    ),
                  ),
                );
              }
            },
            child: Text("Start Exam"),
          ),
        ]),
      ),
      bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            // color: Theme.of(context).secondaryHeaderColor,
            color: Colors.white12,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                enableFeedback: true,
                tooltip: 'Home',
                onPressed: () {
                  pageIndex = 0;
                  pageKey = 'home';

                  /* go back to home */
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Home(
                  //       title: "BiT-ExitE",
                  //       department: "",
                  //     ),
                  //   ),
                  // );
                },
                icon: const Icon(
                  Icons.home_outlined,
                  color: Colors.black54,
                  size: 35,
                ),
              ),
            ],
          )),
    );
  }

  int validateInput(String value) {
    int qnos = 0;
    try {
      qnos = int.parse(value);
      if (qnos > 25) {
        return 25;
      }
    } catch (e) {
      // catch error
    }
    return qnos;
  }
}
