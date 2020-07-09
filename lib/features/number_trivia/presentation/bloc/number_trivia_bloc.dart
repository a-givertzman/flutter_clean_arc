import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trtivia.dart';
import '../../domain/usecases/usecases.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Ошибка доступа к серверу';
const String CACHE_FAILURE_MESSAGE = 'Ошибка доступа к кэшу';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Ошибка ввода - допускается число больше 0';
const String INIT_STATE_MESSAGE = 'Привет! \nначинай...';
const String LOADING_STATE_MESSAGE = 'Подождите, загрузка...';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  // Usecases
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  // проверка и преобразование значений из UI
  final InputConverter inputConverter;

  /// Конструктор
  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Initial(message: INIT_STATE_MESSAGE));

  @override
  // NumberTriviaState get initialState => Initial(message: INIT_STATE_MESSAGE);

  /// Возвращает State в зависимости от пришедшего event
  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // если UI запросил GetTriviaForConcreteNumber
    if (event is GetTriviaForConcreteNumber) {
      // проверяем и конвертируем значение из UI
      // Either < Failure or double >
      final number = inputConverter.stringToUInt(event.numberString);

      yield* number.fold(

          // если пришло Failure от inputConverter.stringToDouble
          (failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      },

          // если пришло double от inputConverter.stringToDouble
          (intleValue) async* {
        // делаем стейт Loading пока идет загрузка
        yield Loading(message: LOADING_STATE_MESSAGE);

        // Запрос на сервер
        // Either < Failure or NumberTrivia >
        final usecaseResult =
            await getConcreteNumberTrivia(Params(number: intleValue));

        // возвращаем стейт
        yield* _eitherLoadedOrErrorState(usecaseResult);
      });
    }

    // если UI запросил GetTriviaForRandomNumber
    if (event is GetTriviaForRandomNumber) {
      // делаем стейт Loading пока идет загрузка
      yield Loading(message: LOADING_STATE_MESSAGE);

      // Запрос на сервер
      // Either < Failure or NumberTrivia >
      final usecaseResult = await getRandomNumberTrivia(NoParams());

      // возвращаем стейт
      yield* _eitherLoadedOrErrorState(usecaseResult);
    }
  }

  // вернет стейт Stream<NumberTriviaState> в зависимости Failure или NumberTrivia пришло с сервера
  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrNumberTrivia) async* {
    yield failureOrNumberTrivia.fold(
        // если сервер вернул ошибку
        (failure) => Error(message: _mapFailureToMessage(failure)),

        // если сервер вернул данные
        (numberTrivia) => Loaded(numberTrivia: numberTrivia));
  }

  /// Метод вернет текстовое сообщение, соответствующее типу ошибки
  /// Если сообщений много, лучше использовать Sealed Unions
  /// это поможет не запутаться
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return SERVER_FAILURE_MESSAGE;
    if (failure is CacheFailure) return CACHE_FAILURE_MESSAGE;

    // если нет такого типа ошибки
    return "Неизвестный тип ошибки: + ${failure.runtimeType}";
  }
}
