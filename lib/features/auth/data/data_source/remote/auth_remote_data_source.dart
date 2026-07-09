import 'package:family_product_plan/features/auth/data/mapper/auth_firebase_user_mapper.dart';
import 'package:family_product_plan/features/auth/domain/entity/auth_user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'i_auth_remote_data_source.dart';

/// Реализация удаленного статуса авторизации
final class AuthRemoteDataSource implements IAuthRemoteDataSource {
  const AuthRemoteDataSource({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async => await _firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async => await _firebaseAuth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

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
  AuthUserEntity? get currentUser => _firebaseAuth.currentUser?.toEntity();

  @override
  Stream<AuthUserEntity?> authStateChanges() =>
      _firebaseAuth.authStateChanges().map((user) => user?.toEntity());
}
