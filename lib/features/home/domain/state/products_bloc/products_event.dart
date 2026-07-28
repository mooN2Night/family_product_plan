part of 'products_bloc.dart';

/// Класс базового события.
sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

/// Класс события старта прослушивания списка покупок.
final class ProductsWatchEvent extends ProductsEvent {
  const ProductsWatchEvent();
}
