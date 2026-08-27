import 'package:family_product_plan/app/mapper/app_task_mapper.dart';
import '../../../../../app/services/database/i_database.dart';
import '../../../domain/entity/task_entity.dart';
import 'i_tasks_local_data_source.dart';

final class TasksLocalDataSource implements ITasksLocalDataSource {
  const TasksLocalDataSource({required IDatabase database})
    : _database = database;

  final IDatabase _database;

  @override
  Stream<List<TaskEntity>> watchTodayTasks() {
    return _database.watchTodayTasks().map(
      (tasks) => tasks.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Stream<List<TaskEntity>> watchOneTimeTasks() {
    return _database.watchOneTimeTasks().map(
      (tasks) => tasks.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Stream<List<TaskEntity>> watchOverdueTasks() {
    return _database.watchOverdueTasks().map(
      (tasks) => tasks.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Stream<List<TaskEntity>> watchDailyTasks() {
    return _database.watchDailyTasks().map(
      (tasks) => tasks.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Stream<List<TaskEntity>> watchWeaklyTasks() {
    return _database.watchWeaklyTasks().map(
      (tasks) => tasks.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Stream<List<TaskEntity>> watchMonthlyTasks() {
    return _database.watchMonthlyTasks().map(
      (tasks) => tasks.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Stream<List<TaskEntity>> watchYearlyTasks() {
    return _database.watchYearlyTasks().map(
      (tasks) => tasks.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  Future<void> insertTask(TaskEntity entity) {
    return _database.insertTask(entity.toCompanion());
  }

  @override
  Future<void> updateTask(TaskEntity entity) {
    return _database.updateTask(entity.toDatabaseModel());
  }

  @override
  Future<void> upsertTask(TaskEntity entity) {
    return _database.upsertTask(entity.toDatabaseModel());
  }

  @override
  Future<void> replaceTasks(List<TaskEntity> entities) {
    return _database.replaceTasks(
      entities.map((e) => e.toDatabaseModel()).toList(),
    );
  }

  @override
  Future<void> deleteTask(TaskEntity entity) {
    return _database.deleteTask(entity.toDatabaseModel());
  }

  @override
  Future<void> clearTasks() {
    return _database.clearTasks();
  }

  @override
  Future<TaskEntity> getTaskById(String id) async {
    final task = await _database.getTaskById(id);

    return task.toEntity();
  }

  @override
  Future<List<TaskEntity>> getRecurringTasks() async {
    final tasks = await _database.getRecurringTasks();
    return tasks.map((e) => e.toEntity()).toList();
  }
}
