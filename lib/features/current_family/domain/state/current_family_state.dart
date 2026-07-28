part of 'current_family_cubit.dart';

/// Класс базового состояния.
sealed class CurrentFamilyState extends Equatable {
  const CurrentFamilyState();

  @override
  List<Object?> get props => [];
}

/// Класс состояния загрузки.
final class CurrentFamilyLoadingState extends CurrentFamilyState {
  const CurrentFamilyLoadingState();
}

/// Класс состояния, когда у пользователя нет семьи.
final class CurrentFamilyWithoutFamilyState extends CurrentFamilyState {
  const CurrentFamilyWithoutFamilyState();
}

/// Класс состояния, когда у пользователя есть семьи.
final class CurrentFamilyWithFamilyState extends CurrentFamilyState {
  const CurrentFamilyWithFamilyState({
    required this.familyId,
  });

  /// Id семьи.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}

/// Класс состояния ошибки.
final class CurrentFamilyErrorState extends CurrentFamilyState {
  const CurrentFamilyErrorState();

  @override
  List<Object?> get props => [];
}