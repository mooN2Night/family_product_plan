/// Интерфейся сервиса запроса доступов.
abstract interface class IPermissionHandler {
  /// Метод для запроса доступа к галереи телефона
  Future<bool> requestPhotosPermission();
}
