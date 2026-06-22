import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/auth/presentation/provider/auth_provider.dart';
import 'package:poweriot/features/users/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/dashboard_header_widget.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/main_power_card.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/power_source.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/s3_emergency_stop.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/s3_generator_detail.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/user_home_loading_widget.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? type;
  String? fullName;
  Timer? _timer;
  DateTime? _dateTime;

  PageController? _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    getUserSourceType();
    planExpirationDate();

    _timer = Timer.periodic(Duration(minutes: 10), (_) {
      getUserSourceType();
    });
    super.initState();
  }

  void planExpirationDate() {
    DateTime currentDate = DateTime.now();
    _dateTime = DateTime(2026, 06, 12);
    DateTime warningDate = _dateTime!.subtract(Duration(days: 6));
    log(
      "this is the $currentDate is same as  $warningDate and before $currentDate",
    );
    if (currentDate.isAtSameMomentAs(warningDate) &&
        currentDate.isBefore(_dateTime!)) {
      log(
        "this is the $currentDate is same as  $warningDate and before $currentDate",
      );
    }
  }

  void getUserSourceType() async {
    final String? deviceID = await service<SecureStorageService>().read(
      userDeviceIDStored,
    );
    final String? uId = await service<SecureStorageService>().read(userID);
    final name = await service<SecureStorageService>().read(userName);

    fullName = name;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      // First fetch devices using uId
      await context.read<UserDeviceProvider>().fetchSourceInfo(
        deviceID: uId ?? "user-123",
      );
      
      if (!mounted) return;
      
      // Now find index of previously selected device ID
      final devices = context.read<UserDeviceProvider>().devices;
      int initialIndex = 0;
      if (deviceID != null && devices.isNotEmpty) {
        final idx = devices.indexWhere((d) => d.deviceId == deviceID);
        if (idx != -1) {
          initialIndex = idx;
        }
      }
      
      setState(() {
        _currentPageIndex = initialIndex;
        if (_pageController == null) {
          _pageController = PageController(initialPage: initialIndex);
        } else if (_pageController!.hasClients) {
          _pageController!.jumpToPage(initialIndex);
        }
      });
      
      // If the device list was not empty, make sure the active device's application type is correctly set
      if (devices.isNotEmpty) {
        final activeDevice = devices[initialIndex];
        await service<SecureStorageService>().write(
          key: userDeviceIDStored,
          value: activeDevice.deviceId.toString(),
        );
        await service<SecureStorageService>().write(
          key: userDeviceCodeStored,
          value: activeDevice.deviceCode.toString(),
        );
        await service<SecureStorageService>().write(
          key: sourceTypeStored,
          value: activeDevice.applicationType.toString(),
        );
      }
      
      if (!mounted) return;
      // Now fetch telemetry for the selected device
      context.read<DashboardProvider>().fetchDashboardMethod();
      context.read<AuthProvider>().resetState();
    });

    setState(() {});
  }

  void _onPageChanged(int index, List<DeviceModel> devices) async {
    setState(() {
      _currentPageIndex = index;
    });
    final selectedDevice = devices[index];
    
    // Save details to secure storage
    await service<SecureStorageService>().write(
      key: userDeviceIDStored,
      value: selectedDevice.deviceId.toString(),
    );
    await service<SecureStorageService>().write(
      key: userDeviceCodeStored,
      value: selectedDevice.deviceCode.toString(),
    );
    await service<SecureStorageService>().write(
      key: sourceTypeStored,
      value: selectedDevice.applicationType.toString(),
    );
    
    // Reload dashboard telemetry for the new device
    if (mounted) {
      context.read<DashboardProvider>().fetchDashboardMethod();
    }
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isCurrent = index == _currentPageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isCurrent ? 18 : 6,
          decoration: BoxDecoration(
            color: isCurrent ? Theme.of(context).primaryColor : const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer2<UserDeviceProvider, DashboardProvider>(
            builder: (context, userDeviceProvider, dashboardProvider, child) {
              final devices = userDeviceProvider.devices;

              return Column(
                children: [
                  DashboardHeaderWidget(
                    lastUpdate: dashboardProvider.dashboardStatus == Status.success
                        ? dashboardProvider.dashboardModel.lastUpdated!
                        : null,
                  ),
                  SizedBox(height: AppSizes.height(2)),

                  // Device Carousel
                  if (userDeviceProvider.fetchSourceStatus == Status.loading) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ] else if (devices.isNotEmpty) ...[
                    SizedBox(
                      height: 170,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) => _onPageChanged(index, devices),
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          final isActive = index == _currentPageIndex;
                          return DeviceCarouselCard(
                            device: device,
                            isActive: isActive,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildPageIndicator(devices.length),
                    SizedBox(height: AppSizes.height(2)),
                  ],

                  if (dashboardProvider.dashboardStatus == Status.success) ...[
                    if (dashboardProvider.showExpiryWarning) ...[
                      _warningCard(dashboardProvider.daysRemaining, theme),
                      SizedBox(height: AppSizes.height(2)),
                    ],
                    S3PowerSourcesRow(
                      currentPowerSource: dashboardProvider
                          .dashboardModel
                          .currentPowerSource
                          .toString(),
                      hasMseb: dashboardProvider.dashboardModel.mseb != null,
                      hasGenerator: dashboardProvider.dashboardModel.generator != null,
                    ),
                    SizedBox(height: AppSizes.height(2)),
                    if (dashboardProvider.dashboardModel.mseb != null) ...[
                      S3MainPowerCard(
                        mseb: dashboardProvider.dashboardModel.mseb!,
                        status:
                            dashboardProvider.dashboardModel.currentPowerSource
                                    .toString()
                                    .toLowerCase() ==
                                'mseb'
                            ? true
                            : false,
                      ),
                      SizedBox(height: AppSizes.height(2)),
                    ],
                    if (dashboardProvider.dashboardModel.generator != null) ...[
                      S3GeneratorDetailCard(
                        generator: dashboardProvider.dashboardModel.generator!,
                      ),
                      SizedBox(height: AppSizes.height(2)),
                    ],
                    S3EmergencyStopCard(),
                  ],
                  dashboardProvider.dashboardStatus == Status.loading
                      ? UserHomeLoadingWidget(
                          isEnable:
                              dashboardProvider.dashboardStatus == Status.loading,
                        )
                      : SizedBox.shrink(),

                  dashboardProvider.dashboardStatus == Status.failed
                      ? Center(
                          child: Column(
                            crossAxisAlignment: .center,
                            mainAxisAlignment: .center,
                            children: [
                              Text(dashboardProvider.message.toString()),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: AppSizes.height(2)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _warningCard(int daysLeft, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.blueGrey),
        ),
        child: ListTile(
          onTap: () {
            context.goNamed(userSetting);
          },
          leading: const Icon(Icons.warning_amber_rounded),
          title: Text(
            '${AppLocale.subscription.getString(context)} ${AppLocale.expires.getString(context)} in $daysLeft day${daysLeft > 1 ? 's' : ''}',
            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            AppLocale.subscriptionwarning.getString(context),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}

class DeviceCarouselCard extends StatelessWidget {
  final DeviceModel device;
  final bool isActive;

  const DeviceCarouselCard({
    super.key,
    required this.device,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMains = device.applicationType.toString().toLowerCase() == "mg" ||
        device.applicationType.toString().toLowerCase() == "mseb" ||
        device.applicationType.toString().toLowerCase() == "mains";
    final hasGen = device.applicationType.toString().toLowerCase() == "mg" ||
        device.applicationType.toString().toLowerCase() == "dg";

    String appTypeLabel = "Mains & Generator";
    if (!hasMains && hasGen) appTypeLabel = "Generator Only";
    if (hasMains && !hasGen) appTypeLabel = "Mains Only";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isActive
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFF475569), const Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isActive ? theme.primaryColor.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? theme.primaryColor.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.developer_board_rounded,
              size: 80,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      device.deviceCode.toString().toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: device.active == true ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        device.active == true ? "Online" : "Offline",
                        style: TextStyle(
                          color: device.active == true ? Colors.greenAccent : Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.deviceName.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.white60, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        "${device.areaName ?? ''}, ${device.locationName ?? ''}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  appTypeLabel,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
