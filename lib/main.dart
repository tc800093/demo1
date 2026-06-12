import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:poweriot/dashboard_screen.dart';
import 'package:poweriot/login_screen.dart';
import 'package:poweriot/login_screen_2.dart';
import 'firebase_options.dart';

/// The main entry point of the PowerIoT application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: DashboardScreen(),
    );
  }
}
