import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/complaint/presentation/provider/user_complaint_provider.dart';
import 'package:poweriot/features/settings/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final void Function()? onTapFunction;
  const DashboardHeaderWidget({super.key, this.onTapFunction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
            theme.colorScheme.primary.withValues(alpha: 0.9),
          ],
        ),
      ),
      padding: .fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              // Lightning icon
              InkWell(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  padding: .all(5),
                  decoration: BoxDecoration(
                    // color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: .circular(18),
                  ),
                  child: Image.asset(logo),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    AppLocale.dashboard.getString(context),
                    style: theme.textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    context.read<SettingsProvider>().userNameStored.toString(),
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  context.read<ComplaintProvider>().fetchComplaintIssue();
                  context.pushNamed(userRaiseComplaintScreen);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: .circle,
                    border: .all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.report_problem_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.width(2)),
              InkWell(
                onTap: () {
                  context.goNamed(userSetting);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: .circle,
                    border: .all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),

              SizedBox(width: AppSizes.width(2)),
              InkWell(
                onTap: onTapFunction,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: .circle,
                    border: .all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1.5)),
        ],
      ),
    );
  }
}
