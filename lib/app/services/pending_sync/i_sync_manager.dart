abstract interface class ISyncManager {
  /// Запускает прослушивание сети.
  Future<void> start();

  /// Освобождает ресурсы.
  Future<void> dispose();
}