part of 'family_join_bloc.dart';

/// Класс базового события.
sealed class FamilyJoinEvent extends Equatable {
  const FamilyJoinEvent();

  @override
  List<Object?> get props => [];
}

/// Присоединиться к семье.
final class FamilyJoinRequestedEvent extends FamilyJoinEvent {
  const FamilyJoinRequestedEvent({required this.joinCode});

  /// Пригласительный код.
  final String joinCode;

  @override
  List<Object?> get props => [joinCode];
}
