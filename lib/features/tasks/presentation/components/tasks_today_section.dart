import 'package:family_product_plan/features/tasks/presentation/components/task_list_tile.dart';
import 'package:family_product_plan/features/tasks/presentation/components/task_type_error.dart';
import 'package:family_product_plan/features/tasks/presentation/components/task_type_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/state/tasks_today/today_tasks_bloc.dart';

class TasksTodaySection extends StatelessWidget {
  const TasksTodaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayTasksBloc, TodayTasksState>(
      builder: (context, state) {
        switch (state) {
          case TodayTasksLoadingState():
            return const TodayTaskLoadingView();
          case TodayTasksErrorState():
            return TasksErrorCard(
              message: 'Ошибка загрузки задач на сегодня, попробуйте обновить',
              onTap: () =>
                  context.read<TodayTasksBloc>().add(TodayTasksStartedEvent()),
            );
          case TodayTasksSuccessState():
            return _TasksTodaySectionContent(tasks: state.tasks);
          case TodayTasksInitialState():
            return SizedBox.shrink();
        }
      },
    );
  }
}

class _TasksTodaySectionContent extends StatelessWidget {
  const _TasksTodaySectionContent({required this.tasks});

  final List<TaskEntity> tasks;

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((task) => task.isCompleted).length;

    final totalTasks = tasks.length;

    final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Text(
                'Сегодня',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              DateFormat('d MMMM', 'ru').format(DateTime.now()),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const HBox(16),
        _TodayProgressCard(
          completed: completedTasks,
          total: totalTasks,
          progress: progress,
        ),
        const HBox(12),

        if (tasks.isEmpty)
          const _EmptyTodayTasks()
        else
          _TodayTasksList(tasks: tasks),
      ],
    );
  }
}

class _TodayProgressCard extends StatelessWidget {
  const _TodayProgressCard({
    required this.completed,
    required this.total,
    required this.progress,
  });

  final int completed;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final allCompleted = total > 0 && completed == total;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              allCompleted ? Icons.done_all_rounded : Icons.check_rounded,
              color: AppColors.primary,
              size: 25,
            ),
          ),
          const WBox(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  total == 0
                      ? 'Сегодня свободный день'
                      : allCompleted
                      ? 'Все задачи выполнены'
                      : 'Задачи на сегодня',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const HBox(4),
                Text(
                  total == 0
                      ? 'Можно немного отдохнуть 🎉'
                      : '$completed из $total выполнено',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),

                if (total > 0) ...[
                  const HBox(10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.7),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayTasksList extends StatelessWidget {
  const _TodayTasksList({required this.tasks});

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

class _EmptyTodayTasks extends StatelessWidget {
  const _EmptyTodayTasks();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.wb_sunny_outlined,
              color: AppColors.primary,
              size: 27,
            ),
          ),
          const HBox(12),
          const Text(
            'На сегодня задач нет',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const HBox(4),
          const Text(
            'Можно немного отдохнуть 🎉',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
