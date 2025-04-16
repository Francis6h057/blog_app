// Importing necessary packages
import 'package:blog_app/core/common/entities/user.dart'; // Importing User entity
import 'package:flutter/material.dart'; // Importing Flutter Material package for UI components
import 'package:flutter_bloc/flutter_bloc.dart'; // Importing Flutter Bloc package for state management

// Part directive for AppUserState, separating state from the cubit logic
part 'app_user_state.dart';

// AppUserCubit class extends Cubit<AppUserState>, which manages the state of the user's authentication
class AppUserCubit extends Cubit<AppUserState> {
  // Constructor initializing the AppUserCubit with the initial state AppUserInitial
  AppUserCubit() : super(AppUserInitial());

  // Method to update the user's state based on whether the user is null or logged in
  void updateUser(User? user) {
    // If user is null, emit the initial state (user not logged in)
    if (user == null) {
      emit(AppUserInitial());
    } else {
      // If user is not null, emit the logged-in state with user details
      emit(AppUserLoggedIn(user));
    }
  }
}
