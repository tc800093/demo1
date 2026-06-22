import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/users/dashboard/domain/model/dashboard_model.dart';

class S3MainPowerCard extends StatelessWidget {
  final Mseb mseb;
  final bool status;
  const S3MainPowerCard({super.key, required this.mseb, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: .symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(theme: theme, context: context),
          _buildGaugeNumber(theme: theme, context: context),
          SizedBox(height: AppSizes.height(1)),
          _buildStatsGrid(theme: theme, context: context),
          SizedBox(height: AppSizes.height(1)),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required ThemeData theme,
    required BuildContext context,
  }) {
    return Padding(
      padding: .fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: AppSizes.width(8),
                        height: AppSizes.height(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Image.asset(
                          mainPowerLogo,
                          color:
                              //  status != null
                              // ?
                              status ? Colors.green : null,
                          // : null,
                        ),
                      ),
                      SizedBox(width: AppSizes.width(1)),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '${AppLocale.mainPower.getString(context)} ${AppLocale.status.getString(context)}',
                            style: theme.textTheme.titleMedium!,
                          ),
                          Text(
                            "${mseb.phaseType.toString().toLowerCase() == "three_phase" ? '3-Phase' : '1-Phase'} Connection",
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: .symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: status ? Color(0xFFDCFCE7) : Color(0xFF94A3B8),
                  borderRadius: .circular(20),
                ),
                child: Text(
                  status
                      ? AppLocale.active.getString(context)
                      : AppLocale.offline.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: status ? Color(0xFF16A34A) : Colors.white,
                    fontWeight: .bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSizes.height(1)),
          Row(
            crossAxisAlignment: .center,
            children: [
              Text("Phase:"),
              SizedBox(width: AppSizes.width(2)),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: status ? Colors.red : Color(0xFF94A3B8),
                  shape: .circle,
                ),
              ),
              SizedBox(width: AppSizes.width(1)),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: status ? Color(0xFFF59E0B) : Color(0xFF94A3B8),
                  shape: .circle,
                ),
              ),
              SizedBox(width: AppSizes.width(1)),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: status ? Color(0xFF2563EB) : Color(0xFF94A3B8),
                  shape: .circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeNumber({
    required ThemeData theme,
    required BuildContext context,
  }) {
    return Padding(
      padding: .symmetric(vertical: 18),
      child: Column(
        children: [
          Text(
            '${mseb.voltage.toString()}/${mseb.current.toString()}',
            style: theme.textTheme.displayMedium!.copyWith(
              color: theme.primaryColor,
              fontWeight: .bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${AppLocale.current.getString(context)} ${AppLocale.voltage.getString(context)} / Ampere',
            style: TextStyle(fontSize: 11, color: const Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid({
    required ThemeData theme,
    required BuildContext context,
  }) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.power_rounded,
                  iconColor: theme.primaryColor,
                  label:
                      '${AppLocale.outage.getString(context)} / ${AppLocale.duration.getString(context)}',
                  value:
                      '${mseb.outageCount.toString()} times / ${mseb.outageDuration != null ? mseb.outageDuration.toString() : "-"} hr',
                  sub: '',
                  bgColor: const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.bar_chart_rounded,
                  iconColor: const Color(0xFF0EA5E9),
                  label: AppLocale.comsumption.getString(context),
                  value:
                      '${mseb.unitConsumption.toString()} ${AppLocale.units.getString(context)}',
                  bgColor: const Color(0xFFF0F9FF),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.bar_chart_rounded,
                  iconColor: theme.primaryColor,
                  label: 'Average ${AppLocale.comsumption.getString(context)}',
                  value: '600 ${AppLocale.units.getString(context)}',
                  sub: '',
                  bgColor: const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.bar_chart_rounded,
                  iconColor: const Color(0xFF0EA5E9),
                  label: AppLocale.comsumption.getString(context),
                  value:
                      '${mseb.unitConsumption.toString()} ${AppLocale.units.getString(context)}',
                  bgColor: const Color(0xFFF0F9FF),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(2)),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.waves_rounded,
                  iconColor: const Color(0xFF10B981),
                  label: 'Frequency',
                  value: '${mseb.frequency.toString()} Hz',
                  sub: 'Standard range',
                  bgColor: const Color(0xFFF0FDF4),
                ),
              ),
              // const SizedBox(width: 10),
              // Expanded(
              //   child: _StatBox(
              //     icon: Icons.bolt_rounded,
              //     iconColor: const Color(0xFFF59E0B),
              //     label: 'Power Factor',
              //     value: '0.98',
              //     sub: 'Efficient transmission',
              //     bgColor: const Color(0xFFFFFBEB),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? sub;
  final Color bgColor;

  const _StatBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.sub,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: .circular(12),
        border: .all(color: iconColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 13),
              SizedBox(width: AppSizes.width(0.5)),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall!.copyWith(fontSize: 10),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1)),
          Text(
            value,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              fontWeight: .bold,
            ),
          ),
        ],
      ),
    );
  }
}
