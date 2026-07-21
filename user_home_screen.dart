import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poweriot/core/common/provider/local_notification_provider.dart';
import 'package:poweriot/core/common/widgets/custom_button_widget.dart';
import 'package:poweriot/core/common/widgets/no_data_widget.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/click_event.dart';
import 'package:poweriot/core/utils/service/local_notification_service.dart';
import 'package:poweriot/features/admin/users/presentation/provider/user_device_provider.dart';
import 'package:poweriot/features/auth/presentation/provider/auth_provider.dart';
import 'package:poweriot/features/settings/presentation/provider/settings_provider.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/tutorial_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/dashboard_header_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/device_carousel_card_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/main_power_card.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/plan_exipred_card_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/power_source.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/s3_emergency_stop.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/generator_detail.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/user_home_loading_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/waring_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

final GlobalKey _firstShowcaseWidget = GlobalKey();

/// Global key for the last showcase widget
final GlobalKey _lastShowcaseWidget = GlobalKey();

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});
  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? type;
  String? fullName;
  String? userID;
  Timer? _timer;
  final DashboardProvider _dashboardProvider = service<DashboardProvider>();
  final TutorialProvider _tutorialProvider = service<TutorialProvider>();
  PageController? _pageController;
  int _currentPageIndex = 0;
  DashboardModel? model;
  final GlobalKey _two = GlobalKey();
  final GlobalKey _powerSource = GlobalKey();
  final GlobalKey _mainSection = GlobalKey();
  final GlobalKey _generatorSection = GlobalKey();

  @override
  void initState() {
    ShowcaseView.register(
      hideFloatingActionWidgetForShowcase: [_lastShowcaseWidget],
      globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
        left: 16,
        bottom: AppSizes.height(14),
        child: Padding(
          padding: .symmetric(horizontal: 10),
          child: SizedBox(
            height: AppSizes.height(4),
            width: AppSizes.width(30),
            child: ElevatedButton(
              onPressed: () async {
                ShowcaseView.get().dismiss();
                await _tutorialProvider.markTutorialAsShown();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffEE5366),
              ),
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
      onStart: (index, key) {},
      onComplete: (index, key) {
        if (index == 5) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
            ),
          );
          ShowcaseView.get().dismiss();
        }
      },
      blurValue: 1,
      autoPlayDelay: Duration(seconds: 3),
      globalTooltipActionConfig: TooltipActionConfig(
        position: .inside,
        alignment: .spaceBetween,
        actionGap: 20,
      ),
      globalTooltipActions: [
        TooltipActionButton(
          type: .previous,
          textStyle: TextStyle(color: Colors.white),
          hideActionWidgetForShowcase: [_firstShowcaseWidget],
        ),
        TooltipActionButton(
          type: .next,
          textStyle: const TextStyle(color: Colors.white),
          hideActionWidgetForShowcase: [_lastShowcaseWidget],
        ),
      ],
      onDismiss: (key) {},
    );
    // });
    uploadUserLogs();
    getUserSourceType();
    _timer = Timer.periodic(Duration(minutes: 10), (_) {
      getUserSourceType();
    });
    super.initState();
  }

  void getUserSourceType() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final String? token = await service<LocalNotificationService>()
      //     .getToken();

      // log("fcm token $token");
      await service<SettingsProvider>().fetchUserDetail();
      final name = service<SettingsProvider>().userNameStored;
      setState(() {
        fullName = name;
      });
      if (!mounted) return;
      await _dashboardProvider.fetchDashboardMethod();
      await _dashboardProvider.fetchMySubscriptionMethod();
      if (!mounted) return;
      int initialIndex = 0;
      setState(() {
        _currentPageIndex = initialIndex;
        if (_pageController == null) {
          _pageController = PageController(initialPage: initialIndex);
        } else if (_pageController!.hasClients) {
          _pageController!.jumpToPage(initialIndex);
        }
      });

      if (!mounted) return;
      service<AuthProvider>().resetState();
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      service<LocalNotificationProvider>().requestPermission();
      bool _isShow = await _tutorialProvider.shouldShowTutorial();
      if (_isShow == true) {
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        ShowcaseView.get().startShowCase([
          _firstShowcaseWidget,
          _two,
          _powerSource,
          _mainSection,
          _generatorSection,
          _lastShowcaseWidget,
        ]);
      }
    });

    setState(() {});
  }

  void uploadUserLogs() {
    log("upload function called");
    ClickLogger.uploadIfNeeded();
  }

  void _onPageChanged(int index, List<DashboardModel> devices) async {
    setState(() {
      _currentPageIndex = index;
    });
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: .center,
      children: List.generate(count, (index) {
        final isCurrent = index == _currentPageIndex;
        return AnimatedContainer(
          duration: Duration(milliseconds: 250),
          margin: .symmetric(horizontal: 4),
          height: 6,
          width: isCurrent ? 18 : 6,
          decoration: BoxDecoration(
            color: isCurrent
                ? Theme.of(context).primaryColor
                : lightSlateGrayColor,
            borderRadius: .circular(3),
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
              return Column(
                children: [
                  Showcase(
                    key: _firstShowcaseWidget,
                    blurValue: 1,
                    title: "Welcome to PowerIoT",
                    description:
                        "Monitor your power system, generator, and important events from one place",
                    onBarrierClick: () {
                      debugPrint('Barrier clicked');
                      debugPrint(
                        'Floating Action widget for first '
                        'showcase is now hidden',
                      );
                      ShowcaseView.get().hideFloatingActionWidgetForKeys([
                        _firstShowcaseWidget,
                        _lastShowcaseWidget,
                      ]);
                    },
                    enableAutoScroll: true,
                    tooltipPadding: .all(8),
                    tooltipActionConfig: const TooltipActionConfig(
                      alignment: .end,
                      position: .outside,
                      gapBetweenContentAndAction: 10,
                    ),

                    child: DashboardHeaderWidget(
                      onTapFunction: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          ShowcaseView.get().startShowCase([
                            _firstShowcaseWidget,
                            _two,
                            _powerSource,
                            _mainSection,
                            _generatorSection,
                            _lastShowcaseWidget,
                          ]);
                        });
                      },
                    ),
                  ),
                  // Device Carousel
                  if (dashboardProvider.dashboardStatus == .loading) ...[
                    Padding(
                      padding: .symmetric(vertical: 0),
                      child: UserHomeLoadingWidget(
                        isEnable: dashboardProvider.dashboardStatus == .loading,
                      ),
                    ),
                  ],
                  if (dashboardProvider.dashboardStatus == .success) ...[
                    if (dashboardProvider.dashboardModel.isEmpty) ...[
                      SizedBox(height: AppSizes.height(20)),
                      Padding(
                        padding: .all(8.0),
                        child: SizedBox(
                          child: NoDataWidget(
                            title: dashboardProvider.message.toString(),
                            message:
                                "No device has been assigned to your account yet. Please contact your administrator to add a device.",
                          ),
                        ),
                      ),
                    ],
                    if (dashboardProvider.dashboardModel.isNotEmpty) ...[
                      Showcase(
                        key: _two,
                        blurValue: 1,
                        title: "Select Device",
                        description:
                            "Slide here to switch between your monitored devices.\n Additionally, you can tap on the location option to open the site directly in an external maps application for easy navigation.",
                        onBarrierClick: () {
                          debugPrint('Barrier clicked');
                          debugPrint(
                            'Floating Action widget for first '
                            'showcase is now hidden',
                          );
                          ShowcaseView.get().hideFloatingActionWidgetForKeys([
                            _firstShowcaseWidget,
                            _lastShowcaseWidget,
                          ]);
                        },
                        enableAutoScroll: true,
                        tooltipPadding: .all(8),
                        tooltipActionConfig: TooltipActionConfig(
                          alignment: .end,
                          position: .outside,
                          gapBetweenContentAndAction: 10,
                        ),
                        child: SizedBox(
                          height: 215,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) => _onPageChanged(
                              index,
                              dashboardProvider.dashboardModel,
                            ),
                            itemCount: dashboardProvider.dashboardModel.length,
                            itemBuilder: (context, index) {
                              final device =
                                  dashboardProvider.dashboardModel[index];
                              final isActive = index == _currentPageIndex;
                              return DeviceCarouselCard(
                                device: device,
                                isActive: isActive,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.height(1)),
                      _buildPageIndicator(
                        dashboardProvider.dashboardModel.length,
                      ),
                      SizedBox(height: AppSizes.height(2)),
                      if (dashboardProvider.showWarning) ...[
                        WaringCardWidget(
                          daysLeft: dashboardProvider.daysRemaining!,
                        ),
                        SizedBox(height: AppSizes.height(2)),
                      ],

                      if (dashboardProvider.planExpired!) ...[
                        PlanExipredCardWidget(),
                        SizedBox(height: AppSizes.height(2)),
                      ],
                      if (dashboardProvider
                                  .dashboardModel[_currentPageIndex]
                                  .mains ==
                              null &&
                          dashboardProvider
                                  .dashboardModel[_currentPageIndex]
                                  .generator ==
                              null) ...[
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: AppSizes.height(2)),
                              NoDataWidget(
                                iconData: Icons.device_unknown_outlined,
                                title: 'No Devices Connected',
                                message:
                                    'Connect a device to view analytics and live data.',
                              ),
                            ],
                          ),
                        ),
                      ],

                      if (dashboardProvider
                                  .dashboardModel[_currentPageIndex]
                                  .mains !=
                              null ||
                          dashboardProvider
                                  .dashboardModel[_currentPageIndex]
                                  .generator !=
                              null) ...[
                        Showcase(
                          key: _powerSource,
                          title: 'System Status',
                          description:
                              'View the current status of the mains supply and generator at a glance.',
                          enableAutoScroll: true,
                          tooltipPadding: .all(8),
                          tooltipActionConfig: const TooltipActionConfig(
                            alignment: .end,
                            position: .outside,
                            gapBetweenContentAndAction: 10,
                          ),
                          child: S3PowerSourcesRow(
                            mainsTodayHours: dashboardProvider
                                .dashboardModel[_currentPageIndex]
                                .mainsTodayRuntimeHours,
                            generatorTodayHours: dashboardProvider
                                .dashboardModel[_currentPageIndex]
                                .generatorTodayRuntimeHours,
                            onTapGenerator: () {
                              dashboardProvider.changePowerSource(
                                _currentPageIndex,
                              );
                              if (dashboardProvider
                                      .dashboardModel[_currentPageIndex]
                                      .currentPowerSource ==
                                  "MAINS") {
                                service<LocalNotificationProvider>()
                                    .showNotificaion(
                                      id: 8,
                                      title: "Power Restored",
                                      body:
                                          "Main power supply is available. The generator has stopped.",
                                    );
                              }
                              if (dashboardProvider
                                          .dashboardModel[_currentPageIndex]
                                          .currentPowerSource ==
                                      "GENERATOR" ||
                                  dashboardProvider
                                          .dashboardModel[_currentPageIndex]
                                          .currentPowerSource ==
                                      "DG") {
                                service<LocalNotificationProvider>()
                                    .showNotificaion(
                                      id: 1,
                                      title: "Power Outage Detected",
                                      body:
                                          "Main power supply is unavailable. The generator has started automatically and is supplying power.",
                                    );
                                service<LocalNotificationProvider>()
                                    .showNotificaion(
                                      id: 2,
                                      title: "Generator Running",
                                      body:
                                          "Main supply has failed. The generator is now running to maintain uninterrupted power.",
                                    );
                              }
                            },
                            onTapMains: () async {
                              uploadUserLogs();
                            },
                            currentPowerSource:
                                dashboardProvider.planExpired == false
                                ? dashboardProvider
                                      .dashboardModel[_currentPageIndex]
                                      .currentPowerSource
                                      .toString()
                                : "",
                            hasMseb: dashboardProvider.planExpired == false
                                ? dashboardProvider
                                          .dashboardModel[_currentPageIndex]
                                          .mains !=
                                      null
                                : false,
                            hasGenerator: dashboardProvider.planExpired == false
                                ? dashboardProvider
                                          .dashboardModel[_currentPageIndex]
                                          .generator !=
                                      null
                                : false,
                          ),
                        ),

                        SizedBox(height: AppSizes.height(2)),
                        Showcase(
                          key: _mainSection,
                          title: 'Main Supply',
                          description:
                              'Monitor voltage, frequency, outage count, outage duration, and phase status.',
                          tooltipActionConfig: TooltipActionConfig(
                            alignment: .end,
                            position: .outside,
                            gapBetweenContentAndAction: 10,
                          ),
                          blurValue: 1,
                          enableAutoScroll: true,
                          tooltipPadding: .all(8),
                          toolTipMargin: AppSizes.height(5),
                          child: S3MainPowerCard(
                            mseb: dashboardProvider.planExpired == false
                                ? dashboardProvider
                                      .dashboardModel[_currentPageIndex]
                                      .mains
                                : null,
                            phaseFailedFunction: () {
                              setState(() {
                                dashboardProvider
                                    .dashboardModel[_currentPageIndex]
                                    .mains = dashboardProvider
                                    .dashboardModel[_currentPageIndex]
                                    .mains!
                                    .copyWith(
                                      status:
                                          dashboardProvider
                                                  .dashboardModel[_currentPageIndex]
                                                  .mains!
                                                  .status ==
                                              true
                                          ? false
                                          : true,
                                      phaseFailure:
                                          dashboardProvider
                                                  .dashboardModel[_currentPageIndex]
                                                  .mains!
                                                  .phaseFailure ==
                                              true
                                          ? false
                                          : true,
                                      yPhaseStatus:
                                          dashboardProvider
                                                  .dashboardModel[_currentPageIndex]
                                                  .mains!
                                                  .yPhaseStatus ==
                                              true
                                          ? false
                                          : true,
                                    );
                              });
                            },
                            rPhaseFailedFunction: () {
                              setState(() {
                                dashboardProvider
                                    .dashboardModel[_currentPageIndex] = dashboardProvider
                                    .dashboardModel[_currentPageIndex]
                                    .copyWith(
                                      currentPowerSource: "GENERATOR",
                                      mains:
                                          dashboardProvider
                                              .dashboardModel[_currentPageIndex]
                                              .mains = dashboardProvider
                                              .dashboardModel[_currentPageIndex]
                                              .mains!
                                              .copyWith(
                                                phaseFailure:
                                                    dashboardProvider
                                                            .dashboardModel[_currentPageIndex]
                                                            .mains!
                                                            .phaseFailure ==
                                                        true
                                                    ? false
                                                    : true,
                                                rPhaseStatus:
                                                    dashboardProvider
                                                            .dashboardModel[_currentPageIndex]
                                                            .mains!
                                                            .rPhaseStatus ==
                                                        true
                                                    ? false
                                                    : true,
                                              ),
                                    );
                              });
                              if (dashboardProvider
                                      .dashboardModel[_currentPageIndex]
                                      .mains!
                                      .rPhaseStatus ==
                                  false) {
                                service<LocalNotificationProvider>()
                                    .showNotificaion(
                                      id: 3,
                                      title: "R Phase Down",
                                      body:
                                          "The R phase voltage has dropped below the acceptable limit. Please inspect the power supply.",
                                    );
                              }
                            },
                            status:
                                dashboardProvider
                                        .dashboardModel[_currentPageIndex]
                                        .currentPowerSource
                                        .toString()
                                        .toLowerCase() ==
                                    'mains'
                                ? true
                                : false,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(2)),
                        Showcase(
                          key: _generatorSection,
                          title: "Generator",
                          description:
                              'Track generator runtime, fuel level, battery voltage, engine temperature, and operational status.',
                          tooltipActions: [],
                          tooltipActionConfig: const TooltipActionConfig(
                            alignment: .end,
                            position: .outside,
                            gapBetweenContentAndAction: 10,
                          ),
                          enableAutoScroll: true,
                          tooltipPadding: .all(8),
                          child: GeneratorDetail(
                            deviceID: dashboardProvider
                                .dashboardModel[_currentPageIndex]
                                .deviceId
                                .toString(),
                            isOnStatus: dashboardProvider.planExpired == false
                                ? dashboardProvider
                                              .dashboardModel[_currentPageIndex]
                                              .generator !=
                                          null
                                      ? dashboardProvider
                                                    .dashboardModel[_currentPageIndex]
                                                    .generator!
                                                    .status ==
                                                true
                                            ? true
                                            : dashboardProvider
                                                          .dashboardModel[_currentPageIndex]
                                                          .currentPowerSource
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'dg' ||
                                                  dashboardProvider
                                                          .dashboardModel[_currentPageIndex]
                                                          .currentPowerSource
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'generator'
                                            ? true
                                            : false
                                      : false
                                : false,
                            isGeneratorAvailable:
                                dashboardProvider.planExpired == false
                                ? dashboardProvider
                                              .dashboardModel[_currentPageIndex]
                                              .applicationType
                                              .toString()
                                              .toLowerCase() ==
                                          'mg' ||
                                      dashboardProvider
                                              .dashboardModel[_currentPageIndex]
                                              .applicationType
                                              .toString()
                                              .toLowerCase() ==
                                          'dg'
                                : false,
                            generator: dashboardProvider.planExpired == false
                                ? dashboardProvider
                                      .dashboardModel[_currentPageIndex]
                                      .generator
                                : null,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(2)),
                        Showcase(
                          key: _lastShowcaseWidget,
                          title: "Emergancy Stop",
                          description:
                              'Instantly shuts down the generator to help prevent damage or ensure safety during critical situations.',
                          tooltipActions: [
                            TooltipActionButton.custom(
                              button: SizedBox(
                                height: AppSizes.height(5),
                                width: AppSizes.width(40),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    ShowcaseView.get().dismiss();
                                    await _tutorialProvider
                                        .markTutorialAsShown();
                                  },
                                  child: Text(
                                    "Get Started",
                                    style: theme.textTheme.titleSmall!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          tooltipActionConfig: TooltipActionConfig(
                            alignment: .end,
                            position: .outside,
                            gapBetweenContentAndAction: 10,
                          ),
                          enableAutoScroll: true,
                          tooltipPadding: .all(8),
                          child: S3EmergencyStopCard(
                            isGeneratorAvailable:
                                dashboardProvider
                                        .dashboardModel[_currentPageIndex]
                                        .applicationType
                                        .toString()
                                        .toLowerCase() ==
                                    'mg' ||
                                dashboardProvider
                                        .dashboardModel[_currentPageIndex]
                                        .applicationType
                                        .toString()
                                        .toLowerCase() ==
                                    'dg',
                          ),
                        ),
                      ],
                    ],
                    dashboardProvider.dashboardStatus == .loading
                        ? UserHomeLoadingWidget(
                            isEnable:
                                dashboardProvider.dashboardStatus == .loading,
                          )
                        : SizedBox.shrink(),
                  ],
                  dashboardProvider.dashboardStatus == .failed
                      ? Padding(
                          padding: .symmetric(horizontal: 16, vertical: 10),
                          child: Column(
                            crossAxisAlignment: .center,
                            mainAxisAlignment: .center,
                            children: [
                              SizedBox(height: AppSizes.height(16)),
                              NoDataWidget(
                                title: dashboardProvider.message.toString(),
                              ),
                              SizedBox(height: AppSizes.height(2)),
                              CustomButtonWidget(
                                isLoading: false,
                                title: 'Retry',
                                theme: theme,
                                onPressedFunction: () {
                                  getUserSourceType();
                                },
                              ),
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
}
