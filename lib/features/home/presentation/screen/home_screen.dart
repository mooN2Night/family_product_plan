import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:family_product_plan/features/home/presentation/components/home_products_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dialog/product_add_dialog.dart';
import '../../../../app/ui_kit/app_bar.dart';
import '../../../current_family/domain/state/current_family_cubit.dart';
import '../../domain/entity/product_entity.dart';
import '../../domain/state/products_action_bloc/products_action_bloc.dart';
import '../../domain/state/products_bloc/products_bloc.dart';

/// Класс для отображения главного экрана
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeRepository = context.di.repositories.homeRepository;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProductsBloc(homeRepository: homeRepository)
                ..add(const ProductsWatchEvent()),
        ),
        BlocProvider(
          create: (context) =>
              ProductsActionBloc(homeRepository: homeRepository),
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
        body: BlocListener<ProductsActionBloc, ProductsActionState>(
          listener: (context, actionState) {
            if (actionState is ProductsActionErrorState) {
              AppSnackBar.showError(context, message: actionState.message);
            }
          },
          child: BlocBuilder<ProductsBloc, ProductsState>(
            builder: (context, state) {
              switch (state) {
                case ProductsLoadingState():
                  return const Center(child: CircularProgressIndicator());
                case ProductsErrorState():
                  return Center(child: Text(state.message));
                case ProductsSuccessState():
                  final products = state.products;
                  final productsToBuy = state.products
                      .where((product) => product.isToBuy)
                      .toList();

                  return BlocBuilder<CurrentFamilyCubit, CurrentFamilyState>(
                    builder: (context, familyState) {
                      switch (familyState) {
                        case CurrentFamilyLoadingState():
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case CurrentFamilyErrorState():
                          return const Center(
                            child: Text(
                              'Не удалось получить информацию о семье',
                            ),
                          );
                        case CurrentFamilyWithoutFamilyState():
                          return _HomeTabBarListView(
                            hasFamily: false,
                            products: products,
                            productsToBuy: productsToBuy,
                          );
                        case CurrentFamilyWithFamilyState():
                          return _HomeTabBarListView(
                            hasFamily: true,
                            products: products,
                            productsToBuy: productsToBuy,
                          );
                      }
                    },
                  );
                case _:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _HomeTabBarListView extends StatelessWidget {
  const _HomeTabBarListView({
    required this.hasFamily,
    required this.products,
    required this.productsToBuy,
  });

  final bool hasFamily;
  final List<ProductEntity> products;
  final List<ProductEntity> productsToBuy;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        HomeProductsListView(hasFamily: hasFamily, products: products),
        HomeProductsListView(hasFamily: hasFamily, products: productsToBuy),
      ],
    );
  }
}
