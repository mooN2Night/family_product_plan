import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/domain/entity/product_create_entity.dart';
import '../../features/home/domain/state/products_bloc/products_bloc.dart';
import '../ui_kit/app_box.dart';
import '../ui_kit/app_snack_bar.dart';

/// Отображает диалог добавления нового продукта.
///
/// В зависимости от платформы показывает нативный диалог:
/// - iOS — [CupertinoAlertDialog];
/// - Android и другие платформы — [AlertDialog].
Future<void> showAddProductDialog(BuildContext parentContext) async {
  final productsBloc = parentContext.read<ProductsBloc>();

  if (Platform.isIOS) {
    await showCupertinoDialog(
      context: parentContext,
      builder: (context) {
        return _Dialog(productsBloc: productsBloc);
      },
    );
  } else {
    await showDialog(
      context: parentContext,
      builder: (context) {
        return _Dialog(productsBloc: productsBloc);
      },
    );
  }
}

/// Диалог добавления нового продукта.
class _Dialog extends StatefulWidget {
  const _Dialog({required this.productsBloc});

  /// BLoC для управления списком продуктов.
  final ProductsBloc productsBloc;

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  /// Контроллер поля названия продукта.
  late final TextEditingController _productController;

  /// Контроллер поля производителя продукта.
  late final TextEditingController _manufacturerController;

  /// Флаг необходимости покупки продукта.
  bool _isNeedToBuy = false;

  @override
  void initState() {
    super.initState();
    _productController = TextEditingController();
    _manufacturerController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить новый продукт'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Напишите название'),
          TextField(
            controller: _productController,
            decoration: const InputDecoration(
              hint: Text(
                'Например "Молоко"',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          const HBox(10),
          const Text('Напишите производителя'),
          TextField(
            controller: _manufacturerController,
            decoration: const InputDecoration(
              hint: Text(
                'Например "Простоквашино"',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          const HBox(10),
          Row(
            children: [
              const Expanded(
                child: Text('Добавить сразу в список "Нужно купить"?'),
              ),
              Checkbox(
                value: _isNeedToBuy,
                onChanged: (value) {
                  setState(() {
                    _isNeedToBuy = value ?? false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_productController.text.isNotEmpty) {
              final product = ProductCreateEntity(
                productName: _productController.text,
                productManufacturer: _manufacturerController.text,
                isToBuy: _isNeedToBuy,
              );

              widget.productsBloc.add(ProductAddEvent(product: product));
              context.pop();
            } else {
              AppSnackBar.showError(
                context,
                message: 'Название не может быть пустым',
              );
            }
          },
          child: const Text('Добавить'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _productController.dispose();
    _manufacturerController.dispose();
    super.dispose();
  }
}
