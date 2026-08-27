import 'dart:io';

import 'package:family_product_plan/features/card/domain/entity/create_card_entity.dart';
import 'package:family_product_plan/features/card/domain/state/card_action/card_action_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../ui_kit/app_box.dart';
import '../ui_kit/app_snack_bar.dart';

/// Отображает диалог добавления нового продукта.
///
/// В зависимости от платформы показывает нативный диалог:
/// - iOS — [CupertinoAlertDialog];
/// - Android и другие платформы — [AlertDialog].
Future<void> showAddCardDialog(BuildContext parContext) async {
  final actionBloc = parContext.read<CardActionBloc>();

  if (Platform.isIOS) {
    await showCupertinoDialog(
      context: parContext,
      builder: (parContext) => _Dialog(actionBloc: actionBloc),
    );
  } else {
    await showDialog(
      context: parContext,
      builder: (parContext) => _Dialog(actionBloc: actionBloc),
    );
  }
}

/// Диалог добавления нового продукта.
class _Dialog extends StatefulWidget {
  const _Dialog({required this.actionBloc});

  final CardActionBloc actionBloc;

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  /// Контроллер поля названия карты.
  late final TextEditingController _cardNameController;

  /// Контроллер поля номера карты.
  late final TextEditingController _cardNumberController;

  @override
  void initState() {
    super.initState();
    _cardNameController = TextEditingController();
    _cardNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardActionBloc, CardActionState>(
      bloc: widget.actionBloc,
      listener: (context, state) {
        if (state is CardActionSuccessState) {
          context.pop();
        }
      },
      child: AlertDialog(
        title: const Text('Добавить новую карту'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Название магазина'),
            TextField(
              controller: _cardNameController,
              decoration: const InputDecoration(
                hint: Text(
                  'Например "Магнит"',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
            const HBox(10),
            const Text('Номер карты'),
            TextField(controller: _cardNumberController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_cardNameController.text.isNotEmpty &&
                  _cardNumberController.text.isNotEmpty) {
                final card = CreateCardEntity(
                  name: _cardNameController.text,
                  number: _cardNumberController.text,
                );

                widget.actionBloc.add(CardActionAddEvent(card: card));
              } else {
                AppSnackBar.showError(
                  context,
                  message: 'Название и номер карты не может быть пустым',
                );
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }
}
