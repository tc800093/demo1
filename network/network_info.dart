import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract contract for network info checking.
abstract class NetworkInfo {
  /// Returns true if connected to mobile or wifi at the moment.
  Future<bool> get isConnected;

  /// Stream that emits true/false whenever connectivity changes.
  Stream<bool> get onConnectivityChanged;
}

/// Implementation using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  late final StreamController<bool> _controller;

  NetworkInfoImpl(this._connectivity) {
    _controller = StreamController<bool>.broadcast();
    _connectivity.onConnectivityChanged.listen((results) {
      // Handle both ConnectivityResult or List<ConnectivityResult> (depends on plugin version)
      _controller.add(
        results.contains(ConnectivityResult.mobile) ||
            results.contains(ConnectivityResult.wifi),
      );
    });
  }

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
  }

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;
}
