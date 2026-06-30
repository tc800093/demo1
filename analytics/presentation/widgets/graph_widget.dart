import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class GraphWidget extends StatelessWidget {
  final List<FlSpot>? spots;
  final Widget Function(double, TitleMeta) getTitlesBottomWidget;
  final String title;
  final AxisTitles leftAccesTile;
  final double maxY;
  final double maxX;

  const GraphWidget({
    super.key,
    this.spots,
    required this.getTitlesBottomWidget,
    required this.title,
    required this.leftAccesTile,
    required this.maxX,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(20),
        border: .all(color: Colors.blueGrey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          SizedBox(height: AppSizes.height(2)),
          SizedBox(
            height: AppSizes.height(30),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFF1F5F9),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: getTitlesBottomWidget,
                    ),
                  ),
                  leftTitles: leftAccesTile,
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  // Generator Line
                  LineChartBarData(
                    spots: spots!,
                    isCurved: false,
                    color: Colors.grey.shade400,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.grey.shade200.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
