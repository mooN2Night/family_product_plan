part of 'today_tasks_bloc.dart';

/// Класс базового события.
sealed class TodayTasksEvent extends Equatable {
  const TodayTasksEvent();

  @override
  List<Object?> get props => [];
}

final class TodayTasksStartedEvent extends TodayTasksEvent {
  const TodayTasksStartedEvent();
}

final class _TodayTasksUpdatedEvent extends TodayTasksEvent {
  const _TodayTasksUpdatedEvent({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

final class _TodayTasksErrorEvent extends TodayTasksEvent {
  const _TodayTasksErrorEvent({required this. message});

  final String message;

  @override
  List<Object?> get props => [message];
}
