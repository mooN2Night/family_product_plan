import '../../../profile/domain/entity/profile_user_entity.dart';
import '../../domain/entity/family_member_info_entity.dart';
import '../../domain/entity/family_relation.dart';
import '../../domain/entity/family_role.dart';

/// Сущность информации пользователя в семье.
final class FamilyMemberInfoDto {
  const FamilyMemberInfoDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.gender,
  });

  /// Фабричный конструктор для преобразования серверной модели в [FamilyMemberInfoDto]
  factory FamilyMemberInfoDto.fromJson(String id, Map<String, dynamic> json) {
    return FamilyMemberInfoDto(
      id: id,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      middleName: json['middleName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: Gender.fromValue(json['gender'] as String? ?? ''),
    );
  }

  /// Уникальный идентификатор
  final String id;

  /// Имя
  final String firstName;

  /// Фамилия
  final String lastName;

  /// Отчество
  final String middleName;

  /// Почта
  final String email;

  /// Пол
  final Gender gender;

  /// Метод для преобразования DTO в сущность.
  FamilyMemberInfoEntity toEntity({
    required FamilyRole role,
    required FamilyRelation relation,
    required bool canEditRelation,
    required bool isCurrentUser,
  }) {
    return FamilyMemberInfoEntity(
      userId: id,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      email: email,
      gender: gender,
      role: role,
      relation: relation,
      canEditRelation: canEditRelation,
      isCurrentUser: isCurrentUser,
    );
  }
}
