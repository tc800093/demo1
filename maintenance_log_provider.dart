import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/common/domain/model/generator_refuel_history_model.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_generator_service_history_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_generator_refuel_history_usecase.dart';
import 'package:poweriot/core/common/domain/usecase/add_generator_Refuel_record_usecase.dart';
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

  Status _serviceHistoryStatus = Status.init;
  Status get serviceHistoryStatus => _serviceHistoryStatus;

  List<GeneratorServiceHistoryModel>? _serviceHistoryModel;
  List<GeneratorServiceHistoryModel> get serviceHistoryModel =>
      _serviceHistoryModel ?? [];

  String _serviceHistorymessage = '';
  String get serviceHistorymessage => _serviceHistorymessage;

  Status _refuelHistoryStatus = Status.init;
  Status get refuelHistoryStatus => _refuelHistoryStatus;

  List<GeneratorRefuelHistoryModel>? _refuelHistoryModel;
  List<GeneratorRefuelHistoryModel> get refuelHistoryModel =>
      _refuelHistoryModel ?? [];

  String _refuelHistoryMessage = '';
  String get refuelHistoryMessage => _refuelHistoryMessage;

  Status _addRefuelStatus = Status.init;
  Status get addRefuelStatus => _addRefuelStatus;

  void resetAddRefuelStatus() {
    _addRefuelStatus = Status.init;
    notifyListeners();
  }

  Future<void> fetchGeneratorServiceHistoryMethod({
    required String deviceID,
  }) async {
    await fetchMaintenanceLogs(deviceID: deviceID);
  }

  Future<void> fetchMaintenanceLogs({required String deviceID}) async {
    try {
      _serviceHistoryStatus = Status.loading;
      _refuelHistoryStatus = Status.loading;
      _serviceHistorymessage = '';
      _refuelHistoryMessage = '';
      notifyListeners();

      final results = await Future.wait([
        fetchGeneratorServiceHistoryUsecase.call(deviceID),
        fetchGeneratorRefuelHistoryUsecase.call(deviceID),
      ]);

      final serviceResult = results[0] as Either<Failure, List<GeneratorServiceHistoryModel>>;
      final refuelResult = results[1] as Either<Failure, List<GeneratorRefuelHistoryModel>>;

      serviceResult.fold(
        (failed) {
          _serviceHistoryStatus = Status.failed;
          _serviceHistorymessage = failed.message.toString();
        },
        (success) {
          _serviceHistoryModel = success;
          _serviceHistoryStatus = Status.success;
        },
      );

      refuelResult.fold(
        (failed) {
          _refuelHistoryStatus = Status.failed;
          _refuelHistoryMessage = failed.message.toString();
        },
        (success) {
          _refuelHistoryModel = success;
          _refuelHistoryStatus = Status.success;
        },
      );

      notifyListeners();
    } catch (e) {
      _serviceHistoryStatus = Status.failed;
      _refuelHistoryStatus = Status.failed;
      _serviceHistorymessage = 'something went wrong';
      _refuelHistoryMessage = 'something went wrong';
      notifyListeners();
    }
  }

  Future<void> addGeneratorRefuelRecordMethod({
    required AddGeneratorRefuelRecordParams params,
  }) async {
    try {
      _addRefuelStatus = Status.loading;
      notifyListeners();

      final result = await addGeneratorRefuelRecordUsecase.call(params);
      await result.fold(
        (failed) {
          _addRefuelStatus = Status.failed;
          _refuelHistoryMessage = failed.message.toString();
        },
        (success) async {
          _addRefuelStatus = Status.success;
          await fetchMaintenanceLogs(deviceID: params.deviceId);
        },
      );
      notifyListeners();
    } catch (e) {
      _addRefuelStatus = Status.failed;
      _refuelHistoryMessage = 'something went wrong';
      notifyListeners();
    }
  }
}
