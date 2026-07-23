import 'package:family_product_plan/app/extensions/string_extensions.dart';
import 'package:family_product_plan/features/family/presentation/screen/family_create_screen.dart';
import 'package:family_product_plan/features/family/presentation/screen/family_info_screen.dart';
import 'package:family_product_plan/features/family/presentation/screen/family_join_screen.dart';
import 'package:family_product_plan/features/family/presentation/screen/family_member_info_screen.dart';
import 'package:go_router/go_router.dart';

/// Роуты для фичи семьи
abstract final class FamilyRoutes {
  /// Название роута страницы создания семьи
  static const String familyCreateScreenName = 'family_create_screen';

  /// Название роута страницы информации о семье
  static const String familyInfoScreenName = 'family_info_screen';

  /// Название роута страницы информации об участнике семьи
  static const String familyMemberInfoScreenName = 'family_member_info_screen';

  /// Название роута страницы вступления в семьею
  static const String familyJoinScreenName = 'family_join_screen';

  /// Путь роута страницы создания семьи
  static const String _familyCreateScreenPath = 'family_create';

  /// Путь роута страницы информации о семье
  static const String _familyInfoScreenPath = 'family_info/:familyId';

  /// Путь роута страницы информации об участнике семьи
  static const String _familyMemberInfoScreenPath = 'member_info/:userId';

  /// Путь роута страницы вступления в семьею
  static const String _familyJoinScreenPath = 'family_join';

  /// Метод для построения роута страницы создания семьи
  static GoRoute buildFamilyCreateRoute({List<RouteBase> routes = const []}) =>
      GoRoute(
        path: _familyCreateScreenPath,
        name: familyCreateScreenName,
        builder: (context, state) => FamilyCreateScreen(),
      );

  /// Метод для построения роута страницы информации о семье
  static GoRoute buildFamilyInfoRoute({
    List<RouteBase> routes = const [],
  }) => GoRoute(
    path: _familyInfoScreenPath,
    name: familyInfoScreenName,
    builder: (context, state) {
      final familyId = state.pathParameters['familyId'];

      assert(
        familyId != null,
        'Для открытия экрана "Список участников семьи" нужно передать обязательные параметры',
      );

      return FamilyInfoScreen(familyId: familyId!);
    },
    routes: routes,
  );

  /// Метод для построения роута страницы информации об участнике семьи
  static GoRoute buildFamilyMemberInfoRoute({
    List<RouteBase> routes = const [],
  }) => GoRoute(
    path: _familyMemberInfoScreenPath,
    name: familyMemberInfoScreenName,
    builder: (context, state) {
      final userId = state.pathParameters['userId'];
      final familyId = state.pathParameters['familyId'];
      final role = state.uri.queryParameters['role'];
      final relation = state.uri.queryParameters['relation'];
      final canEditRelation = state.uri.queryParameters['canEditRelation']
          .toBool();

      assert(
        userId != null && familyId != null && role != null && relation != null,
        'Для открытия экрана "Информация об участнике семьи" нужно передать обязательные параметры',
      );

      return FamilyMemberInfoScreen(
        userId: userId!,
        familyId: familyId!,
        role: role!,
        relation: relation!,
        canEditRelation: canEditRelation,
      );
    },
  );

  /// Метод для построения роута страницы вступления в семьею
  static GoRoute buildFamilyJoinRoute({List<RouteBase> routes = const []}) =>
      GoRoute(
        path: _familyJoinScreenPath,
        name: familyJoinScreenName,
        builder: (context, state) => FamilyJoinScreen(),
      );
}
