import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// ─────────────────────────────────────────────────
// COLOURS  (shared palette)
// ─────────────────────────────────────────────────
class _C {
  static const scaffold = Color(0xFFF0F7FF);
  static const accentBlue = Color(0xFF2196F3);
  static const deepBlue = Color(0xFF1565C0);
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
}

// ─────────────────────────────────────────────────
// MOCK DATA
// ─────────────────────────────────────────────────
const _dailyData = [42.0, 55.0, 48.0, 61.0, 70.0, 38.0, 29.0];
const _weeklyData = [310.0, 340.0, 295.0, 360.0, 380.0, 250.0, 180.0];
const _monthlyData = [1200.0, 1350.0, 1180.0, 1420.0];
const _yearlyData = [14200.0, 15800.0, 13900.0, 16500.0,
                     15100.0, 14700.0, 16000.0, 17200.0,
                     15500.0, 14800.0, 13600.0, 12900.0];

const _dailyLabels   = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _weeklyLabels  = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7'];
const _monthlyLabels = ['Jan–Mar', 'Apr–Jun', 'Jul–Sep', 'Oct–Dec'];
const _yearlyLabels  = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {
  String _timeframe = 'Daily';
  String _source = 'Combined';
  int _touchedIndex = -1;

  List<double> get _values => switch (_timeframe) {
        'Weekly' => _weeklyData,
        'Monthly' => _monthlyData,
        'Yearly' => _yearlyData,
        _ => _dailyData,
      };

  List<String> get _labels => switch (_timeframe) {
        'Weekly' => _weeklyLabels,
        'Monthly' => _monthlyLabels,
        'Yearly' => _yearlyLabels,
        _ => _dailyLabels,
      };

  String get _unit => 'kWh';

  double get _total => _values.reduce((a, b) => a + b);
  double get _average => _total / _values.length;
  double get _peak => _values.reduce((a, b) => a > b ? a : b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.scaffold,
      body: Stack(
        children: [
          // Blue gradient header
          Positioned(
            top: 0, left: 0, right: 0, height: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
                ),
              ),
            ),
          ),
          Positioned(
            top: -60, right: -60,
            child: Container(
              width: 200, height: 200,
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
                        _buildFiltersCard(),
                        const SizedBox(height: 16),
                        _buildSummaryRow(),
                        const SizedBox(height: 16),
                        _buildChartCard(),
                        const SizedBox(height: 16),
                        _buildTrendRow(),
                        const SizedBox(height: 16),
                        _buildSourceBreakdown(),
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

  // ──────────────────────────────────
  // APP BAR
  // ──────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('POWERIOT',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8)),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.bolt, color: Colors.white, size: 22),
                  SizedBox(width: 6),
                  Text('Consumption',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 24)),
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

  // ──────────────────────────────────
  // FILTERS CARD
  // ──────────────────────────────────
  Widget _buildFiltersCard() {
    return _LightCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // Period toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _C.paleBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((tf) {
                final sel = _timeframe == tf;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _timeframe = tf;
                      _touchedIndex = -1;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: sel ? _C.accentBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: sel
                            ? [BoxShadow(
                                color: _C.accentBlue.withValues(alpha: 0.3),
                                blurRadius: 8, offset: const Offset(0, 3))]
                            : [],
                      ),
                      child: Text(tf,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: sel ? Colors.white : _C.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Source dropdown row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.electrical_services_outlined,
                      color: _C.accentBlue, size: 16),
                  SizedBox(width: 6),
                  Text('Data Source',
                      style: TextStyle(
                          color: _C.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _C.paleBlue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _source,
                    isDense: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: _C.accentBlue, size: 18),
                    style: const TextStyle(
                        color: _C.accentBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 13),
                    items: ['Combined', 'MSEB', 'Generator']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _source = v);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────
  // SUMMARY KPI ROW
  // ──────────────────────────────────
  Widget _buildSummaryRow() {
    return Row(
      children: [
        Expanded(child: _StatCard(
          label: 'Total',
          value: '${_total.toStringAsFixed(0)} $_unit',
          icon: Icons.bolt,
          color: _C.accentBlue,
          bg: _C.paleBlue,
        )),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(
          label: 'Average',
          value: '${_average.toStringAsFixed(1)} $_unit',
          icon: Icons.analytics_outlined,
          color: _C.green,
          bg: _C.greenBg,
        )),
        const SizedBox(width: 10),
        Expanded(child: _StatCard(
          label: 'Peak',
          value: '${_peak.toStringAsFixed(0)} $_unit',
          icon: Icons.trending_up,
          color: _C.orange,
          bg: _C.orangeBg,
        )),
      ],
    );
  }

  // ──────────────────────────────────
  // BAR CHART CARD
  // ──────────────────────────────────
  Widget _buildChartCard() {
    final maxY = (_peak * 1.3).ceilToDouble();
    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _C.softBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bar_chart_rounded,
                    color: _C.accentBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Consumption Overview',
                        style: TextStyle(
                            color: _C.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    Text('$_timeframe • $_source',
                        style: const TextStyle(
                            color: _C.textMuted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => _C.deepBlue,
                    getTooltipItem: (group, gi, rod, ri) => BarTooltipItem(
                      '${_labels[group.x]}\n',
                      const TextStyle(color: Colors.white70, fontSize: 10),
                      children: [
                        TextSpan(
                          text: '${rod.toY.toStringAsFixed(1)} $_unit',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  touchCallback: (ev, resp) {
                    setState(() {
                      if (ev is FlPointerExitEvent) {
                        _touchedIndex = -1;
                      } else if (resp?.spot != null) {
                        _touchedIndex = resp!.spot!.touchedBarGroupIndex;
                      }
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: const TextStyle(
                            color: _C.textMuted, fontSize: 9),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= _labels.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(_labels[i],
                              style: const TextStyle(
                                  color: _C.textSecondary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600)),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: _C.divider, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_values.length, (i) {
                  final touched = i == _touchedIndex;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: _values[i],
                        gradient: touched
                            ? null
                            : const LinearGradient(
                                colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                        color: touched ? _C.deepBlue : null,
                        width: _values.length > 8 ? 14 : 22,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6)),
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
        ],
      ),
    );
  }

  // ──────────────────────────────────
  // TREND ROW
  // ──────────────────────────────────
  Widget _buildTrendRow() {
    return _LightCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.trending_down, color: _C.green, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 13, color: _C.textSecondary),
                children: [
                  TextSpan(
                      text: '4.2% lower ',
                      style: TextStyle(
                          color: _C.green, fontWeight: FontWeight.w800)),
                  TextSpan(text: 'than the previous period. '),
                  TextSpan(
                      text: 'Keep it up!',
                      style: TextStyle(
                          color: _C.textPrimary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────
  // SOURCE BREAKDOWN
  // ──────────────────────────────────
  Widget _buildSourceBreakdown() {
    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _C.paleBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.pie_chart_outline_rounded,
                    color: _C.accentBlue, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Source Breakdown',
                  style: TextStyle(
                      color: _C.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 16),
          _sourceRow('MSEB Grid', '68%', _C.accentBlue, 0.68),
          const SizedBox(height: 12),
          _sourceRow('Generator', '32%', _C.orange, 0.32),
          const SizedBox(height: 14),
          const Divider(color: _C.divider, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Grid Reliability',
                  style: TextStyle(
                      color: _C.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Text('94.3%',
                  style: TextStyle(
                      color: _C.accentBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sourceRow(String label, String pct, Color color, double frac) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(label,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            Text(pct,
                style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: frac,
            minHeight: 7,
            backgroundColor: _C.softBlue,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0E8FA)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFB3D9F2).withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2)),
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
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF90A8BF), fontSize: 10),
              textAlign: TextAlign.center),
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
        border: Border.all(color: const Color(0xFFD0E8FA)),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFB3D9F2).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}
