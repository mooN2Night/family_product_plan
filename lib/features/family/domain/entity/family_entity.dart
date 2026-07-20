import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/family/data/dto/family_dto.dart';
import 'package:family_product_plan/features/family/domain/entity/family_member_entity.dart';

/// Сущность семьи пользователя.
final class FamilyEntity extends Equatable {
  const FamilyEntity({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
  });

  /// Id семьи
  final String id;

  /// Название семьи
  final String name;

  /// Список участников
  final List<FamilyMemberEntity> members;

  /// Дата создания
  final DateTime createdAt;

  FamilyDto toDto() {
    return FamilyDto(
      name: name,
      members: members.map((e) => e.toDto()).toList(),
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, members, createdAt];
}
