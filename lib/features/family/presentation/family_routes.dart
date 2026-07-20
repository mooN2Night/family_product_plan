import 'package:family_product_plan/features/family/presentation/screen/family_create_screen.dart';
import 'package:family_product_plan/features/family/presentation/screen/family_info_screen.dart';
import 'package:go_router/go_router.dart';

/// Роуты для фичи семьи
abstract final class FamilyRoutes {
  /// Название роута страницы создания семьи
  static const String familyCreateScreenName = 'family_create_screen';

  /// Название роута страницы информации о семье
  static const String familyInfoScreenName = 'family_info_screen';

  /// Путь роута страницы создания семьи
  static const String _familyCreateScreenPath = 'family_create';

  /// Путь роута страницы информации о семье
  static const String _familyInfoScreenPath = 'family_info';

  /// Метод для построения роута страницы создания семьи
  static GoRoute buildFamilyCreateRoute({List<RouteBase> routes = const []}) =>
      GoRoute(
        path: _familyCreateScreenPath,
        name: familyCreateScreenName,
        builder: (context, state) => FamilyCreateScreen(),
      );

  /// Метод для построения роута страницы создания семьи
  static GoRoute buildFamilyInfoRoute({List<RouteBase> routes = const []}) =>
      GoRoute(
        path: _familyInfoScreenPath,
        name: familyInfoScreenName,
        builder: (context, state) => FamilyInfoScreen(),
      );
}
