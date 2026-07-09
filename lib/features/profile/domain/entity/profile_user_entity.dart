import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/profile/data/dto/profile_user_dto.dart';

/// Перечисление гендеров
enum Gender {
  /// Мужской
  male,

  /// Женский
  female,

  /// Не выбран
  unspecified;

  /// Текстовая метка для отображения на экране
  String get title => switch (this) {
    Gender.unspecified => 'Не указан',
    Gender.male => 'Мужской',
    Gender.female => 'Женский',
  };

  /// Отправка на сервер
  String get value {
    return switch (this) {
      Gender.male => 'male',
      Gender.female => 'female',
      Gender.unspecified => 'unspecified',
    };
  }

  /// Принимаем с сервера
  static Gender fromValue(String genderStr) {
    return switch (genderStr) {
      'male' => Gender.male,
      'female' => Gender.female,
      'unspecified' => Gender.unspecified,
      _ => Gender.unspecified,
    };
  }
}

/// Сущность профиля пользователя.
final class ProfileUserEntity extends Equatable {
  const ProfileUserEntity({
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

  /// Конструктор пустого профиля при создании пользователя
  factory ProfileUserEntity.empty({
    required String id,
    required String email,
  }) {
    return ProfileUserEntity(
      id: id,
      email: email,
      firstName: '',
      lastName: '',
      middleName: '',
      gender: Gender.unspecified,
      birthDate: null,
      avatarUrl: null,
      familyId: null,
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
  final Gender gender;

  /// Дата рождения.
  final DateTime? birthDate;

  /// Ссылка на аватар.
  final String? avatarUrl;

  /// Идентификатор семьи.
  final String? familyId;

  /// Метод для преобразования Entity в DTO
  ProfileUserDto toDto() => ProfileUserDto(
    id: id,
    email: email,
    firstName: firstName,
    lastName: lastName,
    middleName: middleName,
    gender: gender.value,
    birthDate: birthDate,
    avatarUrl: avatarUrl,
    familyId: familyId,
  );

  /// Метод для частичного обновления полей
  ProfileUserEntity copyWith({
    String? firstName,
    String? lastName,
    String? middleName,
    Gender? gender,
    DateTime? birthDate,
    String? avatarUrl,
    String? familyId,
  }) {
    return ProfileUserEntity(
      id: id,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      familyId: familyId ?? this.familyId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    middleName,
    gender,
    birthDate,
    avatarUrl,
    familyId,
  ];
}
