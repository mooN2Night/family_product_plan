import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/product_entity.dart';

final class ProductDto {
  const ProductDto({
    required this.id,
    required this.productName,
    required this.productManufacturer,
    required this.isToBuy,
    required this.createdAt,
    required this.updatedAt,
  });

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

  final String id;
  final String productName;
  final String productManufacturer;
  final bool isToBuy;
  final DateTime createdAt;
  final DateTime updatedAt;

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
}
