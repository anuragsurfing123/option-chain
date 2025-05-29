// lib/utils/service_locator.dart
import 'package:get_it/get_it.dart';

import '../../option_trading/data/datasources/option_chain_remote_data_source.dart';
import '../../option_trading/data/repositories/option_data_repository.dart';
import '../../option_trading/domain/repositories/i_option_repository.dart';
import '../../option_trading/domain/usecases/get_option_chain_usecase.dart';
import '../../option_trading/presentation/viewmodels/option_chain_viewmodel.dart';
import '../api/api_service.dart';
import '../api/dio_client.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {
  // dio client
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // register repository
  sl.registerLazySingleton<OptionChainRepository>(
    () => OptionChainRepositoryImpl(sl()),
  );

  // register datasource
  sl.registerLazySingleton<OptionChainRemoteDataSource>(
        () => OptionChainRemoteDataSourceImpl(sl()),
  );

  // api service
  sl.registerLazySingleton(() => ApiService(sl<DioClient>()));

  // register use case
  sl.registerLazySingleton(() => GetOptionChainUseCase(sl()));

  sl.registerFactory(() => OptionChainViewModel(sl()));
}
