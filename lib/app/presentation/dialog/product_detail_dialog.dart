import 'package:family_product_plan/app/presentation/ui_kit/app_actions_tile.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/home/domain/entity/product_entity.dart';
import '../../../features/home/domain/state/products_action_bloc/products_action_bloc.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_utils.dart';
import '../ui_kit/app_box.dart';
import '../ui_kit/app_toggle_tile.dart';

/// Отображает диалог добавления нового продукта.
///
/// В зависимости от платформы показывает нативный диалог:
/// - iOS — [CupertinoAlertDialog];
/// - Android и другие платформы — [AlertDialog].
Future<void> showDetailProductModal(
  BuildContext parentContext, {
  required ProductEntity product,
}) async {
  final productsActionBloc = parentContext.read<ProductsActionBloc>();

  await showModalBottomSheet(
    context: parentContext,
    useRootNavigator: true,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) =>
        _DetailProductModal(product: product, bloc: productsActionBloc),
  );
}

// TODO: где то баг
class _DetailProductModal extends StatefulWidget {
  const _DetailProductModal({required this.product, required this.bloc});

  final ProductEntity product;
  final ProductsActionBloc bloc;

  @override
  State<_DetailProductModal> createState() => _DetailProductModalState();
}

class _DetailProductModalState extends State<_DetailProductModal> {
  late final TextEditingController _nameController;
  late final TextEditingController _manufacturerController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;

  late final ValueNotifier<bool> _isToBuyNotifier;
  late final ValueNotifier<bool> _isNameChangingNotifier;
  late final ValueNotifier<bool> _isManufacturerChangingNotifier;
  late final ValueNotifier<bool> _isQuantityChangingNotifier;
  late final ValueNotifier<bool> _isDescriptionChangingNotifier;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.productName);
    _isToBuyNotifier = ValueNotifier<bool>(widget.product.isToBuy);
    _isNameChangingNotifier = ValueNotifier<bool>(false);
    _manufacturerController = TextEditingController(
      text: widget.product.productManufacturer,
    );
    _quantityController = TextEditingController(text: widget.product.quantity);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );

    _isManufacturerChangingNotifier = ValueNotifier<bool>(false);
    _isQuantityChangingNotifier = ValueNotifier<bool>(false);
    _isDescriptionChangingNotifier = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final actionBloc = widget.bloc;
    final zeroPadding = EdgeInsets.zero;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const HBox(16),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const HBox(16),
              _ProductEdit(
                icon: Icons.shopping_basket_outlined,
                title: 'Название',
                changeNotifier: _isNameChangingNotifier,
                controller: _nameController,
                onTap: () {
                  if (_nameController.text == product.productName) {
                    _isNameChangingNotifier.value = false;
                    return;
                  }

                  final updatedProduct = product.copyWith(
                    productName: _nameController.text,
                    updatedAt: DateTime.now(),
                  );

                  actionBloc.add(
                    ProductActionUpdateEvent(product: updatedProduct),
                  );

                  _isNameChangingNotifier.value = false;
                },
              ),

              if (product.quantity.isNotEmpty) ...[
                HBox(24),
                _ProductEdit(
                  icon: Icons.numbers_rounded,
                  title: 'Количество',
                  changeNotifier: _isQuantityChangingNotifier,
                  controller: _quantityController,
                  onTap: () {
                    if (_quantityController.text == product.quantity) {
                      _isQuantityChangingNotifier.value = false;
                      return;
                    }

                    final updatedProduct = product.copyWith(
                      quantity: _quantityController.text,
                      updatedAt: DateTime.now(),
                    );

                    actionBloc.add(
                      ProductActionUpdateEvent(product: updatedProduct),
                    );

                    _isQuantityChangingNotifier.value = false;
                  },
                ),
              ],

              if (product.productManufacturer.isNotEmpty) ...[
                HBox(24),
                _ProductEdit(
                  icon: Icons.factory_outlined,
                  title: 'Производитель',
                  changeNotifier: _isManufacturerChangingNotifier,
                  controller: _manufacturerController,
                  onTap: () {
                    if (_manufacturerController.text ==
                        product.productManufacturer) {
                      _isManufacturerChangingNotifier.value = false;
                      return;
                    }

                    final updatedProduct = product.copyWith(
                      productManufacturer: _manufacturerController.text,
                      updatedAt: DateTime.now(),
                    );

                    actionBloc.add(
                      ProductActionUpdateEvent(product: updatedProduct),
                    );

                    _isManufacturerChangingNotifier.value = false;
                  },
                ),
              ],

              if (product.description.isNotEmpty) ...[
                HBox(24),
                _ProductEdit(
                  icon: Icons.notes_rounded,
                  title: 'Описание',
                  changeNotifier: _isDescriptionChangingNotifier,
                  controller: _descriptionController,
                  onTap: () {
                    if (_descriptionController.text == product.description) {
                      _isDescriptionChangingNotifier.value = false;
                      return;
                    }

                    final updatedProduct = product.copyWith(
                      description: _descriptionController.text,
                      updatedAt: DateTime.now(),
                    );

                    actionBloc.add(
                      ProductActionUpdateEvent(product: updatedProduct),
                    );

                    _isDescriptionChangingNotifier.value = false;
                  },
                ),
              ],

              HBox(16),
              ValueListenableBuilder(
                valueListenable: _isToBuyNotifier,
                builder: (context, isToBuy, _) {
                  return AppToggleTile(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Нужно купить',
                    subtitle: 'Добавить в список покупок',
                    value: isToBuy,
                    onChanged: (value) {
                      _isToBuyNotifier.value = value;
                      actionBloc.add(
                        ProductActionToggleEvent(
                          product: product.copyWith(
                            isToBuy: _isToBuyNotifier.value,
                          ),
                        ),
                      );
                    },
                    padding: zeroPadding,
                  );
                },
              ),
              HBox(24),
              _ProductDates(
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
              ),
              HBox(24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _manufacturerController.dispose();
    _descriptionController.dispose();

    _isToBuyNotifier.dispose();
    _isNameChangingNotifier.dispose();
    _isQuantityChangingNotifier.dispose();
    _isManufacturerChangingNotifier.dispose();
    _isDescriptionChangingNotifier.dispose();
    super.dispose();
  }
}

class _ProductEdit extends StatelessWidget {
  const _ProductEdit({
    required this.icon,
    required this.title,
    required this.changeNotifier,
    required this.controller,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final ValueNotifier<bool> changeNotifier;
  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final zeroPadding = EdgeInsets.zero;

    return ValueListenableBuilder(
      valueListenable: changeNotifier,
      builder: (context, change, _) {
        if (change) {
          return AppTextField(
            controller: controller,
            label: title,
            icon: icon,
            textCapitalization: TextCapitalization.sentences,
            padding: zeroPadding,
            autofocus: true,
            onFieldSubmitted: (value) => onTap.call(),
            suffix: GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.save_outlined,
                size: 24,
                color: AppColors.primary,
              ),
            ),
          );
        } else {
          return AppActionTile(
            icon: icon,
            label: title,
            onTap: () => changeNotifier.value = !changeNotifier.value,
            value: controller.text,
            showChangeIcon: true,
            padding: zeroPadding,
            onChangeTap: () => changeNotifier.value = !changeNotifier.value,
          );
        }
      },
    );
  }
}

class _ProductDates extends StatelessWidget {
  const _ProductDates({required this.createdAt, required this.updatedAt});

  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    final formatedDateCreatedAt = AppUtils.formatDate(createdAt);
    final formatedDateUpdatedAt = AppUtils.formatDate(updatedAt);
    final formatedTimeCreatedAt = AppUtils.formatTime(createdAt);
    final formatedTimeUpdatedAt = AppUtils.formatTime(updatedAt);

    return Column(
      children: [
        _ProductDateRow(
          title: 'Создан',
          value: '$formatedDateCreatedAt в $formatedTimeCreatedAt',
        ),
        if (updatedAt != createdAt) ...[
          const HBox(8),
          _ProductDateRow(
            title: 'Изменён',
            value: '$formatedDateUpdatedAt в $formatedTimeUpdatedAt',
          ),
        ],
      ],
    );
  }
}

class _ProductDateRow extends StatelessWidget {
  const _ProductDateRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
