import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class GeneratorStatusCard extends StatefulWidget {
  const GeneratorStatusCard({super.key});

  @override
  State<GeneratorStatusCard> createState() => _GeneratorStatusCardState();
}

class _GeneratorStatusCardState extends State<GeneratorStatusCard>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation =
        Tween<double>(begin: 0.88, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 4),
          _buildAlternatorRow(),
          const SizedBox(height: 12),
          _buildWaveform(),
          const SizedBox(height: 14),
          _buildVoltagePhaseLine(),
          const SizedBox(height: 14),
          _buildStatsRow(),
          const SizedBox(height: 14),
          _buildPhaseChips(),
          const SizedBox(height: 14),
          _buildAutomaticMonitoring(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.settings_input_component_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generator',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '3-phase diesel generator',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Running badge with pulse
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.success.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.65),
                              blurRadius: 6,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Running',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Alternator row ────────────────────────────────────────────────────────
  Widget _buildAlternatorRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.primary.withOpacity(0.5), blurRadius: 6)
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Alternator ON',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Animated 3-phase waveform ─────────────────────────────────────────────
  Widget _buildWaveform() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _WaveformPainter(
                    progress: _waveController.value,
                  ),
                  size: const Size(double.infinity, 80),
                );
              },
            ),
            // Phase labels
            Positioned(
              right: 8,
              top: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PhaseLabel(label: 'R', color: AppColors.danger),
                  const SizedBox(height: 4),
                  _PhaseLabel(label: 'Y', color: AppColors.warning),
                  const SizedBox(height: 4),
                  _PhaseLabel(label: 'B', color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Voltage phase value row ────────────────────────────────────────────────
  Widget _buildVoltagePhaseLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Running indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.success.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.play_arrow_rounded,
                    color: AppColors.success, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Running',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Generator Voltage
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generator Voltage',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '415V',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Current Voltage
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Current Voltage',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '415V',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stats row: 8 Vrms, 4Jms, 12000 ──────────────────────────────────────
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatBox(
              topLabel: 'Voltage Current',
              value: '8 Vrms / Clrv',
              subValue: '4Jms',
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatBox(
              topLabel: 'Current Voltage',
              value: '12000',
              subValue: 'Watts total load',
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  // ── Phase chips ───────────────────────────────────────────────────────────
  Widget _buildPhaseChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _PhaseChip(label: 'R Phase', color: AppColors.danger),
          const SizedBox(width: 8),
          _PhaseChip(label: 'Y Phase', color: AppColors.warning),
          const SizedBox(width: 8),
          _PhaseChip(label: 'B Phase', color: AppColors.primary),
        ],
      ),
    );
  }

  // ── Automatic Monitoring ──────────────────────────────────────────────────
  Widget _buildAutomaticMonitoring() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monitor_heart_rounded,
                        color: AppColors.primary, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Automatic Monitoring',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '15 / 100',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: 0.15,
                backgroundColor: AppColors.border,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Load banking',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.success.withOpacity(0.5),
                              blurRadius: 4)
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Active',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ─────────────────────────────────────────────────────────

class _PhaseLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _PhaseLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 16,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _PhaseChip extends StatelessWidget {
  final String label;
  final Color color;
  const _PhaseChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)
                ],
              ),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String topLabel;
  final String value;
  final String subValue;
  final Color color;
  const _StatBox({
    required this.topLabel,
    required this.value,
    required this.subValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topLabel,
            style: GoogleFonts.inter(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subValue,
            style: GoogleFonts.inter(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Waveform Painter ────────────────────────────────────────────────────────

class _WaveformPainter extends CustomPainter {
  final double progress;
  _WaveformPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    // R=red, Y=yellow, B=blue — 3 phases offset by 120°
    final phaseData = [
      (AppColors.danger, 0.0),
      (AppColors.warning, 2 * math.pi / 3),
      (AppColors.primary, 4 * math.pi / 3),
    ];

    final padding = 12.0;
    final usableWidth = size.width - padding * 2;
    final centerY = size.height / 2;
    final amplitude = size.height * 0.28;
    const cycles = 2.5;

    for (final (color, phaseOffset) in phaseData) {
      paint.color = color.withOpacity(0.75);
      final path = Path();
      for (double px = 0; px <= usableWidth; px++) {
        final t = px / usableWidth;
        final y = centerY +
            amplitude *
                math.sin(
                    cycles * 2 * math.pi * t +
                        phaseOffset -
                        progress * 2 * math.pi);
        if (px == 0) {
          path.moveTo(padding + px, y);
        } else {
          path.lineTo(padding + px, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) => old.progress != progress;
}
