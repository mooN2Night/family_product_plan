import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/task_entity.dart';
import '../../domain/state/task_action/tasks_action_bloc.dart';
import '../../utils/task_priority_checkbox.dart';
import '../../utils/task_type.dart';

class TaskInfoSuccessView extends StatefulWidget {
  const TaskInfoSuccessView({required this.task, super.key});

  final TaskEntity task;

  @override
  State<TaskInfoSuccessView> createState() => _TaskInfoSuccessViewState();
}

class _TaskInfoSuccessViewState extends State<TaskInfoSuccessView> {
  late final ValueNotifier<bool> _isCompleted;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _isCompleted = ValueNotifier<bool>(widget.task.isCompleted);
  }

  @override
  void didUpdateWidget(covariant TaskInfoSuccessView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task.id != widget.task.id) {
      _debounceTimer?.cancel();

      _isCompleted.value = widget.task.isCompleted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ValueListenableBuilder(
          valueListenable: _isCompleted,
          builder: (context, isCompleted, _) {
            return Row(
              children: [
                PriorityCheckbox(
                  priority: widget.task.priority,
                  value: isCompleted,
                  onChanged: (value) =>
                      _onCompletedChanged(context, value: value),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        if (widget.task.description != null &&
            widget.task.description!.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(widget.task.description!, style: theme.textTheme.bodyLarge),
        ],

        const SizedBox(height: 24),
        _TaskInfoRow(title: 'Тип', value: widget.task.type.title),
        _TaskInfoRow(title: 'Приоритет', value: widget.task.priority.title),

        if (widget.task.type == TaskType.oneTime && widget.task.dueDate != null)
          _TaskInfoRow(
            title: 'Срок выполнения',
            value: DateFormat('dd.MM.yyyy').format(widget.task.dueDate!),
          ),

        if (widget.task.type != TaskType.oneTime &&
            widget.task.type != TaskType.daily &&
            widget.task.nextExecutionAt != null)
          _TaskInfoRow(
            title: 'Следующее выполнение',
            value: DateFormat(
              'dd.MM.yyyy',
            ).format(widget.task.nextExecutionAt!),
          ),

        if (widget.task.assignedUserId != null)
          _TaskInfoRow(
            title: 'Назначена пользователю',
            value: widget.task.assignedUserId!,
          ),

        _TaskInfoRow(
          title: 'Создана',
          value: DateFormat('dd.MM.yyyy').format(widget.task.createdAt),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _isCompleted.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onCompletedChanged(BuildContext context, {required bool value}) {
    _isCompleted.value = value;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 650), () {
      if (!context.mounted) return;

      final bloc = context.read<TasksActionBloc>();

      final updatedTask = widget.task.copyWith(isCompleted: _isCompleted.value);

      if (_isCompleted.value) {
        bloc.add(TasksActionCompleteEvent(task: updatedTask));
      } else {
        bloc.add(TasksActionRestoreEvent(task: updatedTask));
      }
    });
  }
}

class _TaskInfoRow extends StatelessWidget {
  const _TaskInfoRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
