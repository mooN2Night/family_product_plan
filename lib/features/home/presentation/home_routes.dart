import 'package:family_product_plan/features/home/presentation/screen/home_screen.dart';
import 'package:family_product_plan/features/home/presentation/screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/error/app_error_screen.dart';

/// Класс для роутов главного экрана
abstract final class HomeRoutes {
  /// Название роута главной страницы
  static const String homeScreenName = 'home_screen';

  /// Название роута экрана с деталями
  static const String homeDetailScreenName = 'home_detail_screen';

  /// Путь роута главной страницы
  static const String _homeScreenPath = '/home';

  /// Путь роута экрана с деталями
  static const String _homeDetailScreenPath = '/home/detail';

  /// Метод для построения ветки роутов главного экрана
  ///
  /// Принимает:
  /// - [routes] - вложенные роуты
  static StatefulShellBranch buildShellBranch({
    List<RouteBase> routes = const [],
    List<NavigatorObserver>? observers,
  }) => StatefulShellBranch(
    initialLocation: _homeScreenPath,
    observers: observers,
    routes: [
      GoRoute(
        path: _homeScreenPath,
        name: homeScreenName,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: _homeDetailScreenPath,
            name: homeDetailScreenName,
            builder: (context, state) {
              final id = state.uri.queryParameters['id'];

              assert(
                id != null,
                'Экран детальной информации о продукте требует передачи id продукта',
              );

              if (id != null) {
                return ProductDetailScreen(id: id);
              }

              return ErrorScreen(
                error:
                    '"Ошибка открытия страницы $homeDetailScreenName! Не переданы обязательные параметры!",',
                stackTrace: StackTrace.current,
              );
            },
          ),
          ...routes,
        ],
      ),
    ],
  );
}
