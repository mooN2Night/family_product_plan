import '../../../../../app/services/database/app_database.dart';
import '../../../domain/entity/product_entity.dart';

/// Интерфейс локальной БД
abstract interface class IProductsLocalDataSource {
  /// Поток всех продуктов.
  Stream<List<Product>> watchProducts();

  /// Добавляет продукт.
  Future<void> addProduct(ProductEntity product);

  /// Получает продукт по id.
  Future<Product> getProduct(int id);

  /// Обновляет продукт.
  Future<void> updateProduct(ProductEntity product);

  /// Удаляет продукт.
  Future<void> deleteProduct(int id);
}
