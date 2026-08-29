import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/card/domain/state/card_action/card_action_bloc.dart';
import 'package:family_product_plan/features/card/presentation/screen/card_add_screen.dart';
import 'package:family_product_plan/features/card/presentation/screen/card_detail_screen.dart';
import 'package:family_product_plan/features/card/presentation/screen/card_scan_screen.dart';
import 'package:family_product_plan/features/card/presentation/screen/card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/error/app_error_screen.dart';
import '../../../app/router/app_router.dart';

/// Класс для роутов главного экрана
abstract final class CardRoutes {
  /// Название роута главной страницы
  static const String cardScreenName = 'card_screen';

  /// Название роута экрана с деталями
  static const String cardDetailScreenName = 'card_detail_screen';
  static const String cardScannerScreenName = 'card_scanner_screen';
  static const String cardAddScreenName = 'card_add_screen';

  /// Путь роута главной страницы
  static const String cardScreenPath = '/card';

  /// Путь роута экрана с деталями
  static const String _cardDetailScreenPath = 'card_detail/:id';
  static const String _cardScannerScreenPath = 'card_scanner';
  static const String _cardAddScreenPath = 'card_add';

  /// Метод для построения ветки роутов главного экрана
  ///
  /// Принимает:
  /// - [routes] - вложенные роуты
  static StatefulShellBranch buildShellBranch({
    List<RouteBase> routes = const [],
    List<NavigatorObserver>? observers,
  }) => StatefulShellBranch(
    initialLocation: cardScreenPath,
    observers: observers,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final cardRepository = context.di.repositories.cardRepository;

          return BlocProvider(
            create: (context) => CardActionBloc(cardRepository: cardRepository),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: cardScreenPath,
            name: cardScreenName,
            builder: (context, state) => const CardScreen(),
            routes: [
              GoRoute(
                path: _cardDetailScreenPath,
                name: cardDetailScreenName,
                builder: (context, state) {
                  final id = state.pathParameters['id'];

                  assert(
                    id != null,
                    'Экран детальной информации о продукте требует передачи id продукта',
                  );

                  if (id != null) {
                    return CardDetailScreen(id: id);
                  }

                  return ErrorScreen(
                    error:
                        '"Ошибка открытия страницы $cardDetailScreenName! Не переданы обязательные параметры!",',
                    stackTrace: StackTrace.current,
                  );
                },
              ),
              GoRoute(
                path: _cardAddScreenPath,
                name: cardAddScreenName,
                builder: (context, state) {
                  return CardAddScreen();
                },
                routes: [
                  GoRoute(
                    path: _cardScannerScreenPath,
                    name: cardScannerScreenName,
                    parentNavigatorKey: AppRouter.rootNavigatorKey,
                    builder: (context, state) {
                      return CardScannerScreen();
                    },
                  ),
                ],
              ),
              ...routes,
            ],
          ),
        ],
      ),
    ],
  );
}
