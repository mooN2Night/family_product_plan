import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/dialog/poduct_delete_dialog.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/state/products_action_bloc/products_action_bloc.dart';
import '../home_routes.dart';
import 'home_info_modal_view.dart';

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
        _HomeProductsListView(hasFamily: hasFamily, products: products),
        _HomeProductsListView(hasFamily: hasFamily, products: productsToBuy),
      ],
    );
  }
}

class _HomeProductsListView extends StatelessWidget {
  const _HomeProductsListView({
    required this.products,
    required this.hasFamily,
  });

  final List<ProductEntity> products;
  final bool hasFamily;

  @override
  Widget build(BuildContext context) {
    final actionBloc = context.read<ProductsActionBloc>();

    if (products.isEmpty) {
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          if (!hasFamily) const HomeInfoModalView(),
          const SizedBox(height: 32),
          const Center(child: Text('Добавьте Ваши продукты')),
        ],
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: products.length + (hasFamily ? 0 : 1),
      itemBuilder: (context, index) {
        if (!hasFamily && index == 0) {
          return const HomeInfoModalView();
        }

        final product = products[hasFamily ? index : index - 1];

        return ListTile(
          title: Text(product.productName),
          subtitle: product.productManufacturer.isNotEmpty
              ? Text(product.productManufacturer)
              : null,
          leading: Checkbox(
            value: product.isToBuy,
            onChanged: (_) {
              actionBloc.add(ProductActionToggleEvent(product: product));
            },
          ),
          onTap: () => context.goNamed(
            HomeRoutes.homeDetailScreenName,
            queryParameters: {'id': product.id},
          ),
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
