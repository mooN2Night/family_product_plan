import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entity/product_entity.dart';
import '../../dto/product_dto.dart';

abstract interface class IProductsRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchProducts({
    required String familyId,
  });

  Future<List<ProductDto>> getProducts({
    required String familyId,
  });

  Future<void> addProduct({
    required String familyId,
    required ProductEntity product,
  });

  Future<void> updateProduct({
    required String familyId,
    required ProductEntity product,
  });

  Future<void> deleteProduct({
    required String familyId,
    required String productId,
  });
}