import '../../../domain/entity/pending_sync_entity.dart';

abstract interface class IPendingSyncLocalDataSource {
  /// Добавляет новую операцию в очередь синхронизации.
  Future<void> addOperation(PendingSyncEntity operation);

  /// Обновляет существующую операцию.
  Future<void> updateOperation(PendingSyncEntity operation);

  /// Возвращает все операции из очереди.
  Future<List<PendingSyncEntity>> getOperations();

  /// Следит за изменениями очереди.
  Stream<List<PendingSyncEntity>> watchOperations();

  /// Удаляет операцию по идентификатору.
  Future<void> deleteOperation(String id);

  /// Полностью очищает очередь.
  Future<void> clearOperations();

  /// Получение оперции по id продукта
  Future<PendingSyncEntity?> getOperationByEntityId(String entityId);
}