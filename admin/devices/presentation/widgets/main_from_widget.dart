import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/validator.dart';

class MainFromWidget extends StatelessWidget {
  final TextEditingController connectionName;
  final TextEditingController meterNumber;
  const MainFromWidget({
    super.key,
    required this.connectionName,
    required this.meterNumber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      iconData: Icons.power,
      title:
          '${AppLocale.mainPower.getString(context)} ${AppLocale.info.getString(context)}',
      child: Padding(
        padding: .symmetric(horizontal: 8, vertical: 5),
        child: Column(
          children: [
            CustomTextfieldWidget(
              controller: connectionName,
              title: AppLocale.name.getString(context),
              validatorFunction: (value) => Validator.text(value),
            ),

            SizedBox(height: AppSizes.height(1)),
            CustomTextfieldWidget(
              controller: meterNumber,
              title: AppLocale.meterNumber.getString(context),
              validatorFunction: (value) => Validator.text(value),
            ),

            SizedBox(height: AppSizes.height(1)),
          ],
        ),
      ),
    );
  }
}
