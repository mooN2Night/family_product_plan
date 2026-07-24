import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_context_ext.dart';
import '../../../../app/ui_kit/app_bar.dart';
import '../../../../app/ui_kit/app_box.dart';
import '../../domain/state/products_bloc/products_bloc.dart';

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
          ProductsBloc(homeRepository: homeRepository)
            ..add(ProductGetEvent(id: id)),
      child: const _ProductDetailView(),
    );
  }
}

/// Класс для отображения содержимого экрана детальной информации о продукте.
class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.products.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Не нашли такого продукта')),
          );
        }

        final products = state.products.first;
        return Scaffold(
          appBar: CustomAppBar.productDetail(
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.blue),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
            title: products.productName,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const HBox(16),
                Row(
                  children: [
                    const Text('Статус:'),
                    const WBox(5),
                    Text(
                      products.isToBuy ? 'Нужно купить' : 'Есть дома',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                if (products.productManufacturer.isNotEmpty) ...[
                  const HBox(8),
                  Row(
                    children: [
                      const Text('Производитель:'),
                      const WBox(5),
                      Text(
                        products.productManufacturer,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
