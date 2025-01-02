import 'package:flutter/material.dart';
import 'package:smees/depreciated/department.dart';
import 'package:smees/login_page.dart';
import 'package:smees/views/exam_home.dart';
import 'package:smees/views/take_exam.dart';

class ExamPage extends StatefulWidget {
  final String title;
  const ExamPage({super.key, required this.title});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
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
                  Image.asset('images/graduation.png', height: 100),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(33, 150, 243, 1),
        title: Text(
          "Time allowed: 60'",
        ),
        actions: [
          // working on search bar
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: TextButton(
                  child: Text("About Us"),
                  onPressed: () {},
                ),
              ),
              PopupMenuItem(
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ),
            ];
          }),
        ],
      ),
      body: TakeExam(department: "CivilEngineering", items: []),
    );
  }
}

// test grid view
class MyGrid extends StatelessWidget {
  const MyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            // height: 50,
            color: Colors.blue[500],
            child: Column(
              children: [
                Text("What is meant by the following question?"),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(value: 1, groupValue: 1, onChanged: (index) {}),
                        Text("Option A"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: 2, groupValue: 2, onChanged: (index) {}),
                        Text("Option B"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: 3, groupValue: 3, onChanged: (index) {}),
                        Text("Option C"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: 4, groupValue: 4, onChanged: (index) {}),
                        Text("Option D"),
                      ],
                    ),
                  ],
                ),
              ],
            ));
      },
      // child: GridView.count(
      //     scrollDirection: Axis.vertical,
      //     crossAxisCount: 1,
      //     mainAxisSpacing: 0,
      //     children: List.generate(
      //       60,
      //       (index) {
      //         return Center(
      //           child: Text("Question $index"),
      //         );
      //       },
      //     )),
    );
  }
}
