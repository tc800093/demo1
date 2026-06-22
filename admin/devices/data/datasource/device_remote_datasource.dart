import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/add_device_usecase.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/update_device_usecase.dart';

/// Abstract contract for device-related remote data source operations.
abstract class DeviceRemoteDatasource {
  /// Registers a new IoT device on the server with the provided [params].
  Future<Either<Failure, String>> addDeviceRemoteData({
    required AddDeviceParams params,
  });

  /// Updates an existing IoT device record on the server.
  Future<Either<Failure, String>> updateDeviceRemoteData({
    required UpdateDeviceParams params,
  });

  /// Retrieves the complete list of registered IoT devices from the server.
  Future<Either<Failure, List<DeviceModel>>> fetchDevicesRemoteData();
}

/// Concrete implementation of [DeviceRemoteDatasource] using Dio for HTTP requests.
class DeviceRemoteDatasourceImpl implements DeviceRemoteDatasource {
  final DioClient dioClient;
  final AppLogger appLogger;
  final SecureStorageService secureStorageService;
  DeviceRemoteDatasourceImpl({
    required this.appLogger,
    required this.dioClient,
    required this.secureStorageService,
  });

  static final List<DeviceModel> _staticDevices = [
    DeviceModel(
      deviceId: "device-1",
      userId: "user-123",
      deviceCode: "DEV-001",
      deviceName: "Andheri Head Office",
      locationName: "Mumbai",
      areaName: "Andheri East",
      latitude: 19.0760,
      longitude: 72.8777,
      geofenceRadius: 150,
      imeiNo: "863456789012345",
      simNo: "8991123456789012345f",
      active: true,
      applicationType: "MG",
    ),
    DeviceModel(
      deviceId: "device-2",
      userId: "user-456",
      deviceCode: "DEV-002",
      deviceName: "Pune Branch",
      locationName: "Pune",
      areaName: "Hinjewadi Phase 1",
      latitude: 18.5204,
      longitude: 73.8567,
      geofenceRadius: 200,
      imeiNo: "863456789012346",
      simNo: "8991123456789012346f",
      active: true,
      applicationType: "DG",
    ),
  ];

  @override
  Future<Either<Failure, String>> addDeviceRemoteData({
    required AddDeviceParams params,
  }) async {
    try {
      final newDevice = DeviceModel(
        deviceId: "device-${DateTime.now().millisecondsSinceEpoch}",
        userId: params.userID,
        deviceCode: params.deviceCode,
        deviceName: params.deviceName,
        locationName: params.locationName,
        areaName: params.areaName,
        latitude: double.tryParse(params.latitude.toString()) ?? 0.0,
        longitude: double.tryParse(params.longitude.toString()) ?? 0.0,
        geofenceRadius: double.tryParse(params.geofenceRadius.toString())?.toInt() ?? 0,
        imeiNo: params.imeiNo,
        simNo: params.simNo,
        active: true,
        applicationType: params.applicationType,
      );
      _staticDevices.add(newDevice);
      return right('Device added');
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<DeviceModel>>> fetchDevicesRemoteData() async {
    try {
      return right(List<DeviceModel>.from(_staticDevices));
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> updateDeviceRemoteData({
    required UpdateDeviceParams params,
  }) async {
    try {
      final idx = _staticDevices.indexWhere((element) => element.deviceCode == params.deviceCode);
      if (idx != -1) {
        _staticDevices[idx] = _staticDevices[idx].copyWith(
          deviceName: params.deviceName,
          applicationType: params.applicationType,
          locationName: params.locationName,
          areaName: params.areaName,
          latitude: double.tryParse(params.latitude.toString()) ?? 0.0,
          longitude: double.tryParse(params.longitude.toString()) ?? 0.0,
          geofenceRadius: double.tryParse(params.geofenceRadius.toString())?.toInt() ?? 0,
          imeiNo: params.imeiNo,
          simNo: params.simNo,
          active: params.isActice,
        );
      }
      return right('Device updated');
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }
}
