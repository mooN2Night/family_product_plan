import 'package:go_router/go_router.dart';

import 'error_screen_not_found.dart';

/// Класс для реализации роутов страниц с ошибками.
abstract final class ErrorRoutes {
  /// Название экрана ошибки 404
  static const notFoundScreenName = 'not_found';

  /// Путь экрана ошибки 404
  static const _notFoundScreenPath = '/not_found';

  /// Метод для построения роута к экрану ошибки 404
  static GoRoute buildRoute() => GoRoute(
    path: _notFoundScreenPath,
    name: notFoundScreenName,
    builder: (context, state) {
      return const ErrorScreenNotFound();
    },
  );
}
