import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_context_ext.dart';
import '../../../../app/ui_kit/app_bar.dart';
import '../../../../app/ui_kit/app_box.dart';
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
                          product.isToBuy ? 'Нужно купить' : 'Есть дома',
                          style: const TextStyle(fontSize: 18),
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
                              style: const TextStyle(fontSize: 18),
                            ),
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
        // if (state.isLoading) {
        //   return const Scaffold(
        //     body: Center(child: CircularProgressIndicator()),
        //   );
        // }
        //
        // if (state.products.isEmpty) {
        //   return const Scaffold(
        //     body: Center(child: Text('Не нашли такого продукта')),
        //   );
        // }
        //
        // final products = state.products.first;
        // return Scaffold(
        //   appBar: CustomAppBar.productDetail(
        //     actions: [
        //       IconButton(
        //         onPressed: () {},
        //         icon: const Icon(Icons.edit, color: Colors.blue),
        //       ),
        //       IconButton(
        //         onPressed: () {},
        //         icon: const Icon(Icons.delete, color: Colors.red),
        //       ),
        //     ],
        //     title: products.productName,
        //   ),
        //   body: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //     child: Column(
        //       children: [
        //         const HBox(16),
        //         Row(
        //           children: [
        //             const Text('Статус:'),
        //             const WBox(5),
        //             Text(
        //               products.isToBuy ? 'Нужно купить' : 'Есть дома',
        //               style: const TextStyle(fontSize: 18),
        //             ),
        //           ],
        //         ),
        //         if (products.productManufacturer.isNotEmpty) ...[
        //           const HBox(8),
        //           Row(
        //             children: [
        //               const Text('Производитель:'),
        //               const WBox(5),
        //               Text(
        //                 products.productManufacturer,
        //                 style: const TextStyle(fontSize: 18),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}
