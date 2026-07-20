/// Сервис для получения путей к директориям приложения.
abstract interface class IPathProvider {
  /// Возвращает путь к директории документов приложения.
  Future<String> getAppDocumentsDirectoryPath();
}
