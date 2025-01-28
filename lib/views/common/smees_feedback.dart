import 'package:flutter/material.dart';
import 'package:smees/views/common/appbar.dart';
import 'package:smees/views/common/drawer.dart';

class SmeesFeedback extends StatefulWidget {
  const SmeesFeedback({super.key});

  @override
  State<SmeesFeedback> createState() => _SmeesFeedbackState();
}

class _SmeesFeedbackState extends State<SmeesFeedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmeesAppbar(title: "SMEES - Feedback page"),
      drawer: LeftNavigation(),
      body: Form(
        child: Text("Form Field"),
      ),
    );
  }
}
