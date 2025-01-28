import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final latestScore = prefs.getDouble("smees-score");
    setState(() {
      if (latestScore != null) {
        score = latestScore;
      }
    });
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      user = User(
          username: "sgetme",
          password: null,
          email: null,
          univesity: "BDU",
          department: "Test Department");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                'assets/images/user-2.png',
                fit: BoxFit.contain,
                width: 120,
                height: 120,
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Column(
            children: [
              Text(
                "Welcome ${user.username}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Latest Score: $score"),
            ],
          ),
        ],
      ),
    );
  }
}
