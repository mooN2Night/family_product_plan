part of 'family_delete_bloc.dart';

/// Базовое состояние.
sealed class FamilyDeleteState extends Equatable {
  const FamilyDeleteState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyDeleteInitialState extends FamilyDeleteState {
  const FamilyDeleteInitialState();
}

/// Состояние загрузки.
final class FamilyDeleteLoadingState extends FamilyDeleteState {
  const FamilyDeleteLoadingState();
}

/// Состояния успешного получения информации.
final class FamilyDeleteSuccessState extends FamilyDeleteState {
  const FamilyDeleteSuccessState();
}

/// Состояние ошибки
final class FamilyDeleteErrorState extends FamilyDeleteState {
  const FamilyDeleteErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
