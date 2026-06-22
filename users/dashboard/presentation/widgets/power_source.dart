import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class S3PowerSourcesRow extends StatelessWidget {
  final String currentPowerSource;
  final bool hasMseb;
  final bool hasGenerator;
  const S3PowerSourcesRow({
    super.key,
    required this.currentPowerSource,
    this.hasMseb = true,
    this.hasGenerator = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (hasMseb)
            Expanded(
              child: _MainsPowerCard(
                isOn: currentPowerSource.toLowerCase() == 'mseb',
              ),
            ),
          if (hasMseb && hasGenerator)
            SizedBox(width: AppSizes.width(3)),
          if (hasGenerator)
            Expanded(
              child: _GeneratorSummaryCard(
                isOn: currentPowerSource.toLowerCase() == 'generator',
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
                ? const Color(0xFF10B981).withValues(alpha: 0.1)
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
                  color: const Color(0xFFF1F5F9),
                  borderRadius: .circular(9),
                ),
                child: Image.asset(
                  mainPowerLogo,
                  color: isOn ? Colors.green : null,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOn ? Colors.green : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOn
                      ? AppLocale.active.getString(context).toUpperCase()
                      : AppLocale.offline.getString(context).toUpperCase(),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 9,
                    color: isOn ? Colors.white : Colors.black,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppLocale.mainPower.getString(context),
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: AppSizes.height(0.1)),
          Text('3-Phase System', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _GeneratorSummaryCard extends StatelessWidget {
  final bool isOn;
  const _GeneratorSummaryCard({required this.isOn});
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
              ? const Color(0xFFBBF7D0)
              : theme.primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isOn
                ? const Color(0xFF10B981).withValues(alpha: 0.1)
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
                  color: isOn ? Colors.green : null,
                ),
              ),
              Container(
                padding: .symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isOn
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF1F5F9),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  isOn
                      ? AppLocale.active.getString(context).toUpperCase()
                      : AppLocale.offline.getString(context).toUpperCase(),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 9,
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
          Text('Diesel Engine', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
