import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poweriot/core/config/web_socket_config.dart';
import 'package:poweriot/features/user/dashboard/domain/model/dashboar_model.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:async';

/// A class that acts as a central communication bus for real-time WebSocket messages.
///
/// It uses a [StreamController] to broadcast parsed [LiveBatchData] objects
/// received from the STOMP server to any listening UI components.
///
/// Author: Sagar Choudhary
class SocketMessageBus {
  static final StreamController<DashboardModel> _controller =
      StreamController<DashboardModel>.broadcast();

  /// A public stream to subscribe to real-time batch data updates.
  static Stream<DashboardModel> get stream => _controller.stream;

  /// Parses the raw JSON [message] string and adds the resulting [LiveBatchData] object to the stream.
  static void addMessage(String message) {
    log("add message");
    DashboardModel data = DashboardModel.fromJson(jsonDecode(message));
    _controller.add(data);
  }
}

/// The global STOMP client instance.
StompClient? stompClient;

/// Establishes a connection to the STOMP WebSocket server.
///
/// It configures the [StompClient] with the server URL, authentication headers
/// (using the provided [token]), and sets up callbacks for connection status and
/// incoming messages. It subscribes to the /user/gtamb/sensor topic.
void connectStomp(String token) {
  if (stompClient != null && stompClient!.connected) {
    log('STOMP client already connected');
    return;
  }

  // Deactivate any existing client configuration safely
  disconnectStomp();

  final String url = WebSocketConfig.webSocketBaseUrl;
  stompClient = StompClient(
    config: StompConfig.sockJS(
      url: url,
      stompConnectHeaders: {'Authorization': 'Bearer $token'},
      webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      onConnect: (StompFrame frame) {
        log('Connected to STOMP');

        stompClient!.subscribe(
          destination: '/user/queue/dashboard',
          callback: (StompFrame message) {
            log("Incoming data: ${message.body}");
            if (message.body != null) {
              // Pass message to your UI state
              SocketMessageBus.addMessage(message.body!);
            } else {
              log("this is the the body if null ${message.command}");
            }
          },
        );
      },
      onWebSocketError: (dynamic error) {
        log('WebSocket error: $error');
      },
      onStompError: (StompFrame frame) {
        log(
          'STOMP error: ${frame.body} \n ${frame.headers} \n ${frame.command} \n ${frame.hashCode}',
        );
      },
      onDisconnect: (StompFrame frame) {
        log('Disconnected');
      },
      heartbeatIncoming: Duration(milliseconds: 0),
      heartbeatOutgoing: Duration(milliseconds: 20000), // 20s
    ),
  );

  stompClient!.activate();
}

/// Deactivates and disconnects the STOMP WebSocket client if it is currently connected.
void disconnectStomp() {
  if (stompClient != null && stompClient!.connected) {
    stompClient!.deactivate();
    debugPrint("STOMP client deactivated");
  }
  stompClient = null;
}
