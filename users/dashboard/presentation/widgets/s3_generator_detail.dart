import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:local_auth/local_auth.dart';
import 'package:poweriot/core/constants/app_image_constant.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/biometric_function.dart';
import 'package:poweriot/features/users/dashboard/domain/model/dashboard_model.dart';

enum _SupportState { unknown, supported, unsupported }

class S3GeneratorDetailCard extends StatefulWidget {
  final Generator generator;
  const S3GeneratorDetailCard({super.key, required this.generator});

  @override
  State<S3GeneratorDetailCard> createState() => _S3GeneratorDetailCardState();
}

class _S3GeneratorDetailCardState extends State<S3GeneratorDetailCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _progressAnimation;
  bool _generatorOn = true;
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
    auth.isDeviceSupported().then(
      (bool isSupported) => setState(
        () => _supportState = isSupported
            ? _SupportState.supported
            : _SupportState.unsupported,
      ),
    );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    var authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        persistAcrossBackgrounding: true,
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on LocalAuthException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        if (e.code != LocalAuthExceptionCode.userCanceled &&
            e.code != LocalAuthExceptionCode.systemCanceled) {
          _authorized =
              'Error - ${e.code.name}${e.description != null ? ': ${e.description}' : ''}';
        }
      });
      return;
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Unexpected error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
      () => _authorized = authenticated ? 'Authorized' : 'Not Authorized',
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    var authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
      if (authenticated == true) {
        setState(() => _generatorOn = !_generatorOn);
      }
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on LocalAuthException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        if (e.code != LocalAuthExceptionCode.userCanceled &&
            e.code != LocalAuthExceptionCode.systemCanceled) {
          _authorized =
              'Error - ${e.code.name}${e.description != null ? ': ${e.description}' : ''}';
        }
      });
      return;
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Unexpected Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
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
          _buildCircularGauges(theme: theme),
          SizedBox(height: AppSizes.height(2)),
          _buildRuntimeBar(theme: theme),
          SizedBox(height: AppSizes.height(2)),

          if (widget.generator.warningStatus == true) ...[
            _buildWarningBanner(theme: theme),
            SizedBox(height: AppSizes.height(2)),
          ],
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
                    color: widget.generator.status! ? Colors.green : null,
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
              color: widget.generator.status!
                  ? const Color(0xFFDCFCE7)
                  : Colors.grey.withAlpha(45),
              borderRadius: .circular(20),
            ),
            child: Text(
              widget.generator.status!
                  ? AppLocale.running.getString(context).toUpperCase()
                  : AppLocale.idle.getString(context).toUpperCase(),
              style: theme.textTheme.bodySmall!.copyWith(
                color: widget.generator.status!
                    ? const Color(0xFF16A34A)
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
        style: TextStyle(fontSize: 10, color: const Color(0xFF94A3B8)),
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
              setState(() => _generatorOn = !_generatorOn);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 48,
              height: 26,
              decoration: BoxDecoration(
                color: _generatorOn ? Color(0xFF2563EB) : Color(0xFFCBD5E1),
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
      } else {
        AppSnackbar.error(context, "Biometric failed");
      }
    } else {
      setState(() {
        _generatorOn != !_generatorOn;
      });
    }
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
                  AppLocale.status.getString(context),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: .circle,
                      ),
                    ),
                    SizedBox(width: AppSizes.width(2)),
                    Text(
                      widget.generator.status! ? 'Running' : 'Idle',
                      style: theme.textTheme.titleSmall!.copyWith(
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '${AppLocale.output.getString(context)} ${AppLocale.count.getString(context)}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(0.5)),
                Text(
                  '${widget.generator.outputVoltage} V',
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
                  '${AppLocale.start.getString(context)} ${AppLocale.count.getString(context)} / ${AppLocale.duration.getString(context)}',
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: .w700,
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSizes.height(1)),
                Text(
                  '${widget.generator.startCount} / ${widget.generator.runtimeMinutes ?? '2'} Hr',
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
                  '${AppLocale.health.getString(context)} ${AppLocale.status.getString(context).toUpperCase()}',
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
                        color:
                            widget.generator.healthStatus
                                    .toString()
                                    .toLowerCase() ==
                                "good"
                            ? Color(0xFF10B981)
                            : widget.generator.healthStatus
                                      .toString()
                                      .toLowerCase() ==
                                  "warning"
                            ? Colors.orangeAccent
                            : Colors.red,
                        shape: .circle,
                      ),
                    ),
                    SizedBox(width: AppSizes.width(1)),
                    Text(
                      widget.generator.healthStatus.toString().toUpperCase(),
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
          return Row(
            mainAxisAlignment: .spaceAround,
            children: [
              _CircularGauge(
                value:
                    (widget.generator.fuelLevel! / 100) *
                    _progressAnimation.value,
                label: AppLocale.fuel.getString(context),
                displayValue: '',
                color: const Color(0xFF2563EB),
              ),
              _CircularGauge(
                value:
                    (widget.generator.oilPressure! / 100) *
                    _progressAnimation.value,
                label:
                    '${AppLocale.oil.getString(context)} ${AppLocale.press.getString(context)}',
                displayValue: '${widget.generator.oilPressure!.floor()} PSI',
                color: const Color(0xFF10B981),
              ),
              _CircularGauge(
                value:
                    (widget.generator.engineTemperature! / 100) *
                    _progressAnimation.value,
                label: AppLocale.temp.getString(context),
                displayValue:
                    '${widget.generator.engineTemperature!.toStringAsFixed(1)}°C',
                color: const Color(0xFFF59E0B),
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
                '${AppLocale.runtime.getString(context).toUpperCase()} ${AppLocale.runtime.getString(context).toUpperCase()}',
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: .w700,
                  fontSize: 10,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '12.4 Hrs',
                style: theme.textTheme.titleSmall!.copyWith(fontWeight: .bold),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(1)),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.45 * _progressAnimation.value,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF2563EB),
                  ),
                  minHeight: 8,
                ),
              );
            },
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppLocale.generatorRuntimemsg.getString(context),
              style: TextStyle(fontSize: 9, color: const Color(0xFF94A3B8)),
            ),
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
                '${AppLocale.system.getString(context)} ${AppLocale.warning.getString(context)}: ${widget.generator.warningMessage.toString()} ',
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
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A202C),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
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
