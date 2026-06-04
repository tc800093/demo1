import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth/bloc/auth_bloc.dart';

// ─────────────────────────────────────────────────
// COLOURS
// ─────────────────────────────────────────────────
class _C {
  static const scaffold = Color(0xFFF0F7FF);
  static const accentBlue = Color(0xFF2196F3);
  static const paleBlue = Color(0xFFEAF4FD);
  static const softBlue = Color(0xFFD6EEFF);
  static const lightBlue = Color(0xFFB3D9F2);
  static const divider = Color(0xFFD0E8FA);
  static const textPrimary = Color(0xFF0D2B4E);
  static const textSecondary = Color(0xFF5A7A9A);
  static const textMuted = Color(0xFF90A8BF);
  static const red = Color(0xFFC62828);
}

/// Redesigned Settings Screen – light blue & white theme.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _lowVoltageAlert = true;
  bool _highVoltageAlert = true;
  bool _fuelAlert = true;
  bool _outageNotify = true;
  String _selectedAppearance = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.scaffold,
      body: Stack(
        children: [
          // Blue gradient header
          Positioned(
            top: 0, left: 0, right: 0, height: 220,
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
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Column(
                      children: [
                        _buildProfileCard(context),
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          icon: Icons.manage_accounts_outlined,
                          title: 'Account Details',
                          child: _buildAccountDetails(),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          icon: Icons.notifications_active_outlined,
                          title: 'Notification Center',
                          child: _buildNotifications(),
                        ),
                        const SizedBox(height: 16),
                        _buildSectionCard(
                          icon: Icons.tune_outlined,
                          title: 'System Preferences',
                          child: _buildSystemPreferences(),
                        ),
                        const SizedBox(height: 24),
                        _buildLogoutButton(context),
                        const SizedBox(height: 16),
                        const Text(
                          'Version 2.4.0 (Enterprise)  •  Build #9203',
                          style: TextStyle(
                              color: _C.textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
                  Icon(Icons.settings_outlined, color: Colors.white, size: 22),
                  SizedBox(width: 6),
                  Text('Settings',
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
  // PROFILE CARD
  // ──────────────────────────────────
  Widget _buildProfileCard(BuildContext context) {
    return _LightCard(
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/settings/update-profile'),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.accentBlue, width: 2.5),
                  ),
                  child: const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _C.accentBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('John Doe',
                    style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                const Text('john.doe@energy.io',
                    style: TextStyle(color: _C.textSecondary, fontSize: 12)),
                const SizedBox(height: 3),
                const Text('+1 (555) 000-1234',
                    style: TextStyle(color: _C.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _C.accentBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Active Admin',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _C.textMuted),
        ],
      ),
    );
  }

  // ──────────────────────────────────
  // ACCOUNT DETAILS
  // ──────────────────────────────────
  Widget _buildAccountDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoField(Icons.person_outline, 'Full Name', 'John Doe'),
        const SizedBox(height: 12),
        _infoField(Icons.phone_outlined, 'Contact', '+1 (555) 000-1234'),
        const SizedBox(height: 16),
        const _SectionLabel('SECURITY'),
        const SizedBox(height: 10),
        _tappableRow(
          icon: Icons.lock_outline_rounded,
          label: 'Update Password',
          onTap: () {},
          color: _C.accentBlue,
          bg: _C.paleBlue,
        ),
      ],
    );
  }

  Widget _infoField(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.paleBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: _C.accentBlue, size: 16),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: _C.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tappableRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required Color bg,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
            ),
            Icon(Icons.chevron_right, color: color, size: 18),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────
  // NOTIFICATIONS
  // ──────────────────────────────────
  Widget _buildNotifications() {
    return Column(
      children: [
        _switchRow(
          icon: Icons.flash_off_outlined,
          title: 'Low Voltage',
          subtitle: 'Alert when voltage drops below 190V',
          value: _lowVoltageAlert,
          onChanged: (v) => setState(() => _lowVoltageAlert = v),
        ),
        _divider(),
        _switchRow(
          icon: Icons.flash_on_outlined,
          title: 'High Voltage',
          subtitle: 'Alert when voltage exceeds 250V',
          value: _highVoltageAlert,
          onChanged: (v) => setState(() => _highVoltageAlert = v),
        ),
        _divider(),
        _switchRow(
          icon: Icons.local_gas_station_outlined,
          title: 'Low Fuel Level',
          subtitle: 'Alert when generator fuel is below 15%',
          value: _fuelAlert,
          onChanged: (v) => setState(() => _fuelAlert = v),
        ),
        _divider(),
        _switchRow(
          icon: Icons.power_off_outlined,
          title: 'MSEB Outage',
          subtitle: 'Notify when a grid outage is detected',
          value: _outageNotify,
          onChanged: (v) => setState(() => _outageNotify = v),
        ),
      ],
    );
  }

  Widget _switchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: value ? _C.paleBlue : const Color(0xFFF5F5F5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: value ? _C.accentBlue : _C.textMuted, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      color: _C.textSecondary, fontSize: 11)),
            ],
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: _C.accentBlue,
          activeTrackColor: _C.softBlue,
          inactiveThumbColor: _C.textMuted,
          inactiveTrackColor: _C.divider,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: _C.divider, height: 1),
      );

  // ──────────────────────────────────
  // SYSTEM PREFERENCES
  // ──────────────────────────────────
  Widget _buildSystemPreferences() {
    return Column(
      children: [
        // Language row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.language_outlined,
                    color: _C.accentBlue, size: 16),
                SizedBox(width: 10),
                Text('Language',
                    style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.paleBlue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.divider),
              ),
              child: const Text('English (US)',
                  style: TextStyle(
                      color: _C.accentBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: _C.divider, height: 1),
        const SizedBox(height: 14),
        // Appearance toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.palette_outlined,
                    color: _C.accentBlue, size: 16),
                SizedBox(width: 10),
                Text('Appearance',
                    style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _C.paleBlue,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.divider),
              ),
              child: Row(
                children: [
                  _appearanceChip('Light', Icons.wb_sunny_outlined),
                  _appearanceChip('Dark', Icons.nights_stay_outlined),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: _C.divider, height: 1),
        const SizedBox(height: 14),
        // Units row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.straighten_outlined,
                    color: _C.accentBlue, size: 16),
                SizedBox(width: 10),
                Text('Units',
                    style: TextStyle(
                        color: _C.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.paleBlue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.divider),
              ),
              child: const Text('Metric (kWh, L)',
                  style: TextStyle(
                      color: _C.accentBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _appearanceChip(String label, IconData icon) {
    final sel = _selectedAppearance == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedAppearance = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: sel ? _C.accentBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          boxShadow: sel
              ? [BoxShadow(
                  color: _C.accentBlue.withValues(alpha: 0.3),
                  blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 13,
                color: sel ? Colors.white : _C.textSecondary),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    color: sel ? Colors.white : _C.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────
  // SECTION CARD WRAPPER
  // ──────────────────────────────────
  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return _LightCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              color: _C.paleBlue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _C.accentBlue.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: _C.accentBlue, size: 16),
                ),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        color: _C.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const Divider(color: _C.divider, height: 1),
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────
  // LOGOUT BUTTON
  // ──────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(LogoutRequested());
          context.go('/login');
        },
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Logout',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _C.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 2,
          shadowColor: _C.red.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            color: _C.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5),
      );
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
              offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}
