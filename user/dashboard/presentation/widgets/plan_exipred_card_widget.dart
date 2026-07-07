import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';

class PlanExipredCardWidget extends StatelessWidget {
  const PlanExipredCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: .symmetric(horizontal: 8, vertical: 2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: .circular(15),
          side: BorderSide(color: blueGrey),
        ),
        child: ListTile(
          onTap: () {
            context.goNamed(userSetting);
          },
          leading: Icon(Icons.dangerous_rounded, color: Colors.red),
          title: Text(
            'Your subscription has expired.',
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Please renew to continue monitoring your devices.',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
