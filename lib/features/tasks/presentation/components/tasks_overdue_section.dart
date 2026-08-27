import 'package:family_product_plan/features/tasks/presentation/components/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/state/tasks_overdue/overdue_tasks_bloc.dart';

class TasksOverdueSection extends StatelessWidget {
  const TasksOverdueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverdueTasksBloc, OverdueTasksState>(
      builder: (context, state) {
        final tasks = switch (state) {
          OverdueTasksSuccessState(:final tasks) => tasks,
          _ => const <TaskEntity>[],
        };

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: tasks.isEmpty
              ? const SizedBox.shrink()
              : _TasksOverdueSectionContent(
                  key: const ValueKey('overdue_tasks_content'),
                  tasks: tasks,
                ),
        );
      },
    );
  }
}

class _TasksOverdueSectionContent extends StatelessWidget {
  const _TasksOverdueSectionContent({required this.tasks, super.key});

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('overdue_tasks'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Text(
                'Просроченные',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const HBox(16),
        _OverdueTasksList(tasks: tasks),
        const HBox(28),
      ],
    );
  }
}

class _OverdueTasksList extends StatelessWidget {
  const _OverdueTasksList({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks
          .map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TaskListTile(task: task),
            ),
          )
          .toList(),
    );
  }
}
