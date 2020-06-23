import 'dart:convert';

import 'package:clean_arcitecture/features/number_trivia/data/models/model.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

main() {
  print('number_trivia_model_test:main');
  final tNumberTriviaModel = NumberTriviaModel(number: 81, text: 'Test text');
  final tDNumberTriviaModel = NumberTriviaModel(number: 4.52, text: 'Test Trivia 4.52');
  print('number_trivia_model_test:main');


  test(
    'должен получить сабкласс NumberTrivia',
    () async {
    // arrange
  
    // act
  
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );


  group('fromJson', () {

    test(
      'должен вернуть валидный NumberTriviaModel от числа типа int',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_int.json'));
        
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'должен вернуть валидный NumberTriviaModel от числа типа double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
        
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        
        // assert
        expect(result, tDNumberTriviaModel);
      },
    );
  });


  group('toJson', () {
    test(
      'должен получить валидные данные в формате JSON когда число int',
      () async {
        // arrange
      
        // act
        final result = tNumberTriviaModel.toJson();

        // assert
        final expectedJson = {
          "text": "Test text",
          "number": 81,
        };
        expect(result, expectedJson);
      },
    );

    test(
      'должен получить валидные данные в формате JSON когда число double',
      () async {
        // arrange
      
        // act
        final result = tDNumberTriviaModel.toJson();

        // assert
        final expectedJson = {
          "text": "Test Trivia 4.52",
          "number": 4.52,
        };
        expect(result, expectedJson);
      },
    );
  });
}