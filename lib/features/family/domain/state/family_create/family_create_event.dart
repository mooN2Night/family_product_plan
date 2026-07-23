part of 'family_create_bloc.dart';

/// Класс базового события создания семьи.
sealed class FamilyCreateEvent extends Equatable {
  const FamilyCreateEvent();

  @override
  List<Object?> get props => [];
}

/// Событие создания семьи.
final class FamilyCreateRequestedEvent extends FamilyCreateEvent {
  const FamilyCreateRequestedEvent({required this.name});

  /// Название семье.
  final String name;

  @override
  List<Object?> get props => [name];
}
