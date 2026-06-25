import 'package:family_product_plan/app/di/di_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Регистрирует зависимости приложения в дереве виджетов.
class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.child,
    required this.diContainer,
    super.key,
  });

  /// Дочернее дерево виджетов.
  final Widget child;

  /// Контейнер зависимостей приложения.
  final DiContainer diContainer;

  @override
  Widget build(BuildContext context) {
    return Provider.value(value: diContainer, child: child);
    // TODO: если в будущем потребуется несколько провайдеров (для смены языка например)
    //   MultiProvider(
    //   providers: [Provider.value(value: diContainer)],
    //   child: child,
    // );
  }
}
