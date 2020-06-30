import '../models/model.dart';

abstract class NumberTriviaRemoteDataSource {

  /// Метод вызывает http://numbersapi.com/random/[number]?json
  /// 
  /// Сгененрирует [ServerExeption] при любой ошибке
  Future<NumberTriviaModel> getConcreteNumberTrivia(double number);

  /// Метод вызывает http://numbersapi.com/random/trivia?json
  /// 
  /// Сгененрирует [ServerExeption] при любой ошибке
  Future<NumberTriviaModel> getRandomNumberTrivia();
}