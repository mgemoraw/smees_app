import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Hide grid lines
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true)), // Left labels
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}'); // Customize X-axis labels
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(show: true), // Show border
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 2.5),
                FlSpot(3, 5),
                FlSpot(4, 3.5),
                FlSpot(5, 4),
                FlSpot(6, 3),
              ],
              isCurved: true, // Smooth curve
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false), // Hide below area
            ),
          ],
        ),
      ),
    );
  }
}
