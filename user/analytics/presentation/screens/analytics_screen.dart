import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/core/service_locator/service_path.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/analytics_daily_widget.dart';
import 'package:poweriot/features/user/analytics/presentation/widgets/analytics_weeky_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/v3_app_bar_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String? type;
  String? fullName = 'user';
  String _selectedTimeRange = 'Daily';
  DateTime? selectedDate = DateTime.now();
  @override
  void initState() {
    getUserSourceType();
    super.initState();
  }

  void getUserSourceType() async {
    final secure = await service<SecureStorageService>().read(sourceTypeStored);
    final name = await service<SecureStorageService>().read(userName);
    if (name!.isNotEmpty) {
      fullName = name;
    } else {
      fullName = "user";
    }

    if (secure!.isNotEmpty) {
      type = secure;
    } else {
      type = '1';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: V3AppBarWidget(
        accountType: '2',
        userName: 'userName',
        title: 'Analytics',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: .symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              SizedBox(height: AppSizes.height(2)),
              _buildTimeRangeSelector(),
              SizedBox(height: AppSizes.height(2)),
              Container(
                padding: .all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  borderRadius: .circular(12),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    DateIconButton(
                      theme: theme,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = selectedDate!.add(
                              Duration(days: -1),
                            );
                          });
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                    DateIconButton(
                      theme: theme,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          textAlign: .center,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ),
                    DateIconButton(
                      theme: theme,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            selectedDate = selectedDate!.add(Duration(days: 1));
                          });
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _selectedTimeRange.toLowerCase() == 'monthly'
                  ? AnalyticsWeeklyWidget(accoundType: type ?? "1")
                  : _selectedTimeRange.toLowerCase() == 'weekly'
                  ? AnalyticsWeeklyWidget(accoundType: type ?? '1')
                  : AnalyticsDailyWidget(accoundType: type ?? '1'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: .all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTimeToggle('Daily'),
          _buildTimeToggle('Weekly'),
          _buildTimeToggle('Monthly'),
        ],
      ),
    );
  }

  Widget _buildTimeToggle(String label) {
    bool isSelected = _selectedTimeRange == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTimeRange = label);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
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
            label,
            textAlign: .center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class DateIconButton extends StatelessWidget {
  const DateIconButton({super.key, required this.theme, required this.child});

  final ThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class MsebMetrix extends StatelessWidget {
  const MsebMetrix({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: .symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: .circular(16),
                border: .all(color: theme.primaryColor),
              ),
              child: Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Main Power (Today's)",
                    style: theme.textTheme.headlineMedium,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Status:", style: theme.textTheme.titleMedium),
                      Text("ON", style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Outage count:", style: theme.textTheme.titleMedium),
                      Text("2", style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Duration:", style: theme.textTheme.titleMedium),
                      Text("1hr 18min", style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Phase Failure:",
                        style: theme.textTheme.titleMedium,
                      ),
                      Text("NO", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: AppSizes.width(2)),
          // Expanded(
          //   child: Container(
          //     padding: .symmetric(horizontal: 10, vertical: 10),
          //     decoration: BoxDecoration(
          //       color: theme.cardColor,
          //       borderRadius: .circular(16),
          //       border: .all(color: theme.primaryColor),
          //     ),
          //     child: Column(
          //       mainAxisAlignment: .center,
          //       children: [Text("Generator Status")],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class MetrixRow extends StatelessWidget {
  const MetrixRow({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: .symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: .circular(16),
                border: .all(color: theme.primaryColor),
              ),
              child: Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Generator (Today's)",
                    style: theme.textTheme.headlineMedium,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Status:", style: theme.textTheme.titleMedium),
                      Text("Idle", style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Count:", style: theme.textTheme.titleMedium),
                      Text("2", style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Duration:", style: theme.textTheme.titleMedium),
                      Text("1hr 20min", style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Fuel Comsumption:",
                        style: theme.textTheme.titleMedium,
                      ),
                      Text("8 Ltr", style: theme.textTheme.bodyMedium),
                    ],
                  ),

                  Divider(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Health:", style: theme.textTheme.titleMedium),
                      Text("GOOD", style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: AppSizes.width(2)),
          // Expanded(
          //   child: Container(
          //     padding: .symmetric(horizontal: 10, vertical: 10),
          //     decoration: BoxDecoration(
          //       color: theme.cardColor,
          //       borderRadius: .circular(16),
          //       border: .all(color: theme.primaryColor),
          //     ),
          //     child: Column(
          //       mainAxisAlignment: .center,
          //       children: [Text("Generator Status")],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
