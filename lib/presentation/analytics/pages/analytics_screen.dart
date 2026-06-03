import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// The Analytics screen presents advanced telemetry and efficiency metrics.
/// It displays interactive consumption analysis charts, total usage stats,
/// peak demand warnings, and actionable efficiency insights.
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedTimeRange = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        toolbarHeight: 64,
        title: Row(
          children: [
            const Icon(Icons.bolt, color: Colors.blueAccent, size: 28),
            const SizedBox(width: 8),
            Text(
              'PowerIoT',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF003366),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTimeRangeSelector(),
            const SizedBox(height: 16),
            _buildSourceDropdown(),
            const SizedBox(height: 24),
            _buildChartCard(),
            const SizedBox(height: 16),
            _buildTotalConsumptionCard(),
            const SizedBox(height: 16),
            _buildPeakDemandCard(),
            const SizedBox(height: 16),
            _buildAverageUsageCard(),
            const SizedBox(height: 16),
            _buildRecentUsageEvents(),
            const SizedBox(height: 16),
            _buildEfficiencyInsight(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTimeToggle('Daily'),
          _buildTimeToggle('Weekly'),
          _buildTimeToggle('Monthly'),
        ],
      ),
    );
  }

  Widget _buildTimeToggle(String label) {
    bool isSelected = _selectedTimeRange == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTimeRange = label);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF0D47A1) : Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSourceDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Source: Combined Analytics',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF003366),
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(Icons.unfold_more, size: 20, color: Color(0xFF0D47A1)),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Energy\nConsumption\nAnalysis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.circle, size: 8, color: Colors.green),
                        SizedBox(width: 6),
                        Text(
                          'Live Telemetry',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.circle, size: 10, color: Color(0xFF0D47A1)),
                      SizedBox(width: 6),
                      Text(
                        'MSEB',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: Colors.grey.shade400),
                      const SizedBox(width: 6),
                      const Text(
                        'Generator',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
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
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        );
                        String text = '';
                        switch (value.toInt()) {
                          case 0:
                            text = '00:00';
                            break;
                          case 2:
                            text = '06:00';
                            break;
                          case 4:
                            text = '12:00';
                            break;
                          case 6:
                            text = '18:00';
                            break;
                          case 8:
                            text = '23:59';
                            break;
                          default:
                            return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 200,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} kWh',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 8,
                          ),
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 8,
                minY: 0,
                maxY: 800,
                lineBarsData: [
                  // Generator Line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 150),
                      FlSpot(1, 100),
                      FlSpot(2, 80),
                      FlSpot(3, 120),
                      FlSpot(4, 200),
                      FlSpot(5, 180),
                      FlSpot(6, 220),
                      FlSpot(7, 190),
                      FlSpot(8, 160),
                    ],
                    isCurved: true,
                    color: Colors.grey.shade400,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.grey.shade200.withValues(alpha: 0.5),
                    ),
                  ),
                  // MSEB Line
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 400),
                      FlSpot(1, 380),
                      FlSpot(2, 300),
                      FlSpot(3, 350),
                      FlSpot(4, 480),
                      FlSpot(5, 450),
                      FlSpot(6, 500),
                      FlSpot(7, 520),
                      FlSpot(8, 420),
                    ],
                    isCurved: true,
                    color: const Color(0xFF0D47A1),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF0D47A1).withValues(alpha: 0.3),
                          const Color(0xFF0D47A1).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
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

  Widget _buildTotalConsumptionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1), // Dark Blue
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.bolt,
              size: 100,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.bolt, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'TOTAL CONSUMPTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '1,482.5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'kWh total this period',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white.withValues(alpha: 0.2)),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.trending_down, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    '4.2% reduction vs yesterday',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeakDemandCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Color(0xFFD32F2F), width: 6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.speed, color: Color(0xFF003366), size: 16),
              SizedBox(width: 8),
              Text(
                'PEAK DEMAND',
                style: TextStyle(
                  color: Color(0xFF003366),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '24.8',
            style: TextStyle(
              color: Color(0xFF003366),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'kW reached at 14:32',
            style: TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.blueGrey.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFD32F2F),
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Approaching critical 80% limit',
                style: TextStyle(color: Colors.black87, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageUsageCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC), // Light Blue
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.bar_chart, color: Color(0xFF006064), size: 16),
              SizedBox(width: 8),
              Text(
                'AVERAGE USAGE',
                style: TextStyle(
                  color: Color(0xFF006064),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '61.7',
            style: TextStyle(
              color: Color(0xFF006064),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'kWh per hour avg',
            style: TextStyle(color: Color(0xFF00838F), fontSize: 12),
          ),
          const SizedBox(height: 20),
          Divider(color: const Color(0xFF006064).withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF006064),
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Consistent with 30-day mean',
                style: TextStyle(color: Color(0xFF006064), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUsageEvents() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Usage Events',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              Text(
                'Download CSV',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 3,
                child: Text(
                  'Timestamp',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Event\nSource',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Consumption',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildEventRow(
            'Today,\n10:15 AM',
            'MSEB\nGrid Main',
            true,
            '14.2 kWh',
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildEventRow(
            'Today,\n09:30 AM',
            'Generator\nG1',
            false,
            '8.4 kWh',
            isGreyText: true,
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildEventRow(
            'Today,\n08:45 AM',
            'MSEB\nGrid Main',
            true,
            '12.1 kWh',
          ),
        ],
      ),
    );
  }

  Widget _buildEventRow(
    String time,
    String source,
    bool isMseb,
    String consumption, {
    bool isGreyText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              time,
              style: const TextStyle(fontSize: 11, color: Color(0xFF003366)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 8,
                  color: isMseb
                      ? const Color(0xFF0D47A1)
                      : Colors.grey.shade400,
                ),
                const SizedBox(width: 8),
                Text(
                  source,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF003366),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              consumption,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isGreyText ? Colors.blueGrey : const Color(0xFF0D47A1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyInsight() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF003366), // Deep Navy Blue
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Efficiency Insight',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'Your facility is performing '),
                TextSpan(
                  text: '12% more efficiently ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(text: 'than last month\'s average.\n\n'),
                TextSpan(
                  text:
                      'Proactive Alert: Scheduled maintenance for Generator G1 is recommended in 3 days.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF003366),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'VIEW INSIGHTS REPORT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
