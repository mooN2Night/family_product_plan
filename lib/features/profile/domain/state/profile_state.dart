part of 'profile_bloc.dart';

/// Базовое состояние.
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Начальное стостояние
final class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

/// Состояние загрузки.
final class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

/// Общий класс для состояний успешной загрузки и обновления
abstract class ProfileLoadedState extends ProfileState {
  const ProfileLoadedState({required this.user});

  /// Текущий пользователь.
  final ProfileUserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Пользователь получен успешно.
final class ProfileSuccessState extends ProfileLoadedState {
  const ProfileSuccessState({required super.user});
}

/// Состояние обновления пользователя
final class ProfileSavingState extends ProfileLoadedState {
  const ProfileSavingState({required super.user});
}

/// Ошибка получения профиля.
final class ProfileErrorState extends ProfileState {
  const ProfileErrorState({required this.message});

  /// Текст ошибки.
  final String message;

  @override
  List<Object?> get props => [message];
}
