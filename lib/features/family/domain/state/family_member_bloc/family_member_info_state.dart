part of 'family_member_info_bloc.dart';

/// Базовое состояние.
sealed class FamilyMemberInfoState extends Equatable {
  const FamilyMemberInfoState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class FamilyMemberInfoInitialState extends FamilyMemberInfoState {
  const FamilyMemberInfoInitialState();
}

/// Состояние загрузки.
final class FamilyMemberInfoLoadingState extends FamilyMemberInfoState {
  const FamilyMemberInfoLoadingState();
}

/// Состояния успешного получения информации.
final class FamilyMemberInfoLoadedState extends FamilyMemberInfoState {
  const FamilyMemberInfoLoadedState({required this.profile, this.relation});

  /// Пользователь в семье.
  final ProfileUserEntity profile;

  /// Статус в семье.
  final FamilyRelation? relation;

  FamilyMemberInfoLoadedState copyWith({
    ProfileUserEntity? profile,
    FamilyRelation? relation,
  }) {
    return FamilyMemberInfoLoadedState(
      profile: profile ?? this.profile,
      relation: relation ?? this.relation,
    );
  }

  @override
  List<Object?> get props => [profile, relation];
}

/// Состояние ошибки
final class FamilyMemberInfoErrorState extends FamilyMemberInfoState {
  const FamilyMemberInfoErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
