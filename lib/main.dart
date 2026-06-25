import 'package:flutter/material.dart';

import 'app/app_root.dart';
import 'app/di/di_container.dart';
import 'app/error/app_error_screen.dart';
import 'app/router/app_router.dart';

void main() => _run();

/// Выполняет запуск приложения и обработку ошибок инициализации.
Future<void> _run() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    final diContainer = await _initDependencies();

    final router = AppRouter.createRouter();

    runApp(AppRoot(diContainer: diContainer, router: router));
  } on Object catch (error, stackTrace) {
    // В случае ошибки инициализации отображаем fallback-экран с возможностью
    // повторного запуска приложения.
    runApp(ErrorScreen(error: error, stackTrace: stackTrace, onRetry: _run));
  }
}

/// Метод для инициализации зависимостей приложения
Future<DiContainer> _initDependencies() async {
  final diContainer = DiContainer();
  await diContainer.init();
  return diContainer;
}
