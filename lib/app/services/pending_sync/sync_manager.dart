import 'dart:async';

import '../network/i_network_service.dart';
import 'i_pending_sync_service.dart';
import 'i_sync_manager.dart';

final class SyncManager implements ISyncManager {
  SyncManager({
    required INetworkService networkService,
    required IPendingSyncService pendingSyncService,
  }) : _networkService = networkService,
       _pendingSyncService = pendingSyncService;

  final INetworkService _networkService;
  final IPendingSyncService _pendingSyncService;

  StreamSubscription<bool>? _subscription;

  @override
  Future<void> start() async {
    _subscription?.cancel();

    _subscription = _networkService.watchConnection().listen((connected) async {
      if (!connected) {
        return;
      }

      await _pendingSyncService.processQueue();
    });
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}
