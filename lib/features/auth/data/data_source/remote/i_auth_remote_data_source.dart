import '../../../domain/entity/auth_user_entity.dart';

/// Интерфейс удаленного статуса авторизации
abstract interface class IAuthRemoteDataSource {
  /// Метод регистрации.
  Future<void> signUp({required String email, required String password});

  /// Метод авторизации.
  Future<void> signIn({required String email, required String password});

  /// Метод выхода.
  Future<void> signOut();

  /// Метод удаления.
  Future<void> delete({required String password});

  /// Получения текущего пользователя.
  AuthUserEntity? get currentUser;

  /// Поток изменений авторизации.
  Stream<AuthUserEntity?> authStateChanges();
}
