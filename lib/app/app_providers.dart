import 'package:family_product_plan/app/di/di_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/auth/domain/state/auth_bloc.dart';

/// Регистрирует зависимости приложения в дереве виджетов.
class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.child,
    required this.diContainer,
    required this.authBloc,
    super.key,
  });

  /// Дочернее дерево виджетов.
  final Widget child;

  /// Контейнер зависимостей приложения.
  final DiContainer diContainer;

  /// Блок авторизации
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: diContainer),
        Provider.value(value: authBloc),
      ],
      child: child,
    );
  }
}


// BlocProvider.value(
//   value: authBloc,
//   child: Provider.value(value: diContainer, child: child),
// );
// TODO: если в будущем потребуется несколько провайдеров (для смены языка например)
//   MultiProvider(
//   providers: [Provider.value(value: diContainer)],
//   child: child,
// );
