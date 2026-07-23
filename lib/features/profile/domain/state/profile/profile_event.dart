part of 'profile_bloc.dart';

/// Класс базового события.
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Событие потокового просмотра профиля
final class ProfileWatchEvent extends ProfileEvent {
  const ProfileWatchEvent();
}

/// Остановить отслеживание профиля.
final class ProfileStopWatchEvent extends ProfileEvent {
  const ProfileStopWatchEvent();
}

/// Внутреннее событие обновления профиля.
final class ProfileUpdateEvent extends ProfileEvent {
  const ProfileUpdateEvent({required this.user});

  /// Пользователь.
  final ProfileUserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Внутреннее событие ошибки.
final class ProfileWatchErrorEvent extends ProfileEvent {
  const ProfileWatchErrorEvent({required this.error});

  /// Ошибка.
  final AppException error;

  @override
  List<Object?> get props => [error];
}

/// Событие выбора аватара
// TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
// final class ProfileAvatarChangedEvent extends ProfileEvent {
//   const ProfileAvatarChangedEvent({required this.file});
//
//   final File file;
//
//   @override
//   List<Object?> get props => [file];
// }
