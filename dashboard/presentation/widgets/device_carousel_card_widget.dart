import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/widgets/blink_anitmation_effect_widget.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/maintenance_log_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/status_chip_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void fetchServiceHistory(BuildContext context, String deviceID) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<MaintenanceLogProvider>().fetchMaintenanceLogs(
      deviceID: deviceID.toString(),
    );
  });
}

class DeviceCarouselCard extends StatelessWidget {
  final DashboardModel device;
  final bool isActive;

  const DeviceCarouselCard({
    super.key,
    required this.device,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMains =
        device.applicationType.toString().toLowerCase() == "mg" ||
        device.applicationType.toString().toLowerCase() == "mains";
    final hasGen =
        device.applicationType.toString().toLowerCase() == "mg" ||
        device.applicationType.toString().toLowerCase() == "dg";

    String appTypeLabel = "Mains & Generator";
    if (!hasMains && hasGen) appTypeLabel = "Generator Only";
    if (hasMains && !hasGen) appTypeLabel = "Mains Only";

    final mains = parseRuntime(
      fetchTotalHours(fromDate: DateTime(2026, 07, 01), toDate: DateTime.now()),
    );

    final mainsRunttime = mains - Duration(hours: 80);
    final generatorRuntime = mains - mainsRunttime;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: .symmetric(horizontal: 16, vertical: 8),
      padding: .all(16),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        gradient: LinearGradient(
          colors: isActive
              ? [
                  theme.colorScheme.primary.withValues(alpha: 0.7),
                  theme.colorScheme.primary.withValues(alpha: 0.9),
                ]
              : [
                  theme.colorScheme.primary.withValues(alpha: 0.3),
                  theme.colorScheme.primary.withValues(alpha: 0.6),
                ],
          begin: .topLeft,
          end: .bottomRight,
        ),
        border: .all(
          color: Colors.white.withValues(alpha: 0.1),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? theme.primaryColor.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceBetween,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  StatusChip(
                    dot: true,
                    dotColor: device.isLive == true
                        ? AppStatusColors.success
                        : blueGrey,
                    label:
                        '${AppLocale.live.getString(context)} ${AppLocale.status.getString(context)}',
                    theme: theme,
                  ),
                  InkWell(
                    onTap: () {
                      // context.read<DashboardProvider>().fetchDashboardMethod();
                      context
                          .read<DashboardProvider>()
                          .fetchMySubscriptionMethod();
                    },
                    child: StatusChip(
                      label:
                          '${AppLocale.last.getString(context)} ${AppLocale.update.getString(context)} ${formatTimeAgo(device.lastUpdated)} ',
                      icon: Icons.refresh,
                      theme: theme,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    device.deviceName.toString(),
                    style: theme.textTheme.displaySmall!.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: .bold,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  SizedBox(height: 2),
                  InkWell(
                    onTap: () {
                      openMapWithLocation(device.locationName.toString());
                    },
                    child: Row(
                      children: [
                        BlinkAnitmationEffectWidget(
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.white60,
                            size: 12,
                          ),
                        ),
                        SizedBox(width: 3),
                        SizedBox(
                          width: AppSizes.width(60),
                          child: Text(
                            device.locationName != 'null' &&
                                    device.locationName != null
                                ? device.locationName!.toString()
                                : '-',
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Container(
                    padding: const .symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                      borderRadius: .circular(10),
                      border: .all(
                        color: theme.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      appTypeLabel,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: .bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 32,
            right: 0,
            child: Column(
              crossAxisAlignment: .end,
              children: [
                Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.calendar_month, size: 12, color: Colors.white70),
                    SizedBox(width: 4),
                    Text(
                      device.mains != null
                          ? "${DateFormat('dd MMM').format(device.mains!.billingCycleStart != null ? DateTime.parse(device.mains!.billingCycleStart.toString().trim()) : DateTime(DateTime.now().year, DateTime.now().month, 01))} - Today"
                          : '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _runtimeChip(
                  AppLocale.generator.getString(context),
                  const Color.fromRGBO(76, 175, 80, 1),
                  formatHours(
                    device.generator != null
                        ? device.generator!.generatorBillingCycleHours != null
                              ? device.generator!.generatorBillingCycleHours!
                              : 0.0
                        : 0.0,
                  ),
                ),
                const SizedBox(height: 4),
                _runtimeChip(
                  AppLocale.mainPower.getString(context),
                  Colors.orange,
                  formatMinutes(
                    int.parse(
                      device.mains != null
                          ? device
                                        .mains!
                                        .mainsOnRuntimeInHourUsingBillingCycleInHours !=
                                    null
                                ? device
                                      .mains!
                                      .mainsOnRuntimeInHourUsingBillingCycleInHours!
                                      .floor()
                                      .toString()
                                : "0"
                          : "0",
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _runtimeChip(
                  'Total Hours',
                  Colors.blue,
                  fetchTotalDays(
                    fromDate: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      01,
                    ),
                    toDate: DateTime.now(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _runtimeChip(String text, Color color, String value) {
    return Container(
      padding: .symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .15),
        borderRadius: .circular(20),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Text(
            "$text ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: .circle),
          ),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openMapWithLocation(String locationName) async {
    final Uri uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(locationName)}",
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Map launch failed: $e");
    }
  }
}
