import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:poweriot/core/common/domain/model/generator_refuel_history_model.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_Refuel_record_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_service_record_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_generator_refuel_history_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_generator_service_history_usecase.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/errors/failure.dart';
import 'package:poweriot/core/logger/app_logger.dart';

import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/core/common/domain/model/generator_model.dart';
import 'package:poweriot/core/common/domain/model/main_power_model.dart';
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
  final FetchGeneratorServiceHistoryUsecase fetchGeneratorServiceHistoryUsecase;
  final AddGeneratorServiceRecordUsecase addGeneratorServiceRecordUsecase;
  final FetchGeneratorRefuelHistoryUsecase fetchGeneratorRefuelHistoryUsecase;
  final AddGeneratorRefuelRecordUsecase addGeneratorRefuelRecordUsecase;
  UserDeviceProvider({
    required this.fetchGeneratorInfoUsecase,
    required this.fetchMainPowerInfoUsecase,
    required this.secureStorageService,
    required this.fetchUserDeviceInfoUsecase,
    required this.fetchGeneratorServiceHistoryUsecase,
    required this.addGeneratorServiceRecordUsecase,
    required this.fetchGeneratorRefuelHistoryUsecase,
    required this.addGeneratorRefuelRecordUsecase,
  });

  /// Status of the combined device + source info fetch operation.
  Status _fetchSourceStatus = .init;
  Status get fetchSourceStatus => _fetchSourceStatus;

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

  Status _addServiceStatus = Status.init;
  Status get addServiceStatus => _addServiceStatus;

  Status _addRefuelStatus = Status.init;
  Status get addRefuelStatus => _addRefuelStatus;

  void resetAddServiceStatus() {
    _addServiceStatus = Status.init;
  }

  void resetAddRefuelStatus() {
    _addRefuelStatus = Status.init;
  }

  /// Fetches all devices for [deviceID] (treated as userId) and enriches each
  /// with generator and main power data fetched concurrently per device.
  ///
  /// Application type determines which sub-requests fire:
  ///  `mg`   generator + mains
  ///  `dg`   generator only
  ///  `mseb`/`mains` → mains only
  Future<void> fetchSourceInfo({required String deviceID}) async {
    try {
      _fetchSourceStatus = .loading;
      _devices = [];
      notifyListeners();

      List<DeviceModel> devices = [];
      final result = await fetchUserDeviceInfoUsecase.call(deviceID);
      await result.fold(
        (error) {
          _fetchSourceStatus = .failed;
          _message = error.message;
        },
        (success) async {
          List<DeviceModel> _deviceList = success;
          final futures = _deviceList.map((device) async {
            Future<Either<Failure, GeneratorModel>>? generatorFuture;
            Future<Either<Failure, MainPowerModel>>? mainsFuture;
            Future<Either<Failure, List<GeneratorServiceHistoryModel>>>?
            serviceHistoryFuture;
            Future<Either<Failure, List<GeneratorRefuelHistoryModel>>>?
            refuelHistoryFuture;
            final appType = device.applicationType.toString().toLowerCase();

            if (appType == "mg" || appType == "dg") {
              generatorFuture = fetchGeneratorInfoUsecase.call(
                device.deviceId.toString(),
              );
              serviceHistoryFuture = fetchGeneratorServiceHistoryUsecase.call(
                device.deviceId.toString(),
              );
              refuelHistoryFuture = fetchGeneratorRefuelHistoryUsecase.call(
                device.deviceId.toString(),
              );
            }

            if (appType == "mg" || appType == "mains") {
              mainsFuture = fetchMainPowerInfoUsecase.call(
                device.deviceId.toString(),
              );
            }

            final deviceResponse = await Future.wait([
              generatorFuture ?? Future.value(right(null)),
              mainsFuture ?? Future.value(right(null)),
              serviceHistoryFuture ?? Future.value(right(null)),
              refuelHistoryFuture ?? Future.value(right(null)),
            ]);

            dynamic generatorData;
            dynamic mainsPowerData;
            dynamic serviceHistoryData;
            dynamic refuelHistoryData;

            // Unwrap generator result
            (deviceResponse[0]).fold((_) {}, (data) => generatorData = data);
            // Unwrap mains result
            (deviceResponse[1]).fold((f) {}, (data) => mainsPowerData = data);
            (deviceResponse[2]).fold(
              (f) {},
              (data) => serviceHistoryData = data,
            );
            (deviceResponse[3]).fold(
              (f) {},
              (data) => refuelHistoryData = data,
            );

            return device.copyWith(
              generatorModel: generatorData,
              mainPowerModel: mainsPowerData,
              serviceHistory: serviceHistoryData,
              refuelHistory: refuelHistoryData,
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

  Future<void> addGeneratorServiceRecordMethod({
    required AddGeneratorServiceRecordParams params,
  }) async {
    try {
      _addServiceStatus = Status.loading;
      notifyListeners();
      final result = await addGeneratorServiceRecordUsecase.call(params);

      result.fold(
        (error) {
          _addServiceStatus = Status.failed;
          _message = error.message;
        },
        (right) {
          _addServiceStatus = Status.success;
          fetchSourceInfo(deviceID: params.userID.toString());
        },
      );
      notifyListeners();
    } catch (e) {
      _addServiceStatus = Status.failed;
      _message = "something went wrong";
      notifyListeners();
    }
  }

  Future<void> addGeneratorRefuelRecordMethod({
    required AddGeneratorRefuelRecordParams params,
    required String userId,
  }) async {
    try {
      _addRefuelStatus = Status.loading;
      notifyListeners();
      final result = await addGeneratorRefuelRecordUsecase.call(params);

      result.fold(
        (error) {
          _addRefuelStatus = Status.failed;
          _message = error.message;
        },
        (right) {
          _addRefuelStatus = Status.success;
          fetchSourceInfo(deviceID: userId);
        },
      );
      notifyListeners();
    } catch (e) {
      _addRefuelStatus = Status.failed;
      _message = "something went wrong";
      notifyListeners();
    }
  }

  /// Resets source info state so the next user's detail screen starts clean.
  void resetState() {
    _fetchSourceStatus = .init;
    _addServiceStatus = .init;
    _addRefuelStatus = .init;
    _devices = [];
    _generatorModel = null;
    _powerModel = null;
    _message = '';
  }
}
