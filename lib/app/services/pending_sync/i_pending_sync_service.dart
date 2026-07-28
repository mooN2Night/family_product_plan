import '../../../features/home/domain/entity/product_entity.dart';

abstract interface class IPendingSyncService {
  /// Добавляет операцию создания продукта в очередь.
  Future<void> enqueueAdd(ProductEntity product);

  /// Добавляет операцию обновления продукта в очередь.
  Future<void> enqueueUpdate(ProductEntity product);

  /// Добавляет операцию удаления продукта в очередь.
  Future<void> enqueueDelete(String productId);

  /// Выполняет синхронизацию всех операций.
  Future<void> processQueue();
}