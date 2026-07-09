import 'package:family_product_plan/features/auth/data/data_source/remote/i_auth_remote_data_source.dart';
import 'package:family_product_plan/features/auth/data/mapper/auth_exception_mapper.dart';
import 'package:family_product_plan/features/auth/domain/entity/auth_user_entity.dart';
import 'package:family_product_plan/features/auth/domain/repository/i_auth_repository.dart';

/// Репозиторий для работы с авторизацией
final class AuthRepository implements IAuthRepository {
  const AuthRepository({required IAuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  /// УДаленный статус авторизации
  final IAuthRemoteDataSource _remoteDataSource;

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signUp(email: email, password: password);
    } on Object catch (error) {
      throw AuthExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _remoteDataSource.signIn(email: email, password: password);
    } on Object catch (error) {
      throw AuthExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      return await _remoteDataSource.signOut();
    } on Object catch (error) {
      throw AuthExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    try {
      return _remoteDataSource.delete(password: password);
    } on Object catch (error) {
      throw AuthExceptionMapper.fromException(error);
    }
  }

  @override
  AuthUserEntity? get currentUser => _remoteDataSource.currentUser;

  @override
  Stream<AuthUserEntity?> authStateChanges() =>
      _remoteDataSource.authStateChanges();
}
