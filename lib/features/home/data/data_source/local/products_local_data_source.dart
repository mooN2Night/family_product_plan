import 'package:drift/drift.dart';
import '../../../../../app/mapper/app_product_mapper.dart';
import '../../../../../app/services/database/app_database.dart';
import '../../../../../app/services/database/i_database.dart';
import '../../../domain/entity/product_entity.dart';
import 'i_products_local_data_source.dart';

/// Реализация локального хр`анения продуктов
final class ProductsLocalDataSource implements IProductsLocalDataSource {
  ProductsLocalDataSource({required IDatabase database}) : _database = database;

  /// Экземпляр локальной базы данных.
  final IDatabase _database;

  @override
  Stream<List<Product>> watchProducts() {
    return _database.watchAllProducts();
  }

  @override
  Future<void> addProduct(ProductEntity product) {
    return _database.insertProduct(
      ProductsCompanion.insert(
        id: product.id,
        name: product.productName,
        manufacturer: Value(product.productManufacturer),
        isToBuy: Value(product.isToBuy),
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
      ),
    );
  }

  @override
  Future<Product> getProduct(String id) {
    return _database.getProductById(id);
  }

  @override
  Future<void> updateProduct(ProductEntity product) {
    return _database.updateProduct(product.toDatabaseModel());
  }

  @override
  Future<void> deleteProduct(String id) {
    return _database.deleteProductById(id);
  }

  @override
  Future<void> replaceProducts(List<ProductEntity> products) async {
    await _database.replaceProducts(
      products.map((e) => e.toDatabaseModel()).toList(),
    );
  }

  @override
  Future<void> upsertProduct(ProductEntity product) {
    return _database.upsertProduct(product.toDatabaseModel());
  }

  @override
  Future<List<Product>> getProducts() {
    return _database.getProducts();
  }

  @override
  Future<void> clearProducts() {
    return _database.clearProducts();
  }
}
