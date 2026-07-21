part of 'family_bloc.dart';

/// Базовое состояние.
sealed class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyInitialState extends FamilyState {
  const FamilyInitialState();
}

/// Состояние загрузки.
final class FamilyLoadingState extends FamilyState {
  const FamilyLoadingState();
}

/// Состояния успешного получения информации.
final class FamilyLoadedState extends FamilyState {
  const FamilyLoadedState({required this.family, required this.members});

  /// Сущность семьи.
  final FamilyEntity family;

  /// Сущность участников семьи.
  final List<FamilyMemberInfoEntity> members;

  @override
  List<Object?> get props => [family, members];
}

/// Состояния создании семьи.
final class FamilyCreatingState extends FamilyState {
  const FamilyCreatingState();
}

/// Состояния успешно созданной семьи.
final class FamilyCreatedState extends FamilyState {
  const FamilyCreatedState({required this.familyId});

  /// Уникальный идентификаторв семьи.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}

/// Состояние ошибки
final class FamilyErrorState extends FamilyState {
  const FamilyErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
