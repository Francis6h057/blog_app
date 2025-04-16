// Defining a class named Failure to represent an error or failure in the application.
class Failure {
  // Declaring a final variable `message` to store the error message.
  // It has a default value that will be used if no message is provided.
  final String message;

  // Constructor for the Failure class.
  // If no message is provided, it will default to 'An unexpected error occurred. Please try again later.'
  Failure(
      [this.message = 'An unexpected error occurred. Please try again later.']);
}
