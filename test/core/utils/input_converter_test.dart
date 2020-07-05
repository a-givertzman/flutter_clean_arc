import 'package:clean_arcitecture/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUInt', () {
    test(
      'должен вернуть Integer при условии что строка содержит положительное целое',
      () async {
        // arrange
        final str = '123';

        // act
        final result = inputConverter.stringToUInt(str);

        // assert
        expect(result, Right(123));
      },
    );

    test(
      'должен вернуть InvalidInputFailure при условии что строка не содержит целое',
      () async {
        // arrange
        final str = 'asd';

        // act
        final result = inputConverter.stringToUInt(str);

        // assert
        expect(result, Left(InvalidInputFailure(message: 'Подходит только положительное целое, строка не содержит целое.')));
      },
    );

    test(
      'должен вернуть InvalidInputFailure при условии что строка содержит отрицательное целое',
      () async {
        // arrange
        final str = '-123';

        // act
        final result = inputConverter.stringToUInt(str);

        // assert
        expect(result, Left(InvalidInputFailure(message: 'Подходит только положительное целое, строка содержит отрицательное целое.')));
      },
    );
  });


  group('stringToInt', () {
    test(
      'должен вернуть Integer при условии что строка содержит целое',
      () async {
        // arrange
        final str = '123';

        // act
        final result = inputConverter.stringToInt(str);

        // assert
        expect(result, Right(123));
      },
    );

    test(
      'должен вернуть Integer при условии что строка содержит отрицательное целое',
      () async {
        // arrange
        final str = '-123';

        // act
        final result = inputConverter.stringToInt(str);

        // assert
        expect(result, Right(-123));
      },
    );

    test(
      'должен вернуть InvalidInputFailure при условии что строка не содержит целое',
      () async {
        // arrange
        final str = 'asd';

        // act
        final result = inputConverter.stringToInt(str);

        // assert
        expect(result, Left(InvalidInputFailure(message: 'Подходит только положительное целое, строка не содержит целое.')));
      },
    );
  });


  group('stringToDouble', () {
    test(
      'должен вернуть double при условии что строка содержит double',
      () async {
        // arrange
        final str = '-123.1';

        // act
        final result = inputConverter.stringToDouble(str);

        // assert
        expect(result, Right(-123.1));
      },
    );

    test(
      'должен вернуть InvalidInputFailure при условии что строка не содержит double',
      () async {
        // arrange
        final str = 'asd';

        // act
        final result = inputConverter.stringToDouble(str);

        // assert
        expect(result, Left(InvalidInputFailure(message: 'Подходит только положительное целое, строка не содержит целое.')));
      },
    );
  });
}