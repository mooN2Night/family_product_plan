import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';

/// DTO профиля пользователя.
final class ProfileUserDto {
  const ProfileUserDto({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.gender,
    required this.birthDate,
    required this.avatarUrl,
    required this.familyId,
  });

  /// Создание DTO из данных Firestore.
  factory ProfileUserDto.fromJson(Map<String, dynamic> json) {
    return ProfileUserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String,
      gender: json['gender'] as String,
      birthDate: (json['birthDate'] as Timestamp?)?.toDate(),
      avatarUrl: json['avatarUrl'] as String?,
      familyId: json['familyId'] as String?,
    );
  }

  /// Идентификатор пользователя.
  final String id;

  /// Email пользователя.
  final String email;

  /// Имя.
  final String firstName;

  /// Фамилия.
  final String lastName;

  /// Отчество.
  final String middleName;

  /// Пол.
  final String gender;

  /// Дата рождения.
  final DateTime? birthDate;

  /// Ссылка на аватар.
  final String? avatarUrl;

  /// Идентификатор семьи.
  final String? familyId;

  /// Метод для преобразования DTO в Entity
  ProfileUserEntity toEntity() => ProfileUserEntity(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    middleName: middleName,
    gender: Gender.fromValue(gender),
    birthDate: birthDate,
    avatarUrl: avatarUrl,
    familyId: familyId,
  );

  /// Преобразование DTO в данные для Firestore.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'gender': gender,
      'birthDate': birthDate,
      'avatarUrl': avatarUrl,
      'familyId': familyId,
    };
  }
}
