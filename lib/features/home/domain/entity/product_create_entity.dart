import 'package:equatable/equatable.dart';

import '../../data/dto/product_create_dto.dart';

/// Сущность, содержащая данные для создания нового продукта.
class ProductCreateEntity extends Equatable {
  const ProductCreateEntity({
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
    this.quantity,
    this.description,
  });

  /// Название продукта.
  final String productName;

  /// Производитель продукта.
  final String productManufacturer;

  /// Количество продукта.
  ///
  /// Например: `2 л`, `3 шт`, `500 г`.
  final String? quantity;

  /// Дополнительное описание продукта.
  final String? description;

  /// Признак необходимости покупки.
  final bool isToBuy;

  /// Метод для частичного изменения полей продукта
  ProductCreateEntity copyWith({
    String? productName,
    String? productManufacturer,
    String? quantity,
    String? description,
    bool? isToBuy,
  }) {
    return ProductCreateEntity(
      productName: productName ?? this.productName,
      productManufacturer: productManufacturer ?? this.productManufacturer,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      isToBuy: isToBuy ?? this.isToBuy,
    );
  }

  /// Преобразует сущность в DTO.
  ProductCreateDto toDto() {
    return ProductCreateDto(
      productName: productName,
      productManufacturer: productManufacturer,
      quantity: quantity,
      description: description,
      isToBuy: isToBuy,
    );
  }

  @override
  List<Object?> get props => [
    productName,
    productManufacturer,
    quantity,
    description,
    isToBuy,
  ];
}
