import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smees/models/database.dart';
import 'package:smees/models/test_model.dart';
import 'package:smees/views/common/status_card.dart';
import 'package:smees/views/statistics/student_stats_chart.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        UserStatusCard(),
        UserStatistics(),
      ],
    );
  }
}

class UserStatistics extends StatefulWidget {
  const UserStatistics({super.key});

  @override
  State<UserStatistics> createState() => _UserStatisticsState();
}

class _UserStatisticsState extends State<UserStatistics> {
  late Future<List<Map<String, dynamic>>> _testsFuture;
  late Future<List<Map<String, dynamic>>> _examsFuture;
  late Iterable<Test> _tests;
  late List<Exam> _exams;

  @override
  initState() {
    super.initState();
    _fetchTests();
    _loadTests();
  }

  Future<void> _loadTests() async {
    await SmeesHelper().database;
    final data = await loadTests();
    setState(() {
      _tests = data;
    });
  }

  Future<Iterable<Test>> loadTests() async {
    final db = SmeesHelper();
    final result = await db.getTests();
    return result.map((row) {
      return Test(
        id: row['id'],
        userId: row['userId'],
        testStarted: DateTime.parse(row['testStarted']),
        testEnded: DateTime.parse(row['testEnded']),
        questions: row['questions'],
        score: row['score'],
      );
    }).toList();
  }

  Future<void> _fetchTests() async {
    final helper = SmeesHelper();
    // final data = helper.getTests();
    // final examData = helper.getExams();
    setState(() {
      _testsFuture = helper.getTests();
      _examsFuture = helper.getExams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          leading: Icon(Icons.bar_chart),
          title: const Text("Test Statistics",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
                future: _testsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Errror: ${snapshot.error}"));
                  } else {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("No")),
                          DataColumn(label: Text("User")),
                          DataColumn(label: Text("Test Date")),
                          // DataColumn(label: Text("Started")),
                          // DataColumn(label: Text("Ended")),
                          // DataColumn(label: Text("Questions")),
                          DataColumn(label: Text("Score")),
                        ],
                        rows: data.map((row) {
                          final test = Test.fromMap(row);
                          return DataRow(cells: [
                            DataCell(Text(test.id.toString())),
                            DataCell(Text(test.userId.toString())),
                            DataCell(Text(
                                "${test.testStarted!.day}-${test.testStarted!.month}-${test.testStarted!.year} ")), //
                            // DataCell(Text(
                            //     "${test.testStarted!.hour}:${test.testStarted!.minute}:${test.testStarted!.second}")), //
                            // DataCell(Text(
                            //     "${test.testEnded!.hour}:${test.testEnded!.minute}:${test.testEnded!.second}")), //
                            // DataCell(Text(test.questions.toString())),
                            DataCell(Text("${test.score.toString()} / ${test
                                .questions.toString()}")),
                          ]);
                        }).toList(),
                      ),
                    );
                  }
                }),
            // ListView.builder(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   itemCount: _tests.toList().length,
            //   itemBuilder: (context, index) {
            //     final data = _tests.toList();
            //     return ListTile(
            //       leading: Text("${index + 1}"),
            //       title: Text("${data[index].testStarted}"),
            //       trailing: Text("${data[index].score}"),
            //       subtitle: Text("Details"),
            //     );
            //   },
            // ),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.bar_chart),
          title: const Text(
            "Exam Statistics",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          children: [
            // const ListTile(
            //   leading: Text(
            //     "No.",
            //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //   ),
            //   title: Text(
            //     "Date Taken \t Time Elapsed",
            //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //   ),
            //   trailing: Text(
            //     "Score",
            //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            //   ),
            //   subtitle: Text(
            //     "Description text",
            //   ),
            // ),
            FutureBuilder<List<Map<String, dynamic>>>(
                future: _examsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("No")),
                          DataColumn(label: Text("User")),
                          DataColumn(label: Text("Test Date")),
                          //DataColumn(label: Text("Started")),
                          //DataColumn(label: Text("Ended")),
                          //DataColumn(label: Text("Questions")),
                          DataColumn(label: Text("Score")),
                        ],
                        rows: data.map((row) {
                          final exam = Exam.fromMap(row);

                          return DataRow(cells: [
                            DataCell(Text(exam.id.toString())),
                            DataCell(Text(exam.userId.toString())),
                            // DataCell(Text(
                            //     "${exam.examStarted!.day}-${exam.examStarted!
                            //         .month}-${exam.examStarted!.year} ")), //
                            // DataCell(Text(
                            //     "${exam.examStarted!.hour}:${exam
                            //         .examStarted!.minute}:${exam.examStarted!
                            //         .second}")), //
                            DataCell(Text(
                                "${exam.examEnded!.hour}:${exam.examEnded!
                                    .minute}:${exam.examEnded!.second}")),
                            // DataCell(Text(exam.questions.toString())),
                            DataCell(Text("${exam.score.toString()} / ${exam
                                .questions.toString()}")),
                          ]);
                        }).toList(),
                      ),
                    );
                  }
                }),
            // ListView.builder(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   itemCount: 5,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       leading: Text("${index + 1}"),
            //       title: Text("08-04-2024 \t 1:30:45"),
            //       trailing: Text("80%"),
            //       subtitle: Text("1:30:45"),
            //       hoverColor: Colors.blue,
            //     );
            //   },
            // ),
          ],
        ),
        // LineChartWidget(),
      ],
    );
  }
}
