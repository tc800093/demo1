import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/model/subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/add_subscription_plan_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/fetch_subscription_plan_list_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/update_subscription_plan_usecase.dart';

/// Manages subscription plan state for the admin section of PowerIoT.
///
/// Handles fetching, adding, updating, and searching subscription plans.
class SubscriptionProvider extends ChangeNotifier {
  final FetchSubscriptionPlanListUsecase fetchSubscriptionPlanListUsecase;
  final AddSubscriptionPlanUsecase addSubscriptionPlanUsecase;
  final UpdateSubscriptionPlanUsecase updateSubscriptionPlanUsecase;
  SubscriptionProvider({
    required this.fetchSubscriptionPlanListUsecase,
    required this.addSubscriptionPlanUsecase,
    required this.updateSubscriptionPlanUsecase,
  });

  /// Status of the fetch-subscription-list operation.
  Status _fetchSubscriptionListStatus = .init;
  Status get fetchStatus => _fetchSubscriptionListStatus;

  /// Status of the add-subscription operation.
  Status _addSubscriptionStatus = .init;
  Status get addStatus => _addSubscriptionStatus;

  /// Status of the update-subscription operation.
  Status _updateSubscriptionStatus = .init;
  Status get updateStatus => _updateSubscriptionStatus;

  /// Latest status message (success or error).
  String _message = '';
  String get message => _message;

  /// Count of currently active subscription plans.
  int _activePlans = 0;
  int get activePlan => _activePlans;

  /// Total number of subscription plans.
  int _totalPlan = 0;
  int get totalPlans => _totalPlan;

  List<SubscriptionModel> _subscriptionList = [];
  List<SubscriptionModel> _filteredSubscription = [];

  /// Returns the filtered list if a search is active, otherwise the full list.
  List<SubscriptionModel> get subscriptionList =>
      _filteredSubscription.isEmpty ? _subscriptionList : _filteredSubscription;

  /// Fetch Subscription plan list method
  Future<void> fetchSubscriptionListMethod() async {
    try {
      _fetchSubscriptionListStatus = .loading;
      _message = '';
      _subscriptionList.clear();
      notifyListeners();

      final result = await fetchSubscriptionPlanListUsecase.call(NoParams());

      await result.fold(
        (error) {
          _fetchSubscriptionListStatus = .failed;
          _message = error.message;
        },

        (success) {
          _message = "Subscriptions plan found";
          _fetchSubscriptionListStatus = .success;
          List<SubscriptionModel> _list = success;
          _activePlans = _list
              .where((element) => element.active == true)
              .toList()
              .length;
          _totalPlan = _list.length;
          setSubscriptionPlan(_list);
        },
      );
      _addSubscriptionStatus = .init;
      _updateSubscriptionStatus = .init;
      notifyListeners();
    } catch (e) {
      _fetchSubscriptionListStatus = .failed;
      _message = "something went wrong";
      notifyListeners();
    }
  }

  /// Set List method
  void setSubscriptionPlan(List<SubscriptionModel> devices) {
    _subscriptionList.clear();
    _subscriptionList.addAll(devices);
    notifyListeners();
  }

  /// Search method
  void searchSubscriptionPlan(String query) {
    if (query.trim().isEmpty) {
      _filteredSubscription.clear();
    } else {
      _filteredSubscription = _subscriptionList.where((plan) {
        return plan.planName.toString().toLowerCase().contains(
          query.toLowerCase(),
        );
      }).toList();
    }

    notifyListeners();
  }

  ///Method to add Subscription plan
  Future<void> addSubscriptionPlanMethod({
    required AddSubscriptionParams params,
  }) async {
    try {
      _addSubscriptionStatus = .loading;
      _message = '';

      final result = await addSubscriptionPlanUsecase.call(params);

      await result.fold(
        (error) {
          _addSubscriptionStatus = .failed;
          _message = error.message;
        },
        (success) {
          _addSubscriptionStatus = .success;
          _message = 'Subscription Added';
          fetchSubscriptionListMethod();
        },
      );
      notifyListeners();
    } catch (e) {
      _addSubscriptionStatus = .failed;
      _message = "something went wrong";
      notifyListeners();
    }
  }

  ///Method to update Subscription plan
  Future<void> updateSubscriptionPlanMethod({
    required UpdateSubscriptionParams params,
  }) async {
    print("inprovider");
    try {
      _updateSubscriptionStatus = .loading;
      _message = '';

      final result = await updateSubscriptionPlanUsecase.call(params);

      await result.fold(
        (error) {
          print("error ${error.message}");
          _updateSubscriptionStatus = .failed;
          _message = error.message;
        },
        (success) {
          print("success");
          _updateSubscriptionStatus = .success;
          _message = 'Subscription Updated';
          fetchSubscriptionListMethod();
        },
      );
      notifyListeners();
    } catch (e) {
      AppLogger().error("getting error $e");
      _updateSubscriptionStatus = .failed;
      _message = "something went wrong";
      notifyListeners();
    }
  }
}
