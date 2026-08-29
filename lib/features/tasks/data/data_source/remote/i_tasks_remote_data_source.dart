import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entity/task_entity.dart';
import '../../dto/task_dto.dart';

abstract interface class ITasksRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchTasks({
    required String familyId,
  });

  Future<TaskEntity?> addTask({required String familyId, required TaskDto dto});

  Future<TaskEntity?> updateTask({required String familyId, required TaskDto dto});

  Future<TaskEntity?> markDeleted({
    required String familyId,
    required String taskId,
    required DateTime updatedAt,
  });
}
