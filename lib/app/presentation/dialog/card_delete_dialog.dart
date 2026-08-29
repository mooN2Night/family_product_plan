import 'dart:io';

import 'package:family_product_plan/app/utils/app_colors.dart';
import 'package:family_product_plan/features/card/domain/state/card_action/card_action_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Отображает диалог добавления нового продукта.
///
/// В зависимости от платформы показывает нативный диалог:
/// - iOS — [CupertinoAlertDialog];
/// - Android и другие платформы — [AlertDialog].
Future<void> showDeleteCardDialog(
  BuildContext context, {
  required String name,
  required String id,
}) async {
  final actionBloc = context.read<CardActionBloc>();

  if (Platform.isIOS) {
    await showCupertinoDialog(
      context: context,
      builder: (context) => _Dialog(actionBloc: actionBloc, name: name, id: id),
    );
  } else {
    await showDialog(
      context: context,
      builder: (context) => _Dialog(actionBloc: actionBloc, name: name, id: id),
    );
  }
}

/// Диалог добавления нового продукта.
class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.actionBloc,
    required this.name,
    required this.id,
  });

  final CardActionBloc actionBloc;
  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<CardActionBloc, CardActionState>(
      bloc: actionBloc,
      listener: (context, state) {
        if (state is CardActionSuccessState) context.pop();
      },
      child: AlertDialog(
        title: Text('Удалить карту "$name"?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('После удаления её нужно будет создавать заново'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Отмена',
              style: textTheme.titleMedium?.copyWith(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () => actionBloc.add(CardActionDeleteEvent(id: id)),
            child: Text(
              'Удалить',
              style: textTheme.titleSmall?.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
