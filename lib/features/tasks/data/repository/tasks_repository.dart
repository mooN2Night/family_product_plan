import 'package:uuid/uuid.dart';

import '../../domain/entity/create_task_entity.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/repository/i_tasks_repository.dart';
import '../data_source/local/i_tasks_local_data_source.dart';

final class TasksRepository implements ITasksRepository {
  const TasksRepository({required ITasksLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final ITasksLocalDataSource _localDataSource;

  @override
  Stream<List<TaskEntity>> watchTodayTasks() {
    return _localDataSource.watchTodayTasks();
  }

  @override
  Future<List<TaskEntity>> getUrgentTasks() {
    return _localDataSource.getUrgentTasks();
  }

  @override
  Future<List<TaskEntity>> getHighPriorityTasks() {
    return _localDataSource.getHighPriorityTasks();
  }

  @override
  Future<List<TaskEntity>> getMediumPriorityTasks() {
    return _localDataSource.getMediumPriorityTasks();
  }

  @override
  Future<List<TaskEntity>> getLowPriorityTasks() {
    return _localDataSource.getLowPriorityTasks();
  }

  @override
  Future<TaskEntity> getTask(String id) {
    return _localDataSource.getTaskById(id);
  }

  @override
  Future<void> createTask(CreateTaskEntity createTask) {
    final task = TaskEntity(
      id: const Uuid().v4(),
      title: createTask.title,
      type: createTask.type,
      priority: createTask.priority,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      dueDate: createTask.dueDate,
      completedAt: null,
      lastExecutionAt: null,
      nextExecutionAt: createTask.dueDate,
      isCompleted: false,
      isDeleted: false,
      isActive: createTask.isActive,
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
    await _localDataSource.updateTask(
      task.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
}
