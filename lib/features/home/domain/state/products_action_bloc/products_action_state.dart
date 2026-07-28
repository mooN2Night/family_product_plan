part of 'products_action_bloc.dart';

/// Базовый класс состояния для покупок.
sealed class ProductsActionState extends Equatable {
  const ProductsActionState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние.
final class ProductsActionInitialState extends ProductsActionState {
  const ProductsActionInitialState();
}

/// Состояние загрузки.
final class ProductsActionLoadingState extends ProductsActionState {
  const ProductsActionLoadingState();
}

/// Состояние успешного действия.
final class ProductsActionSuccessState extends ProductsActionState {
  const ProductsActionSuccessState();
}

/// Состояние успешного получения продукта.
final class ProductsLoadedState extends ProductsActionState {
  const ProductsLoadedState({required this.product});

  /// Покупка.
  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}

/// Состояние ошибки.
final class ProductsActionErrorState extends ProductsActionState {
  const ProductsActionErrorState({required this.message});

  /// Текст ошибки
  final String message;

  @override
  List<Object?> get props => [message];
}
