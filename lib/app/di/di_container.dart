import 'package:family_product_plan/app/di/di_data_sources.dart';
import 'package:family_product_plan/app/di/di_repositories.dart';
import 'package:family_product_plan/app/di/di_services.dart';

/// Корневой контейнер зависимостей приложения.
///
/// Отвечает за создание и инициализацию сервисов и репозиториев,
/// а также предоставляет к ним централизованный доступ.
final class DiContainer {
  /// Контейнер сервисов приложения.
  late final DiServices services;

  /// Контейнер репозиториев приложения.
  late final DiRepositories repositories;

  /// Контейнер источников данных приложения.
  late final DiDataSources dataSource;

  /// Инициализирует все зависимости приложения.
  Future<void> init() async {
    services = DiServices();
    await services.init();

    dataSource = DiDataSources()..init(diContainer: this);

    repositories = DiRepositories()..init(diContainer: this);
  }
}
