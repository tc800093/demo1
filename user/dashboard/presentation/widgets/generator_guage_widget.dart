import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/app_colors.dart';

class GeneratorGuageWidget extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final double percentValue;
  const GeneratorGuageWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
    required this.percentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            fit: .expand,
            children: [
              CircularProgressIndicator(
                value: percentValue,
                strokeWidth: 8,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  value,
                  textAlign: .center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, size: 14, color: blueGrey),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: blueGrey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
