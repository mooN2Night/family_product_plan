import 'package:family_product_plan/features/auth/data/mapper/firebase_user_mapper.dart';
import 'package:family_product_plan/features/auth/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'i_auth_remote_data_source.dart';

/// Реализация удаленного статуса авторизации
final class AuthRemoteDataSource implements IAuthRemoteDataSource {
  const AuthRemoteDataSource({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Не удалось создать пользователя');
    }

    return user.toEntity();
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Не удалось найти такого пользователя');
    }

    return user.toEntity();
  }

  @override
  Future<void> signOut() async => await _firebaseAuth.signOut();

  @override
  Future<void> delete({required String password}) async {
    final user = _firebaseAuth.currentUser!;

    // TODO: когда добавится семья, токены и продукты, все чистить
    // final credential = EmailAuthProvider.credential(
    //   email: user.email!,
    //   password: password,
    // );
    //
    // await user.reauthenticateWithCredential(credential);

    // удалить профиль
    // await _firestore.collection('users').doc(user.uid).delete();

    // удалить приглашения
    // удалить настройки
    // удалить токены FCM
    // удалить файлы из Storage

    await user.delete();
  }

  @override
  UserEntity? get currentUser => _firebaseAuth.currentUser?.toEntity();

  @override
  Stream<UserEntity?> authStateChanges() =>
      _firebaseAuth.authStateChanges().map((user) => user?.toEntity());
}
