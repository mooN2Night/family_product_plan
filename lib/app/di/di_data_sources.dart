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
  /// Локальный источник данных для работы с продуктами.
  late final IProductsLocalDataSource productsLocalDataSource;

  /// Удаленный источник данных для работы с продуктами.
  late final IProductsRemoteDataSource productsRemoteDataSource;

  /// Удалённый источник данных для работы с авторизацией.
  late final IAuthRemoteDataSource authRemoteDataSource;

  /// Инициализирует источники данных приложения.
  void init({required DiContainer diContainer}) {
    productsLocalDataSource = ProductsLocalDataSource(
      database: diContainer.services.database,
    );

    productsRemoteDataSource = ProductsRemoteDataSource(
      firestore: diContainer.services.firestore,
    );

    authRemoteDataSource = AuthRemoteDataSource(
      firebaseAuth: diContainer.services.firebaseAuth,
      firestore: diContainer.services.firestore,
      currentFamilyProvider: diContainer.services.currentFamilyProvider,
    );
  }
}
