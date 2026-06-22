import 'package:flutter/material.dart';
import 'package:poweriot/core/constants/app_constant.dart';
import 'package:poweriot/core/usecase/usecase.dart';
import 'package:poweriot/features/admin/devices/domain/model/device_model.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/add_device_usecase.dart';
import 'package:poweriot/features/admin/devices/domain/usecase/fetch_all_device_usecase.dart';
import 'package:poweriot/features/admin/users/domain/model/user_model.dart';
import 'package:poweriot/features/admin/users/domain/usecase/fetch_user_list_usecase.dart';

/// Manages the device state for the admin section of PowerIoT.
///
/// Handles fetching all devices, adding devices, filtering/searching,
/// and managing the multi-step form state for adding a new device.
class DeviceProvider extends ChangeNotifier {
  final FetchAllDeviceUsecase fetchAllDeviceUsecase;
  final AddDeviceUsecase addDeviceUsecase;
  final FetchUserListUsecase fetchUserListUsecase;
  DeviceProvider({
    required this.addDeviceUsecase,
    required this.fetchAllDeviceUsecase,
    required this.fetchUserListUsecase,
  });

  /// Current step index in the multi-step device add form.
  int _currentStep = 0;
  int get currentStep => _currentStep;

  /// Advances to the next step in the device add form.
  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  /// Goes back to the previous step in the device add form.
  void previousStep() {
    _currentStep--;
    notifyListeners();
  }

  /// Status of the fetch-all-devices operation.
  Status _fetchDeviceStatus = .init;
  Status get fetchDeviceStatus => _fetchDeviceStatus;

  /// Status of the add-device operation.
  Status _addDeviceStatus = .init;
  Status get addDeviceStatus => _addDeviceStatus;

  List<DeviceModel> _deviceList = [];
  List<DeviceModel> _filteredDevices = [];

  /// Returns the filtered list if a search is active, otherwise the full list.
  List<DeviceModel> get deviceList =>
      _filteredDevices.isEmpty ? _deviceList : _filteredDevices;

  List<UserModel> _userList = [];

  /// List of users available for device assignment.
  List<UserModel> get userList => _userList;

  /// Currently selected user to assign the device to.
  UserModel? _userData;
  UserModel? get userData => _userData;

  /// Latest status message (success or error).
  String _message = '';
  String get message => _message;

  /// Sets the selected user for device assignment.
  void selectUsers(UserModel? user) {
    _userData = user;
    notifyListeners();
  }

  /// Fetches all registered IoT devices from the server.
  ///
  /// Sets [fetchDeviceStatus] to [Status.loading] during fetch.
  /// Resets [addDeviceStatus] to [Status.init] after completion.
  Future<void> fetchAllDevicesMethod() async {
    try {
      _fetchDeviceStatus = .loading;
      _message = '';

      final result = await fetchAllDeviceUsecase.call(NoParams());
      result.fold(
        (error) {
          _fetchDeviceStatus = .failed;
          _message = error.message.toString();
        },
        (success) {
          _fetchDeviceStatus = .success;
          List<DeviceModel> _list = success;
          setDevices(_list);
          _message = "Device found";
        },
      );
      _addDeviceStatus = .init;
      notifyListeners();
    } catch (e) {
      _fetchDeviceStatus = .failed;
      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Fetches the list of all users for the device assignment dropdown.
  Future<void> fetchAllUserMethod() async {
    try {
      _message = '';
      notifyListeners();

      final result = await fetchUserListUsecase.call(NoParams());

      await result.fold(
        (error) {
          _message = error.message;
        },
        (success) {
          _userList.clear();
          List<UserModel> _model = success;
          for (var user in _model) {
            if (!_userList.contains(user)) {
              _userList.add(user);
            }
          }
          _userList.toSet();
          _message = "List of users";
        },
      );
      notifyListeners();
    } catch (e) {
      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Submits a new device registration with the provided [deviceparams].
  ///
  /// On success, triggers [fetchAllDevicesMethod] to refresh the device list.
  Future<void> addDeviceMethod({required AddDeviceParams deviceparams}) async {
    try {
      _addDeviceStatus = .loading;
      _message = '';

      final result = await addDeviceUsecase.call(deviceparams);
      result.fold(
        (error) {
          _addDeviceStatus = .failed;
          _message = error.message.toString();
        },
        (success) async {
          _addDeviceStatus = .success;
          _message = "Device added";
          await fetchAllDevicesMethod();
        },
      );
      notifyListeners();
    } catch (e) {
      _addDeviceStatus = .failed;
      _message = 'something went wrong';
      notifyListeners();
    }
  }

  /// Replaces the internal device list with the provided [devices] list.
  void setDevices(List<DeviceModel> devices) {
    _deviceList.clear();
    _deviceList.addAll(devices);
    notifyListeners();
  }

  /// Filters the device list by [query] matching the device name.
  ///
  /// Clears the filter when [query] is empty to show all devices.
  void searchDevices(String query) {
    if (query.trim().isEmpty) {
      _filteredDevices.clear();
    } else {
      _filteredDevices = _deviceList.where((device) {
        return device.deviceName.toString().toLowerCase().contains(
          query.toLowerCase(),
        );
      }).toList();
    }

    notifyListeners();
  }
}
