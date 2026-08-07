import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/task_priority.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'priority_tasks_event.dart';

part 'priority_tasks_state.dart';

/// Блок управлением состоянием экрана семьи
final class PriorityTasksBloc
    extends Bloc<PriorityTasksEvent, PriorityTasksState> {
  PriorityTasksBloc({required ITasksRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const PriorityTasksInitialState()) {
    on<PriorityTasksRequestedEvent>(_loadTasks);
  }

  /// Репозиторий задач
  final ITasksRepository _taskRepository;

  /// Метод для загрузки задач по типу приоритета.
  Future<void> _loadTasks(
    PriorityTasksRequestedEvent event,
    Emitter<PriorityTasksState> emit,
  ) async {
    if (state is PriorityTasksLoadingState) return;
    emit(const PriorityTasksLoadingState());

    try {
      final List<TaskEntity> tasks;

      switch (event.priority) {
        case TaskPriority.low:
          tasks = await _taskRepository.getLowPriorityTasks();
        case TaskPriority.medium:
          tasks = await _taskRepository.getMediumPriorityTasks();
        case TaskPriority.high:
          tasks = await _taskRepository.getHighPriorityTasks();
        case TaskPriority.urgent:
          tasks = await _taskRepository.getUrgentTasks();
      }

      emit(PriorityTasksSuccessState(tasks: tasks));
    } on AppException catch (error, stackTrace) {
      emit(PriorityTasksErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
