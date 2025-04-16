// import 'package:blog_app/core/theme/app_pallete.dart';
// (Commented out) This would import color or style palette if needed for theming

// Importing Cubit for user authentication state management
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';

// Importing the global app theme
import 'package:blog_app/core/theme/theme.dart';

// Importing the Bloc that handles authentication logic
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';

// Importing the login page UI
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';

// Importing the main blog page UI
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';

// Importing the dependency initializer function
import 'package:blog_app/init_dependencies.dart';

// Importing Flutter material design components
import 'package:flutter/material.dart';

// Importing Flutter Bloc utilities (for using BlocProvider, BlocSelector, etc.)
import 'package:flutter_bloc/flutter_bloc.dart';

// Importing the Bloc that handles blog-related logic
import 'features/blog/presentation/bloc/blog_bloc.dart';

void main() async {
  // Ensures Flutter bindings are initialized before executing further
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes dependency injection (likely using GetIt or similar service locator)
  await initDependencies();

  // Starts the app and provides multiple Blocs to the widget tree
  runApp(MultiBlocProvider(
    providers: [
      // Providing AppUserCubit (for auth/user state)
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      // Providing AuthBloc (for login/signup logic)
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      // Providing BlogBloc (for blog-related actions)
      BlocProvider(
        create: (_) => serviceLocator<BlogBloc>(),
      ),
    ],
    // Setting the root widget of the app
    child: const MyApp(),
  ));
}

// Root widget of the app
class MyApp extends StatefulWidget {
  const MyApp({super.key}); // Constructor with optional key

  @override
  State<MyApp> createState() => _MyAppState(); // Creating mutable state
}

// State class for the MyApp widget
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // When the app starts, check if user is already logged in
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides debug banner in release mode
      title: 'Blog App', // Title of the app
      theme: AppTheme.darkThemeMode, // Applies dark theme to the app
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        // Selects whether the user is logged in
        selector: (state) {
          return state is AppUserLoggedIn; // True if user is logged in
        },
        // Builds UI based on login state
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage(); // Show blog page if user is logged in
          }
          return const LoginPage(); // Otherwise, show login page
        },
      ),
    );
  }
}
