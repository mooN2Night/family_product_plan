import '../../../domain/entity/task_entity.dart';

abstract interface class ITasksLocalDataSource {
  Stream<List<TaskEntity>> watchTodayTasks();

  Stream<List<TaskEntity>> watchOneTimeTasks();

  Stream<List<TaskEntity>> watchOverdueTasks();

  Stream<List<TaskEntity>> watchDailyTasks();

  Stream<List<TaskEntity>> watchWeaklyTasks();

  Stream<List<TaskEntity>> watchMonthlyTasks();

  Stream<List<TaskEntity>> watchYearlyTasks();

  Future<void> insertTask(TaskEntity entity);

  Future<void> updateTask(TaskEntity entity);

  Future<void> upsertTask(TaskEntity entity);

  Future<void> replaceTasks(List<TaskEntity> entities);

  Future<void> deleteTask(TaskEntity entity);

  Future<void> clearTasks();

  Future<TaskEntity> getTaskById(String id);

  Future<List<TaskEntity>> getRecurringTasks();
}
