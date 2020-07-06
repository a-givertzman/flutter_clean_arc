import 'package:clean_arcitecture/core/error/exceptions.dart';
import 'package:clean_arcitecture/core/error/failures.dart';
import 'package:clean_arcitecture/core/network/network_info.dart';
import 'package:clean_arcitecture/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:clean_arcitecture/features/number_trivia/data/datasources/remote_data_source.dart';
import 'package:clean_arcitecture/features/number_trivia/data/models/model.dart';
import 'package:clean_arcitecture/features/number_trivia/data/repositories/repository_impl.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
  implements NumberTriviaRemoteDataSource {

}

class MockLocalDataSource extends Mock
  implements NumberTriviaLocalDataSource {

}

class MockNetworkInfo extends Mock
  implements NetworkInfo {

}


main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }


  group('getConcreteNumberTrivia', () {
    final int tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: "Test Number Trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'должен проверить что устройство онлайн, есть интерент соединение',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        // проверим что mockNetworkInfo.isConnected - вызван
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {

      test(
        'должен вернуть данные с удаленного сервера если подключение успешное',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'должен сохранить данные с удаленного сервера в кэш если подключение успешное',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheLastNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'должен вернуть server failure если подключение не успешное',
        () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException(message: ''));

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure('Ошибка подключения к серверу'))));
        },
      );

    });

    runTestsOffline(() {

      test(
        'должен вернуть данные из кэша когда в кэше они есть',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
        
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'должен вернуть CacheFailur когда в кэше пусто',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException(message: ''));

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
        
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure('Ошибка чтения из Кэш'))));
        },
      );
    });

  });


  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 123, text: "Test Number Trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test(
      'должен проверить что устройство онлайн, есть интерент соединение',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getRandomNumberTrivia();
        // assert
        // проверим что mockNetworkInfo.isConnected - вызван
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {

      test(
        'должен вернуть данные с удаленного сервера если подключение успешное',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'должен сохранить данные с удаленного сервера в кэш если подключение успешное',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheLastNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'должен вернуть server failure если подключение не успешное',
        () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException(message: ''));

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure('Ошибка подключения к серверу'))));
        },
      );

    });

    runTestsOffline(() {

      test(
        'должен вернуть данные из кэша когда в кэше они есть',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getRandomNumberTrivia();
        
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'должен вернуть CacheFailur когда в кэше пусто',
        () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException(message: ''));

          // act
          final result = await repository.getRandomNumberTrivia();
        
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure('Ошибка чтения из Кэш'))));
        },
      );
    });

  });
}