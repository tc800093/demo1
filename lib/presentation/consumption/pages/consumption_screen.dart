import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// The Consumption screen provides a detailed breakdown of energy usage.
/// It displays interactive charts (via fl_chart) showing daily, weekly,
/// and monthly power consumption trends, alongside peak usage metrics.
class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {
  String _timeframe = 'Daily';
  String _sourceFilter = 'Combined';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Energy Consumption',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilters(context),
            const SizedBox(height: 24),
            _buildChartCard(context),
            const SizedBox(height: 24),
            _buildSummaryStats(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((tf) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        tf,
                        style: TextStyle(
                          color: _timeframe == tf
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: _timeframe == tf,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      onSelected: (selected) {
                        if (selected) setState(() => _timeframe = tf);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Data Source',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _sourceFilter,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      items: ['Combined', 'MSEB', 'Generator'].map((src) {
                        return DropdownMenuItem(value: src, child: Text(src));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _sourceFilter = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consumption Overview',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 280,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) =>
                          Theme.of(context).colorScheme.primary,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '\${rod.toY.round()} kWh',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '\${value.toInt()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    for (int i = 0; i < 7; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: 40.0 + (i * 5),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 20,
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.05),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Consumed',
            '452 kWh',
            Icons.bolt,
            const Color(0xFF0D47A1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Daily Average',
            '64.5 kWh',
            Icons.analytics,
            const Color(0xFF00B0FF),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
