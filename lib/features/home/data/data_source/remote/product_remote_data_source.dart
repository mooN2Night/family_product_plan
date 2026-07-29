import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entity/product_entity.dart';
import '../../dto/product_dto.dart';
import 'i_product_remote_data_source.dart';

/// Реализация удалённого источника данных для работы с продуктами.
final class ProductsRemoteDataSource implements IProductsRemoteDataSource {
  const ProductsRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  /// Сервис удаленной бд.
  final FirebaseFirestore _firestore;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchProducts({
    required String familyId,
  }) => _collection(familyId).snapshots();

  @override
  Future<List<ProductDto>> getProducts({required String familyId}) async {
    final snapshot = await _collection(familyId).get();

    return snapshot.docs.map((e) => ProductDto.fromJson(e.data())).toList();
  }

  @override
  Future<void> addProduct({
    required String familyId,
    required ProductEntity product,
  }) => _collection(familyId).doc(product.id).set(product.toDto().toJson());

  @override
  Future<ProductEntity?> updateProduct({
    required String familyId,
    required ProductEntity product,
  }) async {
    final remoteProduct = await _getProduct(
      familyId: familyId,
      productId: product.id,
    );

    if (remoteProduct == null) return null;
    if (remoteProduct.updatedAt.isAfter(product.updatedAt)) {
      return remoteProduct.toEntity();
    }

    await _collection(familyId).doc(product.id).update({
      'productName': product.productName,
      'productManufacturer': product.productManufacturer,
      'isToBuy': product.isToBuy,
      'updatedAt': Timestamp.fromDate(product.updatedAt),
    });

    return null;
  }

  @override
  Future<void> markDeleted({
    required String familyId,
    required String productId,
    required DateTime updatedAt,
  }) {
    final now = DateTime.now();
    return _collection(familyId).doc(productId).update({
      'isDeleted': true,
      'updatedAt': Timestamp.fromDate(now),
    });
  }

  Future<ProductDto?> _getProduct({
    required String familyId,
    required String productId,
  }) async {
    final snapshot = await _collection(familyId).doc(productId).get();

    if (!snapshot.exists) {
      return null;
    }

    return ProductDto.fromJson(snapshot.data()!);
  }

  /// Возвращает коллекцию продуктов указанной семьи.
  CollectionReference<Map<String, dynamic>> _collection(String familyId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('products');
  }
}
