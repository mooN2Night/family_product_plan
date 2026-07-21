import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_exception.dart';
import 'package:family_product_plan/features/profile/domain/entity/profile_user_entity.dart';
import 'package:family_product_plan/features/profile/domain/repository/i_profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../dto/profile_user_dto.dart';
import '../mapper/profile_exception_mapper.dart';

/// Реализация репозитория для работы с профилем.
final class ProfileRepository implements IProfileRepository {
  const ProfileRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    // required FirebaseStorage storage,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  /// Сервис авторизации.
  final FirebaseAuth _firebaseAuth;

  /// Сервис удаленной бд.
  final FirebaseFirestore _firestore;

  // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
  // final FirebaseStorage _storage;

  @override
  Future<ProfileUserEntity> getProfile() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) throw AppUnknownException();

      final document = await _firestore.collection('users').doc(user.uid).get();

      if (!document.exists) return _createEmptyProfile(user);

      return ProfileUserDto.fromJson(document.data()!).toEntity();
    } on Object catch (error) {
      throw ProfileExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> saveProfile(ProfileUserEntity user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toDto().toJson(), SetOptions(merge: true));
    } on Object catch (error) {
      throw ProfileExceptionMapper.fromException(error);
    }
  }

  @override
  Stream<ProfileUserEntity> watchProfile() {
    final user = _firebaseAuth.currentUser;

    if (user == null) throw AppUnknownException();

    return _firestore.collection('users').doc(user.uid).snapshots().asyncMap((
      snapshot,
    ) async {
      try {
        if (!snapshot.exists) return _createEmptyProfile(user);

        return ProfileUserDto.fromJson(snapshot.data()!).toEntity();
      } on Object catch (error) {
        throw ProfileExceptionMapper.fromException(error);
      }
    });
  }

  @override
  Future<ProfileUserEntity> getProfileById({required String userId}) async {
    try {
      final document = await _firestore.collection('users').doc(userId).get();

      if (!document.exists) throw ProfileNotFoundException();
      return ProfileUserDto.fromJson(document.data()!).toEntity();
    } on Object catch (error) {
      throw ProfileExceptionMapper.fromException(error);
    }
  }

  /// Вспомогательный метод для создания пустого профиля.
  Future<ProfileUserEntity> _createEmptyProfile(User user) async {
    final profile = ProfileUserEntity.empty(id: user.uid, email: user.email!);

    await saveProfile(profile);

    return profile;
  }

  // TODO: нужен FirebaseStorage, за который нужно платить, пока отказываемся от этой темы
  // @override
  // Future<void> uploadAvatar(File file) async {
  //   try {
  //     final uid = _firebaseAuth.currentUser!.uid;
  //
  //     final ref = _storage.ref('avatars/$uid.jpg');
  //
  //     await ref.putFile(file);
  //
  //     final url = await ref.getDownloadURL();
  //
  //     await _firestore.collection('users').doc(uid).update({
  //       'avatarUrl': url,
  //     });
  //   } on Object catch (error) {
  //     throw ProfileExceptionMapper.fromException(error);
  //   }
  // }
}
