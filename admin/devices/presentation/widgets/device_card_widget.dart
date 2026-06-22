import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel deviceModel;

  const DeviceCard({super.key, required this.deviceModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = deviceModel.active! ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      margin: .symmetric(horizontal: 0, vertical: 8),
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: Padding(
        padding: .all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: statusColor.withValues(alpha: .15),
                  child: Icon(Icons.memory_rounded, color: statusColor),
                ),
                SizedBox(width: AppSizes.height(2)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        deviceModel.deviceName.toString(),
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        deviceModel.deviceCode.toString(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: .symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: .12),
                    borderRadius: .circular(20),
                  ),
                  child: Text(
                    deviceModel.active! ? "Online" : "Offline",
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSizes.height(2)),

            /// Device Details
            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    title: "Device Type",
                    value: deviceModel.applicationType.toString(),
                  ),
                ),
                Expanded(
                  child: _InfoTile(
                    title: "Area",
                    value: deviceModel.areaName.toString(),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSizes.height(2)),

            Row(
              children: [
                Expanded(
                  child: _InfoTile(
                    title: "Location",
                    value: deviceModel.locationName.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(title, style: theme.textTheme.titleSmall),
        SizedBox(height: AppSizes.height(0.1)),
        Text(
          value,
          style: theme.textTheme.bodyMedium!.copyWith(fontWeight: .w600),
        ),
      ],
    );
  }
}
