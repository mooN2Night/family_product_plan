import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/tasks/domain/state/task_action/tasks_action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/create_task_entity.dart';
import '../../utils/task_priority.dart';
import '../../utils/task_type.dart';

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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  TaskType _taskType = TaskType.oneTime;

  DateTime? _dueDate;
  String? _assignedUserId;

  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TasksActionBloc, TasksActionState>(
      listener: (context, state) {
        if (state is TasksActionSuccessState) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Новая задача')),
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
              initialValue: _priority,
              decoration: const InputDecoration(labelText: 'Приоритет'),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.title),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskType>(
              initialValue: _taskType,
              decoration: const InputDecoration(labelText: 'Тип задачи'),
              items: TaskType.values.map((type) {
                return DropdownMenuItem(value: type, child: Text(type.title));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _taskType = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Срок выполнения'),
              subtitle: Text(
                _dueDate == null
                    ? 'Не выбран'
                    : DateFormat('dd.MM.yyyy').format(_dueDate!),
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: _selectDate,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _isActive,
              title: const Text('Показывать в общем списке'),
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTask,
              child: Text('Создать задачу'),
            ),
          ],
        ),
      ),
    );
  }

  void _createTask() {
    final task = CreateTaskEntity(
      title: _titleController.text,
      description: _descriptionController.text,
      type: _taskType,
      priority: _priority,
      dueDate: _dueDate,
      nextExecutionAt: _dueDate,
      isActive: _isActive,
      assignedUserId: _assignedUserId,
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

    if (result != null) {
      setState(() {
        _dueDate = result;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
}
