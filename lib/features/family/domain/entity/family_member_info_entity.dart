import 'package:equatable/equatable.dart';

import '../../../profile/domain/entity/profile_user_entity.dart';
import 'family_relation.dart';
import 'family_role.dart';

/// Сущность информации пользователя в семье.
final class FamilyMemberInfoEntity extends Equatable {
  const FamilyMemberInfoEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.gender,
    required this.role,
    required this.relation,
  });

  /// Id пользователя.
  final String userId;

  /// Имя.
  final String firstName;

  /// Фамилия.
  final String lastName;

  /// Отчество.
  final String middleName;

  /// Почта.
  final String email;

  /// Пол.
  final Gender gender;

  /// Роль в семье (owner/member).
  final FamilyRole role;

  /// Родственная связь.
  final FamilyRelation relation;

  /// Полное имя пользователя.
  String get fullName {
    return [
      lastName,
      firstName,
      middleName,
    ].where((e) => e.isNotEmpty).join(' ');
  }

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    middleName,
    email,
    gender,
    role,
    relation,
  ];
}
