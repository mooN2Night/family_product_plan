import 'package:screen_brightness/screen_brightness.dart';

import 'i_screen_brightness.dart';

/// Реализация сервиса управления яркостью экрана приложения.
final class ScreenBrightnessService implements IScreenBrightnessService {
  const ScreenBrightnessService();

  ScreenBrightness get _screenBrightness => ScreenBrightness.instance;

  @override
  Future<void> setApplicationBrightness(double brightness) {
    return _screenBrightness.setApplicationScreenBrightness(brightness);
  }

  @override
  Future<void> setMaxApplicationBrightness() {
    return _screenBrightness.setApplicationScreenBrightness(1.0);
  }

  @override
  Future<void> resetApplicationBrightness() {
    return _screenBrightness.resetApplicationScreenBrightness();
  }

  @override
  Future<double> getApplicationBrightness() {
    return _screenBrightness.application;
  }
}