import 'dart:convert';

import 'package:clean_arcitecture/core/error/exceptions.dart';
import 'package:clean_arcitecture/features/number_trivia/data/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class NumberTriviaLocalDataSource {

  /// Возвращает NumberTriviaModel полученный последним
  /// из удаленного источника
  /// 
  /// Вызовет ошибку [CacheException] если в кэше ничего нет
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Сохраняет последний NumberTriviaModel в кэш
  /// 
  Future<void> cacheLastNumberTrivia(NumberTriviaModel numberTriviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({
    @required this.sharedPreferences
  });

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return Future.value(NumberTriviaModel.fromJson(jsonMap));
    } else {
      throw CacheException('В кэше нет LastNumberTrivia');
    }
  }

  @override
  Future<void> cacheLastNumberTrivia(NumberTriviaModel numberTriviaToCache) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(numberTriviaToCache.toJson())
    );
  }

}