import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/product_entity.dart';
import '../../repository/i_home_repository.dart';

part 'products_event.dart';

part 'products_state.dart';

/// Блок управлением состоянием главного экрана
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({required IHomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const ProductsInitialState()) {
    on<ProductsWatchEvent>(_watchProducts);
    on<_ProductsUpdatedEvent>(_onProductsUpdated);
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
    emit(const ProductsLoadingState());

    await _subscription?.cancel();

    _subscription = _homeRepository.watchProducts().listen(
      (products) {
        add(_ProductsUpdatedEvent(products));
      },
      onError: (error) {
        emit(ProductsErrorState(error.toString()));
      },
    );
  }

  /// Метод для эмита успешного состояния.
  void _onProductsUpdated(
    _ProductsUpdatedEvent event,
    Emitter<ProductsState> emit,
  ) => emit(ProductsSuccessState(products: event.products));

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

/// Внутреннее событие для обновления списка из стрима
class _ProductsUpdatedEvent extends ProductsEvent {
  const _ProductsUpdatedEvent(this.products);

  /// Список продуктов.
  final List<ProductEntity> products;

  @override
  List<Object?> get props => [products];
}
