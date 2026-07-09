import 'package:family_product_plan/features/profile/presentation/screen/profile_editor_screen.dart';
import 'package:family_product_plan/features/profile/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Класс для роутов экрана профиля
abstract final class ProfileRoutes {
  /// Название роута страницы профиля
  static const String profileScreenName = 'profile_screen';

  /// Название роута страницы редактирования профиля
  static const String profileEditorScreenName = 'profile_editor_screen';

  /// Путь роута страницы профиля
  static const String _profileScreenPath = '/profile';

  /// Путь роута страницы редактирования профиля
  static const String _profileEditorScreenPath = 'profile_editor';

  /// Метод для построения ветки роутов экрана профиля
  ///
  /// Принимает:
  /// - [routes] - вложенные роуты
  static StatefulShellBranch buildShellBranch({
    List<RouteBase> routes = const [],
    List<NavigatorObserver>? observers,
  }) => StatefulShellBranch(
    initialLocation: _profileScreenPath,
    observers: observers,
    routes: [
      GoRoute(
        path: _profileScreenPath,
        name: profileScreenName,
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: _profileEditorScreenPath,
            name: profileEditorScreenName,
            builder: (context, state) => const ProfileEditorScreen(),
          ),
        ],
      ),
    ],
  );
}
