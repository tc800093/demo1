import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:poweriot/core/config/config.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/network/dio_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/domain/model/generator_model.dart';
import 'package:poweriot/features/admin/users/domain/model/main_power_model.dart';

abstract class UserDeviceRemoteDatasource {
  Future<Either<Failure, GeneratorModel>> fetchGeneratorRemoteDatasource({
    required String deviceID,
  });
  Future<Either<Failure, MainPowerModel>> fetchMSEBRemoteDatasource({
    required String deviceID,
  });

  Future<Either<Failure, List<DeviceModel>>> fetchAllDevicesRemoteDataSource({
    required String userid,
  });
}

class UserDeviceRemoteDatasourceImpl implements UserDeviceRemoteDatasource {
  final SecureStorageService secureStorageService;
  final DioClient dioClient;
  final AppLogger appLogger;
  UserDeviceRemoteDatasourceImpl({
    required this.dioClient,
    required this.secureStorageService,
    required this.appLogger,
  });

  @override
  Future<Either<Failure, GeneratorModel>> fetchGeneratorRemoteDatasource({
    required String deviceID,
  }) async {
    try {
      return right(GeneratorModel(
        id: "gen-1",
        deviceId: deviceID,
        generatorName: "Office Generator Set",
        manufacturer: "Kirloskar",
        modelNumber: "K-125",
        serialNumber: "SN-987654321",
        generatorType: "DIESEL",
        generatorCapacityKva: 125,
        generatorCapacityKw: 100,
        fuelTankCapacity: 300,
        averageFuelConsumptionPerHour: 15,
        installationDate: DateTime(2025, 6, 1),
        warrantyExpiryDate: DateTime(2028, 6, 1),
        lastMaintenanceDate: DateTime(2026, 5, 10),
        nextMaintenanceDate: DateTime(2026, 8, 10),
        maintenanceIntervalDays: 90,
        runningHoursAtInstallation: 0,
        supplierName: "PowerCorp Ltd",
        supplierContact: "+91 99999 99999",
        location: "Mumbai",
        active: true,
      ));
    } catch (e) {
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, MainPowerModel>> fetchMSEBRemoteDatasource({
    required String deviceID,
  }) async {
    try {
      return right(MainPowerModel(
        id: "mseb-1",
        deviceId: deviceID,
        connectionName: "Office MSEB Connection",
        meterNumber: "MTR-11223344",
        electricityBoard: "MSEB (Maharashtra State Electricity Board)",
        phaseType: "THREE_PHASE",
      ));
    } catch (e) {
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<DeviceModel>>> fetchAllDevicesRemoteDataSource({
    required String userid,
  }) async {
    try {
      if (userid == "user-123") {
        // Tejas Patil - Multiple Devices
        return right([
          DeviceModel(
            deviceId: "device-1",
            userId: userid,
            deviceCode: "DEV-MG01",
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
            userId: userid,
            deviceCode: "DEV-DG02",
            deviceName: "Pune Generator Site",
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
          DeviceModel(
            deviceId: "device-3",
            userId: userid,
            deviceCode: "DEV-MSEB03",
            deviceName: "Nashik Substation",
            locationName: "Nashik",
            areaName: "Ambad",
            latitude: 19.9975,
            longitude: 73.7898,
            geofenceRadius: 100,
            imeiNo: "863456789012347",
            simNo: "8991123456789012347f",
            active: true,
            applicationType: "MSEB",
          ),
        ]);
      } else if (userid == "user-456") {
        // Vasundhara Dev - Generator only (DG)
        return right([
          DeviceModel(
            deviceId: "device-2",
            userId: userid,
            deviceCode: "DEV-DG02",
            deviceName: "Pune Generator Site",
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
        ]);
      } else if (userid == "user-789") {
        // Rahul Shinde - Mains only (MSEB)
        return right([
          DeviceModel(
            deviceId: "device-3",
            userId: userid,
            deviceCode: "DEV-MSEB03",
            deviceName: "Nashik Substation",
            locationName: "Nashik",
            areaName: "Ambad",
            latitude: 19.9975,
            longitude: 73.7898,
            geofenceRadius: 100,
            imeiNo: "863456789012347",
            simNo: "8991123456789012347f",
            active: true,
            applicationType: "MSEB",
          ),
        ]);
      } else {
        // Fallback or dynamically added users - Mains + Generator (MG)
        return right([
          DeviceModel(
            deviceId: "device-default",
            userId: userid,
            deviceCode: "DEV-DEF001",
            deviceName: "Default Office Connection",
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
        ]);
      }
    } catch (e) {
      return left(ServerFailure('something went wrong'));
    }
  }
}
// 9168497373