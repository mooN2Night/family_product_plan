import 'package:family_product_plan/features/home/presentation/screen/home_screen.dart';
import 'package:family_product_plan/features/home/presentation/screen/product_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Класс для роутов главного экрана
abstract final class HomeRoutes {
  /// Название роута главной страницы
  static const String homeScreenName = 'home_screen';

  /// Название роута главной страницы
  static const String homeAddScreenName = 'home_add_screen';

  /// Путь роута главной страницы
  static const String homeScreenPath = '/home';

  /// Путь роута главной страницы
  static const String _homeAddScreenPath = 'home_add';

  /// Метод для построения ветки роутов главного экрана
  ///
  /// Принимает:
  /// - [routes] - вложенные роуты
  static StatefulShellBranch buildShellBranch({
    List<RouteBase> routes = const [],
    List<NavigatorObserver>? observers,
  }) => StatefulShellBranch(
    initialLocation: homeScreenPath,
    observers: observers,
    routes: [
      GoRoute(
        path: homeScreenPath,
        name: homeScreenName,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: _homeAddScreenPath,
            name: homeAddScreenName,
            builder: (context, state) => ProductAddScreen(),
          ),
          ...routes,
        ],
      ),
    ],
  );
}
