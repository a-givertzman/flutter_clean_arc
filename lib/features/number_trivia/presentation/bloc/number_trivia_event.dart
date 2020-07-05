/// Здесь классы событий, выполняющие исключительно передачу данных из UI в Bloc
/// Ни какой логики, ни каких преобразований данных тут быть не может
/// Для следования принципам SOLID, а именно 1 - Single Responsibility

part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}


class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;      // строковое предсталение числа введенного пользователем в UI

  GetTriviaForConcreteNumber(this.numberString);

  @override
  // TODO: Проверить что это правильно
  List<Object> get props => [numberString];

}


class GetTriviaForRandomNumber extends NumberTriviaEvent {

    @override
  // TODO: Проверить что это правильно
  List<Object> get props => this.props;
}