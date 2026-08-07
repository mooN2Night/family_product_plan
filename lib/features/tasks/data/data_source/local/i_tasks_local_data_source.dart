import '../../../domain/entity/task_entity.dart';

abstract interface class ITasksLocalDataSource {
  Stream<List<TaskEntity>> watchTodayTasks();

  Future<List<TaskEntity>> getUrgentTasks();

  Future<List<TaskEntity>> getHighPriorityTasks();

  Future<List<TaskEntity>> getMediumPriorityTasks();

  Future<List<TaskEntity>> getLowPriorityTasks();

  Future<void> insertTask(TaskEntity entity);

  Future<void> updateTask(TaskEntity entity);

  Future<void> upsertTask(TaskEntity entity);

  Future<void> replaceTasks(List<TaskEntity> entities);

  Future<void> deleteTask(TaskEntity entity);

  Future<void> clearTasks();

  Future<TaskEntity> getTaskById(String id);
}
