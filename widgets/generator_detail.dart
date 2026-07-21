import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/provider/local_notification_provider.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/routes/app_route_paths.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_locale.dart';
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
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant GeneratorDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.generator != oldWidget.generator ||
        widget.isOnStatus != oldWidget.isOnStatus) {
      setState(() {
        generator = widget.generator;
        _generatorOn = widget.isOnStatus;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRunning = widget.isGeneratorAvailable && widget.isOnStatus;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRunning
              ? const Color(0xFF22C55E).withValues(alpha: 0.35)
              : theme.primaryColor.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isRunning
                ? AppStatusColors.success.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme: theme),
          const SizedBox(height: 2),
          _buildSubtitle(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: Color(0xFFE2E8F0), height: 1),
          ),
          _buildToggleRow(theme: theme),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(color: Color(0xFFE2E8F0), height: 1),
          ),
          const SizedBox(height: 6),
          _buildStatusGrid(theme: theme),
          const SizedBox(height: 16),
          _buildCircularGauges(theme: theme),
          const SizedBox(height: 16),
          _buildRuntimeBar(theme: theme),
          const SizedBox(height: 14),
          if (generator != null && generator!.dgFaultStatus == true) ...[
            _buildWarningBanner(theme: theme),
            const SizedBox(height: 14),
          ],
          _buildServiceHistoryButton(theme: theme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader({required ThemeData theme}) {
    final isRunning = widget.isGeneratorAvailable && widget.isOnStatus;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isRunning
                      ? AppStatusColors.success.withValues(alpha: 0.12)
                      : theme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  generatorLogo,
                  color: generator != null
                      ? (widget.isOnStatus ? AppStatusColors.success : Colors.grey)
                      : blueGrey,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                AppLocale.generator.getString(context),
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: widget.isGeneratorAvailable
                  ? (widget.isOnStatus
                      ? const Color(0xFFDCFCE7)
                      : Colors.grey.withValues(alpha: 0.15))
                  : Colors.grey.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.isGeneratorAvailable
                  ? (widget.isOnStatus
                      ? AppLocale.running.getString(context).toUpperCase()
                      : AppLocale.idle.getString(context).toUpperCase())
                  : "N/A",
              style: theme.textTheme.bodySmall!.copyWith(
                color: widget.isGeneratorAvailable
                    ? (widget.isOnStatus
                        ? const Color(0xFF16A34A)
                        : Colors.black87)
                    : Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        AppLocale.generatorSubtitle.getString(context),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 11,
              color: slateDarkGrayColor,
            ),
      ),
    );
  }

  Widget _buildToggleRow({required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, color: Color(0xFF64748B), size: 18),
          const SizedBox(width: 8),
          Text(
            '${AppLocale.generator.getString(context)} ${_generatorOn ? AppLocale.on.getString(context) : AppLocale.off.getString(context)}',
            style: theme.textTheme.titleMedium!.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                _generatorOn = !_generatorOn;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 48,
              height: 26,
              decoration: BoxDecoration(
                color: _generatorOn ? const Color(0xFF2563EB) : lightSlateGrayColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                alignment: _generatorOn ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(3),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
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
      }
    } else {
      setState(() {
        _generatorOn = !_generatorOn;
      });
    }
  }

  Widget _buildStatusGrid({required ThemeData theme}) {
    final double voltage = widget.isGeneratorAvailable ? (generator?.outputVoltage ?? 0.0) : 0.0;
    final double units = voltage / 1000.0;
    final String healthStr = generator != null && generator!.generatorHealth != null
        ? generator!.generatorHealth.toString().toUpperCase()
        : "-";

    Color healthColor = blueGrey;
    if (widget.isGeneratorAvailable && generator != null) {
      final h = generator!.generatorHealth.toString().toLowerCase();
      if (h == "healthy") {
        healthColor = AppStatusColors.success;
      } else if (h == "warning") {
        healthColor = Colors.orangeAccent;
      } else {
        healthColor = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTelemetryCard(
                  theme: theme,
                  title: AppLocale.output.getString(context),
                  value: widget.isGeneratorAvailable
                      ? '${voltage.toStringAsFixed(1)} V'
                      : '-',
                  icon: Icons.flash_on_rounded,
                  iconColor: theme.primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTelemetryCard(
                  theme: theme,
                  title: 'Consumption',
                  value: widget.isGeneratorAvailable
                      ? '${units.toStringAsFixed(3)} Units'
                      : '-',
                  icon: Icons.electric_bolt_rounded,
                  iconColor: const Color(0xFF0EA5E9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTelemetryCard(
                  theme: theme,
                  title: '${AppLocale.duration.getString(context)} (${AppLocale.count.getString(context)})',
                  value: widget.isGeneratorAvailable && generator != null
                      ? '${generator!.runtimeHours != null ? generator!.runtimeHours!.floor() : '-'} min (${generator!.startCount ?? 0})'
                      : "-",
                  icon: Icons.timer_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTelemetryCard(
                  theme: theme,
                  title: AppLocale.health.getString(context),
                  value: healthStr,
                  icon: Icons.favorite_outline_rounded,
                  iconColor: healthColor,
                  customBadge: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: healthColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.event_available_outlined,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Next service due date',
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Text(
                  '20 Aug 2026',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryCard({
    required ThemeData theme,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    Widget? customBadge,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (customBadge != null) ...[
                customBadge,
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularGauges({required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          ? (widget.isGeneratorAvailable
                              ? (generator!.fuelLevel! / 100) *
                                  _progressAnimation.value
                              : 0)
                          : 0,
                      label: AppLocale.fuel.getString(context),
                      displayValue: widget.isGeneratorAvailable
                          ? "${generator!.fuelLevel!.floor()}%"
                          : "-",
                      color: generator != null
                          ? (generator!.fuelLevel! <= 15
                              ? AppStatusColors.error
                              : (generator!.fuelLevel! <= 30
                                  ? AppStatusColors.warning
                                  : const Color(0xFF2563EB)))
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
                          ? (widget.isGeneratorAvailable
                              ? (generator!.oilPressure != null
                                  ? (generator!.oilPressure! / 100) *
                                        _progressAnimation.value
                                  : 0)
                              : 0)
                          : 0,
                      label:
                          '${AppLocale.oil.getString(context)} ${AppLocale.press.getString(context)}',
                      displayValue: widget.isGeneratorAvailable
                          ? (generator!.oilPressure != null
                              ? '${generator!.oilPressure!.floor()}'
                              : '0')
                          : '-',
                      color: AppStatusColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onLongPress: () {},
                    child: _CircularGauge(
                      value: generator != null
                          ? (widget.isGeneratorAvailable
                              ? (generator!.dailyFuelConsumption != null
                                  ? (generator!.dailyFuelConsumption! / 50.0) *
                                        _progressAnimation.value
                                  : 0)
                              : 0)
                          : 0,
                      label: 'Daily Fuel Use',
                      displayValue: widget.isGeneratorAvailable
                          ? (generator!.dailyFuelConsumption != null
                              ? '${generator!.dailyFuelConsumption!.toStringAsFixed(1)} L'
                              : '0 L')
                          : '-',
                      color: const Color(0xFF10B981),
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
                          ? (widget.isGeneratorAvailable
                              ? (generator!.engineTemperature != null
                                  ? (generator!.engineTemperature! / 100) *
                                        _progressAnimation.value
                                  : 0)
                              : 0)
                          : 0,
                      label: AppLocale.temp.getString(context),
                      displayValue: widget.isGeneratorAvailable
                          ? (generator!.engineTemperature != null
                              ? '${generator!.engineTemperature!.toStringAsFixed(1)}°C'
                              : '0°C')
                          : '-',
                      color: const Color(0xFFF59E0B),
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
    final double fuelLevel = generator?.fuelLevel ?? 0.0;
    final double fullTankRuntime = generator?.fullTankRuntime ?? 18.0;
    final double estimatedRuntime = (fuelLevel / 100.0) * fullTankRuntime;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated runtime at current fuel level',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.black87,
                ),
              ),
              Text(
                widget.isGeneratorAvailable
                    ? '${estimatedRuntime.toStringAsFixed(1)} Hrs'
                    : '-',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              final double ratio = (fullTankRuntime > 0)
                  ? (estimatedRuntime / fullTankRuntime)
                  : 0.45;
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: widget.isGeneratorAvailable
                      ? ratio.clamp(0.0, 1.0) * _progressAnimation.value
                      : 0,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                  minHeight: 8,
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average Runtime (100% Tank)',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                widget.isGeneratorAvailable
                    ? '${fullTankRuntime.toStringAsFixed(1)} Hrs'
                    : '-',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF59E0B),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${AppLocale.system.getString(context)} ${AppLocale.warning.getString(context)}: ${generator!.warningMessage.toString()} ',
                style: theme.textTheme.titleSmall!.copyWith(
                  fontSize: 12,
                  color: const Color(0xFFB45309),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceHistoryButton({required ThemeData theme}) {
    return GestureDetector(
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
              Icon(
                Icons.history_rounded,
                size: 18,
                color: theme.primaryColor,
              ),
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
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall!.copyWith(
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            color: slateDarkGrayColor,
            letterSpacing: 0.4,
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

