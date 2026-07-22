import 'package:flutter/material.dart';
import 'package:poweriot/core/utils/app_sizes.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/device_carousel_card_widget.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/main_power_card.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/power_source.dart';
import 'package:poweriot/features/user/dashboard/presentation/widgets/s3_emergency_stop.dart';
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
            SizedBox(
              height: 170,
              child: PageView.builder(
                // controller: _pageController,
                onPageChanged: (index) {},
                itemCount: 2,
                itemBuilder: (context, index) {
                  return DeviceCarouselCard(
                    device: DashboardModel(
                      mains: MainsModel(),
                      generator: Generator(),
                    ),
                    isActive: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // _buildPageIndicator(dashboardProvider.dashboardModel.length),
            SizedBox(height: AppSizes.height(2)),
            S3PowerSourcesRow(currentPowerSource: ''),
            SizedBox(height: AppSizes.height(2)),
            S3MainPowerCard(
              dashboardModel: DashboardModel(
                applicationType: "",
                currentPowerSource: "",
                deviceId: "",
                deviceName: "",
                generator: Generator(),
                isLive: false,
                lastUpdated: DateTime.now(),
                locationName: "",
                mains: MainsModel(
                  bPhaseStatus: false,
                  billingCycleEnd: '2026-01-01',
                  billingCycleStart: '2026-01-01',
                  currnet: '',
                  dailyConsumption: 0.0,
                  electricityConsumption: 0.0,
                  frequency: 0.0,
                  mainsOnRuntimeInHourUsingBillingCycleInHours: 0,
                  meterReading: 0.0,
                  outageCount: 0,
                  outageDuratioHours: 0.0,
                  phaseFailure: false,
                  phaseType: '',
                  previousMonthMeterReading: 0.0,
                  rPhaseStatus: false,
                  status: false,
                  voltage: 0.0,
                  yPhaseStatus: false,
                ),
              ),
              mains: MainsModel(
                bPhaseStatus: false,
                billingCycleEnd: '2026-01-01',
                billingCycleStart: '2026-01-01',
                currnet: '',
                dailyConsumption: 0.0,
                electricityConsumption: 0.0,
                frequency: 0.0,
                mainsOnRuntimeInHourUsingBillingCycleInHours: 0,
                meterReading: 0.0,
                outageCount: 0,
                outageDuratioHours: 0.0,
                phaseFailure: false,
                phaseType: '',
                previousMonthMeterReading: 0.0,
                rPhaseStatus: false,
                status: false,
                voltage: 0.0,
                yPhaseStatus: false,
              ),
              status: false,
            ),
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
