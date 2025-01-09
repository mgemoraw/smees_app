import 'package:flutter/material.dart';
import 'package:smees/exam_page.dart';
import 'package:smees/home_page.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/exam_home.dart';
import 'package:smees/views/practice_quiz.dart';

class HomePage extends StatefulWidget {
  final String department;
  const HomePage({super.key, required this.department});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                    // print("Hello");
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
                    setState(() {
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
