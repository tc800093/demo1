import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/common/widgets/custom_textfield_widget.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/devices/presentation/provider/device_provider.dart';
import 'package:poweriot/features/admin/devices/presentation/widgets/device_card_widget.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/v3_app_bar_widget.dart';
import 'package:provider/provider.dart';

class DevicesListScreen extends StatefulWidget {
  const DevicesListScreen({super.key});

  @override
  State<DevicesListScreen> createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    fetchAllDevices();
    super.initState();
  }

  void fetchAllDevices() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeviceProvider>().fetchAllDevicesMethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: V3AppBarWidget(
        accountType: '2',
        userName: 'userName',
        title: AppLocale.devices.getString(context),
      ),
      floatingActionButton: Padding(
        padding: .symmetric(vertical: 5),
        child: FloatingActionButton(
          onPressed: () {
            context.read<DeviceProvider>().fetchAllUserMethod();
            context.pushNamed(adminAddDeviceScreen, extra: false);
          },
          child: Icon(Icons.add_outlined),
        ),
      ),
      body: Padding(
        padding: .symmetric(horizontal: 15, vertical: 10),
        child: Consumer<DeviceProvider>(
          builder: (context, deviceProvider, child) {
            return Column(
              children: [
                CustomTextfieldWidget(
                  title: AppLocale.search.getString(context),
                  controller: searchController,
                  inputKeyBoard: .text,
                  suffixIconData: Icons.search_rounded,
                  onChangedFunction: (v) {
                    context.read<DeviceProvider>().searchDevices(
                      searchController.text.toString(),
                    );
                  },
                ),

                deviceProvider.fetchDeviceStatus == .success
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: deviceProvider.deviceList.length,
                          itemBuilder: (context, index) {
                            DeviceModel model =
                                deviceProvider.deviceList[index];
                            return DeviceCard(deviceModel: model);
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                deviceProvider.fetchDeviceStatus == .failed
                    ? Expanded(
                        child: Center(
                          child: Text(deviceProvider.message.toString()),
                        ),
                      )
                    : SizedBox.shrink(),
                deviceProvider.fetchDeviceStatus == .loading
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
