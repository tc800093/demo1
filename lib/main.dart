import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/auth/bloc/auth_bloc.dart';

/// The main entry point of the PowerIoT application.
/// Initializes Flutter bindings, dependency injection, and starts the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const PowerIoTApp());
}

/// The root widget of the PowerIoT application.
/// Sets up the global [AuthBloc], themes, and GoRouter for navigation.
class PowerIoTApp extends StatelessWidget {
  const PowerIoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'demo ',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: goRouter,
      ),
    );
  }
}
