import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/data/dto/family_member_dto.dart';
import 'package:family_product_plan/features/family/domain/entity/family_relation.dart';

import 'family_role.dart';

/// Сущность участника в семье.
final class FamilyMemberEntity extends Equatable {
  const FamilyMemberEntity({
    required this.userId,
    required this.role,
    required this.relation,
  });

  /// Id пользователя.
  final String userId;

  /// Роль в семье.
  final FamilyRole role;

  /// Статус в семье.
  final FamilyRelation relation;

  /// Метод для преобразования DTO в сущность.
  FamilyMemberDto toDto() {
    return FamilyMemberDto(
      userId: userId,
      role: role.toString(),
      relation: relation.toString(),
    );
  }

  @override
  List<Object?> get props => [userId, role, relation];
}
