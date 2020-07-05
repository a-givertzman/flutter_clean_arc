part of 'number_trivia_bloc.dart';


abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}


class NumberTriviaInitial extends NumberTriviaState {
  @override
  List<Object> get props => [];
}


class Loading extends NumberTriviaState {
  final String loadingMessage;

  Loading({@required this.loadingMessage});

  @override
  // TODO: проверить это
  List<Object> get props => [loadingMessage];
}


class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({@required this.numberTrivia});

  @override
  // TODO: проверить это
  List<Object> get props => [numberTrivia];
}


class Error extends NumberTriviaState {
  final String errorMessage;

  Error({@required this.errorMessage});

  @override
  // TODO: проверить это
  List<Object> get props => [errorMessage];
}