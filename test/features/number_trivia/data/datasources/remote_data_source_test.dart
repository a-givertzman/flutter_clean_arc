import 'dart:convert';

import 'package:clean_arcitecture/core/error/exceptions.dart';
import 'package:clean_arcitecture/features/number_trivia/data/datasources/remote_data_source.dart';
import 'package:clean_arcitecture/features/number_trivia/data/models/model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';


class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  setUpHttpClient(String response, int ctatusCode) {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
      .thenAnswer((_) async => http.Response(response, ctatusCode));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1.0;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_int.json')));

    test(
      '''должен выполнить GET запрос на URL c конкретным
      числом на конце и с хедером aplication/json''',
      () async {
        // arrange
        setUpHttpClient(fixture('trivia_int.json'), 200);

        // act
        dataSource.getConcreteNumberTrivia(tNumber);
    
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$tNumber',
          headers: {
            'Content-Type': 'application/json'
          },
        ));
      },
    );

    test(
      'должен вернуть NymberTrivia при условии что код ответа 200 (успешно)',
      () async {
        // arrange
        setUpHttpClient(fixture('trivia_int.json'), 200);
    
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
    
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      '''должен вернуть [ServerExeption] при условии что
      статус ответа не равен 200 и равен например 404''',
      () async {
        // arrange
        setUpHttpClient('Server Exception', 404);

        // act
        final call = dataSource.getConcreteNumberTrivia;
    
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_int.json')));

    test(
      '''должен выполнить GET запрос на URL c `random`
      на конце и с хедером aplication/json''',
      () async {
        // arrange
        setUpHttpClient(fixture('trivia_int.json'), 200);

        // act
        dataSource.getRandomNumberTrivia();
    
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {
            'Content-Type': 'application/json'
          },
        ));
      },
    );

    test(
      'должен вернуть NymberTrivia при условии что код ответа 200 (успешно)',
      () async {
        // arrange
        setUpHttpClient(fixture('trivia_int.json'), 200);
    
        // act
        final result = await dataSource.getRandomNumberTrivia();
    
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      '''должен вернуть [ServerExeption] при условии что
      статус ответа не равен 200 и равен например 404''',
      () async {
        // arrange
        setUpHttpClient('Server Exception', 404);

        // act
        final call = dataSource.getRandomNumberTrivia;
    
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

}