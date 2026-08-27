part of 'overdue_tasks_bloc.dart';

/// Базовое состояние.
sealed class OverdueTasksState extends Equatable {
  const OverdueTasksState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class OverdueTasksInitialState extends OverdueTasksState {
  const OverdueTasksInitialState();
}

/// Состояние загрузки.
final class OverdueTasksLoadingState extends OverdueTasksState {
  const OverdueTasksLoadingState();
}

/// Состояния успешного получения информации.
final class OverdueTasksSuccessState extends OverdueTasksState {
  const OverdueTasksSuccessState({required this.tasks});

  /// Список задач.
  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

/// Состояние ошибки
final class OverdueTasksErrorState extends OverdueTasksState {
  const OverdueTasksErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
