import 'package:clean_arcitecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/repositories/repository.dart';
import 'package:clean_arcitecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
  implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final double tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: "test number", number: 1);

  test(
    'должен получить trivia для числа из repository',
    () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
      .thenAnswer((_) async => Right(tNumberTrivia));
  
    // act
    final result = await usecase(Params(number: tNumber));
  
    // assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}