import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;

  // A stream to notify when internet connection status changes.
  Stream<bool> get onConnectionChange;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;

  // Constructor
  ConnectionCheckerImpl(this.internetConnection);

  // Getter that returns the current connection status (true if online)
  @override
  Future<bool> get isConnected async {
    try {
      return await internetConnection.hasInternetAccess
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      return false;
    }
  }

  // Stream that emits `true` when online and `false` when offline
  @override
  Stream<bool> get onConnectionChange => internetConnection.onStatusChange.map(
        (status) => status == InternetStatus.connected,
      );
}
