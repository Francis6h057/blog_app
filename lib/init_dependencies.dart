// Importing the Cubit that manages the app user's state (e.g., logged in or not)
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/cubits/connection_cubit/connection_cubit_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';

// Importing secret credentials (like Supabase keys and URLs)
import 'package:blog_app/core/secrets/app_secrets.dart';

// Auth feature imports - data layer
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';

// Auth feature imports - domain layer
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';

// Auth feature imports - presentation layer (Bloc)
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';

// Blog feature imports - data layer
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_impl.dart';

// Blog feature imports - domain layer
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';

// Dependency injection package (service locator)
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';

// Supabase package for backend operations
import 'package:supabase_flutter/supabase_flutter.dart';

// Blog feature imports - domain & presentation layer
import 'features/blog/domain/usecases/upload_blog.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';

part 'init_dependencies.main.dart';
