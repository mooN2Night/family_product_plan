part of 'family_create_bloc.dart';

/// Базовое состояние.
sealed class FamilyCreateState extends Equatable {
  const FamilyCreateState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyCreateInitialState extends FamilyCreateState {
  const FamilyCreateInitialState();
}

/// Состояние загрузки.
final class FamilyCreateLoadingState extends FamilyCreateState {
  const FamilyCreateLoadingState();
}

/// Состояния успешного получения информации.
final class FamilyCreateSuccessState extends FamilyCreateState {
  const FamilyCreateSuccessState({required this.familyId});

  /// Уникальный идентификаторв семьи.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}

/// Состояние ошибки
final class FamilyCreateErrorState extends FamilyCreateState {
  const FamilyCreateErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
