import 'package:family_product_plan/app/app_providers.dart';
import 'package:family_product_plan/features/auth/domain/state/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'di/di_container.dart';

/// Корневой виджет приложения.
class AppRoot extends StatelessWidget {
  const AppRoot({
    required this.diContainer,
    required this.router,
    required this.authBloc,
    super.key,
  });

  /// Контейнер зависимостей приложения.
  final DiContainer diContainer;

  /// Конфигурация маршрутизации приложения.
  final GoRouter router;

  /// Блок авторизации
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      diContainer: diContainer,
      authBloc: authBloc,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
