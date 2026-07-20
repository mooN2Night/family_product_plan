import 'package:path_provider/path_provider.dart';

import 'i_path_provider.dart';

/// Реализация сервиса для получения путей к директориям приложения.
final class AppPathProvider implements IPathProvider {
  const AppPathProvider();

  @override
  Future<String> getAppDocumentsDirectoryPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }
}
