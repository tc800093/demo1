import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/devices/domain/respository/device_repository.dart';

class UpdateDeviceUsecase implements UseCase<String, UpdateDeviceParams> {
  final DeviceRepository repository;

  UpdateDeviceUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(UpdateDeviceParams params) async {
    return await repository.updateDeviceRemoteData(params: params);
  }
}

class UpdateDeviceParams {
  final String deviceCode;
  final String deviceName;
  final String applicationType;
  final String locationName;
  final String areaName;
  final String latitude;
  final String longitude;
  final String geofenceRadius;
  final String imeiNo;
  final String simNo;
  final bool isActice;
  UpdateDeviceParams({
    required this.deviceCode,
    required this.deviceName,
    required this.applicationType,
    required this.locationName,
    required this.areaName,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadius,
    required this.imeiNo,
    required this.simNo,
    required this.isActice,
  });
}
