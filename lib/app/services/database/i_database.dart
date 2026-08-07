import 'app_database.dart';

/// Интерфес локальной бд.
abstract interface class IDatabase {
  /// Возвращает поток со списком всех продуктов. Обновляется автоматически при изменении данных.
  Stream<List<Product>> watchAllProducts();

  /// Добавляет новый продукт в базу данных.
  /// Возвращает идентификатор созданной записи.
  Future<int> insertProduct(ProductsCompanion entity);

  /// Обновляет существующий продукт.
  Future<void> updateProduct(Product entity);

  /// Удаляет продукт по его идентификатору.
  Future<int> deleteProductById(String id);

  /// Получает продукт по его идентификатору.
  Future<Product> getProductById(String id);

  /// Полностью заменяет список продуктов.
  Future<void> replaceProducts(List<Product> entity);

  /// Добавляет новый продукт или обновляет существующий.
  Future<void> upsertProduct(Product product);

  /// Возвращает список всех продуктов.
  Future<List<Product>> getProducts();

  /// Удаляет все продукты из базы данных.
  Future<void> clearProducts();

  Future<void> insertPendingSyncOperation(
    PendingSyncOperationsCompanion entity,
  );

  Future<void> updatePendingSyncOperation(PendingSyncOperation entity);

  Future<void> deletePendingSyncOperationById(String id);

  Future<List<PendingSyncOperation>> getPendingSyncOperations();

  Stream<List<PendingSyncOperation>> watchPendingSyncOperations();

  Future<void> clearPendingSyncOperations();

  Future<PendingSyncOperation?> getPendingSyncOperationByEntityId(
    String entityId,
  );

  Stream<List<Task>> watchTodayTasks();

  Future<List<Task>> getUrgentTasks();

  Future<List<Task>> getHighPriorityTasks();

  Future<List<Task>> getMediumPriorityTasks();

  Future<List<Task>> getLowPriorityTasks();

  Future<void> insertTask(TasksCompanion entity);

  Future<void> updateTask(Task entity);

  Future<void> upsertTask(Task entity);

  Future<void> replaceTasks(List<Task> tasks);

  Future<Task> getTaskById(String id);

  Future<void> deleteTask(Task entity);

  Future<void> clearTasks();
}
