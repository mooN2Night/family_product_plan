import '../../../domain/entity/user_entity.dart';

/// Интерфейс удаленного статуса авторизации
abstract interface class IAuthRemoteDataSource {
  /// Метод регистрации.
  Future<UserEntity> signUp({required String email, required String password});

  /// Метод авторизации.
  Future<UserEntity> signIn({required String email, required String password});

  /// Метод выхода.
  Future<void> signOut();

  /// Метод удаления.
  Future<void> delete({required String password});

  /// Получения текущего пользователя.
  UserEntity? get currentUser;

  /// Поток изменений авторизации.
  Stream<UserEntity?> authStateChanges();
}
