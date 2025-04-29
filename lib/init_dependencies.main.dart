part of 'init_dependencies.dart';

// Creating a singleton instance of the GetIt service locator
final serviceLocator = GetIt.instance;

// Initializes and registers all the app dependencies
Future<void> initDependencies() async {
  // Initialize auth-related dependencies
  _initAuth();

  // Initialize blog-related dependencies
  _initBlog();

  // Initialize Supabase and await the instance
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl, // Supabase project URL
    anonKey: AppSecrets.supabaseAnonKey, // Supabase public anonymous key
    // debug: true,                      // Optional: enable debug mode
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  // Register the Supabase client as a singleton so it can be reused
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(
    () => InternetConnection(),
  );

  // Register the AppUserCubit (manages auth state across the app)
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<ConnectionCubit>(() => ConnectionCubit(
        serviceLocator(),
      ));
}

// Private method to register authentication-related dependencies
void _initAuth() {
  serviceLocator
    // Register the remote data source for auth (communicates with Supabase)
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(), // Injecting Supabase client
      ),
    )
    // Register the auth repository (connects use cases to data source)
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(), // Injecting AuthRemoteDataSource
        serviceLocator(),
      ),
    )
    // Register use case for signing up a user
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(), // Injecting AuthRepository
      ),
    )
    // Register use case for logging in a user
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    // Register use case for checking current logged-in user
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Register the AuthBloc (handles auth-related events & state)
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(), // Inject UserSignUp use case
        userLogin: serviceLocator(), // Inject UserLogin use case
        currentUser: serviceLocator(), // Inject CurrentUser use case
        appUserCubit: serviceLocator(), // Inject AppUserCubit
      ),
    );
}

// Private method to register blog-related dependencies
void _initBlog() {
  serviceLocator
    // Register the blog remote data source (for CRUD with Supabase)
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDatasourceImpl(
        supabaseClient: serviceLocator(), // Inject Supabase client
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Register the blog repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(), // Inject BlogRemoteDataSource
      ),
    )
    // Register the use case to upload a blog
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(), // Inject BlogRepository
      ),
    )
    // Register the use case to fetch all blogs
    ..registerFactory(() => GetAllBlogs(
          serviceLocator(), // Inject BlogRepository
        ))
    // Register the BlogBloc (handles blog-related state and logic)
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(), // Inject UploadBlog use case
        getAllBlogs: serviceLocator(), // Inject GetAllBlogs use case
      ),
    );
}
