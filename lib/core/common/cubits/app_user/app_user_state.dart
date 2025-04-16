// Part directive for the AppUserCubit, indicating that this file contains the state for the AppUserCubit
part of 'app_user_cubit.dart';

// Declaring the AppUserState class as sealed, making it immutable and restricts subclassing to the file itself
@immutable
sealed class AppUserState {}

// State for when the user is not logged in, represents the initial state of the app
final class AppUserInitial extends AppUserState {}

// State for when the user is logged in, contains the user's data (User entity)
final class AppUserLoggedIn extends AppUserState {
  final User user; // Declaring the 'user' property to hold the user's details

  // Constructor to initialize the logged-in state with the user
  AppUserLoggedIn(this.user);
}
