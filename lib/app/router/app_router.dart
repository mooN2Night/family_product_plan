import 'package:family_product_plan/app/router/auth_refresh_listener.dart';
import 'package:family_product_plan/features/auth/domain/state/auth_bloc.dart';
import 'package:family_product_plan/features/auth/presentation/auth_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_routes.dart';
import '../../features/profile/presentation/profile_routes.dart';
import '../../features/root/root_screen.dart';
import '../error/app_error_routes.dart';

/// Конфигурация маршрутизации приложения.
abstract interface class AppRouter {
  /// Ключ для доступа к корневому навигатору приложения.
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Начальный роут приложения.
  static const initialLocation = '/splash';

  /// Метод для создания экземпляра GoRouter.
  static GoRouter createRouter({required AuthBloc authBloc}) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      onException: (_, GoRouterState state, GoRouter router) {
        if (router.state.name == ErrorRoutes.notFoundScreenName) return;
        router.pushNamed(ErrorRoutes.notFoundScreenName);
      },
      refreshListenable: AuthRefreshListener(authBloc: authBloc),
      redirect: (context, state) {
        final authState = authBloc.state;

        final isSplash = state.matchedLocation == AuthRoutes.splashScreenPath;

        final isAuthPage =
            state.matchedLocation == AuthRoutes.loginScreenPath ||
            state.matchedLocation == AuthRoutes.registerScreenPath;

        if (authState is AuthCheckingState) {
          return isSplash ? null : AuthRoutes.splashScreenPath;
        }

        if (authState is AuthUnauthenticatedState ||
            authState is AuthErrorState) {
          return isAuthPage ? null : AuthRoutes.loginScreenPath;
        }

        if (authState is AuthAuthenticatedState) {
          return isAuthPage || isSplash ? HomeRoutes.homeScreenPath : null;
        }

        return null;
      },
      routes: [
        ...AuthRoutes.routes(),
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state, navigationShell) =>
              RootScreen(navigationShell: navigationShell),
          branches: [
            HomeRoutes.buildShellBranch(),
            ProfileRoutes.buildShellBranch(),
          ],
        ),
        ErrorRoutes.buildRoute(),
      ],
    );
  }
}
