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

final class _OverdueTasksUpdatedEvent extends OverdueTasksEvent {
  const _OverdueTasksUpdatedEvent({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

final class _OverdueTasksErrorEvent extends OverdueTasksEvent {
  const _OverdueTasksErrorEvent({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
