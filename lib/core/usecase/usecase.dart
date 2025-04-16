// Importing Failure class from core/error/failures.dart
import 'package:blog_app/core/error/failures.dart';
// Importing Either class from fpdart for functional error handling
import 'package:fpdart/fpdart.dart';

// Abstract UseCase class that defines a contract for all use cases in the app.
abstract interface class UseCase<SuccessType, Params> {
  // A method that should be implemented by any class that extends UseCase.
  // It takes a parameter of type Params and returns a Future of Either<Failure, SuccessType>
  Future<Either<Failure, SuccessType>> call(Params params);
}

// A class that is used when no parameters are required for a UseCase.
class NoParams {}
