import '../entity/product_create_entity.dart';
import '../entity/product_entity.dart';

/// Интерфейс репозитория главного экрана
abstract interface class IHomeRepository {
  /// Стрим для отслеживания изменений в списке продуктов
  Stream<List<ProductEntity>> watchProducts();

  /// Добавление нового продукта
  Future<void> addProduct(ProductCreateEntity product);

  /// Получение продукта
  Future<ProductEntity> getProduct(String id);

  /// Переключение статуса "Нужно купить"
  Future<void> toggleProductStatus(ProductEntity product);

  /// Удаление продукта
  Future<void> deleteProduct(String id);

  Future<void> moveLocalProductsToFamily();

  Future<void> clearLocalProducts();
}
