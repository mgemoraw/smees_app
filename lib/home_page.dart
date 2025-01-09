import 'package:flutter/material.dart';
import 'package:smees/depreciated/department.dart';
import 'package:smees/depreciated/quiz_page.dart';
import 'package:smees/login_page.dart';

import 'package:smees/student_profile.dart';
import 'package:smees/student_statistics.dart';
import 'package:smees/views/common/appbar.dart';

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
  int pageIndex = 0;
  String pageKey = "home";
  // String _department = "";

  String get _department => widget.department;

  // list of pages in the bottom appbar
  final pages = {
    'home': const HomePage(department: "AutomotiveEngineering"),
    'exam': const QuizPage(title: 'Select Your Study Area Here'),
    'userstat': const Statistics(),
    'profile': const Profile(userId: "bdu0001"),
    // 'learn': const LearnZone(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/graduation.png', height: 100),
                  Text("Grand Success"),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: const Text('Send Us feedback'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushNamed(context, "/");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Login()),
                // );
              },
            ),
          ],
        ),
      ),
      appBar: SmeesAppbar(title: "SMEES"),
      // body: pages[pageIndex],
      body: pages[pageKey],
      bottomNavigationBar: Container(
          height: 60,
          decoration: const BoxDecoration(
            // color: Theme.of(context).primaryColor,
            color: Colors.white10,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                enableFeedback: true,
                tooltip: 'Home',
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                    pageKey = 'home';
                  });
                },
                icon: pageIndex == 0
                    ? const Icon(
                        Icons.home_outlined,
                        color: Colors.green,
                        size: 35,
                      )
                    : const Icon(
                        Icons.home_outlined,
                        color: Colors.black54,
                        size: 35,
                      ),
              ),
              IconButton(
                enableFeedback: false,
                tooltip: 'Learn Zone',
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                    pageKey = 'learn';
                  });
                },
                icon: pageIndex == 1
                    ? const Icon(
                        Icons.menu_book_outlined,
                        color: Colors.green,
                        size: 35,
                      )
                    : const Icon(
                        Icons.menu_book_outlined,
                        color: Colors.black54,
                        size: 35,
                      ),
              ),
              IconButton(
                  enableFeedback: false,
                  tooltip: 'Statistics',
                  onPressed: () {
                    setState(() {
                      pageIndex = 2;
                      pageKey = 'userstat';
                    });
                  },
                  icon: pageIndex == 2
                      ? const Icon(
                          Icons.bar_chart,
                          color: Colors.green,
                          size: 35,
                        )
                      : const Icon(
                          Icons.bar_chart,
                          color: Colors.black54,
                          size: 35,
                        )),
              IconButton(
                enableFeedback: false,
                tooltip: "Profile",
                onPressed: () {
                  setState(() {
                    pageIndex = 3;
                    pageKey = 'profile';
                  });
                },
                icon: pageIndex == 3
                    ? const Icon(
                        Icons.person_outline,
                        color: Colors.green,
                        size: 35,
                      )
                    : const Icon(
                        Icons.person_outline,
                        color: Colors.black54,
                        size: 35,
                      ),
              ),
            ],
          )),
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
