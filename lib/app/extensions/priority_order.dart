import '../../features/tasks/utils/task_priority.dart';

extension TaskPriorityOrder on TaskPriority {
  int get order {
    switch (this) {
      case TaskPriority.urgent:
        return 0;

      case TaskPriority.high:
        return 1;

      case TaskPriority.medium:
        return 2;

      case TaskPriority.low:
        return 3;
    }
  }
}