import '../../../../app/error/app_exception.dart';

/// У пользователя уже есть семья.
final class DeleteCardNoInternetException extends AppException {
  const DeleteCardNoInternetException()
    : super('Нет интернета, удаление карты недоступно');
}

/// У пользователя уже есть семья.
final class AddCardNoInternetException extends AppException {
  const AddCardNoInternetException()
      : super('Нет интернета, добавление карты недоступно');
}
