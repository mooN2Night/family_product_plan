import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'task_info_event.dart';

part 'task_info_state.dart';

/// Блок управлением состоянием добавления задачи
final class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  TaskInfoBloc({required ITasksRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TaskInfoInitialState()) {
    on<TaskInfoRequestedEvent>(_loadTask);
  }

  /// Репозиторий задач
  final ITasksRepository _taskRepository;

  /// Метод для добавления задачи
  Future<void> _loadTask(
    TaskInfoRequestedEvent event,
    Emitter<TaskInfoState> emit,
  ) async {
    if (state is TaskInfoLoadingState) return;
    emit(const TaskInfoLoadingState());

    try {
      final task = await _taskRepository.getTask(event.id);
      emit(TaskInfoSuccessState(task: task));
    } on AppException catch (error, stackTrace) {
      emit(TaskInfoErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
