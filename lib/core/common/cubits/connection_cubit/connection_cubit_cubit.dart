// Importing required packages and files.
import 'package:blog_app/core/common/cubits/connection_cubit/connection_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Flutter Bloc package for state management
import 'package:blog_app/core/network/connection_checker.dart'; // Custom internet connection checker interface // The state class defined separately

// A cubit that manages internet connection state.
class ConnectionCubit extends Cubit<InternetConnectionState> {
  final ConnectionChecker connectionChecker;

  ConnectionCubit(this.connectionChecker)
      : super(InternetConnectionState(true)) {
    // Emit initial status fast
    connectionChecker.isConnected.then((connected) {
      emit(InternetConnectionState(connected));
    });

    // Then listen to continuous updates
    connectionChecker.onConnectionChange.listen((connected) {
      emit(InternetConnectionState(connected));
    });
  }
}
