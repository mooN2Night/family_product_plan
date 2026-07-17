import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app_root.dart';
import 'app/di/di_container.dart';
import 'app/error/app_error_screen.dart';
import 'app/router/app_router.dart';
import 'features/auth/domain/state/auth_bloc.dart';
import 'firebase_options.dart';

void main() => _run();

/// Выполняет запуск приложения и обработку ошибок инициализации.
Future<void> _run() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final diContainer = await _initDependencies();

    final authBloc = AuthBloc(
      authRepository: diContainer.repositories.authRepository,
    )..add(const AuthStartedEvent());

    final router = AppRouter.createRouter(authBloc: authBloc);

    runApp(AppRoot(diContainer: diContainer, router: router, authBloc: authBloc));
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
  final k = 1;
  return diContainer;
}
