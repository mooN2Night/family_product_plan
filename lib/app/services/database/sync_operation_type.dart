/// Тип синхронизируемой операции
enum SyncOperationType {
  /// Добавление
  add,

  /// Обновление
  update,

  /// Удаление
  delete,
}

/// Тип синхронизируемого вида
enum SyncEntityType {
  /// Продукты
  product,

  /// Задачи
  task,
}
