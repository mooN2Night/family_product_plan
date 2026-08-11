part of 'task_info_bloc.dart';

/// Базовое состояние.
sealed class TaskInfoState extends Equatable {
  const TaskInfoState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class TaskInfoInitialState extends TaskInfoState {
  const TaskInfoInitialState();
}

/// Состояние загрузки.
final class TaskInfoLoadingState extends TaskInfoState {
  const TaskInfoLoadingState();
}

/// Состояния успешного получения информации.
final class TaskInfoSuccessState extends TaskInfoState {
  const TaskInfoSuccessState({required this.task});

  final TaskEntity task;

  @override
  List<Object?> get props => [task];
}

/// Состояние ошибки
final class TaskInfoErrorState extends TaskInfoState {
  const TaskInfoErrorState({required this.message});

  /// Ошибка.
  final String message;

  @override
  List<Object?> get props => [message];
}
