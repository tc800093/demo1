import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/provider/local_notification_provider.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/routes/app_route_paths.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/biometric_function.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/user/dashboard/data/datasources/local_datasource/dashboard_local_datasource.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:super_tooltip/super_tooltip.dart';

class GeneratorDetail extends StatefulWidget {
  final Generator? generator;
  final bool isGeneratorAvailable;
  final String deviceID;
  final bool isOnStatus;
  final bool isGeneratorOn;
  final DashboardModel? dashboardModel;
  const GeneratorDetail({
    super.key,
    required this.generator,
    this.isGeneratorAvailable = true,
    required this.deviceID,
    this.isOnStatus = false,
    this.isGeneratorOn = false,
    this.dashboardModel,
  });

  @override
  State<GeneratorDetail> createState() => _GeneratorDetailState();
}

class _GeneratorDetailState extends State<GeneratorDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnimation;
  final _fuelcontroller = SuperTooltipController();
  final _oilcontroller = SuperTooltipController();
  final _coolantcontroller = SuperTooltipController();
  final _tempcontroller = SuperTooltipController();
  bool _generatorOn = true;
  Generator? generator;

  int voltage = 0;
  int comsuption = 0;

  @override
  void initState() {
    super.initState();

    setValue();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _fuelcontroller.dispose();
    _oilcontroller.dispose();
    _coolantcontroller.dispose();
    _tempcontroller.dispose();
    super.dispose();
  }

  int generateRandomNumber(int min, int max) {
    return Random().nextInt(max - min + 1) + min;
  }

  String getRuntime({
    required DateTime lastUpdated,
    required String apiRuntime,
  }) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    // Use API value if updated within last 5 hours
    if (difference.inHours <= 5) {
      return apiRuntime;
    }

    // Otherwise calculate from last update till now
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String getGeneratorRuntime() {
    if (generator == null) return '-';

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    DateTime? lastUpdated;

    try {
      lastUpdated = DateTime.parse(
        widget.dashboardModel!.lastUpdated.toString(),
      );
    } catch (_) {
      lastUpdated = null;
    }

    int runtimeMinutes = 0;

    // Existing runtime from API (if available)
    if (generator!.runtimeHours != null) {
      runtimeMinutes = generator!.runtimeHours!.floor();
    }

    if (lastUpdated != null) {
      final isToday =
          lastUpdated.year == now.year &&
          lastUpdated.month == now.month &&
          lastUpdated.day == now.day;

      if (isToday) {
        // Add runtime from last update until now
        runtimeMinutes += now.difference(lastUpdated).inMinutes;
      } else {
        // Last update was yesterday or older
        // Only count today's runtime
        runtimeMinutes += now.difference(startOfDay).inMinutes;
      }
    } else {
      // If lastUpdated is invalid, assume runtime from today's start
      runtimeMinutes += now.difference(startOfDay).inMinutes;
    }

    return formatMinutes(runtimeMinutes);
  }

  void setValue() {
    debugPrint("GeneratorDetail: setValue() called. status: ${widget.generator?.status}, fuelLevel: ${widget.generator?.fuelLevel}");
    setState(() {
      generator = widget.generator;
      _generatorOn = widget.generator?.status ?? false;
      voltage = generateRandomNumber(50, 250);
      comsuption = generateRandomNumber(200, 500);
    });
  }

  @override
  void didUpdateWidget(covariant GeneratorDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint("GeneratorDetail: didUpdateWidget. oldGenerator hash: ${oldWidget.generator.hashCode}, newGenerator hash: ${widget.generator.hashCode}");
    if (widget.generator != oldWidget.generator) {
      debugPrint("GeneratorDetail: Generator reference changed. Updating values.");
      setValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: .symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(color: theme.colorScheme.primary.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _buildHeader(theme: theme),
          const SizedBox(height: 4),
          _buildSubtitle(),
          const Divider(color: Color(0xFFE2E8F0), height: 24),
          _buildToggleRow(theme: theme),
          const Divider(color: Color(0xFFE2E8F0), height: 24),
          _buildStatusRow(theme: theme),
          SizedBox(height: AppSizes.height(2)),
          _buildDurationRow(theme: theme),
          SizedBox(height: AppSizes.height(2)),
          _buildServiceStatusRow(theme: theme),
          SizedBox(height: AppSizes.height(2)),
          _buildCircularGauges(theme: theme),
          SizedBox(height: AppSizes.height(2)),
          _buildRuntimeBar(theme: theme),
          SizedBox(height: AppSizes.height(2)),
          if (generator != null)
            if (generator!.dgFaultStatus == true) ...[
              _buildWarningBanner(theme: theme),
              SizedBox(height: AppSizes.height(2)),
            ],

          _buildServiceHistoryButton(theme: theme),
          SizedBox(height: AppSizes.height(2)),
        ],
      ),
    );
  }

  Widget _buildHeader({required ThemeData theme}) {
    return Padding(
      padding: .fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          SizedBox(
            child: Row(
              children: [
                Container(
                  width: AppSizes.width(8),
                  height: AppSizes.height(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Image.asset(
                    generatorLogo,
                    color: generator != null
                        ? generator!.status! &&
                                  generator!.generatorHealth
                                          .toString()
                                          .toLowerCase() !=
                                      'critical'
                              ? AppStatusColors.success
                              : null
                        : blueGrey,
                  ),
                ),
                SizedBox(width: AppSizes.width(1)),
                Text(
                  AppLocale.generator.getString(context),
                  style: theme.textTheme.titleMedium!,
                ),
              ],
            ),
          ),
          Container(
            padding: .symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isGeneratorAvailable
                  ? generator!.status! &&
                            generator!.generatorHealth
                                    .toString()
                                    .toLowerCase() !=
                                'critical'
                        ? const Color(0xFFDCFCE7)
                        : Colors.grey.withAlpha(45)
                  : Colors.grey.withAlpha(45),
              borderRadius: .circular(20),
            ),
            child: Text(
              widget.isGeneratorAvailable
                  ? generator!.status! &&
                            generator!.generatorHealth
                                    .toString()
                                    .toLowerCase() !=
                                'critical'
                        ? AppLocale.running.getString(context)
                        : generator!.generatorHealth.toString().toLowerCase() !=
                              'critical'
                        ? AppLocale.idle.getString(context)
                        : 'Fault'
                  : "N/A",
              style: theme.textTheme.bodySmall!.copyWith(
                color: widget.isGeneratorAvailable
                    ? generator!.status!
                          ? const Color(0xFF16A34A)
                          : Colors.black
                    : Colors.black,
                fontWeight: .bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Text(
        AppLocale.generatorSubtitle.getString(context),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 10,
          color: slateDarkGrayColor,
        ),
      ),
    );
  }

  Widget _buildToggleRow({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.tune_rounded, color: Color(0xFF64748B), size: 18),
          SizedBox(width: AppSizes.width(2)),
          Text(
            '${AppLocale.generator.getString(context)} ${_generatorOn ? AppLocale.on.getString(context) : AppLocale.off.getString(context)}',
            style: theme.textTheme.titleMedium,
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              if (!widget.isGeneratorOn) {
                AppSnackbar.show(
                  context: context,
                  message:
                      'Generator cannot be controlled while Mains Power is the active.',
                );
              } else {
                if (generator!.dgFaultStatus == true) {
                  AppSnackbar.error(
                    context,
                    'Generator cannot be turned on due to ${generator!.warningMessage}',
                  );
                } else {
                  setState(() {
                    _generatorOn = !_generatorOn;
                  });
                }
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 48,
              height: 26,
              decoration: BoxDecoration(
                color: _generatorOn ? Color(0xFF2563EB) : lightSlateGrayColor,
                borderRadius: .circular(13),
              ),
              child: AnimatedAlign(
                duration: Duration(milliseconds: 250),
                alignment: _generatorOn ? .centerRight : .centerLeft,
                child: Container(
                  margin: .all(3),
                  width: AppSizes.width(6),
                  height: AppSizes.height(5),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    shape: .circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generatorOnOROFF() async {
    BiometricFunction bio = BiometricFunction();
    final isSupported = await bio.isSupported();
    if (isSupported == true) {
      final isBioMetricAuth = await bio.authenticate(reaseon: "Local Auth");
      if (isBioMetricAuth) {
        setState(() => _generatorOn = !_generatorOn);
      } else {}
    } else {
      setState(() {
        _generatorOn != !_generatorOn;
      });
    }
  }

  Widget _buildServiceStatusRow({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '${AppLocale.daily.getString(context)} ${AppLocale.fuel.getString(context)} ${AppLocale.comsumption.getString(context)}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  '${widget.generator!.dailyFuelUseage != null ? widget.generator!.dailyFuelUseage!.toStringAsFixed(2) : 0} L',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  AppLocale.nextServiceDue.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  widget.generator != null
                      ? widget.generator!.nextServiceDate != ""
                            ? DateFormat("dd MMM yyyy").format(
                                DateTime.parse(
                                  widget.generator!.nextServiceDate
                                      .toString()
                                      .trim(),
                                ),
                              )
                            : "-"
                      : '-',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '${AppLocale.output.getString(context)} ${AppLocale.voltage.getString(context)}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  '${widget.isGeneratorAvailable ? generator!.generatorVoltage ?? generator!.generatorVoltage : '-'} V',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  AppLocale.comsumption.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  '${widget.isGeneratorAvailable ? generator!.current ?? comsuption : comsuption} Units',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationRow({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '${AppLocale.duration.getString(context)} (${AppLocale.count.getString(context)})',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(1)),

                Text(
                  widget.isGeneratorAvailable
                      ? '${generator!.runtimeHours != null ? getGeneratorRuntimDuration(widget.dashboardModel) : '-'} (${generator!.startCount})'
                      : "-",
                  // widget.isGeneratorAvailable
                  //     ? '${getGeneratorRuntime()}(${generator!.startCount}) '
                  //     : "-",
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  AppLocale.health.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(1)),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: widget.isGeneratorAvailable
                            ? generator!.generatorHealth
                                          .toString()
                                          .toLowerCase() ==
                                      "healthy"
                                  ? AppStatusColors.success
                                  : generator!.generatorHealth
                                            .toString()
                                            .toLowerCase() ==
                                        "warning"
                                  ? Colors.orangeAccent
                                  : Colors.red
                            : blueGrey,
                        // widget.isGeneratorAvailable ? Colors.red : blueGrey,
                        shape: .circle,
                      ),
                    ),
                    SizedBox(width: AppSizes.width(1)),
                    Text(
                      generator != null
                          ? generator!.generatorHealth != null
                                ? generator!.generatorHealth
                                      .toString()
                                      .toUpperCase()
                                : "-"
                          : "-",
                      // widget.isGeneratorAvailable ? "BAD" : "-",
                      style: theme.textTheme.titleSmall!.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceHistoryButton({required ThemeData theme}) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          generatorMantaincesScreen,
          extra: MaintenanceParams(deviceID: widget.deviceID, isAdmin: false),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.history_rounded, size: 18, color: theme.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'View service history',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularGauges({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        generator = generator!.copyWith(
                          fuelLevel: generator!.dgFaultStatus != true ? 10 : 50,
                          dgFaultStatus: generator!.dgFaultStatus == true
                              ? false
                              : true,
                          warningMessage: "Low Fuel",
                        );
                      });
                      if (generator!.dgFaultStatus == true) {
                        service<LocalNotificationProvider>().showNotificaion(
                          id: 4,
                          title: "Low Fuel Warning",
                          body:
                              "Generator fuel level is low. Please refuel soon to ensure uninterrupted power backup.",
                        );
                      }
                    },
                    onDoubleTap: () {
                      _fuelcontroller.showTooltip();
                    },
                    child: SuperTooltip(
                      controller: _fuelcontroller,
                      content: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: generatorFuelTips.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(
                                  child: Text(
                                    generatorFuelTips[index],
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      child: _CircularGauge(
                        value: generator != null
                            ? widget.isGeneratorAvailable
                                  ? (generator!.fuelLevel! / 100) *
                                        _progressAnimation.value
                                  : 0
                            : 0,
                        label: AppLocale.fuel.getString(context),
                        displayValue: widget.isGeneratorAvailable
                            ? "${generator!.fuelLevel!.floor()}%"
                            : "-",
                        color: generator != null
                            ? generator!.fuelLevel! <= 15
                                  ? AppStatusColors.error
                                  : generator!.fuelLevel! <= 30
                                  ? AppStatusColors.warning
                                  : const Color(0xFF2563EB)
                            : blueGrey,
                      ),
                    ),
                  ),
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        generator = generator!.copyWith(
                          dgFaultStatus: generator!.dgFaultStatus == true
                              ? false
                              : true,
                          warningMessage: "Check Oil pressure",
                        );
                      });
                    },
                    onDoubleTap: () {
                      _oilcontroller.showTooltip();
                    },
                    child: SuperTooltip(
                      controller: _oilcontroller,
                      content: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: generatorOilPressureTips.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(
                                  child: Text(
                                    generatorOilPressureTips[index],
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      child: _CircularGauge(
                        value: generator != null
                            ? widget.isGeneratorAvailable
                                  ? generator!.oilPressure != null
                                        ? (generator!.oilPressure! / 100) *
                                              _progressAnimation.value
                                        : 0
                                  : 0
                            : 0,
                        label:
                            '${AppLocale.oil.getString(context)} ${AppLocale.press.getString(context)}',
                        displayValue:
                            '${widget.isGeneratorAvailable
                                ? generator!.oilPressure != null
                                      ? generator!.oilPressure!.floor()
                                      : 0
                                : '-'} PSI',
                        color: AppStatusColors.success,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.height(2)),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  InkWell(
                    onDoubleTap: () {
                      _coolantcontroller.showTooltip();
                    },
                    child: SuperTooltip(
                      controller: _coolantcontroller,
                      content: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: generatorCoolantTips.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: .symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: .start,
                              children: [
                                Text('• '),
                                Expanded(
                                  child: Text(
                                    generatorCoolantTips[index],
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      child: _CircularGauge(
                        // value: 0.5,
                        value: generator != null
                            ? widget.isGeneratorAvailable
                                  ? generator!.waterLevel != null
                                        ? (generator!.waterLevel! / 100) *
                                              _progressAnimation.value
                                        : 0
                                  : 0
                            : 0,
                        label: AppLocale.waterLevel.getString(context),
                        displayValue:
                            '${widget.isGeneratorAvailable
                                ? generator!.waterLevel != null
                                      ? generator!.waterLevel!.floor()
                                      : 0
                                : '-'}%',
                        color: AppStatusColors.success,
                      ),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () {
                      _tempcontroller.showTooltip();
                    },
                    onLongPress: () {
                      setState(() {
                        generator = generator!.copyWith(
                          dgFaultStatus: generator!.dgFaultStatus == true
                              ? false
                              : true,
                          warningMessage: "Critical high temp",
                        );
                      });
                    },
                    child: SuperTooltip(
                      controller: _tempcontroller,
                      content: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: generatorTemperatureTips.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• '),
                                Expanded(
                                  child: Text(
                                    generatorTemperatureTips[index],
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      child: _CircularGauge(
                        value: generator != null
                            ? widget.isGeneratorAvailable
                                  ? generator!.engineTemperature != null
                                        ? (generator!.engineTemperature! /
                                                  100) *
                                              _progressAnimation.value
                                        : 0
                                  : 0
                            : 0,
                        label: AppLocale.temp.getString(context),
                        displayValue:
                            '${widget.isGeneratorAvailable
                                ? generator!.engineTemperature != null
                                      ? generator!.engineTemperature!.toStringAsFixed(1)
                                      : 0
                                : '-'}°C',
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRuntimeBar({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                AppLocale.estimatedRuntimeCurrentFuel.getString(context),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: .w700,
                  fontSize: 10,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                widget.isGeneratorAvailable
                    ? formatHours(
                        widget
                                    .generator!
                                    .estimatedRuntimeBasedOnCurrentFuelInHours !=
                                null
                            ? widget
                                  .generator!
                                  .estimatedRuntimeBasedOnCurrentFuelInHours!
                            : 0.0,
                      )
                    : '-',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: .bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1)),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: .circular(6),
                child: LinearProgressIndicator(
                  value: widget.isGeneratorAvailable
                      ? ((widget
                                        .generator
                                        ?.estimatedRuntimeBasedOnCurrentFuelInHours ??
                                    0) /
                                (widget
                                        .generator
                                        ?.averageRuntimeRuntimeBasedIftFuelIsFullInHours ??
                                    1))
                            .clamp(0, 1.0)
                      : 0,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                  minHeight: 8,
                ),
              );
            },
          ),
          SizedBox(height: AppSizes.height(1)),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                AppLocale.averageRuntimeFullTank.getString(context),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: .w700,
                  fontSize: 10,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                widget.isGeneratorAvailable
                    ? formatHours(
                        widget
                                    .generator!
                                    .averageRuntimeRuntimeBasedIftFuelIsFullInHours !=
                                null
                            ? widget
                                  .generator!
                                  .averageRuntimeRuntimeBasedIftFuelIsFullInHours!
                            : 0.0,
                      )
                    : '-',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: .bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner({required ThemeData theme}) {
    return Padding(
      padding: .symmetric(horizontal: 16),
      child: Container(
        padding: .symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: .circular(10),
          border: .all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF59E0B),
              size: 18,
            ),
            SizedBox(width: AppSizes.width(2)),
            Expanded(
              child: Text(
                '${AppLocale.system.getString(context)} ${AppLocale.warning.getString(context)}: ${generator!.warningMessage.toString()} ',
                style: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular Gauge
class _CircularGauge extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String label;
  final String displayValue;
  final Color color;

  const _CircularGauge({
    required this.value,
    required this.label,
    required this.displayValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: CustomPaint(
            painter: _CirclePainter(value: value, color: color),
            child: Center(
              child: Text(
                displayValue,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 11,
                  fontWeight: .w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSizes.height(1)),
        Text(
          label,
          style: theme.textTheme.bodySmall!.copyWith(
            fontSize: 9,
            fontWeight: .w700,
            color: slateDarkGrayColor,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double value;
  final Color color;

  _CirclePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - 5;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7,
    );

    // Progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter old) => old.value != value;
}
