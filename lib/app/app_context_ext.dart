import 'package:family_product_plan/app/di/di_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Расширение для удобного доступа к зависимостям приложения.
extension AppContextExt on BuildContext {
  /// Возвращает корневой контейнер зависимостей приложения.
  DiContainer get di => read<DiContainer>();
}
