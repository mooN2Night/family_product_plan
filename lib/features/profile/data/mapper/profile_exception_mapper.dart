import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../app/error/app_exception.dart';
import '../../../../app/mapper/app_exception_mapper.dart';
import '../../domain/entity/profile_exception.dart';

/// Маппер ошибок профиля.
abstract final class ProfileExceptionMapper {
  /// Преобразует исключение в исключение приложения.
  static AppException fromException(Object error) {
    switch (error) {
      case AppException():
        return error;

      case FirebaseException(
      plugin: 'cloud_firestore',
      code: 'permission-denied',
      ):
        return const ProfilePermissionDeniedException();

      case FirebaseException(
      plugin: 'cloud_firestore',
      code: 'unavailable',
      ):
        return const AppNetworkException();

      default:
        return AppExceptionMapper.fromException(error);
    }
  }
}