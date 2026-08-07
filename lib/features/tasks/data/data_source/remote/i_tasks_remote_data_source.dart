import 'package:cloud_firestore/cloud_firestore.dart';

import '../../dto/task_dto.dart';

abstract interface class ITasksRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchTasks({
    required String familyId,
  });

  Future<void> addTask({required String familyId, required TaskDto dto});

  Future<void> updateTask({required String familyId, required TaskDto dto});

  Future<void> deleteTask({required String familyId, required String taskId});
}
