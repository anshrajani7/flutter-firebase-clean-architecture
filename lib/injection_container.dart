import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'core/constants/app_constants.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/tabs/data/datasources/tab_local_data_source.dart';
import 'features/tabs/data/datasources/tab_remote_data_source.dart';
import 'features/tabs/data/repositories/tab_repository_impl.dart';
import 'features/tabs/domain/repositories/tab_repository.dart';
import 'features/tabs/domain/usecases/get_tab_data_usecase.dart';
import 'features/tabs/presentation/bloc/tab_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Blocs
  sl.registerFactory(() => AuthBloc(
    signIn: sl<SignInUseCase>(),
    signUp: sl<SignUpUseCase>(),
    signOut: sl<SignOutUseCase>(),
    getAuthState: sl<GetAuthStateUseCase>(),
  ));
  sl.registerFactory(() => TabBloc(getTabData: sl<GetTabDataUseCase>()));

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetAuthStateUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetTabDataUseCase(sl<TabRepository>()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<TabRepository>(
        () => TabRepositoryImpl(
      remoteDataSource: sl<TabRemoteDataSource>(),
      localDataSource: sl<TabLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    ),
  );

  sl.registerLazySingleton<TabRemoteDataSource>(
        () => TabRemoteDataSourceImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<TabLocalDataSource>(
        () => TabLocalDataSourceImpl(sl<Box>()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  final box = await Hive.openBox(AppConstants.cacheBoxName);
  sl.registerLazySingleton(() => box);
}