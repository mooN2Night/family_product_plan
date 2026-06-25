import 'package:equatable/equatable.dart';

/// Сущность продукта.
class ProductEntity extends Equatable {
  const ProductEntity({
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
    this.id,
  });

  /// Уникальный идентификатор.
  final int? id;

  /// Имя продукта.
  final String productName;

  /// Производитель продукта
  final String productManufacturer;

  /// Флаг необходимости покупки
  final bool isToBuy;

  /// Метод для частичного изменения полей продукта
  ProductEntity copyWith({
    int? id,
    String? productName,
    String? productManufacturer,
    bool? isToBuy,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productManufacturer: productManufacturer ?? this.productManufacturer,
      isToBuy: isToBuy ?? this.isToBuy,
    );
  }

  @override
  List<Object?> get props => [id, productName, productManufacturer, isToBuy];
}
