import 'package:flutter/material.dart';
import 'package:smees/depreciated/department.dart';
import 'package:smees/login_page.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/drawer.dart';
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
      drawer: LeftNavigation(),
      appBar: SmeesAppbar(title: "SMEES"),
      body: TakeExam(department: "CivilEngineering", items: [], examId: 0),
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
