import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_lost_focus_wrapper.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_snack_bar.dart';
import 'package:family_product_plan/features/home/domain/state/products_action_bloc/products_action_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/ui_kit/app_field_group.dart';
import '../../../../app/presentation/ui_kit/app_text_field.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/product_create_entity.dart';

class ProductAddScreen extends StatelessWidget {
  const ProductAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeRepository = context.di.repositories.homeRepository;

    return BlocProvider(
      create: (context) => ProductsActionBloc(homeRepository: homeRepository),
      child: const AppLostFocusWrapper(child: _ProductAddView()),
    );
  }
}

class _ProductAddView extends StatefulWidget {
  const _ProductAddView();

  @override
  State<_ProductAddView> createState() => _ProductAddViewState();
}

class _ProductAddViewState extends State<_ProductAddView> {
  late final TextEditingController _nameController;
  late final TextEditingController _manufacturerController;
  late final TextEditingController _quantityController;
  late final TextEditingController _descriptionController;

  late final ValueNotifier<bool> _isToBuyNotifier;
  late final ValueNotifier<bool> _isValidNotifier;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _manufacturerController = TextEditingController();
    _quantityController = TextEditingController();
    _descriptionController = TextEditingController();
    _isToBuyNotifier = ValueNotifier<bool>(false);
    _isValidNotifier = ValueNotifier<bool>(false);

    _nameController.addListener(_updateValidity);
    _manufacturerController.addListener(_updateValidity);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsActionBloc, ProductsActionState>(
      listener: (context, state) {
        if (state is ProductsActionSuccessState) context.pop();

        if (state is ProductsActionErrorState) {
          AppSnackBar.showError(
            context,
            message: 'Произошла непредвиденная ошибка',
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar.secondary(title: 'Добавить продукт'),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          children: [
            AppFieldGroup(
              children: [
                AppTextField(
                  icon: Icons.shopping_basket_outlined,
                  label: 'Название продукта',
                  controller: _nameController,
                  hint: 'Молоко',
                  autofocus: true,
                ),
                const AppFieldDivider(),
                AppTextField(
                  icon: Icons.factory_outlined,
                  label: 'Производитель',
                  controller: _manufacturerController,
                  hint: 'Простоквашино',
                ),
                const AppFieldDivider(),
                AppTextField(
                  icon: Icons.scale_outlined,
                  label: 'Количество',
                  controller: _quantityController,
                  hint: '2 л, 3 шт, 500 г',
                ),
              ],
            ),
            const HBox(16),
            AppFieldGroup(
              children: [
                AppTextField(
                  icon: Icons.notes_outlined,
                  label: 'Описание',
                  controller: _descriptionController,
                  hint: 'Необязательно',
                  maxLines: 3,
                ),
              ],
            ),
            const HBox(16),
            AppFieldGroup(
              children: [
                ValueListenableBuilder(
                  valueListenable: _isToBuyNotifier,
                  builder: (context, isToBuy, _) {
                    return _ToggleTile(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Нужно купить',
                      subtitle: 'Добавить в список покупок',
                      value: isToBuy,
                      onChanged: (value) => _isToBuyNotifier.value = value,
                    );
                  },
                ),
              ],
            ),
            const HBox(28),
            ValueListenableBuilder(
              valueListenable: _isValidNotifier,
              builder: (context, isValid, _) {
                return BlocBuilder<ProductsActionBloc, ProductsActionState>(
                  builder: (context, state) {
                    final isLoading = state is ProductsActionLoadingState;

                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isValid && !isLoading
                            ? () => _handleSave(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.textDisabled,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Сохранить',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_updateValidity)
      ..dispose();
    _manufacturerController
      ..removeListener(_updateValidity)
      ..dispose();
    _quantityController.dispose();
    _descriptionController.dispose();

    _isToBuyNotifier.dispose();
    _isValidNotifier.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _manufacturerController.text.trim().isNotEmpty;

  void _updateValidity() {
    _isValidNotifier.value = _isValid;
  }

  void _handleSave(BuildContext context) {
    if (!_isValid) return;

    final product = ProductCreateEntity(
      productName: _nameController.text.trim(),
      productManufacturer: _manufacturerController.text.trim(),
      quantity: _quantityController.text.trim().isEmpty
          ? null
          : _quantityController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      isToBuy: _isToBuyNotifier.value,
    );

    context.read<ProductsActionBloc>().add(
      ProductActionAddEvent(product: product),
    );
  }
}

/// Строка с тумблером «Нужно купить».
class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const WBox(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const HBox(2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
