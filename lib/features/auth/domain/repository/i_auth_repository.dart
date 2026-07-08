import 'package:family_product_plan/features/auth/domain/entity/user_entity.dart';

/// Интерфейс репозитория авторизации
abstract interface class IAuthRepository {
  /// Метод регистрации.
  Future<UserEntity> signUp({required String email, required String password});

  /// Метод авторизации.
  Future<UserEntity> signIn({required String email, required String password});

  /// Метод выхода.
  Future<void> signOut();

  /// Удаляет аккаунт пользователя.
  Future<void> deleteAccount({required String password});

  /// Получения текущего пользователя.
  UserEntity? get currentUser;

  /// Поток изменений авторизации.
  Stream<UserEntity?> authStateChanges();
}
