import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/tasks/domain/state/task_action/tasks_action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/create_task_entity.dart';
import '../../utils/task_priority.dart';
import '../../utils/task_type.dart';
import '../../utils/weekday.dart';
import '../components/task_create_weekday_picker.dart';

class TaskCreateScreen extends StatelessWidget {
  const TaskCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskRepository = context.di.repositories.tasksRepository;

    return BlocProvider(
      create: (context) => TasksActionBloc(taskRepository: taskRepository),
      child: const _TaskCreateView(),
    );
  }
}

class _TaskCreateView extends StatefulWidget {
  const _TaskCreateView();

  @override
  State<_TaskCreateView> createState() => _TaskCreateViewState();
}

class _TaskCreateViewState extends State<_TaskCreateView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late final ValueNotifier<TaskPriority> _priority;
  late final ValueNotifier<TaskType> _taskType;
  late final ValueNotifier<DateTime?> _dueDate;
  late final ValueNotifier<Weekday?> _weekday;
  late final ValueNotifier<String?> _assignedUserId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    _priority = ValueNotifier<TaskPriority>(TaskPriority.medium);
    _taskType = ValueNotifier<TaskType>(TaskType.oneTime);
    _dueDate = ValueNotifier<DateTime?>(null);
    _weekday = ValueNotifier<Weekday?>(null);
    _assignedUserId = ValueNotifier<String?>(null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksActionBloc, TasksActionState>(
      listener: (context, state) {
        if (state is TasksActionSuccessState) context.pop();
      },
      child: Scaffold(
        appBar: CustomAppBar.secondary(title: 'Новая задача'),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<TaskPriority>(
              initialValue: _priority.value,
              decoration: const InputDecoration(labelText: 'Приоритет'),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.title),
                );
              }).toList(),
              onChanged: (value) => _priority.value = value!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskType>(
              initialValue: _taskType.value,
              decoration: const InputDecoration(labelText: 'Тип задачи'),
              items: TaskType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.title));
              }).toList(),
              onChanged: (value) {
                _taskType.value = value!;
                _dueDate.value = null;
                _weekday.value = null;
              },
            ),
            ValueListenableBuilder(
              valueListenable: _taskType,
              builder: (context, type, _) {
                if (type == TaskType.oneTime) {
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      ValueListenableBuilder(
                        valueListenable: _dueDate,
                        builder: (context, date, _) {
                          return ListTile(
                            title: const Text('Срок выполнения'),
                            subtitle: Text(
                              date == null
                                  ? 'Не выбран'
                                  : DateFormat('dd.MM.yyyy').format(date),
                            ),
                            trailing: const Icon(Icons.calendar_month),
                            onTap: _selectDate,
                          );
                        },
                      ),
                    ],
                  );
                } else if (type == TaskType.monthly ||
                    type == TaskType.yearly) {
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      ValueListenableBuilder(
                        valueListenable: _dueDate,
                        builder: (context, date, _) {
                          return ListTile(
                            title: const Text('Выберите дату задачи'),
                            subtitle: Text(
                              date == null
                                  ? 'Не выбрана'
                                  : DateFormat('dd.MM.yyyy').format(date),
                            ),
                            trailing: const Icon(Icons.calendar_month),
                            onTap: _selectDate,
                          );
                        },
                      ),
                    ],
                  );
                } else if (type == TaskType.weekly) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'День недели',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ValueListenableBuilder(
                        valueListenable: _weekday,
                        builder: (context, weekday, _) {
                          return WeekdayPicker(
                            selected: weekday,
                            onChanged: (day) {
                              _weekday.value = day;
                              _dueDate.value = day.toNextDate();
                            },
                          );
                        },
                      ),
                    ],
                  );
                }

                return SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createTask(context),
              child: Text('Создать задачу'),
            ),
          ],
        ),
      ),
    );
  }

  void _createTask(BuildContext context) {
    final type = _taskType.value;
    final dueDate = _dueDate.value;

    final requiresDueDate = type != TaskType.daily;

    if (requiresDueDate && dueDate == null) {
      AppSnackBar.showError(
        context,
        message: 'Для этого типа задачи необходимо указать дату выполнения',
      );

      return;
    }

    final task = CreateTaskEntity(
      title: _titleController.text,
      description: _descriptionController.text,
      type: _taskType.value,
      priority: _priority.value,
      dueDate: _dueDate.value,
      assignedUserId: _assignedUserId.value,
      createdBy: '',
    );

    context.read<TasksActionBloc>().add(TasksActionAddEvent(task: task));
  }

  Future<void> _selectDate() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (result != null) _dueDate.value = result;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _priority.dispose();
    _taskType.dispose();
    _dueDate.dispose();
    _weekday.dispose();
    _assignedUserId.dispose();
    super.dispose();
  }
}
