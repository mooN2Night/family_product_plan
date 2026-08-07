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

final class TodayTasksUpdatedEvent extends TodayTasksEvent {
  const TodayTasksUpdatedEvent({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}
