import 'package:clean_arcitecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';


/// Класс - конвертир входных данных в форматы, подходящие для уровня Domain
/// Реализован в core так как не привязан к конкретной фиче, но должен
/// использоваться на уровне Presentation!


class InputConverter {

  /// Вернет int из строки, содержащей положительное целое
  /// 
  Either<Failure, int> stringToUInt(String value) {
    final uintValue = int.tryParse(value);
    String _message;

    if (uintValue == null) {
      _message = 'Подходит только положительное целое, строка не содержит целое.';
    } else if (uintValue < 0) {
      _message = 'Подходит только положительное целое, строка содержит отрицательное целое.';
    } else {
      return Right(uintValue);
    }

    return Left(InvalidInputFailure(message: _message));
  }


  /// Вернет int из строки, содержащей целое
  /// 
  Either<Failure, int> stringToInt(String value) {
    final intValue = int.tryParse(value);
    String _message;

    if (intValue == null) {
      _message = 'Подходит только положительное целое, строка не содержит целое.';
    } else {
      return Right(intValue);
    }

    return Left(InvalidInputFailure(message: _message));
  }


  /// Вернет double из строки, содержащей double
  /// 
  Either<Failure, double> stringToDouble(String value) {
    final doubleValue = double.tryParse(value);
    String _message;

    if (doubleValue == null) {
      _message = 'Подходит только положительное целое, строка не содержит целое.';
    } else {
      return Right(doubleValue);
    }

    return Left(InvalidInputFailure(message: _message));
  }
}


class InvalidInputFailure extends Failure {
  final String message;

  InvalidInputFailure({this.message = ''});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}