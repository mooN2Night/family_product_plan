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
    required this.isDeleted,
  });

  /// Уникальный идентификатор.
  final String id;

  /// Имя продукта.
  final String productName;

  /// Производитель продукта
  final String productManufacturer;

  /// Флаг необходимости покупки
  final bool isToBuy;

  /// Дата создания продукта
  final DateTime createdAt;

  /// Дата изменения продукта
  final DateTime updatedAt;

  /// Флаг, было ли поле удалено из Firestore
  final bool isDeleted;

  /// Преобразует сущность в DTO.
  ProductDto toDto() {
    return ProductDto(
      id: id,
      productName: productName,
      productManufacturer: productManufacturer,
      isToBuy: isToBuy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
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
    bool? isDeleted,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      productManufacturer: productManufacturer ?? this.productManufacturer,
      isToBuy: isToBuy ?? this.isToBuy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
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
    isDeleted,
  ];
}
