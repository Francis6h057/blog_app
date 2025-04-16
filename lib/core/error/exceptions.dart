// Defining a class named ServerException that implements the Exception interface.
// This class represents a specific type of error related to server issues.
class ServerException implements Exception {
  // Declaring a final variable `message` to store the error message.
  final String message;

  // Constructor for the ServerException class.
  // It takes a single parameter `message` that will be used to describe the error.
  const ServerException(this.message);
}
