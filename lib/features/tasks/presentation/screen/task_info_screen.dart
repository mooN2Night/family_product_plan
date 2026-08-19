import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/tasks/domain/state/task_info/task_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../../domain/state/task_action/tasks_action_bloc.dart';
import '../components/task_info_success_view.dart';

class TaskInfoScreen extends StatelessWidget {
  const TaskInfoScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final taskRepository = context.di.repositories.tasksRepository;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TaskInfoBloc(taskRepository: taskRepository)
                ..add(TaskInfoRequestedEvent(id: id)),
        ),
        BlocProvider(
          create: (context) => TasksActionBloc(taskRepository: taskRepository),
        ),
      ],
      child: const _TaskInfoView(),
    );
  }
}

class _TaskInfoView extends StatelessWidget {
  const _TaskInfoView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.secondary(title: 'Информация о задаче'),
      body: BlocBuilder<TaskInfoBloc, TaskInfoState>(
        builder: (context, state) {
          switch (state) {
            case TaskInfoInitialState():
            case TaskInfoLoadingState():
              return const Center(child: CircularProgressIndicator());
            case TaskInfoErrorState():
              return Center(child: Text(state.message));
            case TaskInfoSuccessState():
              return TaskInfoSuccessView(task: state.task);
          }
        },
      ),
    );
  }
}
