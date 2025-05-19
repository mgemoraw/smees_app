import 'package:flutter/material.dart';

class SpinnerLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const SpinnerLoader({
    Key? key,
    this.size = 60.0,
    this.strokeWidth = 4.0,
    this.color = Colors.green,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
