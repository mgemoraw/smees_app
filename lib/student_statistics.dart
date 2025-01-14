import 'package:flutter/material.dart';
import 'package:smees/views/common/status_card.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: const Center(
          child: Column(
        children: [
          UserStatusCard(),
          UserStatistics(),
        ],
      )),
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
    return const SingleChildScrollView(
      child: GridTile(
        child: Text(
          "Your Score board",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),  
      ),
    );
  }
}
