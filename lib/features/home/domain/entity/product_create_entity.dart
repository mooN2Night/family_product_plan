import 'package:equatable/equatable.dart';

import '../../data/dto/product_create_dto.dart';

/// Сущность, содержащая данные для создания нового продукта.
class ProductCreateEntity extends Equatable {
  const ProductCreateEntity({
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
  });

  /// Название продукта.
  final String productName;

  /// Производитель продукта.
  final String productManufacturer;

  /// Признак необходимости покупки.
  final bool isToBuy;

  /// Метод для частичного изменения полей продукта
  ProductCreateEntity copyWith({
    String? productName,
    String? productManufacturer,
    bool? isToBuy,
  }) {
    return ProductCreateEntity(
      productName: productName ?? this.productName,
      productManufacturer: productManufacturer ?? this.productManufacturer,
      isToBuy: isToBuy ?? this.isToBuy,
    );
  }

  /// Преобразует сущность в DTO.
  ProductCreateDto toDto() {
    return ProductCreateDto(
      productName: productName,
      productManufacturer: productManufacturer,
      isToBuy: isToBuy,
    );
  }

  @override
  List<Object?> get props => [productName, productManufacturer, isToBuy];
}
