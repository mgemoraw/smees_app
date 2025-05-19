import 'package:flutter/material.dart';

class CircularLoadingIndicator extends StatelessWidget {
  final double progress; // from 0.0 to 1.0
  final double size;
  final Color color;
  final bool showPercentage;

  const CircularLoadingIndicator({
    Key? key,
    required this.progress,
    this.size = 100.0,
    this.color = Colors.green,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          if (showPercentage)
            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}
