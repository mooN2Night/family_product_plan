import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_lost_focus_wrapper.dart';
import 'package:family_product_plan/features/tasks/domain/state/task_action/tasks_action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/presentation/ui_kit/app_actions_tile.dart';
import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../../../../app/presentation/ui_kit/app_dropdown_field.dart';
import '../../../../app/presentation/ui_kit/app_field_group.dart';
import '../../../../app/presentation/ui_kit/app_snack_bar.dart';
import '../../../../app/presentation/ui_kit/app_text_field.dart';
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
      child: const AppLostFocusWrapper(child: _TaskCreateView()),
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
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            AppFieldGroup(
              children: [
                AppTextField(
                  icon: Icons.task_alt_outlined,
                  label: 'Название',
                  controller: _titleController,
                  hint: 'Например: Вынести мусор',
                  autofocus: true,
                ),
                const AppFieldDivider(),
                AppTextField(
                  icon: Icons.notes_outlined,
                  label: 'Описание',
                  controller: _descriptionController,
                  hint: 'Необязательно',
                  minLines: 3,
                  maxLines: 5,
                ),
              ],
            ),
            const HBox(16),
            AppFieldGroup(
              children: [
                ValueListenableBuilder<TaskPriority>(
                  valueListenable: _priority,
                  builder: (context, priority, _) {
                    return AppDropdownField<TaskPriority>(
                      icon: Icons.flag_outlined,
                      label: 'Приоритет',
                      value: priority,
                      items: TaskPriority.values,
                      itemLabelBuilder: (item) => item.title,
                      onChanged: (value) => _priority.value = value,
                    );
                  },
                ),
                const AppFieldDivider(),
                ValueListenableBuilder<TaskType>(
                  valueListenable: _taskType,
                  builder: (context, type, _) {
                    return AppDropdownField<TaskType>(
                      icon: Icons.repeat_outlined,
                      label: 'Тип задачи',
                      value: type,
                      items: TaskType.values,
                      itemLabelBuilder: (item) => item.title,
                      onChanged: (value) {
                        _taskType.value = value;
                        _dueDate.value = null;
                        _weekday.value = null;
                      },
                    );
                  },
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: _taskType,
              builder: (context, type, _) {
                switch (type) {
                  case TaskType.oneTime:
                    return Column(
                      children: [
                        const HBox(16),
                        AppFieldGroup(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _dueDate,
                              builder: (context, date, _) {
                                return AppActionTile(
                                  icon: Icons.calendar_month_outlined,
                                  label: 'Срок выполнения',
                                  // во второй ветке — 'Дата задачи'
                                  value: date == null
                                      ? 'Не выбрана'
                                      : DateFormat('dd.MM.yyyy').format(date),
                                  trailingIcon: Icons.calendar_month,
                                  onTap: () => _selectDate(context),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );

                  case TaskType.monthly || TaskType.yearly:
                    return Column(
                      children: [
                        const HBox(16),
                        AppFieldGroup(
                          children: [
                            ValueListenableBuilder<DateTime?>(
                              valueListenable: _dueDate,
                              builder: (context, date, _) {
                                return AppActionTile(
                                  icon: Icons.calendar_month_outlined,
                                  label: 'Срок выполнения',
                                  // во второй ветке — 'Дата задачи'
                                  value: date == null
                                      ? 'Не выбрана'
                                      : DateFormat('dd.MM.yyyy').format(date),
                                  trailingIcon: Icons.calendar_month,
                                  onTap: () => _selectDate(context),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    );

                  case TaskType.weekly:
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HBox(24),
                        const Text(
                          'День недели',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const HBox(10),
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

                  case _:
                    return HWBox.shrink();
                }
              },
            ),
            const HBox(28),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ValueListenableBuilder(
                valueListenable: _titleController,
                builder: (context, title, _) {
                  return ElevatedButton(
                    onPressed: title.text.isEmpty
                        ? null
                        : () => _createTask(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Создать задачу',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
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
      if (type == TaskType.weekly) {
        AppSnackBar.showError(
          context,
          message: 'Для еженедельных задач необходимо указать день недели',
        );

        return;
      }
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

  Future<void> _selectDate(BuildContext context) async {
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
