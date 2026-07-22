import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/domain/model/generator_refuel_history_model.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/maintenance_log_provider.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/common/widgets/no_data_widget.dart';
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
      // context.read<MaintenanceLogProvider>().fetchGeneratorServiceHistoryMethod(
      //   deviceID: widget.params.deviceID,
      // );
      context.read<MaintenanceLogProvider>().fetchMaintenanceLogs(
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
        title: AppLocale.maintenanceLog.getString(context),
      ),
      body: SingleChildScrollView(
        padding: .all(16),
        child: Consumer2<DashboardProvider, MaintenanceLogProvider>(
          builder: (context, dp, mp, child) {
            if (mp.serviceHistoryStatus == .failed) {
              return Center(
                child: NoDataWidget(title: 'No Service History found'),
              );
            }
            if (mp.serviceHistoryStatus == .loading) {
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
                      GeneratorRefuelHistoryModel(
                        createdAt: DateTime.now(),
                        createdBy: "",
                        deviceId: "",
                        deviceLocation: '',
                        deviceName: '',
                        fuelQuantity: 0.0,
                        fuelRate: 0.0,
                        id: "",
                        refuelDate: DateTime.now(),
                        remarks: "",
                        totalCost: 0.0,
                      ),
                    ),
                    SizedBox(height: AppSizes.height(2)),
                    CustomExpansionCard(
                      title: AppLocale.serviceHistory.getString(context),
                      iconData: Icons.workspace_premium_outlined,
                      child: ServiceHistorySection(
                        userId: '',
                        serviceHistory: [],
                      ),
                    ),
                    SizedBox(height: AppSizes.height(3)),
                    CustomExpansionCard(
                      title: AppLocale.refeulHistory.getString(context),
                      iconData: Icons.workspace_premium_outlined,
                      child: RefuelHistorySection(userId: '', history: []),
                    ),
                  ],
                ),
              );
            }
            if (mp.serviceHistoryStatus == .success) {
              return Column(
                children: [
                  _maintenanceCard(
                    theme,
                    mp.serviceHistoryModel != null &&
                            mp.serviceHistoryModel!.isNotEmpty
                        ? mp.serviceHistoryModel!.first
                        : null,
                    mp.refuelHistoryModel != null &&
                            mp.refuelHistoryModel!.isNotEmpty
                        ? mp.refuelHistoryModel!.first
                        : null,
                  ),
                  SizedBox(height: AppSizes.height(2)),
                  // _historyExpansionTiles(theme),
                  CustomExpansionCard(
                    title: AppLocale.serviceHistory.getString(context),
                    iconData: Icons.workspace_premium_outlined,
                    child: ServiceHistorySection(
                      userId: '',
                      serviceHistory: mp.serviceHistoryModel != null
                          ? mp.serviceHistoryModel!
                          : [],
                    ),
                  ),
                  SizedBox(height: AppSizes.height(3)),
                  CustomExpansionCard(
                    title: AppLocale.refeulHistory.getString(context),
                    iconData: Icons.workspace_premium_outlined,
                    child: RefuelHistorySection(
                      userId: widget.params.deviceID,
                      history: mp.refuelHistoryModel != null
                          ? mp.refuelHistoryModel!
                          : [],
                    ),
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _maintenanceCard(
    ThemeData theme,
    GeneratorServiceHistoryModel? lastService,
    GeneratorRefuelHistoryModel? lastRefeul,
  ) {
    return CustomExpansionCard(
      initiallyExpanded: true,
      title: AppLocale.maintenanceInfo.getString(context),
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
              value: lastRefeul != null
                  ? DateFormat('dd MMM yyyy').format(lastRefeul.refuelDate!)
                  : "NA",
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
