import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/number_trivia/data/datasources/local_data_source.dart';
import 'features/number_trivia/data/datasources/remote_data_source.dart';
import 'features/number_trivia/data/repositories/repository_impl.dart';
import 'features/number_trivia/domain/repositories/repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trtivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';

// dependency injection
// регистрируем здесь все зависимости в порядке стека вызова:
// widget -> presentation -> usecases -> entities -> repositories -> DataModel -> DataSources

// Service Locator
final sl = GetIt.instance;

// эта функция будет вызвана в main.dart
Future<void> init() async {
  
  //! /////////////////////////////////////////////////////
  //! Features - Number Trivia
  
  //* Bloc
  // Начнем с Bloc, он ближайший к уровню widget
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(), 
      random: sl(), 
      inputConverter: sl()
    )
  );

  //* Use cases
  // registerLazySingleton - будет работать по мере необходимости, когда соответствующая зависимость активирована
  // Зависимости данных usecases GetConcreteNumberTrivia и GetRandomNumberTrivia определяются только контрактом
  // между Domain и Repository, который описан абстрактным классом NumberTriviaRepository
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //* Repository
  // Это контракт   : NumberTriviaRepository     - lean_arcitecture/features/number_trivia/domain/repositories/repository.dart
  // Это реализация : NumberTriviaRepositoryImpl - clean_arcitecture/features/number_trivia/data/repositories/repository_impl.dart
  // Любой представитель Repository должен строго соответствовать контракту NumberTriviaRepository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(), 
      localDataSource: sl(), 
      networkInfo: sl()
    )
  );
  
  //* Data sources
  // NumberTrivia Local Data Source
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl()
    )
  );

  // NumberTrivia Remote Data Source
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      httpClient: sl()
    )
  );


  //! Core

  //* Input Converter
  sl.registerLazySingleton(() => InputConverter());

  //* Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl())
  );

  //! External

  //* Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance(); 
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());


  //! /////////////////////////////////////////////////////
  //! Features - New feature
  //! Core
  //! External

}