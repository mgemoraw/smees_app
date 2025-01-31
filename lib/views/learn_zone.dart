import "package:flutter/material.dart";
import "package:smees/views/common/appbar.dart";
import "package:smees/views/common/navigation.dart";

class LearnZone extends StatefulWidget {
  final String department;
  const LearnZone({super.key, required this.department});

  @override
  State<LearnZone> createState() => _LearnZoneState();
}

class _LearnZoneState extends State<LearnZone> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: Text("Learn Zone")),
    );
  }
}
