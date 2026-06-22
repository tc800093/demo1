import 'package:flutter/material.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/subscription/domain/model/subscription_model.dart';
import 'package:poweriot/features/admin/subscription/presentation/widgets/subscription_plan_card_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubscriptionLoadingWidget extends StatelessWidget {
  const SubscriptionLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          SizedBox(height: AppSizes.height(2)),
          Padding(
            padding: .symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    title: "Total Plans",
                    value: "12",
                    icon: Icons.subscriptions,
                    theme: theme,
                  ),
                ),
                SizedBox(width: AppSizes.width(4)),
                Expanded(
                  child: _summaryCard(
                    title: "Active",
                    value: "10",
                    icon: Icons.check_circle,
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.height(1)),

          /// Search
          Padding(
            padding: .symmetric(horizontal: 16),
            child: CustomTextfieldWidget(
              controller: TextEditingController(),
              title: 'search..',
              suffixIconData: Icons.search_outlined,
            ),
          ),
          SizedBox(height: AppSizes.height(2)),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              padding: .symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return SubscriptionPlanCardWidget(plan: SubscriptionModel());
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: .all(16),
        child: Column(
          children: [
            Icon(icon, size: 28, color: theme.primaryColor),
            SizedBox(height: AppSizes.height(0.8)),
            Text(
              value,
              style: theme.textTheme.headlineMedium!.copyWith(
                color: theme.primaryColor,
              ),
            ),
            Text(
              title,
              style: theme.textTheme.titleSmall!.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
