import 'package:equatable/equatable.dart';

import '../../data/dto/product_create_dto.dart';

/// Сущность создания продукта.
class ProductCreateEntity extends Equatable {
  const ProductCreateEntity({
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
  });

  /// Имя продукта.
  final String productName;

  /// Производитель продукта
  final String productManufacturer;

  /// Флаг необходимости покупки
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
