
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';

// ============================================================
// LIGHT BLUE + WHITE THEME COLOR PALETTE
// ============================================================
class _AppColors {
  // Primary blues
  static const Color lightBlue = Color(0xFFB3D9F2);
  static const Color softBlue = Color(0xFFD6EEFF);
  static const Color paleBlue = Color(0xFFEAF4FD);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color deepBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);

  // Backgrounds
  static const Color scaffoldBg = Color(0xFFF0F7FF);

  // Text
  static const Color textPrimary = Color(0xFF0D2B4E);
  static const Color textSecondary = Color(0xFF5A7A9A);
  static const Color textMuted = Color(0xFF90A8BF);

  // Status
  static const Color statusGreen = Color(0xFF2E7D32);
  static const Color statusGreenBg = Color(0xFFE8F5E9);
  static const Color statusOrange = Color(0xFFE65100);
  static const Color statusOrangeBg = Color(0xFFFFF3E0);
  static const Color statusRed = Color(0xFFC62828);
  static const Color statusRedBg = Color(0xFFFFEBEE);

  // Divider
  static const Color divider = Color(0xFFD0E8FA);
}

/// Redesigned Dashboard Screen for PowerIoT
/// Light Blue & White premium IoT dashboard.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  bool _isMsebActive = true;
  bool _generatorNotifications = true;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    AccountType accountType = AccountType.hybrid;
    if (authState is AuthAuthenticated) {
      accountType = authState.accountType;
    }

    return Scaffold(
      backgroundColor: _AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Soft blue gradient top wash
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
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
          // Decorative circle top-right
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(accountType),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: accountType == AccountType.generatorOnly
                        ? _buildGeneratorOnlyView()
                        : accountType == AccountType.msebOnly
                            ? _buildMsebOnlyView()
                            : _buildHybridView(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // APP BAR
  // ──────────────────────────────────────────────
  Widget _buildAppBar(AccountType accountType) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                accountType == AccountType.hybrid
                    ? 'Good afternoon'
                    : 'POWERIOT',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.bolt, color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      letterSpacing: 0.5,
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

  // ──────────────────────────────────────────────
  // MSEB ONLY VIEW
  // ──────────────────────────────────────────────
  Widget _buildMsebOnlyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildActiveSourceBanner(
            'MSEB Grid', Icons.cell_tower, _AppColors.accentBlue),
        const SizedBox(height: 16),
        _buildLiveVoltageCard('231', 'MSEB Grid Status'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildPhaseBox(
                    'R-Phase', 'Normal', _AppColors.statusGreen, _AppColors.statusGreenBg)),
            const SizedBox(width: 10),
            Expanded(
                child: _buildPhaseBox(
                    'Y-Phase', 'Low Volts', _AppColors.statusOrange, _AppColors.statusOrangeBg)),
            const SizedBox(width: 10),
            Expanded(
                child: _buildPhaseBox(
                    'B-Phase', 'Normal', _AppColors.statusGreen, _AppColors.statusGreenBg)),
          ],
        ),
        const SizedBox(height: 16),
        _buildQuickStatsCard(
          title: 'Grid Stats',
          stats: [
            _StatItem("Today's Units", '42.6 kWh', Icons.bolt,
                _AppColors.accentBlue),
            _StatItem('Power Factor', '0.94', Icons.show_chart,
                _AppColors.deepBlue),
            _StatItem(
                'Frequency', '50.1 Hz', Icons.waves, _AppColors.mediumBlue),
          ],
        ),
        const SizedBox(height: 16),
        _buildOutageLog(),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // GENERATOR ONLY VIEW
  // ──────────────────────────────────────────────
  Widget _buildGeneratorOnlyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildActiveSourceBanner(
            'Generator (DG Set)', Icons.memory, _AppColors.statusOrange),
        const SizedBox(height: 16),
        _buildGeneratorTelemetryCard(),
        const SizedBox(height: 16),
        _buildQuickStatsCard(
          title: 'Generator Stats',
          stats: [
            _StatItem(
                'Output Volts', '415V', Icons.bolt, _AppColors.accentBlue),
            _StatItem(
                'Start Count', '4', Icons.refresh, _AppColors.mediumBlue),
            _StatItem('Health', '87%', Icons.favorite, _AppColors.statusRed),
          ],
        ),
        const SizedBox(height: 16),
        _buildGaugesRow(),
        const SizedBox(height: 16),
        _buildGeneratorControls(),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // HYBRID VIEW
  // ──────────────────────────────────────────────
  Widget _buildHybridView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHybridSourceSwitcher(),
        const SizedBox(height: 16),
        if (_isMsebActive) ...[
          _buildLiveVoltageCard('231', 'MSEB Grid Status'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildPhaseBox(
                      'R-Phase', 'Normal', _AppColors.statusGreen, _AppColors.statusGreenBg)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildPhaseBox(
                      'Y-Phase', 'Low Volts', _AppColors.statusOrange, _AppColors.statusOrangeBg)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildPhaseBox(
                      'B-Phase', 'Normal', _AppColors.statusGreen, _AppColors.statusGreenBg)),
            ],
          ),
          const SizedBox(height: 16),
          _buildOutageLog(),
        ] else ...[
          _buildGeneratorTelemetryCard(),
          const SizedBox(height: 16),
          _buildGaugesRow(),
          const SizedBox(height: 16),
          _buildGeneratorControls(),
        ],
      ],
    );
  }

  // ──────────────────────────────────────────────
  // REUSABLE COMPONENTS
  // ──────────────────────────────────────────────

  Widget _buildHybridSourceSwitcher() {
    return _LightCard(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMsebActive = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: _isMsebActive
                      ? _AppColors.accentBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _isMsebActive
                      ? [
                          BoxShadow(
                            color: _AppColors.accentBlue.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cell_tower,
                      color: _isMsebActive
                          ? Colors.white
                          : _AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'MSEB Grid',
                      style: TextStyle(
                        color: _isMsebActive
                            ? Colors.white
                            : _AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMsebActive = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: !_isMsebActive
                      ? _AppColors.statusOrange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: !_isMsebActive
                      ? [
                          BoxShadow(
                            color:
                                _AppColors.statusOrange.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.memory,
                      color: !_isMsebActive
                          ? Colors.white
                          : _AppColors.textSecondary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Generator',
                      style: TextStyle(
                        color: !_isMsebActive
                            ? Colors.white
                            : _AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSourceBanner(
      String title, IconData icon, Color accentColor) {
    return _LightCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Currently Powered by',
                    style: TextStyle(
                        color: _AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    style: const TextStyle(
                        color: _AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
          _buildPulsingIndicator('Live', _AppColors.statusGreen),
        ],
      ),
    );
  }

  Widget _buildLiveVoltageCard(String voltage, String title) {
    return _LightCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _AppColors.softBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bolt,
                    color: _AppColors.accentBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    color: _AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              _buildPulsingIndicator('Connected', _AppColors.statusGreen),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  voltage,
                  style: const TextStyle(
                    color: _AppColors.deepBlue,
                    fontSize: 68,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Live Voltage (V)',
                  style: TextStyle(
                      color: _AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratorTelemetryCard() {
    return _LightCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _AppColors.statusOrangeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.developer_board,
                    color: _AppColors.statusOrange, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Generator Telemetry',
                style: TextStyle(
                    color: _AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              _buildPulsingIndicator('Running', _AppColors.statusOrange),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Runtime Remaining',
                  value: '6h 24m',
                  valueColor: _AppColors.statusGreen,
                  bgColor: _AppColors.statusGreenBg,
                  icon: Icons.timer_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  label: 'Burn Rate',
                  value: '2.4 L/hr',
                  valueColor: _AppColors.statusOrange,
                  bgColor: _AppColors.statusOrangeBg,
                  icon: Icons.local_gas_station_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Fuel Level',
                      style: TextStyle(
                          color: _AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  Text('60%',
                      style: TextStyle(
                          color: _AppColors.accentBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 8,
                  backgroundColor: _AppColors.softBlue,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      _AppColors.accentBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color valueColor,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: valueColor, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
                color: _AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseBox(
      String title, String status, Color statusColor, Color statusBg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: _AppColors.lightBlue.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                color: _AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(
      {required String title, required List<_StatItem> stats}) {
    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: _AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Row(
            children: stats
                .map((e) => Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            right: stats.last == e ? 0 : 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 8),
                        decoration: BoxDecoration(
                          color: _AppColors.paleBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: e.color.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(e.icon, color: e.color, size: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              e.value,
                              style: const TextStyle(
                                  color: _AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              e.label,
                              style: const TextStyle(
                                  color: _AppColors.textMuted, fontSize: 9),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugesRow() {
    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Readings',
            style: TextStyle(
                color: _AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGauge('72%', 'Fuel', _AppColors.accentBlue, 0.72),
              _buildGauge('45 PSI', 'Oil Pressure', _AppColors.statusOrange, 0.55),
              _buildGauge('88°C', 'Temperature', _AppColors.statusRed, 0.75),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGauge(
      String value, String label, Color color, double progress) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 7,
                backgroundColor: _AppColors.softBlue,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
              color: _AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOutageLog() {
    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _AppColors.statusOrangeBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.history,
                    color: _AppColors.statusOrange, size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'Recent Outages',
                style: TextStyle(
                    color: _AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Table header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _AppColors.paleBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('Date',
                        style: TextStyle(
                            color: _AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700))),
                Expanded(
                    flex: 2,
                    child: Text('Duration',
                        style: TextStyle(
                            color: _AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700))),
                Expanded(
                    flex: 2,
                    child: Text('Cause',
                        style: TextStyle(
                            color: _AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700))),
                Expanded(
                    flex: 3,
                    child: Text('Status',
                        style: TextStyle(
                            color: _AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildOutageRow('Mar 12', '45 min', 'Storm', 'Resolved',
              _AppColors.statusGreen, _AppColors.statusGreenBg),
          _buildOutageRow('Mar 09', '12 min', 'Maint.', 'Resolved',
              _AppColors.statusGreen, _AppColors.statusGreenBg),
          _buildOutageRow('Mar 05', '1h 20m', 'Fault', 'Investigating',
              _AppColors.statusOrange, _AppColors.statusOrangeBg),
        ],
      ),
    );
  }

  Widget _buildOutageRow(String date, String duration, String cause,
      String status, Color statusColor, Color statusBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(date,
                  style: const TextStyle(
                      color: _AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600))),
          Expanded(
              flex: 2,
              child: Text(duration,
                  style: const TextStyle(
                      color: _AppColors.textSecondary, fontSize: 12))),
          Expanded(
              flex: 2,
              child: Text(cause,
                  style: const TextStyle(
                      color: _AppColors.textSecondary, fontSize: 12))),
          Expanded(
            flex: 3,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratorControls() {
    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _AppColors.statusRedBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.settings_outlined,
                    color: _AppColors.statusRed, size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'Controls',
                style: TextStyle(
                    color: _AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.stop_circle_outlined, size: 18),
            label: const Text(
              'EMERGENCY STOP',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppColors.statusRed,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              shadowColor: _AppColors.statusRed.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _AppColors.paleBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.notifications_active_outlined,
                        color: _AppColors.accentBlue, size: 18),
                    SizedBox(width: 10),
                    Text(
                      'Notifications',
                      style: TextStyle(
                          color: _AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Switch(
                  value: _generatorNotifications,
                  activeThumbColor: _AppColors.accentBlue,
                  activeTrackColor: _AppColors.lightBlue,
                  inactiveThumbColor: _AppColors.textMuted,
                  inactiveTrackColor: _AppColors.divider,
                  onChanged: (val) =>
                      setState(() => _generatorNotifications = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingIndicator(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _pulseController,
            child: Icon(Icons.circle, color: color, size: 8),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// DATA MODEL
// ──────────────────────────────────────────────
class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _StatItem(this.label, this.value, this.icon, this.color);
}

// ──────────────────────────────────────────────
// LIGHT CARD WIDGET
// ──────────────────────────────────────────────
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
        border: Border.all(color: _AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: _AppColors.lightBlue.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
