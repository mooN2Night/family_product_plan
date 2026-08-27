import 'package:family_product_plan/app/services/pending_sync/sync_status.dart';
import 'package:family_product_plan/features/tasks/domain/entity/task_entity.dart';

import '../../../features/home/domain/entity/product_entity.dart';

abstract interface class IPendingSyncService {
  /// Добавляет операцию создания продукта в очередь.
  Future<void> enqueueProductAdd(ProductEntity entity);

  /// Добавляет операцию создания задачи в очередь.
  Future<void> enqueueTaskAdd(TaskEntity entity);

  /// Добавляет операцию обновления продукта в очередь.
  Future<void> enqueueProductUpdate(ProductEntity entity);

  /// Добавляет операцию обновления задачи в очередь.
  Future<void> enqueueTaskUpdate(TaskEntity entity);

  /// Добавляет операцию удаления продукта в очередь.
  Future<void> enqueueProductDelete(ProductEntity entity);

  /// Добавляет операцию удаления задачи в очередь.
  Future<void> enqueueTaskDelete(TaskEntity entity);

  /// Выполняет синхронизацию всех операций.
  Future<void> processQueue();

  Stream<SyncStatus> watchStatus();
}
