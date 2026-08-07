import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_bar.dart';
import 'package:family_product_plan/features/tasks/domain/state/task_action/tasks_action_bloc.dart';
import 'package:family_product_plan/features/tasks/domain/state/tasks_today/today_tasks_bloc.dart';
import 'package:family_product_plan/features/tasks/presentation/tasks_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          IconButton(
            onPressed: () => debugPrint('debugPrint '),
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Сегодня',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<TodayTasksBloc, TodayTasksState>(
              builder: (context, state) {
                switch (state) {
                  case TodayTasksInitialState():
                  case TodayTasksLoadingState():
                    return const Center(child: CircularProgressIndicator());

                  case TodayTasksErrorState():
                    return Center(child: Text(state.message));

                  case TodayTasksSuccessState():
                    if (state.tasks.isEmpty) {
                      return const Center(
                        child: Text('На сегодня задач нет 🎉'),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.tasks.length,
                      separatorBuilder: (_, _) {
                        return const SizedBox(height: 8);
                      },
                      itemBuilder: (_, index) {
                        final task = state.tasks[index];

                        return Card(
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: task.description == null
                                ? null
                                : Text(task.description!),
                            trailing: Checkbox(
                              value: task.isCompleted,
                              onChanged: (_) {},
                            ),
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
