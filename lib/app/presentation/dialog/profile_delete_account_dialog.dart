import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showDeleteAccountDialog(BuildContext context) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Удалить аккаунт?'),
        content: const Text(
          'Все данные аккаунта будут удалены. '
          'Это действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => context.pop(true),
            child: const Text('Удалить'),
          ),
        ],
      );
    },
  );

  if (shouldDelete != true || !context.mounted) {
    return;
  }

  // Здесь позже сделаем нормальный сценарий:
  // 1. запросить пароль;
  // 2. reauthenticate Firebase;
  // 3. удалить аккаунт.
}
