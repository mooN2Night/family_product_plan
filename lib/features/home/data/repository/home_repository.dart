import 'package:drift/drift.dart';
import 'package:family_product_plan/app/mapper/app_product_mapper.dart';

import '../../../../app/database/app_database.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/repository/i_home_repository.dart';

/// Реализация репозитория для работы с главной страницей.
final class HomeRepository implements IHomeRepository {
  HomeRepository({required AppDatabase appDatabase})
    : _appDatabase = appDatabase;

  /// Экземпляр локальной базы данных.
  final AppDatabase _appDatabase;

  @override
  Stream<List<ProductEntity>> watchProducts() {
    return _appDatabase.watchAllProducts().map(
      (list) => list.map((item) => item.toEntity()).toList(),
    );
  }

  // Stream<List<ProductEntity>> watchProducts() {
  //   return _appDatabase.watchAllProducts().map(
  //         (list) => list
  //         .map(
  //           (item) => ProductEntity(
  //         id: item.id,
  //         productName: item.name,
  //         productManufacturer: item.manufacturer,
  //         isToBuy: item.isToBuy,
  //       ),
  //     )
  //         .toList(),
  //   );
  // }

  @override
  Future<void> addProduct(ProductEntity product) {
    return _appDatabase.insertProduct(
      ProductsCompanion.insert(
        name: product.productName,
        manufacturer: Value(product.productManufacturer),
        isToBuy: Value(product.isToBuy),
      ),
    );
  }

  @override
  Future<void> deleteProduct(int id) async =>
      await _appDatabase.deleteProductById(id);

  @override
  Future<ProductEntity> getProduct(int id) async {
    final rowProduct = await _appDatabase.getProductById(id);

    return ProductEntity(
      id: rowProduct.id,
      productName: rowProduct.name,
      productManufacturer: rowProduct.manufacturer,
      isToBuy: rowProduct.isToBuy,
    );
  }

  @override
  Future<void> toggleProductStatus(ProductEntity product) async =>
      await _appDatabase.updateProduct(product.toDatabaseModel());

  // Product(
  //   id: product.id!,
  //   name: product.productName,
  //   manufacturer: product.productManufacturer,
  //   isToBuy: product.isToBuy,
  // ),
}
