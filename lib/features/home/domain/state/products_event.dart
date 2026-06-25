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

/// Класс события изменения продукта.
class ProductToggleEvent extends ProductsEvent {
  const ProductToggleEvent({required this.product});

  /// Продукт.
  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}

/// Класс события добавления продукта.
class ProductAddEvent extends ProductsEvent {
  const ProductAddEvent({required this.product});

  /// Прордукт.
  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}

/// Класс события получения продукта.
class ProductGetEvent extends ProductsEvent {
  const ProductGetEvent({required this.id});

  /// Уникальный идентификатор.
  final int id;

  @override
  List<Object?> get props => [id];
}

/// Класс события удаления продукта
class ProductDeleteEvent extends ProductsEvent {
  const ProductDeleteEvent({required this.id});

  /// Уникальный идентификатор.
  final int id;

  @override
  List<Object?> get props => [id];
}
