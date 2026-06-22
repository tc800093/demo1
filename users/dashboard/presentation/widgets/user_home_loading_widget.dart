import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/users/dashboard/domain/model/dashboard_model.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/main_power_card.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/power_source.dart';
import 'package:poweriot/features/users/dashboard/presentation/widgets/s3_emergency_stop.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserHomeLoadingWidget extends StatelessWidget {
  final bool isEnable;
  const UserHomeLoadingWidget({super.key, required this.isEnable});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Skeletonizer(
        enabled: isEnable,
        child: Column(
          children: [
            S3PowerSourcesRow(currentPowerSource: ''),
            SizedBox(height: AppSizes.height(2)),
            S3MainPowerCard(mseb: Mseb(), status: false),
            SizedBox(height: AppSizes.height(2)),
            // S3GeneratorDetailCard(generator: Generator()),
            SizedBox(height: AppSizes.height(2)),
            S3EmergencyStopCard(),
          ],
        ),
      ),
    );
  }
}
