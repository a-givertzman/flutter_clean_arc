import 'package:clean_arcitecture/features/number_trivia/data/models/model.dart';

abstract class NumberTriviaLocalDataSource {

  /// Возвращает NumberTriviaModel полученный последним
  /// из удаленного источника
  /// 
  /// Вызовет ошибку [CacheException] если в кэше ничего нет
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheLastNumberTrivia(NumberTriviaModel numberTriviaToCache);
}