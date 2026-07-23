part of 'family_join_bloc.dart';

/// Базовое состояние.
sealed class FamilyJoinState extends Equatable {
  const FamilyJoinState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyJoinInitialState extends FamilyJoinState {
  const FamilyJoinInitialState();
}

/// Состояние загрузки.
final class FamilyJoinLoadingState extends FamilyJoinState {
  const FamilyJoinLoadingState();
}

/// Состояние успешного присоединения к семье.
final class FamilyJoinSuccessState extends FamilyJoinState {
  const FamilyJoinSuccessState();
}

/// Состояние ошибки
final class FamilyJoinErrorState extends FamilyJoinState {
  const FamilyJoinErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
