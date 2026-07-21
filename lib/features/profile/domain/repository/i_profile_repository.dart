import '../entity/profile_user_entity.dart';

/// Интерфейс репозитория профиля
abstract interface class IProfileRepository {
  /// Получение профиля
  Future<ProfileUserEntity> getProfile();

  /// Сохранение профиля
  Future<void> saveProfile(ProfileUserEntity user);

  /// Метод для отслеживания состояния профиля.
  Stream<ProfileUserEntity> watchProfile();

  /// Получить пользователя по id.
  Future<ProfileUserEntity> getProfileById({required String userId});

  /// Загрузка аватара пользователя
  // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
  // Future<void> uploadAvatar(File file);
}
