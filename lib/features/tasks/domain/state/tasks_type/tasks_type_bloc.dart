import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:family_product_plan/features/tasks/utils/task_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'tasks_type_event.dart';

part 'tasks_type_state.dart';

/// Блок управлением состоянием экрана семьи
final class TasksTypeBloc extends Bloc<TasksTypeEvent, TasksTypeState> {
  TasksTypeBloc({required ITasksRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TasksTypeInitialState()) {
    on<TasksTypeRequestedEvent>(_loadTasks);
  }

  /// Репозиторий задач
  final ITasksRepository _taskRepository;

  /// Метод для загрузки задач по типу приоритета.
  Future<void> _loadTasks(
    TasksTypeRequestedEvent event,
    Emitter<TasksTypeState> emit,
  ) async {
    if (state is TasksTypeLoadingState) return;
    emit(const TasksTypeLoadingState());

    try {
      final List<TaskEntity> tasks;

      switch (event.type) {
        case TaskType.oneTime:
          tasks = await _taskRepository.getOneTimeTasks();
        case TaskType.daily:
          tasks = await _taskRepository.getDailyTasks();
        case TaskType.weekly:
          tasks = await _taskRepository.getWeaklyTasks();
        case TaskType.monthly:
          tasks = await _taskRepository.getMonthlyTasks();
        case TaskType.yearly:
          tasks = await _taskRepository.getYearlyTasks();
      }

      emit(TasksTypeSuccessState(tasks: tasks));
    } on AppException catch (error, stackTrace) {
      emit(TasksTypeErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
