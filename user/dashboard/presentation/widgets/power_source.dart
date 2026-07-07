import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class S3PowerSourcesRow extends StatelessWidget {
  final String currentPowerSource;
  final bool hasMseb;
  final bool hasGenerator;
  final void Function()? onTapMains;
  final void Function()? onTapGenerator;
  const S3PowerSourcesRow({
    super.key,
    required this.currentPowerSource,
    this.hasMseb = false,
    this.hasGenerator = false,
    this.onTapGenerator,
    this.onTapMains,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // if (hasMseb)
          Expanded(
            child: InkWell(
              onTap: onTapMains,
              child: _MainsPowerCard(
                isOn: currentPowerSource.toLowerCase() == 'mains',
              ),
            ),
          ),
          // if (hasMseb && hasGenerator)
          SizedBox(width: AppSizes.width(3)),
          // if (hasGenerator)
          Expanded(
            child: InkWell(
              onTap: onTapGenerator,
              child: _GeneratorSummaryCard(
                isOn:
                    currentPowerSource.toLowerCase() == 'generator' ||
                    currentPowerSource.toLowerCase() == 'dg',
                hasGenerator: hasGenerator,
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
  const _MainsPowerCard({required this.isOn});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(14),
        border: .all(
          color: isOn
              ? Color(0xFFBBF7D0)
              : theme.primaryColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? AppStatusColors.success.withValues(alpha: 0.1)
                : theme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
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
                  color: lightGrayBlueColor.withValues(alpha: 0.2),
                  borderRadius: .circular(9),
                ),
                child: Image.asset(
                  mainPowerLogo,
                  color: isOn ? AppStatusColors.success : null,
                ),
              ),
              Container(
                padding: .symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOn ? AppStatusColors.success : lightGrayBlueColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOn
                      ? AppLocale.active.getString(context)
                      : AppLocale.offline.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 12,
                    color: isOn ? Colors.white : Colors.black,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1)),
          Text(
            AppLocale.mainPower.getString(context),
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: AppSizes.height(0.1)),
          Text('3-Phase', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _GeneratorSummaryCard extends StatelessWidget {
  final bool isOn;
  final bool hasGenerator;
  const _GeneratorSummaryCard({required this.isOn, required this.hasGenerator});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(14),
        border: .all(
          color: hasGenerator
              ? isOn
                    ? const Color(0xFFBBF7D0)
                    : theme.primaryColor.withValues(alpha: 0.3)
              : blueGrey,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? AppStatusColors.success.withValues(alpha: 0.1)
                : theme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
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
                  // color: isOn
                  color: Colors.white,
                  //     ? const Color(0xFFDCFCE7)
                  //     : theme.primaryColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Image.asset(
                  generatorLogo,
                  color: isOn ? AppStatusColors.success : null,
                ),
              ),
              Container(
                padding: .symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOn ? AppStatusColors.success : lightGrayBlueColor,
                  borderRadius: .circular(20),
                ),
                child: Text(
                  hasGenerator
                      ? isOn
                            ? AppLocale.active.getString(context)
                            : AppLocale.offline.getString(context)
                      : "N/A",
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 12,
                    color: isOn ? Colors.white : Colors.black,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1.2)),
          Text(
            AppLocale.generator.getString(context),
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: AppSizes.height(0.1)),
          Text(
            hasGenerator ? 'Diesel Engine' : 'N/A',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
