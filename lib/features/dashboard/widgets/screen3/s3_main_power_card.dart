import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class S3MainPowerCard extends StatelessWidget {
  const S3MainPowerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildGaugeNumber(),
          const SizedBox(height: 4),
          _buildPhaseRow(),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF94A3B8),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Main Power Status',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A202C),
                ),
              ),
            ],
          ),
          Text(
            'Stats',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text(
            '0',
            style: GoogleFonts.inter(
              fontSize: 64,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2563EB),
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Combined Voltage / Frequency',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _PhaseBox(label: 'R-PHASE', status: 'off', color: const Color(0xFFEF4444)),
          const SizedBox(width: 8),
          _PhaseBox(label: 'Y-PHASE', status: 'off', color: const Color(0xFFF59E0B)),
          const SizedBox(width: 8),
          _PhaseBox(label: 'B-PHASE', status: 'off', color: const Color(0xFF2563EB)),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.power_rounded,
                  iconColor: const Color(0xFF2563EB),
                  label: 'Voltage-Current /\nDuration',
                  value: '0 Vrms / 0 Hr',
                  sub: '4km',
                  bgColor: const Color(0xFFEFF6FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.bar_chart_rounded,
                  iconColor: const Color(0xFF0EA5E9),
                  label: 'Consumption',
                  value: '1200 Unit',
                  bgColor: const Color(0xFFF0F9FF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  icon: Icons.waves_rounded,
                  iconColor: const Color(0xFF10B981),
                  label: 'Frequency',
                  value: '50 Hz',
                  sub: 'Standard range',
                  bgColor: const Color(0xFFF0FDF4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatBox(
                  icon: Icons.bolt_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  label: 'Power Factor',
                  value: '0.98',
                  sub: 'Efficient transmission',
                  bgColor: const Color(0xFFFFFBEB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseBox extends StatelessWidget {
  final String label;
  final String status;
  final Color color;

  const _PhaseBox({
    required this.label,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color.withOpacity(0.8),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? sub;
  final Color bgColor;

  const _StatBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.sub,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 13),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A202C),
            ),
          ),
          if (sub != null)
            Text(
              sub!,
              style: GoogleFonts.inter(
                fontSize: 9,
                color: const Color(0xFF94A3B8),
              ),
            ),
        ],
      ),
    );
  }
}
