import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smees/depreciated/department.dart';
import 'package:smees/depreciated/quiz_page.dart';
import 'package:smees/login_page.dart';
import 'package:smees/models/user.dart';

import 'package:smees/student_profile.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/drawer.dart';
import 'package:smees/views/common/navigation.dart';
import 'package:smees/views/learn_zone.dart';

import 'home.dart';

class Home extends StatefulWidget {
  final String title;
  final String department;

  const Home({super.key, required this.title, required this.department});

  set pageKey(String pageKey) {}

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String pageKey = "home";
  String department = "";
  User? user;

  // list of pages in the bottom appbar
  // final pages = {
  //   'home': const HomePage(department: "TEst", username: "None"),
  //   'exam': const QuizPage(title: 'Select Your Study Area Here'),
  //   'userstat': const Statistics(),
  //   'profile': const Profile(userId: "bdu0001"),
  //   // 'learn': const LearnZone(),
  // };

  static List<Widget> _pages = <Widget>[
    const HomePage(department: "", username: ""),
    // const LearnZone(department: ''),
    const Statistics(),
    const Profile(userId: ""),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("smees-user-data");

    setState(() {
      if (jsonString != null) {
        Map<String, dynamic> userData = jsonDecode(jsonString);
        user = User(
          userId: userData['username'],
          department: userData['department'],
          univesity: userData['university'],
          password: null,
        );
      }
    });
  }

  String getCurrentDepartment() {
    return "Test Department";
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showStatistics() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LeftNavigation(),
      appBar: SmeesAppbar(title: "SMEES-App"),

      body: _pages.elementAt(_selectedIndex), // _pages[_selectedIndex],
      bottomNavigationBar:
          BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}

// test grid view
class MyGrid extends StatelessWidget {
  const MyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          mainAxisSpacing: 5,
          children: List.generate(
            100,
            (index) {
              return const Center(
                child: Departments(),
              );
            },
          )),
    );
  }
}
