import 'package:equatable/equatable.dart';

import '../../../../app/services/database/sync_operation_type.dart';

final class PendingSyncEntity extends Equatable {
  const PendingSyncEntity({
    required this.id,
    required this.type,
    required this.entityId,
    required this.payload,
    required this.createdAt,
  });

  final String id;

  final SyncOperationType type;

  final String entityId;

  final String? payload;

  final DateTime createdAt;

  @override
  List<Object?> get props => [id, type, entityId, payload, createdAt];
}
