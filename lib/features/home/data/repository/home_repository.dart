import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/app/mapper/app_product_mapper.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/services/family/i_current_family_provider.dart';
import '../../domain/entity/product_create_entity.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/repository/i_home_repository.dart';
import '../data_source/local/i_products_local_data_source.dart';
import '../data_source/remote/i_product_remote_data_source.dart';
import '../dto/product_dto.dart';

/// Реализация репозитория для работы с главной страницей.
final class HomeRepository implements IHomeRepository {
  HomeRepository({
    required IProductsLocalDataSource localDataSource,
    required IProductsRemoteDataSource remoteDataSource,
    required ICurrentFamilyProvider currentFamilyProvider,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _currentFamilyProvider = currentFamilyProvider {
    _familySubscription = _currentFamilyProvider.watchCurrentFamilyId().listen((
      familyId,
    ) {
      unawaited(_restartRemoteSync(familyId));
    });
  }

  /// Реализация локального хранения продуктов
  final IProductsLocalDataSource _localDataSource;

  /// Реализация удаленного хранения продуктов
  final IProductsRemoteDataSource _remoteDataSource;

  final ICurrentFamilyProvider _currentFamilyProvider;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _remoteSubscription;

  StreamSubscription<String?>? _familySubscription;

  bool _initialized = false;

  static const _uuid = Uuid();

  @override
  Stream<List<ProductEntity>> watchProducts() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchProducts().map(
      (e) => e.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Future<void> addProduct(ProductCreateEntity product) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final entity = ProductEntity(
      id: id,
      productName: product.productName,
      productManufacturer: product.productManufacturer,
      isToBuy: product.isToBuy,
      createdAt: now,
      updatedAt: now,
    );

    await _localDataSource.addProduct(entity);
    unawaited(_syncAdd(entity));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _localDataSource.deleteProduct(id);
    unawaited(_syncDelete(id));
  }

  @override
  Future<ProductEntity> getProduct(String id) async {
    final product = await _localDataSource.getProduct(id);

    return product.toEntity();
  }

  @override
  Future<void> toggleProductStatus(ProductEntity product) async {
    final updatedProduct = product.copyWith(
      isToBuy: !product.isToBuy,
      updatedAt: DateTime.now(),
    );

    await _localDataSource.updateProduct(updatedProduct);
    unawaited(_syncUpdate(updatedProduct));
  }

  @override
  Future<void> moveLocalProductsToFamily() async {
    final familyId = await _familyId();
    if (familyId == null) return;

    final localProducts = await _localDataSource.getProducts();

    for (final product in localProducts) {
      await _remoteDataSource.addProduct(
        familyId: familyId,
        product: product.toEntity(),
      );
    }
  }

  @override
  Future<void> clearLocalProducts() {
    return _localDataSource.clearProducts();
  }

  Future<String?> _familyId() {
    return _currentFamilyProvider.getCurrentFamilyId();
  }

  Future<void> _restartRemoteSync(String? familyId) async {
    await _remoteSubscription?.cancel();
    _remoteSubscription = null;

    if (familyId == null) {
      await _localDataSource.replaceProducts([]);
      return;
    }

    _remoteSubscription = _remoteDataSource
        .watchProducts(familyId: familyId)
        .listen(
          (snapshot) {
            for (final change in snapshot.docChanges) {
              final product = ProductDto.fromJson(
                change.doc.data()!,
              ).toEntity();

              switch (change.type) {
                case DocumentChangeType.added:
                  unawaited(_localDataSource.upsertProduct(product));
                  break;

                case DocumentChangeType.modified:
                  unawaited(_localDataSource.upsertProduct(product));
                  break;

                case DocumentChangeType.removed:
                  unawaited(_localDataSource.deleteProduct(product.id));
                  break;
              }
            }
          },
          onError: (error, stackTrace) {
            debugPrint('Remote sync error: $error');
          },
        );
  }

  Future<void> _syncAdd(ProductEntity product) async {
    final familyId = await _familyId();
    if (familyId == null) return;

    await _remoteDataSource.addProduct(familyId: familyId, product: product);
  }

  Future<void> _syncDelete(String id) async {
    final familyId = await _familyId();
    if (familyId == null) return;
    await _remoteDataSource.deleteProduct(familyId: familyId, productId: id);
  }

  Future<void> _syncUpdate(ProductEntity product) async {
    final familyId = await _familyId();
    if (familyId == null) return;
    await _remoteDataSource.updateProduct(familyId: familyId, product: product);
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    _initialized = true;

    _familySubscription = _currentFamilyProvider.watchCurrentFamilyId().listen((
      familyId,
    ) {
      unawaited(_restartRemoteSync(familyId));
    });
  }

  Future<void> dispose() async {
    await _remoteSubscription?.cancel();
    await _familySubscription?.cancel();
  }
}
