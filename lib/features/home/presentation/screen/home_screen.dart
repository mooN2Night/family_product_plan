import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/home/presentation/home_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/dialog/poduct_delete_dialog.dart';
import '../../../../app/dialog/product_add_dialog.dart';
import '../../../../app/ui_kit/app_bar.dart';
import '../../domain/state/products_bloc.dart';

/// Класс для отображения главного экрана
///
/// Инициализируется блок и запрашивается ивент получения списка покупок
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeRepository = context.di.repositories.homeRepository;
    return BlocProvider(
      create: (context) =>
          ProductsBloc(homeRepository: homeRepository)
            ..add(const ProductsWatchEvent()),
      child: const HomeScreenView(),
    );
  }
}

/// Класс для отображения содержимого главного экрана
class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar.main(
          actions: [
            IconButton(
              onPressed: () => showAddProductDialog(context),
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: const TabBar(
            dividerHeight: 0,
            indicatorColor: Colors.lightBlueAccent,
            labelStyle: TextStyle(color: Colors.lightBlueAccent),
            tabs: [
              Tab(child: Text('Список всех продуктов')),
              Tab(child: Text('Нужно купить')),
            ],
          ),
        ),
        body: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final products = state.products;
            final productsToBuy = products
                .where((product) => product.isToBuy)
                .toList();

            if (products.isEmpty) {
              return const Center(child: Text('Добавьте Ваши продукты'));
            }

            final productsBloc = context.read<ProductsBloc>();

            return TabBarView(
              children: [
                ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ListTile(
                      title: Text(product.productName),
                      titleTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      subtitle: product.productManufacturer.isNotEmpty
                          ? Text(product.productManufacturer)
                          : null,
                      subtitleTextStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      leading: Checkbox(
                        value: product.isToBuy,
                        onChanged: (value) => productsBloc.add(
                          ProductToggleEvent(product: product),
                        ),
                        activeColor: Colors.blueGrey,
                      ),
                      onLongPress: () => showDeleteProductDialog(
                        context,
                        productName: product.productName,
                        onDeletePressed: () {
                          if (product.id == null) return;
                          productsBloc.add(ProductDeleteEvent(id: product.id!));
                        },
                      ),
                      onTap: () => _openProductDetail(
                        context,
                        id: product.id.toString(),
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: productsToBuy.length,
                  itemBuilder: (context, index) {
                    final product = productsToBuy[index];

                    return ListTile(
                      title: Text(product.productName),
                      titleTextStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      subtitle: product.productManufacturer.isNotEmpty
                          ? Text(product.productManufacturer)
                          : null,
                      subtitleTextStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                      leading: Checkbox(
                        value: product.isToBuy,
                        onChanged: (value) => productsBloc.add(
                          ProductToggleEvent(product: product),
                        ),
                        activeColor: Colors.blueGrey,
                      ),
                      onTap: () => _openProductDetail(
                        context,
                        id: product.id.toString(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Метод для перехода на экран детальной информации
  void _openProductDetail(BuildContext context, {required String id}) {
    context.goNamed(
      HomeRoutes.homeDetailScreenName,
      queryParameters: {'id': id},
    );
  }
}
