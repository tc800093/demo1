import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';

/// The primary dashboard of the PowerIoT application.
/// It dynamically renders different UI layouts based on the current user's [AccountType]
/// fetched from the [AuthBloc]. It supports:
/// - Hybrid View: Dual monitoring of both Grid and Generator.
/// - MSEB Only View: Dedicated layout for Grid-only monitoring.
/// - Generator Only View: Dedicated layout for DG Set-only monitoring.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isMsebActive = true;
  bool _generatorNotifications = true;

  @override
  Widget build(BuildContext context) {
    // Read Account Type
    final authState = context.read<AuthBloc>().state;
    AccountType accountType = AccountType.hybrid;
    if (authState is AuthAuthenticated) {
      accountType = authState.accountType;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: _buildAppBar(accountType),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: accountType == AccountType.generatorOnly
            ? _buildGeneratorOnlyView()
            : accountType == AccountType.msebOnly
            ? _buildMsebOnlyView()
            : _buildHybridView(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AccountType accountType) {
    if (accountType == AccountType.generatorOnly ||
        accountType == AccountType.msebOnly) {
      return AppBar(
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'POWERIOT',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.2),
                  width: 2,
                ),
                color: Colors.white,
              ),
              child: IconButton(
                icon: accountType == AccountType.msebOnly
                    ? Stack(
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            color: Colors.blueAccent,
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.settings_outlined,
                        color: Colors.blueAccent,
                      ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      );
    } else {
      return AppBar(
        backgroundColor: const Color(0xFFF4F7FB),
        elevation: 0,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good afternoon',
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
            Row(
              children: [
                const Icon(Icons.bolt, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 8),
                Text(
                  'PowerIoT Dashboard',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.2),
                  width: 2,
                ),
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.blue),
                onPressed: () {},
              ),
            ),
          ),
        ],
      );
    }
  }

  // ==========================================
  // MSEB ONLY VIEW
  // ==========================================
  Widget _buildMsebOnlyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cell_tower,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Currently Powered by',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'MSEB Grid',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade100.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.green, size: 10),
                    SizedBox(width: 6),
                    Text(
                      'Live',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // MSEB Grid Status Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.blueAccent),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'MSEB Grid Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade100.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.wifi, color: Colors.green, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Connected',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    const Text(
                      '231V',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'Live Voltage',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMsebPhaseBox('R-Phase', 'Normal', Colors.green),
                  _buildMsebPhaseBox('Y-Phase', 'Low Voltage', Colors.orange),
                  _buildMsebPhaseBox('B-Phase', 'Normal', Colors.green),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Duration',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Cause',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Status',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildMsebOutageRow(
                      'Mar 12',
                      '45 min',
                      'Storm',
                      'Resolved',
                      true,
                    ),
                    _buildMsebOutageRow(
                      'Mar 09',
                      '12 min',
                      'Maint.',
                      'Resolved',
                      false,
                    ),
                    _buildMsebOutageRow(
                      'Mar 05',
                      '1h 20m',
                      'Fault',
                      'Resolved',
                      true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick Stats Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMsebStatBox(
                      'Today\'s Units',
                      '42.6 kWh',
                      Icons.bolt,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMsebStatBox(
                      'Power Factor',
                      '0.94',
                      Icons.show_chart,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMsebStatBox(
                      'Frequency',
                      '50.1 Hz',
                      Icons.cell_tower,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user_outlined,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Grid Health',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Good',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Alerts & Notifications
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Alerts & Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 16),
              _buildAlertBox(
                'Y-Phase voltage below threshold',
                'Today, 2:14 PM',
                Icons.warning_amber_rounded,
                Colors.orange,
              ),
              const SizedBox(height: 12),
              _buildAlertBox(
                'Last sync completed successfully',
                'Today, 1:58 PM',
                Icons.check_circle_outline,
                Colors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMsebPhaseBox(String title, String status, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                color: color == Colors.orange ? Colors.orange.shade800 : color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMsebOutageRow(
    String date,
    String duration,
    String cause,
    String status,
    bool isWhite,
  ) {
    return Container(
      color: isWhite ? Colors.white : const Color(0xFFF4F8FC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(fontSize: 12, color: Color(0xFF003366)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              duration,
              style: const TextStyle(fontSize: 12, color: Color(0xFF003366)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              cause,
              style: const TextStyle(fontSize: 12, color: Color(0xFF003366)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMsebStatBox(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blueAccent, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBox(String title, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // GENERATOR ONLY VIEW
  // ==========================================
  Widget _buildGeneratorOnlyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.memory, color: Colors.orange),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Currently Powered by',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Generator (DG Set)',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Running',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Generator Telemetry Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.developer_board,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Generator Telemetry',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003366),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Running',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.circle, color: Colors.green, size: 10),
                              SizedBox(width: 6),
                              Text(
                                'Running',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Output Voltage',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '415V',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Start Count',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '4 times',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FA),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Health Score',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.circle, color: Colors.green, size: 10),
                              SizedBox(width: 6),
                              Text(
                                '87%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                  fontSize: 16,
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenGauge(
                    '72%',
                    'Fuel',
                    Icons.water_drop_outlined,
                    Colors.blue,
                  ),
                  _buildGenGauge(
                    '45\nPSI',
                    'Oil Press',
                    Icons.speed,
                    Colors.lightBlue,
                  ),
                  _buildGenGaugeWithPill('88°C', 'Warm', Colors.orange),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Runtime & Fuel Log Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Runtime & Fuel Log',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Runtime Remaining',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                  ),
                  Text(
                    '6h 24m remaining',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.6,
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                color: Colors.greenAccent.shade400,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.orangeAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '2.4 L/hr',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF003366),
                          ),
                        ),
                        Text(
                          'Current burn rate',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    'Log Refuel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Controls',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA3A45),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text(
                    'Emergency Stop',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.notifications_none,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Notifications',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: _generatorNotifications,
                      activeColor: Colors.blueAccent,
                      onChanged: (val) {
                        setState(() => _generatorNotifications = val);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildGenGauge(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 0.72,
                strokeWidth: 8,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF003366),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.blueGrey),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenGaugeWithPill(String value, String pillText, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 0.88,
                strokeWidth: 8,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF003366),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.thermostat, size: 14, color: Colors.orange),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                pillText,
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // HYBRID VIEW
  // ==========================================
  Widget _buildHybridView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildActiveSourceBannerHybrid(),
        const SizedBox(height: 24),
        _buildSectionTitle(Icons.show_chart, 'MSEB Grid Status'),
        const SizedBox(height: 12),
        _buildMSEBCardHybrid(),
        const SizedBox(height: 24),
        _buildSectionTitle(
          Icons.propane_tank_outlined,
          'Generator (DG Set) Telemetry',
        ),
        const SizedBox(height: 12),
        _buildGeneratorCardHybrid(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF003366), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF003366),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveSourceBannerHybrid() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isMsebActive = !_isMsebActive;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _isMsebActive
                        ? Colors.greenAccent.shade400
                        : Colors.amber,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (_isMsebActive ? Colors.green : Colors.orange)
                          .withValues(alpha: 0.3),
                      width: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Currently Powered by',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                    Text(
                      _isMsebActive ? 'MSEB Grid' : 'Generator',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
              ),
              child: Icon(
                _isMsebActive ? Icons.cell_tower : Icons.electric_meter,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMSEBCardHybrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Live Voltage',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _isMsebActive ? '231' : '0',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'V',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_isMsebActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.waves, color: Colors.blueAccent, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Stable',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Offline',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPhaseBoxHybrid(
                'R Phase',
                _isMsebActive ? 'Normal' : 'Off',
                _isMsebActive ? Colors.green : Colors.grey,
              ),
              _buildPhaseBoxHybrid(
                'Y Phase',
                _isMsebActive ? 'Low Voltage' : 'Off',
                _isMsebActive ? Colors.amber : Colors.grey,
              ),
              _buildPhaseBoxHybrid(
                'B Phase',
                _isMsebActive ? 'Normal' : 'Off',
                _isMsebActive ? Colors.green : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Outages',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'End',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Duration',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '14:32',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '15:10',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '38 min',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseBoxHybrid(String title, String status, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: color == Colors.amber ? Colors.orange.shade800 : color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratorCardHybrid() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildGenStatBoxHybrid(
                  'Status',
                  _isMsebActive ? 'Idle' : 'Running',
                  _isMsebActive ? Colors.blueGrey : Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenStatBoxHybrid(
                  'Voltage',
                  _isMsebActive ? '0 V' : '230 V',
                  const Color(0xFF003366),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildGenStatBoxHybrid(
                  'Start Count',
                  _isMsebActive ? '4' : '5',
                  const Color(0xFF003366),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenStatBoxHybrid('Health', '87%', Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircularGaugeHybrid('72%', 'Fuel Level', Colors.blue),
              _buildCircularGaugeHybrid(
                '45\nPSI',
                'Oil Pressure',
                Colors.lightBlue,
              ),
              _buildCircularGaugeHybrid('88°', 'Engine Temp', Colors.orange),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text(
                    'Emergency Stop',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Notifications',
                style: TextStyle(color: Colors.blueGrey, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Switch(
                value: _generatorNotifications,
                activeColor: Colors.blueAccent,
                onChanged: (val) {
                  setState(() => _generatorNotifications = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F8FC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.battery_charging_full,
                      size: 16,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Battery: 94%',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 16,
                  color: Colors.blueGrey.withValues(alpha: 0.3),
                ),
                Row(
                  children: const [
                    Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
                    SizedBox(width: 6),
                    Text(
                      'Runtime: 3h 12m',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenStatBoxHybrid(String label, String value, Color valueColor) {
    bool isPill = label == 'Status';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
          if (isPill)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: valueColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: valueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularGaugeHybrid(String value, String label, Color color) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 0.75, // Just visual representation
                strokeWidth: 8,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xFF003366),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF003366),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
