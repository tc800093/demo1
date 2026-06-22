import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/subscription/presentation/provider/subscription_provider.dart';
import 'package:poweriot/features/admin/subscription/presentation/widgets/subscription_loading_widget.dart';
import 'package:poweriot/features/admin/subscription/presentation/widgets/subscription_plan_card_widget.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';

TextEditingController searchController = TextEditingController();

class SubscriptionListScreen extends StatelessWidget {
  const SubscriptionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: V3AppBarWidget(
        title:
            '${AppLocale.subscription.getString(context)} ${AppLocale.plan.getString(context)}',
        accountType: "2",
        userName: "",
      ),
      floatingActionButtonLocation: .startFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(adminAddSubscriptionScreen);
        },
        icon: Icon(Icons.add),
        label: Text(
          '${AppLocale.add.getString(context)} ${AppLocale.plan.getString(context)}',
        ),
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, planProvider, child) {
          if (planProvider.fetchStatus == .loading) {
            return SubscriptionLoadingWidget();
          }
          if (planProvider.fetchStatus == .failed) {
            return Center(
              child: Column(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                children: [
                  SizedBox(height: AppSizes.height(2)),
                  Text(planProvider.message.toString(), textAlign: .center),
                ],
              ),
            );
          }
          if (planProvider.fetchStatus == .success) {
            return Column(
              children: [
                SizedBox(height: AppSizes.height(2)),
                Padding(
                  padding: .symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          title:
                              "${AppLocale.total.getString(context)} ${AppLocale.plan.getString(context)}",
                          value: planProvider.totalPlans.toString().toString(),
                          icon: Icons.subscriptions,
                          theme: theme,
                        ),
                      ),
                      SizedBox(width: AppSizes.width(4)),
                      Expanded(
                        child: _summaryCard(
                          title: "${AppLocale.active.getString(context)}",
                          value: planProvider.activePlan.toString(),
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
                    controller: searchController,
                    onChangedFunction: (v) {
                      planProvider.searchSubscriptionPlan(
                        searchController.text.toString(),
                      );
                    },
                    title: '${AppLocale.search.getString(context)}..',
                    suffixIconData: Icons.search_outlined,
                  ),
                ),
                SizedBox(height: AppSizes.height(2)),
                Expanded(
                  child: planProvider.fetchStatus == .success
                      ? ListView.builder(
                          itemCount: planProvider.subscriptionList.length,
                          padding: .symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final plan = planProvider.subscriptionList[index];
                            return SubscriptionPlanCardWidget(plan: plan);
                          },
                        )
                      : SizedBox.shrink(),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
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
