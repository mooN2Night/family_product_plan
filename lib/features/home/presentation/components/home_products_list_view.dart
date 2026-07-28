import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/dialog/poduct_delete_dialog.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/state/products_action_bloc/products_action_bloc.dart';
import '../home_routes.dart';
import 'home_info_modal_view.dart';

class HomeProductsListView extends StatelessWidget {
  const HomeProductsListView({
    required this.products,
    required this.hasFamily,
    super.key,
  });

  final List<ProductEntity> products;
  final bool hasFamily;

  @override
  Widget build(BuildContext context) {
    final actionBloc = context.read<ProductsActionBloc>();

    if (products.isEmpty) {
      return ListView(
        children: [
          if (!hasFamily) const HomeInfoModalView(),
          const SizedBox(height: 32),
          const Center(child: Text('Добавьте Ваши продукты')),
        ],
      );
    }

    return ListView.builder(
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
          onTap: () {
            context.goNamed(
              HomeRoutes.homeDetailScreenName,
              queryParameters: {'id': product.id},
            );
          },
          onLongPress: () {
            showDeleteProductDialog(
              context,
              productName: product.productName,
              onDeletePressed: () {
                actionBloc.add(ProductActionDeleteEvent(id: product.id));
              },
            );
          },
        );
      },
    );
  }
}
