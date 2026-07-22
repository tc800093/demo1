import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_preset_value_usecase.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/user/dashboard/data/datasources/remote_datasource/stomp_connect.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/domain/model/my_subscription_model.dart';
import 'package:poweriot/features/user/dashboard/domain/usecase/connect_dashboard_websoctket_usecase.dart';
import 'package:poweriot/features/user/dashboard/domain/usecase/fetch_dashboard_data_usecase.dart';
import 'package:poweriot/features/user/dashboard/domain/usecase/fetch_my_subscriptoin_usecase.dart';

enum SocketStatus { disconnected, connecting, connected, error }

class DashboardProvider extends ChangeNotifier {
  StreamSubscription? _socketSubscription;
  final FetchDashboardDataUsecase fetchDashboardDataUsecase;
  final FetchMySubscriptoinUsecase fetchMySubscriptoinUsecase;
  final FetchPresetValueUsecase fetchPresetValueUsecase;
  final AppLogger appLogger;
  final ConnectDashboardWebSocketUseCase connectDashboardWebSocketUseCase;
  DashboardProvider({
    required this.fetchDashboardDataUsecase,
    required this.fetchMySubscriptoinUsecase,
    required this.appLogger,
    required this.fetchPresetValueUsecase,
    required this.connectDashboardWebSocketUseCase,
  }) {
    {
      _socketSubscription = SocketMessageBus.stream.listen((msg) {
        dev.log("Socket message : $msg");

        updateDashboardData(msg);
      });
    }
  }

  Status _dashboardStatus = Status.init;
  Status get dashboardStatus => _dashboardStatus;
  List<DashboardModel>? _dashboardModel;
  List<DashboardModel> get dashboardModel => _dashboardModel!;

  StreamSubscription? _subscription;

  int? _currentIndex = 0;
  int? get currnetIndex => _currentIndex;

  String _message = '';
  String get message => _message;

  Status _getSubscriptionStatus = .init;
  Status get getSubscriptionStatus => _getSubscriptionStatus;

  SocketStatus _socketStatus = .disconnected;

  SocketStatus get socketStatus => _socketStatus;
  String _subscriptinMessage = '';
  String get subscriptionMessage => _subscriptinMessage;

  MySubscriptionModel? _subscriptionModel;
  MySubscriptionModel? get subscriptionModel => _subscriptionModel;

  DashboardModel? _selectedDevice;
  DashboardModel? get selectedDevice => _selectedDevice;

  DateTime? _planExpiryDate;
  DateTime? get planExpiryDate => _planExpiryDate;

  bool? _planWarning = false;
  bool? get planWarning => _planWarning;

  bool? _planExpired = false;
  bool? get planExpired => _planExpired;

  bool _showWarning = false;
  bool get showWarning => _showWarning;
  int? _daysRemaining;
  int? get daysRemaining => _daysRemaining;

  Future<void> connectToSocket() async {
    if (_socketStatus == SocketStatus.connected && _subscription != null) {
      dev.log("WebSocket already connected.");
      return;
    }
    _socketStatus = SocketStatus.connecting;
    notifyListeners();

    try {
      _subscription?.cancel();
      final stream = connectDashboardWebSocketUseCase.call();
      _subscription = stream.listen(
        (msg) {
          dev.log("WebSocket message received: $msg");
          updateDashboardData(msg);
        },
        onError: (error) {
          dev.log("WebSocket error: $error");
          _socketStatus = SocketStatus.error;
          notifyListeners();
        },
        onDone: () {
          dev.log("WebSocket connection closed.");
          _socketStatus = SocketStatus.disconnected;
          notifyListeners();
        },
      );
      _socketStatus = SocketStatus.connected;
    } catch (e) {
      dev.log("WebSocket connection failed: $e");
      _socketStatus = SocketStatus.error;
    }

    notifyListeners();
  }

  // Future<void> connectToSocket() async {
  //   dev.log("connecting to socket...");
  //   final String? token = await service<SecureStorageService>().read(
  //     storedToken,
  //   );

  //   dev.log("this is the token ${token}");

  //   if (token != null && token.isNotEmpty) {
  //     connectStomp(token);
  //   } else {
  //     dev.log("invalid dashboard tokens");
  //   }
  // }

  void disconnect() {
    _subscription?.cancel();
  }

  void updateDashboardData(DashboardModel newData) {
    _dashboardModel ??= [];

    final index = _dashboardModel!.indexWhere(
      (item) => item.deviceId == newData.deviceId,
    );

    if (index >= 0) {
      _dashboardModel![index] = newData.copyWith(isLive: true);
    } else {
      _dashboardModel!.add(newData.copyWith(isLive: true));
    }

    if (_selectedDevice != null && _selectedDevice!.deviceId == newData.deviceId) {
      _selectedDevice = newData.copyWith(isLive: true);
    }

    dev.log("Dashboard updated length ${_dashboardModel!.length}");

    notifyListeners();
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    _subscription?.cancel();

    super.dispose();
  }

  void changePowerSource(int index) {
    _dashboardModel![index] = _dashboardModel![index].copyWith(
      currentPowerSource: _dashboardModel![index].currentPowerSource == "MAINS"
          ? "GENERATOR"
          : "MAINS",
      mains: _dashboardModel![index].mains = _dashboardModel![index].mains!
          .copyWith(
            status: _dashboardModel![index].currentPowerSource == "MAINS"
                ? true
                : false,
          ),
      generator: _dashboardModel![index].generator = _dashboardModel![index]
          .generator!
          .copyWith(
            status: _dashboardModel![index].currentPowerSource == "GENERATOR"
                ? true
                : false,
          ),
    );
    notifyListeners();
  }

  void selectDevice(DashboardModel? deviceModel) {
    _selectedDevice = deviceModel;
    notifyListeners();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int generateRandomNumber(int min, int max) {
    return Random().nextInt(max - min + 1) + min;
  }

  /// Method to fetch dashboard Data
  Future<void> fetchDashboardMethod() async {
    await fetchPresetValueUsecase.call(NoParams());
    try {
      _dashboardStatus = .loading;
      _message = "";
      notifyListeners();

      final result = await fetchDashboardDataUsecase.call(NoParams());

      await result.fold(
        (error) {
          _dashboardStatus = .failed;
          _dashboardModel = [];
          _message = error.message;
        },
        (success) {
          // _dashboardStatus = .success;
          if (success.isNotEmpty) {
            _message = "";
            _dashboardModel = success;

            selectDevice(success.first);
            _dashboardStatus = .success;
          } else {
            _dashboardStatus = .failed;
            _message = "No Device Found";
          }
        },
      );
      notifyListeners();
    } catch (e) {
      _dashboardStatus = .failed;
      _dashboardModel = [];
      _message = "something went wrong";
      notifyListeners();
    }
  }

  /// Method for generator service history
  Future<void> fetchMySubscriptionMethod() async {
    try {
      _getSubscriptionStatus = .loading;
      _subscriptinMessage = '';
      _planWarning = false;
      _showWarning = false;
      _daysRemaining = 0;
      notifyListeners();

      final result = await fetchMySubscriptoinUsecase.call(NoParams());
      await result.fold(
        (failed) {
          _getSubscriptionStatus = .failed;
          _subscriptinMessage = failed.message.toString();
        },
        (success) {
          _subscriptionModel = success;
          _getSubscriptionStatus = .success;
          _planExpiryDate = _subscriptionModel?.expiryDate;
          getPlanStatus(_planExpiryDate!);
          _subscriptinMessage = 'Subscription available';
        },
      );
      notifyListeners();
    } catch (e) {
      _getSubscriptionStatus = .failed;
      _subscriptinMessage = 'something went wrong';
      notifyListeners();
    }
  }

  void changetoWarningStat() {
    getPlanStatus(DateTime.now().add(Duration(days: 3)));
  }

  void changetoExipredStat() {
    getPlanStatus(DateTime.now().subtract(Duration(days: 1)));
  }

  void getPlanStatus(DateTime expiryDate) {
    final now = DateTime.now();

    // Remove time portion to compare only dates.
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);

    final remainingDays = expiry.difference(today).inDays;

    _daysRemaining = remainingDays;

    if (remainingDays < 0) {
      _showWarning = false;
      _planExpired = true;
    } else if (remainingDays >= 0 && remainingDays <= 5) {
      _showWarning = true;
      _planExpired = false;
    } else {
      _showWarning = false;
      _planExpired = false;
    }

    notifyListeners();
  }
}
