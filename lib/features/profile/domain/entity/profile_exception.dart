import '../../../../app/error/app_exception.dart';

/// Нет доступа к профилю пользователя.
final class ProfilePermissionDeniedException extends AppException {
  const ProfilePermissionDeniedException()
    : super('Нет доступа к данным профиля');
}

/// Профиль пользователя не найден.
final class ProfileNotFoundException extends AppException {
  const ProfileNotFoundException() : super('Профиль пользователя не найден');
}

/// Не удалось сохранить профиль.
final class ProfileSaveException extends AppException {
  const ProfileSaveException() : super('Не удалось сохранить изменения');
}

/// Пользователь отменил выбранную фотографию
final class ProfileImageCanceledException extends AppException {
  const ProfileImageCanceledException() : super('Выбор фотографии отменён');
}
