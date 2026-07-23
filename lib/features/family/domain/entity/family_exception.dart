import '../../../../app/error/app_exception.dart';

/// Нет доступа к данным семьи.
final class FamilyPermissionDeniedException extends AppException {
  const FamilyPermissionDeniedException() : super('Нет доступа к данным семьи');
}

/// Семья не найдена.
final class FamilyNotFoundException extends AppException {
  const FamilyNotFoundException() : super('Семья не найдена');
}

/// У пользователя уже есть семья.
final class UserAlreadyHasFamilyException extends AppException {
  const UserAlreadyHasFamilyException()
    : super('У пользователя уже есть семья');
}

/// Семья с таким кодом не найдена.
final class FamilyInviteCodeNotFoundException extends AppException {
  const FamilyInviteCodeNotFoundException()
      : super('Семья с таким кодом не найдена');
}

/// Владелец семьи не может покинуть семью
final class FamilyOwnerCannotLeaveException extends AppException {
  const FamilyOwnerCannotLeaveException()
      : super(
    'Владелец семьи не может покинуть семью. Передайте права другому участнику или удалите семью.',
  );
}
