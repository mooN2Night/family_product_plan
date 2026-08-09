import '../entity/create_task_entity.dart';
import '../entity/task_entity.dart';

abstract interface class ITasksRepository {
  /// Блок "Сегодня"
  Stream<List<TaskEntity>> watchTodayTasks();

  /// Разовые задачи
  Future<List<TaskEntity>> getOneTimeTasks();

  /// Ежедневные задачи
  Future<List<TaskEntity>> getDailyTasks();

  /// Еженедельные задачи
  Future<List<TaskEntity>> getWeaklyTasks();

  /// Ежемесячные задачи
  Future<List<TaskEntity>> getMonthlyTasks();

  /// Ежегодные задачи
  Future<List<TaskEntity>> getYearlyTasks();

  /// Получение задачи
  Future<TaskEntity> getTask(String id);

  /// Создание задачи
  Future<void> createTask(CreateTaskEntity createTask);

  /// Обновление задачи
  Future<void> updateTask(TaskEntity task);

  /// Завершение задачи
  Future<void> completeTask(TaskEntity task);

  /// Возвращение задачи в активное состояние
  Future<void> restoreTask(TaskEntity task);

  /// Удаление задачи
  Future<void> deleteTask(TaskEntity task);

  /// Синхронизация задач
  Future<void> syncTasks();
}
