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
    await _prepareRecurringTasksForToday();

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

    final executionDate = DateTime(now.year, now.month, now.day);

    final nextExecutionDate = _calculateNextExecutionDateForComplete(
      task: task,
      executionDate: executionDate,
    );

    await _localDataSource.updateTask(
      task.copyWith(
        isCompleted: true,
        completedAt: executionDate,
        updatedAt: executionDate,
        lastExecutionAt: executionDate,
        nextExecutionAt: nextExecutionDate,
      ),
    );
  }

  @override
  Future<void> restoreTask(TaskEntity task) async {
    await _localDataSource.updateTask(
      task.copyWith(
        isCompleted: false,
        completedAt: null,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> syncTasks() {
    // Firebase реализуем позже
    throw UnimplementedError();
  }

  DateTime? _calculateInitialNextExecutionAt({
    required TaskType type,
    required DateTime? dueDate,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (type) {
      case TaskType.oneTime:
        return dueDate;
      case TaskType.daily:
        return today;
      case TaskType.weekly:
        if (dueDate == null) return null;

        final daysUntilTarget = (dueDate.weekday - today.weekday + 7) % 7;

        return today.add(Duration(days: daysUntilTarget));
      case TaskType.monthly:
        if (dueDate == null) return null;

        final day = dueDate.day;

        final daysInCurrentMonth = DateTime(today.year, today.month + 1, 0).day;

        if (day <= daysInCurrentMonth) {
          final candidate = DateTime(today.year, today.month, day);

          if (!candidate.isBefore(today)) return candidate;
        }

        final nextMonth = DateTime(today.year, today.month + 1, 1);

        final daysInNextMonth = DateTime(
          nextMonth.year,
          nextMonth.month + 1,
          0,
        ).day;

        return DateTime(
          nextMonth.year,
          nextMonth.month,
          day > daysInNextMonth ? daysInNextMonth : day,
        );
      case TaskType.yearly:
        if (dueDate == null) return null;

        final month = dueDate.month;
        final day = dueDate.day;

        var candidate = DateTime(today.year, month, day);

        if (candidate.isBefore(today)) {
          candidate = DateTime(today.year + 1, month, day);
        }

        return candidate;
    }
  }

  DateTime? _calculateNextExecutionDateForComplete({
    required TaskEntity task,
    required DateTime executionDate,
  }) {
    final currentDate = DateTime(
      executionDate.year,
      executionDate.month,
      executionDate.day,
    );

    switch (task.type) {
      case TaskType.oneTime:
        return null;

      case TaskType.daily:
        return currentDate.add(const Duration(days: 1));

      case TaskType.weekly:
        final dueDate = task.dueDate;

        if (dueDate == null) {
          return null;
        }

        return currentDate.add(const Duration(days: 7));

      case TaskType.monthly:
        final dueDate = task.dueDate;

        if (dueDate == null) {
          return null;
        }

        final nextMonth = DateTime(currentDate.year, currentDate.month + 1, 1);

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

        if (dueDate == null) {
          return null;
        }

        final nextYear = DateTime(currentDate.year + 1, dueDate.month, 1);

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

  Future<void> _prepareRecurringTasksForToday() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final tasks = await _localDataSource.getRecurringTasks();

    for (final task in tasks) {
      if (task.nextExecutionAt == null) {
        continue;
      }

      final nextExecutionDate = DateTime(
        task.nextExecutionAt!.year,
        task.nextExecutionAt!.month,
        task.nextExecutionAt!.day,
      );

      if (nextExecutionDate.isAfter(today)) {
        continue;
      }

      if (task.isCompleted &&
          task.lastExecutionAt != null &&
          _isSameDate(task.lastExecutionAt!, today)) {
        continue;
      }

      final nextExecutionAt = _calculateNextExecutionDateForComplete(
        task: task,
        executionDate: today,
      );

      await _localDataSource.updateTask(
        task.copyWith(
          isCompleted: false,
          completedAt: null,
          nextExecutionAt: nextExecutionAt,
          updatedAt: today,
        ),
      );
    }
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
