import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/state/task_action/tasks_action_bloc.dart';
import '../../utils/task_priority_checkbox.dart';
import '../../utils/task_type.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({super.key, required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: открыть экран задачи
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            PriorityCheckbox(
              priority: task.priority,
              value: task.isCompleted,
              onChanged: (value) {
                final bloc = context.read<TasksActionBloc>();

                if (value) {
                  bloc.add(TasksActionCompleteEvent(task: task));
                } else {
                  bloc.add(TasksActionRestoreEvent(task: task));
                }
              },
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),

            if (_shouldShowNextExecutionDate(task)) ...[
              const SizedBox(width: 12),
              Text(
                DateFormat('dd.MM.yyyy').format(task.nextExecutionAt!),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],

            if (task.type == TaskType.oneTime && task.dueDate != null) ...[
              const SizedBox(width: 12),
              Text(
                DateFormat('dd.MM.yyyy').format(task.dueDate!),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _shouldShowNextExecutionDate(TaskEntity task) {
    return task.type != TaskType.oneTime &&
        task.type != TaskType.daily &&
        task.nextExecutionAt != null;
  }
}
