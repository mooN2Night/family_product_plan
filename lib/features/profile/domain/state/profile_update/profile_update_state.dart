part of 'profile_update_bloc.dart';

/// Базовое состояние.
sealed class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object?> get props => [];
}

/// Начальное стостояние
final class ProfileUpdateInitialState extends ProfileUpdateState {
  const ProfileUpdateInitialState();
}

/// Состояние загрузки.
final class ProfileUpdateLoadingState extends ProfileUpdateState {
  const ProfileUpdateLoadingState();
}

/// Пользователь получен успешно.
final class ProfileUpdateSuccessState extends ProfileUpdateState {
  const ProfileUpdateSuccessState();
}

/// Ошибка получения профиля.
final class ProfileUpdateErrorState extends ProfileUpdateState {
  const ProfileUpdateErrorState({required this.message});

  /// Текст ошибки.
  final String message;

  @override
  List<Object?> get props => [message];
}
