import 'package:flutter/material.dart';
import 'package:smees/views/common/status_card.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text("Exam Statistics",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          children: [
            const ListTile(
              leading: Text(
                "No.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              title: Text(
                "Date Taken \t Time Elapsed",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "Score",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Description text",
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text("08-04-2024 \t 1:30:45"),
                  trailing: Text("80%"),
                  subtitle: Text("1:30:45"),
                );
              },
            ),
          ],
        ),
        ExpansionTile(
          title: const Text(
            "Test Statistics",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          children: [
            const ListTile(
              leading: Text(
                "No.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              title: Text(
                "Date Taken \t Time Elapsed",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "Score",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Description text",
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text("${index + 1}"),
                  title: Text("08-04-2024 \t 1:30:45"),
                  trailing: Text("80%"),
                  subtitle: Text("1:30:45"),
                  hoverColor: Colors.blue,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
