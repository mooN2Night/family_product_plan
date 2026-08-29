import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/services/day_change/i_day_change_notifier.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'today_tasks_event.dart';

part 'today_tasks_state.dart';

/// Блок управлением состоянием экрана семьи
final class TodayTasksBloc extends Bloc<TodayTasksEvent, TodayTasksState> {
  TodayTasksBloc({
    required ITasksRepository taskRepository,
    required IDayChangeNotifier dayChangeNotifier,
  }) : _taskRepository = taskRepository,
       _dayChangeNotifier = dayChangeNotifier,
       super(const TodayTasksInitialState()) {
    on<TodayTasksStartedEvent>(_started);
    on<_TodayTasksUpdatedEvent>(_updated);
    on<_TodayTasksErrorEvent>(_onStreamError);

    _dayChangeSubscription = _dayChangeNotifier.onDayChanged.listen((_) {
      add(const TodayTasksStartedEvent());
    });
  }

  /// Репозиторий задачи
  final ITasksRepository _taskRepository;

  final IDayChangeNotifier _dayChangeNotifier;

  /// Подписка на прослушивание состояния списка задач
  StreamSubscription<List<TaskEntity>>? _subscription;
  StreamSubscription<void>? _dayChangeSubscription;

  /// Метод для отслеживания обновления статуса задач.
  Future<void> _started(
    TodayTasksStartedEvent event,
    Emitter<TodayTasksState> emit,
  ) async {
    emit(const TodayTasksLoadingState());

    await _subscription?.cancel();
    _subscription = _taskRepository.watchTodayTasks().listen(
      (tasks) => add(_TodayTasksUpdatedEvent(tasks: tasks)),
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        add(_TodayTasksErrorEvent(message: error.toString()));
      },
    );
  }

  /// Метод для обновления статуса задач.
  Future<void> _updated(
    _TodayTasksUpdatedEvent event,
    Emitter<TodayTasksState> emit,
  ) async => emit(TodayTasksSuccessState(tasks: event.tasks));

  Future<void> _onStreamError(
    _TodayTasksErrorEvent event,
    Emitter<TodayTasksState> emit,
  ) async {
    emit(TodayTasksErrorState(message: event.message));
  }

  @override
  Future<void> close() async {
    await _dayChangeSubscription?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}
