import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/features/tasks/utils/task_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'tasks_type_event.dart';

part 'tasks_type_state.dart';

/// Блок управлением состоянием экрана семьи
final class TasksTypeBloc extends Bloc<TasksTypeEvent, TasksTypeState>
    with WidgetsBindingObserver {
  TasksTypeBloc({required ITasksRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TasksTypeInitialState()) {
    on<TasksTypeRequestedEvent>(_onRequested);
    on<TasksTypeUpdatedEvent>(_onUpdated);
    on<TasksTypeClosedEvent>(_onClosed);

    WidgetsBinding.instance.addObserver(this);
  }

  /// Репозиторий задач
  final ITasksRepository _taskRepository;

  StreamSubscription<List<TaskEntity>>? _tasksSubscription;

  TaskType? _currentType;

  Timer? _dayChangeTimer;

  DateTime _currentDate = _dateOnly(DateTime.now());

  /// Метод для загрузки задач по типу приоритета.
  Future<void> _onRequested(
    TasksTypeRequestedEvent event,
    Emitter<TasksTypeState> emit,
  ) async {
    _currentType = event.type;
    _currentDate = _dateOnly(DateTime.now());

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

    if (_currentType == TaskType.oneTime) {
      _scheduleDayChange();
    } else {
      _dayChangeTimer?.cancel();
      _dayChangeTimer = null;
    }
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

  void _scheduleDayChange() {
    _dayChangeTimer?.cancel();

    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    final duration = nextDay.difference(now);

    _dayChangeTimer = Timer(duration, () {
      if (isClosed) return;

      _currentDate = _dateOnly(DateTime.now());

      add(TasksTypeRequestedEvent(type: TaskType.oneTime));
    });
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _isSameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    // Обновление даты нужно только для разовых задач.
    // Остальные типы не должны реагировать на lifecycle.
    if (_currentType != TaskType.oneTime) return;

    final currentDate = _dateOnly(DateTime.now());
    if (!_isSameDate(_currentDate, currentDate)) {
      _currentDate = currentDate;

      add(TasksTypeRequestedEvent(type: TaskType.oneTime));
      return;
    }

    _scheduleDayChange();
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);

    _dayChangeTimer?.cancel();
    await _tasksSubscription?.cancel();
    return super.close();
  }
}
