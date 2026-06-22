import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/users/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final DateTime? lastUpdate;
  const DashboardHeaderWidget({super.key, required this.lastUpdate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [
            theme.primaryColor,
            theme.primaryColor.withValues(alpha: 0.7),
            theme.primaryColor.withValues(alpha: 0.9),
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
              Container(
                width: 35,
                height: 35,
                padding: .all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: .circular(18),
                ),
                child: Image.asset(logo),
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
                  // Text(
                  //   'Multi-source energy precision monitoring',
                  //   style: TextStyle(
                  //     fontSize: 10,
                  //     color: Colors.white.withValues(alpha:0.75),
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                ],
              ),
              Spacer(),
              // Bell
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
            ],
          ),
          SizedBox(height: AppSizes.height(1.5)),
          // Status row
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              _StatusChip(
                dot: true,
                dotColor: Color(0xFF4ADE80),
                label:
                    '${AppLocale.live.getString(context)} ${AppLocale.status.getString(context)}',
                theme: theme,
              ),
              InkWell(
                onTap: () {
                  context.read<DashboardProvider>().fetchDashboardMethod();
                },
                child: _StatusChip(
                  label:
                      '${AppLocale.last.getString(context)} ${AppLocale.update.getString(context)} ${formatTimeAgo(lastUpdate)} ',
                  icon: Icons.refresh,
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatefulWidget {
  final String label;
  final bool dot;
  final Color? dotColor;
  final IconData? icon;
  final ThemeData theme;

  const _StatusChip({
    required this.label,
    this.dot = false,
    this.dotColor,
    this.icon,
    required this.theme,
  });

  @override
  State<_StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<_StatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.2,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 10, vertical: 5),
      // decoration: BoxDecoration(
      //   color: Colors.white.withValues(alpha: 0.15),
      //   borderRadius: .circular(20),
      //   border: .all(color: Colors.white.withValues(alpha: 0.25)),
      // ),
      child: Row(
        mainAxisSize: .min,
        children: [
          if (widget.dot) ...[
            FadeTransition(
              opacity: _controller,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: widget.dotColor,
                  shape: .circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.dotColor!.withValues(alpha: 0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSizes.width(1)),
          ],
          if (widget.icon != null) ...[
            Icon(widget.icon, color: Colors.white, size: 11),
            SizedBox(width: AppSizes.width(1)),
          ],
          Text(
            widget.label,
            style: widget.theme.textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
