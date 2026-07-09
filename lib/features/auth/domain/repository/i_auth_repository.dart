import 'package:family_product_plan/features/auth/domain/entity/auth_user_entity.dart';

/// Интерфейс репозитория авторизации
abstract interface class IAuthRepository {
  /// Метод регистрации.
  Future<void> signUp({required String email, required String password});

  /// Метод авторизации.
  Future<void> signIn({required String email, required String password});

  /// Метод выхода.
  Future<void> signOut();

  /// Удаляет аккаунт пользователя.
  Future<void> deleteAccount({required String password});

  /// Получения текущего пользователя.
  AuthUserEntity? get currentUser;

  /// Поток изменений авторизации.
  Stream<AuthUserEntity?> authStateChanges();
}
