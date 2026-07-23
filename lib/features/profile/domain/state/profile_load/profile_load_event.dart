part of 'profile_load_bloc.dart';

/// Класс базового события.
sealed class ProfileLoadEvent extends Equatable {
  const ProfileLoadEvent();

  @override
  List<Object?> get props => [];
}

/// Событие получения профиля
final class ProfileLoadRequestEvent extends ProfileLoadEvent {
  const ProfileLoadRequestEvent();
}
