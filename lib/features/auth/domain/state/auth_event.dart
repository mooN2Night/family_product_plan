part of 'auth_bloc.dart';

/// Класс базового события.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Запуск проверки состояния авторизации.
final class AuthStartedEvent extends AuthEvent {
  const AuthStartedEvent();
}

/// Событие регистрации
final class AuthSignUpEvent extends AuthEvent {
  const AuthSignUpEvent({required this.email, required this.password});

  /// Почта
  final String email;

  /// Пароль
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Событие авторизации
final class AuthSignInEvent extends AuthEvent {
  const AuthSignInEvent({required this.email, required this.password});

  /// Почта
  final String email;

  /// Пароль
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Событие выхода из профиля
final class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}

/// Событие удаления аккаунта
final class AuthDeleteAccountEvent extends AuthEvent {
  const AuthDeleteAccountEvent({required this.password});

  /// Пароль
  final String password;

  @override
  List<Object?> get props => [password];
}
