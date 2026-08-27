import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entity/task_entity.dart';
import '../../dto/task_dto.dart';
import 'i_tasks_remote_data_source.dart';

final class TasksRemoteDataSource implements ITasksRemoteDataSource {
  const TasksRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchTasks({
    required String familyId,
  }) => _collection(familyId).snapshots();

  @override
  Future<void> addTask({required String familyId, required TaskDto dto}) =>
      _collection(familyId).doc(dto.id).set(dto.toJson());

  @override
  Future<TaskEntity?> updateTask({
    required String familyId,
    required TaskDto dto,
  }) async {
    final remoteTask = await _getTask(familyId: familyId, taskId: dto.id);
    if (remoteTask == null) {
      await addTask(familyId: familyId, dto: dto);
      return null;
    }

    if (remoteTask.updatedAt.isAfter(dto.updatedAt)) {
      return remoteTask.toEntity();
    }

    await _collection(familyId).doc(dto.id).update(dto.toJson());

    return null;
  }

  @override
  Future<TaskEntity?> markDeleted({
    required String familyId,
    required String taskId,
    required DateTime updatedAt,
  }) async {
    final remoteTask = await _getTask(familyId: familyId, taskId: taskId);
    if (remoteTask == null) return null;

    if (remoteTask.updatedAt.isAfter(updatedAt)) {
      return remoteTask.toEntity();
    }

    await _collection(familyId).doc(taskId).update({
      'isDeleted': true,
      'updatedAt': Timestamp.fromDate(updatedAt),
    });

    return null;
  }

  Future<TaskDto?> _getTask({
    required String familyId,
    required String taskId,
  }) async {
    final snapshot = await _collection(familyId).doc(taskId).get();
    if (!snapshot.exists) return null;

    return TaskDto.fromJson(snapshot.data()!);
  }

  CollectionReference<Map<String, dynamic>> _collection(String familyId) =>
      _firestore.collection('families').doc(familyId).collection('tasks');
}
