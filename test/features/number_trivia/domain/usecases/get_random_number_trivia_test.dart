import 'package:clean_arcitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/usecases/get_random_number_trtivia.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(text: "test number", number: 1);

  test(
    'должен получить trivia из repository по рендому',
    () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
      .thenAnswer((_) async => Right(tNumberTrivia));
  
    // act
    final result = await usecase(NoParams());
  
    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}

class MockNumberTriviaRepository extends Mock
  implements NumberTriviaRepository {}