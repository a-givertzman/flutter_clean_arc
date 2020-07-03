import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}


/// Данный класс только перенаправляет вызов isConnected
/// в сторонний модуль, и нужен только для того что бы 
/// изолировать сторонний модуль, в случае его замены
/// интерфейс останется прежним
class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  static Future<bool> result = Future.value(true);
  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}