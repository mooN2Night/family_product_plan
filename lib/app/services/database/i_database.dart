import 'app_database.dart';

abstract interface class IDatabase {
  /// Возвращает поток со списком всех продуктов. Обновляется автоматически при изменении данных.
  Stream<List<Product>> watchAllProducts();

  /// Добавляет новый продукт в базу данных.
  /// Возвращает идентификатор созданной записи.
  Future<int> insertProduct(ProductsCompanion entity);

  /// Обновляет существующий продукт.
  Future<void> updateProduct(Product entity);

  /// Удаляет продукт по его идентификатору.
  Future<int> deleteProductById(int id);

  /// Получает продукт по его идентификатору.
  Future<Product> getProductById(int id);
}