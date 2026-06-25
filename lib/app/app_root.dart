import 'package:family_product_plan/app/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'di/di_container.dart';

/// Корневой виджет приложения.
class AppRoot extends StatelessWidget {
  const AppRoot({required this.diContainer, required this.router, super.key});

  /// Контейнер зависимостей приложения.
  final DiContainer diContainer;

  /// Конфигурация маршрутизации приложения.
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      diContainer: diContainer,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
