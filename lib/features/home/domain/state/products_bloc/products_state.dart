part of 'products_bloc.dart';

/// Базовый класс состояния для покупок.
sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class ProductsInitialState extends ProductsState {
  const ProductsInitialState();
}

/// Состояние загрузки.
final class ProductsLoadingState extends ProductsState {
  const ProductsLoadingState();
}

/// Состояние успешной загрузки.
final class ProductsSuccessState extends ProductsState {
  const ProductsSuccessState({required this.products});

  /// Список покупок.
  final List<ProductEntity> products;

  @override
  List<Object?> get props => [products];
}

/// Состояние ошибки.
final class ProductsErrorState extends ProductsState {
  const ProductsErrorState(this.message);

  /// Текст ошибки
  final String message;

  @override
  List<Object?> get props => [message];
}
