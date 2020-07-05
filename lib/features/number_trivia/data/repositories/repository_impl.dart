import 'package:clean_arcitecture/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomSelector();   // тип для вызова одного из двух методлв

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource, 
    @required this.localDataSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(double number) async {
    return await _getNumberTriviaFromLocal(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getNumberTriviaFromLocal(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTriviaFromLocal(
    _ConcreteOrRandomSelector getConcreteOrRandom           // вызов одного из двух методов
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();   // вызов одного из двух методов
        localDataSource.cacheLastNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure('Ошибка подключения к серверу'));
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure('Ошибка чтения из Кэш'));
      }
    }
  }
}