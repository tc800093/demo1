import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:poweriot/features/admin/users/presentation/widget/add_source_button_widget.dart';
import 'package:poweriot/features/admin/users/presentation/widget/device_source_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Renders the list of IoT devices belonging to the user, each expanded to
/// show its available power sources (generator / mains / both).
///
/// Shows a shimmer skeleton while [UserDeviceProvider.fetchSourceStatus] is loading.
/// Shows an "Add Power Source" button at the bottom of the list.
class PowerSourcesSection extends StatelessWidget {
  final String userId;
  const PowerSourcesSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserDeviceProvider>(
      builder: (context, udp, _) {
        // Loading skeleton
        if (udp.fetchSourceStatus == .loading ||
            udp.fetchSourceStatus == .init) {
          return Skeletonizer(
            enabled: true,
            child: DeviceSourceCard(
              userID: userId,
              device: DeviceModel(
                deviceName: 'Loading Device',
                applicationType: 'MG',
                deviceCode: 'DEV001',
                locationName: 'Loading...',
              ),
            ),
          );
        }

        // Error / empty state
        if (udp.fetchSourceStatus == .failed || udp.devices.isEmpty) {
          return Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'No devices found for this user.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.height(1.5)),
              AddSourceButton(userId: userId),
            ],
          );
        }

        // Device list
        return Column(
          children: [
            SizedBox(height: AppSizes.height(1)),
            ...udp.devices.map(
              (device) => DeviceSourceCard(device: device, userID: userId),
            ),
            SizedBox(height: AppSizes.height(1)),
            AddSourceButton(userId: userId),
          ],
        );
      },
    );
  }
}
