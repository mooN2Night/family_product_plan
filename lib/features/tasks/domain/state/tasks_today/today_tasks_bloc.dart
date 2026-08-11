import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'today_tasks_event.dart';

part 'today_tasks_state.dart';

/// Блок управлением состоянием экрана семьи
final class TodayTasksBloc extends Bloc<TodayTasksEvent, TodayTasksState> {
  TodayTasksBloc({required ITasksRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TodayTasksInitialState()) {
    on<TodayTasksStartedEvent>(_started);
    on<TodayTasksUpdatedEvent>(_updated);
    on<TodayTasksDayChangedEvent>(_onDayChanged);
  }

  /// Репозиторий задачи
  final ITasksRepository _taskRepository;

  /// Подписка на прослушивание состояния списка задач
  StreamSubscription<List<TaskEntity>>? _subscription;

  Timer? _dayTimer;

  DateTime _currentDate = _dateOnly(DateTime.now());

  /// Метод для отслеживания обновления статуса задач.
  Future<void> _started(
    TodayTasksStartedEvent event,
    Emitter<TodayTasksState> emit,
  ) async {
    if (_subscription != null) return;
    emit(const TodayTasksLoadingState());

    await _subscribeToTasks();
    _currentDate = _dateOnly(DateTime.now());

    _startDayTimer();

    // emit(const TodayTasksLoadingState());
    //
    // await _subscription?.cancel();
    // _subscription = _taskRepository.watchTodayTasks().listen(
    //   (tasks) => add(TodayTasksUpdatedEvent(tasks: tasks)),
    // );
  }

  Future<void> _subscribeToTasks() async {
    await _subscription?.cancel();

    _subscription = _taskRepository.watchTodayTasks().listen(
      (tasks) {
        add(TodayTasksUpdatedEvent(tasks: tasks));
      },
      onError: (Object error, StackTrace stackTrace) {
        addError(error, stackTrace);
      },
    );
  }

  void _startDayTimer() {
    _dayTimer?.cancel();

    _dayTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final today = _dateOnly(DateTime.now());

      if (!_isSameDate(today, _currentDate)) {
        _currentDate = today;

        add(const TodayTasksDayChangedEvent());
      }
    });
  }

  Future<void> _onDayChanged(
    TodayTasksDayChangedEvent event,
    Emitter<TodayTasksState> emit,
  ) async {
    emit(const TodayTasksLoadingState());

    await _subscribeToTasks();
  }

  /// Метод для обновления статуса задач.
  Future<void> _updated(
    TodayTasksUpdatedEvent event,
    Emitter<TodayTasksState> emit,
  ) async => emit(TodayTasksSuccessState(tasks: event.tasks));

  @override
  Future<void> close() async {
    _dayTimer?.cancel();
    await _subscription?.cancel();

    _dayTimer = null;
    _subscription = null;

    return super.close();
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
