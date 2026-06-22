import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class AdminHomeCardWidget extends StatelessWidget {
  const AdminHomeCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  onTapFunction: () {
                    context.goNamed(adminUsersScreen);
                  },
                  iconData: Icons.group_add,
                  title: 'Users',
                  count: "30 users",
                ),
              ),
              SizedBox(width: AppSizes.width(3)),
              Expanded(
                child: _SummaryCard(
                  onTapFunction: () {
                    context.pushNamed(adminAllDeviceScreen);
                  },
                  iconData: Icons.device_hub,
                  title: 'Devices',
                  count: '25 Devices',
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(2)),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  onTapFunction: () {},
                  iconData: Icons.workspace_premium,
                  title: 'Subscriptons',
                  count: "3 plan",
                ),
              ),
              SizedBox(width: AppSizes.width(3)),
              Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final void Function()? onTapFunction;
  final IconData iconData;
  final String title;
  final String count;

  _SummaryCard({
    required this.onTapFunction,
    required this.iconData,
    required this.title,
    required this.count,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        padding: .all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: .circular(14),
          border: .all(color: theme.primaryColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: .circular(9),
                  ),
                  child: Icon(iconData),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: theme.textTheme.titleMedium),
            SizedBox(height: AppSizes.height(0.1)),
            Text(count, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
