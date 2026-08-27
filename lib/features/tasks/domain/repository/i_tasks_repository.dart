import '../entity/create_task_entity.dart';
import '../entity/task_entity.dart';

abstract interface class ITasksRepository {
  /// Блок "Сегодня"
  Stream<List<TaskEntity>> watchTodayTasks();

  /// Разовые задачи
  Stream<List<TaskEntity>> watchOneTimeTasks();

  /// Ежедневные задачи
  Stream<List<TaskEntity>> watchDailyTasks();

  /// Еженедельные задачи
  Stream<List<TaskEntity>> watchWeaklyTasks();

  /// Ежемесячные задачи
  Stream<List<TaskEntity>> watchMonthlyTasks();

  /// Ежегодные задачи
  Stream<List<TaskEntity>> watchYearlyTasks();

  Stream<List<TaskEntity>> watchOverdueTasks();

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

  /// Подготовка задач на "Сегодня" для обновления
  Future<void> prepareTasksForToday();
}
