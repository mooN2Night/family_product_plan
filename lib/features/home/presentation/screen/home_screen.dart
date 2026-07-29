import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/ui_kit/app_snack_bar.dart';
import 'package:family_product_plan/features/home/presentation/components/home_products_list_view.dart';
import 'package:family_product_plan/features/sync_status/domain/state/sync_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dialog/product_add_dialog.dart';
import '../../../../app/services/pending_sync/sync_status.dart';
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
    final pendingSyncService = context.di.business.pendingSyncService;

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
        BlocProvider(
          create: (context) =>
              SyncCubit(pendingSyncService: pendingSyncService),
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
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: SyncStatusIndicator(),
            ),
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

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncCubit, SyncStatus>(
      builder: (context, state) {
        switch (state.state) {
          case SyncState.idle:
            if (state.pendingOperations == 0) {
              return const Icon(Icons.cloud_done_outlined, color: Colors.green);
            }

            return Badge.count(
              count: state.pendingOperations,
              child: const Icon(Icons.cloud_upload_outlined),
            );

          case SyncState.syncing:
            return const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            );

          case SyncState.success:
            return const Icon(Icons.cloud_done, color: Colors.green);

          case SyncState.error:
            return Badge.count(
              count: state.pendingOperations,
              child: const Icon(Icons.cloud_off_outlined, color: Colors.red),
            );
        }
      },
    );
  }
}
