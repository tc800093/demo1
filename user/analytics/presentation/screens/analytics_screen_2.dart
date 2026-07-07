import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/widgets/customer_header_widget.dart';
import 'package:poweriot/core/common/widgets/no_data_widget.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/click_event.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/settings/presentation/widgets/setting_item_card_widget.dart';
import 'package:poweriot/features/user/analytics/domain/usecase/fetch_analytics_usecase.dart';
import 'package:poweriot/features/user/analytics/presentation/provider/analytics_provider.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/analytics_loading_widget.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/from_date_to_to_date_widget.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/graph_2.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/usage_linear_indicator_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:poweriot/features/user/dashboard/presentation/provider/tutorial_provider.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

/// The Analytics screen presents efficiency metrics.
/// It displays interactive consumption analysis charts, total usage stats,
class AnalyticsScreen2 extends StatefulWidget {
  const AnalyticsScreen2({super.key});

  @override
  State<AnalyticsScreen2> createState() => _AnalyticsScreen2State();
}

class _AnalyticsScreen2State extends State<AnalyticsScreen2> {
  String _selectedTimeRange = 'Analytics';
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  double minutesToHours(int minutes) => minutes / 60.0;
  final DashboardProvider dashboardProvider = service<DashboardProvider>();
  final AnalyticsProvider analyticsProvider = service<AnalyticsProvider>();
  GlobalKey _firstShowcaseWidget = GlobalKey();
  GlobalKey _timeSelection = GlobalKey();
  GlobalKey _deviceSelection = GlobalKey();
  GlobalKey _powerConsumption = GlobalKey();
  GlobalKey _mainPower = GlobalKey();
  GlobalKey _generator = GlobalKey();
  GlobalKey _mainGraph = GlobalKey();
  GlobalKey _generatorGraph = GlobalKey();
  Status? _previousAnalyticsStatus;
  final TutorialProvider _tutorialProvider = service<TutorialProvider>();

  @override
  void initState() {
    callFetchAnalyticsApi();
    ShowcaseView.register(
      hideFloatingActionWidgetForShowcase: [_generatorGraph],
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
                await _tutorialProvider.markAnalyticsTutorialAsShown();
                ();
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
        if (index == 7) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white,
            ),
          );
          ShowcaseView.get().dismiss();
          _tutorialProvider.markAnalyticsTutorialAsShown();
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
          hideActionWidgetForShowcase: [_generatorGraph],
        ),
      ],
      onDismiss: (key) {},
    );
    super.initState();
  }

  void callFetchAnalyticsApi() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await dashboardProvider.fetchDashboardMethod();
      String deviceId = '';

      if (dashboardProvider.dashboardModel.isNotEmpty) {
        deviceId = dashboardProvider.dashboardModel.first.deviceId ?? '';
      }
      analyticsProvider.fetchAnalyticsMethod(
        params: FetchAnalyticsParams(
          userDevice: deviceId,
          fromDate: dateToString(fromDate),
          toDate: dateToString(toDate),
        ),
      );

      bool _isShow = await _tutorialProvider.shouldShowAnalyticsTutorial();
      if (_isShow == true) {
        await Future.delayed(const Duration(milliseconds: 500));

        if (!mounted) return;

        ShowcaseView.get().startShowCase([
          _firstShowcaseWidget,
          _deviceSelection,
          _timeSelection,
          _powerConsumption,
          _mainPower,
          _generator,
          _mainGraph,
          _generatorGraph,
        ]);
      }
    });
  }

  Future<void> _selectFromDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        fromDate = pickedDate;

        if (fromDate.isAfter(toDate)) {
          toDate = fromDate;
        }
      });
    }
  }

  Future<void> _selectToDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: fromDate,
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        toDate = pickedDate;
      });
    }
  }

  List<String> getBottomLabels(DateTime fromDate, DateTime toDate) {
    final isSameDay =
        fromDate.year == toDate.year &&
        fromDate.month == toDate.month &&
        fromDate.day == toDate.day;

    if (isSameDay) {
      final now = DateTime.now();

      return [
        '00:00',
        '${(now.hour * 0.25).round().toString().padLeft(2, '0')}:00',
        '${(now.hour * 0.50).round().toString().padLeft(2, '0')}:00',
        '${(now.hour * 0.75).round().toString().padLeft(2, '0')}:00',
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      ];
    }

    final days = toDate.difference(fromDate).inDays;

    return [
      DateFormat('dd/MM').format(fromDate),
      DateFormat(
        'dd/MM',
      ).format(fromDate.add(Duration(days: (days * 0.25).round()))),
      DateFormat(
        'dd/MM',
      ).format(fromDate.add(Duration(days: (days * 0.50).round()))),
      DateFormat(
        'dd/MM',
      ).format(fromDate.add(Duration(days: (days * 0.75).round()))),
      DateFormat('dd/MM').format(toDate),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Showcase(
              key: _firstShowcaseWidget,
              title: 'Analytics Screen',
              description:
                  'Here you can view power usage, generator runtime, and detailed reports of your system.',
              onBarrierClick: () {
                debugPrint('Barrier clicked');
                debugPrint(
                  'Floating Action widget for first '
                  'showcase is now hidden',
                );
                ShowcaseView.get().hideFloatingActionWidgetForKeys([
                  _firstShowcaseWidget,
                  _generatorGraph,
                ]);
              },
              enableAutoScroll: true,
              tooltipPadding: .all(8),
              tooltipActionConfig: const TooltipActionConfig(
                alignment: .end,
                position: .outside,
                gapBetweenContentAndAction: 10,
              ),

              child: CustomerHeaderWidget(
                title: AppLocale.analytics.getString(context),
                iconData: Icons.person,
                onTapFunction: () {
                  ClickLogger.logClick(
                    buttonName: "Profile Icon",
                    eventName: "Navigation to profile section",
                    screenName: "Analytics",
                    userId: '',
                  );
                  context.goNamed(userSetting);
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: .symmetric(horizontal: 15, vertical: 4),
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.height(1)),
                    _buildTimeRangeSelector(theme: theme),
                    SizedBox(height: AppSizes.height(2)),
                    Showcase(
                      key: _deviceSelection,
                      title: 'Select Device ',
                      description:
                          'Select a device to view its analytics and data.',
                      child: Consumer<DashboardProvider>(
                        builder: (context, dp, child) {
                          return Column(
                            children: [
                              dashboardProvider.dashboardModel.length > 1
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: AppSizes.height(6),
                                          child: ListView.separated(
                                            scrollDirection: .horizontal,
                                            itemCount: dashboardProvider
                                                .dashboardModel
                                                .length,
                                            itemBuilder: (context, index) {
                                              return ChoiceChip(
                                                selectedColor:
                                                    theme.primaryColor,
                                                showCheckmark: false,
                                                checkmarkColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: .circular(16),
                                                ),
                                                label: Text(
                                                  dashboardProvider
                                                      .dashboardModel[index]
                                                      .deviceName
                                                      .toString(),
                                                  style: theme
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        color:
                                                            dashboardProvider
                                                                    .selectedDevice!
                                                                    .deviceId ==
                                                                dashboardProvider
                                                                    .dashboardModel[index]
                                                                    .deviceId
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                ),
                                                selected:
                                                    dashboardProvider
                                                        .selectedDevice!
                                                        .deviceId ==
                                                    dashboardProvider
                                                        .dashboardModel[index]
                                                        .deviceId,
                                                onSelected: (_) {
                                                  ClickLogger.logClick(
                                                    buttonName:
                                                        "device list chip",
                                                    eventName:
                                                        "Select user device",
                                                    screenName: "Analytics",
                                                    userId: '',
                                                  );
                                                  dashboardProvider.selectDevice(
                                                    dashboardProvider
                                                        .dashboardModel[index],
                                                  );
                                                  analyticsProvider
                                                      .fetchAnalyticsMethod(
                                                        params: FetchAnalyticsParams(
                                                          userDevice:
                                                              dashboardProvider
                                                                  .selectedDevice!
                                                                  .deviceId
                                                                  .toString(),
                                                          fromDate:
                                                              dateToString(
                                                                fromDate,
                                                              ),
                                                          toDate: dateToString(
                                                            toDate,
                                                          ),
                                                        ),
                                                      );
                                                },
                                              );
                                            },
                                            separatorBuilder: (_, sperator) =>
                                                const SizedBox(width: 8),
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.height(2)),
                                      ],
                                    )
                                  : SizedBox.shrink(),

                              // SizedBox(height: AppSizes.height(2)),
                              dashboardProvider.dashboardStatus == .success
                                  ? dashboardProvider.dashboardModel.isNotEmpty
                                        ? Showcase(
                                            key: _timeSelection,
                                            title: 'Select Date Range',
                                            description:
                                                'Select a From Date and To Date to view analytics for the chosen period.',
                                            child: DateRangeSelector(
                                              userDeviceID: dashboardProvider
                                                  .selectedDevice!
                                                  .deviceId
                                                  .toString(),
                                              fromDate: fromDate,
                                              toDate: toDate,
                                              onTapSelectFromDate:
                                                  _selectFromDate,
                                              onTapSelectToDate: _selectToDate,
                                            ),
                                          )
                                        : SizedBox.shrink()
                                  : SizedBox.shrink(),
                            ],
                          );
                        },
                      ),
                    ),
                    Consumer2<AnalyticsProvider, DashboardProvider>(
                      builder: (context, analyticProvider, dp, child) {
                        if (analyticProvider.analyticsStatus == .failed) {
                          if (_previousAnalyticsStatus !=
                              analyticProvider.analyticsStatus) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              AppSnackbar.error(
                                context,
                                analyticProvider.message,
                              );
                            });
                            _previousAnalyticsStatus =
                                analyticProvider.analyticsStatus;
                          }
                          return Column(
                            crossAxisAlignment: .center,
                            mainAxisAlignment: .center,
                            children: [
                              SizedBox(height: AppSizes.height(12)),
                              if (_selectedTimeRange == 'Analytics') ...[
                                NoDataWidget(
                                  title: dp.dashboardModel.isNotEmpty
                                      ? analyticProvider.message.toString()
                                      : dp.message.toString(),
                                  message: dp.dashboardModel.isEmpty
                                      ? "No device has been assigned to your account yet. Please contact your administrator to add a device."
                                      : null,
                                ),
                              ],
                              if (_selectedTimeRange == 'AI Analytics') ...[
                                NoDataWidget(
                                  title: 'Comming Soon....',
                                  titleColor: Colors.black,
                                  messageColor: Colors.black,
                                  message: "AI Analytics",
                                ),
                              ],
                            ],
                          );
                        }

                        if (analyticProvider.analyticsStatus == .loading ||
                            analyticProvider.analyticsStatus == .init) {
                          return AnalyticsLoadingWidget();
                        }
                        if (analyticProvider.analyticsStatus == .success) {
                          return Column(
                            children: [
                              if (_selectedTimeRange == 'Analytics') ...[
                                SizedBox(height: AppSizes.height(2)),
                                Showcase(
                                  key: _powerConsumption,
                                  title: 'Power Consumption',
                                  description:
                                      'View the power consumed from the mains supply and generator during the selected period.',
                                  child: SettingItemCardWidget(
                                    iconData: Icons.data_usage_outlined,
                                    title:
                                        '${AppLocale.power.getString(context)} ${AppLocale.comsumption.getString(context)}',
                                    child: Padding(
                                      padding: .symmetric(
                                        horizontal: 15,
                                        vertical: 15,
                                      ),
                                      child: Column(
                                        children: [
                                          if (analyticProvider
                                                      .analyticsModel
                                                      .applicationType ==
                                                  "MG" ||
                                              analyticProvider
                                                      .analyticsModel
                                                      .applicationType ==
                                                  "MAINS") ...[
                                            UsageLinearIndicatorWidget(
                                              colorData: Colors.lightBlue,
                                              indicatorValue: analyticProvider
                                                  .mainsPowerUsage,
                                              percentage:
                                                  "${(analyticProvider.mainsPowerUsage * 100).toStringAsFixed(1)}%",
                                              title: AppLocale.mainPower
                                                  .getString(context),
                                            ),
                                          ],
                                          if (analyticProvider
                                                      .analyticsModel
                                                      .applicationType ==
                                                  "MG" ||
                                              analyticProvider
                                                      .analyticsModel
                                                      .applicationType ==
                                                  "DG") ...[
                                            SizedBox(
                                              height: AppSizes.height(2),
                                            ),
                                            UsageLinearIndicatorWidget(
                                              colorData: Colors.deepOrange,
                                              indicatorValue: analyticProvider
                                                  .generatorUsage,
                                              percentage:
                                                  "${(analyticProvider.generatorUsage * 100).toStringAsFixed(1)}%",
                                              title: AppLocale.generator
                                                  .getString(context),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "MG" ||
                                    analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "MAINS") ...[
                                  SizedBox(height: AppSizes.height(2)),
                                  Showcase(
                                    key: _mainPower,
                                    title: 'Show Mains Summary',
                                    description:
                                        'View the total outage count, average frequency, average voltage, and total outage duration for the selected period.',
                                    child: SettingItemCardWidget(
                                      iconData: Icons.power,
                                      title:
                                          "${AppLocale.mainPower.getString(context)} ${AppLocale.outage.getString(context)}",
                                      child: Padding(
                                        padding: .symmetric(
                                          horizontal: 15,
                                          vertical: 15,
                                        ),
                                        child: Column(
                                          children: [
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title:
                                                  '${AppLocale.total.getString(context)} ${AppLocale.outage.getString(context)}',
                                              value:
                                                  '${analyticProvider.analyticsModel.mainsAnalytics?.outageCountPerDay != null ? analyticProvider.analyticsModel.mainsAnalytics?.outageCountPerDay.toString() : '-'} Times',
                                            ),
                                            _divider(),
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title:
                                                  '${AppLocale.total.getString(context)} ${AppLocale.duration.getString(context)}',
                                              value:
                                                  analyticProvider
                                                          .analyticsModel
                                                          .mainsAnalytics !=
                                                      null
                                                  ? analyticProvider
                                                                .analyticsModel
                                                                .mainsAnalytics!
                                                                .downtimeDurationMinutes !=
                                                            null
                                                        ? analyticProvider
                                                              .analyticsModel
                                                              .mainsAnalytics!
                                                              .downtimeDurationMinutes
                                                              .toString()
                                                        : '-'
                                                  : '-',
                                            ),

                                            _divider(),
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title: 'Average Voltage',
                                              value:
                                                  analyticProvider
                                                          .analyticsModel
                                                          .mainsAnalytics !=
                                                      null
                                                  ? analyticProvider
                                                                .analyticsModel
                                                                .mainsAnalytics!
                                                                .averageVoltage !=
                                                            null
                                                        ? analyticProvider
                                                              .analyticsModel
                                                              .mainsAnalytics!
                                                              .averageVoltage!
                                                              .toStringAsFixed(
                                                                2,
                                                              )
                                                              .toString()
                                                        : '-'
                                                  : '-',
                                            ),
                                            _divider(),
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title: 'Average Frequency',
                                              value:
                                                  analyticProvider
                                                          .analyticsModel
                                                          .mainsAnalytics !=
                                                      null
                                                  ? analyticProvider
                                                                .analyticsModel
                                                                .mainsAnalytics!
                                                                .averageFrequency !=
                                                            null
                                                        ? analyticProvider
                                                              .analyticsModel
                                                              .mainsAnalytics!
                                                              .averageFrequency!
                                                              .toStringAsFixed(
                                                                2,
                                                              )
                                                              .toString()
                                                        : '-'
                                                  : '-',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                if (analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "MG" ||
                                    analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "DG") ...[
                                  SizedBox(height: AppSizes.height(2)),
                                  Showcase(
                                    key: _generator,
                                    title: 'Genertor Summary',
                                    description:
                                        "View the total generator starts, fuel useage,battery, and total runtime for the selected period.",
                                    child: SettingItemCardWidget(
                                      iconData: Icons.power,
                                      title:
                                          "${AppLocale.generator.getString(context)}  ${AppLocale.useage.getString(context)}",
                                      child: Padding(
                                        padding: .symmetric(
                                          horizontal: 15,
                                          vertical: 15,
                                        ),
                                        child: Column(
                                          children: [
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title:
                                                  '${AppLocale.start.getString(context)} ${AppLocale.count.getString(context).toLowerCase()}',
                                              value:
                                                  '${analyticProvider.analyticsModel.generatorAnalytics != null ? analyticProvider.analyticsModel.generatorAnalytics!.generatorStartCount.toString() : "-"} Times',
                                            ),
                                            _divider(),
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title: AppLocale.duration
                                                  .getString(context),
                                              value:
                                                  '${analyticProvider.analyticsModel.generatorAnalytics != null ? analyticProvider.analyticsModel.generatorAnalytics!.generatorOnDuration ?? '-' : '-'} ',
                                            ),
                                            _divider(),
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title:
                                                  '${AppLocale.fuel.getString(context)} ${AppLocale.useage.getString(context).toLowerCase()}',
                                              value:
                                                  '${analyticProvider.analyticsModel.generatorAnalytics != null ? analyticProvider.analyticsModel.generatorAnalytics!.dailyFuelConsumption ?? '-' : '-'} L',
                                            ),

                                            _divider(),
                                            _buildRowInfoWidget(
                                              theme: theme,
                                              title: 'Battery',
                                              value:
                                                  '${analyticProvider.analyticsModel.generatorAnalytics != null ? analyticProvider.analyticsModel.generatorAnalytics!.batteryVoltage ?? '-' : '-'} V',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                if (analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "MG" ||
                                    analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "MAINS") ...[
                                  SizedBox(height: AppSizes.height(2)),
                                  Showcase(
                                    key: _mainGraph,
                                    title: 'Power Trends',
                                    description:
                                        'View graphical trends of Mains outage duration for the selected period',

                                    enableAutoScroll: true,
                                    child: SettingItemCardWidget(
                                      iconData: Icons.bar_chart_outlined,
                                      title:
                                          '${AppLocale.mainPower.getString(context)} ${AppLocale.outage.getString(context)}',
                                      child: OutageGraphWidget(
                                        segments: analyticProvider.outTimge,
                                        fromDate: fromDate,
                                        toDate: toDate,
                                        title:
                                            '${AppLocale.power.getString(context)} ${AppLocale.outage.getString(context)}',
                                      ),
                                    ),
                                  ),
                                ],
                                if (analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "MG" ||
                                    analyticProvider
                                            .analyticsModel
                                            .applicationType ==
                                        "DG") ...[
                                  SizedBox(height: AppSizes.height(2)),
                                  Showcase(
                                    key: _generatorGraph,
                                    title: 'Generator Graph',
                                    description:
                                        'View graphical trends of generator runtime for the selected period',
                                    enableAutoScroll: true,
                                    tooltipActions: [
                                      TooltipActionButton.custom(
                                        button: SizedBox(
                                          height: AppSizes.height(5),
                                          width: AppSizes.width(40),
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              ShowcaseView.get().dismiss();
                                              await _tutorialProvider
                                                  .markAnalyticsTutorialAsShown();
                                              ();
                                            },
                                            child: Text(
                                              "Get Started",
                                              style: theme.textTheme.titleSmall!
                                                  .copyWith(
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

                                    child: SettingItemCardWidget(
                                      iconData: Icons.bar_chart_outlined,
                                      title:
                                          '${AppLocale.generator.getString(context)} ${AppLocale.useage.getString(context)}',
                                      child: OutageGraphWidget(
                                        segments:
                                            analyticProvider.generatorTimge,
                                        fromDate: fromDate,
                                        toDate: toDate,
                                        title:
                                            '${AppLocale.generator.getString(context)} ${AppLocale.useage.getString(context)}',
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(height: AppSizes.height(2)),
                              ],
                              if (_selectedTimeRange == 'AI Analytics') ...[
                                NoDataWidget(
                                  title: 'Comming Soon....',
                                  titleColor: Colors.black,
                                  messageColor: Colors.black,
                                  message: "AI Analytics",
                                ),
                              ],
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> buildOutageSpots({
    required List<RuntimeSegment> segments,
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    final isSameDay =
        fromDate.year == toDate.year &&
        fromDate.month == toDate.month &&
        fromDate.day == toDate.day;

    if (isSameDay) {
      return segments.map((e) {
        final x = e.start.hour + (e.start.minute / 60);

        final y = e.duration.inMinutes / 60.0;
        return FlSpot(x, y);
      }).toList();
    }

    final totalDays = toDate.difference(fromDate).inDays;

    return segments.map((e) {
      final dayOffset = e.start.difference(fromDate).inDays;

      final x = (dayOffset / totalDays) * 8;

      final y = e.duration.inMinutes / 60.0;

      return FlSpot(y, x);
    }).toList();
  }

  Widget _buildRowInfoWidget({
    required ThemeData theme,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        Text(value, style: theme.textTheme.labelMedium),
      ],
    );
  }

  Widget _divider() => Padding(
    padding: .symmetric(vertical: 10),
    child: Divider(color: Colors.grey, height: 1),
  );

  Widget _buildTimeRangeSelector({required ThemeData theme}) {
    return Container(
      padding: .all(10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(12),
        border: .all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTimeToggle('Analytics', theme),
          // _buildTimeToggle('AI Insights', theme),
          _buildTimeToggle('AI Analytics', theme),
        ],
      ),
    );
  }

  Widget _buildTimeToggle(String label, ThemeData theme) {
    bool isSelected = _selectedTimeRange == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ClickLogger.logClick(
            buttonName: "Tab bar",
            eventName: "Select tab for ${label}",
            screenName: "Analytics",
            userId: '',
          );
          setState(() => _selectedTimeRange = label);
        },
        child: Container(
          padding: .symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label.contains('AI')
                ? AppLocale.aiAnalytics.getString(context)
                : AppLocale.analytics.getString(context),
            textAlign: .center,
            style: theme.textTheme.titleMedium!.copyWith(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
