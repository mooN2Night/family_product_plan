import 'dart:async';

import 'package:flutter/material.dart';

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
  Timer? _retryTimer;

  static const _retryInterval = Duration(seconds: 30);

  @override
  Future<void> start() async {
    _subscription?.cancel();

    _subscription = _networkService.watchConnection().listen(
      (connected) {
        if (!connected) return;

        unawaited(_pendingSyncService.processQueue());
      },
      onError: (error, stackTrace) {
        debugPrint('SyncManager connectivity stream error: $error');
      },
    );

    // Проверяем сразу при старте — на случай, если уже онлайн
    // и watchConnection не эмитит текущее значение сразу.
    if (await _networkService.hasInternet()) {
      unawaited(_pendingSyncService.processQueue());
    }

    // Периодически пробуем разгрести очередь, чтобы отработал backoff
    // из PendingSyncService даже без смены состояния сети.
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(_retryInterval, (_) {
      unawaited(_pendingSyncService.processQueue());
    });
  }

  @override
  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _subscription?.cancel();
  }
}
