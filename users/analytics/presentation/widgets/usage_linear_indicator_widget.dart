import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class UsageLinearIndicatorWidget extends StatelessWidget {
  const UsageLinearIndicatorWidget({
    super.key,
    required this.colorData,
    required this.indicatorValue,
    required this.percentage,
    required this.title,
  });

  final String title;
  final String percentage;
  final double indicatorValue;
  final Color colorData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              Text(percentage, style: theme.textTheme.labelMedium),
            ],
          ),
          SizedBox(height: AppSizes.height(1)),
          LinearProgressIndicator(
            backgroundColor: colorData.withValues(alpha: 0.4),
            borderRadius: .circular(15),
            color: colorData,
            value: indicatorValue,
          ),
        ],
      ),
    );
  }
}
