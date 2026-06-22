import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_dropdown_list_widget.dart';
import 'package:poweriot/core/common/widgets/custom_expansiontile_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/validator.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/add_device_usecase.dart';
import 'package:poweriot/features/admin/devices/presentation/provider/device_provider.dart';
import 'package:poweriot/features/admin/devices/presentation/screens/add_device_screen_v2.dart';
import 'package:poweriot/features/admin/devices/presentation/widgets/generator_from_widget.dart';
import 'package:poweriot/features/admin/devices/presentation/widgets/main_from_widget.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';

List<DeviceType> typeList = [
  DeviceType(typeName: 'Main Power + GEN-SET', type: "MG"),
  DeviceType(typeName: 'Only Main Power', type: "MSEB"),
  DeviceType(typeName: 'Only Generator', type: "DG"),
];

DeviceType? selectedType;

class AddDeviceView extends StatefulWidget {
  final String? preSelectedUserId;
  const AddDeviceView({super.key, this.preSelectedUserId});

  @override
  State<AddDeviceView> createState() => _AddDeviceViewState();
}

class _AddDeviceViewState extends State<AddDeviceView> {
  TextEditingController deviceCodeController = TextEditingController();
  TextEditingController deviceNameController = TextEditingController();
  TextEditingController deviceTypeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController areaNameController = TextEditingController();

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  TextEditingController imeinoController = TextEditingController();
  TextEditingController simnnoController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  /// meter textfield
  TextEditingController connectionName = TextEditingController();
  TextEditingController meterNumber = TextEditingController();

  // generator textfield

  TextEditingController generatorName = TextEditingController();
  TextEditingController generatorMode = TextEditingController();
  TextEditingController generatorFuelType = TextEditingController();
  TextEditingController generatorcapacity = TextEditingController();
  TextEditingController generatorFuelCapacity = TextEditingController();
  TextEditingController generatorInstallDate = TextEditingController();
  TextEditingController generatorwarrantyDate = TextEditingController();
  TextEditingController generatorCompany = TextEditingController();

  List<DeviceType> typeList = [
    DeviceType(typeName: 'Main Power + GEN-SET', type: "MG"),
    DeviceType(typeName: 'Only Main Power', type: "MSEB"),
    DeviceType(typeName: 'Only Generator', type: "DG"),
  ];

  List<DeviceType> generatorType = [
    DeviceType(typeName: 'DIESEL', type: "DIESEL"),
    DeviceType(typeName: 'PETROL', type: "PETROL"),
    DeviceType(typeName: 'BIO_DIESEL', type: "BIO_DIESEL"),
    DeviceType(typeName: 'NATURAL_GAS', type: "NATURAL_GAS"),
    DeviceType(typeName: 'HYBRID', type: "HYBRID"),
  ];

  DeviceType? selectedGeneratorType;

  DeviceType? selectedType;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchDeviceData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (widget.isEdit == true) {
      //   context.read<DeviceProvider>().fetchAllUserMethod();
      // }
    });
  }

  @override
  void dispose() {
    deviceCodeController.dispose();
    deviceNameController.dispose();
    areaNameController.dispose();
    deviceTypeController.dispose();
    locationController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    radiusController.dispose();
    imeinoController.dispose();
    simnnoController.dispose();

    connectionName.dispose();
    meterNumber.dispose();
    generatorName.dispose();
    generatorMode.dispose();
    generatorFuelType.dispose();
    generatorcapacity.dispose();
    generatorFuelCapacity.dispose();
    generatorInstallDate.dispose();
    generatorwarrantyDate.dispose();
    generatorCompany.dispose();
    super.dispose();
  }

  void clearAll() {
    deviceCodeController.clear();
    deviceNameController.clear();
    areaNameController.clear();
    deviceTypeController.clear();
    locationController.clear();
    latitudeController.clear();
    longitudeController.clear();
    radiusController.clear();
    imeinoController.clear();
    simnnoController.clear();
    imeinoController.clear();
    simnnoController.clear();
    connectionName.clear();
    meterNumber.clear();
    generatorName.clear();
    generatorMode.clear();
    generatorFuelType.clear();
    generatorcapacity.clear();
    generatorFuelCapacity.clear();
    generatorInstallDate.clear();
    generatorwarrantyDate.clear();
    generatorCompany.clear();
  }

  void fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final deviceProvider = context.read<DeviceProvider>();
      await deviceProvider.fetchAllUserMethod();
      if (widget.preSelectedUserId != null && mounted) {
        try {
          final user = deviceProvider.userList.firstWhere(
            (u) => u.userId == widget.preSelectedUserId,
          );
          deviceProvider.selectUsers(user);
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: V3AppBarWidget(
        accountType: '2',
        userName: 'userName',
        title:
            '${AppLocale.add.getString(context)} ${AppLocale.devices.getString(context)}',
      ),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 10, vertical: 10),
        child: Consumer<DeviceProvider>(
          builder: (context, deviceProvider, child) {
            return Form(
              child: Column(
                children: [
                  SizedBox(height: AppSizes.height(1)),
                  SizedBox(height: AppSizes.height(2)),
                  CustomExpansionCard(
                    title:
                        "${AppLocale.iot.getString(context)} ${AppLocale.device.getString(context)} ${AppLocale.info.getString(context)}",
                    iconData: Icons.perm_device_information_outlined,
                    child: Column(
                      children: [
                        CustomDropdownWidget<DeviceType>(
                          title:
                              "${AppLocale.select.getString(context)} ${AppLocale.device.getString(context)} ${AppLocale.type.getString(context)}",
                          items: typeList,
                          value: selectedType,
                          itemLabelBuilder: (device) =>
                              device.typeName.toString(),
                          onChanged: (device) {
                            setState(() {
                              selectedType = device!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a device Type";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: AppSizes.height(1)),
                        CustomDropdownWidget<UserModel>(
                          title:
                              "${AppLocale.select.getString(context)} ${AppLocale.user.getString(context)}",
                          items: deviceProvider.userList,
                          value: deviceProvider.userData,
                          itemLabelBuilder: (user) => user.fullName.toString(),
                          onChanged: (user) {
                            deviceProvider.selectUsers(user);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a user";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: deviceCodeController,
                          title: AppLocale.deviceCode.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),

                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: deviceNameController,
                          title: AppLocale.deviceName.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),

                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: imeinoController,
                          title: AppLocale.imeiNo.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),
                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: simnnoController,
                          title: AppLocale.simNo.getString(context),
                          inputKeyBoard: .phone,
                          validatorFunction: (value) => Validator.phone(value),
                        ),

                        SizedBox(height: AppSizes.height(1)),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.height(2)),
                  CustomExpansionCard(
                    title: AppLocale.location.getString(context),
                    iconData: Icons.location_on,
                    child: Column(
                      children: [
                        CustomTextfieldWidget(
                          controller: locationController,
                          title: AppLocale.location.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),

                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: areaNameController,
                          title: AppLocale.area.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),

                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: latitudeController,
                          title: AppLocale.latitude.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),
                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: longitudeController,
                          title: AppLocale.longitude.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),
                        SizedBox(height: AppSizes.height(1)),
                        CustomTextfieldWidget(
                          controller: radiusController,
                          title: AppLocale.radius.getString(context),
                          validatorFunction: (value) => Validator.text(value),
                        ),
                        SizedBox(height: AppSizes.height(1)),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.height(2)),
                  if (selectedType?.type == "MG" ||
                      selectedType?.type == "DG") ...[
                    GeneratorFromWidget(
                      generatorCompany: generatorCompany,
                      generatorFuelCapacity: generatorFuelCapacity,
                      generatorFuelType: generatorFuelType,
                      generatorInstallDate: generatorInstallDate,
                      generatorMode: generatorMode,
                      generatorName: generatorName,
                      generatorcapacity: generatorcapacity,
                      generatorwarrantyDate: generatorwarrantyDate,
                      typeList: generatorType,
                      selected: selectedGeneratorType,
                      onChangedGeneratorType: (type) {
                        setState(() {
                          selectedGeneratorType = type;
                        });
                      },
                    ),

                    SizedBox(height: AppSizes.height(2)),
                  ],

                  if (selectedType?.type == "MG" ||
                      selectedType?.type == "MSEB") ...[
                    MainFromWidget(
                      connectionName: connectionName,
                      meterNumber: meterNumber,
                    ),
                    SizedBox(height: AppSizes.height(2)),
                  ],

                  Consumer<DeviceProvider>(
                    builder: (context, deviceProvider, child) {
                      if (deviceProvider.addDeviceStatus == .success) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          clearAll();
                          AppSnackbar.success(context, 'Device Added');
                          context.pop();
                        });
                      }
                      return CustomButtonWidget(
                        isLoading: deviceProvider.addDeviceStatus == .loading,
                        title:
                            '${AppLocale.add.getString(context)} ${AppLocale.device.getString(context)}',
                        theme: theme,
                        onPressedFunction: () {
                          if (_globalKey.currentState!.validate()) {
                            context.read<DeviceProvider>().addDeviceMethod(
                              deviceparams: AddDeviceParams(
                                userID: deviceProvider.userData!.userId
                                    .toString(),
                                deviceCode: deviceCodeController.text
                                    .toString(),
                                deviceName: deviceNameController.text
                                    .toString(),
                                applicationType: selectedType!.type.toString(),
                                locationName: locationController.text
                                    .toString(),
                                areaName: areaNameController.text.toString(),
                                latitude: latitudeController.text.toString(),
                                longitude: longitudeController.text.toString(),
                                geofenceRadius: radiusController.text
                                    .toString(),
                                imeiNo: imeinoController.text.toString(),
                                simNo: simnnoController.text.toString(),
                                connectionName: connectionName.text.toString(),
                                generatorCapacityKW: generatorcapacity.text
                                    .toString(),
                                generatorFuelCapacity: generatorFuelCapacity
                                    .text
                                    .toString(),
                                generatorFuelType: selectedGeneratorType!.type
                                    .toString(),
                                generatorModel: generatorMode.text.toString(),
                                generatorName: generatorName.text.toString(),
                                installationDate: generatorInstallDate.text
                                    .toString(),
                                manufacturer: generatorCompany.text.toString(),
                                meterNumber: meterNumber.text.toString(),
                                warrantyExpiryDate: generatorwarrantyDate.text
                                    .toString(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
