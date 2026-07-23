part of 'family_remove_member_bloc.dart';

/// Базовое состояние.
sealed class FamilyRemoveMemberState extends Equatable {
  const FamilyRemoveMemberState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyRemoveMemberInitialState extends FamilyRemoveMemberState {
  const FamilyRemoveMemberInitialState();
}

/// Состояние загрузки.
final class FamilyRemoveMemberLoadingState extends FamilyRemoveMemberState {
  const FamilyRemoveMemberLoadingState();
}

/// Состояния успешного получения информации.
final class FamilyRemoveMemberSuccessState extends FamilyRemoveMemberState {
  const FamilyRemoveMemberSuccessState({required this.action});

  /// Тип удаления из семьи.
  final FamilyMemberAction action;

  @override
  List<Object?> get props => [action];
}

/// Состояние ошибки
final class FamilyRemoveMemberErrorState extends FamilyRemoveMemberState {
  const FamilyRemoveMemberErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
