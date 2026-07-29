import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/services/pending_sync/i_pending_sync_service.dart';
import '../../../../app/services/pending_sync/sync_status.dart';

final class SyncCubit extends Cubit<SyncStatus> {
  SyncCubit({required IPendingSyncService pendingSyncService})
    : _pendingSyncService = pendingSyncService,
      super(const SyncStatus.idle(0)) {
    _subscription = _pendingSyncService.watchStatus().listen(emit);
  }

  final IPendingSyncService _pendingSyncService;

  StreamSubscription<SyncStatus>? _subscription;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
