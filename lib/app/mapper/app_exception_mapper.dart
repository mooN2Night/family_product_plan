import 'dart:async';
import 'dart:io';
import '../error/app_exception.dart';

/// Маппер основных ошибок приложения.
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
