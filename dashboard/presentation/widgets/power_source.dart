import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class S3PowerSourcesRow extends StatelessWidget {
  final String currentPowerSource;
  final bool hasMIANS;
  final bool hasGenerator;
  final String mainsTodayHours;
  final String generatorTodayHours;
  final void Function()? onTapMains;
  final void Function()? onTapGenerator;

  const S3PowerSourcesRow({
    super.key,
    required this.currentPowerSource,
    this.hasMIANS = false,
    this.hasGenerator = false,
    this.mainsTodayHours = '',
    this.generatorTodayHours = '',
    this.onTapGenerator,
    this.onTapMains,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTapMains,
              child: _MainsPowerCard(
                isOn: currentPowerSource.toLowerCase() == 'mains',
                todayHours: mainsTodayHours,
              ),
            ),
          ),
          SizedBox(width: AppSizes.width(3)),
          Expanded(
            child: InkWell(
              onTap: onTapGenerator,
              child: _GeneratorSummaryCard(
                isOn:
                    currentPowerSource.toLowerCase() == 'generator' ||
                    currentPowerSource.toLowerCase() == 'dg',
                hasGenerator: hasGenerator,
                todayHours: generatorTodayHours,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainsPowerCard extends StatelessWidget {
  final bool isOn;
  final String todayHours;

  const _MainsPowerCard({required this.isOn, required this.todayHours});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: .all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(
          color: isOn
              ? Color(0xFF22C55E).withValues(alpha: 0.2)
              : theme.primaryColor.withValues(alpha: 0.2),
          width: isOn ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? AppStatusColors.success.withValues(alpha: 0.12)
                : theme.primaryColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isOn
                      ? AppStatusColors.success.withValues(alpha: 0.15)
                      : lightGrayBlueColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Image.asset(
                    mainPowerLogo,
                    color: isOn ? AppStatusColors.success : Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: const .symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOn
                      ? AppStatusColors.success
                      : Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOn
                      ? AppLocale.active.getString(context)
                      : AppLocale.offline.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 11,
                    color: isOn
                        ? Colors.white
                        : theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1)),
          Text(
            AppLocale.mainPower.getString(context),
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '3-Phase Supply',
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppSizes.height(1)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 12, color: theme.primaryColor),
                const SizedBox(width: 4),
                Text(
                  'Today: ${todayHours.toString()}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneratorSummaryCard extends StatelessWidget {
  final bool isOn;
  final bool hasGenerator;
  final String todayHours;

  const _GeneratorSummaryCard({
    required this.isOn,
    required this.hasGenerator,
    required this.todayHours,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      padding: .all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(
          color: hasGenerator
              ? (isOn
                    ? const Color(0xFF22C55E).withValues(alpha: 0.2)
                    : theme.primaryColor.withValues(alpha: 0.2))
              : blueGrey.withValues(alpha: 0.3),
          width: isOn ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? AppStatusColors.success.withValues(alpha: 0.12)
                : theme.primaryColor.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isOn
                      ? AppStatusColors.success.withValues(alpha: 0.15)
                      : lightGrayBlueColor.withValues(alpha: 0.3),
                  borderRadius: .circular(10),
                ),
                child: Padding(
                  padding: .all(6.0),
                  child: Image.asset(
                    generatorLogo,
                    color: isOn ? AppStatusColors.success : Colors.grey,
                  ),
                ),
              ),
              Container(
                padding: .symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: hasGenerator
                      ? (isOn
                            ? AppStatusColors.success
                            : Colors.grey.withValues(alpha: 0.2))
                      : blueGrey.withValues(alpha: 0.2),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  hasGenerator
                      ? (isOn
                            ? AppLocale.active.getString(context)
                            : AppLocale.offline.getString(context))
                      : "N/A",
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 11,
                    color: isOn
                        ? Colors.white
                        : theme.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1)),
          Text(
            AppLocale.generator.getString(context),
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hasGenerator ? 'Diesel Engine' : 'N/A',
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: AppSizes.height(1)),
          Container(
            padding: .symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppStatusColors.warning.withValues(alpha: 0.12),
              borderRadius: .circular(8),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                const Icon(
                  Icons.schedule,
                  size: 12,
                  color: AppStatusColors.warning,
                ),
                const SizedBox(width: 4),
                Text(
                  hasGenerator
                      ? 'Today: ${todayHours != '0.0' ? todayHours.toString() : '-'}'
                      : 'Today: -',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppStatusColors.warning,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
