part of 'family_fetch_bloc.dart';

/// Класс базового события создания семьи.
sealed class FamilyFetchEvent extends Equatable {
  const FamilyFetchEvent();

  @override
  List<Object?> get props => [];
}

/// Событие создания семьи.
final class FamilyFetchRequestedEvent extends FamilyFetchEvent {
  const FamilyFetchRequestedEvent({required this.familyId});

  /// Название семье.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}
