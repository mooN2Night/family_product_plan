import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entity/user_entity.dart';

/// Расширение для преобразования FirebaseUser в UserEntity
extension FirebaseUserMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      id: uid,
      email: email ?? '',
    );
  }
}