import 'package:path_provider/path_provider.dart';

/// Сервис для получения путей к директориям приложения.
final class AppPathProvider {
  const AppPathProvider();

  /// Возвращает путь к директории документов приложения.
  Future<String> getAppDocumentsDirectoryPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }
}
