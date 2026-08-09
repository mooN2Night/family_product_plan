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
