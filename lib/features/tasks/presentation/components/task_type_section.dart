import 'package:family_product_plan/features/tasks/presentation/components/task_list_tile.dart';
import 'package:family_product_plan/features/tasks/presentation/components/task_type_error.dart';
import 'package:family_product_plan/features/tasks/presentation/components/task_type_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/task_entity.dart';
import '../../domain/state/tasks_type/tasks_type_bloc.dart';
import '../../utils/task_type.dart';

class TaskTypeSection extends StatefulWidget {
  const TaskTypeSection({super.key, required this.type});

  final TaskType type;

  @override
  State<TaskTypeSection> createState() => _TaskTypeSectionState();
}

class _TaskTypeSectionState extends State<TaskTypeSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksTypeBloc, TasksTypeState>(
      builder: (context, state) {
        switch (state) {
          case TasksTypeLoadingState():
            return const RepeatingTaskLoadingView();
          case TasksTypeErrorState():
            return TasksErrorCard(
              message:
                  'Ошибка загрузки повторяющихся задач, попробуйте обновить',
              onTap: () => context.read<TasksTypeBloc>().add(
                TasksTypeRequestedEvent(type: widget.type),
              ),
            );
          case TasksTypeSuccessState():
            return _RepeatingTasksSectionContent(
              type: widget.type,
              tasks: state.tasks,
            );
          case TasksTypeInitialState():
            return SizedBox.shrink();
        }
      },
    );
  }
}

class _RepeatingTasksSectionContent extends StatefulWidget {
  const _RepeatingTasksSectionContent({
    required this.type,
    required this.tasks,
  });

  final TaskType type;
  final List<TaskEntity> tasks;

  @override
  State<_RepeatingTasksSectionContent> createState() =>
      _RepeatingTasksSectionContentState();
}

class _RepeatingTasksSectionContentState
    extends State<_RepeatingTasksSectionContent> {
  late final ValueNotifier<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;
    final title = _titleForType(widget.type);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: tasks.isEmpty
                ? null
                : () => _isExpanded.value = !_isExpanded.value,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Row(
                children: [
                  _TaskTypeIcon(type: widget.type),
                  const WBox(12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: tasks.isEmpty
                            ? AppColors.textDisabled
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _TaskCount(count: tasks.length),
                  const WBox(8),
                  ValueListenableBuilder(
                    valueListenable: _isExpanded,
                    builder: (context, isExpanded, _) {
                      return AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: tasks.isEmpty
                              ? AppColors.textDisabled
                              : AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: ValueListenableBuilder(
              valueListenable: _isExpanded,
              builder: (context, isExpanded, _) {
                return AnimatedAlign(
                  alignment: Alignment.topCenter,
                  heightFactor: isExpanded ? 1 : 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      children: tasks
                          .map(
                            (task) => Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: TaskListTile(task: task),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isExpanded.dispose();
    super.dispose();
  }

  String _titleForType(TaskType type) {
    switch (type) {
      case TaskType.daily:
        return 'Каждый день';
      case TaskType.weekly:
        return 'Каждую неделю';
      case TaskType.monthly:
        return 'Каждый месяц';
      case TaskType.yearly:
        return 'Каждый год';
      case TaskType.oneTime:
        return 'Разовые';
    }
  }
}

class _TaskCount extends StatelessWidget {
  const _TaskCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 28),
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _TaskTypeIcon extends StatelessWidget {
  const _TaskTypeIcon({required this.type});

  final TaskType type;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      TaskType.daily => Icons.today_rounded,
      TaskType.weekly => Icons.view_week_rounded,
      TaskType.monthly => Icons.calendar_month_rounded,
      TaskType.yearly => Icons.event_repeat_rounded,
      TaskType.oneTime => Icons.push_pin_outlined,
    };

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, size: 20, color: AppColors.primary),
    );
  }
}
