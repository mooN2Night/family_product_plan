import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entity/product_entity.dart';
import '../../dto/product_dto.dart';
import 'i_product_remote_data_source.dart';

final class ProductsRemoteDataSource implements IProductsRemoteDataSource {
  const ProductsRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchProducts({
    required String familyId,
  }) {
    return _collection(familyId).snapshots();
    // return _collection(familyId).snapshots().map(
    //   (snapshot) =>
    //       snapshot.docs.map((e) => ProductDto.fromJson(e.data())).toList(),
    // );
  }

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
  Future<void> updateProduct({
    required String familyId,
    required ProductEntity product,
  }) async {
    await _collection(familyId).doc(product.id).update({
      'productName': product.productName,
      'productManufacturer': product.productManufacturer,
      'isToBuy': product.isToBuy,
      'updatedAt': Timestamp.fromDate(product.updatedAt),
    });
  }

  @override
  Future<void> deleteProduct({
    required String familyId,
    required String productId,
  }) {
    return _collection(familyId).doc(productId).delete();
  }

  CollectionReference<Map<String, dynamic>> _collection(String familyId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('products');
  }
}
