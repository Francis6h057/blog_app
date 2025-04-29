import 'package:blog_app/core/common/widgets/loader.dart'; // Custom loader widget
import 'package:blog_app/core/theme/app_pallete.dart'; // Color palette for the app
import 'package:blog_app/core/utils/show_snackbar.dart'; // Utility function to show snackbar messages
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart'; // Bloc for managing authentication state
import 'package:blog_app/features/auth/presentation/pages/login_page.dart'; // Login page
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart'; // Custom text field widget for authentication
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart'; // Custom gradient button widget for authentication
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart'; // Flutter Material package
import 'package:flutter_bloc/flutter_bloc.dart'; // Flutter Bloc package for state management

// SignupPage widget for creating a new user account
class SignupPage extends StatefulWidget {
  // Route method for navigation to the LoginPage
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  // Constructor for SignupPage
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers for the name, email, and password text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // GlobalKey for form validation
  final formKey = GlobalKey<FormState>();

  // Dispose method to clean up controllers
  @override
  void dispose() {
    nameController.dispose();
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
                  // Title: Sign Up
                  const Center(
                      child: Text(
                    "Sign Up.",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  )),
                  // Custom name text field
                  AuthField(
                    hintText: "Name",
                    controller: nameController,
                  ),
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
                  // Custom gradient sign-up button
                  AuthGradientButton(
                    text: "Sign Up",
                    onPressed: () {
                      // Validate form before proceeding
                      if (formKey.currentState!.validate()) {
                        // Dispatch AuthSignUp event with the provided name, email, and password
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                  ),
                  // Gesture to navigate to the Login page if the user already has an account
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        SignupPage.route(),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: const [
                          TextSpan(
                            text: "Sign In",
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
