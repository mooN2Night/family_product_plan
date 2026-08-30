import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entity/product_entity.dart';
import '../../dto/product_dto.dart';

/// Интерфейс удалённого источника данных для работы с продуктами.
abstract interface class IProductsRemoteDataSource {
  /// Возвращает поток изменений списка продуктов семьи.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchProducts({
    required String familyId,
  });

  /// Получает список продуктов семьи.
  Future<List<ProductDto>> getProducts({required String familyId});

  /// Добавляет продукт в удалённую базу данных.
  Future<void> addProduct({
    required String familyId,
    required ProductEntity product,
  });

  /// Обновляет продукт в удалённой базе данных.
  Future<ProductEntity?> updateProduct({
    required String familyId,
    required ProductEntity product,
  });

  /// Удаляет продукт из удалённой базы данных.
  Future<ProductEntity?> markDeleted({
    required String familyId,
    required String productId,
    required DateTime updatedAt,
  });
}
