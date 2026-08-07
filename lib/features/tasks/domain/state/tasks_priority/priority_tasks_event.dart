part of 'priority_tasks_bloc.dart';

/// Класс базового события.
sealed class PriorityTasksEvent extends Equatable {
  const PriorityTasksEvent();

  @override
  List<Object?> get props => [];
}

final class PriorityTasksRequestedEvent extends PriorityTasksEvent {
  const PriorityTasksRequestedEvent({required this.priority});

  final TaskPriority priority;

  @override
  List<Object?> get props => [priority];
}
