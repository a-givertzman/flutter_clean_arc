import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]) : super();

  List<Object> get properties => <dynamic>[];
}


// General Failures
class ServerFailure extends Failure {
  final dynamic message;

  ServerFailure(this.message);

  @override
  List<Object> get props => [message];
}


class CacheFailure extends Failure {
  final dynamic message;

  CacheFailure(this.message);

  @override
  List<Object> get props => [message];
}