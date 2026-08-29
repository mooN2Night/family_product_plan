import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_product_plan/features/tasks/data/mapper/tasks_exception_mapper.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/services/family/i_current_family_provider.dart';
import '../../../../app/services/network/i_network_service.dart';
import '../../../../app/services/pending_sync/i_pending_sync_service.dart';
import '../../domain/entity/create_task_entity.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/repository/i_tasks_repository.dart';
import '../../utils/task_type.dart';
import '../data_source/local/i_tasks_local_data_source.dart';
import '../data_source/remote/i_tasks_remote_data_source.dart';
import '../dto/task_dto.dart';

final class TasksRepository implements ITasksRepository {
  TasksRepository({
    required ITasksLocalDataSource localDataSource,
    required ITasksRemoteDataSource remoteDataSource,
    required ICurrentFamilyProvider currentFamilyProvider,
    required IPendingSyncService pendingSyncService,
    required INetworkService networkService,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _currentFamilyProvider = currentFamilyProvider,
       _pendingSyncService = pendingSyncService,
       _networkService = networkService;

  final ITasksLocalDataSource _localDataSource;
  final ITasksRemoteDataSource _remoteDataSource;
  final ICurrentFamilyProvider _currentFamilyProvider;
  final IPendingSyncService _pendingSyncService;
  final INetworkService _networkService;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _remoteSubscription;

  StreamSubscription<String?>? _familySubscription;

  bool _initialized = false;

  static const _uuid = Uuid();

  @override
  Stream<List<TaskEntity>> watchTodayTasks() async* {
    unawaited(_ensureInitialized());
    await _prepareTasksForToday();

    yield* _localDataSource.watchTodayTasks();
  }

  @override
  Stream<List<TaskEntity>> watchOneTimeTasks() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchOneTimeTasks();
  }

  @override
  Stream<List<TaskEntity>> watchOverdueTasks() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchOverdueTasks();
  }

  @override
  Stream<List<TaskEntity>> watchDailyTasks() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchDailyTasks();
  }

  @override
  Stream<List<TaskEntity>> watchWeaklyTasks() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchWeaklyTasks();
  }

  @override
  Stream<List<TaskEntity>> watchMonthlyTasks() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchMonthlyTasks();
  }

  @override
  Stream<List<TaskEntity>> watchYearlyTasks() {
    unawaited(_ensureInitialized());

    return _localDataSource.watchYearlyTasks();
  }

  @override
  Future<TaskEntity> getTask(String id) {
    try {
      return _localDataSource.getTaskById(id);
    } on Object catch (error) {
      throw TasksExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> createTask(CreateTaskEntity createTask) async {
    try {
      final now = DateTime.now();
      final nextExecutionAt = _calculateInitialNextExecutionAt(
        type: createTask.type,
        dueDate: createTask.dueDate,
      );

      final task = TaskEntity(
        id: _uuid.v4(),
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

      await _localDataSource.insertTask(task);

      if (await _networkService.hasInternet()) {
        unawaited(_syncAdd(task));
      } else {
        await _pendingSyncService.enqueueTaskAdd(task);
      }
    } on Object catch (error) {
      throw TasksExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    try {
      final updatedTask = task.copyWith(updatedAt: DateTime.now());
      await _localDataSource.updateTask(updatedTask);

      if (await _networkService.hasInternet()) {
        unawaited(_syncUpdate(updatedTask));
      } else {
        await _pendingSyncService.enqueueTaskUpdate(updatedTask);
      }
    } on Object catch (error) {
      throw TasksExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> deleteTask(TaskEntity task) async {
    try {
      final deletedTask = task.copyWith(
        isDeleted: true,
        updatedAt: DateTime.now(),
      );
      await _localDataSource.updateTask(deletedTask);

      if (await _networkService.hasInternet()) {
        unawaited(_syncDelete(deletedTask));
      } else {
        await _pendingSyncService.enqueueTaskDelete(deletedTask);
      }
    } on Object catch (error) {
      throw TasksExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> completeTask(TaskEntity task) async {
    try {
      final now = DateTime.now();
      final executionDate = _dateOnly(now);
      final nextExecutionAt = _calculateNextExecutionDate(task: task);

      final updatedTask = task.copyWith(
        isCompleted: true,
        completedAt: executionDate,
        updatedAt: now,
        nextExecutionAt: nextExecutionAt,
        lastExecutionAt: task.nextExecutionAt,
      );
      await _localDataSource.updateTask(updatedTask);

      if (await _networkService.hasInternet()) {
        unawaited(_syncUpdate(updatedTask));
      } else {
        await _pendingSyncService.enqueueTaskUpdate(updatedTask);
      }
    } on Object catch (error) {
      throw TasksExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> restoreTask(TaskEntity task) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final nextExecutionAt = switch (task.type) {
        TaskType.oneTime => task.dueDate,
        TaskType.daily => today,
        TaskType.weekly => task.lastExecutionAt,
        TaskType.monthly => task.lastExecutionAt,
        TaskType.yearly => task.lastExecutionAt,
      };

      final updatedTask = task.copyWith(
        isCompleted: false,
        completedAt: null,
        nextExecutionAt: nextExecutionAt,
        updatedAt: now,
      );
      await _localDataSource.updateTask(updatedTask);

      if (await _networkService.hasInternet()) {
        unawaited(_syncUpdate(updatedTask));
      } else {
        await _pendingSyncService.enqueueTaskUpdate(updatedTask);
      }
    } on Object catch (error) {
      throw TasksExceptionMapper.fromException(error);
    }
  }

  @override
  Future<void> syncTasks() async {
    await _pendingSyncService.processQueue();
  }

  @override
  Future<void> prepareTasksForToday() {
    return _prepareTasksForToday();
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
      // Задача назначена на сегодня или будущее.
      // Ничего с ней не делаем.
      if (!nextExecutionDate.isBefore(today)) continue;

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
          updatedAt: DateTime.now(),
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

  Future<void> _restartRemoteSync(String? familyId) async {
    await _remoteSubscription?.cancel();
    _remoteSubscription = null;

    if (familyId == null) return;

    _remoteSubscription = _remoteDataSource
        .watchTasks(familyId: familyId)
        .listen(
          (snapshot) {
            for (final change in snapshot.docChanges) {
              final task = TaskDto.fromJson(change.doc.data()!).toEntity();

              switch (change.type) {
                case DocumentChangeType.added:
                  if (!task.isDeleted) {
                    unawaited(_handleRemoteTask(task));
                  }
                  break;
                case DocumentChangeType.modified:
                  unawaited(_handleRemoteTask(task));
                  break;
                case DocumentChangeType.removed:
                  break;
              }
            }
          },
          onError: (error, stackTrace) {
            debugPrint('Remote tasks sync error: $error');
          },
        );
  }

  Future<void> _handleRemoteTask(TaskEntity remoteTask) async {
    try {
      final localTask = await _localDataSource.getTaskById(remoteTask.id);

      if (localTask.updatedAt.isAfter(remoteTask.updatedAt)) {
        await _syncUpdate(localTask);
        return;
      }

      await _localDataSource.upsertTask(remoteTask);
    } catch (_) {
      await _localDataSource.upsertTask(remoteTask);
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;

    _familySubscription = _currentFamilyProvider.watchCurrentFamilyId().listen((
      familyId,
    ) {
      unawaited(_restartRemoteSync(familyId));
    });
  }

  Future<void> _syncAdd(TaskEntity task) async {
    final familyId = await _familyId();
    if (familyId == null) return;

    final remoteTask = await _remoteDataSource.addTask(
      familyId: familyId,
      dto: task.toDto(),
    );
    if (remoteTask != null) await _localDataSource.updateTask(remoteTask);
  }

  Future<void> _syncUpdate(TaskEntity task) async {
    final familyId = await _familyId();
    if (familyId == null) return;

    final remoteTask = await _remoteDataSource.updateTask(
      familyId: familyId,
      dto: task.toDto(),
    );
    if (remoteTask != null) await _localDataSource.upsertTask(remoteTask);
  }

  Future<void> _syncDelete(TaskEntity task) async {
    final familyId = await _familyId();
    if (familyId == null) return;

    final remoteTask = await _remoteDataSource.markDeleted(
      familyId: familyId,
      taskId: task.id,
      updatedAt: task.updatedAt,
    );
    if (remoteTask != null) await _localDataSource.upsertTask(remoteTask);
  }

  Future<String?> _familyId() {
    return _currentFamilyProvider.getCurrentFamilyId();
  }

  Future<void> dispose() async {
    await _remoteSubscription?.cancel();
    await _familySubscription?.cancel();
  }
}
