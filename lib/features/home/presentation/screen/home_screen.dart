import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/features/home/domain/state/current_family_cubit/current_family_cubit.dart';
import 'package:family_product_plan/features/home/presentation/home_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/dialog/poduct_delete_dialog.dart';
import '../../../../app/dialog/product_add_dialog.dart';
import '../../../../app/ui_kit/app_bar.dart';
import '../../domain/state/products_bloc/products_bloc.dart';
import '../components/home_info_modal_view.dart';

/// Класс для отображения главного экрана
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeRepository = context.di.repositories.homeRepository;
    final provider = context.di.services.currentFamilyProvider;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProductsBloc(homeRepository: homeRepository)
                ..add(const ProductsWatchEvent()),
        ),
        BlocProvider(
          create: (context) => CurrentFamilyCubit(provider: provider),
        ),
      ],
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

            return BlocBuilder<CurrentFamilyCubit, String?>(
              builder: (context, familyId) {
                final hasFamily = familyId != null;

                if (products.isEmpty && !hasFamily) {
                  return const Center(
                    child: Column(
                      children: [
                        HomeInfoModalView(),
                        Center(child: Text('Добавьте Ваши продукты')),
                      ],
                    ),
                  );
                }

                final productsBloc = context.read<ProductsBloc>();

                return BlocBuilder<CurrentFamilyCubit, String?>(
                  builder: (context, familyId) {
                    final hasFamily = familyId != null;

                    return TabBarView(
                      children: [
                        ListView.builder(
                          itemCount: products.length + (hasFamily ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (!hasFamily && index == 0) {
                              return const HomeInfoModalView();
                            }

                            final productIndex = hasFamily ? index : index - 1;
                            final product = products[productIndex];

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
                                  productsBloc.add(
                                    ProductDeleteEvent(id: product.id),
                                  );
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
                          itemCount: productsToBuy.length + (hasFamily ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (!hasFamily && index == 0) {
                              return const HomeInfoModalView();
                            }

                            final productIndex = hasFamily ? index : index - 1;
                            final product = productsToBuy[productIndex];

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
                );
              },
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
