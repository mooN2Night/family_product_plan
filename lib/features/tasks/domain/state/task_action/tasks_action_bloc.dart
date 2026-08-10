import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/create_task_entity.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'tasks_action_event.dart';

part 'tasks_action_state.dart';

/// Блок управлением состоянием добавления задачи
final class TasksActionBloc extends Bloc<TasksActionEvent, TasksActionState> {
  TasksActionBloc({required ITasksRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TasksActionInitialState()) {
    on<TasksActionAddEvent>(_addTask);
    on<TasksActionCompleteEvent>(_completeTask);
    on<TasksActionRestoreEvent>(_restoreTask);
  }

  /// Репозиторий задач
  final ITasksRepository _taskRepository;

  /// Метод для добавления задачи
  Future<void> _addTask(
    TasksActionAddEvent event,
    Emitter<TasksActionState> emit,
  ) async {
    if (state is TasksActionLoadingState) return;
    emit(const TasksActionLoadingState());

    try {
      await _taskRepository.createTask(event.task);
      emit(const TasksActionSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(TasksActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  Future<void> _completeTask(
    TasksActionCompleteEvent event,
    Emitter<TasksActionState> emit,
  ) async {
    if (state is TasksActionLoadingState) return;
    emit(const TasksActionLoadingState());

    try {
      await _taskRepository.completeTask(event.task);
      emit(const TasksActionSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(TasksActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  Future<void> _restoreTask(
    TasksActionRestoreEvent event,
    Emitter<TasksActionState> emit,
  ) async {
    if (state is TasksActionLoadingState) return;
    emit(const TasksActionLoadingState());

    try {
      await _taskRepository.restoreTask(event.task);
      emit(const TasksActionSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(TasksActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
