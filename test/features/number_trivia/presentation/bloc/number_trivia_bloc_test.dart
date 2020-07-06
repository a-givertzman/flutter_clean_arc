import 'package:clean_arcitecture/core/error/failures.dart';
import 'package:clean_arcitecture/core/utils/input_converter.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/usecases/get_random_number_trtivia.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/usecases/usecases.dart';
import 'package:clean_arcitecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';


class MockGetConcreteNumberTrivia extends Mock 
  implements GetConcreteNumberTrivia {}


class MockGetRandomNumberTrivia extends Mock 
  implements GetRandomNumberTrivia {}


class MockInputConverter extends Mock 
  implements InputConverter {}


void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia, 
      random: mockGetRandomNumberTrivia, 
      inputConverter: mockInputConverter
    );
  });

  test(
    'должен вернуть Inital',
    () async {
      // arrange
  
      // act
  
      // assert
      expect(bloc.state, emits(Initial(initMessage: INIT_STATE_MESSAGE)));
    },
  );

  group('getTriviaForConcreteNumber', () {
    final tNumberString = '81';     // пользователь ввел строку
    final tNumberParsed = 81.0;     // строка введенная пользователем после конвертации в double
    final tNumberTrivia = NumberTrivia(number: 81.0, text: 'Test text');

    // функция проверит что inputConverter успешно вернул верное значение
    void setUpMockInputConverterSuccess() => when(mockInputConverter.stringToDouble(any))
          .thenReturn(Right(tNumberParsed));


    test(
      'должен запустить InputConverter что бы проверить и преобразовать введенную строку',
      () async {
        // arrange
        // проверим что inputConverter отработал успешно
        setUpMockInputConverterSuccess();

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToDouble(any));

        // assert
        verify(mockInputConverter.stringToDouble(tNumberString));
      },
    );

    test(
      'должен вернуть ошибку при условии что введено недопустимое значение',
      () async {
        // arrange
        when(mockInputConverter.stringToDouble(any))
          .thenReturn(Left(InvalidInputFailure(message: 'Подходит только положительное целое, строка не содержит целое.')));
    
        // assert later - сначала объявим чего ожидаем
        // state последовательно переходит в состояния перечисленные в массиве expected
        final expected = [
          Initial(initMessage: INIT_STATE_MESSAGE),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE)
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act - затем запустим процесс
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        
      },
    );

    test(
      'должен вернуть данные из GetConcreteNumberTrivia usecase',
      () async {
        // arrange
        // проверим что inputConverter отработал успешно
        setUpMockInputConverterSuccess();
        // проверяем что GetConcreteNumberTrivia usecase успешно вернула tNumberTrivia
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    
        // act
        // генерим event GetTriviaForConcreteNumber
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        // ждем когда event GetTriviaForConcreteNumber отработает
        await untilCalled(mockGetConcreteNumberTrivia(any));
        
        // assert
        // смотрим что бы usecase GetConcreteNumberTrivia был вызван с тем же аргументом что мы получили от inputConverter
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));

      },
    );

    test(
      '''должен проверить что была последовательность стейтов emit [Initial, Loading, Loaded] 
      при условии что данные успешно получены''',
      () async {
        // arrange
        // проверим что inputConverter отработал успешно
        setUpMockInputConverterSuccess();
        // проверяем что GetConcreteNumberTrivia usecase успешно вернула tNumberTrivia
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    
        // assert later
        final expected = [
          Initial(initMessage: INIT_STATE_MESSAGE),
          Loading(message: LOADING_STATE_MESSAGE),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    
      },
    );

    test(
      '''должен проверить что была последовательность стейтов emit [Initial, Loading, Error] 
      при условии что данные не получены и получено сообщение SERVER_FAILURE_MESSAGE''',
      () async {
        // arrange
        // проверим что inputConverter отработал успешно
        setUpMockInputConverterSuccess();
        // проверяем что GetConcreteNumberTrivia usecase был неуспешен и вернул Failure
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure('')));
    
        // assert later
        final expected = [
          Initial(initMessage: INIT_STATE_MESSAGE),
          Loading(message: LOADING_STATE_MESSAGE),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      '''должен проверить что была последовательность стейтов emit [Initial, Loading, Error] 
      при условии что данные не получены и получено сообщение CACHE_FAILURE_MESSAGE''',
      () async {
        // arrange
        // проверим что inputConverter отработал успешно
        setUpMockInputConverterSuccess();
        // проверяем что GetConcreteNumberTrivia usecase был неуспешен и вернул Failure
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure('')));
    
        // assert later
        final expected = [
          Initial(initMessage: INIT_STATE_MESSAGE),
          Loading(message: LOADING_STATE_MESSAGE),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 81.0, text: 'Test text');

    test(
      'должен вернуть данные из GetRandomNumberTrivia usecase',
      () async {
        // arrange
        // проверяем что GetRandomNumberTrivia usecase успешно вернула tNumberTrivia
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    
        // act
        // генерим event GetTriviaForRandomNumber
        bloc.dispatch(GetTriviaForRandomNumber());
        // ждем когда event GetTriviaForRandomNumber отработает
        await untilCalled(mockGetRandomNumberTrivia(any));
        
        // assert
        // смотрим что бы usecase GetRandomNumberTrivia был вызван с NoParams
        verify(mockGetRandomNumberTrivia(NoParams()));

      },
    );

    test(
      '''должен проверить что была последовательность стейтов emit [Initial, Loading, Loaded] 
      при условии что данные успешно получены''',
      () async {
        // arrange
        // проверяем что GetRandomNumberTrivia usecase успешно вернула tNumberTrivia
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    
        // assert later
        final expected = [
          Initial(initMessage: INIT_STATE_MESSAGE),
          Loading(message: LOADING_STATE_MESSAGE),
          Loaded(numberTrivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      '''должен проверить что была последовательность стейтов emit [Initial, Loading, Error] 
      при условии что данные не получены и получено сообщение SERVER_FAILURE_MESSAGE''',
      () async {
        // arrange
        // проверяем что GetConcreteNumberTrivia usecase был неуспешен и вернул Failure
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure('')));
    
        // assert later
        final expected = [
          Initial(initMessage: INIT_STATE_MESSAGE),
          Loading(message: LOADING_STATE_MESSAGE),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      '''должен проверить что была последовательность стейтов emit [Initial, Loading, Error] 
      при условии что данные не получены и получено сообщение CACHE_FAILURE_MESSAGE''',
      () async {
        // arrange
        // проверяем что GetConcreteNumberTrivia usecase был неуспешен и вернул Failure
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure('')));
    
        // assert later
        final expected = [
          Initial(initMessage: INIT_STATE_MESSAGE),
          Loading(message: LOADING_STATE_MESSAGE),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));

        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });

}