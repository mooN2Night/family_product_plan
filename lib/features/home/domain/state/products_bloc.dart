import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/product_entity.dart';
import '../repository/i_home_repository.dart';

part 'products_event.dart';

part 'products_state.dart';

/// Блок управлением состоянием главного экрана
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({required IHomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const ProductsState(isLoading: true)) {
    on<ProductsWatchEvent>(_watchProducts);
    on<_UpdateProductsInternalEvent>((event, emit) {
      emit(ProductsState(products: event.products));
    });

    on<ProductToggleEvent>((event, emit) async {
      final updatedProduct = event.product.copyWith(
        isToBuy: !event.product.isToBuy,
      );
      await _homeRepository.toggleProductStatus(updatedProduct);
    });

    on<ProductAddEvent>((event, emit) async {
      await _homeRepository.addProduct(event.product);
    });

    on<ProductGetEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final product = await _homeRepository.getProduct(event.id);

      emit(ProductsState(products: [product]));
    });

    on<ProductDeleteEvent>((event, emit) async {
      await _homeRepository.deleteProduct(event.id);
    });
  }

  /// Репозиторий для запросов
  final IHomeRepository _homeRepository;

  /// Подписка на поток изменений списка продуктов.
  StreamSubscription? _subscription;

  /// Запускает наблюдение за изменениями списка продуктов.
  Future<void> _watchProducts(
    ProductsWatchEvent event,
    Emitter<ProductsState> emit,
  ) async {
    await _subscription?.cancel();

    _subscription = _homeRepository.watchProducts().listen(
      (products) => add(_UpdateProductsInternalEvent(products)),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

/// Внутреннее событие для обновления списка из стрима
class _UpdateProductsInternalEvent extends ProductsEvent {
  const _UpdateProductsInternalEvent(this.products);

  final List<ProductEntity> products;

  @override
  List<Object?> get props => [products];
}
