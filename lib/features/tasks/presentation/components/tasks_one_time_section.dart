import 'package:family_product_plan/features/tasks/presentation/components/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_context_ext.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/state/tasks_type/tasks_type_bloc.dart';
import '../../utils/task_type.dart';

class TasksOneTimeSection extends StatelessWidget {
  const TasksOneTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskRepository = context.di.repositories.tasksRepository;

    return BlocProvider(
      create: (context) =>
          TasksTypeBloc(taskRepository: taskRepository)
            ..add(const TasksTypeRequestedEvent(type: TaskType.oneTime)),
      child: BlocBuilder<TasksTypeBloc, TasksTypeState>(
        builder: (context, state) {
          if (state is! TasksTypeSuccessState) {
            return const SizedBox.shrink();
          }

          final tasks = state.tasks;
          if (tasks.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Разовые задачи',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TaskListTile(task: task),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
