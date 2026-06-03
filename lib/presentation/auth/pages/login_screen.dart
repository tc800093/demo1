import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';

/// The initial authentication screen of the PowerIoT application.
/// Provides mock authentication flows allowing the user to log in as
/// different Account Types (Hybrid, MSEB Only, Generator Only) to
/// experience the dynamic dashboard UI.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F4F8), Color(0xFFD9E2EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.bolt,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'PowerIoT',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  'Premium Energy Monitoring',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 64),
                _buildLoginButton(
                  context,
                  'Login as Hybrid User',
                  AccountType.hybrid,
                  Icons.merge_type,
                ),
                const SizedBox(height: 16),
                _buildLoginButton(
                  context,
                  'Login as MSEB Only',
                  AccountType.msebOnly,
                  Icons.grid_on,
                ),
                const SizedBox(height: 16),
                _buildLoginButton(
                  context,
                  'Login as Generator Only',
                  AccountType.generatorOnly,
                  Icons.electric_meter,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
    String label,
    AccountType type,
    IconData icon,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<AuthBloc>().add(LoginRequested(type));
        context.go('/dashboard');
      },
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }
}
