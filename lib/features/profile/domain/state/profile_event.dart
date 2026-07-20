part of 'profile_bloc.dart';

/// Класс базового события.
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Событие обновления профиля
final class ProfileUpdateEvent extends ProfileEvent {
  const ProfileUpdateEvent({required this.user});

  final ProfileUserEntity user;

  @override
  List<Object?> get props => [user];
}

/// Событие потокового просмотра профиля
final class ProfileWatchEvent extends ProfileEvent {
  const ProfileWatchEvent();
}

/// Событие получения профиля
final class ProfileGetEvent extends ProfileEvent {
  const ProfileGetEvent();
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
