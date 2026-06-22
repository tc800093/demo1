import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:poweriot/features/users/analytics/presentation/provider/analytics_provider.dart';

class OutageGraphWidget extends StatelessWidget {
  final List<RuntimeSegment> segments;
  final DateTime fromDate;
  final DateTime toDate;
  final String title;

  const OutageGraphWidget({
    super.key,
    required this.segments,
    required this.fromDate,
    required this.toDate,
    required this.title,
  });

  bool get isSameDay =>
      fromDate.year == toDate.year &&
      fromDate.month == toDate.month &&
      fromDate.day == toDate.day;

  List<FlSpot> _buildSpots() {
    final Map<int, double> values = {};

    if (isSameDay) {
      for (final segment in segments) {
        final hour = segment.start.hour;

        values.update(
          hour,
          (value) => value + (segment.duration.inMinutes / 60),
          ifAbsent: () => segment.duration.inMinutes / 60,
        );
      }
    } else {
      for (final segment in segments) {
        final dayOffset = segment.start.difference(fromDate).inDays;

        values.update(
          dayOffset,
          (value) => value + (segment.duration.inMinutes / 60),
          ifAbsent: () => segment.duration.inMinutes / 60,
        );
      }
    }

    return values.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()
      ..sort((a, b) => a.x.compareTo(b.x));
  }

  double _maxX() {
    if (isSameDay) {
      return math.max(1, DateTime.now().hour.toDouble());
    }

    return math.max(1, (toDate.difference(fromDate).inDays).toDouble());
  }

  double _maxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 24;

    final highest = spots.map((e) => e.y).reduce(math.max);

    return math.max(24, highest.ceilToDouble() + 2);
  }

  double _bottomInterval() {
    if (isSameDay) {
      final currentHour = DateTime.now().hour;

      if (currentHour <= 6) return 1;
      return (currentHour / 5).ceil().toDouble();
    }

    final totalDays = toDate.difference(fromDate).inDays + 1;

    if (totalDays <= 7) return 1;
    if (totalDays <= 15) return 2;
    if (totalDays <= 30) return 5;
    if (totalDays <= 60) return 10;
    if (totalDays <= 90) return 15;

    return (totalDays / 6).ceil().toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spots = _buildSpots();

    return Padding(
      padding: .symmetric(horizontal: 20, vertical: 5),
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: _maxX(),
            minY: 0,
            maxY: _maxY(spots),

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 6,
              getDrawingHorizontalLine: (value) {
                return const FlLine(color: Color(0xFFF1F5F9), strokeWidth: 1);
              },
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 45,
                  interval: 6,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()} Hr',
                      style: theme.textTheme.bodySmall,
                    );
                  },
                ),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: _bottomInterval(),

                  getTitlesWidget: (value, meta) {
                    final style = theme.textTheme.bodySmall;

                    String text;

                    if (isSameDay) {
                      text = '${value.toInt().toString().padLeft(2, '0')}:00';
                    } else {
                      final date = fromDate.add(Duration(days: value.toInt()));

                      text = '${date.day}/${date.month}';
                    }

                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        text,
                        style: style,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    );
                  },
                ),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: Colors.grey.shade400,
                barWidth: 3,
                isStrokeCapRound: true,

                dotData: FlDotData(show: true),

                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.grey.shade200.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
