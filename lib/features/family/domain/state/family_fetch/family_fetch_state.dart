part of 'family_fetch_bloc.dart';

/// Базовое состояние.
sealed class FamilyFetchState extends Equatable {
  const FamilyFetchState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyFetchInitialState extends FamilyFetchState {
  const FamilyFetchInitialState();
}

/// Состояние загрузки.
final class FamilyFetchLoadingState extends FamilyFetchState {
  const FamilyFetchLoadingState();
}

/// Состояния успешного получения информации.
final class FamilyFetchSuccessState extends FamilyFetchState {
  const FamilyFetchSuccessState({required this.family});

  /// Уникальный идентификаторв семьи.
  final FamilyEntity family;

  @override
  List<Object?> get props => [family];
}

/// Состояние ошибки
final class FamilyFetchErrorState extends FamilyFetchState {
  const FamilyFetchErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
