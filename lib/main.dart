import 'package:flutter/material.dart';

import 'package:smees/login_page.dart';
import 'package:smees/views/exam_home.dart';
import 'package:smees/views/practice_quiz.dart';
import "package:smees/views/learn_zone.dart";

import "package:smees/student_profile.dart";

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grand Success',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 142, 129, 157),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: Login(),
      initialRoute: "/home",
      routes: {
        '/': (context) => const Login(),
        '/home': (context) => const Home(title: "BiT-ExitE", department: "",),
        '/quiz': (context) => const TestHome(department: "",),
        "/exam": (context) => const ExamHome(department: ""),
        "/profile": (context) => const Profile(userId: "bdu20150001"),
        "/learn": (contest) => const LearnZone(department: ""),
      },
      // home: TestHome(department: "IndustrialEngineering"),
    );
  }
}
