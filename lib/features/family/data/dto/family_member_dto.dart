import '../../domain/entity/family_member_entity.dart';

/// DTO участника в семье.
final class FamilyMemberDto {
  const FamilyMemberDto({required this.userId, required this.role});

  factory FamilyMemberDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberDto(
      userId: json['userId'] as String,
      role: json['role'] as String,
    );
  }

  /// Id пользователя.
  final String userId;

  /// Роль в семье.
  final String role;

  FamilyMemberEntity toEntity() {
    return FamilyMemberEntity(
      userId: userId,
      role: FamilyRole.fromString(role),
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'role': role};
  }
}
