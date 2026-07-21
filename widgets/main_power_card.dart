import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:provider/provider.dart';

class S3MainPowerCard extends StatelessWidget {
  final MainsModel? mseb;
  final bool status;
  final void Function()? phaseFailedFunction;
  final void Function()? rPhaseFailedFunction;

  const S3MainPowerCard({
    super.key,
    required this.mseb,
    required this.status,
    this.phaseFailedFunction,
    this.rPhaseFailedFunction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: status
              ? const Color(0xFF22C55E).withValues(alpha: 0.35)
              : theme.primaryColor.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: status
                ? AppStatusColors.success.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme: theme, context: context),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          _buildGaugeNumber(theme: theme, context: context),
          _buildStatsGrid(
            theme: theme,
            context: context,
            onLongPressPhaseFailed: phaseFailedFunction,
            onLongPressRPhaseFailed: rPhaseFailedFunction,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required ThemeData theme,
    required BuildContext context,
  }) {
    final isThreePhase = mseb != null &&
        mseb!.phaseType.toString().toLowerCase() == "three_phase";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: status
                          ? AppStatusColors.success.withValues(alpha: 0.12)
                          : theme.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      mainPowerLogo,
                      color: status ? AppStatusColors.success : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocale.mainPower.getString(context)} ${AppLocale.status.getString(context)}',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isThreePhase ? '3-Phase Supply' : '1-Phase Supply',
                        style: theme.textTheme.bodySmall!.copyWith(
                          fontSize: 11,
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: mseb != null
                      ? (status
                          ? const Color(0xFFDCFCE7)
                          : lightSlateGrayColor.withValues(alpha: 0.3))
                      : lightGrayBlueColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  mseb != null
                      ? (status
                          ? AppLocale.active.getString(context)
                          : AppLocale.offline.getString(context))
                      : 'N/A',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: mseb != null
                        ? (status ? const Color(0xFF16A34A) : Colors.black87)
                        : Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Phase Indicators
          Row(
            children: [
              Text(
                "Phases:",
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              _buildPhaseChip(
                label: "R",
                isActive: mseb?.rPhaseStatus == true,
                activeColor: const Color(0xFFEF4444), // Red
              ),
              if (isThreePhase) ...[
                const SizedBox(width: 6),
                _buildPhaseChip(
                  label: "Y",
                  isActive: mseb?.yPhaseStatus == true,
                  activeColor: const Color(0xFFF59E0B), // Yellow/Amber
                ),
                const SizedBox(width: 6),
                _buildPhaseChip(
                  label: "B",
                  isActive: mseb?.bPhaseStatus == true,
                  activeColor: const Color(0xFF2563EB), // Blue
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseChip({
    required String label,
    required bool isActive,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isActive ? activeColor : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? activeColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeNumber({
    required ThemeData theme,
    required BuildContext context,
  }) {
    final currentStr = mseb != null && mseb!.currnet != null && mseb!.currnet != "/"
        ? mseb!.currnet.toString()
        : '-';
    final voltageStr = mseb != null && mseb!.voltage != null
        ? mseb!.voltage!.toStringAsFixed(2)
        : '-';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Text(
            '$currentStr A / $voltageStr V',
            style: theme.textTheme.headlineMedium!.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${AppLocale.current.getString(context)} / ${AppLocale.voltage.getString(context)}',
            style: theme.textTheme.bodySmall!.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
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
    final DateTime now = DateTime.now();
    DateTime billingStart = DateTime(now.year, now.month, 1);
    DateTime billingEnd =
        DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));

    if (mseb != null && mseb!.billingCycleStart != null) {
      final parsed = DateTime.tryParse(mseb!.billingCycleStart!);
      if (parsed != null) billingStart = parsed;
    }
    if (mseb != null && mseb!.billingCycleEnd != null) {
      final parsed = DateTime.tryParse(mseb!.billingCycleEnd!);
      if (parsed != null) billingEnd = parsed;
    }

    final double totalHours = now.difference(billingStart).inSeconds / 3600.0;
    final double generatorRunHours =
        (mseb?.outageDurationMinutes ?? 180.0) / 60.0;
    final double mainsRunHours =
        totalHours > generatorRunHours ? totalHours - generatorRunHours : 0.0;

    const List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final String startMonth = monthNames[billingStart.month - 1];
    final String endMonth = monthNames[billingEnd.month - 1];
    final String billingCycleStr =
        "${billingStart.day} $startMonth - ${billingEnd.day} $endMonth";

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                        '${AppLocale.outage.getString(context)} / ${AppLocale.duration.getString(context)}',
                    value:
                        '${mseb != null ? mseb!.outageCount.toString() : '-'} times / ${mseb != null && mseb!.outageDurationMinutes != null ? (mseb!.outageDurationMinutes! / 60.0).toStringAsFixed(1) : "-"} hr',
                    bgColor: const Color(0xFFEFF6FF),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onLongPress: onLongPressRPhaseFailed,
                  child: _StatBox(
                    icon: Icons.waves_rounded,
                    iconColor: AppStatusColors.success,
                    label: 'Frequency',
                    value:
                        '${mseb != null ? mseb!.frequency.toString() : '-'} Hz',
                    sub: 'Standard range',
                    bgColor: const Color(0xFFF0FDF4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                        'Monthly ${AppLocale.comsumption.getString(context)}',
                    value:
                        '${mseb != null ? mseb!.electricityConsumption.toString() : '-'} ${AppLocale.units.getString(context)}',
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
                    label: "Daily ${AppLocale.comsumption.getString(context)}",
                    value:
                        '${mseb != null ? mseb!.dailyConsumption.toString() : "-"} ${AppLocale.units.getString(context)}',
                    bgColor: const Color(0xFFF0F9FF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.speed,
                  label: "Meter Reading",
                  value:
                      '${mseb != null && mseb!.meterReading != null ? mseb!.meterReading.toString() : '-'} ${AppLocale.units.getString(context)}',
                  iconColor: theme.primaryColor,
                  bgColor: const Color(0xFFF8FAFC),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.calendar_month,
                  label: "Billing Cycle",
                  value: billingCycleStr,
                  iconColor: theme.primaryColor,
                  sub: "Total Cycle: ${totalHours.toStringAsFixed(1)} hrs",
                  bgColor: const Color(0xFFF8FAFC),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.av_timer,
                  label: "Mains Run Time",
                  value: '${mainsRunHours.toStringAsFixed(1)} Hrs',
                  iconColor: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.av_timer,
                  label: "Generator Run Time",
                  value: '${generatorRunHours.toStringAsFixed(1)} Hrs',
                  iconColor: const Color(0xFFF59E0B),
                  bgColor: const Color(0xFFFEF3C7),
                ),
              ),
            ],
          ),
          if (mseb != null && mseb!.phaseFailure == true) ...[
            const SizedBox(height: 12),
            _buildWarningBanner(
              context: context,
              theme: theme,
              msg: mseb!.rPhaseStatus == true
                  ? "R Phase failed"
                  : mseb!.yPhaseStatus == true
                      ? "Y Phase failed"
                      : mseb!.bPhaseStatus == true
                          ? "R Phase failed"
                          : '',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWarningBanner({
    required BuildContext context,
    required ThemeData theme,
    required String msg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mains ${AppLocale.warning.getString(context)}: $msg',
              style: theme.textTheme.titleSmall!.copyWith(
                fontSize: 12,
                color: const Color(0xFFB45309),
                fontWeight: FontWeight.bold,
              ),
            ),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (sub != null && sub!.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              sub!,
              style: theme.textTheme.bodySmall!.copyWith(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

