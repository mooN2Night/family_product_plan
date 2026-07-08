import 'package:drift/drift.dart';

import '../../../../../app/database/app_database.dart';
import '../../../../../app/mapper/app_product_mapper.dart';
import '../../../domain/entity/product_entity.dart';
import 'i_products_local_data_source.dart';

/// Реализация локального хр`анения продуктов
final class ProductsLocalDataSource implements IProductsLocalDataSource {
  ProductsLocalDataSource({required AppDatabase database})
    : _database = database;

  /// Экземпляр локальной базы данных.
  final AppDatabase _database;

  @override
  Stream<List<Product>> watchProducts() {
    return _database.watchAllProducts();
  }

  @override
  Future<void> addProduct(ProductEntity product) {
    return _database.insertProduct(
      ProductsCompanion.insert(
        name: product.productName,
        manufacturer: Value(product.productManufacturer),
        isToBuy: Value(product.isToBuy),
      ),
    );
  }

  @override
  Future<Product> getProduct(int id) {
    return _database.getProductById(id);
  }

  @override
  Future<void> updateProduct(ProductEntity product) {
    return _database.updateProduct(product.toDatabaseModel());
  }

  @override
  Future<void> deleteProduct(int id) {
    return _database.deleteProductById(id);
  }
}
