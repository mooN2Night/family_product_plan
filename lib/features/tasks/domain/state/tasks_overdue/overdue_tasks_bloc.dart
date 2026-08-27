import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'overdue_tasks_event.dart';

part 'overdue_tasks_state.dart';

final class OverdueTasksBloc extends Bloc<OverdueTasksEvent, OverdueTasksState>
    with WidgetsBindingObserver {
  OverdueTasksBloc({required ITasksRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const OverdueTasksInitialState()) {
    on<OverdueTasksStartedEvent>(_started);
    on<OverdueTasksUpdatedEvent>(_updated);

    WidgetsBinding.instance.addObserver(this);
  }

  final ITasksRepository _taskRepository;

  StreamSubscription<List<TaskEntity>>? _subscription;
  Timer? _dayChangeTimer;

  DateTime _currentDate = _dateOnly(DateTime.now());

  Future<void> _started(
    OverdueTasksStartedEvent event,
    Emitter<OverdueTasksState> emit,
  ) async {
    emit(const OverdueTasksLoadingState());

    await _subscription?.cancel();
    _subscription = _taskRepository.watchOverdueTasks().listen(
      (tasks) => add(OverdueTasksUpdatedEvent(tasks: tasks)),
    );

    _scheduleDayChange();
  }

  Future<void> _updated(
    OverdueTasksUpdatedEvent event,
    Emitter<OverdueTasksState> emit,
  ) async {
    emit(OverdueTasksSuccessState(tasks: event.tasks));
  }

  void _scheduleDayChange() {
    _dayChangeTimer?.cancel();

    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1);
    final duration = nextDay.difference(now);

    _dayChangeTimer = Timer(duration, () {
      if (isClosed) return;

      _currentDate = _dateOnly(DateTime.now());
      add(const OverdueTasksStartedEvent());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    final currentDate = _dateOnly(DateTime.now());

    if (!_isSameDate(_currentDate, currentDate)) {
      _currentDate = currentDate;

      add(const OverdueTasksStartedEvent());
      return;
    }

    _scheduleDayChange();
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _isSameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);

    _dayChangeTimer?.cancel();
    await _subscription?.cancel();

    return super.close();
  }
}
