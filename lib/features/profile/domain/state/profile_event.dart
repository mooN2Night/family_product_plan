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
