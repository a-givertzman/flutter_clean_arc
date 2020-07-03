import 'dart:convert';

import 'package:clean_arcitecture/core/error/exceptions.dart';
import 'package:clean_arcitecture/features/number_trivia/data/datasources/local_data_source.dart';
import 'package:clean_arcitecture/features/number_trivia/data/models/model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';


class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences :mockSharedPreferences
    );
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'должен вернуть NumberTrivia из SharedPreferences если в кэш есть последний NumberTrivia',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

        // act
        final result = await dataSource.getLastNumberTrivia();

        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'должен вернуть CacheExeption если в кэш нет последний NumberTrivia',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
          .thenReturn(null);

        // act
        final call = dataSource.getLastNumberTrivia;

        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });


  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: "Test text", number: 81);
    test(
      'должен вызвать SharedPreferences для сохранения последнего NumberTrivia в кэш',
      () async {
        // arrange
    
        // act
        dataSource.cacheLastNumberTrivia(tNumberTriviaModel);

        // assert
        final expectJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA,
          expectJsonString
        ));
      },
    );
  });
}