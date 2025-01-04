import "package:flutter/material.dart";

class LearnZone extends StatefulWidget {
  final String department;
  const LearnZone({super.key, required this.department});

  @override
  State<LearnZone> createState() => _LearnZoneState();
}

class _LearnZoneState extends State<LearnZone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
