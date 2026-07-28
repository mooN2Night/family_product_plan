import '../../../../../app/services/database/app_database.dart';
import '../../../domain/entity/product_entity.dart';

/// Интерфейс локального источника данных для работы с продуктами.
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

  /// Добавляет новый продукт или обновляет существующий.
  Future<void> upsertProduct(ProductEntity product);

  /// Возвращает список всех продуктов.
  Future<List<Product>> getProducts();

  /// Удаляет все продукты.
  Future<void> clearProducts();
}
