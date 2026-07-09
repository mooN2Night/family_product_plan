import 'package:equatable/equatable.dart';

/// Базовый класс для исключений приложения.
abstract class AppException extends Equatable implements Exception {
  const AppException(this.message);

  /// Сообщение для пользователя.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Ошибки сети
final class AppNetworkException extends AppException {
  const AppNetworkException() : super('Проверьте подключение к интернету');
}

/// Неизвестная ошибка
final class AppUnknownException extends AppException {
  const AppUnknownException() : super('Произошла неизвестная ошибка');
}
