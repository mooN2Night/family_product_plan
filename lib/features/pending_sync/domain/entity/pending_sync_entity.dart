import 'package:equatable/equatable.dart';

import '../../../../app/services/database/sync_operation_type.dart';

final class PendingSyncEntity extends Equatable {
  const PendingSyncEntity({
    required this.id,
    required this.type,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.lastAttemptAt,
    this.lastError,
  });

  final String id;

  final SyncOperationType type;

  final SyncEntityType entityType;

  final String entityId;

  final String? payload;

  final DateTime createdAt;

  /// Количество неудачных попыток синхронизации.
  final int retryCount;

  /// Последняя попытка отправки.
  final DateTime? lastAttemptAt;

  /// Последняя ошибка.
  final String? lastError;

  PendingSyncEntity copyWith({
    String? id,
    SyncOperationType? type,
    SyncEntityType? entityType,
    String? entityId,
    String? payload,
    DateTime? createdAt,
    int? retryCount,
    DateTime? lastAttemptAt,
    String? lastError,
  }) {
    return PendingSyncEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    entityType,
    entityId,
    payload,
    createdAt,
    retryCount,
    lastAttemptAt,
    lastError,
  ];
}
