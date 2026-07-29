import 'package:equatable/equatable.dart';

enum SyncState { idle, syncing, success, error }

final class SyncStatus extends Equatable {
  const SyncStatus({
    required this.state,
    required this.pendingOperations,
    this.error,
  });

  final SyncState state;
  final int pendingOperations;
  final String? error;

  const SyncStatus.idle(int pending)
    : this(state: SyncState.idle, pendingOperations: pending);

  const SyncStatus.syncing(int pending)
    : this(state: SyncState.syncing, pendingOperations: pending);

  const SyncStatus.success()
    : this(state: SyncState.success, pendingOperations: 0);

  const SyncStatus.error({required int pending, required String error})
    : this(state: SyncState.error, pendingOperations: pending, error: error);

  @override
  List<Object?> get props => [state, pendingOperations, error];
}
