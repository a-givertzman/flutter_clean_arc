part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class Initial extends NumberTriviaState {
  final String message;

  Initial({@required this.message});

  @override
  List<Object> get props => [message];
}

class Loading extends NumberTriviaState {
  final String message;

  Loading({@required this.message});

  @override
  List<Object> get props => [message];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({@required this.numberTrivia});

  @override
  List<Object> get props => [numberTrivia];
}

class Error extends NumberTriviaState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
