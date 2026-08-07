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
  }

  /// Репозиторий задачи
  final ITasksRepository _taskRepository;

  /// Подписка на прослушивание состояния списка задач
  StreamSubscription<List<TaskEntity>>? _subscription;

  /// Метод для отслеживания обновления статуса задач.
  Future<void> _started(
    TodayTasksStartedEvent event,
    Emitter<TodayTasksState> emit,
  ) async {
    emit(const TodayTasksLoadingState());

    await _subscription?.cancel();
    _subscription = _taskRepository.watchTodayTasks().listen(
      (tasks) => add(TodayTasksUpdatedEvent(tasks: tasks)),
    );
  }

  /// Метод для обновления статуса задач.
  Future<void> _updated(
    TodayTasksUpdatedEvent event,
    Emitter<TodayTasksState> emit,
  ) async => emit(TodayTasksSuccessState(tasks: event.tasks));

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
