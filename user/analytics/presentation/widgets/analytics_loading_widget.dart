import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/settings/presentation/widgets/setting_item_card_widget.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/usage_linear_indicator_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnalyticsLoadingWidget extends StatelessWidget {
  const AnalyticsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          SizedBox(height: AppSizes.height(1)),
          SettingItemCardWidget(
            iconData: Icons.data_usage_outlined,
            title:
                '${AppLocale.power.getString(context)} ${AppLocale.comsumption.getString(context)}',
            child: Padding(
              padding: .symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  UsageLinearIndicatorWidget(
                    colorData: Colors.lightBlue,
                    indicatorValue: 0.8,
                    percentage: "100%",
                    title: AppLocale.mainPower.getString(context),
                  ),
                  SizedBox(height: AppSizes.height(2)),
                  UsageLinearIndicatorWidget(
                    colorData: Colors.deepOrange,
                    indicatorValue: 0.2,
                    percentage: "0%",
                    title: AppLocale.generator.getString(context),
                  ),
                ],
              ),
            ),
          ),
          SettingItemCardWidget(
            iconData: Icons.power,
            title:
                "${AppLocale.mainPower.getString(context)} ${AppLocale.outage.getString(context)}",
            child: Padding(
              padding: .symmetric(horizontal: 15, vertical: 15),
              child: Column(
                children: [
                  _buildRowInfoWidget(
                    theme: theme,
                    title: 'Total Outage',
                    value: '2 Times',
                  ),
                  _divider(),
                  _buildRowInfoWidget(
                    theme: theme,
                    title: 'Total Duration',
                    value: '22',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.height(2)),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
    padding: .symmetric(vertical: 10),
    child: Divider(color: Colors.grey, height: 1),
  );

  Widget _buildRowInfoWidget({
    required ThemeData theme,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        Text(value, style: theme.textTheme.labelMedium),
      ],
    );
  }
}
