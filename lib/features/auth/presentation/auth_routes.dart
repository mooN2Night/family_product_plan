import 'package:family_product_plan/features/auth/presentation/screen/login_screen.dart';
import 'package:family_product_plan/features/auth/presentation/screen/register_screen.dart';
import 'package:family_product_plan/features/auth/presentation/screen/splash_screen.dart';
import 'package:go_router/go_router.dart';

/// Класс для роутов страницы авторизации
abstract final class AuthRoutes {
  /// Название роута страницы сплеш
  static const String splashScreenName = 'splash_screen';

  /// Название роута страницы авторизации
  static const String loginScreenName = 'login_screen';

  /// Название роута страницы регистрации
  static const String registerScreenName = 'register_screen';

  /// Путь роута страницы сплеш
  static const String splashScreenPath = '/splash';

  /// Путь роута страницы авторизации
  static const String loginScreenPath = '/login';

  /// Путь роута страницы авторизации
  static const String registerScreenPath = '/register';

  /// Создание роутов авторизации.
  static List<RouteBase> routes() {
    return [
      GoRoute(
        path: splashScreenPath,
        name: splashScreenName,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: loginScreenPath,
        name: loginScreenName,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: registerScreenPath,
        name: registerScreenName,
        builder: (context, state) => const RegisterScreen(),
      ),
    ];
  }
}
