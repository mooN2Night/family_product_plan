import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:family_product_plan/app/error/app_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/product_create_entity.dart';
import '../../entity/product_entity.dart';
import '../../repository/i_home_repository.dart';

part 'products_action_event.dart';

part 'products_action_state.dart';

/// Блок управлением состоянием действий с продуктом
class ProductsActionBloc
    extends Bloc<ProductsActionEvent, ProductsActionState> {
  ProductsActionBloc({required IHomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(const ProductsActionInitialState()) {
    on<ProductActionAddEvent>(_onAdd);
    on<ProductActionDeleteEvent>(_onDelete);
    on<ProductActionToggleEvent>(_onToggle);
    on<ProductActionGetEvent>(_onGet);
  }

  /// Репозиторий для запросов
  final IHomeRepository _homeRepository;

  /// Добавление продукта
  Future<void> _onAdd(
    ProductActionAddEvent event,
    Emitter<ProductsActionState> emit,
  ) async {
    if (state is ProductsActionLoadingState) return;
    emit(const ProductsActionLoadingState());

    try {
      await _homeRepository.addProduct(event.product);

      emit(const ProductsActionSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(ProductsActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  /// Удаление продукта
  Future<void> _onDelete(
    ProductActionDeleteEvent event,
    Emitter<ProductsActionState> emit,
  ) async {
    if (state is ProductsActionLoadingState) return;
    emit(const ProductsActionLoadingState());

    try {
      await _homeRepository.deleteProduct(event.id);

      emit(const ProductsActionSuccessState());
    } on AppException catch (error, stackTrace) {
      emit(ProductsActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  /// Изменение флага к покупке у продукта
  Future<void> _onToggle(
    ProductActionToggleEvent event,
    Emitter<ProductsActionState> emit,
  ) async {
    if (state is ProductsActionLoadingState) return;
    emit(const ProductsActionLoadingState());

    try {
      await _homeRepository.toggleProductStatus(event.product);
    } on AppException catch (error, stackTrace) {
      emit(ProductsActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }

  /// Получение продукта
  Future<void> _onGet(
    ProductActionGetEvent event,
    Emitter<ProductsActionState> emit,
  ) async {
    if (state is ProductsActionLoadingState) return;
    emit(const ProductsActionLoadingState());

    try {
      final product = await _homeRepository.getProduct(event.id);

      emit(ProductsLoadedState(product: product));
    } on AppException catch (error, stackTrace) {
      emit(ProductsActionErrorState(message: error.message));
      addError(error, stackTrace);
    }
  }
}
