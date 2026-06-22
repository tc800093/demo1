import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/custom_dropdown_list_widget.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/validator.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/add_device_usecase.dart';
import 'package:poweriot/features/admin/devices/presentation/provider/device_provider.dart';
import 'package:poweriot/features/admin/devices/presentation/widgets/generator_from_widget.dart';
import 'package:poweriot/features/admin/devices/presentation/widgets/main_from_widget.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/settings/presentation/widgets/setting_item_card_widget.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';

class DeviceType {
  final String typeName;
  final String type;

  DeviceType({required this.typeName, required this.type});
}

class AddDeviceScreenV2 extends StatefulWidget {
  final bool isEdit;
  const AddDeviceScreenV2({super.key, this.isEdit = false});

  @override
  State<AddDeviceScreenV2> createState() => _AddDeviceScreenV2State();
}

class _AddDeviceScreenV2State extends State<AddDeviceScreenV2> {
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
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void fetchDeviceData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEdit == true) {
        context.read<DeviceProvider>().fetchAllUserMethod();
      }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: V3AppBarWidget(
        accountType: '2',
        userName: 'userName',
        title: 'Add Devices',
      ),
      body: SingleChildScrollView(
        padding: .symmetric(horizontal: 10, vertical: 10),
        child: Consumer<DeviceProvider>(
          builder: (context, deviceProvider, child) {
            return Form(
              key: _globalKey,
              child: Column(
                children: [
                  SizedBox(height: AppSizes.height(1)),

                  SizedBox(height: AppSizes.height(2)),
                  SettingItemCardWidget(
                    iconData: Icons.perm_device_information_outlined,
                    title: 'IoT Device Info',
                    child: Padding(
                      padding: .symmetric(horizontal: 8, vertical: 5),
                      child: Column(
                        children: [
                          CustomDropdownWidget<DeviceType>(
                            title: "Select Device Type",
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
                            title: "Select User",
                            items: deviceProvider.userList,
                            value: deviceProvider.userData,
                            itemLabelBuilder: (user) =>
                                user.fullName.toString(),
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
                            title: 'Device Code',
                            validatorFunction: (value) => Validator.text(value),
                          ),

                          SizedBox(height: AppSizes.height(1)),
                          CustomTextfieldWidget(
                            controller: deviceNameController,
                            title: 'Device Name',
                            validatorFunction: (value) => Validator.text(value),
                          ),

                          SizedBox(height: AppSizes.height(1)),
                          CustomTextfieldWidget(
                            controller: imeinoController,
                            title: 'IMEI no.',
                            validatorFunction: (value) => Validator.text(value),
                          ),
                          SizedBox(height: AppSizes.height(1)),
                          CustomTextfieldWidget(
                            controller: simnnoController,
                            title: 'SIM no.',
                            inputKeyBoard: .phone,
                            validatorFunction: (value) =>
                                Validator.phone(value),
                          ),

                          SizedBox(height: AppSizes.height(1)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(2)),

                  SettingItemCardWidget(
                    iconData: Icons.perm_device_information_outlined,
                    title: 'Location',
                    child: Padding(
                      padding: .symmetric(horizontal: 8, vertical: 5),
                      child: Column(
                        children: [
                          CustomTextfieldWidget(
                            controller: locationController,
                            title: 'Location',
                            validatorFunction: (value) => Validator.text(value),
                          ),

                          SizedBox(height: AppSizes.height(1)),
                          CustomTextfieldWidget(
                            controller: areaNameController,
                            title: 'Area',
                            validatorFunction: (value) => Validator.text(value),
                          ),

                          SizedBox(height: AppSizes.height(1)),
                          CustomTextfieldWidget(
                            controller: latitudeController,
                            title: 'Latitude',
                            validatorFunction: (value) => Validator.text(value),
                          ),
                          SizedBox(height: AppSizes.height(1)),
                          CustomTextfieldWidget(
                            controller: longitudeController,
                            title: 'Longitude',
                            validatorFunction: (value) => Validator.text(value),
                          ),
                          SizedBox(height: AppSizes.height(1)),
                          CustomTextfieldWidget(
                            controller: radiusController,
                            title: 'Radius',
                            validatorFunction: (value) => Validator.text(value),
                          ),
                          SizedBox(height: AppSizes.height(1)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppSizes.height(2)),
                  selectedType?.type == "MG"
                      ? SizedBox(
                          child: Column(
                            children: [
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
                              MainFromWidget(
                                connectionName: connectionName,
                                meterNumber: meterNumber,
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),

                  selectedType?.type == "MSEB"
                      ? MainFromWidget(
                          connectionName: connectionName,
                          meterNumber: meterNumber,
                        )
                      : SizedBox.shrink(),

                  selectedType?.type == "DG"
                      ? Column(
                          children: [
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
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: AppSizes.height(2)),
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
                        title: 'Add Device',
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
                  SizedBox(height: AppSizes.height(1)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
