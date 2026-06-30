import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/widgets/customer_header_widget.dart';
import 'package:poweriot/core/routes/app_route_name.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/core/utils/app_snackbar.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/settings/presentation/widgets/setting_item_card_widget.dart';
import 'package:poweriot/features/users/analytics/domain/usecase/fetch_analytics_usecase.dart';
import 'package:poweriot/features/users/analytics/presentation/provider/analytics_provider.dart';
import 'package:poweriot/features/users/analytics/presentation/widgets/from_date_to_to_date_widget.dart';
import 'package:poweriot/features/users/analytics/presentation/widgets/graph_2.dart';
import 'package:poweriot/features/users/analytics/presentation/widgets/graph_widget.dart';
import 'package:poweriot/features/users/analytics/presentation/widgets/usage_linear_indicator_widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// The Analytics screen presents efficiency metrics.
/// It displays interactive consumption analysis charts, total usage stats,
/// peak demand warnings, and actionable efficiency insights.
class AnalyticsScreen2 extends StatefulWidget {
  const AnalyticsScreen2({super.key});

  @override
  State<AnalyticsScreen2> createState() => _AnalyticsScreen2State();
}

class _AnalyticsScreen2State extends State<AnalyticsScreen2> {
  String _selectedTimeRange = 'Analytics';
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 5));
  DateTime toDate = DateTime.now();
  double minutesToHours(int minutes) => minutes / 60.0;

  @override
  void initState() {
    callFetchAnalyticsApi();
    super.initState();
  }

  void callFetchAnalyticsApi() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AnalyticsProvider>().fetchAnalyticsMethod(
        params: FetchAnalyticsParams(
          fromDate: dateToString(fromDate),
          toDate: dateToString(toDate),
        ),
      );
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
            CustomerHeaderWidget(
              title: AppLocale.analytics.getString(context),
              iconData: Icons.person,
              onTapFunction: () {
                context.goNamed(userSetting);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: .symmetric(horizontal: 15, vertical: 4),
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.height(1)),
                    _buildTimeRangeSelector(theme: theme),
                    SizedBox(height: AppSizes.height(2)),
                    DateRangeSelector(
                      fromDate: fromDate,
                      toDate: toDate,
                      onTapSelectFromDate: _selectFromDate,
                      onTapSelectToDate: _selectToDate,
                    ),
                    Consumer<AnalyticsProvider>(
                      builder: (context, analyticProvider, child) {
                        if (analyticProvider.analyticsStatus == .failed) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            AppSnackbar.error(
                              context,
                              analyticProvider.message,
                            );
                          });

                          return Column(
                            crossAxisAlignment: .center,
                            mainAxisAlignment: .center,
                            children: [Text("Unable to load data")],
                          );
                        }
                        if (analyticProvider.analyticsStatus == .loading) {
                          return Skeletonizer(
                            enabled:
                                analyticProvider.analyticsStatus == .loading,
                            child: Column(
                              children: [
                                SizedBox(height: AppSizes.height(1)),
                                SettingItemCardWidget(
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
                                        UsageLinearIndicatorWidget(
                                          colorData: Colors.lightBlue,
                                          indicatorValue: 0.8,
                                          percentage: "100%",
                                          title: AppLocale.mainPower.getString(
                                            context,
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.height(2)),
                                        UsageLinearIndicatorWidget(
                                          colorData: Colors.deepOrange,
                                          indicatorValue: 0.2,
                                          percentage: "0%",
                                          title: AppLocale.generator.getString(
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SettingItemCardWidget(
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
                                          title: 'Total Outage',
                                          value: '2 Times',
                                        ),
                                        _divider(),
                                        _buildRowInfoWidget(
                                          theme: theme,
                                          title: 'Total Duration',
                                          value: '22',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.height(2)),
                              ],
                            ),
                          );
                        }
                        if (analyticProvider.analyticsStatus == .success) {
                          return Column(
                            children: [
                              if (_selectedTimeRange == 'Analytics') ...[
                                SizedBox(height: AppSizes.height(2)),
                                SettingItemCardWidget(
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
                                        UsageLinearIndicatorWidget(
                                          colorData: Colors.lightBlue,
                                          indicatorValue:
                                              analyticProvider.mainsPowerUsage,
                                          percentage:
                                              "${(analyticProvider.mainsPowerUsage * 100).toStringAsFixed(1)}%",
                                          title: AppLocale.mainPower.getString(
                                            context,
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.height(2)),
                                        UsageLinearIndicatorWidget(
                                          colorData: Colors.deepOrange,
                                          indicatorValue:
                                              analyticProvider.generatorUsage,
                                          percentage:
                                              "${(analyticProvider.generatorUsage * 100).toStringAsFixed(1)}%",
                                          title: AppLocale.generator.getString(
                                            context,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.height(2)),
                                SettingItemCardWidget(
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
                                              '${analyticProvider.analyticsModel.msebAnalytics!.outageCountPerDay.toString()} Times',
                                        ),
                                        _divider(),
                                        _buildRowInfoWidget(
                                          theme: theme,
                                          title:
                                              '${AppLocale.total.getString(context)} ${AppLocale.duration.getString(context)}',
                                          value:
                                              analyticProvider
                                                      .analyticsModel
                                                      .msebAnalytics!
                                                      .downtimeDurationMinutes !=
                                                  null
                                              ? analyticProvider
                                                    .analyticsModel
                                                    .msebAnalytics!
                                                    .downtimeDurationMinutes
                                                    .toString()
                                              : '-',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.height(2)),
                                SettingItemCardWidget(
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
                                              '${analyticProvider.analyticsModel.generatorAnalytics!.generatorStartCount.toString()} Times',
                                        ),
                                        _divider(),
                                        _buildRowInfoWidget(
                                          theme: theme,
                                          title: AppLocale.duration.getString(
                                            context,
                                          ),
                                          value:
                                              '${analyticProvider.analyticsModel.generatorAnalytics!.generatorOnDuration ?? '-'} ',
                                        ),

                                        _divider(),
                                        _buildRowInfoWidget(
                                          theme: theme,
                                          title:
                                              '${AppLocale.fuel.getString(context)} ${AppLocale.useage.getString(context).toLowerCase()}',
                                          value:
                                              '${analyticProvider.analyticsModel.generatorAnalytics!.dailyFuelConsumption ?? '-'} L',
                                        ),
                                        _divider(),
                                        _buildRowInfoWidget(
                                          theme: theme,
                                          title:
                                              '${AppLocale.fuel.getString(context)} ${AppLocale.cost.getString(context)}',
                                          value: "\u20B9 250",
                                        ),

                                        _divider(),
                                        _buildRowInfoWidget(
                                          theme: theme,
                                          title:
                                              '${AppLocale.power.getString(context)} ${AppLocale.generated.getString(context)}',
                                          value: "220Kw",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSizes.height(2)),
                                SettingItemCardWidget(
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

                                SizedBox(height: AppSizes.height(2)),
                                SettingItemCardWidget(
                                  iconData: Icons.bar_chart_outlined,
                                  title:
                                      '${AppLocale.generator.getString(context)} ${AppLocale.useage.getString(context)}',
                                  child: OutageGraphWidget(
                                    segments: analyticProvider.generatorTimge,
                                    fromDate: fromDate,
                                    toDate: toDate,
                                    title:
                                        '${AppLocale.generator.getString(context)} ${AppLocale.useage.getString(context)}',
                                  ),
                                ),

                                SizedBox(height: AppSizes.height(2)),
                                SettingItemCardWidget(
                                  iconData: Icons.bar_chart_outlined,
                                  title:
                                      '${AppLocale.fuel.getString(context)} ${AppLocale.comsumption.getString(context)}',
                                  child: GraphWidget(
                                    title:
                                        '${AppLocale.fuel.getString(context)} ${AppLocale.comsumption.getString(context).toLowerCase()}',
                                    leftAccesTile: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 6,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${value.toInt()} Ltr',
                                            style: theme.textTheme.bodySmall,
                                          );
                                        },
                                        reservedSize: 42,
                                      ),
                                    ),
                                    getTitlesBottomWidget: (value, meta) {
                                      final style = theme.textTheme.bodySmall!
                                          .copyWith(fontWeight: .bold);
                                      String text = '';
                                      switch (value.toInt()) {
                                        case 0:
                                          text = '00:00';
                                          break;
                                        case 2:
                                          text = '06:00';
                                          break;
                                        case 4:
                                          text = '12:00';
                                          break;
                                        case 6:
                                          text = '18:00';
                                          break;
                                        case 8:
                                          text = '23:59';
                                          break;
                                        default:
                                          return Container();
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        child: Text(text, style: style),
                                      );
                                    },
                                    maxX: 8,
                                    maxY: 24,
                                    spots: [
                                      FlSpot(0, 3.5),
                                      FlSpot(1, 0),
                                      FlSpot(2, 0),
                                      FlSpot(3, 0),
                                      FlSpot(4, 0.7),
                                      FlSpot(5, 0.1),
                                      FlSpot(6, 0.3),
                                      FlSpot(7, 0),
                                      FlSpot(8, 0),
                                    ],
                                  ),
                                ),
                              ],
                              if (_selectedTimeRange == 'AI Analytics') ...[
                                Column(
                                  crossAxisAlignment: .center,
                                  mainAxisAlignment: .center,
                                  children: [
                                    SizedBox(height: AppSizes.height(2)),
                                    Text("Comming soon.."),
                                  ],
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
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
