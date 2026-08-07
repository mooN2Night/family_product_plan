part of 'tasks_action_bloc.dart';

/// Базовое состояние.
sealed class TasksActionState extends Equatable {
  const TasksActionState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class TasksActionInitialState extends TasksActionState {
  const TasksActionInitialState();
}

/// Состояние загрузки.
final class TasksActionLoadingState extends TasksActionState {
  const TasksActionLoadingState();
}

/// Состояния успешного получения информации.
final class TasksActionSuccessState extends TasksActionState {
  const TasksActionSuccessState();
}

/// Состояние ошибки
final class TasksActionErrorState extends TasksActionState {
  const TasksActionErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
