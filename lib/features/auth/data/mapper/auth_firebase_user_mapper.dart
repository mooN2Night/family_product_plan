import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/auth_user_entity.dart';

/// Расширение для преобразования FirebaseUser в UserEntity
extension FirebaseUserMapper on User {
  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: uid,
      email: email ?? '',
    );
  }
}