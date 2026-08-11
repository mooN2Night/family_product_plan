import 'package:uuid/uuid.dart';

import '../../domain/entity/create_task_entity.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/repository/i_tasks_repository.dart';
import '../../utils/task_type.dart';
import '../data_source/local/i_tasks_local_data_source.dart';

final class TasksRepository implements ITasksRepository {
  const TasksRepository({required ITasksLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final ITasksLocalDataSource _localDataSource;

  @override
  Stream<List<TaskEntity>> watchTodayTasks() async* {
    await _prepareTasksForToday();

    yield* _localDataSource.watchTodayTasks();
  }

  @override
  Stream<List<TaskEntity>> watchOneTimeTasks() {
    return _localDataSource.watchOneTimeTasks();
  }

  @override
  Stream<List<TaskEntity>> watchDailyTasks() {
    return _localDataSource.watchDailyTasks();
  }

  @override
  Stream<List<TaskEntity>> watchWeaklyTasks() {
    return _localDataSource.watchWeaklyTasks();
  }

  @override
  Stream<List<TaskEntity>> watchMonthlyTasks() {
    return _localDataSource.watchMonthlyTasks();
  }

  @override
  Stream<List<TaskEntity>> watchYearlyTasks() {
    return _localDataSource.watchYearlyTasks();
  }

  @override
  Future<TaskEntity> getTask(String id) {
    return _localDataSource.getTaskById(id);
  }

  @override
  Future<void> createTask(CreateTaskEntity createTask) {
    final now = DateTime.now();

    final nextExecutionAt = _calculateInitialNextExecutionAt(
      type: createTask.type,
      dueDate: createTask.dueDate,
    );

    final task = TaskEntity(
      id: const Uuid().v4(),
      title: createTask.title,
      description: createTask.description,
      type: createTask.type,
      priority: createTask.priority,
      createdAt: now,
      updatedAt: now,
      dueDate: createTask.dueDate,
      completedAt: null,
      lastExecutionAt: null,
      nextExecutionAt: nextExecutionAt,
      isCompleted: false,
      isDeleted: false,
      sortOrder: 0,
      assignedUserId: createTask.assignedUserId,
      createdBy: createTask.createdBy,
    );

    return _localDataSource.insertTask(task);
  }

  @override
  Future<void> updateTask(TaskEntity task) {
    return _localDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(TaskEntity task) {
    return _localDataSource.deleteTask(task);
  }

  @override
  Future<void> completeTask(TaskEntity task) async {
    final now = DateTime.now();

    final executionDate = _dateOnly(now);

    final nextExecutionAt = _calculateNextExecutionDate(task: task);

    await _localDataSource.updateTask(
      task.copyWith(
        isCompleted: true,
        completedAt: executionDate,
        updatedAt: executionDate,
        nextExecutionAt: nextExecutionAt,
        lastExecutionAt: task.nextExecutionAt,
      ),
    );
  }

  @override
  Future<void> restoreTask(TaskEntity task) async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final nextExecutionAt = switch (task.type) {
      TaskType.oneTime => task.dueDate,
      TaskType.daily => today,
      TaskType.weekly => task.lastExecutionAt,
      TaskType.monthly => task.lastExecutionAt,
      TaskType.yearly => task.lastExecutionAt,
    };

    await _localDataSource.updateTask(
      task.copyWith(
        isCompleted: false,
        completedAt: null,
        nextExecutionAt: nextExecutionAt,
        updatedAt: today,
      ),
    );
  }

  @override
  Future<void> syncTasks() {
    // Firebase реализуем позжеtask.lastExecutionAt
    throw UnimplementedError();
  }

  DateTime? _calculateInitialNextExecutionAt({
    required TaskType type,
    required DateTime? dueDate,
  }) {
    switch (type) {
      case TaskType.oneTime:
        return null;
      case TaskType.daily:
        return _dateOnly(DateTime.now());
      case TaskType.weekly:
      case TaskType.monthly:
      case TaskType.yearly:
        return dueDate;
    }
  }

  DateTime? _calculateNextExecutionDate({required TaskEntity task}) {
    final nextExecutionAt = task.nextExecutionAt;

    if (nextExecutionAt == null) return null;

    switch (task.type) {
      case TaskType.oneTime:
        return null;
      case TaskType.daily:
        return nextExecutionAt.add(const Duration(days: 1));
      case TaskType.weekly:
        return nextExecutionAt.add(const Duration(days: 7));
      case TaskType.monthly:
        final dueDate = task.dueDate;

        if (dueDate == null) return null;

        final nextMonth = DateTime(
          nextExecutionAt.year,
          nextExecutionAt.month + 1,
          1,
        );

        final lastDayOfNextMonth = DateTime(
          nextMonth.year,
          nextMonth.month + 1,
          0,
        ).day;

        return DateTime(
          nextMonth.year,
          nextMonth.month,
          dueDate.day > lastDayOfNextMonth ? lastDayOfNextMonth : dueDate.day,
        );
      case TaskType.yearly:
        final dueDate = task.dueDate;

        if (dueDate == null) return null;

        final nextYear = DateTime(nextExecutionAt.year + 1, dueDate.month, 1);

        final lastDayOfMonth = DateTime(
          nextYear.year,
          dueDate.month + 1,
          0,
        ).day;

        return DateTime(
          nextYear.year,
          dueDate.month,
          dueDate.day > lastDayOfMonth ? lastDayOfMonth : dueDate.day,
        );
    }
  }

  DateTime? _calculateNextExecutionDateAfter({
    required TaskEntity task,
    required DateTime from,
    required DateTime today,
  }) {
    var nextDate = from;

    switch (task.type) {
      case TaskType.oneTime:
        return null;
      case TaskType.daily:
        do {
          nextDate = nextDate.add(const Duration(days: 1));
        } while (nextDate.isBefore(today));

        return nextDate;
      case TaskType.weekly:
        do {
          nextDate = nextDate.add(const Duration(days: 7));
        } while (nextDate.isBefore(today));

        return nextDate;
      case TaskType.monthly:
        final dueDate = task.dueDate;
        if (dueDate == null) return null;

        do {
          final nextMonth = DateTime(nextDate.year, nextDate.month + 1, 1);

          final lastDayOfMonth = DateTime(
            nextMonth.year,
            nextMonth.month + 1,
            0,
          ).day;

          nextDate = DateTime(
            nextMonth.year,
            nextMonth.month,
            dueDate.day > lastDayOfMonth ? lastDayOfMonth : dueDate.day,
          );
        } while (nextDate.isBefore(today));

        return nextDate;
      case TaskType.yearly:
        final dueDate = task.dueDate;
        if (dueDate == null) return null;

        do {
          final nextYear = DateTime(nextDate.year + 1, dueDate.month, 1);

          final lastDayOfMonth = DateTime(
            nextYear.year,
            dueDate.month + 1,
            0,
          ).day;

          nextDate = DateTime(
            nextYear.year,
            dueDate.month,
            dueDate.day > lastDayOfMonth ? lastDayOfMonth : dueDate.day,
          );
        } while (nextDate.isBefore(today));

        return nextDate;
    }
  }

  Future<void> _prepareTasksForToday() async {
    final today = _dateOnly(DateTime.now());

    final tasks = await _localDataSource.getRecurringTasks();

    for (final task in tasks) {
      final nextExecutionAt = task.nextExecutionAt;
      if (nextExecutionAt == null) continue;

      final nextExecutionDate = _dateOnly(nextExecutionAt);
      // Следующее выполнение ещё не наступило.
      if (nextExecutionDate.isAfter(today)) continue;

      // Если задача уже выполнена сегодня,
      // ничего с ней не делаем.
      if (task.isCompleted &&
          task.completedAt != null &&
          _isSameDate(task.completedAt!, today)) {
        continue;
      }

      final nextDate = _calculateNextExecutionDateAfter(
        task: task,
        from: nextExecutionDate,
        today: today,
      );

      if (nextDate == null) continue;

      await _localDataSource.updateTask(
        task.copyWith(
          isCompleted: false,
          completedAt: null,
          nextExecutionAt: nextDate,
          updatedAt: today,
        ),
      );
    }
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
