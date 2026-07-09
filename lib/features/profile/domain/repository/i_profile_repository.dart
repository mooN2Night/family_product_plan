import '../entity/profile_user_entity.dart';

/// Интерфейс репозитория профиля
abstract interface class IProfileRepository {
  /// Получение профиля
  Future<ProfileUserEntity> getProfile();

  /// Сохранение профиля
  Future<void> saveProfile(ProfileUserEntity user);

  Stream<ProfileUserEntity> watchProfile();
}
