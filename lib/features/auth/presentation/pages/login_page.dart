import 'package:blog_app/core/common/widgets/loader.dart'; // Custom loading widget
import 'package:blog_app/core/theme/app_pallete.dart'; // Color palette for the app
import 'package:blog_app/core/utils/show_snackbar.dart'; // Utility to show snackbars
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart'; // Bloc for authentication states
import 'package:blog_app/features/auth/presentation/pages/signup_page.dart'; // Signup page
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart'; // Custom text field widget
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart'; // Custom gradient button widget
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart'; // Flutter Material package
import 'package:flutter_bloc/flutter_bloc.dart'; // Flutter Bloc package for state management

// LoginPage widget
class LoginPage extends StatefulWidget {
  // Route method for navigation to SignupPage
  static route() => MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );

  // Constructor for LoginPage
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for the email and password text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // GlobalKey for form validation
  final formKey = GlobalKey<FormState>();

  // Dispose method to clean up controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Build method for the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          // Listener for authentication state changes
          listener: (context, state) {
            if (state is AuthFailure) {
              // Show failure message in Snackbar if authentication fails
              showSnackBar(
                context,
                state.message,
              );
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
          },
          // Builder to display the widget based on the current authentication state
          builder: (context, state) {
            if (state is AuthLoading) {
              // Show loading indicator if authentication is in progress
              return const Loader();
            }

            return Form(
              key: formKey, // FormKey for validating form fields
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Title: Sign In
                  const Center(
                      child: Text(
                    "Sign In.",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  )),
                  // Custom email text field
                  AuthField(
                    hintText: "Email",
                    controller: emailController,
                  ),
                  // Custom password text field
                  AuthField(
                    hintText: "Password",
                    controller: passwordController,
                    obscureText: true, // Hide password input
                  ),
                  // Custom gradient sign-in button
                  AuthGradientButton(
                    text: "Sign In",
                    onPressed: () {
                      // Validate form before proceeding
                      if (formKey.currentState!.validate()) {
                        // Dispatch AuthLogin event with email and password
                        context.read<AuthBloc>().add(AuthLogin(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ));
                      }
                    },
                  ),
                  // Navigation to Sign Up page if the user doesn't have an account
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, LoginPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: const [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
