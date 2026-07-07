import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/provider/local_notification_provider.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/routes/app_route_paths.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/biometric_function.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';

class GeneratorDetail extends StatefulWidget {
  final Generator? generator;
  final bool isGeneratorAvailable;
  final String deviceID;
  final bool isOnStatus;
  const GeneratorDetail({
    super.key,
    required this.generator,
    this.isGeneratorAvailable = true,
    required this.deviceID,
    this.isOnStatus = false,
  });

  @override
  State<GeneratorDetail> createState() => _GeneratorDetailState();
}

class _GeneratorDetailState extends State<GeneratorDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnimation;
  bool _generatorOn = true;
  Generator? generator;

  @override
  void initState() {
    super.initState();
    generator = widget.generator;
    _generatorOn = widget.isOnStatus;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: .symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(color: theme.primaryColor.withValues(alpha: 0.4)),
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

          GestureDetector(
            onTap: () {
              context.pushNamed(
                generatorMantaincesScreen,
                extra: MaintenanceParams(
                  deviceID: widget.deviceID,
                  isAdmin: false,
                ),
              );
            },
            child: Padding(
              padding: .symmetric(horizontal: 16),
              child: Container(
                padding: .symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: .circular(10),
                  border: .all(
                    color: theme.primaryColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'View service history',
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_outlined),
                  ],
                ),
              ),
            ),
          ),
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
                        ? widget.isOnStatus
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
                  ? widget.isOnStatus
                        ? const Color(0xFFDCFCE7)
                        : Colors.grey.withAlpha(45)
                  : Colors.grey.withAlpha(45),
              borderRadius: .circular(20),
            ),
            child: Text(
              widget.isGeneratorAvailable
                  ? widget.isOnStatus
                        ? AppLocale.running.getString(context).toUpperCase()
                        : AppLocale.idle.getString(context).toUpperCase()
                  : "N/A",
              style: theme.textTheme.bodySmall!.copyWith(
                color: widget.isGeneratorAvailable
                    ? widget.isOnStatus
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
              // _authenticateWithBiometrics();
              // generatorOnOROFF();
              setState(() {
                _generatorOn = !_generatorOn;
              });
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
                  'Next service duedate',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  '20 Aug 2026',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: .start,
          //     children: [
          //       Text(
          //         'Comsumption',
          //         style: theme.textTheme.bodySmall!.copyWith(
          //           fontWeight: .w700,
          //           fontSize: 10,
          //           color: Colors.grey,
          //           letterSpacing: 0.8,
          //         ),
          //       ),
          //       SizedBox(height: AppSizes.height(0.5)),
          //       Text(
          //         '${widget.isGeneratorAvailable ? generator!.current ?? '-' : '-'} Units',
          //         style: theme.textTheme.titleSmall!.copyWith(
          //           fontWeight: .bold,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                  AppLocale.output.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  '${widget.isGeneratorAvailable ? generator!.current ?? '-' : '-'} V',
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
                  'Comsumption',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  '${widget.isGeneratorAvailable ? generator!.current ?? '-' : '-'} Units',
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
                  '${AppLocale.duration.getString(context)}(${AppLocale.count.getString(context)})',
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
                      ? '${generator!.runtimeHours != null ? generator!.runtimeHours!.floor() : '-'} min(${generator!.startCount}) '
                      : "-",
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
                ],
              ),
              SizedBox(height: AppSizes.height(2)),
              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  InkWell(
                    onLongPress: () {},
                    child: _CircularGauge(
                      value: 0.5,
                      // value: generator != null
                      //     ? widget.isGeneratorAvailable
                      //           ? generator!.oilPressure != null
                      //                 ? (generator!.oilPressure! / 100) *
                      //                       _progressAnimation.value
                      //                 : 0
                      //           : 0
                      //     : 0,
                      label: 'Water level',
                      displayValue:
                          '${widget.isGeneratorAvailable
                              ? generator!.oilPressure != null
                                    ? generator!.oilPressure!.floor()
                                    : 0
                              : '-'}%',
                      color: AppStatusColors.success,
                    ),
                  ),
                  InkWell(
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
                    child: _CircularGauge(
                      value: generator != null
                          ? widget.isGeneratorAvailable
                                ? generator!.engineTemperature != null
                                      ? (generator!.engineTemperature! / 100) *
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
                'Estimated runtime at current fuel level',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: .w700,
                  fontSize: 10,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                widget.isGeneratorAvailable ? '12.4 Hrs' : '-',
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
                      ? 0.45 * _progressAnimation.value
                      : 0,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
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
                'Average Runtime (100% Tank)',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: .w700,
                  fontSize: 10,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                widget.isGeneratorAvailable ? '18 Hrs' : '-',
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
                  color: const Color(0xFF1A202C),
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
