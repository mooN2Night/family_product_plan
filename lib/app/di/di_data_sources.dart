import 'package:family_product_plan/features/pending_sync/data/data_source/local/i_pending_sync_local_data_source.dart';
import 'package:family_product_plan/features/pending_sync/data/data_source/local/pending_sync_local_data_source.dart';
import 'package:family_product_plan/features/tasks/data/data_source/local/i_tasks_local_data_source.dart';
import 'package:family_product_plan/features/tasks/data/data_source/local/tasks_local_data_source.dart';
import 'package:family_product_plan/features/tasks/data/data_source/remote/i_tasks_remote_data_source.dart';

import '../../features/auth/data/data_source/remote/auth_remote_data_source.dart';
import '../../features/auth/data/data_source/remote/i_auth_remote_data_source.dart';
import '../../features/home/data/data_source/local/i_products_local_data_source.dart';
import '../../features/home/data/data_source/local/products_local_data_source.dart';
import '../../features/home/data/data_source/remote/i_product_remote_data_source.dart';
import '../../features/home/data/data_source/remote/product_remote_data_source.dart';
import 'di_container.dart';

/// Контейнер источников данных приложения.
///
/// Отвечает за создание и хранение экземпляров DataSource,
/// обеспечивающих доступ к локальным и удалённым данным.
final class DiDataSources {
  /// Удалённый источник данных для работы с авторизацией.
  late final IAuthRemoteDataSource authRemoteDataSource;

  /// Локальный источник данных для работы с продуктами.
  late final IProductsLocalDataSource productsLocalDataSource;

  /// Удаленный источник данных для работы с продуктами.
  late final IProductsRemoteDataSource productsRemoteDataSource;

  /// Локальный источник данных для работы с задачами.
  late final ITasksLocalDataSource tasksLocalDataSource;

  /// Удаленный источник данных для работы с задачами.
  late final ITasksRemoteDataSource tasksRemoteDataSource;

  /// Удаленный источник данных для работы с продуктами.
  late final IPendingSyncLocalDataSource pendingSyncLocalDataSource;

  /// Инициализирует источники данных приложения.
  void init({required DiContainer diContainer}) {
    authRemoteDataSource = AuthRemoteDataSource(
      firebaseAuth: diContainer.services.firebaseAuth,
      firestore: diContainer.services.firestore,
      currentFamilyProvider: diContainer.services.currentFamilyProvider,
    );

    productsLocalDataSource = ProductsLocalDataSource(
      database: diContainer.services.database,
    );

    productsRemoteDataSource = ProductsRemoteDataSource(
      firestore: diContainer.services.firestore,
    );

    tasksLocalDataSource = TasksLocalDataSource(
      database: diContainer.services.database,
    );

    pendingSyncLocalDataSource = PendingSyncLocalDataSource(
      database: diContainer.services.database,
    );
  }
}
