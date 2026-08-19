import '../../features/home/domain/entity/product_entity.dart';
import '../services/database/app_database.dart';

/// Расширение для преобразования продуктов из локальной бд в сущность.
extension ProductMapper on Product {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      productName: name,
      productManufacturer: manufacturer,
      quantity: quantity ?? '',
      description: description ?? '',
      isToBuy: isToBuy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}

/// Расширение для преобразования сущности продуктов в локальную бд.
extension ProductEntityMapper on ProductEntity {
  Product toDatabaseModel() {
    return Product(
      id: id,
      name: productName,
      manufacturer: productManufacturer,
      quantity: quantity,
      description: description,
      isToBuy: isToBuy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }
}
