import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/ui_kit/app_box.dart';
import 'package:family_product_plan/app/utils/app_expansion_tile.dart';
import 'package:family_product_plan/features/tasks/domain/state/task_action/tasks_action_bloc.dart';
import 'package:family_product_plan/features/tasks/domain/state/tasks_today/today_tasks_bloc.dart';
import 'package:family_product_plan/features/tasks/presentation/components/task_list_tile.dart';
import 'package:family_product_plan/features/tasks/presentation/tasks_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/state/tasks_type/tasks_type_bloc.dart';
import '../../utils/task_type.dart';

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
      appBar: CustomAppBar.profile(
        actions: [
          IconButton(
            onPressed: () => context.goNamed(TasksRoutes.taskCreateScreenName),
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 140),
        children: [
          HBox(16),
          Text('Сегодня', style: Theme.of(context).textTheme.titleLarge),
          BlocBuilder<TodayTasksBloc, TodayTasksState>(
            builder: (context, state) {
              switch (state) {
                case TodayTasksInitialState():
                case TodayTasksLoadingState():
                  return const Center(child: CircularProgressIndicator());

                case TodayTasksErrorState():
                  return Center(child: Text(state.message));

                case TodayTasksSuccessState():
                  final tasks = state.tasks;
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text('На сегодня задач нет 🎉'),
                      ),
                    );
                  }

                  return Column(
                    children: tasks
                        .map((task) => TaskListTile(task: task))
                        .toList(),
                  );
              }
            },
          ),
          HBox(20),
          _TasksWrapper(type: TaskType.oneTime),
          HBox(16),
          _TasksWrapper(type: TaskType.daily),
          HBox(16),
          _TasksWrapper(type: TaskType.weekly),
          HBox(16),
          _TasksWrapper(type: TaskType.monthly),
          HBox(16),
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
      child: BlocBuilder<TasksTypeBloc, TasksTypeState>(
        builder: (context, state) {
          if (state is! TasksTypeSuccessState) {
            return Container(height: 50, width: 50, color: Colors.red);
          }

          final tasks = state.tasks;

          return AppExpansionWrapper.borderless(
            context,
            title: type.title,
            subtitle: tasks.length.toString(),
            isEnabled: tasks.isNotEmpty,
            expandedContent: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: tasks
                    .map((task) => TaskListTile(task: task))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
