enum AppPermissionResult { granted, denied, permanentlyDenied }

/// Интерфейся сервиса запроса доступов.
abstract interface class IPermissionHandler {
  /// Метод для запроса доступа к галереи телефона
  Future<bool> requestPhotosPermission();

  /// Метод для запроса доступа к камере телефона
  Future<AppPermissionResult> requestCameraPermission();

  /// Открывает системные настройки приложения
  Future<bool> openSettings();
}
