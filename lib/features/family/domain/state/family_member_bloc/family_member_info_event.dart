part of 'family_member_info_bloc.dart';

/// Класс базового события.
sealed class FamilyMemberInfoEvent extends Equatable {
  const FamilyMemberInfoEvent();

  @override
  List<Object?> get props => [];
}

/// Событие загрузки информации об участнике семьи.
final class FamilyMemberInfoLoadEvent extends FamilyMemberInfoEvent {
  const FamilyMemberInfoLoadEvent({required this.userId});

  /// Id пользователя.
  final String userId;

  @override
  List<Object?> get props => [userId];
}

/// Событие обновления статуса пользователя в семье.
final class FamilyMemberInfoUpdateRelationEvent extends FamilyMemberInfoEvent {
  const FamilyMemberInfoUpdateRelationEvent({
    required this.familyId,
    required this.userId,
    required this.relation,
  });

  /// Id семьи.
  final String familyId;

  /// Id пользователя.
  final String userId;

  /// Новый статус.
  final FamilyRelation relation;

  @override
  List<Object?> get props => [familyId, userId, relation];
}
