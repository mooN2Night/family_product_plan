import 'package:equatable/equatable.dart';
import '../../utils/task_priority.dart';
import '../../utils/task_type.dart';

final class CreateTaskEntity extends Equatable {
  const CreateTaskEntity({
    required this.title,
    required this.type,
    required this.priority,
    required this.isActive,
    required this.createdBy,
    this.description,
    this.dueDate,
    this.nextExecutionAt,
    this.assignedUserId,
  });

  /// Название
  final String title;

  /// Описание
  final String? description;

  /// Тип задачи
  final TaskType type;

  /// Тип приоритета задачи
  final TaskPriority priority;

  /// Срок выполенения задачи
  final DateTime? dueDate;

  /// Дата следующего выполнения.
  final DateTime? nextExecutionAt;

  /// Показывать ли задачу в общем списке
  final bool isActive;

  /// Кому адресована задача
  final String? assignedUserId;

  /// Кто создал задачу
  final String createdBy;

  @override
  List<Object?> get props => [
    title,
    description,
    type,
    priority,
    dueDate,
    nextExecutionAt,
    isActive,
    assignedUserId,
    createdBy,
  ];
}