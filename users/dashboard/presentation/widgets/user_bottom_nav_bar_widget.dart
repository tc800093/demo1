import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';

class UserBottomNavBarWidget extends StatelessWidget {
  final Widget childWidget;
  final int selectedIndex;
  final StatefulNavigationShell navigationShell;
  const UserBottomNavBarWidget({
    super.key,
    required this.childWidget,
    required this.selectedIndex,
    required this.navigationShell,
  });

  void _onNavItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(userHomeScreen);
        break;
      case 1:
        context.goNamed(userAnalytics);
        break;
      case 2:
        context.goNamed(userSetting);
        break;
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    const dashboardIndex = 0;

    if (navigationShell.currentIndex != dashboardIndex) {
      navigationShell.goBranch(dashboardIndex, initialLocation: false);
      return false;
    }

    final shouldExit =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('No'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;

    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _onWillPop(context);
        if (shouldExit && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Padding(padding: .only(bottom: 0), child: childWidget),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          currentIndex: selectedIndex,
          onTap: (index) {
            _onNavItemTap(context, index);
          },
          type: .fixed,
          selectedItemColor: Theme.of(context).colorScheme.surface,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocale.home.getString(context),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: AppLocale.analytics.getString(context),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: AppLocale.profile.getString(context),
            ),
          ],
        ),
      ),
    );
  }
}
