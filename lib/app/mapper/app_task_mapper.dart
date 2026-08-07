import 'package:drift/drift.dart';

import '../../features/tasks/domain/entity/task_entity.dart';
import '../../features/tasks/utils/task_priority.dart';
import '../../features/tasks/utils/task_type.dart';
import '../services/database/app_database.dart';

/// Преобразование модели Drift в доменную сущность.
extension TaskMapper on Task {
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
      isActive: isActive,
      sortOrder: sortOrder,
      assignedUserId: assignedUserId,
      createdBy: createdBy,
    );
  }
}

/// Преобразование сущности в модель Drift.
extension TaskEntityMapper on TaskEntity {
  Task toDatabaseModel() {
    return Task(
      id: id,
      title: title,
      description: description,
      type: type.name,
      priority: priority.name,
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

  TasksCompanion toCompanion() {
    return TasksCompanion.insert(
      id: id,
      title: title,
      type: type.name,
      priority: priority.name,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      description: Value(description),
      dueDate: Value(dueDate),
      completedAt: Value(completedAt),
      lastExecutionAt: Value(lastExecutionAt),
      nextExecutionAt: Value(nextExecutionAt),
      isCompleted: Value(isCompleted),
      isDeleted: Value(isDeleted),
      isActive: Value(isActive),
      assignedUserId: Value(assignedUserId),
    );
  }
}
