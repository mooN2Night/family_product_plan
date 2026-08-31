import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/presentation/dialog/poduct_delete_dialog.dart';
import '../../../../app/presentation/dialog/product_detail_dialog.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/state/products_action_bloc/products_action_bloc.dart';
import 'home_info_modal_view.dart';

enum _ListMode { catalog, shoppingList }

class HomeTabBarListView extends StatelessWidget {
  const HomeTabBarListView({
    required this.hasFamily,
    required this.products,
    required this.productsToBuy,
    super.key,
  });

  final bool hasFamily;
  final List<ProductEntity> products;
  final List<ProductEntity> productsToBuy;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        _HomeProductsListView(
          hasFamily: hasFamily,
          products: products,
          mode: _ListMode.catalog,
        ),
        _HomeProductsListView(
          hasFamily: hasFamily,
          products: productsToBuy,
          mode: _ListMode.shoppingList,
        ),
      ],
    );
  }
}

class _HomeProductsListView extends StatefulWidget {
  const _HomeProductsListView({
    required this.products,
    required this.hasFamily,
    required this.mode,
  });

  final List<ProductEntity> products;
  final bool hasFamily;
  final _ListMode mode;

  @override
  State<_HomeProductsListView> createState() => _HomeProductsListViewState();
}

class _HomeProductsListViewState extends State<_HomeProductsListView> {
  @override
  Widget build(BuildContext context) {
    final actionBloc = context.read<ProductsActionBloc>();

    if (widget.products.isEmpty) {
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          if (!widget.hasFamily) const HomeInfoModalView(),
          const HBox(32),
          Center(
            child: Text(
              widget.mode == _ListMode.shoppingList
                  ? 'Список покупок пуст'
                  : 'Добавьте Ваши продукты',
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.products.length + (widget.hasFamily ? 0 : 1),
      itemBuilder: (context, index) {
        if (!widget.hasFamily && index == 0) {
          return const HomeInfoModalView();
        }

        final product = widget.products[widget.hasFamily ? index : index - 1];
        bool toBuy = product.isToBuy;

        return ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          title: Text(product.productName),
          subtitle: product.productManufacturer.isNotEmpty
              ? Text(product.productManufacturer)
              : null,
          leading: widget.mode == _ListMode.shoppingList
              ? Checkbox(
                  value: false,
                  onChanged: (checked) => actionBloc.add(
                      ProductActionToggleEvent(
                        product: product.copyWith(isToBuy: false),
                      ),
                    ),
                )
              : _ToBuyToggleButton(
                  isToBuy: toBuy,
                  onTap: () {
                    setState(() => toBuy = !toBuy);

                    actionBloc.add(
                      ProductActionToggleEvent(
                        product: product.copyWith(isToBuy: toBuy),
                      ),
                    );
                  },
                ),
          trailing: widget.mode == _ListMode.catalog
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_ToBuyBadge(visible: product.isToBuy)],
                )
              : null,
          onTap: () => showDetailProductModal(context, product: product),
          onLongPress: () => showDeleteProductDialog(
            context,
            productName: product.productName,
            onDeletePressed: () {
              actionBloc.add(ProductActionDeleteEvent(id: product.id));
            },
          ),
        );
      },
    );
  }
}

/// Кнопка-переключатель "добавить/убрать из списка покупок"
class _ToBuyToggleButton extends StatefulWidget {
  const _ToBuyToggleButton({required this.isToBuy, required this.onTap});

  final bool isToBuy;
  final VoidCallback onTap;

  @override
  State<_ToBuyToggleButton> createState() => _ToBuyToggleButtonState();
}

class _ToBuyToggleButtonState extends State<_ToBuyToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 0.0,
      upperBound: 0.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _handleTap,
      tooltip: widget.isToBuy
          ? 'Убрать из списка покупок'
          : 'Добавить в список покупок',
      icon: ScaleTransition(
        scale: Tween(
          begin: 1.0,
          end: 1.25,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: widget.isToBuy
              ? Icon(
                  Icons.shopping_cart,
                  key: const ValueKey('toBuy'),
                  color: AppColors.softError,
                )
              : Icon(
                  Icons.shopping_cart_outlined,
                  key: const ValueKey('notToBuy'),
                  color: AppColors.primary,
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    // лёгкий "прыжок" при нажатии
    _controller.forward(from: 0).then((_) => _controller.reverse());
    widget.onTap();
  }
}

/// Небольшой бейдж-подсказка на вкладке "Все продукты"
class _ToBuyBadge extends StatelessWidget {
  const _ToBuyBadge({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: visible
          ? Container(
              key: const ValueKey('badge'),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.softErrorBack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Закончился',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.softError,
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}
