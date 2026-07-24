import 'package:equatable/equatable.dart';

import '../../data/dto/product_dto.dart';

/// Сущность продукта.
class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Уникальный идентификатор.
  final String id;

  /// Имя продукта.
  final String productName;

  /// Производитель продукта
  final String productManufacturer;

  /// Флаг необходимости покупки
  final bool isToBuy;

  final DateTime createdAt;
  final DateTime updatedAt;

  ProductDto toDto() {
    return ProductDto(
      id: id,
      productName: productName,
      productManufacturer: productManufacturer,
      isToBuy: isToBuy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Метод для частичного изменения полей продукта
  ProductEntity copyWith({
    String? id,
    String? productName,
    String? productManufacturer,
    bool? isToBuy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productManufacturer: productManufacturer ?? this.productManufacturer,
      isToBuy: isToBuy ?? this.isToBuy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productName,
    productManufacturer,
    isToBuy,
    createdAt,
    updatedAt,
  ];
}
