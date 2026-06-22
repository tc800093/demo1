import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/devices/domain/respository/device_repository.dart';

class AddDeviceUsecase implements UseCase<String, AddDeviceParams> {
  final DeviceRepository repository;

  AddDeviceUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(AddDeviceParams params) async {
    return await repository.addDeviceRemoteData(params: params);
  }
}

class AddDeviceParams {
  final String deviceCode;
  final String deviceName;
  final String applicationType;
  final String userID;
  final String locationName;
  final String areaName;
  final String latitude;
  final String longitude;
  final String geofenceRadius;
  final String imeiNo;
  final String simNo;
  final String? connectionName;
  final String? meterNumber;
  final String? generatorName;
  final String? generatorModel;
  final String? manufacturer;
  final String? generatorFuelType;
  final String? generatorFuelCapacity;
  final String? generatorCapacityKW;
  final String? installationDate;
  final String? warrantyExpiryDate;

  AddDeviceParams({
    required this.deviceCode,
    required this.deviceName,
    required this.applicationType,
    required this.userID,
    required this.locationName,
    required this.areaName,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadius,
    required this.imeiNo,
    required this.simNo,
    this.connectionName,
    this.meterNumber,
    this.generatorName,
    this.generatorModel,
    this.manufacturer,
    this.generatorFuelType,
    this.generatorFuelCapacity,
    this.generatorCapacityKW,
    this.installationDate,
    this.warrantyExpiryDate,
  });
}
