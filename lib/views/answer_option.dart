import 'package:flutter/material.dart';

class AnswerOption extends StatelessWidget {
  final String answerText;
  final String value;
  final Color? answerColor;
  final void Function() answerTap;
  final bool enabled;
  const AnswerOption({
    super.key,
    required this.value,
    required this.answerText,
    required this.answerColor,
    required this.answerTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: answerColor,
          border: Border.all(),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          enabled: enabled,
          onTap: answerTap,
          leading: Text(
            "$value.",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          title: Text(
            answerText,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }
}
