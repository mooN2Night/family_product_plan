import '../../../../app/error/app_exception.dart';

/// Пользователь не найден
final class AuthUserNotFoundException extends AppException {
  const AuthUserNotFoundException() : super('Пользователь с таким email не найден');
}

/// Неверный пароль
final class AuthWrongPasswordException extends AppException {
  const AuthWrongPasswordException() : super('Неверный пароль');
}

/// Такой email уже существует
final class AuthEmailAlreadyInUseException extends AppException {
  const AuthEmailAlreadyInUseException()
    : super('Пользователь с таким email уже существует');
}

/// Пароль слишком простой
final class AuthWeakPasswordException extends AppException {
  const AuthWeakPasswordException() : super('Пароль слишком простой');
}
