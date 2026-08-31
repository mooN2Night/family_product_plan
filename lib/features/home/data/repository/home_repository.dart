import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/app/mapper/app_product_mapper.dart';
import 'package:family_product_plan/app/services/network/i_network_service.dart';
import 'package:family_product_plan/app/services/pending_sync/i_pending_sync_service.dart';
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
    required IPendingSyncService pendingSyncService,
    required INetworkService networkService,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _currentFamilyProvider = currentFamilyProvider,
       _pendingSyncService = pendingSyncService,
       _networkService = networkService;

  /// Локальный источник данных.
  final IProductsLocalDataSource _localDataSource;

  /// Удалённый источник данных.
  final IProductsRemoteDataSource _remoteDataSource;

  /// Провайдер текущей выбранной семьи.
  final ICurrentFamilyProvider _currentFamilyProvider;

  /// Провайдер текущей выбранной семьи.
  final INetworkService _networkService;

  /// Провайдер текущей выбранной семьи.
  final IPendingSyncService _pendingSyncService;

  /// Подписка на изменения продуктов в удалённом хранилище.
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _remoteSubscription;

  /// Подписка на изменение текущей семьи.
  StreamSubscription<String?>? _familySubscription;

  /// Признак завершения инициализации репозитория.
  bool _initialized = false;

  /// Генератор уникальных идентификаторов.
  static const _uuid = Uuid();

  @override
  Stream<List<ProductEntity>> watchProducts() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchProducts().map(
      (products) =>
          products.map((e) => e.toEntity()).where((e) => !e.isDeleted).toList(),
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
      quantity: product.quantity ?? '',
      description: product.description ?? '',
      isToBuy: product.isToBuy,
      createdAt: now,
      updatedAt: now,
      isDeleted: false,
    );

    await _localDataSource.addProduct(entity);
    if (await _networkService.hasInternet()) {
      unawaited(_syncAdd(entity));
    } else {
      await _pendingSyncService.enqueueProductAdd(entity);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final product = await _localDataSource.getProduct(id);
    final deletedProduct = product.toEntity().copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );

    await _localDataSource.updateProduct(deletedProduct);
    if (await _networkService.hasInternet()) {
      unawaited(_syncDelete(deletedProduct));
    } else {
      await _pendingSyncService.enqueueProductDelete(deletedProduct);
    }
  }

  @override
  Future<ProductEntity> getProduct(String id) async {
    final product = await _localDataSource.getProduct(id);

    return product.toEntity();
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    await _localDataSource.updateProduct(product);
    if (await _networkService.hasInternet()) {
      unawaited(_syncUpdate(product));
    } else {
      await _pendingSyncService.enqueueProductUpdate(product);
    }
  }

  @override
  Future<void> toggleProductStatus(ProductEntity product) async {
    final updatedProduct = product.copyWith(updatedAt: DateTime.now());

    await _localDataSource.updateProduct(updatedProduct);
    if (await _networkService.hasInternet()) {
      unawaited(_syncUpdate(updatedProduct));
    } else {
      await _pendingSyncService.enqueueProductUpdate(updatedProduct);
    }
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

  /// Возвращает идентификатор текущей семьи.
  Future<String?> _familyId() {
    return _currentFamilyProvider.getCurrentFamilyId();
  }

  /// Перезапускает синхронизацию продуктов при смене семьи.
  Future<void> _restartRemoteSync(String? familyId) async {
    await _remoteSubscription?.cancel();
    _remoteSubscription = null;

    if (familyId == null) return;

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
                  if (!product.isDeleted) {
                    unawaited(_handleRemoteProduct(product));
                  }
                  break;

                case DocumentChangeType.modified:
                  unawaited(_handleRemoteProduct(product));
                  break;
                case DocumentChangeType.removed:
                  break;
              }
            }
          },
          onError: (error, stackTrace) {
            debugPrint('Remote sync error: $error');
          },
        );
  }

  Future<void> _handleRemoteProduct(ProductEntity remoteProduct) async {
    if (remoteProduct.isDeleted) {
      await _localDataSource.deleteProduct(remoteProduct.id);
      return;
    }

    try {
      final localProduct = await _localDataSource.getProduct(remoteProduct.id);
      final local = localProduct.toEntity();

      if (local.updatedAt.isAfter(remoteProduct.updatedAt)) {
        await _syncUpdate(local);
        return;
      }

      await _localDataSource.upsertProduct(remoteProduct);
    } catch (_) {
      await _localDataSource.upsertProduct(remoteProduct);
    }
  }

  /// Синхронизирует добавление продукта с удалённым хранилищем.
  Future<void> _syncAdd(ProductEntity product) async {
    final familyId = await _familyId();
    if (familyId == null) return;

    await _remoteDataSource.addProduct(familyId: familyId, product: product);
  }

  /// Синхронизирует удаление продукта с удалённым хранилищем.
  Future<void> _syncDelete(ProductEntity deletedProduct) async {
    final familyId = await _familyId();
    if (familyId == null) return;

    final remoteProduct = await _remoteDataSource.markDeleted(
      familyId: familyId,
      productId: deletedProduct.id,
      updatedAt: deletedProduct.updatedAt,
    );
    if (remoteProduct != null) {
      await _localDataSource.upsertProduct(remoteProduct);
    }
  }

  /// Синхронизирует обновление продукта с удалённым хранилищем.
  Future<void> _syncUpdate(ProductEntity product) async {
    final familyId = await _familyId();
    if (familyId == null) return;
    await _remoteDataSource.updateProduct(familyId: familyId, product: product);
  }

  /// Выполняет первоначальную инициализацию репозитория.
  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    _initialized = true;

    _familySubscription = _currentFamilyProvider.watchCurrentFamilyId().listen((
      familyId,
    ) {
      unawaited(_restartRemoteSync(familyId));
    });
  }

  /// Освобождает ресурсы репозитория.
  Future<void> dispose() async {
    await _remoteSubscription?.cancel();
    await _familySubscription?.cancel();
  }
}
