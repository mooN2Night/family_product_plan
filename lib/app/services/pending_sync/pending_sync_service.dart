import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../../features/home/data/data_source/remote/i_product_remote_data_source.dart';
import '../../../features/home/data/dto/product_dto.dart';
import '../../../features/home/domain/entity/product_entity.dart';
import '../../../features/pending_sync/data/data_source/local/i_pending_sync_local_data_source.dart';
import '../../../features/pending_sync/domain/entity/pending_sync_entity.dart';
import '../database/sync_operation_type.dart';
import '../family/i_current_family_provider.dart';
import '../network/i_network_service.dart';
import 'i_pending_sync_service.dart';

final class PendingSyncService implements IPendingSyncService {
  PendingSyncService({
    required IPendingSyncLocalDataSource localDataSource,
    required IProductsRemoteDataSource remoteDataSource,
    required ICurrentFamilyProvider currentFamilyProvider,
    required INetworkService networkService,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _currentFamilyProvider = currentFamilyProvider,
       _networkService = networkService;

  final IPendingSyncLocalDataSource _localDataSource;
  final IProductsRemoteDataSource _remoteDataSource;
  final ICurrentFamilyProvider _currentFamilyProvider;
  final INetworkService _networkService;

  static const _uuid = Uuid();

  @override
  Future<void> enqueueAdd(ProductEntity product) async {
    await _localDataSource.addOperation(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.add,
        entityId: product.id,
        payload: jsonEncode(product.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> enqueueUpdate(ProductEntity product) async {
    await _localDataSource.addOperation(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.update,
        entityId: product.id,
        payload: jsonEncode(product.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> enqueueDelete(String productId) async {
    await _localDataSource.addOperation(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.delete,
        entityId: productId,
        payload: null,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> processQueue() async {
    if (!await _networkService.hasInternet()) {
      return;
    }

    final familyId = await _currentFamilyProvider.getCurrentFamilyId();

    if (familyId == null) {
      return;
    }

    final operations = await _localDataSource.getOperations();

    for (final operation in operations) {
      try {
        switch (operation.type) {
          case SyncOperationType.add:
            await _processAdd(familyId, operation);

          case SyncOperationType.update:
            await _processUpdate(familyId, operation);

          case SyncOperationType.delete:
            await _processDelete(familyId, operation);
        }

        await _localDataSource.deleteOperation(operation.id);
      } on Object {
        break;
      }
    }
  }

  Future<void> _processAdd(String familyId, PendingSyncEntity operation) async {
    final product = ProductDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    await _remoteDataSource.addProduct(familyId: familyId, product: product);
  }

  Future<void> _processUpdate(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    final product = ProductDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    await _remoteDataSource.updateProduct(familyId: familyId, product: product);
  }

  Future<void> _processDelete(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    await _remoteDataSource.deleteProduct(
      familyId: familyId,
      productId: operation.entityId,
    );
  }
}
