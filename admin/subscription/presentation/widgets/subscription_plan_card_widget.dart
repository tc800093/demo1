import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/subscription/domain/model/subscription_model.dart';

class SubscriptionPlanCardWidget extends StatelessWidget {
  final SubscriptionModel plan;
  const SubscriptionPlanCardWidget({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: .only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: Padding(
        padding: .all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(child: Icon(Icons.workspace_premium)),
                SizedBox(width: AppSizes.width(3)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        plan.planName.toString(),
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      Text(
                        "${plan.amount.toString()} • ${plan.durationDays.toString()} Days",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: .symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: plan.active == true
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: .circular(20),
                  ),
                  child: Text(plan.active == true ? "Active" : "Inactive"),
                ),
              ],
            ),

            Divider(height: AppSizes.height(4)),

            Row(
              mainAxisAlignment: .end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.pushNamed(adminAddSubscriptionScreen, extra: plan);
                  },
                  icon: Icon(Icons.edit),
                  label: Text(
                    "Edit",
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontWeight: .bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.width(2)),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: Icon(Icons.delete),
                //   label: Text(
                //     "Delete",
                //     style: theme.textTheme.bodyLarge!.copyWith(
                //       fontWeight: .bold,
                //       color: theme.primaryColor,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
