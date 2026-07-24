import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entity/family_entity.dart';
import 'family_member_dto.dart';

/// DTO семьи пользователя.
final class FamilyDto {
  const FamilyDto({
    required this.name,
    required this.members,
    required this.createdAt,
    required this.joinCode,
  });

  /// Фабричный конструктор для преобразования серверной модели в [FamilyDto]
  factory FamilyDto.fromJson(Map<String, dynamic> json) {
    return FamilyDto(
      name: json['name'] as String,
      members: (json['members'] as List)
          .map((e) => FamilyMemberDto.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      joinCode: json['joinCode'] as String,
    );
  }

  /// Название семьи
  final String name;

  /// Список участников
  final List<FamilyMemberDto> members;

  /// Дата создания
  final DateTime createdAt;

  /// Код для вступления в семью.
  final String joinCode;

  /// Метод для преобразования DTO в сущность.
  FamilyEntity toEntity(String id) {
    return FamilyEntity(
      id: id,
      name: name,
      members: members.map((e) => e.toEntity()).toList(),
      createdAt: createdAt,
      joinCode: joinCode,
    );
  }

  /// Фабричный конструктор для преобразования [FamilyDto] в серверную модель
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'members': members.map((e) => e.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'joinCode': joinCode,
    };
  }
}
