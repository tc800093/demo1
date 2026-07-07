import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/logger/app_logger.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/subscription/domain/model/user_subscription_model.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/assign_subscription_by_admin_usecase.dart';
import 'package:poweriot/features/admin/subscription/domain/usecase/fetch_subscription_by_userid_usecase.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/domain/usecase/add_user_usecase.dart';
import 'package:poweriot/features/admin/users/domain/usecase/delete_user_usecase.dart';
import 'package:poweriot/features/admin/users/domain/usecase/fetch_user_by_id_usecase.dart';
import 'package:poweriot/features/admin/users/domain/usecase/fetch_user_list_usecase.dart';
import 'package:poweriot/features/admin/users/domain/usecase/update_user_data_usecase.dart';

/// Manages user administration state for the admin section of PowerIoT.
///
/// Handles fetching, adding, updating, deleting users,
/// fetching user subscriptions, and assigning plans to users.
class UserProvider extends ChangeNotifier {
  final AddUserUsecase addUserUsecase;
  final FetchUserListUsecase fetchUserListUsecase;
  final FetchUserByIdUsecase fetchUserByIdUsecase;
  final UpdateUserDataUsecase updateUserDataUsecase;
  final DeleteUserUsecase deleteUserUsecase;
  final SecureStorageService secureStorageService;
  final FetchSubscriptionByUseridUsecase fetchSubscriptionByUseridUsecase;
  final AssignSubscriptionByAdminUsecase assignSubscriptionByAdminUsecase;
  UserProvider({
    required this.addUserUsecase,
    required this.fetchUserListUsecase,
    required this.fetchUserByIdUsecase,
    required this.updateUserDataUsecase,
    required this.deleteUserUsecase,
    required this.secureStorageService,
    required this.fetchSubscriptionByUseridUsecase,
    required this.assignSubscriptionByAdminUsecase,
  });

  /// Status of the add-user operation.
  Status _addUserStatus = Status.init;
  Status get addUserStatus => _addUserStatus;

  /// Status of the fetch-all-users operation.
  Status _fetchUserStatus = Status.init;
  Status get fetchUserStatus => _fetchUserStatus;

  /// Status of the subscription assignment operation.
  Status _assignPlanStatus = Status.init;
  Status get assignPlanStatus => _assignPlanStatus;

  /// Status of the fetch-user-by-ID operation.
  Status _fetchByIDUserStatus = Status.init;
  Status get fetchByIDUserStatus => _fetchByIDUserStatus;

  /// Status of the update-user operation.
  Status _updateUserStatus = Status.init;
  Status get updateUserStatus => _updateUserStatus;

  /// Status of the delete-user operation.
  Status _deleteUserStatus = Status.init;
  Status get deleteUserStatus => _deleteUserStatus;

  /// Status of the fetch-subscription-by-user-ID operation.
  Status _fetchSubsctiptionByIDStatus = .init;
  Status get fetchSubscriptionByIDStatus => _fetchSubsctiptionByIDStatus;

  /// Subscription data for the currently selected user.
  UserSubscriptionModel? _userSubscriptionModel;
  UserSubscriptionModel? get userSubscriptionModel => _userSubscriptionModel;

  /// Latest status message (success or error).
  String _message = '';
  String get message => _message;

  List<UserModel> _userList = [];
  List<UserModel> _filteredusers = [];

  /// Currently selected user's data.
  UserModel? _userData;
  UserModel get userData => _userData!;

  UserModel? _addedUserData;
  UserModel? get addedUserData => _addedUserData;

  /// Returns the filtered list if a search is active, otherwise the full list.
  List<UserModel> get userList =>
      _filteredusers.isEmpty ? _userList : _filteredusers;

  /// Currently selected device for the user detail view.
  DeviceModel? _selectedDevice;
  DeviceModel? get selectedDevice => _selectedDevice;

  /// Sets the currently selected device in the user detail view.
  void selectDevice(DeviceModel? device) {
    _selectedDevice = device;
    notifyListeners();
  }

  /// Replaces the internal user list with the provided [devices] list.
  void setUsers(List<UserModel> devices) {
    _userList.clear();
    _userList.addAll(devices);
    notifyListeners();
  }

  /// Filters the user list by [query] matching the user's full name.
  /// Clears the filter when [query] is empty.
  void searchUsers(String query) {
    if (query.trim().isEmpty) {
      _filteredusers.clear();
    } else {
      _filteredusers = _userList.where((device) {
        return device.fullName.toString().toLowerCase().contains(
          query.toLowerCase(),
        );
      }).toList();
    }

    notifyListeners();
  }

  /// Creates a new user using [params] and refreshes the user list on success.
  Future<void> addUserMethod({required AddUserParams params}) async {
    try {
      _addUserStatus = .loading;
      _message = '';
      notifyListeners();

      final result = await addUserUsecase.call(params);

      await result.fold(
        (error) {
          AppLogger().error("status failed ${error.message}");
          _addUserStatus = .failed;
          _message = error.message;
        },
        (success) async {
          _addedUserData = success;
          _addUserStatus = .success;
          fetchAllUserMethod();
          _message = "user added";
        },
      );
      notifyListeners();
    } catch (e, trace) {
      AppLogger().error(
        "error while getting the adding the user $e \n trace $trace",
      );
      _addUserStatus = .failed;
      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Fetches the complete list of users, excluding the currently logged-in admin.
  /// Uses [secureStorageService] to read the current user ID and filter them out.
  Future<void> fetchAllUserMethod() async {
    try {
      _fetchUserStatus = .loading;
      _message = '';
      notifyListeners();

      final String? id = await secureStorageService.read(userID);
      final result = await fetchUserListUsecase.call(NoParams());

      await result.fold(
        (error) {
          List<UserModel> _userListFromApi = [
            UserModel(
              userId: "",
              active: true,
              deviceId: "sas",
              email: "test@vasundhara.com",
              fullName: "test user",
              mobileNumber: "9999999999",
              organizationName: "HS housing",
              role: "user",
            ),
          ];
          setUsers(_userListFromApi);
          _fetchUserStatus = .success;
          _message = error.message;
        },
        (success) {
          _fetchUserStatus = .success;
          List<UserModel> _userListFromApi = success
              .where((device) => device.userId != id)
              .toList();
          setUsers(_userListFromApi);
          _message = "List of users";
        },
      );
      _addUserStatus = .init;

      notifyListeners();
    } catch (e) {
      // List<UserModel> _userListFromApi = [
      //   UserModel(
      //     userId: "",
      //     active: true,
      //     deviceId: "sas",
      //     email: "test@vasundhara.com",
      //     fullName: "test user",
      //     mobileNumber: "9999999999",
      //     organizationName: "HS housing",
      //     role: "user",
      //   ),
      // ];
      // setUsers(_userListFromApi);
      _fetchUserStatus = .failed;
      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Fetches a single user's data by their [userID].
  Future<void> fetchUserByIDMethod({required String userID}) async {
    try {
      _fetchByIDUserStatus = .loading;
      _message = '';
      notifyListeners();

      final result = await fetchUserByIdUsecase.call(userID);

      await result.fold(
        (error) {
          _fetchByIDUserStatus = .failed;
          _message = error.message;
        },
        (success) async {
          _fetchByIDUserStatus = .success;
          _userData = success;

          _message = "User data available";
        },
      );
      _addUserStatus = .init;
      _updateUserStatus = .init;
      notifyListeners();
    } catch (e) {
      _fetchByIDUserStatus = .failed;
      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Fetch the subscription plan assigned to a user identified by [userId].
  Future<void> fetchSubscriptionByUserIDMethod({required String userId}) async {
    try {
      _fetchSubsctiptionByIDStatus = .loading;
      _message = '';
      notifyListeners();

      final result = await fetchSubscriptionByUseridUsecase.call(userId);

      await result.fold(
        (error) {
          _fetchSubsctiptionByIDStatus = .failed;
          _message = error.message;
        },
        (success) async {
          _fetchSubsctiptionByIDStatus = .success;
          _userSubscriptionModel = success;
          _message = "Subscription data found";
        },
      );
      _assignPlanStatus = .init;
      notifyListeners();
    } catch (e) {
      _fetchSubsctiptionByIDStatus = .failed;

      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Updates the profile data for the given [user].
  ///
  /// On success, immediately re-fetches the user's data to keep state in sync.
  Future<void> updateUserByIDMethod({required UserModel user}) async {
    try {
      _updateUserStatus = .loading;
      _message = '';
      notifyListeners();

      final result = await updateUserDataUsecase.call(user);

      await result.fold(
        (error) {
          _updateUserStatus = .failed;
          _message = error.message;
        },
        (success) async {
          _updateUserStatus = .success;
          await fetchUserByIDMethod(userID: user.userId.toString());
          _message = "User data update";
        },
      );
      notifyListeners();
    } catch (e) {
      _updateUserStatus = .failed;
      _message = 'something went wrong]';
      notifyListeners();
    }
  }

  /// Assigns a subscription plan to a user using [params].
  ///
  /// On success, re-fetches the user's current subscription to reflect the change.
  Future<void> assignPlan({required AssignSubscriptionParams params}) async {
    try {
      _assignPlanStatus = .loading;
      _message = '';
      notifyListeners();

      /// call the usecase for assing menthod
      final result = await assignSubscriptionByAdminUsecase.call(params);

      await result.fold(
        (error) {
          _assignPlanStatus = .failed;
          AppLogger().error("Error while assign subscription ${error.message}");
        },
        (success) {
          fetchSubscriptionByUserIDMethod(userId: params.userId);
          _assignPlanStatus = .success;
          AppLogger().debug("assign subscription");
        },
      );
    } catch (e) {
      _assignPlanStatus = .failed;
      _message = "something went wrong";
      notifyListeners();
    }
  }

  /// Deletes the currently selected user.
  Future<void> deleteUserByIDMethod() async {
    try {
      _deleteUserStatus = .loading;
      _message = '';
      notifyListeners();

      final result = await deleteUserUsecase.call(NoParams());

      await result.fold(
        (error) {
          _deleteUserStatus = .failed;
          _message = error.message;
        },
        (success) {
          _deleteUserStatus = .success;
          _message = "User deleted";
        },
      );
      notifyListeners();
    } catch (e) {
      _deleteUserStatus = .failed;
      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Resets all detail-screen-specific statuses back to [Status.init].
  ///
  /// Call this in the detail screen's [dispose()] so that opening
  /// the next user starts with a clean state (no stale flash of old data).
  void resetDetailState() {
    _fetchByIDUserStatus = Status.init;
    _fetchSubsctiptionByIDStatus = Status.init;
    _updateUserStatus = Status.init;
    _userData = null;
    _userSubscriptionModel = null;
  }
}
