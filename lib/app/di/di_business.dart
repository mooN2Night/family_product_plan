import '../services/pending_sync/i_pending_sync_service.dart';
import '../services/pending_sync/i_sync_manager.dart';
import '../services/pending_sync/pending_sync_service.dart';
import '../services/pending_sync/sync_manager.dart';
import 'di_container.dart';

final class DiBusiness {
  /// Сервис кеширования запросов при отсутствии интернета.
  late final IPendingSyncService pendingSyncService;

  /// Сервис синхронизации запросов после появления интернета.
  late final ISyncManager syncManager;

  /// Инициализирует репозитории приложения.
  void init({required DiContainer diContainer}) {
    pendingSyncService = PendingSyncService(
      localDataSource: diContainer.dataSource.pendingSyncLocalDataSource,
      remoteDataSource: diContainer.dataSource.productsRemoteDataSource,
      currentFamilyProvider: diContainer.services.currentFamilyProvider,
      networkService: diContainer.services.networkService,
    );

    syncManager = SyncManager(
      networkService: diContainer.services.networkService,
      pendingSyncService: pendingSyncService,
    );
  }
}
