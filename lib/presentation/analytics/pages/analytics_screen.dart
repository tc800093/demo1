import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// ─────────────────────────────────────────────────────────────
// COLOUR PALETTE  (matches dashboard)
// ─────────────────────────────────────────────────────────────
class _C {
  static const scaffold = Color(0xFFF0F7FF);
  static const accentBlue = Color(0xFF2196F3);
  static const deepBlue = Color(0xFF1565C0);
  static const lightBlue = Color(0xFFB3D9F2);
  static const softBlue = Color(0xFFD6EEFF);
  static const paleBlue = Color(0xFFEAF4FD);
  static const divider = Color(0xFFD0E8FA);
  static const textPrimary = Color(0xFF0D2B4E);
  static const textSecondary = Color(0xFF5A7A9A);
  static const textMuted = Color(0xFF90A8BF);
  static const green = Color(0xFF2E7D32);
  static const greenBg = Color(0xFFE8F5E9);
  static const orange = Color(0xFFE65100);
  static const orangeBg = Color(0xFFFFF3E0);
  static const red = Color(0xFFC62828);
  static const redBg = Color(0xFFFFEBEE);
}

// ─────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────

enum _Period { daily, weekly, monthly }

class _OutageEvent {
  final String date;
  final String startTime;
  final String endTime;
  final String duration;
  final String cause;
  final bool resolved;
  const _OutageEvent({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.cause,
    required this.resolved,
  });
}

class _AnalyticsData {
  // Fuel consumption (litres)
  final List<double> fuelConsumption;
  // Fuel cost (₹)
  final List<double> fuelCost;
  // Bar labels
  final List<String> labels;
  // Summary values
  final double totalFuelLitres;
  final double totalFuelCost;
  final double avgFuelPerDay;
  // MSEB outages
  final List<_OutageEvent> outages;

  const _AnalyticsData({
    required this.fuelConsumption,
    required this.fuelCost,
    required this.labels,
    required this.totalFuelLitres,
    required this.totalFuelCost,
    required this.avgFuelPerDay,
    required this.outages,
  });
}

// ─── MOCK DATA per period ───────────────────────────────────
final _mockData = {
  _Period.daily: _AnalyticsData(
    labels: ['6am', '9am', '12pm', '3pm', '6pm', '9pm'],
    fuelConsumption: [2.4, 3.1, 4.8, 5.2, 3.6, 2.0],
    fuelCost: [192, 248, 384, 416, 288, 160],
    totalFuelLitres: 21.1,
    totalFuelCost: 1688,
    avgFuelPerDay: 21.1,
    outages: [
      _OutageEvent(
        date: 'Today',
        startTime: '08:12',
        endTime: '08:47',
        duration: '35 min',
        cause: 'Fault',
        resolved: true,
      ),
      _OutageEvent(
        date: 'Today',
        startTime: '14:05',
        endTime: '14:18',
        duration: '13 min',
        cause: 'Maint.',
        resolved: true,
      ),
    ],
  ),
  _Period.weekly: _AnalyticsData(
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    fuelConsumption: [18.0, 21.5, 19.2, 24.8, 22.0, 14.5, 9.3],
    fuelCost: [1440, 1720, 1536, 1984, 1760, 1160, 744],
    totalFuelLitres: 129.3,
    totalFuelCost: 10344,
    avgFuelPerDay: 18.5,
    outages: [
      _OutageEvent(
        date: 'Mon',
        startTime: '09:00',
        endTime: '09:45',
        duration: '45 min',
        cause: 'Storm',
        resolved: true,
      ),
      _OutageEvent(
        date: 'Wed',
        startTime: '11:30',
        endTime: '12:10',
        duration: '40 min',
        cause: 'Grid Fault',
        resolved: true,
      ),
      _OutageEvent(
        date: 'Fri',
        startTime: '15:00',
        endTime: '15:20',
        duration: '20 min',
        cause: 'Maint.',
        resolved: true,
      ),
      _OutageEvent(
        date: 'Sat',
        startTime: '22:15',
        endTime: '23:30',
        duration: '1h 15m',
        cause: 'Unknown',
        resolved: false,
      ),
    ],
  ),
  _Period.monthly: _AnalyticsData(
    labels: ['W1', 'W2', 'W3', 'W4'],
    fuelConsumption: [129.3, 142.0, 118.6, 135.4],
    fuelCost: [10344, 11360, 9488, 10832],
    totalFuelLitres: 525.3,
    totalFuelCost: 42024,
    avgFuelPerDay: 16.9,
    outages: [
      _OutageEvent(
        date: '03 Jun',
        startTime: '08:12',
        endTime: '08:47',
        duration: '35 min',
        cause: 'Fault',
        resolved: true,
      ),
      _OutageEvent(
        date: '09 Jun',
        startTime: '11:30',
        endTime: '12:10',
        duration: '40 min',
        cause: 'Grid Fault',
        resolved: true,
      ),
      _OutageEvent(
        date: '14 Jun',
        startTime: '15:00',
        endTime: '15:20',
        duration: '20 min',
        cause: 'Maint.',
        resolved: true,
      ),
      _OutageEvent(
        date: '19 Jun',
        startTime: '22:15',
        endTime: '23:30',
        duration: '1h 15m',
        cause: 'Unknown',
        resolved: false,
      ),
      _OutageEvent(
        date: '24 Jun',
        startTime: '07:00',
        endTime: '09:30',
        duration: '2h 30m',
        cause: 'Storm',
        resolved: true,
      ),
    ],
  ),
};

// ─────────────────────────────────────────────────────────────
// ANALYTICS SCREEN
// ─────────────────────────────────────────────────────────────

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  _Period _period = _Period.daily;

  // Which bar chart tab: fuel consumption or fuel cost
  int _chartTab = 0; // 0 = Fuel Consumption, 1 = Fuel Cost

  // Touched bar index
  int _touchedIndex = -1;

  _AnalyticsData get _data => _mockData[_period]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.scaffold,
      body: Stack(
        children: [
          // Blue header wash
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF1E88E5),
                    Color(0xFF42A5F5),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                    child: Column(
                      children: [
                        _buildPeriodToggle(),
                        const SizedBox(height: 16),
                        _buildSummaryRow(),
                        const SizedBox(height: 16),
                        _buildChartCard(),
                        const SizedBox(height: 16),
                        _buildFuelCostSummaryCard(),
                        const SizedBox(height: 16),
                        _buildOutageSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // APP BAR
  // ──────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POWERIOT',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.bar_chart_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 6),
                  Text(
                    'Analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // PERIOD TOGGLE  Daily / Weekly / Monthly
  // ──────────────────────────────────────
  Widget _buildPeriodToggle() {
    return _LightCard(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: _Period.values.map((p) {
          final selected = _period == p;
          final label = p.name[0].toUpperCase() + p.name.substring(1);
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _period = p;
                _touchedIndex = -1;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: selected ? _C.accentBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: _C.accentBlue.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : _C.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ──────────────────────────────────────
  // SUMMARY ROW (3 KPI cards)
  // ──────────────────────────────────────
  Widget _buildSummaryRow() {
    final outageCount = _data.outages.length;
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            label: 'Total Fuel',
            value: '${_data.totalFuelLitres.toStringAsFixed(1)} L',
            icon: Icons.local_gas_station_outlined,
            color: _C.accentBlue,
            bg: _C.paleBlue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _KpiCard(
            label: 'Fuel Cost',
            value: '₹${_data.totalFuelCost.toStringAsFixed(0)}',
            icon: Icons.currency_rupee_rounded,
            color: _C.orange,
            bg: _C.orangeBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _KpiCard(
            label: 'Outages',
            value: outageCount.toString(),
            icon: Icons.power_off_outlined,
            color: _C.red,
            bg: _C.redBg,
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────
  // CHART CARD (bar chart with tab switch)
  // ──────────────────────────────────────
  Widget _buildChartCard() {
    final isConsumption = _chartTab == 0;
    final values = isConsumption ? _data.fuelConsumption : _data.fuelCost;
    final maxY = (values.reduce((a, b) => a > b ? a : b) * 1.3).ceilToDouble();
    final unit = isConsumption ? 'L' : '₹';
    final barColor = isConsumption ? _C.accentBlue : _C.orange;

    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + tab
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isConsumption ? 'Fuel Consumption' : 'Fuel Cost',
                      style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isConsumption
                          ? 'Litres used per interval'
                          : 'Cost in ₹ per interval',
                      style: const TextStyle(color: _C.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Mini tab
              Container(
                decoration: BoxDecoration(
                  color: _C.paleBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _miniTab('Fuel', 0, barColor),
                    _miniTab('Cost', 1, _C.orange),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bar chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => _C.deepBlue,
                    getTooltipItem: (group, gi, rod, ri) {
                      return BarTooltipItem(
                        '${_data.labels[group.x]}\n',
                        const TextStyle(color: Colors.white70, fontSize: 10),
                        children: [
                          TextSpan(
                            text: '${rod.toY.toStringAsFixed(1)} $unit',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  touchCallback: (ev, resp) {
                    setState(() {
                      if (resp == null ||
                          resp.spot == null ||
                          ev is FlTapUpEvent == false) {
                        if (ev is FlPointerExitEvent) {
                          _touchedIndex = -1;
                        }
                        return;
                      }
                      _touchedIndex = resp.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (v, _) => Text(
                        isConsumption ? '${v.toInt()}L' : '₹${v.toInt()}',
                        style: const TextStyle(
                          color: _C.textMuted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= _data.labels.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _data.labels[idx],
                            style: const TextStyle(
                              color: _C.textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: _C.divider, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(values.length, (i) {
                  final isTouched = i == _touchedIndex;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i],
                        color: isTouched
                            ? _C.deepBlue
                            : barColor.withValues(alpha: 0.85),
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: _C.softBlue.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 14),
          // Average callout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _C.paleBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: barColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  isConsumption
                      ? 'Avg per day: ${_data.avgFuelPerDay.toStringAsFixed(1)} L'
                      : 'Avg cost/day: ₹${(_data.totalFuelCost / (isConsumption ? 1 : (_period == _Period.daily
                                      ? 1
                                      : _period == _Period.weekly
                                      ? 7
                                      : 30))).toStringAsFixed(0)}',
                  style: TextStyle(
                    color: barColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniTab(String label, int idx, Color activeColor) {
    final sel = _chartTab == idx;
    return GestureDetector(
      onTap: () => setState(() {
        _chartTab = idx;
        _touchedIndex = -1;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: sel ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: sel ? Colors.white : _C.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────
  // FUEL COST SUMMARY CARD
  // ──────────────────────────────────────
  Widget _buildFuelCostSummaryCard() {
    final costPerLitre = 80.0; // ₹80/litre
    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _C.orangeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: _C.orange,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Fuel Cost Breakdown',
                style: TextStyle(
                  color: _C.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _costRow(
            'Total Fuel Used',
            '${_data.totalFuelLitres.toStringAsFixed(1)} L',
            _C.accentBlue,
          ),
          _dividerLine(),
          _costRow(
            'Rate per Litre',
            '₹${costPerLitre.toStringAsFixed(0)}',
            _C.textSecondary,
          ),
          _dividerLine(),
          _costRow(
            'Generator Runtime Cost',
            '₹${_data.totalFuelCost.toStringAsFixed(0)}',
            _C.orange,
          ),
          _dividerLine(),
          _costRow(
            'Avg Daily Cost',
            '₹${(_data.totalFuelCost / (_period == _Period.daily
                    ? 1
                    : _period == _Period.weekly
                    ? 7
                    : 30)).toStringAsFixed(0)}',
            _C.deepBlue,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Generator Cost',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                Text(
                  '₹${_data.totalFuelCost.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _costRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _C.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerLine() =>
      const Divider(color: _C.divider, height: 1, thickness: 1);

  // ──────────────────────────────────────
  // MSEB OUTAGE SECTION
  // ──────────────────────────────────────
  Widget _buildOutageSection() {
    final outages = _data.outages;
    final resolved = outages.where((o) => o.resolved).length;
    final unresolved = outages.length - resolved;

    // Total duration in minutes — safely parsed with regex
    int totalMinutes = 0;
    final hourRegex = RegExp(r'(\d+)\s*h');
    final minRegex = RegExp(r'(\d+)\s*m');
    for (final o in outages) {
      final hMatch = hourRegex.firstMatch(o.duration);
      final mMatch = minRegex.firstMatch(o.duration);
      if (hMatch != null) totalMinutes += int.parse(hMatch.group(1)!) * 60;
      if (mMatch != null) totalMinutes += int.parse(mMatch.group(1)!);
    }
    final hh = totalMinutes ~/ 60;
    final mm = totalMinutes % 60;
    final totalDuration = hh > 0 ? '${hh}h ${mm}m' : '${mm}m';

    return Column(
      children: [
        // Outage summary row
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: 'Total Outages',
                value: outages.length.toString(),
                icon: Icons.power_off_outlined,
                color: _C.red,
                bg: _C.redBg,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                label: 'Total Downtime',
                value: totalDuration,
                icon: Icons.timer_off_outlined,
                color: _C.orange,
                bg: _C.orangeBg,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                label: 'Unresolved',
                value: unresolved.toString(),
                icon: Icons.warning_amber_rounded,
                color: unresolved > 0 ? _C.red : _C.green,
                bg: unresolved > 0 ? _C.redBg : _C.greenBg,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Outage log table
        _LightCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _C.redBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.history_toggle_off,
                      color: _C.red,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'MSEB Outage Log',
                      style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _C.paleBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${outages.length} event${outages.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: _C.accentBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Table header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _C.paleBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 2, child: _HeaderCell('Date')),
                    Expanded(flex: 2, child: _HeaderCell('Start')),
                    Expanded(flex: 2, child: _HeaderCell('End')),
                    Expanded(flex: 2, child: _HeaderCell('Duration')),
                    Expanded(flex: 2, child: _HeaderCell('Cause')),
                    Expanded(flex: 3, child: _HeaderCell('Status')),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Rows
              if (outages.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No outages recorded this period.',
                      style: TextStyle(color: _C.textMuted, fontSize: 13),
                    ),
                  ),
                )
              else
                ...outages.asMap().entries.map((e) {
                  final idx = e.key;
                  final o = e.value;
                  return Column(
                    children: [
                      _OutageRow(event: o),
                      if (idx < outages.length - 1)
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: _C.divider,
                        ),
                    ],
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Insight banner
        _InsightBanner(period: _period, data: _data),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: _C.textSecondary,
      fontSize: 10,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _OutageRow extends StatelessWidget {
  final _OutageEvent event;
  const _OutageRow({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              event.date,
              style: const TextStyle(
                color: _C.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              event.startTime,
              style: const TextStyle(color: _C.textSecondary, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              event.endTime,
              style: const TextStyle(color: _C.textSecondary, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              event.duration,
              style: const TextStyle(
                color: _C.orange,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              event.cause,
              style: const TextStyle(color: _C.textSecondary, fontSize: 11),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: event.resolved ? _C.greenBg : _C.orangeBg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                event.resolved ? 'Resolved' : 'Ongoing',
                style: TextStyle(
                  color: event.resolved ? _C.green : _C.orange,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightBanner extends StatelessWidget {
  final _Period period;
  final _AnalyticsData data;
  const _InsightBanner({required this.period, required this.data});

  @override
  Widget build(BuildContext context) {
    final periodLabel = period.name;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Insight Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.white.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 14),
          _insightRow(
            Icons.local_gas_station_outlined,
            'Fuel used this $periodLabel: ${data.totalFuelLitres.toStringAsFixed(1)} L',
          ),
          const SizedBox(height: 8),
          _insightRow(
            Icons.currency_rupee_rounded,
            'Total generator cost: ₹${data.totalFuelCost.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
          _insightRow(
            Icons.power_off_outlined,
            '${data.outages.length} MSEB outage${data.outages.length != 1 ? 's' : ''} recorded this $periodLabel',
          ),
          const SizedBox(height: 8),
          _insightRow(
            Icons.trending_down,
            'Avg daily fuel burn: ${data.avgFuelPerDay.toStringAsFixed(1)} L/day',
          ),
        ],
      ),
    );
  }

  Widget _insightRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 15),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.divider),
        boxShadow: [
          BoxShadow(
            color: _C.lightBlue.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: _C.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LightCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const _LightCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.divider),
        boxShadow: [
          BoxShadow(
            color: _C.lightBlue.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
