import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/widgets/subscription_card_widget.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/click_event.dart';
import 'package:poweriot/features/admin/subscription/presentation/provider/subscription_provider.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_provider.dart';
import 'package:poweriot/features/settings/presentation/widgets/subscripton_plan_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Renders the subscription plan section with a loading skeleton and null safety.
class SubscriptionSectionWidget extends StatelessWidget {
  final UserProvider userProvider;
  final String userId;

  const SubscriptionSectionWidget({
    super.key,
    required this.userProvider,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Loading state for subscription
    if (userProvider.fetchSubscriptionByIDStatus == .loading) {
      return Skeletonizer(
        enabled: true,
        child: SubscriptionCardWidget(
          theme: theme,
          planName: 'Premium Plan',
          expiry: 'dd MMM yyyy',
          status: 'Active',
          amount: '₹0',
        ),
      );
    }

    // No subscription / failed
    if (userProvider.fetchSubscriptionByIDStatus == .failed ||
        userProvider.userSubscriptionModel == null) {
      return Padding(
        padding: .all(8.0),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'No active subscription found.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.height(1.5)),
            FilledButton.icon(
              onPressed: () {
                ClickLogger.logClick(
                  eventName: 'View available subscription plan ',
                  screenName: "Profile Screen",
                  userId: '',
                  buttonName: "Add  plan",
                );
                context
                    .read<SubscriptionProvider>()
                    .fetchSubscriptionListMethod();
                _showSubscriptionPlans(context, userId);
              },
              icon: Icon(Icons.add),
              label: Text('Purchase Plan'),
            ),
          ],
        ),
      );
    }

    // Success — safe to read
    final sub = userProvider.userSubscriptionModel!;
    final expiryStr = sub.expiryDate != null
        ? DateFormat('dd MMM yyyy').format(sub.expiryDate!)
        : 'N/A';
    final startStr = sub.startDate != null
        ? DateFormat('dd MMM yyyy').format(sub.startDate!)
        : 'N/A';
    final isExpired =
        sub.expiryDate != null && sub.expiryDate!.isBefore(DateTime.now());

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: .all(8.0),
          child: SubscriptionCardWidget(
            theme: theme,
            planName: sub.planName?.toString() ?? 'N/A',
            expiry: expiryStr,
            status: isExpired
                ? 'Expired'
                : (sub.status?.toString() ?? 'Active'),
            amount: '₹${sub.amount?.toString() ?? '--'}',
            isExpired: isExpired,
            purchaseDate: startStr,
          ),
        ),
        Padding(
          padding: .all(8.0),
          child: FilledButton.icon(
            onPressed: () {
              ClickLogger.logClick(
                eventName: 'View available subscription plan ',
                screenName: "Profile Screen",
                userId: '',
                buttonName: "Change plan",
              );
              context
                  .read<SubscriptionProvider>()
                  .fetchSubscriptionListMethod();
              _showSubscriptionPlans(context, userId);
            },
            icon: const Icon(Icons.upgrade_outlined),
            label: const Text('Change Plan'),
          ),
        ),
      ],
    );
  }

  void _showSubscriptionPlans(BuildContext context, String userid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SubscriptonPlanWidget(userId: userid),
    );
  }
}
