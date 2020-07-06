part of 'number_trivia_bloc.dart';


abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}


class Initial extends NumberTriviaState {
  final String initMessage;

  Initial({@required this.initMessage});

  @override
  List<Object> get props => [initMessage];
}


class Loading extends NumberTriviaState {
  final String message;

  Loading({@required this.message});

  @override
  // TODO: проверить это
  List<Object> get props => [message];
}


class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({@required this.numberTrivia});

  @override
  // TODO: проверить это
  List<Object> get props => [numberTrivia];
}


class Error extends NumberTriviaState {
  final String message;

  Error({@required this.message});

  @override
  // TODO: проверить это
  List<Object> get props => [message];
}