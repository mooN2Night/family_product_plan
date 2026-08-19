import 'package:family_product_plan/features/tasks/presentation/tasks_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/state/task_action/tasks_action_bloc.dart';
import '../../utils/task_priority_checkbox.dart';
import '../../utils/task_type.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({super.key, required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => context.goNamed(
          TasksRoutes.taskInfoScreenName,
          pathParameters: {'id': task.id},
        ),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
              const WBox(12),
              Expanded(child: _TaskContent(task: task)),
              const WBox(8),
              if (_shouldShowDate(task)) _TaskDate(date: _getDate(task)!),
            ],
          ),
        ),
      ),
    );
  }

  bool _shouldShowDate(TaskEntity task) {
    if (task.type == TaskType.oneTime) return task.dueDate != null;

    return task.type != TaskType.daily && task.nextExecutionAt != null;
  }

  DateTime? _getDate(TaskEntity task) {
    if (task.type == TaskType.oneTime) return task.dueDate;
    if (task.type == TaskType.daily) return null;

    return task.nextExecutionAt;
  }
}

class _TaskContent extends StatelessWidget {
  const _TaskContent({required this.task});

  final TaskEntity task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.textSecondary,
          ),
        ),

        if (task.description != null && task.description!.isNotEmpty) ...[
          const HBox(4),
          Text(
            task.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _TaskDate extends StatelessWidget {
  const _TaskDate({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('dd.MM.yyyy').format(date),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }
}
