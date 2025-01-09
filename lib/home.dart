import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smees/exam_page.dart';
import 'package:smees/home_page.dart';
import 'package:smees/models/user.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/exam_home.dart';
import 'package:smees/views/practice_quiz.dart';

class HomePage extends StatefulWidget {
  final String department;
  final String username;
  const HomePage({super.key, required this.department, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String username;
  late double score = 0;
  late User user;
  late int _pageIndex = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      _getCurrentUser();
      _loadScore();
    });
  }

  Future<void> _loadScore() async {
    // late double latestScore = 0;
    setState(() {
      score = 6.0;
    });
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      user = User(
          userId: "sgetme",
          password: "test password",
          univesity: "BDU",
          department: "Test Department");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UserStatusCard(),

              // additional widgets here
              Divider(
                height: 3,
                color: Colors.blue[900],
              ),

              // additional widgets below
              Card(
                child: ListTile(
                  title: Text(
                    "Learn Zone",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Learn things where you failed more"),
                  trailing: const Icon(Icons.menu_book),
                  leading: Image.asset(
                    'assets/images/theory.png',
                    fit: BoxFit.contain,
                    // width: 150,
                    // height: 150,
                  ),
                  onTap: () {
                    setState(() {
                      _pageIndex = 0;
                    });
                  },
                ),
              ),

              Card(
                child: ListTile(
                  title: const Text(
                    "Practice Questions",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                      "Practice Wih limited nummber of Randomly selected Questios"),
                  trailing: const Icon(Icons.question_answer_rounded),
                  leading: Image.asset(
                    'assets/images/quiz.png',
                    fit: BoxFit.contain,
                  ),
                  onTap: () {
                    // print("Hello");
                    setState(() {
                      Navigator.pushNamed(context, "/quiz");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const TestHome(
                      //         department: "IndustrialEngineering"),
                      //     // const HomePage(),
                      //   ),
                      // );
                    });
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    "Take Model Exam",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                      "Take a Model Exit Exam . Please read more on how to take the Model exam"),
                  trailing: const Icon(Icons.quiz_rounded),
                  leading: Image.asset(
                    'assets/images/exam.png',
                    fit: BoxFit.contain,
                    // width: 150,
                    // height: 150,
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.pushNamed(context, "/exam");
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const ExamHome(
                      //       department: "CivilEngineering",
                      //     ),
                      //     // const HomePage(),
                      //   ),
                      // );
                    });
                  },
                ),
              ),

              Card(
                child: ListTile(
                  title: const Text(
                    "Your Statistics",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Check your Statistics Here"),
                  trailing: const Icon(Icons.bar_chart),
                  leading: Image.asset(
                    'assets/images/stats.png',
                    fit: BoxFit.contain,
                    // width: 150,
                    // height: 150,
                  ),
                  onTap: () {
                    final parentState =
                        context.findAncestorStateOfType<_Hometate>();
                    parentState?._showStatistics();
                    setState(() {
                      _pageIndex = 2;
                      Home h = const Home(
                          department: "AutomotiveEngineering", title: 'SMEES');
                      h.pageKey = 'userstat';
                    });
                  },
                ),
              ),
            ],
          )),
    );
  }
}
