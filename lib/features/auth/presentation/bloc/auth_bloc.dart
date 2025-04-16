// Importing necessary packages and classes
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart'; // To manage app user state
import 'package:blog_app/core/usecase/usecase.dart'; // Base UseCase class
import 'package:blog_app/core/common/entities/user.dart'; // User entity class
import 'package:blog_app/features/auth/domain/usecases/current_user.dart'; // CurrentUser use case
import 'package:blog_app/features/auth/domain/usecases/user_login.dart'; // UserLogin use case
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart'; // UserSignUp use case
import 'package:flutter/material.dart'; // Flutter Material package for UI
import 'package:flutter_bloc/flutter_bloc.dart'; // BLoC package for state management

// Parts to separate event and state definitions
part 'auth_event.dart';
part 'auth_state.dart';

// AuthBloc class extends Bloc<AuthEvent, AuthState> to manage authentication-related events and states
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Dependencies: Use cases and the AppUserCubit for managing the user state
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  // Constructor to initialize the BLoC with dependencies
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    // Event handler for all events
    on<AuthEvent>((_, emit) => emit(AuthLoading())); // Default loading state
    // Specific event handlers for sign-up, login, and checking if the user is logged in
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  // Checks if the user is logged in
  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams()); // Fetch current user

    res.fold(
      // If the result is a failure, emit an AuthFailure state
      (fail) => emit(AuthFailure(fail.message)),
      // If successful, emit AuthSuccess and update the AppUserCubit
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // Handles user sign-up logic
  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(UserSignUpParams(
      email: event.email,
      name: event.name,
      password: event.password,
    ));

    res.fold(
      // If there's a failure, emit AuthFailure with the error message
      (failure) => emit(AuthFailure(failure.message)),
      // On success, emit AuthSuccess and update the AppUserCubit
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // Handles user login logic
  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogin(UserLoginParams(
      email: event.email,
      password: event.password,
    ));

    res.fold(
      // If login fails, emit AuthFailure with the error message
      (failure) => emit(AuthFailure(failure.message)),
      // If login is successful, emit AuthSuccess and update the AppUserCubit
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  // Helper method to emit AuthSuccess and update the AppUserCubit with user data
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user); // Update the user data in the AppUserCubit
    emit(AuthSuccess(user)); // Emit AuthSuccess with user data
  }
}
