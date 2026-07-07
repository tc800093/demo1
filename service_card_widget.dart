import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/utils/app_sizes.dart';

class ServiceCardWidget extends StatelessWidget {
  final GeneratorServiceHistoryModel model;
  const ServiceCardWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('dd MMM yyyy').format(model.serviceDate!);
    return Container(
      padding: .all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: .circular(12),
        // border: Border.all(color: theme.dividerColor, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                model.serviceType.toString(),
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: .bold),
              ),
              Text(
                '₹${model.cost!.toStringAsFixed(0)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: .bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(0.5)),
          Row(
            children: [
              const Icon(Icons.memory_outlined, size: 14, color: Colors.grey),
              SizedBox(width: AppSizes.width(0.6)),
              SizedBox(
                width: AppSizes.width(35),
                child: Text(
                  model.deviceName.toString(),
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.width(1.4)),
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.grey,
              ),
              SizedBox(width: AppSizes.width(.4)),
              Text(
                dateStr,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          if (model.remarks!.isNotEmpty) ...[
            SizedBox(height: AppSizes.height(0.5)),
            Text(model.remarks!, style: theme.textTheme.bodyMedium),
          ],
          SizedBox(height: AppSizes.height(0.6)),
          Divider(height: 20),
        ],
      ),
    );
  }
}
