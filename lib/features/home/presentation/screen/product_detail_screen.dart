import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_context_ext.dart';
import '../../../../app/ui_kit/app_bar.dart';
import '../../../../app/ui_kit/app_box.dart';
import '../../../../app/utils/app_utils.dart';
import '../../domain/state/products_action_bloc/products_action_bloc.dart';

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
    final fontStyle = const TextStyle(fontSize: 18);
    return BlocBuilder<ProductsActionBloc, ProductsActionState>(
      builder: (context, state) {
        final bloc = context.read<ProductsActionBloc>();

        switch (state) {
          case ProductsActionInitialState():
          case ProductsActionLoadingState():
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case ProductsActionErrorState():
            return Scaffold(
              appBar: CustomAppBar.productDetail(actions: [], title: 'asd'),
              body: Center(child: Text(state.message)),
            );

          case ProductsLoadedState():
            final product = state.product;
            final formatedCreatedAt = AppUtils.formateDate(product.createdAt);
            final formatedUpdatedAt = AppUtils.formateDate(product.updatedAt);

            return Scaffold(
              appBar: CustomAppBar.productDetail(
                title: product.productName,
                actions: [
                  IconButton(
                    onPressed: () {
                      // TODO: перейти на экран редактирования
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () =>
                        bloc.add(ProductActionDeleteEvent(id: product.id)),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HBox(16),
                    Row(
                      children: [
                        const Text('Статус:'),
                        const WBox(5),
                        Text(
                          product.isToBuy
                              ? 'Нужно купить'
                              : 'Покупать не нужно',
                          style: fontStyle,
                        ),
                      ],
                    ),
                    const HBox(8),
                    Row(
                      children: [
                        const Text('Товар:'),
                        const WBox(5),
                        Expanded(
                          child: Text(product.productName, style: fontStyle),
                        ),
                      ],
                    ),

                    if (product.productManufacturer.isNotEmpty) ...[
                      const HBox(8),
                      Row(
                        children: [
                          const Text('Производитель:'),
                          const WBox(5),
                          Expanded(
                            child: Text(
                              product.productManufacturer,
                              style: fontStyle,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (formatedCreatedAt != null) ...[
                      const HBox(8),
                      Row(
                        children: [
                          const Text('Дата создания:'),
                          const WBox(5),
                          Expanded(
                            child: Text(formatedCreatedAt, style: fontStyle),
                          ),
                        ],
                      ),
                    ],

                    if (formatedUpdatedAt != null) ...[
                      const HBox(8),
                      Row(
                        children: [
                          const Text('Дата обновления:'),
                          const WBox(5),
                          Expanded(
                            child: Text(formatedUpdatedAt, style: fontStyle),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );

          case ProductsActionSuccessState():
            return const SizedBox.shrink();
        }
      },
    );
  }
}
