part of 'family_bloc.dart';

/// Класс базового события.
sealed class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object?> get props => [];
}

/// Событие обновления профиля
final class FamilyCreateEvent extends FamilyEvent {
  const FamilyCreateEvent({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}
