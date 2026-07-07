import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/common/provider/maintenance_log_provider.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/common/widgets/no_data_widget.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/domain/model/service_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:provider/provider.dart';

class ServiceHistorySection extends StatelessWidget {
  final String userId;
  final bool isAdmin;
  final List<GeneratorServiceHistoryModel> serviceHistory;
  const ServiceHistorySection({
    required this.userId,
    this.isAdmin = false,
    required this.serviceHistory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer2<UserDeviceProvider, MaintenanceLogProvider>(
      builder: (context, udp, mp, _) {
        // if (udp.fetchSourceStatus == .loading ||
        //     udp.fetchSourceStatus == .init) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        // Get all service records for all user devices
        if (mp.serviceHistoryStatus == .failed) {
          return NoDataWidget(title: 'No Service History found');
        }

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            if (serviceHistory.isEmpty) ...[
              Padding(
                padding: .symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'No service history found.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(height: AppSizes.height(0.6)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: serviceHistory.length,
                itemBuilder: (context, index) {
                  final record = serviceHistory[index];
                  final dateStr = DateFormat(
                    'dd MMM yyyy',
                  ).format(record.serviceDate!);
                  return Container(
                    margin: .only(bottom: 12),
                    padding: .all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: .circular(12),
                      border: Border.all(color: theme.dividerColor, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Text(
                              record.serviceType.toString(),
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: .bold,
                              ),
                            ),
                            Text(
                              '₹${record.cost!.toStringAsFixed(0)}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: .bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.height(0.5)),
                        Row(
                          children: [
                            const Icon(
                              Icons.memory_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(width: AppSizes.width(0.6)),
                            SizedBox(
                              width: AppSizes.width(35),
                              child: Text(
                                record.deviceName.toString(),
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.width(1.4)),
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            SizedBox(width: AppSizes.width(.4)),
                            Text(
                              dateStr,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (record.remarks!.isNotEmpty) ...[
                          SizedBox(height: AppSizes.height(0.5)),
                          Text(
                            record.remarks!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                        SizedBox(height: AppSizes.height(0.6)),
                      ],
                    ),
                  );
                },
              ),
            ],
            // SizedBox(height: AppSizes.height(2)),
            // if (udp.devices.isNotEmpty)
            isAdmin
                ? OutlinedButton.icon(
                    onPressed: () {},
                    // _showAddServiceBottomSheet(context, udp.devices),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Service Record'),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
