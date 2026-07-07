import 'package:flutter/material.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/users/presentation/widget/user_detail_header_section_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserDetailLoadingWidget extends StatelessWidget {
  const UserDetailLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          UserDetailHeaderSectionWidget(
            email: "email@fmail.com",
            name: "User",
            onPressed: () {},
          ),

          SizedBox(height: AppSizes.height(3)),

          CustomExpansionCard(
            title: 'Customer Information',
            iconData: Icons.person_outline,
            child: Column(
              children: [
                _infoRow("Mobile", "+91 9876543210", theme),
                _infoRow("Company", "ABC Industries", theme),
                _infoRow("Address", "Mumbai, Maharashtra", theme),
              ],
            ),
          ),

          SizedBox(height: AppSizes.height(3)),
          CustomExpansionCard(
            title: 'Power Sources',
            iconData: Icons.electrical_services,
            child: Column(
              children: [
                SizedBox(height: AppSizes.height(2)),

                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add),
                  label: Text("Add Power Source"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _infoRow(String title, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
