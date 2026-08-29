part of 'tasks_type_bloc.dart';

/// Класс базового события.
sealed class TasksTypeEvent extends Equatable {
  const TasksTypeEvent();

  @override
  List<Object?> get props => [];
}

final class TasksTypeRequestedEvent extends TasksTypeEvent {
  const TasksTypeRequestedEvent({required this.type});

  final TaskType type;

  @override
  List<Object?> get props => [type];
}

final class TasksTypeUpdatedEvent extends TasksTypeEvent {
  const TasksTypeUpdatedEvent({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

final class TasksTypeClosedEvent extends TasksTypeEvent {
  const TasksTypeClosedEvent();
}

final class _TasksTypeErrorEvent extends TasksTypeEvent {
  const _TasksTypeErrorEvent({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
