// This file defines the state that will be emitted by the ConnectionCubit.

// A simple class to represent the internet connection state.
class InternetConnectionState {
  // A boolean value indicating whether the device is connected to the internet.
  final bool isConnected;

  // Constructor to initialize the connection state.
  InternetConnectionState(this.isConnected);
}
