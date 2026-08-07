part of 'priority_tasks_bloc.dart';

/// Базовое состояние.
sealed class PriorityTasksState extends Equatable {
  const PriorityTasksState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class PriorityTasksInitialState extends PriorityTasksState {
  const PriorityTasksInitialState();
}

/// Состояние загрузки.
final class PriorityTasksLoadingState extends PriorityTasksState {
  const PriorityTasksLoadingState();
}

/// Состояния успешного получения информации.
final class PriorityTasksSuccessState extends PriorityTasksState {
  const PriorityTasksSuccessState({required this.tasks});

  /// Список задач.
  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

/// Состояние ошибки
final class PriorityTasksErrorState extends PriorityTasksState {
  const PriorityTasksErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
