import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/services/day_change/i_day_change_notifier.dart';
import '../../entity/task_entity.dart';
import '../../repository/i_tasks_repository.dart';

part 'overdue_tasks_event.dart';

part 'overdue_tasks_state.dart';

final class OverdueTasksBloc
    extends Bloc<OverdueTasksEvent, OverdueTasksState> {
  OverdueTasksBloc({
    required ITasksRepository taskRepository,
    required IDayChangeNotifier dayChangeNotifier,
  }) : _taskRepository = taskRepository,
       _dayChangeNotifier = dayChangeNotifier,
       super(const OverdueTasksInitialState()) {
    on<OverdueTasksStartedEvent>(_started);
    on<_OverdueTasksUpdatedEvent>(_updated);
    on<_OverdueTasksErrorEvent>(_onStreamError);

    _dayChangeSubscription = _dayChangeNotifier.onDayChanged.listen((_) {
      add(const OverdueTasksStartedEvent());
    });
  }

  final ITasksRepository _taskRepository;
  final IDayChangeNotifier _dayChangeNotifier;

  StreamSubscription<List<TaskEntity>>? _subscription;
  StreamSubscription<void>? _dayChangeSubscription;

  Future<void> _started(
    OverdueTasksStartedEvent event,
    Emitter<OverdueTasksState> emit,
  ) async {
    emit(const OverdueTasksLoadingState());

    await _subscription?.cancel();
    _subscription = _taskRepository.watchOverdueTasks().listen(
      (tasks) => add(_OverdueTasksUpdatedEvent(tasks: tasks)),
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        add(_OverdueTasksErrorEvent(message: error.toString()));
      },
    );
  }

  Future<void> _updated(
    _OverdueTasksUpdatedEvent event,
    Emitter<OverdueTasksState> emit,
  ) async {
    emit(OverdueTasksSuccessState(tasks: event.tasks));
  }

  Future<void> _onStreamError(
    _OverdueTasksErrorEvent event,
    Emitter<OverdueTasksState> emit,
  ) async {
    emit(OverdueTasksErrorState(message: event.message));
  }

  @override
  Future<void> close() async {
    await _dayChangeSubscription?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}
