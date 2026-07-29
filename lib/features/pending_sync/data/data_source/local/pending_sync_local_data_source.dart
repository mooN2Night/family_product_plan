import '../../../../../app/mapper/app_pending_sync_operation_mapper.dart';
import '../../../../../app/services/database/i_database.dart';
import '../../../domain/entity/pending_sync_entity.dart';
import 'i_pending_sync_local_data_source.dart';

final class PendingSyncLocalDataSource implements IPendingSyncLocalDataSource {
  PendingSyncLocalDataSource({required IDatabase database})
    : _database = database;

  final IDatabase _database;

  @override
  Future<void> addOperation(PendingSyncEntity operation) {
    return _database.insertPendingSyncOperation(operation.toCompanion());
  }

  @override
  Future<void> updateOperation(PendingSyncEntity operation) {
    return _database.updatePendingSyncOperation(operation.toDatabaseModel());
  }

  @override
  Future<List<PendingSyncEntity>> getOperations() async {
    final operations = await _database.getPendingSyncOperations();

    return operations.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<PendingSyncEntity>> watchOperations() {
    return _database.watchPendingSyncOperations().map(
      (operations) => operations.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Future<void> deleteOperation(String id) {
    return _database.deletePendingSyncOperationById(id);
  }

  @override
  Future<void> clearOperations() {
    return _database.clearPendingSyncOperations();
  }

  @override
  Future<PendingSyncEntity?> getOperationByEntityId(String entityId) async {
    final operation = await _database.getPendingSyncOperationByEntityId(entityId);

    return operation?.toEntity();
  }
}
