import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/product_entity.dart';

/// DTO продукта для хранения и передачи данных.
final class ProductDto {
  const ProductDto({
    required this.id,
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Создает DTO из JSON.
  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      productName: json['productName'] as String,
      productManufacturer: json['productManufacturer'] as String,
      isToBuy: json['isToBuy'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory ProductDto.fromJsonOffline(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      productName: json['productName'] as String,
      productManufacturer: json['productManufacturer'] as String,
      isToBuy: json['isToBuy'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Идентификатор продукта.
  final String id;

  /// Название продукта.
  final String productName;

  /// Производитель продукта.
  final String productManufacturer;

  /// Признак необходимости покупки продукта.
  final bool isToBuy;

  /// Дата создания продукта.
  final DateTime createdAt;

  /// Дата последнего обновления продукта.
  final DateTime updatedAt;

  /// Преобразует DTO в доменную сущность.
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      productName: productName,
      productManufacturer: productManufacturer,
      isToBuy: isToBuy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Преобразует объект в JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'productManufacturer': productManufacturer,
      'isToBuy': isToBuy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toOfflineJson() {
    return {
      'id': id,
      'productName': productName,
      'productManufacturer': productManufacturer,
      'isToBuy': isToBuy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
