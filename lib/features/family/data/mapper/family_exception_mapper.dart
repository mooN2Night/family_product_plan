import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/features/family/domain/entity/family_exception.dart';

import '../../../../app/error/app_exception.dart';
import '../../../../app/mapper/app_exception_mapper.dart';

/// Маппер ошибок семьи.
abstract final class FamilyExceptionMapper {
  /// Преобразует исключение в исключение приложения.
  static AppException fromException(Object error) {
    switch (error) {
      case AppException():
        return error;

      case FirebaseException(
      plugin: 'cloud_firestore',
      code: 'permission-denied',
      ):
        return const FamilyPermissionDeniedException();

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