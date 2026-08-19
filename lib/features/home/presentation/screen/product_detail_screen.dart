import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_context_ext.dart';
import '../../../../app/presentation/dialog/poduct_delete_dialog.dart';
import '../../../../app/presentation/ui_kit/app_bar.dart';
import '../../../../app/presentation/ui_kit/app_skeleton.dart';
import '../../domain/state/products_action_bloc/products_action_bloc.dart';
import '../components/home_product_success_view.dart';

/// Класс для отображения экрана детальной информации о продукте.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.id, super.key});

  /// Уникальный идентификатор.
  final String id;

  @override
  Widget build(BuildContext context) {
    final homeRepository = context.di.repositories.homeRepository;

    return BlocProvider(
      create: (context) =>
          ProductsActionBloc(homeRepository: homeRepository)
            ..add(ProductActionGetEvent(id: id)),
      child: const _ProductDetailView(),
    );
  }
}

/// Класс для отображения содержимого экрана детальной информации о продукте.
class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsActionBloc, ProductsActionState>(
      builder: (context, state) {
        switch (state) {
          case ProductsActionLoadingState():
            return Scaffold(
              appBar: CustomAppBar.secondary(title: 'Информация о продукте'),
              body: _ProductDetailLoadingView(),
            );

          case ProductsActionErrorState():
            return Scaffold(
              appBar: CustomAppBar.secondary(title: 'Информация о продукте'),
              body: Center(child: Text(state.message)),
            );

          case ProductsLoadedState():
            final product = state.product;

            return Scaffold(
              appBar: CustomAppBar.secondary(
                title: 'Информация о продукте',
                actions: [
                  IconButton(
                    onPressed: () {
                      // TODO: перейти на экран редактирования
                    },
                    icon: const Icon(Icons.edit_rounded, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => showDeleteProductDialog(
                      context,
                      productName: product.productName,
                      onDeletePressed: () => context
                          .read<ProductsActionBloc>()
                          .add(ProductActionDeleteEvent(id: product.id)),
                    ),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              body: HomeProductSuccessView(product: state.product),
            );

          case ProductsActionSuccessState():
          case ProductsActionInitialState():
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _ProductDetailLoadingView extends StatelessWidget {
  const _ProductDetailLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppSkeleton(width: 56, height: 56, borderRadius: 18),
                  const WBox(16),
                  Expanded(child: AppSkeleton(height: 28, borderRadius: 10)),
                ],
              ),
              const HBox(20),
              const AppSkeleton(width: 140, height: 36, borderRadius: 12),
              const HBox(18),
              const AppSkeleton(width: 220, height: 42, borderRadius: 10),
              const HBox(12),
              const AppSkeleton(width: 250, height: 42, borderRadius: 10),
            ],
          ),
        ),
        const HBox(20),
        const AppSkeleton(
          width: double.infinity,
          height: 120,
          borderRadius: 20,
        ),
        const HBox(28),
        const AppSkeleton(width: double.infinity, height: 16, borderRadius: 8),
        const HBox(8),
        const AppSkeleton(width: double.infinity, height: 16, borderRadius: 8),
      ],
    );
  }
}
