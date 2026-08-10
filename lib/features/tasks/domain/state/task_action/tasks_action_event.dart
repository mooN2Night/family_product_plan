part of 'tasks_action_bloc.dart';

/// Класс базового события.
sealed class TasksActionEvent extends Equatable {
  const TasksActionEvent();

  @override
  List<Object?> get props => [];
}

final class TasksActionAddEvent extends TasksActionEvent {
  const TasksActionAddEvent({required this.task});

  final CreateTaskEntity task;

  @override
  List<Object?> get props => [task];
}

final class TasksActionCompleteEvent extends TasksActionEvent {
  const TasksActionCompleteEvent({required this.task});

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

final class TasksActionRestoreEvent extends TasksActionEvent {
  const TasksActionRestoreEvent({required this.task});

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}
