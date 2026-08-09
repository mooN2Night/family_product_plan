part of 'tasks_type_bloc.dart';

/// Базовое состояние.
sealed class TasksTypeState extends Equatable {
  const TasksTypeState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class TasksTypeInitialState extends TasksTypeState {
  const TasksTypeInitialState();
}

/// Состояние загрузки.
final class TasksTypeLoadingState extends TasksTypeState {
  const TasksTypeLoadingState();
}

/// Состояния успешного получения информации.
final class TasksTypeSuccessState extends TasksTypeState {
  const TasksTypeSuccessState({required this.tasks});

  /// Список задач.
  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

/// Состояние ошибки
final class TasksTypeErrorState extends TasksTypeState {
  const TasksTypeErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
