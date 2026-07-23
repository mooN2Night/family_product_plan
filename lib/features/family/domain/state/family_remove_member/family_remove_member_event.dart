part of 'family_remove_member_bloc.dart';

/// Класс базового события удаления семьи.
sealed class FamilyRemoveMemberEvent extends Equatable {
  const FamilyRemoveMemberEvent();

  @override
  List<Object?> get props => [];
}

/// Событие удаления самого себя из семьи.
final class FamilyRemoveMemberYourselfEvent extends FamilyRemoveMemberEvent {
  const FamilyRemoveMemberYourselfEvent({required this.familyId});

  /// Id семьи.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}

/// Событие удаления участника из семьи.
final class FamilyRemoveMemberOtherEvent extends FamilyRemoveMemberEvent {
  const FamilyRemoveMemberOtherEvent({required this.familyId, required this.userId});

  /// Id семьи.
  final String familyId;

  /// Id участника.
  final String userId;

  @override
  List<Object?> get props => [familyId, userId];
}
