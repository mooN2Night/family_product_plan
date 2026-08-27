import 'dart:convert';

import 'package:family_product_plan/app/services/pending_sync/sync_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../../features/home/data/data_source/local/i_products_local_data_source.dart';
import '../../../features/home/data/data_source/remote/i_product_remote_data_source.dart';
import '../../../features/home/data/dto/product_dto.dart';
import '../../../features/home/domain/entity/product_entity.dart';
import '../../../features/pending_sync/data/data_source/local/i_pending_sync_local_data_source.dart';
import '../../../features/pending_sync/domain/entity/pending_sync_entity.dart';
import '../../../features/tasks/data/data_source/local/i_tasks_local_data_source.dart';
import '../../../features/tasks/data/data_source/remote/i_tasks_remote_data_source.dart';
import '../../../features/tasks/data/dto/task_dto.dart';
import '../../../features/tasks/domain/entity/task_entity.dart';
import '../database/sync_operation_type.dart';
import '../family/i_current_family_provider.dart';
import '../network/i_network_service.dart';
import 'i_pending_sync_service.dart';

final class PendingSyncService implements IPendingSyncService {
  PendingSyncService({
    required IPendingSyncLocalDataSource localDataSource,
    required IProductsRemoteDataSource productsRemoteDataSource,
    required IProductsLocalDataSource productsLocalDataSource,
    required ITasksRemoteDataSource tasksRemoteDataSource,
    required ITasksLocalDataSource tasksLocalDataSource,
    required ICurrentFamilyProvider currentFamilyProvider,
    required INetworkService networkService,
  }) : _localDataSource = localDataSource,
       _productsRemoteDataSource = productsRemoteDataSource,
       _productsLocalDataSource = productsLocalDataSource,
       _tasksRemoteDataSource = tasksRemoteDataSource,
       _tasksLocalDataSource = tasksLocalDataSource,
       _currentFamilyProvider = currentFamilyProvider,
       _networkService = networkService;

  final IPendingSyncLocalDataSource _localDataSource;

  final IProductsRemoteDataSource _productsRemoteDataSource;
  final IProductsLocalDataSource _productsLocalDataSource;

  final ITasksRemoteDataSource _tasksRemoteDataSource;
  final ITasksLocalDataSource _tasksLocalDataSource;

  final ICurrentFamilyProvider _currentFamilyProvider;
  final INetworkService _networkService;

  final _statusController = BehaviorSubject<SyncStatus>.seeded(
    const SyncStatus.idle(0),
  );

  static const _uuid = Uuid();
  bool _processing = false;

  @override
  Future<void> enqueueProductAdd(ProductEntity entity) {
    return _enqueue(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.add,
        entityType: SyncEntityType.product,
        entityId: entity.id,
        payload: jsonEncode(entity.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> enqueueTaskAdd(TaskEntity entity) {
    return _enqueue(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.add,
        entityType: SyncEntityType.task,
        entityId: entity.id,
        payload: jsonEncode(entity.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> enqueueProductUpdate(ProductEntity entity) {
    return _enqueue(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.update,
        entityType: SyncEntityType.product,
        entityId: entity.id,
        payload: jsonEncode(entity.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> enqueueTaskUpdate(TaskEntity entity) {
    return _enqueue(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.update,
        entityType: SyncEntityType.task,
        entityId: entity.id,
        payload: jsonEncode(entity.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> enqueueProductDelete(ProductEntity entity) {
    final deletedProduct = entity.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );

    return _enqueue(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.delete,
        entityType: SyncEntityType.product,
        entityId: entity.id,
        payload: jsonEncode(deletedProduct.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> enqueueTaskDelete(TaskEntity entity) {
    final deletedTask = entity.copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
    );

    return _enqueue(
      PendingSyncEntity(
        id: _uuid.v4(),
        type: SyncOperationType.delete,
        entityType: SyncEntityType.task,
        entityId: entity.id,
        payload: jsonEncode(deletedTask.toDto().toOfflineJson()),
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> processQueue() async {
    if (_processing) return;
    _processing = true;

    try {
      if (!await _networkService.hasInternet()) return;

      final familyId = await _currentFamilyProvider.getCurrentFamilyId();
      if (familyId == null) return;

      final operations = await _localDataSource.getOperations();
      if (operations.isEmpty) {
        await _emitIdle();
        return;
      }

      _statusController.add(SyncStatus.syncing(operations.length));

      for (final operation in operations) {
        await _processOperation(familyId, operation);

        final left = (await _localDataSource.getOperations()).length;
        _statusController.add(SyncStatus.syncing(left));
      }
      final pending = await _localDataSource.getOperations();

      if (pending.isEmpty) {
        _statusController.add(const SyncStatus.success());
      }

      await _emitIdle();
    } finally {
      _processing = false;
    }
  }

  @override
  Stream<SyncStatus> watchStatus() => _statusController.stream;

  Future<void> _emitIdle() async {
    final count = (await _localDataSource.getOperations()).length;

    _statusController.add(SyncStatus.idle(count));
  }

  Future<void> _enqueue(PendingSyncEntity operation) async {
    final existing = await _localDataSource.getOperationByEntityId(
      operation.entityId,
    );

    if (existing == null) {
      await _localDataSource.addOperation(operation);
      await _emitIdle();
      return;
    }

    switch (existing.type) {
      case SyncOperationType.add:
        await _handleExistingAdd(existing, operation);

      case SyncOperationType.update:
        await _handleExistingUpdate(existing, operation);

      case SyncOperationType.delete:
        await _handleExistingDelete(existing, operation);
    }
  }

  Future<void> _handleExistingAdd(
    PendingSyncEntity existing,
    PendingSyncEntity incoming,
  ) async {
    switch (incoming.type) {
      case SyncOperationType.add:
        return;

      case SyncOperationType.update:
        await _localDataSource.updateOperation(
          existing.copyWith(payload: incoming.payload),
        );
        await _emitIdle();
      case SyncOperationType.delete:
        await _localDataSource.deleteOperation(existing.id);
        await _emitIdle();
    }
  }

  Future<void> _handleExistingUpdate(
    PendingSyncEntity existing,
    PendingSyncEntity incoming,
  ) async {
    switch (incoming.type) {
      case SyncOperationType.add:
        return;
      case SyncOperationType.update:
        await _localDataSource.updateOperation(
          existing.copyWith(payload: incoming.payload),
        );

        await _emitIdle();
      case SyncOperationType.delete:
        await _localDataSource.updateOperation(
          existing.copyWith(type: SyncOperationType.delete, payload: null),
        );
        await _emitIdle();
    }
  }

  Future<void> _handleExistingDelete(
    PendingSyncEntity existing,
    PendingSyncEntity incoming,
  ) async {
    switch (incoming.type) {
      case SyncOperationType.add:
        await _localDataSource.updateOperation(
          existing.copyWith(
            type: SyncOperationType.add,
            payload: incoming.payload,
          ),
        );
        await _emitIdle();
      case SyncOperationType.update:
        return;

      case SyncOperationType.delete:
        return;
    }
  }

  Future<void> _processProductAdd(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    final product = ProductDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    await _productsRemoteDataSource.addProduct(
      familyId: familyId,
      product: product,
    );
  }

  Future<void> _processTaskAdd(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    final task = TaskDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    await _tasksRemoteDataSource.addTask(familyId: familyId, dto: task.toDto());
  }

  Future<void> _processProductUpdate(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    final localProduct = ProductDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    final remoteProduct = await _productsRemoteDataSource.updateProduct(
      familyId: familyId,
      product: localProduct,
    );

    if (remoteProduct != null) {
      await _productsLocalDataSource.upsertProduct(remoteProduct);
    }
  }

  Future<void> _processTaskUpdate(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    final task = TaskDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    final remoteTask = await _tasksRemoteDataSource.updateTask(
      familyId: familyId,
      dto: task.toDto(),
    );

    if (remoteTask != null) {
      await _tasksLocalDataSource.upsertTask(remoteTask);
    }
  }

  Future<void> _processProductDelete(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    final product = ProductDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    await _productsRemoteDataSource.markDeleted(
      familyId: familyId,
      productId: product.id,
      updatedAt: product.updatedAt,
    );
  }

  Future<void> _processTaskDelete(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    final task = TaskDto.fromJsonOffline(
      jsonDecode(operation.payload!) as Map<String, dynamic>,
    ).toEntity();

    final remoteTask = await _tasksRemoteDataSource.markDeleted(
      familyId: familyId,
      taskId: task.id,
      updatedAt: task.updatedAt,
    );

    if (remoteTask != null) {
      await _tasksLocalDataSource.upsertTask(remoteTask);
    }
  }

  Future<bool> _processOperation(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    if (!_canRetry(operation)) {
      debugPrint(
        'Skip retry ${operation.entityId}. '
        'Next retry in ${_retryDelay(operation.retryCount)}',
      );
      return false;
    }

    try {
      switch (operation.entityType) {
        case SyncEntityType.product:
          await _processProductOperation(familyId, operation);
        case SyncEntityType.task:
          await _processTaskOperation(familyId, operation);
      }
      // switch (operation.type) {
      //   case SyncOperationType.add:
      //     await _processAdd(familyId, operation);
      //   case SyncOperationType.update:
      //     await _processUpdate(familyId, operation);
      //   case SyncOperationType.delete:
      //     await _processDelete(familyId, operation);
      // }
      await _localDataSource.deleteOperation(operation.id);
      await _emitIdle();
      return true;
    } catch (error, stackTrace) {
      debugPrint('''
                  SYNC ERROR
                  operation: ${operation.type}
                  entity: ${operation.entityId}
                  retry: ${operation.retryCount}
                  error: $error
                  stackTrace: $stackTrace
                ''');

      final updated = operation.copyWith(
        retryCount: operation.retryCount + 1,
        lastAttemptAt: DateTime.now(),
        lastError: error.toString(),
      );

      await _localDataSource.updateOperation(updated);

      final pending = await _localDataSource.getOperations();

      _statusController.add(
        SyncStatus.error(pending: pending.length, error: error.toString()),
      );
      return false;
    }
  }

  Future<void> _processTaskOperation(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    switch (operation.type) {
      case SyncOperationType.add:
        await _processTaskAdd(familyId, operation);

      case SyncOperationType.update:
        await _processTaskUpdate(familyId, operation);

      case SyncOperationType.delete:
        await _processTaskDelete(familyId, operation);
    }
  }

  Future<void> _processProductOperation(
    String familyId,
    PendingSyncEntity operation,
  ) async {
    switch (operation.type) {
      case SyncOperationType.add:
        await _processProductAdd(familyId, operation);

      case SyncOperationType.update:
        await _processProductUpdate(familyId, operation);

      case SyncOperationType.delete:
        await _processProductDelete(familyId, operation);
    }
  }

  bool _canRetry(PendingSyncEntity operation) {
    if (operation.retryCount >= 10) {
      _statusController.add(
        SyncStatus.error(pending: 1, error: 'Max retry count reached'),
      );

      return false;
    }

    final lastAttempt = operation.lastAttemptAt;
    if (lastAttempt == null) return true;

    final delay = _retryDelay(operation.retryCount);
    return DateTime.now().difference(lastAttempt) >= delay;
  }

  Duration _retryDelay(int retryCount) {
    switch (retryCount) {
      case 0:
        return Duration.zero;
      case 1:
        return const Duration(seconds: 5);
      case 2:
        return const Duration(seconds: 30);
      case 3:
        return const Duration(minutes: 5);
      case 4:
        return const Duration(minutes: 30);
      default:
        return const Duration(hours: 2);
    }
  }

  Future<void> dispose() async {
    await _statusController.close();
  }
}
