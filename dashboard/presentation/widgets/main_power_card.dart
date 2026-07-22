import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class S3MainPowerCard extends StatelessWidget {
  final MainsModel? mains;
  final bool status;
  final void Function()? phaseFailedFunction;
  final void Function()? rPhaseFailedFunction;
  final DashboardModel? dashboardModel;
  const S3MainPowerCard({
    super.key,
    required this.mains,
    required this.status,
    this.phaseFailedFunction,
    this.rPhaseFailedFunction,
    this.dashboardModel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: .symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
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
          _buildStatsGrid(
            theme: theme,
            context: context,
            onLongPressPhaseFailed: phaseFailedFunction,
            onLongPressRPhaseFailed: rPhaseFailedFunction,
          ),
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
                        padding: .all(4),
                        child: Image.asset(
                          mainPowerLogo,
                          color: status ? AppStatusColors.success : null,
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
                            mains != null
                                ? mains!.phaseType.toString().toLowerCase() ==
                                          "three_phase"
                                      ? '3-${AppLocale.phase.getString(context)}'
                                      : '1-${AppLocale.phase.getString(context)}'
                                : '-',
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
                  color: mains != null
                      ? status
                            ? Color(0xFFDCFCE7)
                            : lightSlateGrayColor
                      : lightGrayBlueColor,
                  borderRadius: .circular(20),
                ),
                child: Text(
                  mains != null
                      ? status
                            ? AppLocale.active.getString(context)
                            : AppLocale.offline.getString(context)
                      : 'N/A',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: mains != null
                        ? status
                              ? Color(0xFF16A34A)
                              : Colors.white
                        : Colors.black,
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
              Text("${AppLocale.phase.getString(context)}:"),
              SizedBox(width: AppSizes.width(2)),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: mains != null
                      ? mains!.rPhaseStatus == true
                            ? Colors.red
                            : lightSlateGrayColor
                      : blueGrey,
                  shape: .circle,
                ),
              ),
              SizedBox(width: AppSizes.width(1)),
              mains != null
                  ? mains!.phaseType.toString().toLowerCase() == "three_phase"
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: mains!.yPhaseStatus == true
                                  ? Color(0xFFF59E0B)
                                  : lightSlateGrayColor,
                              shape: .circle,
                            ),
                          )
                        : SizedBox.shrink()
                  : SizedBox.fromSize(),
              SizedBox(width: AppSizes.width(1)),
              mains != null &&
                      mains!.phaseType.toString().toLowerCase() == "three_phase"
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: mains!.bPhaseStatus == true
                            ? Color(0xFF2563EB)
                            : lightSlateGrayColor,
                        shape: .circle,
                      ),
                    )
                  : SizedBox.shrink(),
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
            '${mains != null
                ? mains!.currnet != null && mains!.currnet != "/"
                      ? mains!.currnet!.toString()
                      : '-'
                : '-'} / ${mains != null
                ? mains!.voltage != null
                      ? mains!.voltage!.toStringAsFixed(1)
                      : '-'
                : '-'}',
            style: theme.textTheme.displayMedium!.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: .bold,
            ),
          ),
          SizedBox(height: AppSizes.height(1)),
          Text(
            '${AppLocale.current.getString(context)} / ${AppLocale.voltage.getString(context)}',
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid({
    required ThemeData theme,
    required BuildContext context,
    required void Function()? onLongPressPhaseFailed,
    required void Function()? onLongPressRPhaseFailed,
  }) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onLongPress: onLongPressPhaseFailed,
                  child: _StatBox(
                    icon: Icons.power_rounded,
                    iconColor: theme.primaryColor,
                    label:
                        '${AppLocale.duration.getString(context)}(${AppLocale.outage.getString(context)})',
                    value:
                        '${mains != null
                            ? mains!.outageDuratioHours != null
                                  ? formatMinutes(mains!.outageDuratioHours!.floor())
                                  : "-"
                            : '-'} (${mains != null ? mains!.outageCount.toString() : '-'})',
                    // value:
                    //     '${mains != null ? mains!.outageCount.toString() : '-'} times / ${mains != null ? getOutagetime() : '-'}',
                    sub: '',
                    bgColor: const Color(0xFFEFF6FF),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onLongPress: onLongPressRPhaseFailed,
                  child: _StatBox(
                    icon: Icons.waves_rounded,
                    iconColor: AppStatusColors.success,
                    label: AppLocale.frequency.getString(context),
                    value:
                        '${mains != null ? mains!.frequency.toString() : '-'} Hz',
                    sub: 'Standard range',
                    bgColor: Colors.blue.shade50,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(2)),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<DashboardProvider>().changetoWarningStat();
                  },
                  child: _StatBox(
                    icon: Icons.bar_chart_rounded,
                    iconColor: theme.primaryColor,
                    label:
                        '${AppLocale.previousMonth.getString(context)} ${AppLocale.comsumption.getString(context)}',
                    value:
                        '${mains != null
                            ? mains!.electricityConsumption != null
                                  ? mains!.electricityConsumption!.toStringAsFixed(2)
                                  : '-'
                            : '-'} ${AppLocale.units.getString(context)}',
                    sub: '',
                    bgColor: const Color(0xFFEFF6FF),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<DashboardProvider>().changetoExipredStat();
                  },
                  child: _StatBox(
                    icon: Icons.bar_chart_rounded,
                    iconColor: const Color(0xFF0EA5E9),
                    label:
                        "${AppLocale.daily.getString(context)} ${AppLocale.comsumption.getString(context)}",
                    value:
                        '${mains != null ? mains!.dailyConsumption!.toStringAsFixed(2) : "-"} ${AppLocale.units.getString(context)}',
                    bgColor: const Color(0xFFF0F9FF),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(2)),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.speed,
                  label: AppLocale.meterReading.getString(context),
                  value:
                      '${mains!.meterReading != null ? mains!.meterReading!.toStringAsFixed(2) : '-'} ${AppLocale.units.getString(context)}',

                  iconColor: theme.primaryColor,
                  bgColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.calendar_month,
                  label: AppLocale.billingCycle.getString(context),
                  value: mains!.billingCycleStart != null
                      ? '${DateFormat('dd MMM').format(mains!.billingCycleStart != null ? DateTime.parse(mains!.billingCycleStart.toString().trim()) : DateTime(DateTime.now().year, DateTime.now().month, 01))} - ${DateFormat('dd MMM').format(DateTime.parse(mains!.billingCycleStart.toString().trim()).add(Duration(days: 30)))}'
                      : '${DateFormat('dd MMM').format(DateTime(DateTime.now().year, DateTime.now().month, 01))} - ${DateFormat('dd MMM').format(DateTime(DateTime.now().year, DateTime.now().month, 01).add(Duration(days: 30)))}',
                  iconColor: theme.primaryColor,
                  sub: "Current",
                  bgColor: Colors.blue.shade50,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(2)),
          if (mains != null && mains!.phaseFailure == true) ...[
            _buildWarningBanner(
              context: context,
              theme: theme,
              msg: mains!.rPhaseStatus == true
                  ? "R Phase failed"
                  : mains!.yPhaseStatus == true
                  ? "Y Phase failed"
                  : mains!.bPhaseStatus == true
                  ? "R Phase failed"
                  : 'Phase Failure',
            ),
          ],
          SizedBox(height: AppSizes.height(2)),
        ],
      ),
    );
  }

  Widget _buildWarningBanner({
    required BuildContext context,
    required ThemeData theme,
    required String msg,
  }) {
    return Padding(
      padding: .symmetric(horizontal: 0),
      child: Container(
        padding: .symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: .circular(10),
          border: .all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF59E0B),
              size: 18,
            ),
            SizedBox(width: AppSizes.width(2)),
            Expanded(
              child: Text(
                'Mains ${AppLocale.warning.getString(context)}: ${msg}',
                style: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
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
        color: theme.cardColor,
        borderRadius: .circular(12),
        border: .all(color: theme.colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.iconTheme.color, size: 13),
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
