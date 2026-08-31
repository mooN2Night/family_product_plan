part of 'products_action_bloc.dart';

/// Класс базового события.
sealed class ProductsActionEvent extends Equatable {
  const ProductsActionEvent();

  @override
  List<Object?> get props => [];
}

/// Класс события добавления продукта.
final class ProductActionAddEvent extends ProductsActionEvent {
  const ProductActionAddEvent({required this.product});

  /// Продукт.
  final ProductCreateEntity product;

  @override
  List<Object?> get props => [product];
}

/// Класс события удаления продукта
final class ProductActionDeleteEvent extends ProductsActionEvent {
  const ProductActionDeleteEvent({required this.id});

  /// Уникальный идентификатор.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Класс события изменения продукта.
final class ProductActionToggleEvent extends ProductsActionEvent {
  const ProductActionToggleEvent({required this.product});

  /// Продукт.
  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}

/// Класс события получения продукта.
final class ProductActionGetEvent extends ProductsActionEvent {
  const ProductActionGetEvent({required this.id});

  /// Уникальный идентификатор.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Класс события обновления продукта.
final class ProductActionUpdateEvent extends ProductsActionEvent {
  const ProductActionUpdateEvent({required this.product});

  /// Продукт.
  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}
