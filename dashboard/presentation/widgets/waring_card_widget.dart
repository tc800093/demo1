import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';

class WaringCardWidget extends StatelessWidget {
  final int daysLeft;
  const WaringCardWidget({super.key, required this.daysLeft});

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
          leading: const Icon(Icons.warning_amber_rounded),
          title: Text(
            '${AppLocale.subscription.getString(context)} ${AppLocale.expires.getString(context)} ${daysLeft != 0 ? 'in $daysLeft day${daysLeft > 1 ? 's' : ''}' : 'today'}',
            style: theme.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            AppLocale.subscriptionwarning.getString(context),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
