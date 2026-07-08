import 'package:family_product_plan/features/auth/data/data_source/remote/i_auth_remote_data_source.dart';
import 'package:family_product_plan/features/auth/domain/entity/user_entity.dart';
import 'package:family_product_plan/features/auth/domain/repository/i_auth_repository.dart';

/// Репозиторий для работы с авторизацией
final class AuthRepository implements IAuthRepository {
  const AuthRepository({required IAuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  /// УДаленный статус авторизации
  final IAuthRemoteDataSource _remoteDataSource;

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) => _remoteDataSource.signUp(email: email, password: password);

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) => _remoteDataSource.signIn(email: email, password: password);

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<void> deleteAccount({required String password}) =>
      _remoteDataSource.delete(password: password);

  @override
  UserEntity? get currentUser => _remoteDataSource.currentUser;

  @override
  Stream<UserEntity?> authStateChanges() =>
      _remoteDataSource.authStateChanges();
}
