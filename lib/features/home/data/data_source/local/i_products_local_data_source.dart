import '../../../../../app/services/database/app_database.dart';
import '../../../domain/entity/product_entity.dart';

/// Интерфейс локальной БД
abstract interface class IProductsLocalDataSource {
  /// Поток всех продуктов.
  Stream<List<Product>> watchProducts();

  /// Добавляет продукт.
  Future<void> addProduct(ProductEntity product);

  /// Получает продукт по id.
  Future<Product> getProduct(String id);

  /// Обновляет продукт.
  Future<void> updateProduct(ProductEntity product);

  /// Удаляет продукт.
  Future<void> deleteProduct(String id);

  /// метод полной синхронизации
  Future<void> replaceProducts(List<ProductEntity> products);

  Future<void> upsertProduct(ProductEntity product);

  Future<List<Product>> getProducts();

  Future<void> clearProducts();
}
