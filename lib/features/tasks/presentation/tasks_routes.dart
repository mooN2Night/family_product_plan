import 'package:family_product_plan/features/tasks/presentation/screen/task_create_screen.dart';
import 'package:family_product_plan/features/tasks/presentation/screen/task_info_screen.dart';
import 'package:family_product_plan/features/tasks/presentation/screen/tasks_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// Класс для роутов экрана задач
abstract final class TasksRoutes {
  /// Название роута экрана задач
  static const String tasksScreenName = 'tasks_screen';

  /// Название роута экрана создания задачи
  static const String taskCreateScreenName = 'task_create_screen';

  /// Название роута экрана создания задачи
  static const String taskInfoScreenName = 'task_info_screen';

  /// Путь роута экрана задач
  static const String _tasksScreenPath = '/tasks';

  /// Путь роута экрана создания задачи
  static const String _taskCreateScreenPath = 'task_create';

  /// Путь роута экрана создания задачи
  static const String _taskInfoScreenPath = 'task_info/:id';

  /// Метод для построения ветки роутов экрана задач
  ///
  /// Принимает:
  /// - [routes] - вложенные роуты
  static StatefulShellBranch buildShellBranch({
    List<RouteBase> routes = const [],
    List<NavigatorObserver>? observers,
  }) => StatefulShellBranch(
    initialLocation: _tasksScreenPath,
    observers: observers,
    routes: [
      GoRoute(
        path: _tasksScreenPath,
        name: tasksScreenName,
        builder: (context, state) => const TasksScreen(),
        routes: [
          GoRoute(
            path: _taskCreateScreenPath,
            name: taskCreateScreenName,
            builder: (context, state) => const TaskCreateScreen(),
          ),
          GoRoute(
            path: _taskInfoScreenPath,
            name: taskInfoScreenName,
            builder: (context, state) {
              final id = state.pathParameters['id'];

              assert(
                id != null,
                'Для открытия экрана просмотра задачи нужно передать обязательные параметры',
              );

              return TaskInfoScreen(id: id!);
            },
          ),
          ...routes,
        ],
      ),
    ],
  );
}
