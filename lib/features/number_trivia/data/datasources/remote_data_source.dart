import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../core/error/exceptions.dart';
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


class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({
    @required this.client
  });


  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(double number) {
    return _getNumberTriviaFromUrl('http://numbersapi.com/$number');
  }


  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getNumberTriviaFromUrl('http://numbersapi.com/random');
  }


  Future<NumberTriviaModel> _getNumberTriviaFromUrl(String url) async {

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }

  }
}