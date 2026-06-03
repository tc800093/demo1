import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart' as di;
import '../../presentation/dashboard/bloc/dashboard_bloc.dart';

import '../../presentation/auth/pages/login_screen.dart';
import '../../presentation/auth/pages/registration_screen.dart';
import '../../presentation/dashboard/pages/dashboard_screen.dart';
import '../../presentation/consumption/pages/consumption_screen.dart';
import '../../presentation/analytics/pages/analytics_screen.dart';
import '../../presentation/settings/pages/settings_screen.dart';

// Private navigators used for the nested stateful shell routes.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorDashboardKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellDashboard',
);
final _shellNavigatorConsumptionKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellConsumption',
);
final _shellNavigatorAnalyticsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellAnalytics',
);
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'shellSettings',
);

/// A wrapper widget that provides the persistent BottomNavigationBar
/// while allowing nested navigation state to be maintained per-tab.
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
            label: 'Dashboard',
            icon: Icon(Icons.dashboard),
          ),
          NavigationDestination(label: 'Consumption', icon: Icon(Icons.bolt)),
          NavigationDestination(
            label: 'Analytics',
            icon: Icon(Icons.bar_chart),
          ),
          NavigationDestination(label: 'Settings', icon: Icon(Icons.settings)),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}

/// The global routing configuration utilizing the `go_router` package.
/// It defines the authentication routes and the main application shell
/// which contains the nested navigation (indexed stack) for the BottomNavigationBar.
final goRouter = GoRouter(
  initialLocation: '/login',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorDashboardKey,
          routes: [
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (_) =>
                      di.sl<DashboardBloc>()..add(LoadDashboardData()),
                  child: const DashboardScreen(),
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorConsumptionKey,
          routes: [
            GoRoute(
              path: '/consumption',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ConsumptionScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAnalyticsKey,
          routes: [
            GoRoute(
              path: '/analytics',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AnalyticsScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
