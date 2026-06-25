import '../../features/home/domain/entity/product_entity.dart';
import '../database/app_database.dart';

extension ProductMapper on Product {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      productName: name,
      productManufacturer: manufacturer,
      isToBuy: isToBuy,
    );
  }
}

extension ProductEntityMapper on ProductEntity {
  Product toDatabaseModel() {
    return Product(
      id: id!,
      name: productName,
      manufacturer: productManufacturer,
      isToBuy: isToBuy,
    );
  }
}