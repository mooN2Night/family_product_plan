part of 'family_fetch_member_bloc.dart';

/// Базовое состояние.
sealed class FamilyFetchMemberState extends Equatable {
  const FamilyFetchMemberState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyFetchMemberInitialState extends FamilyFetchMemberState {
  const FamilyFetchMemberInitialState();
}

/// Состояние загрузки.
final class FamilyFetchMemberLoadingState extends FamilyFetchMemberState {
  const FamilyFetchMemberLoadingState();
}

/// Состояния успешного получения информации.
final class FamilyFetchMemberLoadedState extends FamilyFetchMemberState {
  const FamilyFetchMemberLoadedState({
    required this.members,
  });

  final List<FamilyMemberInfoEntity> members;

  @override
  List<Object?> get props => [members];
}

/// Состояние ошибки
final class FamilyFetchMemberErrorState extends FamilyFetchMemberState {
  const FamilyFetchMemberErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
