import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Отображает диалог подтверждения удаления продукта.
///
/// В зависимости от платформы показывает нативный диалог:
/// - iOS — [CupertinoAlertDialog];
/// - Android и другие платформы — [AlertDialog].
Future<void> showDeleteProductDialog(
  BuildContext context, {
  required String productName,
  required VoidCallback onDeletePressed,
}) async {
  if (Platform.isIOS) {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return _Dialog(
          productName: productName,
          onDeletePressed: onDeletePressed,
        );
      },
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) {
        return _Dialog(
          productName: productName,
          onDeletePressed: onDeletePressed,
        );
      },
    );
  }
}

/// Диалог подтверждения удаления продукта.
class _Dialog extends StatelessWidget {
  const _Dialog({required this.productName, required this.onDeletePressed});

  /// Название удаляемого продукта.
  final String productName;

  /// Колбэк, вызываемый при подтверждении удаления.
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Удалить?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Вы действительно хотите удалить "$productName"',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Отмена', style: TextStyle(fontSize: 18)),
        ),
        TextButton(
          onPressed: () {
            onDeletePressed.call();
            context.pop();
          },
          child: const Text('Удалить', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
