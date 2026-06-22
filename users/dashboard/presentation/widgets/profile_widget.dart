import 'package:flutter/material.dart';

// ─── Color constants for dark profile screen ──────────────────────────────────
class ProfileColors {
  static const Color bg = Color(0xFF0F1117);
  static const Color card = Color(0xFF1A1D27);
  static const Color cardBorder = Color(0xFF2D3748);
  static const Color yellow = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF4B5563);
  static const Color input = Color(0xFF111827);
  static const Color inputBorder = Color(0xFF374151);
  static const Color success = Color(0xFF10B981);
}

// ─── Profile Header ──────────────────────────────────────────────────────────

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProfileColors.bg,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF374151), Color(0xFF4B5563)],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: ProfileColors.cardBorder, width: 1.5),
            ),
            child: Center(
              child: Text(
                'AV',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PowerPulse Industrial',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ProfileColors.textPrimary,
                ),
              ),
              Text(
                'Enterprise Account',
                style: TextStyle(
                  fontSize: 10,
                  color: ProfileColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ProfileColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ProfileColors.cardBorder),
              ),
              child: const Icon(
                Icons.settings_rounded,
                color: ProfileColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── User Profile Card ────────────────────────────────────────────────────────

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'USER PROFILE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ProfileColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ProfileColors.yellow.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ProfileColors.yellow.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'AUTH: LEVEL 4',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: ProfileColors.yellow,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Form card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ProfileColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ProfileColors.cardBorder),
          ),
          child: Column(
            children: [
              _ProfileField(label: 'Full Name', hint: 'Alexander Vance'),
              const SizedBox(height: 14),
              _ProfileField(
                label: 'Email Address',
                hint: 'a.vance@powerpulse-industrial.com',
              ),
              const SizedBox(height: 14),
              _ProfileField(label: 'Phone Number', hint: '+1 (555) 882-9012'),
              const SizedBox(height: 18),
              // Update Profile button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: ProfileColors.yellow,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: ProfileColors.yellow.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String hint;

  const _ProfileField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: ProfileColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: ProfileColors.input,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ProfileColors.inputBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
                    fontSize: 13,
                    color: ProfileColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Main Power Source Card ───────────────────────────────────────────────────

class MainPowerSourceCard extends StatelessWidget {
  const MainPowerSourceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MAIN POWER SOURCE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ProfileColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: ProfileColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'STABLE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: ProfileColors.success,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Info card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ProfileColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ProfileColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Grid Node row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GRID NODE',
                        style: TextStyle(
                          fontSize: 9,
                          color: ProfileColors.textMuted,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'GN-X8829-PX',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: ProfileColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ProfileColors.yellow.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ProfileColors.yellow.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: ProfileColors.yellow,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(color: ProfileColors.cardBorder, height: 1),
              const SizedBox(height: 14),
              // Customer + Meter
              Row(
                children: [
                  _InfoField(label: 'Customer Number', value: '#4492-3301'),
                  _InfoField(label: 'Meter ID', value: 'MTR-88219-Q'),
                ],
              ),
              const SizedBox(height: 12),
              // Connection + Service Type
              Row(
                children: [
                  _InfoField(label: 'Connection', value: '3-Phase Industrial'),
                  _InfoField(label: 'Service Type', value: 'High-Voltage Line'),
                ],
              ),
              const SizedBox(height: 12),
              // Service Address
              Text(
                'Service Address',
                style: TextStyle(
                  fontSize: 9,
                  color: ProfileColors.textMuted,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: ProfileColors.textSecondary,
                    size: 13,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '782 Industrial Pkwy, Suite 400\nDetroit, MI 48201',
                      style: TextStyle(
                        fontSize: 12,
                        color: ProfileColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Edit Connection button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ProfileColors.cardBorder),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Connection',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ProfileColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Generator Details Card ───────────────────────────────────────────────────

class GeneratorDetailsCard extends StatelessWidget {
  const GeneratorDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'GENERATOR DETAILS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ProfileColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ProfileColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ProfileColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Auxiliary Asset label
              Text(
                'AUXILIARY ASSET',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: ProfileColors.yellow,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Titan-X Diesel 500',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: ProfileColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: ProfileColors.cardBorder, height: 1),
              const SizedBox(height: 14),
              // Fuel Type + Fuel Capacity
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fuel Type',
                          style: TextStyle(
                            fontSize: 9,
                            color: ProfileColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF3B82F6),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Low-Sulfur Diesel',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ProfileColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fuel Capacity',
                          style: TextStyle(
                            fontSize: 9,
                            color: ProfileColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.80,
                            backgroundColor: const Color(0xFF374151),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              ProfileColors.yellow,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '800 / 1000 Liters',
                          style: TextStyle(
                            fontSize: 10,
                            color: ProfileColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Voltage Output + IMEI
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Voltage Output',
                          style: TextStyle(
                            fontSize: 9,
                            color: ProfileColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '480.00 V AC',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: ProfileColors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System IMEI',
                          style: TextStyle(
                            fontSize: 9,
                            color: ProfileColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'IMEI: 8820-9912-4421',
                          style: TextStyle(
                            fontSize: 11,
                            color: ProfileColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Update Parameters button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ProfileColors.cardBorder),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        color: ProfileColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Update Parameters',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ProfileColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Info Field helper ────────────────────────────────────────────────────────

class _InfoField extends StatelessWidget {
  final String label;
  final String value;

  const _InfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: ProfileColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ProfileColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
