part of 'overdue_tasks_bloc.dart';

/// Класс базового события.
sealed class OverdueTasksEvent extends Equatable {
  const OverdueTasksEvent();

  @override
  List<Object?> get props => [];
}

final class OverdueTasksStartedEvent extends OverdueTasksEvent {
  const OverdueTasksStartedEvent();
}

final class OverdueTasksUpdatedEvent extends OverdueTasksEvent {
  const OverdueTasksUpdatedEvent({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}
