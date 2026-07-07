import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/constants/app_colors.dart';
import 'package:poweriot/core/utils/click_event.dart';
import 'package:poweriot/core/utils/helper.dart';
import 'package:poweriot/features/user/analytics/domain/usecase/fetch_analytics_usecase.dart';
import 'package:poweriot/features/user/analytics/presentation/provider/analytics_provider.dart';
import 'package:provider/provider.dart';

class DateRangeSelector extends StatefulWidget {
  final String userDeviceID;
  final DateTime fromDate;
  final DateTime toDate;
  final void Function()? onTapSelectFromDate;
  final void Function()? onTapSelectToDate;
  const DateRangeSelector({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.userDeviceID,
    this.onTapSelectFromDate,
    this.onTapSelectToDate,
  });

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          Expanded(
            child: InkWell(
              onTap: widget.onTapSelectFromDate,
              child: Container(
                padding: .all(12),

                decoration: BoxDecoration(
                  color: pureWhiteColor,
                  borderRadius: .circular(12),
                  border: .all(color: slateDarkGrayColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formatDate(widget.fromDate),
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "To",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: widget.onTapSelectToDate,
              child: Container(
                padding: .all(12),
                decoration: BoxDecoration(
                  border: .all(color: slateDarkGrayColor),
                  borderRadius: .circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formatDate(widget.toDate),
                        overflow: .ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ClickLogger.logClick(
                buttonName: "Search Icon",
                eventName: "Search analytics fromDate to ToDate",
                screenName: "Analytics",
                userId: '',
              );
              context.read<AnalyticsProvider>().fetchAnalyticsMethod(
                params: FetchAnalyticsParams(
                  userDevice: widget.userDeviceID,
                  fromDate: dateToString(widget.fromDate),
                  toDate: dateToString(widget.toDate),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
