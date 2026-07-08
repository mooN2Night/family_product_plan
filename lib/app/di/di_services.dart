import 'package:family_product_plan/app/database/app_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../path_provider/path_provider.dart';

/// Контейнер сервисов приложения.
final class DiServices {
  /// Сервис для получения путей к директориям приложения.
  late final AppPathProvider pathProvider;

  /// Экземпляр базы данных приложения.
  late final AppDatabase database;

  /// Сервис авторизации.
  late final FirebaseAuth firebaseAuth;

  /// Инициализирует сервисы приложения.
  Future<void> init() async {
    pathProvider = AppPathProvider();

    firebaseAuth = FirebaseAuth.instance;

    final path = await pathProvider.getAppDocumentsDirectoryPath();
    database = AppDatabase(path);
  }
}
