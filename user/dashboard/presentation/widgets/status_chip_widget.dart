import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class StatusChip extends StatefulWidget {
  final String label;
  final bool dot;
  final Color? dotColor;
  final IconData? icon;
  final ThemeData theme;

  const StatusChip({
    super.key,
    required this.label,
    this.dot = false,
    this.dotColor,
    this.icon,
    required this.theme,
  });

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.2,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 0, vertical: 5),
      child: Row(
        mainAxisSize: .min,
        children: [
          if (widget.dot) ...[
            FadeTransition(
              opacity: _controller,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: widget.dotColor,
                  shape: .circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.dotColor!.withValues(alpha: 0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSizes.width(1)),
          ],
          if (widget.icon != null) ...[
            Icon(widget.icon, color: Colors.white, size: 11),
            SizedBox(width: AppSizes.width(1)),
          ],
          Text(
            widget.label,
            style: widget.theme.textTheme.bodySmall!.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
