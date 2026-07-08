part of 'auth_bloc.dart';

/// Базовое состояние авторизации.
final class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// НАчальное стостояние
final class AuthInitialState extends AuthState {
  const AuthInitialState();
}

/// Состояние проверки авторизации.
final class AuthCheckingState extends AuthState {
  const AuthCheckingState();
}

/// Состояние загрузки авторизации.
final class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

/// Пользователь не авторизован.
final class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}

/// Пользователь авторизован.
final class AuthAuthenticatedState extends AuthState {
  const AuthAuthenticatedState({required this.user});

  /// Текущий пользователь.
  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Ошибка авторизации.
final class AuthErrorState extends AuthState {
  const AuthErrorState({required this.message});

  /// Текст ошибки.
  final String message;

  @override
  List<Object?> get props => [message];
}
