import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/graph_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/generator_guage_widget.dart';

class AnalyticsWeeklyWidget extends StatefulWidget {
  final String accoundType;
  const AnalyticsWeeklyWidget({super.key, required this.accoundType});

  @override
  State<AnalyticsWeeklyWidget> createState() =>
      _AnalyticsWeeklyWidgetWidgetState();
}

class _AnalyticsWeeklyWidgetWidgetState extends State<AnalyticsWeeklyWidget> {
  double minutesToHours(int minutes) => minutes / 60.0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(height: AppSizes.height(2)),
        if (widget.accoundType == '1') ...[
          Container(
            padding: .all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: .circular(20),
              border: .all(color: blueGrey.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: .all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: .circular(12),
                      ),
                      child: Icon(
                        Icons.data_usage_outlined,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(width: AppSizes.width(2)),
                    Text(
                      'Power Comsumption',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height(2)),
                Padding(
                  padding: .all(10),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        GeneratorGuageWidget(
                          color: Colors.lightBlue,
                          icon: Icons.power,
                          label: 'Main Power',
                          value: '86%',
                          percentValue: 0.6,
                        ),
                        GeneratorGuageWidget(
                          color: Colors.deepOrange,
                          icon: Icons.memory,
                          label: 'Generator',
                          value: '14%',
                          percentValue: 0.4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(2)),
        ],
        if (widget.accoundType == "1" || widget.accoundType == "3") ...[
          Container(
            padding: .all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: .circular(20),
              border: .all(color: blueGrey.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: .all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: .circular(12),
                      ),
                      child: Icon(Icons.power, color: theme.primaryColor),
                    ),
                    SizedBox(width: AppSizes.width(2)),
                    Text(
                      'Main Power Outage',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height(2)),
                Padding(
                  padding: .all(10),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Container(
                          padding: .all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(25),
                            borderRadius: .circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: .center,
                            children: [
                              Text('Outage', style: theme.textTheme.bodyMedium),
                              SizedBox(height: AppSizes.height(1)),
                              SizedBox(width: AppSizes.width(1)),
                              Text(
                                "13 times",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: .all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(25),
                            borderRadius: .circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: .center,
                            children: [
                              Text(
                                'Duration',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: AppSizes.height(1)),
                              SizedBox(width: AppSizes.width(1)),
                              Text(
                                "4hr 10min",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(2)),
        ],
        if (widget.accoundType == "2" || widget.accoundType == "1") ...[
          Container(
            padding: .all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: .circular(20),
              border: .all(color: blueGrey.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: .all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: .circular(12),
                      ),
                      child: Icon(Icons.memory, color: theme.primaryColor),
                    ),
                    SizedBox(width: AppSizes.width(2)),
                    Text('Generator Usage', style: theme.textTheme.titleLarge),
                  ],
                ),
                SizedBox(height: AppSizes.height(2)),
                Padding(
                  padding: .all(10),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Container(
                          padding: .all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(25),
                            borderRadius: .circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: .center,
                            children: [
                              Text(
                                'Start Count',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: AppSizes.height(1)),
                              SizedBox(width: AppSizes.width(1)),
                              Text(
                                "13 times",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: .all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(25),
                            borderRadius: .circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: .center,
                            children: [
                              Text(
                                'Duration',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: AppSizes.height(1)),
                              SizedBox(width: AppSizes.width(1)),
                              Text(
                                "4hr 08min",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: .all(10),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: .spaceAround,
                      children: [
                        Container(
                          padding: .all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(25),
                            borderRadius: .circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: .center,
                            children: [
                              Text(
                                'Fuel Used',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: AppSizes.height(1)),
                              SizedBox(width: AppSizes.width(1)),
                              Text(
                                "25 L",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: .all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withAlpha(25),
                            borderRadius: .circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: .center,
                            children: [
                              Text(
                                'Fuel cost',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: AppSizes.height(1)),
                              SizedBox(width: AppSizes.width(1)),
                              Text(
                                "\u20B9 2500",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(2)),
        ],
        if (widget.accoundType == "3" || widget.accoundType == "1") ...[
          GraphWidget(
            title: 'Main Power Outgate',

            maxX: 8,
            maxY: 24,
            leftAccesTile: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 6,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()} Hr',
                    style: theme.textTheme.bodySmall,
                  );
                },
                reservedSize: 42,
              ),
            ),
            getTitlesBottomWidget: (value, meta) {
              final style = theme.textTheme.bodySmall!.copyWith(
                fontWeight: .bold,
              );
              String text = '';
              switch (value.toInt()) {
                case 0:
                  text = '04/06';
                  break;
                case 2:
                  text = '06/06';
                  break;
                case 4:
                  text = '08/06';
                  break;
                case 6:
                  text = '10/06';
                  break;
                case 8:
                  text = '12/06';
                  break;
                default:
                  return Container();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(text, style: style),
              );
            },
            spots: [
              FlSpot(0, minutesToHours(240)),
              FlSpot(1, minutesToHours(120)),
              FlSpot(2, minutesToHours(60)),
              FlSpot(3, minutesToHours(70)),
              FlSpot(4, minutesToHours(120)),
              FlSpot(5, minutesToHours(50)),
              FlSpot(6, minutesToHours(0)),
              FlSpot(7, minutesToHours(110)),
              FlSpot(8, minutesToHours(90)),
            ],
          ),

          SizedBox(height: AppSizes.height(2)),
        ],
        if (widget.accoundType == "2" || widget.accoundType == "1") ...[
          GraphWidget(
            title: 'Generator Usage',
            maxX: 8,
            maxY: 24,
            leftAccesTile: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 6,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()} Hr',
                    style: theme.textTheme.bodySmall,
                  );
                },
                reservedSize: 42,
              ),
            ),
            getTitlesBottomWidget: (value, meta) {
              final style = theme.textTheme.bodySmall!.copyWith(
                fontWeight: .bold,
              );
              String text = '';
              switch (value.toInt()) {
                case 0:
                  text = '04/06';
                  break;
                case 2:
                  text = '06/06';
                  break;
                case 4:
                  text = '08/06';
                  break;
                case 6:
                  text = '10/06';
                  break;
                case 8:
                  text = '12/06';
                  break;
                default:
                  return Container();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(text, style: style),
              );
            },
            spots: [
              FlSpot(0, minutesToHours(240)),
              FlSpot(1, minutesToHours(120)),
              FlSpot(2, minutesToHours(60)),
              FlSpot(3, minutesToHours(70)),
              FlSpot(4, minutesToHours(120)),
              FlSpot(5, minutesToHours(50)),
              FlSpot(6, minutesToHours(0)),
              FlSpot(7, minutesToHours(110)),
              FlSpot(8, minutesToHours(90)),
            ],
          ),

          SizedBox(height: AppSizes.height(2)),
          GraphWidget(
            title: 'Fuel ${AppLocale.comsumption.getString(context)}',
            maxX: 8,
            maxY: 24,
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
              final style = theme.textTheme.bodySmall!.copyWith(
                fontWeight: .bold,
              );
              String text = '';
              switch (value.toInt()) {
                case 0:
                  text = '04/06';
                  break;
                case 2:
                  text = '06/06';
                  break;
                case 4:
                  text = '08/06';
                  break;
                case 6:
                  text = '10/06';
                  break;
                case 8:
                  text = '12/06';
                  break;
                default:
                  return Container();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(text, style: style),
              );
            },
            spots: [
              FlSpot(0, 13),
              FlSpot(1, 24),
              FlSpot(2, 5),
              FlSpot(3, 3),
              FlSpot(4, 8.9),
              FlSpot(5, 2.4),
              FlSpot(6, 0),
              FlSpot(7, 10),
              FlSpot(8, 3),
            ],
          ),
        ],
      ],
    );
  }
}

class SectionWidget extends StatelessWidget {
  const SectionWidget({
    super.key,
    required this.sectionName,
    required this.iconData,
    required this.sections,
  });

  final List<Widget> sections;
  final String sectionName;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: .all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: .circular(20),
        border: .all(color: blueGrey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: .all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: .circular(12),
                ),
                child: Icon(iconData, color: theme.primaryColor),
              ),
              SizedBox(width: AppSizes.width(2)),
              Text(sectionName, style: theme.textTheme.titleLarge),
            ],
          ),
          SizedBox(height: AppSizes.height(2)),
        ],
      ),
    );
  }
}
