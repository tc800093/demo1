import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:poweriot/core/utils/app_locale.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/users/analytics/presentation/widgets/graph_widget.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/generator_guage_widget.dart';

class AnalyticsDailyWidget extends StatefulWidget {
  final String accoundType;
  const AnalyticsDailyWidget({super.key, required this.accoundType});

  @override
  State<AnalyticsDailyWidget> createState() =>
      _AnalyticsDailyWidgetWidgetState();
}

class _AnalyticsDailyWidgetWidgetState extends State<AnalyticsDailyWidget> {
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
              border: .all(color: Colors.blueGrey.withValues(alpha: 0.3)),
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
                          value: '60%',
                          percentValue: 0.6,
                        ),
                        GeneratorGuageWidget(
                          color: Colors.deepOrange,
                          icon: Icons.memory,
                          label: 'Generator',
                          value: '40%',
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
              border: .all(color: Colors.blueGrey.withValues(alpha: 0.3)),
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
                                "3 times",
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
                                "30min",
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
              border: .all(color: Colors.blueGrey.withValues(alpha: 0.3)),
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
                                "3 times",
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
                                "30min",
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
                                "3.4 L",
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
                                "\u20B9 500",
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
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(text, style: style),
              );
            },
            spots: [
              FlSpot(0, minutesToHours(120)),
              FlSpot(1, minutesToHours(0)),
              FlSpot(2, minutesToHours(0)),
              FlSpot(3, minutesToHours(0)),
              FlSpot(4, minutesToHours(30)),
              FlSpot(5, minutesToHours(2)),
              FlSpot(6, minutesToHours(30)),
              FlSpot(7, minutesToHours(0)),
              FlSpot(8, minutesToHours(0)),
            ],
          ),

          SizedBox(height: AppSizes.height(2)),
        ],
        if (widget.accoundType == "2" || widget.accoundType == "1") ...[
          GraphWidget(
            title: 'Generator Usage',
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
            maxX: 8,
            maxY: 24,
            getTitlesBottomWidget: (value, meta) {
              final style = theme.textTheme.bodySmall!.copyWith(
                fontWeight: .bold,
              );
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
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(text, style: style),
              );
            },
            spots: [
              FlSpot(0, minutesToHours(120)),
              FlSpot(1, minutesToHours(0)),
              FlSpot(2, minutesToHours(0)),
              FlSpot(3, minutesToHours(0)),
              FlSpot(4, minutesToHours(30)),
              FlSpot(5, minutesToHours(2)),
              FlSpot(6, minutesToHours(30)),
              FlSpot(7, minutesToHours(0)),
              FlSpot(8, minutesToHours(0)),
            ],
          ),

          SizedBox(height: AppSizes.height(2)),
          GraphWidget(
            title: 'Fuel ${AppLocale.comsumption.getString(context)}',
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
                padding: const EdgeInsets.only(top: 10.0),
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
        border: .all(color: Colors.blueGrey.withValues(alpha: 0.3)),
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
