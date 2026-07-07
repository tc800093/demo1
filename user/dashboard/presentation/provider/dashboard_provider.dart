import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poweriot/core/common/domain/model/generator_service_history_model.dart';
import 'package:poweriot/core/common/domain/usecase/fetch_generator_service_history_usecase.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:poweriot/features/user/dashboard/domain/model/my_subscription_model.dart';
import 'package:poweriot/features/user/dashboard/domain/usecase/fetch_dashboard_data_usecase.dart';
import 'package:poweriot/features/user/dashboard/domain/usecase/fetch_my_subscriptoin_usecase.dart';

class DashboardProvider extends ChangeNotifier {
  final FetchDashboardDataUsecase fetchDashboardDataUsecase;
  final FetchMySubscriptoinUsecase fetchMySubscriptoinUsecase;
  final AppLogger appLogger;
  DashboardProvider({
    required this.fetchDashboardDataUsecase,
    required this.fetchMySubscriptoinUsecase,
    required this.appLogger,
  });

  Status _dashboardStatus = Status.init;
  Status get dashboardStatus => _dashboardStatus;
  List<DashboardModel>? _dashboardModel;
  List<DashboardModel> get dashboardModel => _dashboardModel!;

  int? _currentIndex = 0;
  int? get currnetIndex => _currentIndex;

  String _message = '';
  String get message => _message;

  Status _getSubscriptionStatus = .init;
  Status get getSubscriptionStatus => _getSubscriptionStatus;

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

  /// Method to fetch dashboard Data
  Future<void> fetchDashboardMethod() async {
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
          log("failed to get subscription");
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
