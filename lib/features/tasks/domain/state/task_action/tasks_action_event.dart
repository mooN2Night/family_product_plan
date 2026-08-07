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
