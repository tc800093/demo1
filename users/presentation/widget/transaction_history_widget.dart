import 'package:flutter/material.dart';
import 'package:poweriot/core/common/widgets/subscription_card_widget.dart';
import 'package:poweriot/core/common/widgets/transaction_card_widget.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/transactions/presentation/provider/transaction_provider.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Renders the list of IoT devices belonging to the user, each expanded to
/// show its available power sources (generator / mains / both).
///
/// Shows a shimmer skeleton while [UserDeviceProvider.fetchSourceStatus] is loading.

class TransactionHistoryWidget extends StatelessWidget {
  final String userId;
  const TransactionHistoryWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TransactionProvider>(
      builder: (context, tp, _) {
        // Loading skeleton
        if (tp.userHistoryStats == .loading) {
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

        // Error / empty state
        if (tp.userHistoryStats == .failed ||
            tp.userTransactionHisotry.isEmpty) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'No transaction found for this customer.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.height(1.5)),
            ],
          );
        }

        // Device list
        return Column(
          children: [
            SizedBox(height: AppSizes.height(1)),
            ...tp.userTransactionHisotry.map(
              (history) => TransactionCardWidget(
                theme: theme,
                planName: history.planName?.toString() ?? 'N/A',
                amount: '₹${history.paidAmount?.toString() ?? '--'}',
                transactionId: history.transactionId.toString(),
                purchaseDate:
                    '${history.transactionDate!.day}/${history.transactionDate!.month}/${history.transactionDate!.year}',
              ),
            ),
          ],
        );
      },
    );
  }
}
