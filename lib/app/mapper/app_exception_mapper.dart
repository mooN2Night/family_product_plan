import 'dart:async';
import 'dart:io';
import '../error/app_exception.dart';

abstract final class AppExceptionMapper {
  static AppException fromException(Object error) {
    if (error is SocketException) {
      return const AppNetworkException();
    }

    if (error is TimeoutException) {
      return const AppNetworkException();
    }

    return const AppUnknownException();
  }
}
