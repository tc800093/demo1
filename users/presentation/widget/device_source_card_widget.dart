import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/blink_anitmation_effect_widget.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/routes/app_route_paths.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/core/common/provider/device_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// A card for a single IoT device showing its power source(s).
///
/// Application type determines which tiles render:
///  `MG` → Generator + Mains Power
///  `DG` → Generator only
///  `MSEB`/`Mains` → Mains Power only
class DeviceSourceCard extends StatelessWidget {
  final DeviceModel device;
  final String userID;
  final bool? isUser;
  const DeviceSourceCard({
    super.key,
    required this.device,
    required this.userID,
    this.isUser = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appType = (device.applicationType ?? '').toLowerCase();

    final hasGenerator = appType == 'mg' || appType == 'dg';
    final hasMains = appType == 'mg' || appType == 'mains';

    final sourceLabel = _sourceLabel(appType);
    // final sourceColor = _sourceColor(appType, theme);

    return Container(
      margin: .only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(color: theme.dividerColor, width: 1),
      ),
      child: ExpansionTile(
        tilePadding: .symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        collapsedShape: RoundedRectangleBorder(borderRadius: .circular(16)),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withValues(alpha: 0.12),
          child: Icon(Icons.memory_outlined, color: theme.primaryColor),
        ),
        title: Text(
          device.deviceName ?? 'Device',
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .start,
          children: [
            Text(device.deviceCode ?? '', style: theme.textTheme.bodySmall),
            SizedBox(height: AppSizes.height(0.5)),
            Container(
              padding: const .symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                borderRadius: .circular(20),
              ),
              child: Text(
                sourceLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: .w600,
                ),
              ),
            ),
          ],
        ),
        childrenPadding: .fromLTRB(16, 0, 16, 16),
        children: [
          if (device.locationName != null && device.locationName!.isNotEmpty)
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: device.locationName!,
              onTapFunction: () {
                openMapWithLocation(device.locationName.toString());
              },
            ),
          if (hasGenerator) ...[
            Divider(height: 20),
            _SourceTile(
              icon: Icons.power_outlined,
              title: 'Generator',
              subtitle: device.generatorModel != null
                  ? '${device.generatorModel!.generatorName ?? "N/A"}'
                        ' • ${device.generatorModel!.generatorCapacityKva ?? "--"} KVA'
                  : 'Info not available',
              color: Colors.orange,
              details: device.generatorModel == null
                  ? null
                  : [
                      _InfoRow(
                        icon: Icons.precision_manufacturing_outlined,
                        label: 'Manufacturer',
                        value: device.generatorModel!.manufacturer ?? 'N/A',
                      ),

                      _InfoRow(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Model No.',
                        value: device.generatorModel!.modelNumber ?? 'N/A',
                      ),

                      _InfoRow(
                        icon: Icons.local_gas_station_outlined,
                        label: 'Fuel Tank',
                        value:
                            '${device.generatorModel!.fuelTankCapacity ?? '--'} L',
                      ),

                      const Divider(),

                      _InfoRow(
                        icon: Icons.local_gas_station_outlined,
                        label: 'Last Refuel',
                        // value: device.generatorModel!.lastServiceDate != null
                        //     ? DateFormat(
                        //         'dd MMM yyyy • hh:mm a',
                        //       ).format(device.generatorModel!.lastServiceDate!)
                        //     : 'Not Available',
                        value: "01 July 2026",
                      ),

                      _InfoRow(
                        icon: Icons.handyman_outlined,
                        label: 'Last Service',
                        // value: device.generatorModel!.lastServiceDate != null
                        //     ? DateFormat(
                        //         'dd MMM yyyy • hh:mm a',
                        //       ).format(device.generatorModel!.lastServiceDate!)
                        //     : 'Not Available',
                        value: "Not available",
                      ),

                      _InfoRow(
                        icon: Icons.event_available_outlined,
                        label: 'Next Service',
                        // value: device.generatorModel!.nextServiceDate != null
                        //     ? DateFormat(
                        //         'dd MMM yyyy',
                        //       ).format(device.generatorModel!.nextServiceDate!)
                        //     : 'Not Scheduled',
                        value: "20 Jul 2026",
                      ),

                      SizedBox(height: AppSizes.height(1)),

                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton.icon(
                          onPressed: () {
                            context.pushNamed(
                              admingeneratorServiceHistory,
                              // extra: device,
                            );
                          },
                          icon: const Icon(Icons.history),
                          label: const Text("Service History"),
                        ),
                      ),
                    ],
            ),
          ],
          if (hasMains) ...[
            Divider(height: 20),
            _SourceTile(
              icon: Icons.bolt_outlined,
              title: 'Mains Power',
              subtitle: device.mainPowerModel != null
                  ? '${device.mainPowerModel!.connectionName ?? 'N/A'}'
                        ' · ${device.mainPowerModel!.phaseType ?? '--'}'
                  : 'Info not available',
              color: Colors.blue,
              details: device.mainPowerModel == null
                  ? null
                  : [
                      _InfoRow(
                        icon: Icons.numbers_outlined,
                        label: 'Meter No.',
                        value: device.mainPowerModel!.meterNumber ?? 'N/A',
                      ),
                      _InfoRow(
                        icon: Icons.electric_meter_outlined,
                        label: 'Board',
                        value: device.mainPowerModel!.electricityBoard != ""
                            ? device.mainPowerModel!.electricityBoard ?? 'N/A'
                            : "N/A",
                      ),
                      _InfoRow(
                        icon: Icons.cable_outlined,
                        label: 'Phase Type',
                        value: device.mainPowerModel!.phaseType ?? 'N/A',
                      ),
                    ],
            ),
          ],
          SizedBox(height: AppSizes.height(2)),
          isUser == false
              ? SizedBox.shrink()
              : Row(
                  mainAxisAlignment: .start,
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        context.pushNamed(
                          adminAddDeviceScreen,
                          extra: UserDeviceEditOrAdd(
                            userID: userID,
                            deviceModel: device,
                            isEdit: true,
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_outlined),
                      label: Text('Edit'),
                    ),
                    SizedBox(width: AppSizes.width(2)),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<DeviceProvider>().deleteDeviceByIDMethod(
                          deviceId: device.deviceId.toString(),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.7),
                      ),
                      icon: Icon(Icons.delete_forever_outlined),
                      label: Text('Delete'),
                    ),
                  ],
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

  String _sourceLabel(String appType) {
    switch (appType) {
      case 'mg':
        return 'Main + Generator';
      case 'dg':
        return 'Generator Only';
      case 'mains':
        return 'Mains Only';
      default:
        return appType.toUpperCase();
    }
  }
}

/// A single power source row within a device card (generator or mains).
class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Widget>? details;

  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (details != null) ...[const SizedBox(height: 10), ...details!],
      ],
    );
  }
}

/// A single label + value row inside an expanded device card.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final void Function()? onTapFunction;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTapFunction,
      child: Padding(
        padding: .symmetric(vertical: 4),
        child: Row(
          children: [
            label != 'Location'
                ? Icon(icon, size: 16, color: Colors.grey)
                : BlinkAnitmationEffectWidget(
                    child: Icon(icon, size: 16, color: Colors.grey),
                  ),
            SizedBox(width: 8),
            Text(
              '$label: ',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
