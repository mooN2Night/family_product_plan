import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../app/error/app_exception.dart';
import '../../../../app/mapper/app_exception_mapper.dart';

/// Маппер ошибок задач.
abstract final class TasksExceptionMapper {
  static AppException fromException(Object error) {
    switch (error) {
      case AppException():
        return error;

      case FirebaseException(
        plugin: 'cloud_firestore',
        code: 'permission-denied',
      ):
        return const TasksPermissionDeniedException();

      case FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'):
        return const AppNetworkException();

      case FirebaseException(
        plugin: 'cloud_firestore',
        code: 'deadline-exceeded',
      ):
        return const AppNetworkException();

      case TimeoutException():
        return const AppNetworkException();

      default:
        return AppExceptionMapper.fromException(error);
    }
  }
}

/// Нет доступа к задачам семьи (например, вышли из семьи, поменялись правила).
final class TasksPermissionDeniedException extends AppException {
  const TasksPermissionDeniedException() : super('Нет доступа к задачам семьи');
}
