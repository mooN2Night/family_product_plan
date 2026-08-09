import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/features/tasks/domain/entity/task_entity.dart';
import 'package:family_product_plan/features/tasks/utils/task_type.dart';

import '../../utils/task_priority.dart';

/// DTO задачи
final class TaskDto {
  const TaskDto({
    required this.id,
    required this.title,
    required this.type,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
    required this.isDeleted,
    required this.sortOrder,
    required this.createdBy,
    this.description,
    this.dueDate,
    this.completedAt,
    this.lastExecutionAt,
    this.nextExecutionAt,
    this.assignedUserId,
  });

  /// Создает DTO из JSON.
  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      priority: json['priority'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      dueDate: (json['dueDate'] as Timestamp?)?.toDate(),
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
      lastExecutionAt: (json['lastExecutionAt'] as Timestamp?)?.toDate(),
      nextExecutionAt: (json['nextExecutionAt'] as Timestamp?)?.toDate(),
      isCompleted: json['isCompleted'] as bool,
      isDeleted: json['isDeleted'] as bool,
      sortOrder: json['sortOrder'] as int,
      assignedUserId: json['assignedUserId'] as String?,
      createdBy: json['createdBy'] as String,
    );
  }

  factory TaskDto.fromJsonOffline(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      priority: json['priority'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      lastExecutionAt: json['lastExecutionAt'] == null
          ? null
          : DateTime.parse(json['lastExecutionAt'] as String),
      nextExecutionAt: json['nextExecutionAt'] == null
          ? null
          : DateTime.parse(json['nextExecutionAt'] as String),
      isCompleted: json['isCompleted'] as bool,
      isDeleted: json['isDeleted'] as bool,
      sortOrder: json['sortOrder'] as int,
      assignedUserId: json['assignedUserId'] as String?,
      createdBy: json['createdBy'] as String,
    );
  }

  /// Уникальный идентификатор
  final String id;

  /// Название
  final String title;

  /// Описание
  final String? description;

  /// Тип задачи
  final String type;

  /// Тип приоритета задачи
  final String priority;

  /// Дата создания
  final DateTime createdAt;

  /// Дата обновления
  final DateTime updatedAt;

  /// Срок выполенения задачи
  final DateTime? dueDate;

  /// Когда задача была выполнена
  final DateTime? completedAt;

  /// Поле для повторяющихся задач, показывает дату выполнения
  final DateTime? lastExecutionAt;

  /// Дата следующего выполнения.
  final DateTime? nextExecutionAt;

  /// Флаг, выполенена ли одноразовая задача
  final bool isCompleted;

  /// Флаг, были ли задача удалена
  final bool isDeleted;

  /// Порядок отображения
  final int sortOrder;

  /// Кому адресована задача
  final String? assignedUserId;

  /// Кто создал задачу
  final String createdBy;

  /// Преобразует DTO в доменную сущность.
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      type: TaskType.fromString(type),
      priority: TaskPriority.fromString(priority),
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate,
      completedAt: completedAt,
      lastExecutionAt: lastExecutionAt,
      nextExecutionAt: nextExecutionAt,
      isCompleted: isCompleted,
      isDeleted: isDeleted,
      sortOrder: sortOrder,
      assignedUserId: assignedUserId,
      createdBy: createdBy,
    );
  }

  /// Преобразует объект в JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'priority': priority.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
      'completedAt': completedAt == null
          ? null
          : Timestamp.fromDate(completedAt!),
      'lastExecutionAt': lastExecutionAt == null
          ? null
          : Timestamp.fromDate(lastExecutionAt!),
      'nextExecutionAt': nextExecutionAt == null
          ? null
          : Timestamp.fromDate(nextExecutionAt!),
      'isCompleted': isCompleted,
      'isDeleted': isDeleted,
      'sortOrder': sortOrder,
      'assignedUserId': assignedUserId,
      'createdBy': createdBy,
    };
  }

  Map<String, dynamic> toOfflineJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'lastExecutionAt': lastExecutionAt?.toIso8601String(),
      'nextExecutionAt': nextExecutionAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'isDeleted': isDeleted,
      'sortOrder': sortOrder,
      'assignedUserId': assignedUserId,
      'createdBy': createdBy,
    };
  }
}
