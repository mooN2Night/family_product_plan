import 'package:family_product_plan/features/tasks/utils/task_priority.dart';
import 'package:flutter/material.dart';

extension TaskPriorityColor on TaskPriority {
  Color get color {
    switch (this) {
      case TaskPriority.urgent:
        return Colors.red;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.medium:
        return Colors.grey;
      case TaskPriority.low:
        return Colors.blue;
    }
  }
}