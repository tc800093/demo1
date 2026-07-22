import 'dart:convert';

import 'package:poweriot/core/config/web_socket_config.dart';
import 'package:poweriot/core/constants/secure_storage_constant.dart';
import 'package:poweriot/core/network/web_socket_client.dart';
import 'package:poweriot/core/secure_storage/secure_storage.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';

class DashboardWebSocketDatasource {
  final WebSocketClient client;
  final SecureStorageService storage;

  DashboardWebSocketDatasource({required this.client, required this.storage});

  Stream<DashboardModel> dashboardStream() async* {
    final token = await storage.read(storedToken);

    if (token == null || token.isEmpty) {
      throw Exception("JWT token missing");
    }

    yield* client.connect(WebSocketConfig.webSocketBaseUrl, token).map((data) {
      final json = jsonDecode(data);

      return DashboardModel.fromJson(json);
    });
  }
}
