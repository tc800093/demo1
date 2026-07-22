import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:poweriot/core/common/domain/model/generator_refuel_history_model.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_Refuel_record_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_generator_refuel_history_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_generator_service_history_usecase.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/errors/failure.dart';

class MaintenanceLogProvider extends ChangeNotifier {
  final FetchGeneratorServiceHistoryUsecase fetchGeneratorServiceHistoryUsecase;
  final FetchGeneratorRefuelHistoryUsecase fetchGeneratorRefuelHistoryUsecase;
  final AddGeneratorRefuelRecordUsecase addGeneratorRefuelRecordUsecase;
  MaintenanceLogProvider({
    required this.fetchGeneratorServiceHistoryUsecase,
    required this.fetchGeneratorRefuelHistoryUsecase,
    required this.addGeneratorRefuelRecordUsecase,
  });

  Status _serviceHistoryStatus = .init;
  Status get serviceHistoryStatus => _serviceHistoryStatus;

  Status _refuelHistoryStatus = .init;
  Status get refuelHistoryStatus => _refuelHistoryStatus;

  List<GeneratorServiceHistoryModel>? _serviceHistoryModel;
  List<GeneratorServiceHistoryModel>? get serviceHistoryModel =>
      _serviceHistoryModel!;

  List<GeneratorRefuelHistoryModel>? _refuelHistoryModel;
  List<GeneratorRefuelHistoryModel>? get refuelHistoryModel =>
      _refuelHistoryModel;

  String _serviceHistorymessage = '';
  String get serviceHistorymessage => _serviceHistorymessage;
  String _refuelHistoryMessage = '';
  String get refuelHistorymessage => _refuelHistoryMessage;

  Status _addFuelRecordStatus = .init;
  Status get addFuelRecordStatus => _addFuelRecordStatus;

  Future<void> fetchMaintenanceLogs({required String deviceID}) async {
    try {
      _serviceHistoryStatus = .loading;
      _refuelHistoryStatus = .loading;
      _serviceHistorymessage = '';
      _refuelHistoryMessage = '';
      notifyListeners();

      final results = await Future.wait([
        fetchGeneratorServiceHistoryUsecase.call(deviceID),
        fetchGeneratorRefuelHistoryUsecase.call(deviceID),
      ]);

      final serviceResult =
          results[0] as Either<Failure, List<GeneratorServiceHistoryModel>>;
      final refuelResult =
          results[1] as Either<Failure, List<GeneratorRefuelHistoryModel>>;

      serviceResult.fold(
        (failed) {
          _serviceHistoryStatus = .failed;
          _serviceHistorymessage = failed.message.toString();
        },
        (success) {
          _serviceHistoryModel = success;
          _serviceHistoryStatus = .success;
        },
      );

      refuelResult.fold(
        (failed) {
          _refuelHistoryStatus = .failed;
          _refuelHistoryMessage = failed.message.toString();
        },
        (success) {
          _refuelHistoryModel = success;
          _refuelHistoryStatus = .success;
        },
      );

      notifyListeners();
    } catch (e) {
      _serviceHistoryStatus = .failed;
      _refuelHistoryStatus = .failed;
      _serviceHistorymessage = 'something went wrong';
      _refuelHistoryMessage = 'something went wrong';
      notifyListeners();
    }
  }

  Future<void> fetchGeneratorServiceHistoryMethod({
    required String deviceID,
  }) async {
    try {
      _serviceHistoryStatus = .loading;
      notifyListeners();

      final result = await fetchGeneratorServiceHistoryUsecase.call(deviceID);
      await result.fold(
        (failed) {
          _serviceHistoryStatus = .failed;
          _serviceHistorymessage = failed.message.toString();
        },
        (success) {
          _serviceHistoryModel = success;
          _serviceHistoryStatus = .success;
        },
      );
      notifyListeners();
    } catch (e) {
      _serviceHistoryStatus = .failed;
      _serviceHistorymessage = 'something went wrong';
      notifyListeners();
    }
  }

  Future<void> addGeneratorRefuelRecordMethod({
    required AddGeneratorRefuelRecordParams params,
  }) async {
    try {
      _addFuelRecordStatus = .loading;
      notifyListeners();

      final result = await addGeneratorRefuelRecordUsecase.call(params);

      result.fold(
        (error) {
          _addFuelRecordStatus = .failed;
        },
        (right) {
          _addFuelRecordStatus = .success;
          fetchMaintenanceLogs(deviceID: params.deviceId);
        },
      );
      notifyListeners();
    } catch (e) {
      _addFuelRecordStatus = .failed;
      notifyListeners();
    }
  }

  void resetStatus() {
    _addFuelRecordStatus = .init;
    notifyListeners();
  }
}
