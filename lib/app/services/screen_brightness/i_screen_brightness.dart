/// Сервис для управления яркостью экрана приложения.
abstract interface class IScreenBrightnessService {
  /// Устанавливает яркость экрана приложения.
  ///
  /// Значение должно находиться в диапазоне от 0.0 до 1.0.
  Future<void> setApplicationBrightness(double brightness);

  /// Устанавливает максимальную яркость экрана приложения.
  Future<void> setMaxApplicationBrightness();

  /// Сбрасывает переопределённую яркость приложения.
  ///
  /// После сброса приложение возвращается к обычной яркости устройства.
  Future<void> resetApplicationBrightness();

  /// Возвращает текущую яркость приложения.
  Future<double> getApplicationBrightness();
}