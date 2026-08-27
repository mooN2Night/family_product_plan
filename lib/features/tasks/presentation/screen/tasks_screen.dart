import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/tasks/domain/state/task_action/tasks_action_bloc.dart';
import 'package:family_product_plan/features/tasks/domain/state/tasks_overdue/overdue_tasks_bloc.dart';
import 'package:family_product_plan/features/tasks/domain/state/tasks_today/today_tasks_bloc.dart';
import 'package:family_product_plan/features/tasks/presentation/components/tasks_today_section.dart';
import 'package:family_product_plan/features/tasks/presentation/tasks_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/state/tasks_type/tasks_type_bloc.dart';
import '../../utils/task_type.dart';
import '../components/task_type_section.dart';
import '../components/tasks_one_time_section.dart';
import '../components/tasks_overdue_section.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskRepository = context.di.repositories.tasksRepository;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TodayTasksBloc(taskRepository: taskRepository)
                ..add(const TodayTasksStartedEvent()),
        ),
        BlocProvider(
          create: (context) =>
              OverdueTasksBloc(taskRepository: taskRepository)
                ..add(const OverdueTasksStartedEvent()),
        ),
        BlocProvider(
          create: (context) => TasksActionBloc(taskRepository: taskRepository),
        ),
      ],
      child: const _TasksView(),
    );
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.main(
        actions: [
          IconButton(
            onPressed: () => context.goNamed(TasksRoutes.taskCreateScreenName),
            tooltip: 'Добавить задачу',
            icon: const Icon(Icons.add_rounded, size: 28),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
        children: [
          TasksOverdueSection(),
          TasksTodaySection(),
          HBox(28),
          TasksOneTimeSection(),
          const Text(
            'Повторяющиеся',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          HBox(12),
          _TasksWrapper(type: TaskType.daily),
          HBox(8),
          _TasksWrapper(type: TaskType.weekly),
          HBox(8),
          _TasksWrapper(type: TaskType.monthly),
          HBox(8),
          _TasksWrapper(type: TaskType.yearly),
        ],
      ),
    );
  }
}

class _TasksWrapper extends StatelessWidget {
  const _TasksWrapper({required this.type});

  final TaskType type;

  @override
  Widget build(BuildContext context) {
    final taskRepository = context.di.repositories.tasksRepository;

    return BlocProvider(
      create: (context) =>
          TasksTypeBloc(taskRepository: taskRepository)
            ..add(TasksTypeRequestedEvent(type: type)),
      child: TaskTypeSection(type: type),
    );
  }
}
