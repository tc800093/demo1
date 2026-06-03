import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../auth/bloc/auth_bloc.dart';

/// The settings screen of the PowerIoT application.
/// Allows the user to manage their profile, account credentials,
/// alert preferences (Notification Center), system language, and theme.
/// Also provides the functionality to log out of the current session.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _lowVoltageAlert = true;
  bool _highVoltageAlert = true;
  bool _fuelAlert = true;
  String _selectedAppearance = 'Light';

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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 32),
            _buildAccountCredentials(),
            const SizedBox(height: 24),
            _buildNotificationCenter(),
            const SizedBox(height: 24),
            _buildSystemPreferences(),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
            const SizedBox(height: 16),
            const Text(
              'Version 2.4.0 (Enterprise) • Build #9203',
              style: TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0D47A1), width: 3),
              ),
              child: const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=11',
                ), // Generic placeholder avatar
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003366),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.email_outlined, size: 14, color: Colors.blueGrey),
            SizedBox(width: 6),
            Text(
              'john.doe@energy.io',
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.phone_outlined, size: 14, color: Colors.blueGrey),
            SizedBox(width: 6),
            Text(
              '+1 (555) 000-1234',
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Active Admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCredentials() {
    return _buildSectionCard(
      title: 'Account Credentials',
      icon: Icons.manage_accounts_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Full Name', 'John Doe'),
          const SizedBox(height: 16),
          _buildTextField('Contact Number', '+1 (555) 000-1234'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
          ),
          const Text(
            'SECURITY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.restore, color: Color(0xFF0D47A1), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Update Password',
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Color(0xFF0D47A1), size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            value,
            style: const TextStyle(color: Color(0xFF003366), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCenter() {
    return _buildSectionCard(
      title: 'Notification Center',
      icon: Icons.notifications_active_outlined,
      child: Column(
        children: [
          _buildSwitchItem(
            'Low Voltage',
            'Alert when voltage drops below 190V',
            _lowVoltageAlert,
            (val) => setState(() => _lowVoltageAlert = val),
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 32),
          _buildSwitchItem(
            'High Voltage',
            'Alert when voltage exceeds 250V',
            _highVoltageAlert,
            (val) => setState(() => _highVoltageAlert = val),
          ),
          const Divider(color: Color(0xFFE2E8F0), height: 32),
          _buildSwitchItem(
            'Low Fuel Level',
            'Alert when generator fuel is below 15%',
            _fuelAlert,
            (val) => setState(() => _fuelAlert = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: const Color(0xFF0D47A1),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSystemPreferences() {
    return _buildSectionCard(
      title: 'System Preferences',
      icon: Icons.settings_outlined,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Language',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'English (US)',
                  style: TextStyle(fontSize: 12, color: Color(0xFF003366)),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    _buildSegmentButton('Light', Icons.wb_sunny_outlined),
                    _buildSegmentButton('Dark', Icons.nights_stay_outlined),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String label, IconData icon) {
    bool isSelected = _selectedAppearance == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedAppearance = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? const Color(0xFF0D47A1) : Colors.blueGrey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF0D47A1) : Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(LogoutRequested());
          context.go('/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC62828), // Deep Red
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
        ),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
              bottom: 16,
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF003366), size: 20),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
