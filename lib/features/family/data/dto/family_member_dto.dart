import 'package:family_product_plan/features/family/domain/entity/family_relation.dart';

import '../../domain/entity/family_member_entity.dart';
import '../../domain/entity/family_role.dart';

/// DTO участника в семье.
final class FamilyMemberDto {
  const FamilyMemberDto({
    required this.userId,
    required this.role,
    required this.relation,
  });

  /// Фабричный конструктор для преобразования серверной модели в [FamilyMemberDto]
  factory FamilyMemberDto.fromJson(Map<String, dynamic> json) {
    return FamilyMemberDto(
      userId: json['userId'] as String,
      role: json['role'] as String,
      relation:
          json['relation'] as String? ?? FamilyRelation.undefined.toString(),
    );
  }

  /// Id пользователя.
  final String userId;

  /// Роль в семье.
  final String role;

  /// Стутас в семье.
  final String? relation;

  /// Метод для преобразования DTO в сущность.
  FamilyMemberEntity toEntity() {
    return FamilyMemberEntity(
      userId: userId,
      role: FamilyRole.fromString(role),
      relation: relation != null
          ? FamilyRelation.fromString(relation!)
          : FamilyRelation.undefined,
    );
  }

  /// Фабричный конструктор для преобразования [FamilyMemberDto] в серверную модель
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'role': role, 'relation': relation};
  }
}
