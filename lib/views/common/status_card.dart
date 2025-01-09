import "package:flutter/material.dart";
import "package:smees/models/user.dart";

class UserStatusCard extends StatefulWidget {
  const UserStatusCard({super.key});

  @override
  State<UserStatusCard> createState() => _UserStatusCardState();
}

class _UserStatusCardState extends State<UserStatusCard> {
  late String username;
  late double score = 0;
  late User user;
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
    return Row(
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
            Text(
              "${user.userId}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "Hello ${user.userId}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("Latest Score: $score"),
          ],
        ),
      ],
    );
  }
}
