import 'package:flutter/material.dart';
import 'features/dashboard/screens/dashboard_screen_3.dart';
import 'theme/app_theme.dart';

/// The main entry point of the PowerIoT application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PowerIoTApp());
}

/// The root widget of the PowerIoT application.
class PowerIoTApp extends StatelessWidget {
  const PowerIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PowerIoT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardScreen3(),
    );
  }
}
