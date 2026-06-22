import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class UserDetailSection extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Widget child;
  final void Function()? onPressedFunction;
  const UserDetailSection({
    super.key,
    required this.iconData,
    required this.title,
    required this.child,
    this.onPressedFunction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // padding: .all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(20),
        // border: .all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: .symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.7),
              borderRadius: .vertical(top: .circular(20)),
            ),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Container(
                        // padding: .all(7),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.12),
                          shape: .circle,
                        ),
                        child: Icon(iconData, color: Colors.white, size: 16),
                      ),
                      SizedBox(width: AppSizes.width(2)),
                      Text(
                        title,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.12),
                    shape: .circle,
                  ),
                  child: IconButton(
                    onPressed: onPressedFunction,
                    icon: Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(2)),
          child,
        ],
      ),
    );
  }
}
