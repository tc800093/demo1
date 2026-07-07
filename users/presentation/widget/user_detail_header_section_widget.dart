import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class UserDetailHeaderSectionWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? contactNo;
  final void Function()? onPressed;
  const UserDetailHeaderSectionWidget({
    super.key,
    this.email,
    this.name,
    this.contactNo,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(20),
        border: .all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: .1,
                ),
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
              SizedBox(width: AppSizes.width(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name.toString(), style: theme.textTheme.titleMedium),
                    Text(email.toString(), style: theme.textTheme.bodySmall),
                    Text(
                      contactNo.toString(),
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: onPressed, icon: Icon(Icons.edit_outlined)),
            ],
          ),
        ],
      ),
    );
  }
}
