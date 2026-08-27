import 'package:drift/drift.dart';

import '../../features/pending_sync/domain/entity/pending_sync_entity.dart';
import '../services/database/app_database.dart';
import '../services/database/sync_operation_type.dart';

extension PendingSyncMapper on PendingSyncOperation {
  PendingSyncEntity toEntity() {
    return PendingSyncEntity(
      id: id,
      type: SyncOperationType.values.byName(operation),
      entityType: SyncEntityType.values.byName(entityType),
      entityId: entityId,
      payload: payload,
      createdAt: createdAt,
      retryCount: retryCount,
      lastAttemptAt: lastAttemptAt,
      lastError: lastError,
    );
  }
}

extension PendingSyncEntityMapper on PendingSyncEntity {
  PendingSyncOperation toDatabaseModel() {
    return PendingSyncOperation(
      id: id,
      operation: type.name,
      entityType: entityType.name,
      entityId: entityId,
      payload: payload,
      createdAt: createdAt,
      retryCount: retryCount,
      lastAttemptAt: lastAttemptAt,
      lastError: lastError,
    );
  }

  PendingSyncOperationsCompanion toCompanion() {
    return PendingSyncOperationsCompanion.insert(
      id: id,
      operation: type.name,
      entityType: entityType.name,
      entityId: entityId,
      payload: Value(payload),
      createdAt: createdAt,
      retryCount: Value(retryCount),
      lastAttemptAt: Value(lastAttemptAt),
      lastError: Value(lastError),
    );
  }
}
