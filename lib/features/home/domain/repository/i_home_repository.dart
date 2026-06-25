import '../entity/product_entity.dart';

/// Интерфейс репозитория главного экрана
abstract interface class IHomeRepository {
  /// Стрим для отслеживания изменений в списке продуктов
  Stream<List<ProductEntity>> watchProducts();

  /// Добавление нового продукта
  Future<void> addProduct(ProductEntity product);

  /// Получение продукта
  Future<ProductEntity> getProduct(int id);

  /// Переключение статуса "Нужно купить"
  Future<void> toggleProductStatus(ProductEntity product);

  /// Удаление продукта
  Future<void> deleteProduct(int id);
}
