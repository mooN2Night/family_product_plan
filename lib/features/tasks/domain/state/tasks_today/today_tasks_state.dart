part of 'today_tasks_bloc.dart';

/// Базовое состояние.
sealed class TodayTasksState extends Equatable {
  const TodayTasksState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class TodayTasksInitialState extends TodayTasksState {
  const TodayTasksInitialState();
}

/// Состояние загрузки.
final class TodayTasksLoadingState extends TodayTasksState {
  const TodayTasksLoadingState();
}

/// Состояния успешного получения информации.
final class TodayTasksSuccessState extends TodayTasksState {
  const TodayTasksSuccessState({required this.tasks});

  /// Список задач.
  final List<TaskEntity> tasks;

  @override
  List<Object?> get props => [tasks];
}

/// Состояние ошибки
final class TodayTasksErrorState extends TodayTasksState {
  const TodayTasksErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
