part of 'profile_update_bloc.dart';

/// Класс базового события.
sealed class ProfileUpdateEvent extends Equatable {
  const ProfileUpdateEvent();

  @override
  List<Object?> get props => [];
}

/// Событие обновления профиля
final class ProfileUpdateRequestedEvent extends ProfileUpdateEvent {
  const ProfileUpdateRequestedEvent({required this.user});

  /// Пользователь.
  final ProfileUserEntity user;

  @override
  List<Object?> get props => [user];
}
