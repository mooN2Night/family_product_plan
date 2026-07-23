part of 'family_bloc.dart';

/// Класс базового события.
sealed class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object?> get props => [];
}

/// Начать отслеживание семьи.
final class FamilyWatchEvent extends FamilyEvent {
  const FamilyWatchEvent({required this.familyId});

  /// Уникальный идентификтор семьи.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}

/// Остановить отслеживание семьи.
final class FamilyStopWatchEvent extends FamilyEvent {
  const FamilyStopWatchEvent();
}

/// Внутреннее событие обновления семьи.
final class FamilyUpdateEvent extends FamilyEvent {
  const FamilyUpdateEvent({required this.family});

  /// Сущность семьи.
  final FamilyEntity family;

  @override
  List<Object?> get props => [family];
}

/// Внутреннее событие ошибки прослушивания.
final class FamilyWatchErrorEvent extends FamilyEvent {
  const FamilyWatchErrorEvent({required this.error});

  /// Ошибка
  final AppException error;

  @override
  List<Object?> get props => [error];
}
