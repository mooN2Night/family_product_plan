part of 'family_delete_bloc.dart';

/// Класс базового события полного удаления семьи.
sealed class FamilyDeleteEvent extends Equatable {
  const FamilyDeleteEvent();

  @override
  List<Object?> get props => [];
}

/// Событие удаления семьи.
final class FamilyDeleteRequestedEvent extends FamilyDeleteEvent {
  const FamilyDeleteRequestedEvent({required this.familyId});

  /// Id семье.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}
