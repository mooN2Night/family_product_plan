import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/mapper/app_exception_mapper.dart';
import '../../domain/entity/auth_exception.dart';

/// Маппер ошибок авторизации
abstract final class AuthExceptionMapper {
  static AppException fromException(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'invalid-credential':
          return const AuthUserNotFoundException();

        case 'wrong-password':
          return const AuthWrongPasswordException();

        case 'email-already-in-use':
          return const AuthEmailAlreadyInUseException();

        case 'weak-password':
          return const AuthWeakPasswordException();

        case 'network-request-failed':
          return const AppNetworkException();

        default:
          return const AppUnknownException();
      }
    }

    return AppExceptionMapper.fromException(error);
  }
}
