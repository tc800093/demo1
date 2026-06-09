import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/live_summary_card.dart';
import '../widgets/main_power_status_card.dart';
import '../widgets/generator_status_card.dart';
import '../widgets/generator_controls_card.dart';
import '../widgets/dashboard_bottom_nav.dart';
import '../../../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: const [
                    SizedBox(height: 16),
                    LiveSummaryCard(),
                    SizedBox(height: 16),
                    MainPowerStatusCard(),
                    SizedBox(height: 16),
                    GeneratorStatusCard(),
                    SizedBox(height: 16),
                    GeneratorControlsCard(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            DashboardBottomNav(
              currentIndex: _currentNavIndex,
              onTap: (index) => setState(() => _currentNavIndex = index),
            ),
          ],
        ),
      ),
    );
  }
}
