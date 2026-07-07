import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_service_record_usecase.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/common/widgets/no_data_widget.dart';
import 'package:poweriot/core/common/widgets/service_card_widget.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:provider/provider.dart';

class AdminServiceHistoryWidget extends StatelessWidget {
  final String userID;
  const AdminServiceHistoryWidget({super.key, required this.userID});

  void _showAddServiceBottomSheet(BuildContext context, DeviceModel device) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final formKey = GlobalKey<FormState>();
    String? selectedDeviceId = device.deviceId;
    final serviceTypeController = TextEditingController();
    final technicianController = TextEditingController();
    final costController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    DateTime nextServiceDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Consumer<UserDeviceProvider>(
              builder: (ctx, udp, child) {
                if (udp.addServiceStatus == Status.success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.success(context, 'Service Record Added');
                    udp.resetAddServiceStatus();
                    Navigator.of(ctx).pop();
                  });
                }
                if (udp.addServiceStatus == Status.failed) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.error(
                      context,
                      udp.message.isNotEmpty
                          ? udp.message
                          : 'Failed to add service record',
                    );
                    udp.resetAddServiceStatus();
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
                            'Add Service Record',
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: TextEditingController(
                              text: device.deviceName,
                            ),
                            title: 'Device Name',
                            isReadOnly: true,
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: serviceTypeController,
                            title: 'Service Type (e.g. Oil Change)',
                            prefixIconData: Icons.category_outlined,
                            validatorFunction: (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: technicianController,
                            title: 'Technician Name',
                            prefixIconData: Icons.person_outline,
                            validatorFunction: (val) =>
                                val == null || val.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: costController,
                            title: 'Cost (₹)',
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
                            controller: descriptionController,
                            title: 'Description/Notes',
                            prefixIconData: Icons.description_outlined,
                            maxLines: 3,
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                        'Service Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}',
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
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                initialDate: nextServiceDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() {
                                  nextServiceDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                        'Next Service Date: ${DateFormat('dd MMM yyyy').format(nextServiceDate)}',
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
                            isLoading: udp.addServiceStatus == Status.loading,
                            title: 'Save Record',
                            theme: theme,
                            onPressedFunction: () {
                              if (formKey.currentState!.validate()) {
                                final newRecord = AddGeneratorServiceRecordParams(
                                  nextServiceDate: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(nextServiceDate),
                                  deviceId: device.deviceId.toString(),
                                  remarks: descriptionController.text.toString(),
                                  serviceDate: DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(selectedDate),
                                  serviceProvider: technicianController.text
                                      .toString(),
                                  serviceType: serviceTypeController.text.trim(),
                                  cost: double.parse(costController.text.trim()),
                                  userID: userID,
                                );
                                context
                                    .read<UserDeviceProvider>()
                                    .addGeneratorServiceRecordMethod(
                                      params: newRecord,
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
      builder: (context, udp, child) {
        if (udp.fetchSourceStatus == .loading ||
            udp.fetchSourceStatus == .init) {
          return const Center(child: CircularProgressIndicator());
        }
        if (udp.fetchSourceStatus == .failed) {
          return NoDataWidget(title: 'No Service History found');
        }

        return Column(
          crossAxisAlignment: .stretch,
          children: [
            ...udp.devices
                .where(
                  (d) =>
                      d.applicationType.toString().toLowerCase() == 'dg' ||
                      d.applicationType.toString().toLowerCase() == 'mg',
                )
                .map(
                  (device) => device.generatorModel != null
                      ? Container(
                          margin: .only(bottom: 12),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: .circular(16),
                            border: .all(color: theme.dividerColor, width: 1),
                          ),
                          child: ExpansionTile(
                            tilePadding: .symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(16),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: .circular(16),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: theme.primaryColor.withValues(
                                alpha: 0.12,
                              ),
                              child: Icon(
                                Icons.memory_outlined,
                                color: theme.primaryColor,
                              ),
                            ),
                            title: Text(
                              device.generatorModel!.generatorName.toString(),
                            ),
                            children: [
                              device.serviceHistory!.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: device.serviceHistory!.length,
                                      itemBuilder: (context, index) {
                                        final record =
                                            device.serviceHistory![index];
                                        return ServiceCardWidget(model: record);
                                      },
                                    )
                                  : Padding(
                                      padding: .symmetric(vertical: 12),
                                      child: Row(
                                        crossAxisAlignment: .center,
                                        mainAxisAlignment: .center,
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.grey,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'No service history found.',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton.icon(
                                  onPressed: () => _showAddServiceBottomSheet(
                                    context,
                                    device,
                                  ),
                                  icon: Icon(Icons.add),
                                  label: Text('Add Service Record'),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                ),
          ],
        );
      },
    );
  }
}
