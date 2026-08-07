import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/tasks/data/dto/task_dto.dart';

import '../../utils/task_priority.dart';
import '../../utils/task_type.dart';

/// Сущность задачи
final class TaskEntity extends Equatable {
  const TaskEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
    required this.isDeleted,
    required this.isActive,
    required this.sortOrder,
    required this.createdBy,
    this.description,
    this.dueDate,
    this.completedAt,
    this.lastExecutionAt,
    this.nextExecutionAt,
    this.assignedUserId,
  });

  /// Уникальный идентификатор
  final String id;

  /// Название
  final String title;

  /// Описание
  final String? description;

  /// Тип задачи
  final TaskType type;

  /// Тип приоритета задачи
  final TaskPriority priority;

  /// Дата создания
  final DateTime createdAt;

  /// Дата обновления
  final DateTime updatedAt;

  /// Срок выполенения задачи
  final DateTime? dueDate;

  /// Когда задача была выполнена
  final DateTime? completedAt;

  /// Дата последнего выполнения.
  final DateTime? lastExecutionAt;

  /// Дата следующего выполнения.
  final DateTime? nextExecutionAt;

  /// Флаг, выполенена ли одноразовая задача
  final bool isCompleted;

  /// Флаг, были ли задача удалена
  final bool isDeleted;

  /// Показывать ли задачу в общем списке
  final bool isActive;

  /// Порядок отображения
  final int sortOrder;

  /// Кому адресована задача
  final String? assignedUserId;

  /// Кто создал задачу
  final String createdBy;

  /// Преобразует сущность в DTO.
  TaskDto toDto() {
    return TaskDto(
      id: id,
      title: title,
      description: description,
      type: type.toString(),
      priority: priority.toString(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate,
      completedAt: completedAt,
      lastExecutionAt: lastExecutionAt,
      nextExecutionAt: nextExecutionAt,
      isCompleted: isCompleted,
      isDeleted: isDeleted,
      isActive: isActive,
      sortOrder: sortOrder,
      assignedUserId: assignedUserId,
      createdBy: createdBy,
    );
  }

  /// Метод для частичного обновления полей
  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    TaskType? type,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    DateTime? lastExecutionAt,
    DateTime? nextExecutionAt,
    bool? isCompleted,
    bool? isDeleted,
    bool? isActive,
    int? sortOrder,
    String? assignedUserId,
    String? createdBy,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      lastExecutionAt: lastExecutionAt ?? this.lastExecutionAt,
      nextExecutionAt: nextExecutionAt ?? this.nextExecutionAt,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    priority,
    createdAt,
    updatedAt,
    dueDate,
    completedAt,
    lastExecutionAt,
    nextExecutionAt,
    isCompleted,
    isDeleted,
    isActive,
    sortOrder,
    assignedUserId,
    createdBy,
  ];
}
