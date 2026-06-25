import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_routes.dart';
import '../../features/root/root_screen.dart';
import '../error/app_error_routes.dart';

/// Конфигурация маршрутизации приложения.
abstract interface class AppRouter {
  /// Ключ для доступа к корневому навигатору приложения.
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Начальный роут приложения.
  static const initialLocation = '/home';

  /// Метод для создания экземпляра GoRouter.
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      onException: (_, GoRouterState state, GoRouter router) {
        if (router.state.name == ErrorRoutes.notFoundScreenName) return;
        router.pushNamed(ErrorRoutes.notFoundScreenName);
      },
      routes: [
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state, navigationShell) =>
              RootScreen(navigationShell: navigationShell),
          branches: [
            HomeRoutes.buildShellBranch(),
            // ProfileRoutes.buildShellBranch(),
          ],
        ),
        ErrorRoutes.buildRoute(),
      ],
    );
  }
}
