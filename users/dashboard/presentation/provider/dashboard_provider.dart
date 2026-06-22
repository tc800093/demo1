import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/features/users/dashboard/domain/model/dashboard_model.dart';
import 'package:poweriot/features/users/dashboard/domain/repository/dashboard_repository.dart';

/// Manages dashboard data state for the user home screen.
///
/// Fetches IoT device data from the server and computes
/// subscription plan expiry indicators.
class DashboardProvider extends ChangeNotifier {
  final DashboardRepository dashboardRepository;
  DashboardProvider({required this.dashboardRepository});

  /// Status of the fetch-dashboard operation.
  Status _dashboardStatus = Status.init;
  Status get dashboardStatus => _dashboardStatus;

  /// Dashboard data model returned from the API.
  DashboardModel? _dashboardModel;
  DashboardModel get dashboardModel => _dashboardModel!;

  /// Latest status message (success or error).
  String _message = '';
  String get message => _message;

  /// The user's current subscription plan expiry date.
  DateTime? planExpiryDate = DateTime(2026, 06, 21);

  /// Returns `true` if the plan expires within the next 5 days (inclusive).
  bool get showExpiryWarning {
    if (planExpiryDate == null) return false;

    final now = DateTime.now();
    final expiry = DateTime(
      planExpiryDate!.year,
      planExpiryDate!.month,
      planExpiryDate!.day,
    );

    final current = DateTime(now.year, now.month, now.day);

    final daysLeft = expiry.difference(current).inDays;

    return daysLeft >= 0 && daysLeft <= 5;
  }

  /// Returns `true` if the subscription plan expiry date has already passed.
  bool get isPlanExpired {
    if (planExpiryDate == null) return false;

    final now = DateTime.now();
    final expiry = DateTime(
      planExpiryDate!.year,
      planExpiryDate!.month,
      planExpiryDate!.day,
    );

    return now.isAfter(expiry);
  }

  /// Returns the number of full days remaining until the plan expires.
  ///
  /// Returns `0` if [planExpiryDate] is null.
  int get daysRemaining {
    if (planExpiryDate == null) return 0;

    return planExpiryDate!.difference(DateTime.now()).inDays;
  }

  /// Fetches dashboard data from the repository.
  ///
  /// Sets [dashboardStatus] to [Status.loading] during the request.
  /// On success, stores the [DashboardModel] and sets status to [Status.success].
  Future<void> fetchDashboardMethod() async {
    try {
      _dashboardStatus = .loading;
      _message = "";
      notifyListeners();

      final result = await dashboardRepository.fetchDashboardRepo();
      await result.fold(
        (error) {
          _dashboardStatus = .failed;
          _message = error.message;
        },
        (success) {
          _dashboardStatus = .success;
          _dashboardModel = success;
          _message = "Data found";
        },
      );
      notifyListeners();
    } catch (e) {
      _dashboardStatus = .failed;
      _message = "something went wrong";
      notifyListeners();
    }
  }
}
