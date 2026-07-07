import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/domain/model/generator_refuel_history_model.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_Refuel_record_usecase.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:provider/provider.dart';

class RefuelHistorySection extends StatelessWidget {
  final String userId;
  const RefuelHistorySection({required this.userId});

  void _showAddRefuelBottomSheet(
    BuildContext context,
    List<DeviceModel> devices,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final formKey = GlobalKey<FormState>();
    String? selectedDeviceId = devices.first.deviceId;
    final fuelAmountController = TextEditingController();
    final costController = TextEditingController();
    final notesController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Consumer<UserDeviceProvider>(
              builder: (ctx, udp, child) {
                if (udp.addRefuelStatus == Status.success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.success(context, 'Refuel Record Added');
                    udp.resetAddRefuelStatus();
                    Navigator.of(ctx).pop();
                  });
                }
                if (udp.addRefuelStatus == Status.failed) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.error(
                      context,
                      udp.message.isNotEmpty
                          ? udp.message
                          : 'Failed to add refuel record',
                    );
                    udp.resetAddRefuelStatus();
                  });
                }

                return Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 8,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  ),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Add Refuel Record',
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSizes.height(2)),
                          DropdownButtonFormField<String>(
                            initialValue: selectedDeviceId,
                            dropdownColor: theme.cardColor,
                            items: devices
                                .map(
                                  (d) => DropdownMenuItem(
                                    value: d.deviceId,
                                    child: Text(d.deviceName ?? 'Device'),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedDeviceId = val;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Device',
                              prefixIcon: const Icon(Icons.memory_outlined),
                              filled: true,
                              fillColor: isDark
                                  ? const Color(0xFF1E293B).withValues(alpha: 0.35)
                                  : Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: fuelAmountController,
                            title: 'Fuel Amount (Liters)',
                            prefixIconData: Icons.local_gas_station_outlined,
                            inputKeyBoard: TextInputType.number,
                            validatorFunction: (val) {
                              if (val == null || val.isEmpty) return 'Required';
                              if (double.tryParse(val) == null) {
                                return 'Must be a number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: costController,
                            title: 'Total Cost (₹)',
                            prefixIconData: Icons.currency_rupee,
                            inputKeyBoard: TextInputType.number,
                            validatorFunction: (val) {
                              if (val == null || val.isEmpty) return 'Required';
                              if (double.tryParse(val) == null) {
                                return 'Must be a number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: notesController,
                            title: 'Notes',
                            prefixIconData: Icons.description_outlined,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B).withValues(alpha: 0.35)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: theme.iconTheme.color,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Refuel Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: theme.iconTheme.color,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButtonWidget(
                            isLoading: udp.addRefuelStatus == Status.loading,
                            title: 'Save Record',
                            theme: theme,
                            onPressedFunction: () {
                              if (formKey.currentState!.validate()) {
                                final qty = double.parse(fuelAmountController.text.trim());
                                final total = double.parse(costController.text.trim());
                                final rate = qty > 0 ? total / qty : 0.0;
                                final newRecord = AddGeneratorRefuelRecordParams(
                                  deviceId: selectedDeviceId!,
                                  fuelQuantity: qty,
                                  fuelRate: rate,
                                  refuelDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                                  totalCost: total,
                                  remarks: notesController.text.trim(),
                                );

                                context.read<UserDeviceProvider>().addGeneratorRefuelRecordMethod(
                                      params: newRecord,
                                      userId: userId,
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserDeviceProvider>(
      builder: (context, udp, _) {
        // Get all refuel records for all user devices
        final List<GeneratorRefuelHistoryModel> allRecords = [];
        for (var device in udp.devices) {
          if (device.refuelHistory != null) {
            allRecords.addAll(device.refuelHistory!);
          }
        }
        allRecords.sort((a, b) => (b.refuelDate ?? DateTime.now()).compareTo(a.refuelDate ?? DateTime.now()));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (allRecords.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No refuel history found.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allRecords.length,
                itemBuilder: (context, index) {
                  final record = allRecords[index];
                  final dateStr = record.refuelDate != null
                      ? DateFormat('dd MMM yyyy').format(record.refuelDate!)
                      : 'N/A';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.dividerColor, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${record.fuelQuantity?.toStringAsFixed(1) ?? '0.0'} Liters',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '₹${record.totalCost?.toStringAsFixed(0) ?? '0'}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.memory_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              record.deviceName ?? 'Device',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateStr,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        if (record.remarks != null && record.remarks!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(record.remarks!, style: theme.textTheme.bodyMedium),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
            if (udp.devices.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () =>
                    _showAddRefuelBottomSheet(context, udp.devices),
                icon: const Icon(Icons.add),
                label: const Text('Add Refuel Record'),
              ),
          ],
        );
      },
    );
  }
}
