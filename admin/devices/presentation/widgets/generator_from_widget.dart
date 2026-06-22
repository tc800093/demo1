import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/common/widgets/custom_dropdown_list_widget.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/validator.dart';
import 'package:poweriot/features/admin/devices/presentation/screens/add_device_screen_v2.dart';

class GeneratorFromWidget extends StatelessWidget {
  final TextEditingController generatorName;
  final TextEditingController generatorMode;
  final TextEditingController generatorFuelType;
  final TextEditingController generatorcapacity;
  final TextEditingController generatorFuelCapacity;
  final TextEditingController generatorInstallDate;
  final TextEditingController generatorwarrantyDate;
  final TextEditingController generatorCompany;
  final List<DeviceType> typeList;
  final DeviceType? selected;
  final void Function(DeviceType?)? onChangedGeneratorType;
  const GeneratorFromWidget({
    super.key,
    required this.generatorFuelCapacity,
    required this.generatorFuelType,
    required this.generatorInstallDate,
    required this.generatorMode,
    required this.generatorName,
    required this.generatorcapacity,
    required this.generatorwarrantyDate,
    required this.generatorCompany,
    required this.typeList,
    this.selected,
    this.onChangedGeneratorType,
  });

  @override
  Widget build(BuildContext context) {
    return CustomExpansionCard(
      iconData: Icons.power,
      title:
          '${AppLocale.generator.getString(context)} ${AppLocale.info.getString(context)}',
      child: Padding(
        padding: .symmetric(horizontal: 8, vertical: 5),
        child: Column(
          children: [
            CustomTextfieldWidget(
              controller: generatorName,
              title: AppLocale.generatorName.getString(context),
              validatorFunction: (value) => Validator.text(value),
            ),

            SizedBox(height: AppSizes.height(1)),
            CustomTextfieldWidget(
              controller: generatorCompany,
              title: AppLocale.manufacture.getString(context),
              validatorFunction: (value) => Validator.text(value),
            ),

            SizedBox(height: AppSizes.height(1)),
            CustomTextfieldWidget(
              controller: generatorMode,
              title: AppLocale.model.getString(context),
              validatorFunction: (value) => Validator.text(value),
            ),

            SizedBox(height: AppSizes.height(1)),
            // CustomTextfieldWidget(
            //   controller: TextEditingController(),
            //   title: 'Serial Number',
            //   validatorFunction: (value) => Validator.text(value),
            // ),
            // SizedBox(height: AppSizes.height(1)),
            CustomDropdownWidget<DeviceType>(
              title:
                  "${AppLocale.select.getString(context)} ${AppLocale.fuel.getString(context)} ${AppLocale.type.getString(context)}",
              items: typeList,
              value: selected,
              itemLabelBuilder: (device) => device.typeName.toString(),
              onChanged: onChangedGeneratorType,
              validator: (value) {
                if (value == null) {
                  return "Please select a fuel Type";
                }
                return null;
              },
            ),
            SizedBox(height: AppSizes.height(1)),
            CustomTextfieldWidget(
              controller: generatorcapacity,
              title: AppLocale.capacityKva.getString(context),
              inputKeyBoard: .number,
              validatorFunction: (value) => Validator.text(value),
            ),
            // SizedBox(height: AppSizes.height(1)),
            // CustomTextfieldWidget(
            //   controller: TextEditingController(),
            //   title: 'Capacity KW',
            //   inputKeyBoard: .phone,
            //   validatorFunction: (value) => Validator.phone(value),
            // ),
            SizedBox(height: AppSizes.height(1)),
            CustomTextfieldWidget(
              controller: generatorFuelCapacity,
              title: AppLocale.fuelCapacity.getString(context),
              inputKeyBoard: .number,
              validatorFunction: (value) => Validator.text(value),
            ),
            SizedBox(height: AppSizes.height(1)),
            CustomTextfieldWidget(
              controller: generatorInstallDate,
              title: AppLocale.installation.getString(context),
              inputKeyBoard: .datetime,
              validatorFunction: (value) => Validator.text(value),
            ),
            // SizedBox(height: AppSizes.height(1)),
            // CustomTextfieldWidget(
            //   controller: generatorwarrantyDate,
            //   title: "Warranty Expiry Date",
            //   inputKeyBoard: .datetime,
            //   validatorFunction: (value) => Validator.text(value),
            // ),

            // SizedBox(height: AppSizes.height(1)),
            // CustomTextfieldWidget(
            //   controller: TextEditingController(),
            //   title: "Next Maintenance Date",
            //   inputKeyBoard: .phone,
            //   validatorFunction: (value) => Validator.text(value),
            // ),
            // SizedBox(height: AppSizes.height(1)),
            // CustomTextfieldWidget(
            //   controller: TextEditingController(),
            //   title: "Supplier Name",
            //   inputKeyBoard: .text,
            //   validatorFunction: (value) => Validator.text(value),
            // ),
            // SizedBox(height: AppSizes.height(1)),
            // CustomTextfieldWidget(
            //   controller: TextEditingController(),
            //   title: "Supplier Contact",
            //   inputKeyBoard: .phone,
            //   validatorFunction: (value) => Validator.text(value),
            // ),
            SizedBox(height: AppSizes.height(1)),
          ],
        ),
      ),
    );
  }
}
