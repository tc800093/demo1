import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/common/widgets/blink_anitmation_effect_widget.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/status_chip_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        device.applicationType.toString().toLowerCase() == "mseb" ||
        device.applicationType.toString().toLowerCase() == "mains";
    final hasGen =
        device.applicationType.toString().toLowerCase() == "mg" ||
        device.applicationType.toString().toLowerCase() == "dg";

    String appTypeLabel = "Mains & Generator";
    if (!hasMains && hasGen) appTypeLabel = "Generator Only";
    if (hasMains && !hasGen) appTypeLabel = "Mains Only";

    final genRuntime = device.generatorRuntimeHours;
    final mainsRuntime = device.mainsRuntimeHours;
    final totalHours = device.totalHoursFromJuly1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: isActive
              ? [
                  theme.primaryColor.withValues(alpha: 0.85),
                  theme.primaryColor,
                ]
              : [
                  theme.primaryColor.withValues(alpha: 0.4),
                  theme.primaryColor.withValues(alpha: 0.65),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: isActive ? 0.25 : 0.12),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? theme.primaryColor.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  context.read<DashboardProvider>().fetchDashboardMethod();
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
          
          // Device Name & Location
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.deviceName.toString(),
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: () {
                        openMapWithLocation(device.locationName.toString());
                      },
                      child: Row(
                        children: [
                          const BlinkAnitmationEffectWidget(
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.white70,
                              size: 13,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              device.locationName != 'null' &&
                                      device.locationName != null
                                  ? device.locationName.toString()
                                  : '-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: Colors.white70,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  appTypeLabel,
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Runtime Metrics Bar (Gen Runtime, Mains Runtime, Total 1 Jul to Now)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRuntimeItem(
                  context,
                  label: "Gen Runtime",
                  value: "${genRuntime.toStringAsFixed(1)} h",
                  icon: Icons.power,
                  accentColor: const Color(0xFFFACC15),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _buildRuntimeItem(
                  context,
                  label: "Mains Runtime",
                  value: "${mainsRuntime.toStringAsFixed(1)} h",
                  icon: Icons.electrical_services,
                  accentColor: const Color(0xFF4ADE80),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                _buildRuntimeItem(
                  context,
                  label: "1 Jul - Now",
                  value: "${totalHours.toStringAsFixed(1)} h",
                  icon: Icons.access_time_filled,
                  accentColor: const Color(0xFF60A5FA),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuntimeItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: accentColor),
            const SizedBox(width: 3),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
