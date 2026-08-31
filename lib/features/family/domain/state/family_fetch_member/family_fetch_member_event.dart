part of 'family_fetch_member_bloc.dart';

/// Класс базового события.
sealed class FamilyFetchMemberEvent extends Equatable {
  const FamilyFetchMemberEvent();

  @override
  List<Object?> get props => [];
}

/// Событие загрузки информации об участнике семьи.
final class FamilyFetchMemberLoadEvent extends FamilyFetchMemberEvent {
  const FamilyFetchMemberLoadEvent({required this.familyId});

  /// Id пользователя.
  final String familyId;

  @override
  List<Object?> get props => [familyId];
}
