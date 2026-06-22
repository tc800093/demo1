import 'package:dartz/dartz.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/features/admin/devices/data/datasource/device_remote_datasource.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/add_device_usecase.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/update_device_usecase.dart';

/// Abstract contract for device-related data operations.
///
/// Defines methods for adding, updating, and fetching IoT devices.
abstract class DeviceRepository {
  /// Registers a new IoT device with [params] on the server.
  Future<Either<Failure, String>> addDeviceRemoteData({
    required AddDeviceParams params,
  });

  /// Updates an existing device record using [params].
  Future<Either<Failure, String>> updateDeviceRemoteData({
    required UpdateDeviceParams params,
  });

  /// Retrieves the full list of registered IoT devices from the server.
  Future<Either<Failure, List<DeviceModel>>> fetchDevicesRemoteData();
}

/// Concrete implementation of [DeviceRepository].
///
/// Delegates all operations to [DeviceRemoteDatasource].
class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDatasource deviceRemoteDatasource;
  DeviceRepositoryImpl({required this.deviceRemoteDatasource});

  /// Delegates to [DeviceRemoteDatasource.addDeviceRemoteData].
  @override
  Future<Either<Failure, String>> addDeviceRemoteData({
    required AddDeviceParams params,
  }) async {
    return deviceRemoteDatasource.addDeviceRemoteData(params: params);
  }

  /// Delegates to [DeviceRemoteDatasource.fetchDevicesRemoteData].
  @override
  Future<Either<Failure, List<DeviceModel>>> fetchDevicesRemoteData() {
    return deviceRemoteDatasource.fetchDevicesRemoteData();
  }

  /// Delegates to [DeviceRemoteDatasource.updateDeviceRemoteData].
  @override
  Future<Either<Failure, String>> updateDeviceRemoteData({
    required UpdateDeviceParams params,
  }) async {
    return await deviceRemoteDatasource.updateDeviceRemoteData(params: params);
  }
}
