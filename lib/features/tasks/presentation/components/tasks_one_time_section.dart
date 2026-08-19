import 'package:family_product_plan/features/tasks/presentation/components/task_list_tile.dart';
import 'package:family_product_plan/features/tasks/presentation/components/task_type_error.dart';
import 'package:family_product_plan/features/tasks/presentation/components/task_type_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_context_ext.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/task_entity.dart';
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
          switch (state) {
            case TasksTypeLoadingState():
              return const OneTimeTaskLoadingView();
            case TasksTypeErrorState():
              return TasksErrorCard(
                message: 'Ошибка загрузки разовых задач, попробуйте обновить',
                onTap: () => context.read<TasksTypeBloc>().add(
                  const TasksTypeRequestedEvent(type: TaskType.oneTime),
                ),
              );
            case TasksTypeSuccessState():
              return _OneTimeTasksSectionContent(tasks: state.tasks);
            case TasksTypeInitialState():
              return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _OneTimeTasksSectionContent extends StatelessWidget {
  const _OneTimeTasksSectionContent({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
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
  }
}
