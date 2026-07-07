import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/common/domain/model/generator_refuel_history_model.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_Refuel_record_usecase.dart';
import 'package:poweriot/core/common/provider/maintenance_log_provider.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/common/widgets/no_data_widget.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/routes/app_route_paths.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/core/common/widgets/refeul_history_widget.dart';
import 'package:poweriot/core/common/widgets/service_history_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GeneratorMaintenanceScreen extends StatefulWidget {
  final MaintenanceParams params;
  const GeneratorMaintenanceScreen({super.key, required this.params});

  @override
  State<GeneratorMaintenanceScreen> createState() =>
      _GeneratorMaintenanceScreenState();
}

class _GeneratorMaintenanceScreenState
    extends State<GeneratorMaintenanceScreen> {
  TextEditingController refuelTypeController = TextEditingController();
  TextEditingController refuelDateTime = TextEditingController();
  TextEditingController refuelNote = TextEditingController();

  void selectDateFunction() async {
    DateTime? _selectedDate = await pickDate(context);
    refuelDateTime.text = dateToString(_selectedDate!);
  }

  @override
  void initState() {
    fetchGeneratorHistory();
    super.initState();
  }

  void fetchGeneratorHistory() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaintenanceLogProvider>().fetchGeneratorServiceHistoryMethod(
        deviceID: widget.params.deviceID,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: V3AppBarWidget(
        accountType: '2',
        userName: '',
        title: 'Maintenance log',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer2<DashboardProvider, MaintenanceLogProvider>(
          builder: (context, dp, mp, child) {
            if (mp.serviceHistoryStatus == Status.failed || mp.refuelHistoryStatus == Status.failed) {
              return Center(
                child: NoDataWidget(title: 'Failed to load maintenance logs'),
              );
            }
            if (mp.serviceHistoryStatus == Status.loading || mp.refuelHistoryStatus == Status.loading) {
              return Skeletonizer(
                enabled: true,
                child: Column(
                  children: [
                    _maintenanceCard(
                      theme,
                      GeneratorServiceHistoryModel(
                        cost: 0,
                        createdAt: DateTime.now(),
                        createdBy: '',
                        deviceId: "",
                        id: "",
                        nextServiceDate: DateTime.now(),
                        remarks: "",
                        serviceDate: DateTime.now(),
                        serviceProvider: "",
                        serviceType: "",
                      ),
                      null,
                    ),
                    SizedBox(height: AppSizes.height(2)),
                    CustomExpansionCard(
                      title: 'Service History',
                      iconData: Icons.workspace_premium_outlined,
                      child: ServiceHistorySection(
                        userId: '',
                        serviceHistory: [],
                      ),
                    ),
                    SizedBox(height: AppSizes.height(3)),
                    CustomExpansionCard(
                      title: 'Refuel History',
                      iconData: Icons.workspace_premium_outlined,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              );
            }
            if (mp.serviceHistoryStatus == Status.success && mp.refuelHistoryStatus == Status.success) {
              final lastService = mp.serviceHistoryModel.isNotEmpty ? mp.serviceHistoryModel.first : null;
              final lastRefuel = mp.refuelHistoryModel.isNotEmpty ? mp.refuelHistoryModel.first : null;
              return Column(
                children: [
                  _maintenanceCard(theme, lastService, lastRefuel),
                  SizedBox(height: AppSizes.height(2)),
                  CustomExpansionCard(
                    title: 'Service History',
                    iconData: Icons.workspace_premium_outlined,
                    child: ServiceHistorySection(
                      userId: '',
                      serviceHistory: mp.serviceHistoryModel,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(3)),
                  CustomExpansionCard(
                    title: 'Refuel History',
                    iconData: Icons.workspace_premium_outlined,
                    child: _buildLocalRefuelHistory(theme, mp),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLocalRefuelHistory(ThemeData theme, MaintenanceLogProvider mp) {
    final list = mp.refuelHistoryModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (list.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.grey, size: 18),
                const SizedBox(width: 8),
                Text(
                  'No refuel history found.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ] else ...[
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final record = list[index];
              final dateStr = record.refuelDate != null
                  ? DateFormat('dd MMM yyyy').format(record.refuelDate!)
                  : 'N/A';
              return Container(
                margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${record.totalCost?.toStringAsFixed(0) ?? '0'}',
                          style: theme.textTheme.titleSmall?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          dateStr,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: OutlinedButton.icon(
            onPressed: () => _showAddRefuelBottomSheet(context, widget.params.deviceID),
            icon: const Icon(Icons.add),
            label: const Text('Add Refuel Record'),
          ),
        ),
      ],
    );
  }

  void _showAddRefuelBottomSheet(BuildContext context, String deviceId) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final formKey = GlobalKey<FormState>();
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
            return Consumer<MaintenanceLogProvider>(
              builder: (ctx, mlp, child) {
                if (mlp.addRefuelStatus == Status.success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.success(context, 'Refuel Record Added');
                    mlp.resetAddRefuelStatus();
                    Navigator.of(ctx).pop();
                  });
                }
                if (mlp.addRefuelStatus == Status.failed) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AppSnackbar.error(
                      context,
                      mlp.refuelHistoryMessage.isNotEmpty
                          ? mlp.refuelHistoryMessage
                          : 'Failed to add refuel record',
                    );
                    mlp.resetAddRefuelStatus();
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
                          CustomTextfieldWidget(
                            controller: fuelAmountController,
                            title: 'Fuel Quantity (Liters)',
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
                            title: 'Total Cost',
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
                          GestureDetector(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: CustomTextfieldWidget(
                                controller: TextEditingController(
                                  text: DateFormat('dd MMM yyyy').format(selectedDate),
                                ),
                                title: 'Refuel Date',
                                prefixIconData: Icons.calendar_today_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextfieldWidget(
                            controller: notesController,
                            title: 'Remarks / Notes',
                            prefixIconData: Icons.notes,
                          ),
                          SizedBox(height: AppSizes.height(3)),
                          CustomButtonWidget(
                            title: 'Save Record',
                            isLoading: mlp.addRefuelStatus == Status.loading,
                            theme: theme,
                            onPressedFunction: () {
                              if (formKey.currentState!.validate()) {
                                final qty = double.parse(fuelAmountController.text);
                                final cost = double.parse(costController.text);
                                final rate = qty > 0 ? (cost / qty) : 0.0;
                                
                                final newRecord = AddGeneratorRefuelRecordParams(
                                  deviceId: deviceId,
                                  fuelQuantity: qty,
                                  fuelRate: rate,
                                  refuelDate: selectedDate.toIso8601String(),
                                  totalCost: cost,
                                  remarks: notesController.text,
                                );
                                context.read<MaintenanceLogProvider>().addGeneratorRefuelRecordMethod(
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

  Widget _maintenanceCard(
    ThemeData theme,
    GeneratorServiceHistoryModel? lastService,
    GeneratorRefuelHistoryModel? lastRefuel,
  ) {
    final lastRefuelStr = lastRefuel != null && lastRefuel.refuelDate != null
        ? DateFormat('dd MMM yyyy').format(lastRefuel.refuelDate!)
        : "NA";
    return CustomExpansionCard(
      initiallyExpanded: true,
      title: "Maintenance Information",
      iconData: Icons.handyman,
      child: Padding(
        padding: .all(16),
        child: Column(
          children: [
            DetailRow(
              icon: Icons.build_circle_outlined,
              title: "Last Service",
              value: lastService != null
                  ? DateFormat('dd MMM yyyy').format(lastService.serviceDate!)
                  : "NA",
            ),
            Divider(),
            DetailRow(
              icon: Icons.event_available,
              title: "Next Service",
              value: lastService != null
                  ? DateFormat(
                      'dd MMM yyyy',
                    ).format(lastService.nextServiceDate!)
                  : "NA",
            ),
            Divider(),
            DetailRow(
              icon: Icons.local_gas_station,
              title: "Last Refuel",
              value: lastRefuelStr,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title, textAlign: .left),
      trailing: Text(
        value,
        textAlign: .right,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final String title;
  final String date;
  final String subtitle;

  const HistoryTile({
    super.key,
    required this.title,
    required this.date,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: CircleAvatar(child: Icon(Icons.build, size: 18)),
      title: SizedBox(width: AppSizes.width(50), child: Text(title)),
      subtitle: Text(subtitle),
      trailing: Text(
        date,
        textAlign: .right,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
