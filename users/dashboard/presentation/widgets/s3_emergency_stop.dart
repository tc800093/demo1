import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/biometric_function.dart';

class S3EmergencyStopCard extends StatefulWidget {
  const S3EmergencyStopCard({super.key});

  @override
  State<S3EmergencyStopCard> createState() => _S3EmergencyStopCardState();
}

class _S3EmergencyStopCardState extends State<S3EmergencyStopCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.35, end: 0.85).animate(_glowController);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _showConfirm() async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: Duration(milliseconds: 260),
      transitionBuilder: (ctx, anim, _, child) => ScaleTransition(
        scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: anim, child: child),
      ),
      pageBuilder: (ctx, _, _) => _EmergencyDialog(),
    );
    if (confirmed == true) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 900));
      setState(() => _isLoading = false);
      if (mounted) {
        AppSnackbar.error(context, 'Emergency stop executed');
      }
    }
  }

  Future<void> generatorOnOROFF() async {
    BiometricFunction bio = BiometricFunction();
    final isSupported = await bio.isSupported();
    if (isSupported) {
      final isBioMetricAuth = await bio.authenticate(reaseon: "Local Auth");
      if (isBioMetricAuth) {
      } else {
        AppSnackbar.error(context, "Biometric failed");
      }
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: .symmetric(horizontal: 16),
      padding: .symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(16),
        border: .all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section title
          Padding(
            padding: .symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: .circle,
                  ),
                ),
                SizedBox(width: AppSizes.width(2)),
                Text(
                  '${AppLocale.generator.getString(context)} ${AppLocale.control.getString(context)}',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(3)),
          // Emergency button
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (context, child) {
              return GestureDetector(
                onTap: _isLoading ? null : _showConfirm,
                child: Stack(
                  alignment: .center,
                  children: [
                    // Outer glow
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: Color(
                          0xFFEF4444,
                        ).withValues(alpha: _glowAnim.value * 0.12),
                      ),
                    ),
                    // Core red circle
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: const Color(0xFFEF4444),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFEF4444,
                            ).withValues(alpha: _glowAnim.value * 0.45),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Icon(
                              Icons.power_off_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          Text(
            '${AppLocale.emergency.getString(context)} ${AppLocale.stop.getString(context)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFEF4444),
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: .symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(22),
            border: .all(color: const Color(0xFFFECACA), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                blurRadius: 30,
                spreadRadius: 4,
              ),
              const BoxShadow(color: Colors.black12, blurRadius: 20),
            ],
          ),
          child: Padding(
            padding: .fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: .min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: Color(0xFFFEE2E2),
                    border: .all(color: Color(0xFFFCA5A5), width: 2),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFEF4444),
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${AppLocale.emergency.getString(context)} ${AppLocale.stop.getString(context)}?',
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: .bold,
                  ),
                ),
                SizedBox(height: AppSizes.height(1)),
                Text(
                  AppLocale.emergencypopupwarning1.getString(context),
                  // 'This will immediately halt the generator without a cool-down cycle.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: AppSizes.height(2)),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFF97316),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocale.emergencypopupwarning2.getString(context),
                          // 'All active loads will be interrupted immediately',
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: const Color(0xFF9A3412),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.height(2.2)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(false),
                        child: Container(
                          padding: .symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: .circular(12),
                            border: .all(color: Color(0xFFE2E8F0)),
                          ),
                          alignment: .center,
                          child: Text(
                            AppLocale.cancel.getString(context),
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => (Navigator.of(context).pop(true)),
                        child: Container(
                          padding: .symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                            ),
                            borderRadius: .circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFEF4444,
                                ).withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: .center,
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              const Icon(
                                Icons.stop_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: AppSizes.width(1)),
                              Text(
                                AppLocale.stop.getString(context),
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
