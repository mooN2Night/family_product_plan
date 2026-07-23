part of 'profile_load_bloc.dart';

/// Базовое состояние.
sealed class ProfileLoadState extends Equatable {
  const ProfileLoadState();

  @override
  List<Object?> get props => [];
}

/// Начальное стостояние
final class ProfileLoadInitialState extends ProfileLoadState {
  const ProfileLoadInitialState();
}

/// Состояние загрузки.
final class ProfileLoadLoadingState extends ProfileLoadState {
  const ProfileLoadLoadingState();
}

/// Общий класс для состояний успешной загрузки и обновления
final class ProfileLoadSuccessState extends ProfileLoadState {
  const ProfileLoadSuccessState({required this.user});

  /// Текущий пользователь.
  final ProfileUserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Ошибка получения профиля.
final class ProfileLoadErrorState extends ProfileLoadState {
  const ProfileLoadErrorState({required this.message});

  /// Текст ошибки.
  final String message;

  @override
  List<Object?> get props => [message];
}
