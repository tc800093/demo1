import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';

import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/users/domain/model/generator_model.dart';
import 'package:poweriot/features/admin/users/domain/model/main_power_model.dart';
import 'package:poweriot/features/admin/users/domain/usecase/fetch_generator_info_usecase.dart';
import 'package:poweriot/features/admin/users/domain/usecase/fetch_main_power_info_usecase.dart';
import 'package:poweriot/features/admin/users/domain/usecase/fetch_user_device_info_usecase.dart';

/// Represents the type of power source connected to the IoT device.
enum SourceType { mg, dg, mseb }

/// Manages device source information (generator and main power) for the user dashboard.
///
/// Fetches device-level information including generator specs and
/// main power (MSEB) details concurrently.
class UserDeviceProvider extends ChangeNotifier {
  final FetchGeneratorInfoUsecase fetchGeneratorInfoUsecase;
  final FetchMainPowerInfoUsecase fetchMainPowerInfoUsecase;
  final SecureStorageService secureStorageService;
  final FetchUserDeviceInfoUsecase fetchUserDeviceInfoUsecase;
  UserDeviceProvider({
    required this.fetchGeneratorInfoUsecase,
    required this.fetchMainPowerInfoUsecase,
    required this.secureStorageService,
    required this.fetchUserDeviceInfoUsecase,
  });

  /// The current power source type detected for the user's device.
  SourceType _sourceType = .mg;
  SourceType get source => _sourceType;

  /// Status of the combined device + source info fetch operation.
  Status _fetchSourceStatus = .init;
  Status get fetchSourceStatus => _fetchSourceStatus;

  /// Status of the fetch-generator-info operation.
  Status _fetchGeneratorStatu = .init;
  Status get fetchGeneratorStatus => _fetchGeneratorStatu;

  /// Status of the fetch-main-power-info operation.
  Status _fetchMainPowerStatus = .init;
  Status get fetchMainPowerStatus => _fetchMainPowerStatus;

  /// The application type string (e.g., 'MG', 'DG', 'MSEB').
  String _applicationType = '';
  String get applicationType => _applicationType;

  /// All devices belonging to the user, each enriched with generator/mains info.
  List<DeviceModel> _devices = [];
  List<DeviceModel> get devices => _devices;

  /// Generator specification data for the user's device.
  GeneratorModel? _generatorModel;
  GeneratorModel get generatorModel => _generatorModel!;

  /// Main power (MSEB) specification data for the user's device.
  MainPowerModel? _powerModel;
  MainPowerModel get powerModel => _powerModel!;

  /// Latest status message.
  String _message = '';
  String get message => _message;

  /// Fetches all devices for [deviceID] (treated as userId) and enriches each
  /// with generator and main power data fetched concurrently per device.
  ///
  /// Application type determines which sub-requests fire:
  /// - `mg`  → generator + mains
  /// - `dg`  → generator only
  /// - `mseb`/`mains` → mains only
  Future<void> fetchSourceInfo({required String deviceID}) async {
    try {
      _fetchSourceStatus = .loading;
      _devices = [];
      notifyListeners();

      List<DeviceModel> devices = [];
      final result = await fetchUserDeviceInfoUsecase.call(deviceID);
      await result.fold(
        (error) {
          log("failed ${error.message}");
          _fetchSourceStatus = .failed;
          _message = error.message;
        },
        (success) async {
          List<DeviceModel> _deviceList = success;

          final futures = _deviceList.map((device) async {
            Future<Either<Failure, GeneratorModel>>? generatorFuture;
            Future<Either<Failure, MainPowerModel>>? mainsFuture;
            final appType = device.applicationType.toString().toLowerCase();

            if (appType == "mg" || appType == "dg") {
              generatorFuture = fetchGeneratorInfoUsecase.call(
                device.deviceId.toString(),
              );
            }

            if (appType == "mg" || appType == "mains" || appType == "mseb") {
              mainsFuture = fetchMainPowerInfoUsecase.call(
                device.deviceId.toString(),
              );
            }

            final deviceResponse = await Future.wait([
              generatorFuture ?? Future.value(right(null)),
              mainsFuture ?? Future.value(right(null)),
            ]);

            dynamic generatorData;
            dynamic mainsPowerData;

            // Unwrap generator result
            (deviceResponse[0] as Either<Failure, dynamic>).fold(
              (_) {},
              (data) => generatorData = data,
            );
            // Unwrap mains result (was previously bugged — assigned future not value)
            (deviceResponse[1] as Either<Failure, dynamic>).fold(
              (_) {},
              (data) => mainsPowerData = data,
            );

            return device.copyWith(
              generatorModel: generatorData,
              mainPowerModel: mainsPowerData,
            );
          });

          devices = await Future.wait(futures);
          _fetchSourceStatus = .success;
          _devices = devices;
        },
      );
      notifyListeners();
    } catch (e, trace) {
      AppLogger().error(
        "error while getting generator and device info $e \n trace $trace",
      );
      _fetchSourceStatus = .failed;
      notifyListeners();
    }
  }

  /// Resets source info state so the next user's detail screen starts clean.
  void resetState() {
    _fetchSourceStatus = .init;
    _devices = [];
    _generatorModel = null;
    _powerModel = null;
    _message = '';
  }
}
