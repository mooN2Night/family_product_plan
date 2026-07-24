import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/features/auth/data/mapper/auth_firebase_user_mapper.dart';
import 'package:family_product_plan/features/auth/domain/entity/auth_user_entity.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../app/services/family/i_current_family_provider.dart';
import 'i_auth_remote_data_source.dart';

/// Реализация удаленного статуса авторизации
final class AuthRemoteDataSource implements IAuthRemoteDataSource {
  const AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required ICurrentFamilyProvider currentFamilyProvider,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _currentFamilyProvider = currentFamilyProvider;

  /// Сервис авторизации
  final FirebaseAuth _firebaseAuth;

  final FirebaseFirestore _firestore;

  final ICurrentFamilyProvider _currentFamilyProvider;

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _currentFamilyProvider.clearCurrentFamilyId();
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) throw ProfileNotFoundException();

    final snapshot = await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .get();

    final familyId = snapshot.data()?['familyId'] as String?;

    if (familyId == null) {
      await _currentFamilyProvider.clearCurrentFamilyId();
    } else {
      await _currentFamilyProvider.setCurrentFamilyId(familyId);
    }
  }

  @override
  Future<void> signOut() async {
    await _currentFamilyProvider.clearCurrentFamilyId();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> delete({required String password}) async {
    await _currentFamilyProvider.clearCurrentFamilyId();
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
