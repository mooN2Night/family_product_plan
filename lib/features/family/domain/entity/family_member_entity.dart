import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/data/dto/family_member_dto.dart';

/// Роль участника семьи.
enum FamilyRole {
  /// Создатель семьи.
  owner,

  /// Обычный участник.
  member;

  @override
  String toString() {
    return switch (this) {
      FamilyRole.owner => 'owner',
      FamilyRole.member => 'member',
    };
  }

  static FamilyRole fromString(String value) {
    return switch (value) {
      'owner' => FamilyRole.owner,
      'member' => FamilyRole.member,
      _ => FamilyRole.member,
    };
  }
}

/// Сущность участника в семье.
final class FamilyMemberEntity extends Equatable {
  const FamilyMemberEntity({required this.userId, required this.role});

  /// Id пользователя.
  final String userId;

  /// Роль в семье.
  final FamilyRole role;

  FamilyMemberDto toDto() {
    return FamilyMemberDto(
      userId: userId,
      role: role.toString(),
    );
  }

  @override
  List<Object?> get props => [userId, role];
}
