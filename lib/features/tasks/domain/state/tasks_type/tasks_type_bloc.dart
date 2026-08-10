import 'dart:async';
import 'package:equatable/equatable.dart';
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
    on<TasksTypeRequestedEvent>(_onRequested);
    on<TasksTypeUpdatedEvent>(_onUpdated);
    on<TasksTypeClosedEvent>(_onClosed);
  }

  /// Репозиторий задач
  final ITasksRepository _taskRepository;

  StreamSubscription<List<TaskEntity>>? _tasksSubscription;

  /// Метод для загрузки задач по типу приоритета.
  Future<void> _onRequested(
    TasksTypeRequestedEvent event,
    Emitter<TasksTypeState> emit,
  ) async {
    await _tasksSubscription?.cancel();
    emit(const TasksTypeLoadingState());

    final stream = switch (event.type) {
      TaskType.oneTime => _taskRepository.watchOneTimeTasks(),
      TaskType.daily => _taskRepository.watchDailyTasks(),
      TaskType.weekly => _taskRepository.watchWeaklyTasks(),
      TaskType.monthly => _taskRepository.watchMonthlyTasks(),
      TaskType.yearly => _taskRepository.watchYearlyTasks(),
    };

    _tasksSubscription = stream.listen(
      (tasks) {
        add(TasksTypeUpdatedEvent(tasks: tasks));
      },
      onError: (error, stackTrace) {
        addError(error, stackTrace);
      },
    );
  }

  void _onUpdated(TasksTypeUpdatedEvent event, Emitter<TasksTypeState> emit) {
    emit(TasksTypeSuccessState(tasks: event.tasks));
  }

  Future<void> _onClosed(
    TasksTypeClosedEvent event,
    Emitter<TasksTypeState> emit,
  ) async {
    await _tasksSubscription?.cancel();
    _tasksSubscription = null;
  }

  @override
  Future<void> close() async {
    await _tasksSubscription?.cancel();
    return super.close();
  }
}
