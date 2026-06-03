import 'package:get_it/get_it.dart';
import '../../data/datasources/local_database.dart';
import '../../domain/repositories/data_repository.dart';
import '../../data/repositories/data_repository_impl.dart';
import '../../presentation/dashboard/bloc/dashboard_bloc.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => DashboardBloc(dataRepository: sl()));
  sl.registerLazySingleton(() => AuthBloc());

  // Repositories
  sl.registerLazySingleton<DataRepository>(
    () => DataRepositoryImpl(localDatabase: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalDatabase>(() => LocalDatabase.instance);
}
