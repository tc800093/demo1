import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/screen3/s3_header.dart';
import '../widgets/screen3/s3_power_sources_row.dart';
import '../widgets/screen3/s3_main_power_card.dart';
import '../widgets/screen3/s3_generator_detail_card.dart';
import '../widgets/screen3/s3_emergency_stop_card.dart';
import '../widgets/screen3/profile_widgets.dart';

class DashboardScreen3 extends StatefulWidget {
  const DashboardScreen3({super.key});

  @override
  State<DashboardScreen3> createState() => _DashboardScreen3State();
}

class _DashboardScreen3State extends State<DashboardScreen3> {
  // 0 = Home (light dashboard), 1 = Analytics, 2 = Sources, 3 = Logs, 4 = Profile
  int _currentView = 0;

  // Whether we are on the light (home) side or dark (profile) side
  bool get _isProfileView => _currentView == 4;

  @override
  void initState() {
    super.initState();
    _updateSystemUI(_currentView);
  }

  void _updateSystemUI(int view) {
    final isDark = view == 4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          isDark ? Brightness.light : Brightness.light,
    ));
  }

  void _onNavTap(int index) {
    setState(() => _currentView = index);
    _updateSystemUI(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isProfileView ? const Color(0xFF0F1117) : const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _currentView == 4
                    ? _ProfileView(key: const ValueKey('profile'))
                    : _HomeView(key: const ValueKey('home')),
              ),
            ),
            _BottomNav(
              currentIndex: _currentView,
              onTap: _onNavTap,
              isProfileView: _isProfileView,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Home / Dashboard View (Light) ───────────────────────────────────────────

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: const [
          S3Header(),
          SizedBox(height: 16),
          S3PowerSourcesRow(),
          SizedBox(height: 16),
          S3MainPowerCard(),
          SizedBox(height: 16),
          S3GeneratorDetailCard(),
          SizedBox(height: 16),
          S3EmergencyStopCard(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── Profile View (Dark) ──────────────────────────────────────────────────────

class _ProfileView extends StatelessWidget {
  const _ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: const [
          ProfileHeader(),
          SizedBox(height: 20),
          UserProfileCard(),
          SizedBox(height: 20),
          MainPowerSourceCard(),
          SizedBox(height: 20),
          GeneratorDetailsCard(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Unified Bottom Navigation ────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isProfileView;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.isProfileView,
  });

  @override
  Widget build(BuildContext context) {
    if (isProfileView) {
      return _DarkBottomNav(currentIndex: currentIndex, onTap: onTap);
    }
    return _LightBottomNav(currentIndex: currentIndex, onTap: onTap);
  }
}

// Light bottom nav (Home, Analytics, Settings)
class _LightBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _LightBottomNav(
      {required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _LightNavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _LightNavItem(
            icon: Icons.bar_chart_rounded,
            label: 'Analytics',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _LightNavItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          // Profile tab to switch to dark view
          _LightNavItem(
            icon: Icons.person_rounded,
            label: 'Profile',
            isActive: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _LightNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _LightNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF2563EB);
    const inactiveColor = Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive ? activeColor : inactiveColor, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dark bottom nav (Dashboard, Sources, Logs, Profile)
class _DarkBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DarkBottomNav(
      {required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D27),
        border: const Border(
            top: BorderSide(color: Color(0xFF2D3748), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Dashboard -> switch back to home
          _DarkNavItem(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            isActive: false,
            onTap: () => onTap(0),
          ),
          _DarkNavItem(
            icon: Icons.bolt_rounded,
            label: 'Sources',
            isActive: false,
            onTap: () => onTap(2),
          ),
          _DarkNavItem(
            icon: Icons.history_rounded,
            label: 'Logs',
            isActive: false,
            onTap: () => onTap(3),
          ),
          _DarkNavItem(
            icon: Icons.person_rounded,
            label: 'Profile',
            isActive: true,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _DarkNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DarkNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFF59E0B);
    const inactiveColor = Color(0xFF64748B);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 14,
          vertical: 8,
        ),
        decoration: isActive
            ? BoxDecoration(
                color: activeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive ? activeColor : inactiveColor,
                size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
