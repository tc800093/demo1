import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/customer_header_widget.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/devices/presentation/provider/device_provider.dart';
import 'package:poweriot/features/admin/subscription/presentation/provider/subscription_provider.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              CustomerHeaderWidget(
                title: AppLocale.dashboard.getString(context),
                iconData: Icons.person,
                onTapFunction: () {
                  context.goNamed(adminSettingScreen);
                },
              ),

              _buildQuickActions(theme: theme),
              SizedBox(height: AppSizes.height(2)),
              _buildManagement(theme: theme),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagement({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(
            AppLocale.management.getString(context),
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: AppSizes.height(2)),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: .circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildManagementListItem(
                  icon: Icons.people_outline,
                  iconBgColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  iconColor: theme.colorScheme.primary,
                  title: AppLocale.users.getString(context),
                  subtitle:
                      '${AppLocale.manage.getString(context)} ${AppLocale.users.getString(context).toLowerCase()}',
                  showDivider: true,
                  theme: theme,
                  onTapFunction: () {
                    context.goNamed(adminUsersScreen);
                  },
                ),
                _buildManagementListItem(
                  icon: Icons.workspace_premium_rounded,
                  theme: theme,
                  iconBgColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  iconColor: theme.colorScheme.primary,
                  title: AppLocale.subscription.getString(context),
                  subtitle:
                      '${AppLocale.manage.getString(context)} ${AppLocale.subscription.getString(context)}',
                  showDivider: true,
                  onTapFunction: () {
                    context
                        .read<SubscriptionProvider>()
                        .fetchSubscriptionListMethod();
                    context.pushNamed(adminSubsctionListScreen);
                  },
                ),
                _buildManagementListItem(
                  icon: Icons.receipt_long,
                  theme: theme,
                  iconBgColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  iconColor: theme.colorScheme.primary,
                  title:
                      '${AppLocale.transaction.getString(context)} ${AppLocale.history.getString(context)}',
                  subtitle: AppLocale.history.getString(context),
                  showDivider: false,
                  onTapFunction: () {
                    context.pushNamed(adminTransactionHistoryScreen);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementListItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool showDivider,
    required ThemeData theme,
    required void Function()? onTapFunction,
  }) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Column(
        children: [
          ListTile(
            contentPadding: .symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: .circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            title: Text(title, style: theme.textTheme.titleMedium),
            subtitle: Text(subtitle, style: theme.textTheme.titleSmall),
            trailing: Icon(Icons.chevron_right, color: Colors.blueGrey),
            onTap: onTapFunction,
          ),
          if (showDivider)
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.blueGrey,
              indent: 16,
              endIndent: 16,
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActions({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "${AppLocale.quick.getString(context)} ${AppLocale.action.getString(context)}",
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: AppSizes.height(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionItem(
                icon: Icons.person_add_alt_1,
                label: '+ ${AppLocale.users.getString(context)}',
                isPrimary: true,
                theme: theme,
                onTapFunction: () {
                  context.pushNamed(adminAddUserScreen);
                },
              ),
              SizedBox(width: AppSizes.width(4)),
              _buildActionItem(
                icon: Icons.subscriptions_outlined,
                label: '+ ${AppLocale.sub.getString(context)}',
                isPrimary: true,
                theme: theme,
                onTapFunction: () {
                  context.pushNamed(adminAddSubscriptionScreen);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required bool isPrimary,
    required ThemeData theme,
    required void Function()? onTapFunction,
  }) {
    return InkWell(
      onTap: onTapFunction,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isPrimary
                  ? theme.colorScheme.primary
                  : Colors.grey.shade200,
              borderRadius: .circular(16),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: .3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isPrimary ? Colors.white : Colors.blueGrey,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
