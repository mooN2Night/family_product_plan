import '../../../domain/entity/task_entity.dart';

abstract interface class ITasksLocalDataSource {
  Stream<List<TaskEntity>> watchTodayTasks();

  Future<List<TaskEntity>> getOneTimeTasks();

  Future<List<TaskEntity>> getDailyTasks();

  Future<List<TaskEntity>> getWeaklyTasks();

  Future<List<TaskEntity>> getMonthlyTasks();

  Future<List<TaskEntity>> getYearlyTasks();

  Future<void> insertTask(TaskEntity entity);

  Future<void> updateTask(TaskEntity entity);

  Future<void> upsertTask(TaskEntity entity);

  Future<void> replaceTasks(List<TaskEntity> entities);

  Future<void> deleteTask(TaskEntity entity);

  Future<void> clearTasks();

  Future<TaskEntity> getTaskById(String id);
}
